%zewdCompiler9	; Enterprise Web Developer Compiler : ajax fixed text
 ;
 ; Product: Enterprise Web Developer (Build 906)
 ; Build Date: Wed, 28 Mar 2012 12:52:00
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-12 M/Gateway Developments Ltd,                        |
 ; | Reigate, Surrey UK.                                                      |
 ; | All rights reserved.                                                     |
 ; |                                                                          |
 ; | http://www.mgateway.com                                                  |
 ; | Email: rtweed@mgateway.com                                               |
 ; |                                                                          |
 ; | This program is free software: you can redistribute it and/or modify     |
 ; | it under the terms of the GNU Affero General Public License as           |
 ; | published by the Free Software Foundation, either version 3 of the       |
 ; | License, or (at your option) any later version.                          |
 ; |                                                                          |
 ; | This program is distributed in the hope that it will be useful,          |
 ; | but WITHOUT ANY WARRANTY; without even the implied warranty of           |
 ; | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            |
 ; | GNU Affero General Public License for more details.                      |
 ; |                                                                          |
 ; | You should have received a copy of the GNU Affero General Public License |
 ; | along with this program.  If not, see <http://www.gnu.org/licenses/>.    |
 ; ----------------------------------------------------------------------------
 ;
ajaxLoader ;
	;;EWD.ajax = {
	;;   isWithinTarget: function (tagId,targetId,isDojo) {
	;;      var par ;
	;;      if (isDojo) {
	;;         par = dojo.byId(tagId) ;
	;;      }
	;;      else {
	;;         par = document.getElementById(tagId) ;
	;;      }
	;;      if (!par) return false;
	;;      do {
	;;        par = par.parentNode ;
	;;        if (par.id == targetId) {
	;;          return true ;
	;;        }
	;;      }
	;;      while (par.tagName != "BODY") ;
	;;      return false ;
	;;   },
	;;   destroyDJWidgetsWithin: function(id) {
	;;      if (typeof(dijit)!='undefined'){
	;;        var wid;
	;;        for (wid in EWDdojo.widget) {
	;;            //console.debug("testing " + wid) ;
	;;            if ((!dijit.byId(wid))&&(!EWD.utils.contains(wid,"-menu"))) {
	;;                delete EWDdojo.widget[wid];
	;;                //console.debug(wid + " not present, so removed from index") ;
	;;            }
	;;            if ((dijit.byId(wid))||(EWD.utils.contains(wid,"-menu"))) {
	;;               //console.debug("wid=" + wid + "; id=" + id) ;
	;;               if (EWD.ajax.isWithinTarget(wid,id,true)) {
	;;                  var wid1 = wid ;
	;;                  if (EWD.utils.contains(wid,"-menu")) wid1 = EWD.utils.getPiece(wid,"-menu",1) ;
	;;                  dijit.byId(wid1).destroyRecursive();
	;;                  delete EWDdojo.widget[wid];
	;;                  //console.debug("removed " + wid) ;
	;;               }
	;;            }
	;;        }
	;;      }
	;;   },
	;;   destroyChartsWithin: function(id) {
	;;      if (typeof(EJSC)!='undefined'){
	;;        var wid;
	;;        for (wid in EWD.page.chartIndex) {
	;;            var chartId = EWD.page.chartIndex[wid] ;
	;;            if (document.getElementById(wid)) {
	;;               if (EWD.ajax.isWithinTarget(wid,id,false)) {
	;;                  var str = chartId + ".remove();" ;
	;;                  eval(str) ;
	;;                  delete EWD.page.chartIndex[wid];
	;;               }
	;;            }
	;;        }
	;;      }
	;;   },
	;;   getPageFromLocalStorage: function(app,page,targetId,traceFlag) {
	;;      var text=localStorage.getItem("ewdPage/" + app + "/" + page);
	;;      if (text != null) {
	;;         EWD.ajax.injectFragment(text,targetId,traceFlag);
	;;         return true;
	;;      }
	;;      else {
	;;         return false;
	;;      }
	;;   },
	;;   putPageIntoLocalStorage: function(app,page,fragmentText) {
    ;;      localStorage.setItem("ewdPage/" + app + "/" + page,fragmentText);
    ;;   },
    ;;   deleteAppFromLocalStorage: function(app) {
	;;     if (typeof(localStorage) != 'undefined') {
	;;        var appName,key,keyNo;
	;;        keysToDelete = {};
	;;        var noOfKeys = localStorage.length;
	;;        for (keyNo=0;keyNo<noOfKeys;keyNo++) {
	;;          key = localStorage.key(keyNo);
	;;          alert(keyNo + ": " + key);
	;;          appName = EWD.utils.getPiece(key,"/",2);
	;;          if (appName == app) {
	;;             keysToDelete[key] = "";
	;;          }
	;;        }
	;;        for (key in keysToDelete) {
	;;           alert(key + " deletedx");
	;;           localStorage.removeItem(key);
	;;        }
	;;     }
	;;   },
    ;;   setLocalResource: function(obj) {
	;;      if (EWD.browser.isHTML5) {
	;;         if (localStorage.getItem('ewdApp/' + obj.app) != iWD.build) {
	;;            EWD.ajax.deleteAppFromLocalStorage(obj.app);
	;;            localStorage.setItem('ewdApp/' + obj.app,iWD.build);
	;;         }
	;;         delete EWD.ajax.localResource;
	;;         if (typeof(EWD.ajax.offlineMode) != 'undefined') {
	;;            if (EWD.ajax.offlineMode == 'always') {
	;;               EWD.ajax.localResource = obj;
	;;            }
	;;         }
	;;      }
	;;      else {
	;;         delete EWD.ajax.localResource;
	;;      }
	;;   },
	;;   makeRequest: function (zewdurl,zewdid,zewdmethod,zewdpayload,traceFlag) {
	;;      if (typeof(EWD.sencha) !== 'undefined') {
	;;        EWD.sencha.restartSessionTimer = true;
	;;      }
	;;      EWD.ajax.targetId = zewdid ;
	;;      EWD.ajax.destroyChartsWithin(zewdid) ;
	;;      if (typeof(EWD.ajax.localResource) != 'undefined') {
	;;         var ok = EWD.ajax.getPageFromLocalStorage(EWD.ajax.localResource.app,EWD.ajax.localResource.page,zewdid,traceFlag);
	;;         if (ok) {
	;;           delete EWD.ajax.localResource;
	;;           return;
	;;         }
	;;      }
	;;      if ( zewdurl.length > 255 ) {
	;;        var urlP = zewdurl.split('?') ;
	;;        zewdurl = urlP[0] ;
	;;        zewdpayload = '' ;
	;;        for (var i=1; i < urlP.length; i++) {
 	;;          if (zewdpayload != '') zewdpayload += '?' ;
	;;          zewdpayload += urlP[i]; 
	;;        }
	;;        if (zewdmethod == '' || zewdmethod == 'get') {
	;;          zewdmethod = 'post' ;
	;;        }
	;;        else {
	;;          zewdmethod = 'synchPOST' ;
	;;        }
	;;      }
	;;      var noOfParams = EWD.ajax.makeRequest.arguments.length ;
	;;      var noOfFixedParams = 5 ;
	;;      if (noOfParams > noOfFixedParams) {
	;;         for (var nParam = noOfFixedParams; nParam < noOfParams; nParam++) {
	;;            zewdurl = zewdurl.replace(/\[x]/, escape(EWD.ajax.makeRequest.arguments[nParam])) ;
	;;         }
	;;      }
	;;      //force unique URL to prevent IE using Cached URL
	;;      var rn = (Math.round(Math.random()*999999999)+1) ;
	;;      if (zewdurl.indexOf('?') == -1) {
	;;          zewdurl = zewdurl + "?" ;
	;;      }
	;;      else {
	;;          zewdurl = zewdurl + "&" ;
	;;      }
	;;      zewdurl = zewdurl + "ewdrn=" + rn ;
	;;      if (EWD.ajax.base) {
	;;         zewdurl = EWD.ajax.base + zewdurl ;
	;;      }
	;;      var http_request = false;
	;;      if (window.XMLHttpRequest) { // Mozilla, Safari,...
  	;;         http_request = new XMLHttpRequest();
	;;         if (http_request.overrideMimeType) {
	;;            //http_request.overrideMimeType('text/xml');
	;;         }
	;;      } 
	;;      else if (window.ActiveXObject) { // IE
	;;         try {
	;;            http_request = new ActiveXObject("Msxml2.XMLHTTP");
	;;         } 
	;;         catch (e) {
	;;            try {
	;;               http_request = new ActiveXObject("Microsoft.XMLHTTP");
	;;            } 
	;;            catch (e) {}
	;;         }
	;;      }
	;;      if (!http_request) {
	;;         alert('Ajax error : Your browser may not support the XMLHTTP Request Object needed to support Ajax');
	;;         setTimeout("document.body.style.cursor = 'default'",1);
	;;         return false;
	;;      }
	;;      while (zewdurl.indexOf('&amp;') != -1) {
	;;         zewdurl = zewdurl.replace("&amp;","&") ;
	;;      }
	;;      if (zewdmethod == "synchPOST") {
	;;         http_request.open('POST', zewdurl, false);
	;;         http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	;;         http_request.send(zewdpayload);
	;;         var zewdTraceFlag = traceFlag ;
	;;         EWD.ajax.replaceContent(http_request,zewdid,zewdTraceFlag,zewdurl,zewdmethod,zewdpayload);
	;;      }
	;;      else if (zewdmethod == "synch") {
	;;         http_request.open('GET', zewdurl, false);
	;;         http_request.send(null);
	;;         var zewdTraceFlag = traceFlag ;
	;;         EWD.ajax.replaceContent(http_request,zewdid,zewdTraceFlag,zewdurl,zewdmethod,zewdpayload);
	;;      }
	;;      else {
	;;         EWD.ajax.httpStatus = "" ;
	;;         EWD.ajax.asynchSend(http_request,zewdid,traceFlag,zewdurl,zewdmethod,zewdpayload) ;
	;;         setTimeout("document.body.style.cursor = 'default'",1);
	;;      }
	;;   },
	;;   asynchSend: function (http_request,id,traceFlag,url,method,payload) {
	;;         http_request.onreadystatechange = function() { EWD.ajax.replaceContent(http_request,id,traceFlag,url,method,payload); };
	;;         if (method != "post") {
	;;            http_request.open('GET', url, true);
	;;            http_request.send(null);
	;;         }
	;;         else {
	;;            http_request.open('POST', url, true);
	;;            http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	;;            http_request.send(payload);
	;;         }
	;;   },
	;;   replaceContent: function (http_request,zewdid,traceFlag,zewdurl,zewdmethod,zewdpayload) {
	;;      if (http_request.readyState == 4) {
	;;         if (http_request.status == 200) {
	;;            var text = http_request.responseText ;
	;;            if (traceFlag == 'window') {
	;;               document.getElementById("traceContent").value = text ;
	;;               document.getElementById("traceWindow").style.display = "block" ;
	;;            }
	;;            if (text.indexOf('<b>CSP Error') != -1) {
	;;               var i = text.indexOf('<ul>');   
	;;               text = text.substring(i+4) ;
	;;               i = text.indexOf("</ul>");
	;;               text = text.substring(0,i);
	;;               text = "CSP runtime error : " + text ;
	;;               EWD.ajax.alert(text) ;
	;;            }
	;;            if (text.indexOf('id="ewdEBResponse">') != -1) {
	;;               var i = text.indexOf('id="ewdEBResponse">');
	;;               text = text.substring(i+19) ;
	;;               i = text.indexOf("</div>");
	;;               text = text.substring(0,i);
	;;               eval(text) ; 
	;;            }
	;;            else if (text.indexOf('<title>Enterprise Web Developer : A run-time error has occurred') != -1) {
	;;               var i = text.indexOf('<h3>Enterprise Web Developer Error');   
	;;               text = text.substring(i+28) ;
	;;               i = text.indexOf("</h3>");
	;;               text = text.substring(0,i);
	;;               text = "EWD runtime error : " + text ;
	;;               EWD.ajax.alert(text) ;
	;;            }
	;;            else if (text.indexOf('The Server reported the following error:') != -1) {
	;;               var i = text.indexOf('</FONT></B><P>');   
	;;               text = text.substring(i+14) ;
	;;               text = "EWD runtime error : " + text ;
	;;               EWD.ajax.alert(text) ;
	;;            }
	;;            else {
	;;               var i = text.indexOf('id="ewdajaxonload">');
	;;               if (i != -1) {
	;;                  text = text.substring(i+19) ;
	;;                  i = text.indexOf("</span>");
	;;                  text = text.substring(0,i);
	;;               }
	;;               else {
	;;                  text = '' ;
	;;               }
	;;               if ((text != '')&&(text.indexOf("var ewdtext = ''") == -1)) {
	;;                  eval(text) ;
	;;                  if (typeof(iWD) != 'undefined') {
	;;                    iWD.resetSubmit();
	;;                  }      
	;;               }              
	;;		         else {
    ;;                  EWD.ajax.injectFragment(http_request.responseText,zewdid,traceFlag);
	;;                  if (typeof(EWD.ajax.localResource) != 'undefined') {
	;;                    EWD.ajax.putPageIntoLocalStorage(EWD.ajax.localResource.app,EWD.ajax.localResource.page,http_request.responseText);
	;;                    delete EWD.ajax.localResource;
	;;                  }
	;;               }	
	;;            }
	;;         } 
	;;         else {
	;;            var ajaxError = 'There was a problem reported in the Ajax response (status code: ' + http_request.status + ' ' + http_request.statusText + ')' ;
	;;            EWD.ajax.httpStatus=parseInt(http_request.status) ;
	;;            if ((ajaxError != '')&&(EWD.ajax.httpStatus < 12000)) alert(ajaxError);
	;;            if (EWD.ajax.httpStatus >12000) {
	;;                EWD.ajax.asynchSend(http_request,zewdid,traceFlag,zewdurl,zewdmethod,zewdpayload) ;
	;;            }
	;;         }
	;;      }
	;;   },
	;;   injectFragment: function(fragmentText,targetId,traceFlag) {
	;;       var text = fragmentText;
    ;;       while (text.indexOf('<zewd target=') != -1) {
	;;         var i = text.indexOf('<zewd target=');
	;;         text = text.substring(i+13);
	;;         i = text.indexOf('>');
	;;         var target = text.substring(1,i-1);
	;;         text = text.substring(i+1);
	;;         i = text.indexOf('</zewd>');
	;;         var sub = text.substring(0,i);
	;;         text = text.substring(i+7);
	;;         if (typeof(iWD) != 'undefined') {
	;;           if (!document.getElementById(target)) {
	;;             var pageid = EWD.utils.getPiece(target,"-",1);
	;;             iWD.createNewPage(pageid);
	;;             //targetId = pageid;
	;;           }
	;;         }
	;;         EWD.ajax.destroyDJWidgetsWithin(target) ;
	;;         document.getElementById(target).innerHTML = sub ;
	;;       }
	;;       EWD.ajax.destroyDJWidgetsWithin(targetId) ;
	;;       document.getElementById(targetId).innerHTML = text ;
	;;       if (typeof(iWD) != 'undefined') {
	;;         if (typeof(localStorage) != 'undefined') {
	;;           if (iWD.pageStorage=='local') {
	;;             localStorage.setItem("zewd-lastContent-" + targetId,text);
	;;           }
	;;         }
	;;         if (typeof(iWD.target) != 'undefined') {
	;;           jQT.goTo(iWD.target.panelId,iWD.target.transition,iWD.target.reverse) ;
	;;           iWD.currentFragmentName=iWD.target.panelId;
	;;           delete iWD.target;
	;;         }
	;;         iWD.resetSubmit() ;
    ;;         document.getElementById("loading").className = 'loadingOff';
    ;;       }
	;;       var jsID = "ewdButtonJS" ;
	;;       var newJSPointer = document.getElementById(jsID) ;
	;;       EWD.ajax.activateJS(newJSPointer) ;
	;;       var newJSPointer = document.getElementById('ewdscript') ;
	;;       setTimeout("document.body.style.cursor = 'default'",1) ;
	;;       if (traceFlag) {
	;;         if (traceFlag == 'alert') {
	;;           alert(fragmentText) ;
	;;         }
    ;;       }
	;;       var jsText = "" ;
	;;       if (document.getElementById("ewdajaxonload")) {
	;;         var onloadPointer = document.getElementById("ewdajaxonload") ;
	;;         var tnode = onloadPointer.firstChild ;
	;;         while (tnode) {
	;;           jsText = jsText + tnode.data ;
	;;           tnode = tnode.nextSibling ;
	;;         }
	;;         var par = onloadPointer.parentNode;
	;;         par.removeChild(onloadPointer) ;
	;;       }
	;;       EWD.ajax.activateJS(newJSPointer) ;
    ;;       eval(jsText) ;
    ;;       /* Custom extension hook */
    ;;       if (typeof EWD.ajax.onAfterInject !== 'undefined') EWD.ajax.onAfterInject();
	;;   },
	;;   activateAjaxError: function (errorText) {
	;;      if (errorText != "") {
	;;         var errorPointer = document.getElementById('ajaxErrorText') ;
	;;         errorPointer.firstChild.data = errorText ;
	;;         var alertPointer = document.getElementById("ajaxAlert") ;
	;;         if (alertPointer != null) {
	;;            var par = alertPointer.parentNode ;
	;;            par.removeChild(alertPointer) ;
	;;         }
	;;         var head = document.getElementsByTagName("head").item(0) ;
	;;         alertPointer = document.createElement("script") ;
	;;         alertPointer.id = "ajaxAlert" ;
	;;         alertPointer.type = "text/javascript" ;
	;;         head.appendChild(alertPointer) ;
	;;         alertPointer.text = "EWD.ajax.errorOn() ;" ;
	;;      }  
	;;   },
	;;   activateJS: function (newJSPointer) {
	;;      if (newJSPointer != null) {
	;;         var newJSCode = "" ;
	;;         if (newJSPointer != null) newJSCode = newJSPointer.firstChild.data ;
	;;         if (newJSCode != "") {
	;;            var node = newJSPointer.firstChild ;
	;;            var jsText = "" ;
	;;            while (node) {
	;;               jsText = jsText + node.data
	;;               node = node.nextSibling ;
	;;            }
	;;            var par = newJSPointer.parentNode ;
	;;            par.removeChild(newJSPointer) ;
	;;            if (window.execScript) {
	;;               window.execScript(jsText) ;
	;;            }
	;;            else {
	;;               window.eval(jsText) ;
	;;            }
	;;         }
	;;      }
	;;   },
	;;   alert: function(message) {
	;;     if (typeof(Ext) != 'undefined') {
	;;       if (typeof(Ext.Msg) != 'undefined') {
	;;         Ext.Msg.alert('Error',message, Ext.emptyFn);
	;;       }
	;;       else {
	;;         alert(message);
	;;       }
	;;       return;
	;;     }
	;;     if (typeof(iWD) != 'undefined') {
	;;       iWD.alert(message);
	;;     }
	;;     else {
	;;       alert(message);
	;;     }
	;;   },
	;;   errorOn: function () {
	;;      document.getElementById('ewdAjaxError').className='ewdDispOn' ;
	;;   },
	;;   errorOff: function () {
	;;      document.getElementById('ewdAjaxError').className='ewdDispOff' 
	;;   },
	;;   allowSubmit: true,
	;;   confirmSubmit: function (confirmText) {
	;;      if (confirmText == "") confirmText = "Click OK if OK to continue" ;
	;;      EWD.ajax.allowSubmit=EWD.page.displayConfirm(confirmText) ;
	;;   },
	;;   getFragment: function(url,targetId,synch) {
	;;      var method = "synch" ;
	;;      if (!synch) method = "GET"
	;;      EWD.ajax.makeRequest(url,targetId,method) ;
	;;   },
	;;   fetchPage: {},
	;;   getPage: function(params) {
	;;      var page = params.page;
	;;      if (typeof EWD.ajax.fetchPage[page.toLowerCase()] != 'undefined') {
	;;        EWD.ajax.fetchPage[page.toLowerCase()](params);
	;;      }
	;;      else {
	;;        alert("Error: fragment " + page + " does not exist");
	;;      }
	;;   },
	;;   getURL: function(params) {
	;;      var url = params.url;
	;;      var nvp = params.nvp;
	;;      var targetId = params.targetId;
	;;      var synch = params.synch;
	;;      if (synch) {
	;;        method="synch";
	;;      }
	;;      else {
	;;        var method = params.method;
	;;      }
	;;      if (nvp) {
	;;        if (nvp !== '') url = url + '&' + nvp;
	;;      }
	;;      if (!targetId) targetId = 'ewdNullId';
	;;      if (targetId === '') targetId='ewdNullId';
	;;      EWD.ajax.getFragment(url,targetId,method);
	;;   },
	;;   submit: function (buttonName,formPointer,nextPage,url,id,traceFlag,synch) {
	;;      if (EWD.ajax.allowSubmit != false) {
	;;         var nFields = formPointer.elements.length ;
	;;         var payload = "ewdAjaxSubmit=1&ewd_action=" + buttonName + "&ewd_pressed=" + buttonName + "&ewd_nextPage=" + nextPage ;
	;;         //var payload = "ewdAjaxSubmit=1&ewd_nextPage=" + nextPage ;
	;;         for (var nField = 0; nField < nFields; nField++) {
	;;            var fieldPointer = formPointer.elements[nField] ;
	;;            var name = fieldPointer.name ;
	;;            if (name != "") {
	;;            var type = fieldPointer.type ;
	;;            var escValue = escape(fieldPointer.value) ;
	;;            escValue = escValue.replace(/\+/g, "%2B") ;
	;;            if ((type == "text")||(type == "password")|(type == "number")|(type == "tel")) {
	;;               payload = payload + "&" + name + "=" + escValue ;
	;;            }
	;;            if (type == "hidden") {
	;;               if (EWD.utils.getPiece(name,"_",1) != "ewd") {
	;;                  payload = payload + "&" + name + "=" + escValue ;
	;;               }
	;;            }
	;;            if (type == "select-one") {
	;;               payload = payload + "&" + name + "=" + escValue ;
	;;            }
	;;            if (type == "select-multiple") {
	;;               returnValue = "" ;
	;;               for (i = 0 ; i < fieldPointer.length ; i++) {
	;;                 if (fieldPointer.options[i].selected) {
	;;                   escValue = escape(fieldPointer.options[i].value) ;
	;;                   escValue = escValue.replace(/\+/g, "%2B") ;
	;;                   payload = payload + "&" + name + "=" + escValue ;
	;;                 }
	;;               }
	;;            }
	;;            if (type == "textarea") {
	;;               payload = payload + "&" + name + "=" + escValue ;
	;;            }
	;;            if (type == "radio") {
	;;               if (fieldPointer.checked) {
	;;                  payload = payload + "&" + name + "=" + escValue ;
	;;               }
	;;            }
	;;            if (type == "checkbox") {
	;;               if (fieldPointer.length == undefined) {
	;;                  if (fieldPointer.checked) {
	;;                     payload = payload + "&" + name + "=" + escValue ;
	;;                  }                
	;;               } 
	;;               else {
	;;                  for (var i = 0 ; i < fieldPointer.length ; i++) {
	;;                     if (fieldPointer[i].checked) {
	;;                        var escValue = escape(fieldPointer[i].value) ;
	;;                        escValue = escValue.replace(/\+/g, "%2B") ;
	;;                        payload = payload + "&" + name + "=" + escValue ;
	;;                     }
	;;                  }
	;;               }
	;;            }
	;;            }
	;;         }
	;;         if (synch) {
	;;            EWD.ajax.makeRequest(url,id,"synchPOST",payload,traceFlag) ;
	;;         }
	;;         else {
	;;            EWD.ajax.makeRequest(url,id,"post",payload,traceFlag) ;
	;;         }
	;;      }
	;;      EWD.ajax.allowSubmit = true ;
	;;   },
	;;   loadXML: function(url, fn) {
    ;;     var http_request = false;
	;;     var replaceContent = function(http_request) {
    ;;       if (http_request.readyState == 4) {
    ;;         if (http_request.status == 200) {
    ;;           var xmlDoc = http_request.responseXML ;
    ;;           fn(xmlDoc);
    ;;         }
    ;;       }
    ;;     }
    ;;     if (window.XMLHttpRequest) { // Mozilla, Safari,...
    ;;       http_request = new XMLHttpRequest();
    ;;     } 
    ;;     else if (window.ActiveXObject) { // IE
    ;;       try {
    ;;         http_request = new ActiveXObject("Msxml2.XMLHTTP");
    ;;       } 
    ;;       catch (e) {
    ;;         try {
    ;;           http_request = new ActiveXObject("Microsoft.XMLHTTP");
    ;;         } 
    ;;         catch (e) {}
    ;;       }
    ;;     }
    ;;     http_request.onreadystatechange = function() {
    ;;       replaceContent(http_request);
    ;;     };
    ;;     http_request.open('GET', url, true);
    ;;     http_request.send(null);
    ;;   }
	;;};
	;;EWD.sockets = {
	;;  sendMessage: function(params) {
	;;    if (typeof params.message === 'undefined') params.message = '';
	;;    params.token = EWD.sockets.token;
	;;    if (typeof console !== 'undefined') console.log("sendMessage: " + JSON.stringify(params));
	;;    this.socket.json.send(JSON.stringify(params));
	;;  },
	;;  getPage: function(params) {
	;;    if (typeof params.nvp === 'undefined') params.nvp = '';
	;;    this.sendMessage({type: "ewdGetFragment", page: params.page, targetId: params.targetId, nvp: params.nvp});
	;;  },
	;;  connect: function(messageFunction, port, token) {
	;;    //this.socket = io.connect(null, {port: port, rememberTransport: false});
	;;    this.socket = io.connect();
	;;    this.socket.on('connect', function() {
	;;      if (typeof EWD.sockets.token !== 'undefined') {
    ;;        console.log('WebSocket connected');
    ;;        EWD.sockets.sendMessage({type: 'register', token: EWD.sockets.token});
    ;;      }
	;;    });
	;;    this.socket.on('message', function(obj){
	;;      if (typeof console !== 'undefined') console.log("onMessage: " + JSON.stringify(obj));
	;;      if (typeof obj === 'string') {
	;;        var pieces = obj.split(':');
	;;        var type = pieces.shift();
	;;        if (type === 'ewdGetFragment') {
	;;          var targetId = pieces.shift();
	;;          var content = pieces.join(':');
	;;          var pos = content.search("  <");
	;;          EWD.ajax.injectFragment(content.substr(pos),targetId);
	;;        }
	;;        return;
	;;      }
	;;      if (obj.type === 'json') {
	;;        obj.json = JSON.parse(obj.message);
	;;        delete obj.message;
	;;      }
	;;      messageFunction(obj);
	;;    });
	;;    this.token = token;
	;;    //this.sendMessage({type: "register", token: token});
	;;  } 
	;;};
	;;***END***
	;
