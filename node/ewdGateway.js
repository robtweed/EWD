/*

 ----------------------------------------------------------------------------
 | Node.js based Cache gateway for EWD                                      |
 |                                                                          |
 | Copyright (c) 2011 M/Gateway Developments Ltd,                           |
 | Reigate, Surrey UK.                                                      |
 | All rights reserved.                                                     |
 |                                                                          |
 | http://www.mgateway.com                                                  |
 | Email: rtweed@mgateway.com                                               |
 |                                                                          |
 | This program is free software: you can redistribute it and/or modify     |
 | it under the terms of the GNU Affero General Public License as           |
 | published by the Free Software Foundation, either version 3 of the       |
 | License, or (at your option) any later version.                          |
 |                                                                          |
 | This program is distributed in the hope that it will be useful,          |
 | but WITHOUT ANY WARRANTY; without even the implied warranty of           |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            |
 | GNU Affero General Public License for more details.                      |
 |                                                                          |
 | You should have received a copy of the GNU Affero General Public License |
 | along with this program.  If not, see <http://www.gnu.org/licenses/>.    |
 ----------------------------------------------------------------------------

  Get required modules:

*/

var http = require("http");
var url = require("url");
var queryString = require("querystring");
var mwireLib = require("node-mwire");
var path = require("path"); 
var fs = require("fs");
var spawn = require('child_process').spawn;
var events = require("events"); 

/*
 ************************************************************
 * Now set up EWD Gateway parameters and logic
 *
 *  The parameters below should be configured as required
 *    poolSize = the number of concurrent Cache connections to use to support web access
 *    httpPort = the TCP port on which Node.js is listening for web connections
 *    webServerRootPath = the path where Node.js will find standard resource files such as JS, CSS, jpeg  etc files
 *    ewdPath = the URL path used to indicate an EWD page (note: it must be wrapped in / characters)
 *    logHTTP = true if you want M/Wire to be used to log all incoming HTTP requests
 *
 *    M/Wire is also used for supporting execution of any Javascript pre-page Scripts
 * 
 *       mwirePort = the TCP port on which the M/Wire service is listening (for logging HTTP requests)
 *       mwireHost = the IP Address of the M/Wire service
 *       mwirePoolSize = the number of Cache processes to use for M/Wire connections
 *
 *       if HTTP logging enabled:
 *
 *       daysToLog = the number of days of HTTP logs to retain
 *
 *   trace = true if you want to get a detailed activity trace to the Node.js console
 *   silentStart = true if you don't want any message to the console when the gateway starts

 ************************************************************
*/

