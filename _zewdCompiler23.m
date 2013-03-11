%zewdCompiler23	; Enterprise Web Developer Compiler : HTML5 Offline First Page
 ;
 ; Product: Enterprise Web Developer (Build 960)
 ; Build Date: Mon, 11 Mar 2013 14:56:32
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
createLaunchPage(attrs,appName,technology)
 ;
 n crlf,filePath,i,io,line,manifestPage,manifestUrl,pageUrl
 ;
 s io=$io
 s crlf=$c(13,10)
 i $$os^%zewdHTMLParser()'="windows" s crlf=$c(10)
 s manifestPage=$g(attrs("manifestpage"))
 i manifestPage="" s manifestPage="manifest.ewd"
 s mgwlpn=$g(attrs("mgwlpn")) i mgwlpn="" s mgwlpn="LOCAL"
 s manifestUrl=$$expandPageToURL(manifestPage,appName,technology,mgwlpn)
 s pageUrl=$$expandPageToURL(attrs("contentpage"),appName,technology,mgwlpn)
 s filePath=$g(attrs("homepagepath"))
 i '$$openNewFile^%zewdAPI(filePath) QUIT 
 u filePath
 f i=1:1 s line=$t(html5+i^%zewdCompiler23) q:line["***END**"  d
 . s line=$p(line,";;",2,250)
 . i line["<appName>" s line=$$replaceAll^%zewdAPI(line,"<appName>",appName)
 . i line["<page>" s line=$$replaceAll^%zewdAPI(line,"<page>",$g(attrs("contentpage")))
 . i line["<appTitle>" s line=$$replaceAll^%zewdAPI(line,"<appTitle>",$g(attrs("title")))
 . i line["<manifestUrl>" s line=$$replaceAll^%zewdAPI(line,"<manifestUrl>",manifestUrl)
 . i line["pageUrl>" s line=$$replaceAll^%zewdAPI(line,"<pageUrl>",pageUrl)
 . i line["<offlineMode>" s line=$$replaceAll^%zewdAPI(line,"<offlineMode>",$g(attrs("offlinemode")))
 . w line_crlf
 c filePath
 u io
 QUIT
 ;
expandPageToURL(name,appName,technology,mgwlpn)
 ;
 n url
 i technology="wl" d
 . i $g(mgwlpn)="" s mgwlpn="LOCAL"
 . s url=$$getRootURL^%zewdCompiler("wl")_"?MGWLPN="_mgwlpn_"&MGWAPP=ewdwl&app="_appName_"&page="_$p(name,".ewd",1)
 QUIT url
 ;
schemaViewInstance(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:schemaViewInstance instanceName="myDOM" suppressNull="true" suppressInvisible="true" renderMethod="render^%zewdSchemaView" stylesheet="/myStyleSheet.css">
	; 
	;  Note: if renderMethod is left out, then the default EWD method (render^%zewdSchemaView) is used
	;
	n attr,docName,headOID,instanceName,renderMethod,styleSheet,suppressNull,suppressInvisible,xOID
	;
	set instanceName=$$getAttrValue^%zewdCompiler4("instancename",.attrValues,technology)
	set renderMethod=$$getAttrValue^%zewdCompiler4("rendermethod",.attrValues,technology)
	set suppressNull=$$getAttrValue^%zewdCompiler4("suppressNull",.attrValues,technology)
	set suppressInvisible=$$getAttrValue^%zewdCompiler4("suppressInvisible",.attrValues,technology)
	set styleSheet=$$getAttrValue^%zewdCompiler4("stylesheet",.attrValues,technology)
	i $e(instanceName,1)="""" s instanceName=$$removeQuotes^%zewdAPI(instanceName)
	i renderMethod="''" s renderMethod=""
	i styleSheet="''" s styleSheet=""
	i $e(renderMethod,1)="""" s renderMethod=$$removeQuotes^%zewdAPI(renderMethod)
	i $e(suppressNull,1)="""" s suppressNull=$$removeQuotes^%zewdAPI(suppressNull)
	i $e(styleSheet,1)="""" s styleSheet=$$removeQuotes^%zewdAPI(styleSheet)
	i suppressNull="" s suppressNull="false"
	i $e(suppressInvisible,1)="""" s suppressInvisible=$$removeQuotes^%zewdAPI(suppressInvisible)
	i suppressInvisible="" s suppressInvisible="false"
	i renderMethod="" s renderMethod="render^%zewdSchemaView"
	;
	; <ewd:execute method="render^%zewdSchemaView" type="procedure" param1="#ewd_sessid" param2="$instanceName" param3="0" param4="0">
	;
	s attr("method")=renderMethod
	s attr("type")="procedure"
	s attr("param1")="#ewd_sessid"
	s attr("param2")=instanceName
	s attr("param3")=suppressNull
	s attr("param4")=suppressInvisible
	s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",nodeOID,,.attr,"")
	;
 	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	; add run-time script to add <link rel="stylesheet" href="/mtivity.css" type="text/css"/>
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s headOID=$$getFirstElementByTagName^%zewdDOM("head",docName,"")
	s attr("method")="link^%zewdSchemaForm"
	s attr("type")="procedure"
	s attr("param1")="#ewd_sessid"
	s attr("param2")=""
	s attr("param3")=instanceName
	i styleSheet'="" s attr("param4")=styleSheet
	s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",headOID,,.attr,"")	
	;
	QUIT
	;
html5 ;
 ;;<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 ;;<html manifest='<manifestUrl>' xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
 ;;  <head>
 ;;    <meta charset="UTF-8" />
 ;;    <title><appTitle></title>
 ;;    <base href="" />
 ;;    <link rel="stylesheet" type="text/css" href="/ewd.css"> 
 ;;    <link rel="stylesheet" type="text/css" href="/iwd/css/iwd.css"> 
 ;;    <link rel="stylesheet" type="text/css" href="/iwd/jqt/themes/apple/theme.css"> 
 ;;    <link rel="stylesheet" type="text/css" href="/iwd/jqt/extensions/scrolling.css"> 
 ;;    <link rel="stylesheet" type="text/css" href="/iwd/iwebkit/css/developer-style.css"> 
 ;;    <link rel="stylesheet" type="text/css" href="/iwd/jqt/jqtouch/jqtouch.css"> 
 ;;    <link rel="stylesheet" type="text/css" href="/iwd/css/spinningwheel.css"> 
 ;;    <script src="/iwdScripts.js" type="text/javascript"></script>
 ;;    <script src="/iwd/jqt/jqtouch/jquery.1.3.2.min.js" type="text/javascript"></script>
 ;;    <script src="/iwd/jqt/jqtouch/jqtouch.min.js" type="text/javascript"></script>
 ;;    <script src="/iwd/jqt/extensions/jqt.scrolling.js" type="text/javascript"></script>
 ;;    <script src="/iwd/jqt/extensions/jqt.sliding.js" type="text/javascript"></script>
 ;;    <script src="/iwd/javascript/spinningwheel.js" type="text/javascript"></script>
 ;;
 ;;    <script language="javascript">
 ;;       var jQT = new $.jQTouch({
 ;;          fullscreen:true,
 ;;          icon: '/iwd/pics/homescreen.gif',
 ;;          addGlossToIcon: true,
 ;;          startupScreen: '/iwd/pics/iwdSplash.png',
 ;;          statusBar: 'default',
 ;;           popupSelector: '.pop',
 ;;           useFastTouch: true,
 ;;           slideSelector: '#jqt > * > ul li a, .slideRight',
 ;;           useAnimations: true
 ;;       });
 ;;       $(window).load(function() {
 ;;          $('#jqt').bind('touchmove', function(e){e.preventDefault()});
 ;;          $(document.body).trigger('orientationchange');
 ;;       });
 ;;       iWD.jqt=jQT;
 ;;       iWD.toolbarTitle='<appTitle>';
 ;;       iWD.footerContent='';
 ;;       iWD.pageStorage='session';
 ;;       EWD.ajax.appName="<appName>";
 ;;       EWD.ajax.offlineMode="<offlineMode>";
 ;;       EWD.ajax.loadMain=function(){
 ;;          EWD.ajax.setLocalResource({app:"<appName>",page:"<page>"});
 ;;          EWD.ajax.makeRequest('<pageUrl>','<page>-content-body','get','','');
 ;;       };
 ;;    </script>
 ;;    <style media="screen" type="text/css">
 ;;      div#jqt .vertical-scroll,div#jqt  .vertical-slide{ height: 370px; }
 ;;    </style>
 ;;  </head>
 ;;  <body onload="EWD.ajax.loadMain();">
 ;;    <div id="jqt">
 ;;      <div class="current" id="<page>">
 ;;        <div class="toolbar" id="<page>-toolbar">
 ;;          <h1 id="<page>-toolbarTitle"><appTitle></h1>
 ;;          <span>&nbsp;</span>
 ;;        </div>
 ;;        <div id="<page>-tabbar"></div>
 ;;        <div class="vertical-scroll" id="<page>-content-scrollWrapper" style="height:410px;">
 ;;          <div id="<page>-content">
 ;;            <div id="<page>-content-body"></div>
 ;;            <div class="footer" id="<page>-content-footer"></div>
 ;;          </div>
 ;;        </div>
 ;;        <div id="login-bottomToolbar"></div>
 ;;      </div>
 ;;    </div>
 ;;    <img class="loadingOff" id="loading" src="/iwd/images/loading.gif" />
 ;;    <div class="nocover" id="cover"></div>
 ;;    <div class="alertPopup" id="iWDAlert">
 ;;    <div class="alertPanel" id="iWDAlertFrame">
 ;;        <span class="iWDAlertTitle" id="iWDAlertTitle">Error!</span>
 ;;        <span class="iWDAlertText" id="iWDAlertText">Error in field</span>
 ;;        <a class="noeffect">
 ;;          <span class="black" onclick="iWD.closeAlert();">OK</span>
 ;;        </a>
 ;;      </div>
 ;;    </div>
 ;;  </body>
 ;;</html>
 ;;***END***
 ;
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
 ;
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