jsErrorClass ;
 ;;  EWD.page.setErrorClass = function () { 
 ;;*csp*                        if ('#($$getSessionValue^%zewdAPI("ewd_hasErrors",sessid))#' == '1') {
 ;;*php*                        if ('<?= (isset($ewd_session["ewd_hasErrors"])) ? $ewd_session["ewd_hasErrors"] : "" ?>' == '1') {
 ;;*jsp*                        if ('<%= getSessionValue("ewd_hasErrors", ewd_Session, m_jsp) %>' == '1') {
 ;;*gtm*                        if ('#($$getSessionValue^%zewdAPI("ewd_hasErrors",sessid))#' == '1') {
 ;;*vb.net*                     if ('<%= getSessionValue("ewd_hasErrors", ewd_Session, m_aspx) %>' == '1') {
 ;;                               ewd:setErrorClasses^%zewdAPI() ;
 ;;                             }
 ;;                           } ;
 ;;  EWD.utils.putObjectToSession = function (objName) { 
 ;;                           var json,x ;
 ;;                           if (typeof(dojo) != "undefined") {
 ;;                             x = "json = dojo.toJson(" + objName + ")" ;
 ;;                             eval(x) ;
 ;;                           }
 ;;                           else {
 ;;                             //x = "json=" + objName + ".toJSONString()" ;
 ;;                             //eval(x) ;
 ;;                             x = "json=toJsonString(" + objName + ");" ;
 ;;                             eval(x) ;
 ;;                             //json=toJsonString(objName);
 ;;                           }
 ;;                           ewd:saveJSON^%zewdAPI(objName,json) ;
 ;;                         } ;
 ;;  EWD.utils.getObjectFromSession = function (objName, refresh, addRefCol) { 
 ;;                          if (refresh) {
 ;;                             eval("delete(" + objName + ") ;") ;
 ;;                             var objExists = "undefined" ;
 ;;                          }
 ;;                          else {
 ;;                             var x = "var objExists = typeof(" + objName + ");" ;
 ;;                             eval(x) ;
 ;;                          }
 ;;                          if (objExists == "undefined") {
 ;;                            var addRef = 0 ;
 ;;                            if (addRefCol) addRef = 1;
 ;;                            ewd:getJSON^%zewdCompiler13(objName,addRef) ;
 ;;                          };
 ;;                        } ;
 ;;  EWD.utils.mergeObjectFromSession = function (sessionName,JSObjName) { 
 ;;                            ewd:mergeToJSObject^%zewdAPI(sessionName,JSObjName) ;
 ;;                        } ;
 ;;***END***
 ;;  EWD.utils.putObjectToGlobal = function (objName) { 
 ;;                           //var x = "var json=" + objName + ".toJSONString()" ;
 ;;                           //eval(x) ;
 ;;                           //var json=objName.toJSONString() ;
 ;;                           var json=toJsonString(objName);
 ;;                           ewd:saveJSON^%zewdAPI(objName,json) ;
 ;;                         } ;
 ;;  EWD.utils.getObjectFromGlobal = function (objName) {
 ;;                          var x = "var objExists = typeof(" + objName + ");" ;
 ;;                          eval(x) ;
 ;;                          if (objExists == "undefined") {
 ;;                            ewd:objectGlobalToJSON^%zewdCompiler13(objName) ;
 ;;                          };
 ;;                        } ;
 ;;***END***
 ;;
JSON2 ;
 ;;/*
 ;;The following alternative to Douglas Crockford's toJSONString() method
 ;;was written by Theodor Zoulias (http://trimpath.com/forum/viewtopic.php?pid=945)
 ;;*/
 ;;//var toJsonString;
 ;;(function () {
 ;;  toJsonString = function(o) {
 ;;   var UNDEFINED;
 ;;   switch (typeof o) {
 ;;     case 'string': return '\'' + encodeJS(o) + '\'';
 ;;     case 'number': return String(o);
 ;;     case 'object': 
 ;;        if (o) {
 ;;          var a = [];
 ;;          if (o.constructor == Array) {
 ;;            for (var i = 0; i < o.length; i++) {
 ;;              var json = toJsonString(o[i]);
 ;;              if (json != UNDEFINED) a[a.length] = json;
 ;;            }
 ;;            return '[' + a.join(',') + ']';
 ;;          } 
 ;;          else if (o.constructor == Date) {
 ;;            return 'new Date(' + o.getTime() + ')';
 ;;          } 
 ;;          else {
 ;;            for (var p in o) {
 ;;              var json = toJsonString(o[p]);
 ;;              if (json != UNDEFINED) a[a.length] = (/^[A-Za-z_]\w*$/.test(p) ? (p + ':') : ('\'' + encodeJS(p) + '\':')) + json;
 ;;            }
 ;;            return '{' + a.join(',') + '}';
 ;;          }
 ;;        }
 ;;        return 'null';
 ;;     case 'boolean'  : return String(o);
 ;;     case 'function' : return;
 ;;     case 'undefined': return 'null';
 ;;   }
 ;;  }
 ;;  function encodeJS(s) {
 ;;   return (!/[\x00-\x19\'\\]/.test(s)) ? s : s.replace(/([\\'])/g, '\\$1').replace(/\r/g, '\\r').replace(/\n/g, '\\n').replace(/\t/g, '\\t').replace(/[\x00-\x19]/g, '');
 ;;  }
 ;;})()
 ;;***END***
 ;
ajaxErrorClasses ;
	;;.dispOff {
	;;    background : #ffffff ;
	;;    border-style: outset ;
	;;    border-width: 2px ;
	;;    left:400px; 
	;;    width: 300px;
	;;    height:150px;
	;;    position:absolute; 
	;;    top:100px; 
	;;    z-index:1;
	;;    visibility : hidden ;
	;;}
	;;.dispOn {
	;;    background : #efffff ;
	;;    border-style: outset ;
	;;    border-width: 3px ;
	;;    text-align : center ;
	;;    left:400px; 
	;;    width: 300px;
	;;    height:150px;
	;;    position:absolute; 
	;;    top:160px; 
	;;    visibility: on; 
	;;    z-index:1000;
	;;}	
ajaxTraceWindow ;
 ;;<html>
 ;;<head><title>Ajax Trace Page</title>
 ;;</head>
 ;;<body>
 ;;<form>
 ;;<textarea id="traceText" rows="50" cols="100">*
 ;;</textarea>
 ;;</form>
 ;;</body>
 ;;</html>
 ;;***END***