var ewdGateway = {

  buildNo: 12,
  buildDate: "21 April 2010",

  ewdPath: "/ewd/",
  daysToLog: 5,
  httpPort: 8082,
  logHTTP: false,
  mwireHost: '127.0.0.1',
  mwirePoolSize: 5,
  mwirePort: 6331,
  poolSize: 5,
  trace: true,
  webServerRootPath: "/var/www",

  namespace: 'user',
  nodeListenerRoutine: 'nodeListener^%zewdWLD2',

  addToQueue: function(query, headersString, contentEsc, request, response) {
    var queuedRequest = {
      query:query,
      headersString: headersString,
      contentEsc: contentEsc,
      request:request,
      response:response
    };
    this.requestQueue.push(queuedRequest);
    this.totalRequests++;
    var qLength = this.requestQueue.length;
    if (qLength > this.maxQueueLength) this.maxQueueLength = qLength;
    if (this.trace) console.log("added to Queue: " + queuedRequest.query + "; queue length = " + qLength + "; requestNo = " + this.totalRequests + "; after " + this.elapsedTime() + " sec");
    // trigger the processing of the queue
    this.queueEvent.emit("addedToQueue");
  },

  cachey: {},

  cacheyOutput:function(connection) {
    var dataStr;
    var headers = {};
    var headerStr = '';
    var bodyStr = '';
    var contentStr = '';
    var pieces;
    var refreshStr;
    var headerPieces;
    var httpStatus = '';
    var no;
    var i;
    var preBlockResponse = false;
    var returnObj;

    this.cachey[connection].stdout.on('data', function (data) {
      dataStr = data.toString();
      if (ewdGateway.trace) {
        //console.log("from Cache on connection " + connection + ":" + "\r\n" + dataStr + "\r\n=================\r\n");
        //var dump = 'dump: ';
        //for (i=0;i<dataStr.length;i++) dump = dump + ":" + dataStr.charCodeAt(i);
        //console.log(dump + "\r\n=================\r\n");
      }

      contentStr = contentStr + dataStr;

      if (contentStr.indexOf("\x11\x12\x13\x14\n") !== -1) {

        //entire payload received - now send it to browser
        // first separate the head and body and extract the headers

        pieces = contentStr.split("\x11\x12\x13\x14\n");
        contentStr = pieces[0];
        refreshStr = pieces[1];
        pieces = contentStr.split("\n\n");
        headerStr = pieces[0];
        pieces.splice(0,1)
        bodyStr = pieces.join("\n\n");
        pieces = headerStr.split(" ");
        httpStatus = pieces[1];
        preBlockResponse = false;
        headerPieces = headerStr.split("\n");
        for (no = 1;no < headerPieces.length;no++) {
          var header = headerPieces[no];
          var nvps = header.split(": ");
          var name = nvps[0];
          if (name == '') {
            no = 999999999;
          }
          else {
            var value = nvps[1];
            if (name === 'EWD-pre') {
              preBlockResponse = true;
            }
            else {
              if (ewdGateway.trace) console.log("header name=" + name + "; value=" + value);
              headers[name] = value;
            }
          }
        }

        // If this isn't a pre-block, send it all to the browser

        if (!preBlockResponse) {
          if (!headers["Content-type"]) headers["Content-type"] = "text/html";
          if (httpStatus === '') httpStatus = 200;
          ewdGateway.cachey[connection].response.writeHead(httpStatus, headers);
          ewdGateway.cachey[connection].response.write(bodyStr);
          ewdGateway.cachey[connection].response.end();
          //if (ewdGateway.trace) console.log("header and body sent to browser");
          // reset buffers
          headers = {};
          contentStr = '';
          if (ewdGateway.trace) console.log("Connection " + connection + " reset and waiting..");
          ewdGateway.cachey[connection].isAvailable = true;
          // fire event to process queue in case anything in there
          ewdGateway.queueEvent.emit("addedToQueue");
        }
        else {

          // this is a pre-block response - run the Javascript 
          // pre-page script and then invoke the body section
          // first determine which original response this relates to
          
          var textArr = bodyStr.split("<endofpre ");
          if (ewdGateway.trace) console.log('<endofpre> response found: ' + textArr[1]);
          var respArr = textArr[1].split(' ');
          var reqNoArr = respArr[0].split('=');
          var sessArr = respArr[1].split('=');
          if (ewdGateway.trace) console.log('pre response relates to request ' + reqNoArr[1]);
           
          // look up against:
          //  ewdGateway.ewdMap.request[requestNo] = {app:app,page:page,query:query,headersString:headersString,
          //                            request:request,response:response};
          
          var req = ewdGateway.ewdMap.request[reqNoArr[1]];
          delete ewdGateway.ewdMap.request[reqNoArr[1]];
           
          // now run JS pre-page script
  
          if (ewdGateway.trace) console.log("Running Javascript pre-page method: " + ewdGateway.ewdMap.method[req.app][req.page]);

          ewdGateway.ewdMap.module[req.app][ewdGateway.ewdMap.method[req.app][req.page]](sessArr[1], function(error, results) {
            if (ewdGateway.trace) console.log("Pre-page script returned: " + JSON.stringify(results));
            // add list of response headers to add to body response
            // Javascript pre-page script can override any of the standard ones
            //  header["name"] = value;
            
            req.headers["response-headers"] = headers;
          
            // flag to just run body()
            req.headers["ewd_page_block"] = "body";
            req.headers["ewd_sessid"] = sessArr[1];
            console.log("sessid = " + sessArr[1]);
            if (results.error !== '') req.headers["ewd_error"] = results.error;
            var headersString = escape(JSON.stringify(req.headers));
            headers = {};
            contentStr = '';
            ewdGateway.cachey[connection].isAvailable = true;
            ewdGateway.sendRequestToCachey(req.query, headersString, req.contentEsc, req.request, req.response);
          });
        }
        if (refreshStr.indexOf('refresh=true')!== -1) {
          ewdGateway.mwire.clientPool[ewdGateway.mwire.connection()].getJSON('zewd',['nodeModules','methods'],function(error,results) {
            if (!error) {
              ewdGateway.ewdMap.method = results;
              if (ewdGateway.trace) console.log("refreshed module/method table")
            }
          });
        }
      }
    });
  },

  connectionUpdate: false,

  display404: function(response) {
    response.writeHead(404, {"Content-Type" : "text/plain" });  
    response.write("404 Not Found \n");  
    response.end();  
  },

  elapsedTime: function() {
    var now = new Date().getTime();
    //console.log("now = " + now + "; StartTime = " + this.startTime);
    return (now - this.startTime)/1000;
  },

  ewdMap: {
    method: {},
    module: {},
    request: {},
    obj: {}
  },

  getConnection: function() {
    var i;
    // try to find a free connection, otherwise return false
    //console.log("in getConnection");
    for (i=0;i<this.poolSize;i++) {
      if (this.cachey[i].isAvailable) {
        //console.log("connection " + i + " available");
        this.cachey[i].isAvailable = false;
        return i;
      }
    }
    //console.log("no connections available");
    return false;
  },

  makeConnections: function() {
    for (var i = 0;i < this.poolSize;i++) {
      this.cachey[i] = spawn('csession', ['cache', '-U', this.namespace, this.nodeListenerRoutine]);
      this.cachey[i].response = {};
      this.cachey[i].isAvailable = true;
      this.requestsByConnection[i] = 0;
    }
  },
  
  maxQueueLength: 0,
  processingQueue: false,

  processQueue: function() {
    if (!ewdGateway.processingQueue) {
      if (ewdGateway.requestQueue.length === 0) return; 
      ewdGateway.processingQueue = true;
      ewdGateway.queueEvents++;
      console.log("processing queue: " + ewdGateway.queueEvents + "; queue length " + ewdGateway.requestQueue.length + "; after " + ewdGateway.elapsedTime() + " seconds");
      var queuedRequest;
      var okToProcess = true;
      while (okToProcess) {
        queuedRequest = ewdGateway.requestQueue.shift();
        //console.log("processing queued request");
        okToProcess = ewdGateway.sendRequestToCachey(queuedRequest);
        //console.log("okToProcess = " + okToProcess);
        if (!okToProcess) ewdGateway.requestQueue.unshift(queuedRequest);
        if (ewdGateway.requestQueue.length === 0) okToProcess = false;
      }
      if (ewdGateway.requestQueue.length > 0) {
        console.log("queue processing abandoned as no free proceses available");
      }
      ewdGateway.processingQueue = false;
    }
  },

  queueEvents: 0,
  requestsByConnection: {},
  requestNo: 0,
  requestQueue: [],

  sendRequestToCachey: function(queuedRequest) {
    var connection = this.getConnection();
    if (connection !== false) {
      if (this.trace) console.log("Request sent to Cache using connection = " + connection);
      this.requestsByConnection[connection]++;
      this.connectionUpdate = true;
      this.cachey[connection].response = queuedRequest.response;
      this.cachey[connection].stdin.write(queuedRequest.query + "\r\n" + queuedRequest.headersString + "\r\n" + queuedRequest.request.method + "\r\n" + queuedRequest.contentEsc + "\r\n");
      return true;
    }
    else {
      return false;
    }
  },

  sendToCachey: function(request,response,urlObj, content) {
    var error;
    var headers = {
       headers: request.headers,
       server_protocol: 'HTTP/' + request.httpVersion,
       remote_Addr: request.connection.remoteAddress,
       script_name: urlObj.pathname
    };
    var contentEsc = escape(content);
    var query = escape(JSON.stringify(urlObj.query));
    //if (this.trace) console.log("sending query: " + query);
    //if (this.trace) console.log("pathname: " + urlObj.pathname);
    var pathParts = urlObj.pathname.split("/");
    var noOfParts = pathParts.length;
    var page = pathParts[noOfParts - 1];
    var pageParts = page.split(".");
    page = pageParts[0].toLowerCase();
    var app = pathParts[noOfParts - 2].toLowerCase();
    var headersString = escape(JSON.stringify(headers));
     
    if (this.trace) console.log("incoming request for app: " + app + "; page: " + page);
    
    // Does this app have a Javascript pre-page script?

    if (this.ewdMap.method[app]) {
     
      // load the module for this app
      if (!this.ewdMap.module[app]) {
        this.ewdMap.module[app] = require('./node-' + app);
      }
       
      // does this page have a pre-page script?
      if (this.ewdMap.method[app][page]) {
        if (this.ewdMap.method[app][page] !== '') {
           // flag to just run pre() part
           this.requestNo++;
           headers["ewd_page_block"] = "pre";
           headers["ewd_requestNo"] = this.requestNo;
           headersString = escape(JSON.stringify(headers));
           this.ewdMap.request[requestNo] = {app:app,page:page,query:query,headers:headers,contentEsc:contentEsc,request:request,response:response};
           this.addToQueue(query, headersString, contentEsc, request, response);
        }
        else {
          // this page doesn't have a Javascript pre-page script: run this page as standard
          this.addToQueue(query, headersString, contentEsc, request, response);
        }
      }
      else {
        // this page doesn't have a Javascript pre-page script: run this page as standard
        this.addToQueue(query, headersString, contentEsc, request, response);
      }
    }
    else {
      // if not then run as standard page
      this.addToQueue(query, headersString, contentEsc, request, response);
    }
  },

  silentStart: false,
  startTime: new Date().getTime(),
  totalRequests: 0
};

