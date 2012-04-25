%zewdCompiler24	; Enterprise Web Developer Compiler : HTML5 Functionality
 ;
 ; Product: Enterprise Web Developer (Build 910)
 ; Build Date: Wed, 25 Apr 2012 17:59:25
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
main(nodeOID,attrValue,docOID,technology)
 ;
 n addGloss,alertOID,attr,bodyOID,btbOID,cbOID,cfOID,cOID,divOID,footer,headOID,h1OID,homeOID,href
 n htmlOID,iWebKitPath,jqtOID,jqtPath,jqtVersion,jsPath,mainAttrs,metaOID,page,pageStorage
 n rootPath,scriptOID,startupImage,tbOID,text,touchIcon,title,vsOID,waitOID
 ;
 ;   <ewd:main title="HTML5 Feature Test" 
 ;             contentPage="main" 
 ;             useHTML5Features="true" 
 ;             buildNo="1.0" 
 ;             homePagePath="c:\inetpub\wwwroot\html5Test.html" 
 ;             mgwlpn="LOCAL"
 ;    >
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("usehtml5features"))="true" d
 . s mainAttrs("offlinemode")="true"
 . k mainAttrs("usehtml5features")
 d createLaunchPage(.mainAttrs,app,technology)
 d createManifestPage
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
createLaunchPage(attrs,appName,technology)
 ;
 n crlf,filePath,i,io,line,manifestPage,manifestUrl,pageUrl,scriptPath
 ;
 s io=$io
 s crlf=$c(13,10)
 i $$os^%zewdHTMLParser()'="windows" s crlf=$c(10)
 s manifestPage="zewdManifest.ewd"
 s mgwlpn=$g(attrs("mgwlpn")) i mgwlpn="" s mgwlpn="LOCAL"
 s scriptPath=$g(^zewd("config","jsScriptPath",technology,"path"))
 i $e(scriptPath,$l(scriptPath))'="/" s scriptPath=scriptPath_"/"
 s manifestUrl=$$expandPageToURL(manifestPage,appName,technology,mgwlpn)
 s pageUrl=$$expandPageToURL(attrs("contentpage"),appName,technology,mgwlpn)
 s filePath=$g(attrs("homepagepath"))
 i '$$openNewFile^%zewdAPI(filePath) QUIT 
 u filePath
 f i=1:1 s line=$t(html5+i^%zewdCompiler24) q:line["***END**"  d
 . s line=$p(line,";;",2,250)
 . i line["<appName>" s line=$$replaceAll^%zewdAPI(line,"<appName>",appName)
 . i line["<page>" s line=$$replaceAll^%zewdAPI(line,"<page>",$g(attrs("contentpage")))
 . i line["<manifestUrl>" s line=$$replaceAll^%zewdAPI(line,"<manifestUrl>",manifestUrl)
 . i line["pageUrl>" s line=$$replaceAll^%zewdAPI(line,"<pageUrl>",pageUrl)
 . i line["<offlineMode>" s line=$$replaceAll^%zewdAPI(line,"<offlineMode>",$g(attrs("offlinemode")))
 . i line["<scriptPath>" s line=$$replaceAll^%zewdAPI(line,"<scriptPath>",scriptPath)
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
isGetPageAllowed(pageName,sessid)
 i $e(pageName,1,3)="ewd" QUIT ""
 i $e(pageName,1,4)="zewd" QUIT ""
 i '$$isGetPageEnabled(pageName,sessid) QUIT "Access to "_pageName_" is not allowed!"
 QUIT ""
 ;
isGetPageEnabled(page,sessid,sessionArray)
 ;
 n pages,pageType
 ;
 i $e(page,1,3)="ewd" QUIT 1
 i $e(page,1,4)="zewd" QUIT 1
 i $d(sessionArray) d
 . ; called before sessionArray merged into session!
 . s pageType=$g(sessionArray("ewd_pageType"))
 e  d
 . s pageType=$$getSessionValue^%zewdAPI("ewd_pageType",sessid)
 i pageType="" QUIT 1
 d mergeArrayFromSession^%zewdAPI(.pages,"ewd_getPageEnabled",sessid)
 i $d(pages(page)) QUIT 1
 QUIT 0
 ;
getPageEnabledInit(sessid)
 ;
 n pages
 ;
 d deleteFromSession^%zewdAPI("ewd_getPageEnabled",sessid)
 i $$isCSP^%zewdAPI(sessid) QUIT
 ; add any pages from the temporary page enabled list
 d mergeArrayFromSession^%zewdAPI(.pages,"ewd_pageEnabled",sessid)
 d mergeArrayToSession^%zewdAPI(.pages,"ewd_getPageEnabled",sessid)
 d deleteFromSession^%zewdAPI("ewd_pageEnabled",sessid) 
 QUIT
 ;
createGetPageEnabled(sessid)
 ;
 n app,page,pages,xpages
 ;
 s app=$$getSessionValue^%zewdAPI("ewd_appName",sessid)
 s app=$$zcvt^%zewdAPI(app,"l")
 m pages=^%zewdIndex(app,"pages")
 i '$$isCSP^%zewdAPI(sessid) d
 . ; remove any pages registered in the temporary disabled list
 . d mergeArrayFromSession^%zewdAPI(.xpages,"ewd_pageDisabled",sessid)
 . s page=""
 . f  s page=$o(xpages(page)) q:page=""  d
 . . k pages(page)
 d mergeArrayToSession^%zewdAPI(.pages,"ewd_getPageEnabled",sessid)
 ; get rid of the temporary page disabled list
 d deleteFromSession^%zewdAPI("ewd_pageDisabled",sessid)
 QUIT
 ;
enableGetPage(page,sessid)
 ;
 n pages,stop
 ;
 s stop=0
 i '$$isCSP^%zewdAPI(sessid) d  QUIT:stop
 . i '$$sessionNameExists^%zewdAPI("ewd_getPageEnabled",sessid) d  q
 . . ; remove from temporary page disabled list if present
 . . d mergeArrayFromSession^%zewdAPI(.pages,"ewd_pageDisabled",sessid)
 . . i $d(pages(page)) k pages(page)
 . . d deleteFromSession^%zewdAPI("ewd_pageDisabled",sessid)
 . . d mergeArrayToSession^%zewdAPI(.pages,"ewd_pageDisabled",sessid)
 . . ; add to temporary page enabled list
 . . k pages
 . . s pages(page)=""
 . . d mergeArrayToSession^%zewdAPI(.pages,"ewd_pageEnabled",sessid) 
 . . s stop=1
 ;
 s pages(page)=""
 d mergeArrayToSession^%zewdAPI(.pages,"ewd_getPageEnabled",sessid) 
 ;
 QUIT
 ;
disableGetPage(page,sessid)
 ;
 QUIT:$g(page)=""
 QUIT:$g(sessid)=""
 ;
 n pages,stop
 ;
 s stop=0
 i '$$isCSP^%zewdAPI(sessid) d  QUIT:stop
 . i '$$sessionNameExists^%zewdAPI("ewd_getPageEnabled",sessid) d  q
 . . ; remove from temporary page enabled list, if present
 . . d mergeArrayFromSession^%zewdAPI(.pages,"ewd_pageEnabled",sessid)
 . . i $d(pages(page)) k pages(page)
 . . d deleteFromSession^%zewdAPI("ewd_pageEnabled",sessid)
 . . d mergeArrayToSession^%zewdAPI(.pages,"ewd_pageEnabled",sessid)
 . . ; add to temporary page disabled list
 . . k pages
 . . s pages(page)=""
 . . d mergeArrayToSession^%zewdAPI(.pages,"ewd_pageDisabled",sessid)
 . . s stop=1
 ;
 k pages
 d mergeArrayFromSession^%zewdAPI(.pages,"ewd_getPageEnabled",sessid)
 i $d(pages(page)) k pages(page)
 d deleteFromSession^%zewdAPI("ewd_getPageEnabled",sessid) 
 d mergeArrayToSession^%zewdAPI(.pages,"ewd_getPageEnabled",sessid)
 QUIT
 ;
createManifestPage
 ;
 n buildNo,childNo,childOID,filePath,io,manifestPage,mOID,OIDArray,tagName
 ;
 s mOID=$$getTagOID^%zewdDOM("ewd:manifest",docName)
 s buildNo=$$getAttribute^%zewdDOM("buildno",mOID)
 k ^zewd("manifest",app)
 s ^zewd("manifest",app,"build")=buildNo
 ;
 d getChildrenInOrder^%zewdDOM(mOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="ewd:manifestsection" d
 . . s sectionName=$$getAttribute^%zewdDOM("name",childOID) break
 ;
 s io=$io
 s manifestPage="zewdManifest"
 s filePath=inputPath_manifestPage_".ewd"
 i '$$openNewFile^%zewdCompiler(filePath) QUIT
 u filePath
 w "<ewd:config isFirstPage=""true"" cachePage=""false"">",!
 w "<ewd:responseHeader name=""Content-type"" value=""text/cache-manifest"" />",!
 w "<ewd:execute method=""manifest^%zewdCompiler24"" param1=""#ewd_sessid"" type=""procedure"" />",!
 c filePath
 u io
 s files(manifestPage_".ewd")=""
 QUIT
 ;
manifest(sessid)
 n appName,delim,files,inputPath,name,technology
 ;
 s appName=$$getSessionValue^%zewdAPI("ewd_appName",sessid)
 s version=$g(^zewd("manifest",appName,"build"))
 s delim=$$getDelim^%zewdAPI()
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 i technology="",$zv["Cache" s technology="wl"
 i technology="",$zv["GT.M" s technology="gtm"
 w "CACHE MANIFEST"_$c(13,10)
 w "# iWD Offline Manifest for the "_appName_" application"_$c(13,10)
 w "# "_version_$c(13,10)
 s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 i $e(path,$l(path))'="/" s path=path_"/"
 w path_"iwdLoader.js"_$c(13,10)
 w path_"iwdScripts.js"_$c(13,10)
 w "/iwd/jqt/jqtouch/jquery.1.3.2.min.js"_$c(13,10)
 w "/iwd/jqt/jqtouch/jqtouch.min.js"_$c(13,10)
 w "/iwd/jqt/extensions/jqt.scrolling.js"_$c(13,10)
 w "/iwd/jqt/extensions/jqt.sliding.js"_$c(13,10)
 w "/iwd/javascript/spinningwheel.js"_$c(13,10)
 ;
 w path_"ewd.css"_$c(13,10)
 w "/iwd/css/iwd.css"_$c(13,10)
 w "/iwd/jqt/themes/apple/theme.css"_$c(13,10)
 w "/iwd/jqt/extensions/scrolling.css"_$c(13,10)
 w "/iwd/iwebkit/css/developer-style.css"_$c(13,10)
 w "/iwd/jqt/jqtouch/jqtouch.css"_$c(13,10)
 w "/iwd/css/spinningwheel.css"_$c(13,10)
 ;
 w "/iwd/jqt/themes/apple/img/blueButton.png"_$c(13,10)
 w "/iwd/jqt/themes/apple/img/pinstripes.png"_$c(13,10)
 w "/iwd/jqt/themes/apple/img/toolbar.png"_$c(13,10)
 w "/iwd/jqt/themes/apple/img/chevron.png"_$c(13,10)
 w "/iwd/jqt/themes/apple/img/selection.png"_$c(13,10)
 w "/iwd/jqt/themes/apple/img/backButton.png"_$c(13,10)
 w "/iwd/iwebkit/images/whitebutton.png"_$c(13,10)
 w "/iwd/images/loading.gif"_$c(13,10)
 w "/favicon.ico"_$c(13,10)
 ;
 s name=""
 f  s name=$o(files("CACHE",name)) q:name=""  d
 . w name_$c(13,10)
 ;
 w $c(13,10)_"NETWORK:"_$c(13,10)
 i technology="wl" w "/scripts/mgwms32.dll"_$c(13,10)
 w $c(13,10)
 ;
 s name=""
 f  s name=$o(files("NETWORK",name)) q:name=""  d
 . w name_$c(13,10)
 ;
 w "FALLBACK:"_$c(13,10)
 s name=""
 f  s name=$o(files("FALLBACK",name)) q:name=""  d
 . w name_$c(13,10)
 ;
 QUIT
 ;
html5 ;
 ;;<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 ;;<html manifest='<manifestUrl>' xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
 ;;  <head>
 ;;    <meta charset="UTF-8" />
 ;;    <base href="" />
 ;;    <link rel="stylesheet" type="text/css" href="<scriptPath>ewd.css"> 
 ;;    <script src="<scriptPath>ewdScripts.js" type="text/javascript"></script>
 ;;
 ;;    <script language="javascript">
 ;;       EWD.ajax.appName="<appName>";
 ;;       EWD.ajax.offlineMode="<offlineMode>";
 ;;       EWD.ajax.loadMain=function(){
 ;;          EWD.ajax.setLocalResource({app:"<appName>",page:"<page>"});
 ;;          EWD.ajax.makeRequest('<pageUrl>','ewd-body-content','get','','');
 ;;       };
 ;;    </script>
 ;;  </head>
 ;;  <body onload="EWD.ajax.loadMain();">
 ;;     <div id="ewd-body-content"></div>
 ;;  </body>
 ;;</html>
 ;;***END***
