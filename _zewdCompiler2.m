%zewdCompiler2	; Enterprise Web Developer Compiler : fixed text
 ;
 ; Product: Enterprise Web Developer (Build 912)
 ; Build Date: Wed, 02 May 2012 16:47:56
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
 ;
version ;; 912
date	;; 01 May 2012
 ;
ewdError ;
 ;;*jsp*<%@ page contentType="text/html" %>
 ;;*jsp*<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 ;;*vb.net*<%@ Page Language="VB" Debug="true" validateRequest="false" %>
 ;;*vb.net*<%@ Register TagPrefix="m_aspx" Namespace="m_aspx" Assembly="m_aspx" %>
 ;;*vb.net*<%
 ;;*vb.net*  Dim m_aspx = New m_aspx_control
 ;;*vb.net*%>
 ;;
 ;;<html>
 ;;<head>
 ;;<title>Enterprise Web Developer : A run-time error has occurred</title>
 ;;<style type="text/css">
 ;;   body {background: #ffffff ;}
 ;;   .headerBlock {width: 100% ; background : #111111 ; horizontal-align : center ; }
 ;;   .headerBlock[class] {width: 100% ; background : #111111 ; horizontal-align : center ; position: relative ; top : 30px ; border-right-style : solid ; border-right-width: 2px ; }
 ;;   #headerText {vertical-align: center ; font-family: Arial, sans-serif ; color: #dddddd ; font-size: 11pt ; margin-left: 10px}
 ;;   #headerSubject {vertical-align: center ; font-family: Arial, sans-serif ; color: #dddddd ; font-size: 11pt ; position: relative ; top: -30px ; text-align: center ;}
 ;;   .selectedTab {border-style: outset ; background: #eeeedd ; padding-left: 8px ; padding-right: 8px ;}
 ;;   .unselectedTab {border-style: groove ; padding-left: 8px ; padding-right: 8px ;}
 ;;   #tabs {cursor : pointer ; height: 20px ;  background : #cccccc ; text-align: center ; position: relative ; left: 25px ; font-family : Arial, Helvetica, sens-serif ; font-size: 11pt}
 ;;   #mainArea {background : #dfe2f1 ; padding: 0 ; horizontal-align: center ; width : 100% ; height: auto ; border-style: solid ; border-left-width: 1px ; border-right-width: 1px ; padding-top : 0px ; margin-top : 0px}
 ;;   #workArea {background : #ffffff ; horizontal-align: center ; position: relative ; top: -6px ; left: 25px ; width : 95% ; height: auto ; font-family : Arial, Helvetica, sens-serif ; font-size: 12pt ; border-style: outset}
 ;;   #pageTitle {width: 100% ; height: 50px ; text-align : center ; horizontal-align : center ; font-family: Arial, sans-serif ;}
 ;;   .footerBlock {width: 100% ; background : #111111 ; horizontal-align : center ;}
 ;;   .footerBlock[class] {width: 100% ; background : #111111 ; horizontal-align : center ; position: relative ; top : -15px ; border-right-style : solid ; border-right-width: 2px ; }
 ;;   #footerText {vertical-align: center ; font-family: Arial, sans-serif ; color: #dddddd ; font-size: 8pt ; margin-left : 10px}
 ;;   #tableblock {text-align: center ; margin-top: 40px}
 ;;   #hiddenForm {visibility: hidden ;}
 ;;</style>
 ;;</head>
 ;;<body>
 ;;
 ;;      <div id="mainArea">
 ;;        <div id="pageTitle">
 ;;           <h1>ewd_Version</h1>
 ;;        </div>
 ;;
 ;;        <div id="workArea">
 ;;          <div id="tableblock">
 ;;           <h3>An Error has occurred</h3>
 ;;           <br>
 ;;*wl*           <h3>#($g(%KEY("error")))#</h3>
 ;;*php*           <h3><?= $_REQUEST["error"] ?></h3>
 ;;*jsp*           <h3><c:out value="${param.error}" escapeXml="false" /></h3>
 ;;*vb.net*        <h3><%= Request.QueryString("error") %></h3>
 ;;          </div>
 ;;        </div>
 ;;     </div>
 ;;
 ;;     <div class=footerBlock>
 ;;              <p id="footerText">&nbsp;&copy; 2004-2012 M/Gateway Developments Ltd All Rights Reserved</p>
 ;;     </div>
 ;;</body>
 ;;</html>
 ;;***END***
 ;;
eventBrokerJS ;
 ;;EWD.page.event = function (eventID) {
 ;;                   var nvpList = "" ;
 ;;                   var noOfParams = EWD.page.event.arguments.length ;
 ;;                   for (var nParam = 1; nParam < noOfParams; nParam++) {
 ;;*php*                nvpList=nvpList + "&ewd_Param[" + nParam + "]=" + EWD.page.event.arguments[nParam] ;
 ;;*jsp*                nvpList=nvpList + "&ewd_Param=" + ewdEvent.arguments[nParam] ;
 ;;                   }
 ;;*php*              var returnString = server_proc("<?= getCurrentPage() ?>?ewd_token=<?= (isset($ewd_session["ewd_token"])) ? $ewd_session["ewd_token"] : "" ?>&ewd_action=ewdEvent&ewd_eventID=" + eventID + nvpList) ;
 ;;*jsp*              var returnString = server_proc("http://<%= request.getServerName() %>:<%= String.valueOf(request.getServerPort()) %><%= getSessionValue("ewd_rootURL", ewd_Session, m_jsp) %>/<%= getSessionValue("ewd_appName", ewd_Session, m_jsp) %>/<%= currentPage %>?ewd_token=<%= getSessionValue("ewd_token", ewd_Session, m_jsp) %>&ewd_action=ewdEvent&ewd_eventID=" + eventID + nvpList) ;
 ;;                   var ebFunc = new Function(returnString) ;
 ;;                   ebFunc() ;
 ;;                 } ;
 ;;***END***
 ;;
 ;;
 ;;*php*      x = "document.location = '" + page + '.php?ewd_token=' + "<?= $ewd_session["ewd_token"] ?>" + "&n=" + token + "'" ;
 ;;*jsp*       x = "document.location = '" + page + '.jsp?ewd_token=' + '<% out.print(getSessionValue("ewd_token", ewd_Session, m_jsp));%>' + '&n=' + token + "'" ;
jsInPageBlock ;
 ;;*php*  EWD.page.confirmText="<?= $ewd_confirmText ?>" ;
 ;;*jsp*  EWD.page.confirmText="<%= ewd_confirmText %>" ;
 ;;*csp*  EWD.page.confirmText='#($zcvt(confirmText,"o","JS"))#' ;
 ;;*gtm*  EWD.page.confirmText='#($$jsEscape^%zewdGTMRuntime(confirmText))#' ;
 ;;  EWD.page.setOnSubmit =  function(obj,confirmText) { 
 ;;*php*                       if (confirmText == "") confirmText = "<?= $ewd_confirmText ?>" ;
 ;;*csp*                       if (confirmText == "") confirmText = "#(confirmText)#" ;
 ;;*jsp*                       if (confirmText == "") confirmText = "<%= ewd_confirmText %>" ;
 ;;                            str='return EWD.page.displayConfirm("' + confirmText+ '")' ;
 ;;                            obj.form.onsubmit=new Function(str) ;
 ;;                          } ;
 ;;***END***
openWindowJS ;
 ;;***END***
ewdSelectedValueJS ;
 ;;function ewdSelectedValue(field) {
 ;;  type = field.type ;
 ;;  returnValue = "" ;
 ;;  switch (type) 
 ;;     { 
 ;;       case "text": 
 ;;           returnValue = field.value ;
 ;;           break; 
 ;;        case "password": 
 ;;           returnValue = field.value ;
 ;;           break; 
 ;;       case "radio": 
 ;;           returnValue = field.value ;
 ;;           break; 
 ;;       case "checkbox":
 ;;           returnValue = "" ;
 ;;           opt = field.form.elements[field.name] ;
 ;;           for (i = 0 ; i < opt.length ; i++) {
 ;;              if (opt[i].checked) {
 ;;                  returnValue = returnValue + opt[i].value + String.fromCharCode(1) ;
 ;;              }
 ;;           }
 ;;           break;
 ;;       case "select-one":
 ;;           returnValue = field.value ;
 ;;           break;
 ;;       case "select-multiple":
 ;;           returnValue = "" ;
 ;;           for (i = 0 ; i < field.length ; i++) {
 ;;              if (field.options[i].selected) {
 ;;                 returnValue = returnValue + field.options[i].value + String.fromCharCode(1) ;
 ;;              }
 ;;           }
 ;;           break;
 ;;       default: 
 ;;             break; 
 ;;     } 
 ;;     return returnValue ;
 ;;} ;
 ;;***END***
 ;;