ewdGateway.mwire = new mwireLib.Client({
    port:ewdGateway.mwirePort, 
    host:ewdGateway.mwireHost, 
    poolSize:ewdGateway.mwirePoolSize
});

if (process.argv[2]) ewdGateway.httpPort = process.argv[2];
if (process.argv[3]) ewdGateway.poolSize = process.argv[3];



ewdGateway.queueEvent = new events.EventEmitter();

if (ewdGateway.logHTTP) ewdGateway.mwire.setHttpLogDays(daysToLog);

ewdGateway.makeConnections();


ewdGateway.queueEvent.on("addedToQueue", ewdGateway.processQueue);


setInterval(function() {
  //console.log("Checking queue just in case..");
  ewdGateway.queueEvent.emit("addedToQueue")
  // report connection stats if they've changed
  var i;
  if (ewdGateway.trace) {
    if (ewdGateway.connectionUpdate) {
      console.log("Connection utilitisation:");
      for (i=0;i<ewdGateway.poolSize;i++) {
        console.log(i + ": " + ewdGateway.requestsByConnection[i]);
      }
      console.log("Max queue length: " + ewdGateway.maxQueueLength);
      ewdGateway.connectionUpdate = false;
      ewdGateway.maxQueueLength = 0;
    }
  }
},30000);

