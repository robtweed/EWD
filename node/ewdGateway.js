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


 *  The parameters below should be configured as required
 *    poolSize = the number of concurrent Cache connections to use to support web access
 *    httpPort = the TCP port on which Node.js is listening for web connections
 *    webServerRootPath = the path where Node.js will find standard resource files such as JS, CSS, jpeg  etc files
 *    ewdPath = the URL path used to indicate an EWD page (note: it must be wrapped in / characters)
 *    logHTTP = true if you want M/Wire to be used to log all incoming HTTP requests, in which case also define:
 * 
 *       mwirePort = the TCP port on which the M/Wire service is listening (for logging HTTP requests)
 *       mwireHost = the IP Address of the M/Wire service
 *       daysToLog = the number of days of HTTP logs to retain
 *
 *   trace = true if you want to get a detailed activity trace to the Node.js console
 *   silentStart = true if you don't want any message to the console when the gateway starts

 ************************************************************
*/

var poolSize = 5;
var httpPort = 8081;
var webServerRootPath = "/var/www";
var ewdPath = "/ewd/";
var logHTTP = false;
var mwirePort = 6330;
var mwireHost = '127.0.0.1';
var daysToLog = 5;
var trace = true;
var silentStart = false;

/*
 ************************************************************
*/



var http = require("http");
var url = require("url");
var queryString = require("querystring");
if (logHTTP) {
   var mwireLib = require("node-mwire");
   var mwire = new mwireLib.Client({port:mwirePort, host:mwireHost});
}
var path = require("path"); 
var fs = require("fs");
var spawn = require('child_process').spawn;

if (logHTTP) mwire.setHttpLogDays(daysToLog);

var contentType;
var cachey = {};
var i;

for (i=0;i<poolSize;i++) {
  cachey[i] = spawn('csession', ['cache', '-U', 'user', 'nodeListener^%zewdWLD2']);
  cachey[i].response = {};
}

var getConnection = function() {
  // randomly select a connection from available pool
  return Math.floor(Math.random()*poolSize);
};

http.createServer(function(request, response) {

  request.content = '';

  request.on("data", function(chunk) {
       request.content += chunk;
  });

  request.on("end", function(){
    var urlObj = url.parse(request.url, true); 
    var uri = urlObj.pathname;
    if (uri === '/favicon.ico') {
       display404(response);
       return;
    }
    if (logHTTP) mwire.httpLog(request);
    if (trace) console.log(uri);
    if (uri.indexOf(ewdPath) !== -1) {
       sendToCachey(request,response,urlObj, request.content);
    }
    else {
       var fileName = webServerRootPath + uri;
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


  var sendToCachey = function(request,response,urlObj, content) {
    var headers = {
       headers: request.headers,
       server_protocol: 'HTTP/' + request.httpVersion,
       remote_Addr: request.connection.remoteAddress,
       script_name: urlObj.pathname
    };
   var headersString = escape(JSON.stringify(headers));
   var contentEsc = escape(content);
   var query = escape(JSON.stringify(urlObj.query));
   if (trace) console.log("sending query: " + query);
   var connection = getConnection();
   if (trace) console.log("using connection " + connection);
   cachey[connection].response = response;
   cachey[connection].stdin.write(query + "\r\n" + headersString + "\r\n" + request.method + "\r\n" + contentEsc + "\r\n");
 };

}).listen(httpPort);

var display404 = function(response) {
   response.writeHead(404, {"Content-Type" : "text/plain" });  
   response.write("404 Not Found \n");  
   response.end();  
};

var cacheyOutput = function(connection) {

   var headerSent = false;
   var headers = {};
   var httpStatus;
   var no;

   cachey[connection].stdout.on('data', function (data) {
    var dataStr = data.toString();
    if (trace) {
       console.log("from Cache:" + dataStr + "\r\n=================\r\n");
       var dump = 'dump: ';
       for (i=0;i<100;i++) dump = dump + ":" + dataStr.charCodeAt(i);
       console.log(dump + "\r\n=================\r\n");
    }

    if (!headerSent) {

       if ((dataStr.substr(0,2) === '\n<')||(dataStr.substr(0,1) === '<')) {
          headerSent = true;
          httpStatus = 200;
          headers["Content-type"] = "text/html";
          dataStr = "\n\n" + dataStr;
       }

       if (dataStr.indexOf("HTTP/") !== -1) {
          var pieces = dataStr.split(" ");
          httpStatus = pieces[1];
       }


       if ((dataStr.substr(0,1) === "\n")&&(dataStr.substr(1,1) !== "\n")) {
          dataStr = "\n" + dataStr;
       }
       else {
          pieces = dataStr.split("\n");
          for (no = 1;no < pieces.length;no++) {
             var header = pieces[no];
             var nvps = header.split(": ");
             var name = nvps[0];
             if (name == '') {
               no = 999999999;
             }
             else {
                var value = nvps[1];
                if (trace) console.log("header name=" + name + "; value=" + value);
                headers[name] = value;
             }
          }
       }

       if (dataStr.indexOf("\n\n") !== -1) {
          pieces = dataStr.split("\n\n");
          pieces.splice(0,1)
          dataStr = pieces.join(" ");
          cachey[connection].response.writeHead(httpStatus, headers);
          headerSent = true;
       }
       else {
          return;
       }    }

    if (dataStr.indexOf("\x11\x12\x13\x14") !== -1) {
       var text = dataStr.split("\x11\x12\x13\x14");
       cachey[connection].response.write(text[0]);
       cachey[connection].response.end();
       headerSent = false;
       headers = {};
    }
    else {
       cachey[connection].response.write(dataStr);  
    }
   });

};

for (i=0;i<poolSize;i++) {
  cacheyOutput(i);
}

if (!silentStart) {
  console.log("EWD Gateway has started successfully on port " + httpPort);
  if (trace) {
    console.log("Trace mode is on");
  }
  else {
    console.log("Trace mode is off");
  }
}