// Fetch details of Node.js modules needed by EWD applications

ewdGateway.mwire.clientPool[ewdGateway.mwire.connection()].getJSON('zewd',['nodeModules','methods'],function(error,results) {
  if (!error) {
    ewdGateway.ewdMap.method = results;
    if (ewdGateway.trace) console.log("Pre-page modules: " + JSON.stringify(ewdGateway.ewdMap));
  }
});

// Main web-server module

http.createServer(function(request, response) {

  request.content = '';

  request.on("data", function(chunk) {
       request.content += chunk;
  });

  request.on("end", function(){
    var contentType;
    var urlObj = url.parse(request.url, true); 
    var uri = urlObj.pathname;
    if (uri === '/favicon.ico') {
       ewdGateway.display404(response);
       return;
    }
    if (ewdGateway.logHTTP) ewdGateway.mwire.httpLog(request);
    if (ewdGateway.trace) console.log(uri);
    if (uri.indexOf(ewdGateway.ewdPath) !== -1) {
       //console.log("add request to queue");
       ewdGateway.sendToCachey(request,response,urlObj, request.content);
    }
    else {
       var fileName = ewdGateway.webServerRootPath + uri;
       path.exists(fileName, function(exists) {  
         if(!exists) {  
            response.writeHead(404, {"Content-Type": "text/plain"});  
            response.write("404 Not Found\n");  
            response.end();  
            return;  
         }  
         fs.readFile(fileName, "binary", function(err, file) {  
            if(err) {  
                response.writeHead(500, {"Content-Type": "text/plain"});  
                response.write(err + "\n");  
                response.end();  
                return;  
            }
            contentType = "text/plain";
            if (fileName.indexOf(".js") !== -1) contentType = "application/javascript";
            if (fileName.indexOf(".css") !== -1) contentType = "text/css";
            if (fileName.indexOf(".jpg") !== -1) contentType = "image/jpeg";
            response.writeHead(200, {"Content-Type": contentType});  
            response.write(file, "binary");  
            response.end();  
         });  
       }); 
    }

  });


}).listen(ewdGateway.httpPort);

// set up event handlers for each Cache child process in the pool

for (var i=0;i<ewdGateway.poolSize;i++) {
  ewdGateway.cacheyOutput(i);
}

// EWD Session Methods  - Uses global variable ewd to allow its use in modules loaded later!

ewd = {
  setSessionValue: function(sessionName, value, sessid, callback) {
    ewdGateway.mwire.clientPool[ewdGateway.mwire.connection()].remoteFunction('setSessionValue^%zewdSTAPI', [sessionName, value, sessid], function(error, results) {
      callback(error, results);
    });
  },
  getSessionValue: function(sessionName, sessid, callback) {
    ewdGateway.mwire.clientPool[ewdGateway.mwire.connection()].remoteFunction('getSessionValue^%zewdAPI', [sessionName, sessid], function(error, results) {
      callback(error, results.value);
    });
  },
  getSessionArray: function(sessionName,sessid,callback) {
    ewdGateway.mwire.clientPool[ewdGateway.mwire.connection()].getJSON('%zewdSession', [sessid, sessionName], function(error, results) {
      callback(error, results.value);
    });
  },
  setSessionArray: function(json, sessionName,sessid,callback) {
    ewdGateway.mwire.clientPool[ewdGateway.mwire.connection()].setJSON('%zewdSession', ['session', sessid, sessionName], json, true, function(error, results) {
      callback(error, results.value);
    });
  }
};

if (!ewdGateway.silentStart) {
  console.log("********************************************");
  console.log("*** EWD Gateway Build " + ewdGateway.buildNo + " (" + ewdGateway.buildDate + ") ***");
  console.log("********************************************");
  console.log("Started successfully on port " + ewdGateway.httpPort);
  if (ewdGateway.trace) {
    console.log("Trace mode is on");
  }
  else {
    console.log("Trace mode is off");
  }
}
