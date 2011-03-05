%zewdiwd ; iWD Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 856)
 ; Build Date: Sat, 05 Mar 2011 15:19:38
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-11 M/Gateway Developments Ltd,                        |
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
 QUIT
 ;
 ;
main(nodeOID,attrValue,docOID,technology)
 ;
 n addGloss,alertOID,attr,bodyOID,btbOID,cbOID,cfOID,cOID,divOID,footer,headOID,h1OID,homeOID,href
 n htmlOID,iWebKitPath,jqtOID,jqtPath,jqtVersion,jsPath,mainAttrs,metaOID,page,pageStorage
 n rootPath,scriptOID,startupImage,tbOID,text,touchIcon,title,vsOID,waitOID
 ;
 ;   <iwd:main 
 ;        touchIcon="/iwd/pics/homescreen.gif"
 ;        iwdRootPath="/iwd"
 ;        iWebKitPath="iwebkit"
 ;        jqTouchPath="/iwd/jqt"
 ;        jqtVersion="1.3.2"
 ;        startupImage="/iwd/javascript/functions.js" 
 ;        title="IWD Demo"
 ;        footer="Test footer"
 ;        contentPage="mainMenu" 
 ;        pageStorage="session|local"
 ;   />
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("offlinemode"))="always" d  QUIT
 . d createLaunchPage^%zewdCompiler23(.mainAttrs,app,technology)
 ;
 s scriptOID=$$getFirstChild^%zewdDOM(nodeOID)
 s scriptOID=$$removeChild^%zewdDOM(scriptOID)
 ;
 s htmlOID=$$addElementToDOM^%zewdDOM("ewd:xhtml",nodeOID)
 ;d setAttribute^%zewdDOM("manifest","/cgi-bin/nph-mgwcgi?MGWLPN=LOCAL&MGWAPP=ewdwl&app=iwd&page=manifest",htmlOID)
 ; head
 s headOID=$$addElementToDOM^%zewdDOM("head",htmlOID)
 ;
 s attr("charset")="UTF-8"
 s metaOID=$$addElementToDOM^%zewdDOM("meta",headOID,,.attr)
 ;
 s title=$g(mainAttrs("title")) 
 i title="" s title="Un-named iWD Application"
 s metaOID=$$addElementToDOM^%zewdDOM("title",headOID,,,title)
 ;
 s attr("href")=""
 s metaOID=$$addElementToDOM^%zewdDOM("base",headOID,,.attr)
 ;
 s rootPath=$g(mainAttrs("iwdrootpath"))
 i rootPath="" s rootPath="/iwd/"
 i $e(rootPath,$l(rootPath))'="/" s rootPath=rootPath_"/"
 s text=" d setSessionValue^%zewdAPI(""iwd_rootPath"","""_rootPath_""",sessid)"
 s offlineMode=$g(mainAttrs("offlinemode")) i offlineMode="" s offLineMode="false"
 s text=text_$c(13,10)_" d setSessionValue^%zewdAPI(""ewd_offlineMode"","""_offlineMode_""",sessid)"
 i $$addCSPServerScript^%zewdAPI(headOID,text)
 ;
 i offlineMode="always" d
 . d setAttribute^%zewdDOM("manifest","manifest.ewd",htmlOID)
 ;
 s iWebKitPath=$g(mainAttrs("iwebkitpath"))
 i iWebKitPath="" s iWebKitPath="iwebkit/"
 i $e(iWebKitPath,1)'="/" s iWebKitPath=rootPath_iWebKitPath
 i $e(iWebKitPath,$l(iWebKitPath))'="/" s iWebKitPath=iWebKitPath_"/"
 ;
 s jsPath=$g(^zewd("config","jsScriptPath",technology,"path"))
 i jsPath="" s jsPath="/"
 i $e(jsPath,$l(jsPath))'="/" s jsPath=jsPath_"/"
 ;
 s attr("src")=jsPath_"iwdLoader.js"
 s attr("type")="text/javascript"
 s metaOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s pageStorage=$g(mainAttrs("pagestorage"))
 i pageStorage="" s pageStorage="session"
 ;
 s touchIcon=$g(mainAttrs("touchicon"))
 s addGloss=$g(mainAttrs("addglosstoicon"))
 i addGloss="" s addGloss="false"
 s startupImage=$g(mainAttrs("startupimage"))
 s page=$g(mainAttrs("contentpage"))
 i page="" s page="missingContent"
 ;
 s text=""
 s text=text_"iWDLoader.loadJavascript('"_jsPath_"iwdScripts.js');"
 ;
 s text=text_"iWDLoader.loadCSS('"_jsPath_"ewd.css');"
 s text=text_"iWDLoader.loadCSS('/iwd/css/iwd.css');"
 ;
 s text=text_"iWDLoader.loadJavascript('/iwd/jqt/jqtouch/jquery.1.3.2.min.js');"
 s text=text_"iWDLoader.loadJavascript('/iwd/jqt/jqtouch/jqtouch.min.js');"
 s text=text_"iWDLoader.loadJavascript('/iwd/jqt/extensions/jqt.scrolling.js');"
 s text=text_"iWDLoader.loadJavascript('/iwd/jqt/extensions/jqt.sliding.js');"
 s text=text_"iWDLoader.loadJavascript('/iwd/javascript/spinningwheel.js');"
 s text=text_"iWDLoader.loadCSS('/iwd/jqt/themes/apple/theme.css','/iwd/jqt/themes/apple/');"
 s text=text_"iWDLoader.loadCSS('/iwd/jqt/extensions/scrolling.css');"
 s text=text_"iWDLoader.loadCSS('/iwd/iwebkit/css/developer-style.css','/iwd/iwebkit/dummy/');"
 ;s text=text_"iWDLoader.loadCSS('/iwd/jqt/jqtouch/jqtouch.min.css');"
 s text=text_"iWDLoader.loadCSS('/iwd/jqt/jqtouch/jqtouch.css');"
 s text=text_"iWDLoader.loadCSS('/iwd/css/spinningwheel.css');"
 s text=text_"var jQT = new $.jQTouch({"
 s text=text_"fullscreen:true,"
 i touchIcon'="" s text=text_"icon: '"_touchIcon_"'," 
 s text=text_"addGlossToIcon: "_addGloss_","  
 i startupImage'="" s text=text_"startupScreen: '"_startupImage_"',"
 s text=text_"statusBar: 'default',"
 s text=text_"popupSelector: '.pop',"
 s text=text_"useFastTouch: true,"
 s text=text_"slideSelector: '#jqt > * > ul li a, .slideRight',"
 s text=text_"preloadImages:['/iwd/jqt/themes/apple/img/blueButton.png'],"
 s text=text_"useAnimations: true,"
 s text=text_"});"_$c(13,10)
 ;
 s text=text_"$(window).load(function() {"_$c(13,10)
 s text=text_"$('#jqt').bind('touchmove', function(e){e.preventDefault()});"_$c(13,10)
 s text=text_"$(document.body).trigger('orientationchange');"_$c(13,10)
 s text=text_"});"_$c(13,10)
 ;
 s text=text_"iWD.jqt=jQT;"
 s text=text_"iWD.toolbarTitle='"_title_"';"_$c(13,10)
 s text=text_"iWD.footerContent='"_$g(mainAttrs("footer"))_"';"_$c(13,10)
 s text=text_"iWD.pageStorage='"_pageStorage_"';"_$c(13,10)
 s text=text_"EWD.ajax.loadMain=function(){"_$c(13,10)
 ;s text=text_"iWD.createNewPage('"_page_"')"_$c(13,10)
 s text=text_"ewd.ajaxRequest("""_page_""","""_page_"-content-body"");"_$c(13,10)
 s text=text_"iWD.currentFragmentName='"_page_"';"_$c(13,10)
 ;s text=text_"jQT.goTo('#"_page_"');"_$c(13,10)
 s text=text_"};"_$c(13,10)
 i technology="csp" d
 . n rootURL
 . s rootURL=$$getRootURL^%zewdAPI(technology)
 . i $e(rootURL,$l(rootURL))'="/" s rootURL=rootURL_"/"
 . s text=text_"iWDLoader.setBaseHref('"_rootURL_app_"/');"_$c(13,10)
 s text=text_$$getData^%zewdDOM($$getFirstChild^%zewdDOM(scriptOID))
 ;
 s attr("language")="javascript"
 s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
 ;
 s attr("type")="text/css"
 s attr("media")="screen"
 s text="div#jqt .vertical-scroll,div#jqt  .vertical-slide{ height: 370px; }"
 s jsOID=$$addElementToDOM^%zewdDOM("style",headOID,,.attr,text)
 ;
 ; body
 ;
 s attr("onload")="EWD.ajax.loadMain();"
 s bodyOID=$$addElementToDOM^%zewdDOM("body",htmlOID,,.attr)
 ;
 s attr("id")="jqt"
 s jqtOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr)
 ;
 s attr("id")=page
 s attr("class")="current"
 s homeOID=$$addElementToDOM^%zewdDOM("div",jqtOID,,.attr)
 ;
 s attr("id")=page_"-toolbar"
 s attr("class")="toolbar"
 s tbOID=$$addElementToDOM^%zewdDOM("div",homeOID,,.attr)
 ;
 s attr("id")=page_"-toolbarTitle"
 s text=title
 s h1OID=$$addElementToDOM^%zewdDOM("h1",tbOID,,.attr,text)
 ;
 s cOID=$$addElementToDOM^%zewdDOM("span",tbOID,,,"&nbsp;")
 ;
 s attr("id")=page_"-tabbar"
 s tbOID=$$addElementToDOM^%zewdDOM("div",homeOID,,.attr)
 ;
 s attr("class")="vertical-scroll"
 s attr("id")=page_"-content-scrollWrapper"
 s attr("style")="height:410px;"
 s vsOID=$$addElementToDOM^%zewdDOM("div",homeOID,,.attr)
 ;
 s attr("id")=page_"-bottomToolbar"
 s btbOID=$$addElementToDOM^%zewdDOM("div",homeOID,,.attr)
 ;
 s attr("id")=page_"-content"
 s cOID=$$addElementToDOM^%zewdDOM("div",vsOID,,.attr)
 ;
 s attr("id")=page_"-content-body"
 s cbOID=$$addElementToDOM^%zewdDOM("div",cOID,,.attr)
 s attr("id")=page_"-content-footer"
 s attr("class")="footer"
 s cfOID=$$addElementToDOM^%zewdDOM("div",cOID,,.attr)
 ;
 s attr("id")="loading"
 s attr("class")="loadingOff"
 s attr("src")="/iwd/images/loading.gif"
 s cOID=$$addElementToDOM^%zewdDOM("img",bodyOID,,.attr)
 s attr("id")="cover"
 s attr("class")="nocover"
 s cOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr)
 s attr("id")="iWDAlert"
 s attr("class")="alertPopup"
 s aOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr)
 s attr("id")="iWDAlertFrame"
 s attr("class")="alertPanel"
 s alertOID=$$addElementToDOM^%zewdDOM("div",aOID,,.attr)
 s attr("class")="iWDAlertTitle"
 s attr("id")="iWDAlertTitle"
 s text="Error!"
 s cOID=$$addElementToDOM^%zewdDOM("span",alertOID,,.attr,text)
 s attr("class")="iWDAlertText"
 s attr("id")="iWDAlertText"
 s text="Error in field"
 s cOID=$$addElementToDOM^%zewdDOM("span",alertOID,,.attr,text)
 s attr("class")="noeffect"
 ;s attr("href")="#"
 s aOID=$$addElementToDOM^%zewdDOM("a",alertOID,,.attr)
 s attr("class")="black"
 s attr("onclick")="iWD.closeAlert();"
 s text="OK"
 s cOID=$$addElementToDOM^%zewdDOM("span",aOID,,.attr,text)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
graytitle(nodeOID,attrValue,docOID,technology)
 ;
 n attr,divOID,mainAttrs,style,text,title
 ;
 ;   <iwd:graytitle
 ;        title="Features" 
 ;   />
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s attr("class")="graytitle"
 s text=$g(mainAttrs("text"))
 s style=$g(mainAttrs("style"))
 i text="" s text="Missing Gray Title Text"
 i style'="" s attr("style")=style
 s divOID=$$addElementToDOM^%zewdDOM("span",nodeOID,,.attr,text) 
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
header(nodeOID,attrValue,docOID,technology)
 ;
 n attr,divOID,mainAttrs,text
 ;
 ;   <iwd:header text="Welcome to iWD" /> 
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s attr("class")="header"
 s text=$g(mainAttrs("text"))
 i text="" s text="Missing Header Text"
 s divOID=$$addElementToDOM^%zewdDOM("span",nodeOID,,.attr,text) 
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
tablePanel(nodeOID,attrValue,docOID,technology)
 ;
 n attr,childNo,childOID,color,divOID,mainAttrs,OIDArray,lineOID
 n parentOID,rootid,sessionName,tagName
 ;
 ;   <iwd:tablePanel sessionName="myMenu">
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s sessionName=$g(mainAttrs("sessionname"))
 s color=$g(mainAttrs("color"))
 i color="" s color="black"
 ;
 i sessionName'="" d
 . n lineOD,text,xOID
 . s attr("method")="writeTableItems^%zewdiwd"
 . s attr("param1")=sessionName
 . s attr("param2")=color
 . s attr("param3")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",nodeOID,,.attr)
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ul",docOID)
 d setAttribute^%zewdDOM("class","rounded",divOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
writeTableItems(sessionName,color,sessid)
 ;
 n no,psArray
 ;
 d mergeArrayFromSession^%zewdAPI(.psArray,sessionName,sessid)
 ;
 s no=""
 f  s no=$o(psArray(no)) q:no=""  d
 . w "<li style='color:"_color_";'>"_$c(13,10)
 . ;w "<a href='#"_page_"' class='slideRight' onclick=""iWD.goMenuOption['"_sessionName_"']("_no_");"">"
 . w $g(psArray(no,"text"))
 . ;w "</a>"_$c(13,10)
 . w "</li>"_$c(13,10)
 QUIT
 ;
menuPanel(nodeOID,attrValue,docOID,technology)
 ;
 n attr,childNo,childOID,divOID,mainAttrs,OIDArray,lineOID,nextPage
 n parentOID,rootid,sessionName,tagName,transition
 ;
 ;   <iwd:menuPanel />
 ;   <iwd:menuPanel sessionName="myMenu" nextpage="dosomething">
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s sessionName=$g(mainAttrs("sessionname"))
 s nextPage=$g(mainAttrs("nextpage"))
 i nextPage="" s nextPage="UndefinedNextPage"
 s rootid=$g(mainAttrs("rootid"))
 s transition=$g(mainAttrs("transition"))
 i transition="" s transition="slideRight"
 ;
 i sessionName'="" d
 . n lineOD,text,xOID
 . s attr("method")="writeMenuItems^%zewdiwd"
 . s attr("param1")=nextPage
 . s attr("param2")=transition
 . s attr("param3")=rootid
 . s attr("param4")=sessionName
 . s attr("param5")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",nodeOID,,.attr)
 . s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 . i jsOID="" d
 . . n configOID,nsOID
 . . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 . s text="iWD.goMenuOption['"_sessionName_"']=function(no,obj) {"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . s text="var nvp='menuItemNo='+no;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . ;s text="iWD.target={'panelId':'#"_nextPage_"','transition':'"_transition_"'};"
 . ;s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . s text="ewd.ajaxRequest("""_nextPage_""","""_nextPage_"-content-body"",nvp);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . s text="iWD.currentFragmentName='"_nextPage_"';"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . s text="};"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)	
 . s text="iWD.createNewPage('"_nextPage_"');"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . ;s text="document.getElementById('"_nextPage_"').innerHTML=document.getElementById('iwdWait').innerHTML;"
 . ;s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 e  d
 . d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName'="iwd:menuitem" q
 . . d menuItem(childOID,nodeOID)
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ul",docOID)
 d setAttribute^%zewdDOM("class","rounded",divOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;s parentOID=$$getParentNode^%zewdDOM(divOID)
 ;s attr("id")="rPanel"
 ;s attr("style")="display:none;position:absolute;top:0px;left:320px;width:320px;height:400px"
 ;s divOID=$$addElementToDOM^%zewdDOM("div",parentOID,,.attr) 
 s isIwd=1
 QUIT
 ;
writeMenuItems(page,transition,rootid,sessionName,sessid)
 ;
 n aOID,attr,class,id,img,imgOID,liOID,mainAttrs,psArray,rootPath,spanOID,text,type
 ;
 d mergeArrayFromSession^%zewdAPI(.psArray,sessionName,sessid)
 ;
 s rootPath=$$getSessionValue^%zewdAPI("iwd_rootPath",sessid)
 i transition="slide" s transition="slideRight"
 s no=""
 f  s no=$o(psArray(no)) q:no=""  d
 . s id="" i rootid'="" s id="id="""_rootid_no_""" "
 . w "<li class=""arrow"">"_$c(13,10)
 . ;w "<a class="""_transition_""" onmousedown=""jQT.goTo('#"_page_"','"_transition_"') ;iWD.goMenuOption("_no_"); return false;"" href=""#"">"_$c(13,10)
 . ;w "<a "_id_"onmousedown=""jQT.goTo('#"_page_"','"_transition_"') ;setTimeout('iWD.goMenuOption[\'"_sessionName_"\']("_no_");',100);"" href=""#"">"_$c(13,10)
 . ;w "<a "_id_"ontouchstart=""jQT.goTo('#"_page_"','"_transition_"') ;setTimeout('iWD.goMenuOption[\'"_sessionName_"\']("_no_");',100);"">"_$c(13,10)
 . ;w "<a "_id_"onmousedown=""iWD.goMenuOption['"_sessionName_"']("_no_");"" href=""#"">"_$c(13,10)
 . w "<a "_id_" href='#"_page_"' class='"_transition_"' onclick=""document.getElementById('loading').className='loadingOn';iWD.overlayShim(this);iWD.scrollUpPage('"_page_"');iWD.goMenuOption['"_sessionName_"']("_no_",this);"">"
 . w $g(psArray(no,"text"))
 . w "</a>"_$c(13,10)
 . w "</li>"_$c(13,10)
 QUIT
 ;
menuItem(nodeOID,parentOID)
 ;
 n aOID,attr,class,img,imgOID,jsOID,liOID,mainAttrs,spanOID,text,type
 ;
 ;   <iwd:menuItem
 ;      type="text" 
 ;   />
 ;
 ;   <iwd:menuItem
 ;      type="menu"
 ;      text="Sessions"
 ;      nextpage="session" 
 ;      targetID="content"
 ;   />
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type")) i type="" s type="menu"
 s class="arrow"
 i type="text" s class="textbox"
 s attr("class")=class
 s liOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"li",docOID)
 d setAttribute^%zewdDOM("class",class,liOID)
 i type="menu" d
 . n page,phpVar,transition
 . s page=$g(mainAttrs("nextpage")) i type="" s type="missingPage"
 . s transition=$g(mainAttrs("transition")) i transition="" s transition="slideRight"
 . i transition="slide" s transition="slideRight"
 . s text=$g(mainAttrs("text")) i text="" s text="Missing Menu Option Text"
 . s attr("href")="#"_page
 . s attr("class")=transition
 . s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_touchEvent")
 . s attr("event")=phpVar
 . ;s attr("event")="onclick"
 . s attr("ajaxpage")=page
 . s attr("targetid")=page_"-content-body"
 . s attr("eventpre")="document.getElementById('loading').className='loadingOn';iWD.createNewPage('"_page_"');iWD.currentFragmentName='"_page_"'"
 . s attr("eventpre")="EWD.ajax.setLocalResource({app:'"_app_"',page:'"_page_"'});"_attr("eventpre")
 . s aOID=$$addElementToDOM^%zewdDOM("a",liOID,,.attr,text)
 ;
 i $g(mainAttrs("hideif"))'="" d
 . n ifOID,var
 . s ifOID=$$insertNewParentElement^%zewdDOM(liOID,"ewd:if",docOID)
 . s var=mainAttrs("hideif")
 . s var=$p(var,"&php;",2)
 . s var=$g(phpVars(var))
 . s var=$$stripSpaces^%zewdAPI(var)
 . d setAttribute^%zewdDOM("firstvalue",var,ifOID)
 . d setAttribute^%zewdDOM("operation","=",ifOID)
 . d setAttribute^%zewdDOM("secondvalue",0,ifOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
pageItem(nodeOID,attrValue,docOID,technology)
 ;
 n divOID,liOID
 ;
 ;   <iwd:pageItem />
 ;   <iwd:textPanel />
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ul",docOID)
 d setAttribute^%zewdDOM("class","pageitem",divOID)
 s liOID=$$insertNewIntermediateElement^%zewdDOM(divOID,"li",docOID)
 d setAttribute^%zewdDOM("class","textbox",liOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
field(nodeOID,attrValue,docOID,technology)
 ;
 n attr,img,imgOID,liOID,liText,mainAttrs,type,number,rightImage,text,textStyle
 ;
 ;   <iwd:field type="sms" number="+441737244233" text="SMS to 1737244233" /> 
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type"))
 i type="",$$hasChildNodes^%zewdDOM(nodeOID)="true" d  QUIT
 . s liOID=$$renameTag^%zewdDOM("li",nodeOID)
 ;
 s number=$g(mainAttrs("number"))
 s text=$g(mainAttrs("text"))
 s img=$g(mainAttrs("image"))
 i img="" s img=$g(mainAttrs("leftimage"))
 s rightImage=$g(mainAttrs("rightimage"))
 s textStyle=$g(mainAttrs("textstyle"))
 i textStyle="" s textStyle="color:rgb(102,102,102);"
 s liText=""
 i type="text" d
 . s liText=text
 . s attr("style")=textStyle
 s liOID=$$addElementToDOM^%zewdDOM("li",nodeOID,,.attr,liText) 
 ;
 i type="text",img'="" d
 . s imgOID=$$createElement^%zewdDOM("img",docOID)
 . s textOID=$$getFirstChild^%zewdDOM(liOID)
 . s imgOID=$$insertBefore^%zewdDOM(imgOID,textOID)
 . d setAttribute^%zewdDOM("src",img,imgOID)
 ;
 i type="text",rightImage'="" d
 . s attr("src")=rightImage
 . s attr("style")="float:right;"
 . s imgOID=$$addElementToDOM^%zewdDOM("img",liOID,,.attr)
 ;
 ;i type'="text",img'="" d
 ;. s attr("src")=img
 ;. s imgOID=$$addElementToDOM^%zewdDOM("img",liOID,,.attr)
 ;
 i textStyle='"",$e(textStyle,$l(textStyle))'=";" s textStyle=textStyle_";"
 s textStyle=textStyle_"display:inline;" 
 ;
 i type="sms" d
 . n id,onclick
 . s attr("target")="_blank"
 . s attr("style")=textStyle
 . s attr("href")="sms:"_number
 . s aOID=$$addElementToDOM^%zewdDOM("a",liOID,,.attr,text)
 ;
 i type="tel" d
 . n id,onclick
 . s attr("style")=textStyle
 . s attr("href")="tel:"_number
 . s attr("onclick")="iWD.removeActive();"
 . s aOID=$$addElementToDOM^%zewdDOM("a",liOID,,.attr,text)
 ;
 i type'="text",rightImage'="" d
 . s attr("src")=rightImage
 . s attr("style")="float:right;display:inline;"
 . s imgOID=$$addElementToDOM^%zewdDOM("img",aOID,,.attr)
 ;
 i type'="text",img'="" d
 . s attr("src")=img
 . s attr("style")="float:left;display:inline;"
 . s imgOID=$$addElementToDOM^%zewdDOM("img",aOID,,.attr)
 ;
 i $g(mainAttrs("hideif"))'="" d
 . n ifOID,var
 . s ifOID=$$insertNewParentElement^%zewdDOM(liOID,"ewd:if",docOID)
 . s var=mainAttrs("hideif")
 . s var=$p(var,"&php;",2)
 . s var=$g(phpVars(var))
 . s var=$$stripSpaces^%zewdAPI(var)
 . d setAttribute^%zewdDOM("firstvalue",var,ifOID)
 . d setAttribute^%zewdDOM("operation","=",ifOID)
 . d setAttribute^%zewdDOM("secondvalue",0,ifOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
form(nodeOID,attrValue,docOID,technology)
 ;
 n divOID,fsOID
 ;
 ;   <iwd:form />
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"form",docOID)
 d setAttribute^%zewdDOM("method","post",divOID)
 d setAttribute^%zewdDOM("action","ewd",divOID)
 s fsOID=$$insertNewIntermediateElement^%zewdDOM(divOID,"fieldset",docOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
formPanel(nodeOID,attrValue,docOID,technology)
 ;
 n divOID
 ;
 ;   <iwd:formPanel />
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ul",docOID)
 d setAttribute^%zewdDOM("class","pageitem",divOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
formField(nodeOID,attrValue,docOID,technology)
 ;
 n action,attr,color,fieldsize,formOID,iOID,liOID,mainAttrs,multiple
 n name,nextpage,targetId,text,type
 n xtext
 ;
 ;   <iwd:formfield type="text" fieldsize="big" name="username" text="Username" /> 
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s fieldsize=$g(mainAttrs("fieldsize"))
 s color=$g(mainAttrs("color"))
 s type=$g(mainAttrs("type"))
 i type="" s type="text"
 i type="submit"!(type="button") s attr("class")="submitbutton"
 s xtext=""
 i type="toggle" s xtext=$g(mainAttrs("text"))
 i type="radio"!(type="radiobutton") s attr("class")="radiobutton"
 s multiple=0
 i type="multipleselect" s multiple=1,type="select"
 i type="select" s attr("class")="select"
 i type="textarea" s attr("class")="textbox"
 s liOID=$$addElementToDOM^%zewdDOM("li",nodeOID,,.attr,xtext) 
 ;
 s name=$g(mainAttrs("name"))
 i name="" s name=$g(mainAttrs("id"))
 i name="" s name="submit"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 i type="date" d
 . n onClick,fromYear,spanOID,toYear,text
 . s fromYear=$g(mainAttrs("fromyear"))
 . i fromYear="" s fromYear="1900"
 . s toYear=$g(mainAttrs("toyear"))
 . i toYear="" s toYear="2010"
 . s toYear=toYear+1
 . s onClick="iWD.currentPage='"_$p(filename,".ewd",1)_"';"
 . s onClick=onClick_"iWD.blurFields(document.getElementById(iWD.currentPage));"
 . s onClick=onClick_"iWD.openCalendar('"_name_"',"_fromYear_","_toYear_");"
 . d setAttribute^%zewdDOM("onclick",onClick,liOID)
 . s text=$g(mainAttrs("text"))
 . i text="" s text="Missing Text"
 . s spanOID=$$addElementToDOM^%zewdDOM("span",liOID,,,text)
 . s attr("type")="text"
 . s attr("name")=name
 . s attr("value")="*"
 . s attr("readonly")="readonly"
 . s iOID=$$addElementToDOM^%zewdDOM("input",liOID,,.attr)
 ;
 i type="time" d
 . n onClick,spanOID,text
 . s onClick="iWD.currentPage='"_$p(filename,".ewd",1)_"';"
 . s onClick=onClick_"iWD.blurFields(document.getElementById(iWD.currentPage));"
 . s onClick=onClick_"iWD.openTimeSelector('"_name_"');"
 . d setAttribute^%zewdDOM("onclick",onClick,liOID)
 . s text=$g(mainAttrs("text"))
 . i text="" s text="Missing Text"
 . s spanOID=$$addElementToDOM^%zewdDOM("span",liOID,,,text)
 . s attr("type")="text"
 . s attr("name")=name
 . s attr("value")="*"
 . s attr("readonly")="readonly"
 . s iOID=$$addElementToDOM^%zewdDOM("input",liOID,,.attr)
 ;
 i type="text"!(type="password")!(type="number")!(type="tel") d
 . n inputOID
 . s text=$g(mainAttrs("text"))
 . s attr("placeholder")=text
 . s attr("type")=type
 . s attr("name")=name
 . i type="text"!(type="number")!(type="tel") s attr("value")="*"
 . s attr("onclick")="if (iWD.SpinningWheelInUse) {SpinningWheel.close();iWD.SpinningWheelInUse=false}"
 . s iOID=$$addElementToDOM^%zewdDOM("input",liOID,,.attr)  
 ;
 i type="checkbox"!(type="toggle")!(type="radio")!(type="radiobutton") d
 . n class,spanOID
 . ;s class="toggle"
 . i type="radiobutton" s type="radio"
 . ;i type="checkbox" d
 . ;. n click,no
 . ;. d setCheckboxNos(nodeOID)
 . ;;. s no=$$getAttribute^%zewdDOM("checkboxno",nodeOID)
 . ;. ;s click="document.getElementById('"_name_"')["_no_"].checked = !document.getElementById('"_name_"')["_no_"].checked"
 . ;. s click="var cb=iWD.getChildCheckbox(this);cb.checked = !cb.checked"
 . ;. d setAttribute^%zewdDOM("onclick",click,liOID)
 . i type="checkbox" d
 . . s attr("style")="margin-top:5px;margin-bottom:5px;"
 . i type="radio" d
 . . n spanOID
 . . s attr("class")="name"
 . . s text=$g(mainAttrs("text"))
 . . s spanOID=$$addElementToDOM^%zewdDOM("span",liOID,,.attr,text)
 . i type="toggle" d
 . . s attr("class")="toggle"
 . . s liOID=$$addElementToDOM^%zewdDOM("span",liOID,,.attr)
 . . s type="checkbox" k mainAttrs("text")
 . s attr("type")=type
 . s attr("name")=name
 . i type'="radio",$g(mainAttrs("text"))'="" s attr("title")=mainAttrs("text")
 . s attr("value")=$g(mainAttrs("value"))
 . s iOID=$$addElementToDOM^%zewdDOM("input",liOID,,.attr)  
 ;
 i type="select" d
 . n spanOID,textOID
 . ;s attr("class")=type
 . ;s liOID=$$addElementToDOM^%zewdDOM("li",nodeOID,,.attr)
 . s text=$g(mainAttrs("text"))
 . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,liOID)
 . s attr("name")=name
 . i multiple s attr("multiple")="multiple"
 . s iOID=$$addElementToDOM^%zewdDOM("select",liOID,,.attr)  
 . ;s attr("class")="arrow"
 . ;s spanOID=$$addElementToDOM^%zewdDOM("span",liOID,,.attr)  
 ;
 i type="textarea" d
 . n rows,spanOID
 . s text=$g(mainAttrs("titletext"))
 . s attr("class")="header"
 . s spanOID=$$addElementToDOM^%zewdDOM("span",liOID,,.attr,text)  
 . s rows=$g(mainAttrs("rows"))
 . i rows="" s rows=4
 . s attr("name")=name
 . s attr("rows")=rows
 . s iOID=$$addElementToDOM^%zewdDOM("textarea",liOID,,.attr,"*")  
 ;
 i type="submit" d
 . n alertTitle,transition
 . s text=$g(mainAttrs("text"))
 . i text="" s text=$g(mainAttrs("value"))
 . s nextpage=$g(mainAttrs("nextpage"))
 . i nextpage="" s nextpage="missingPage"
 . s targetId=nextpage
 . s action=$g(mainAttrs("action"))
 . i action="" s action=$g(mainAttrs("onsubmitted"))
 . s transition=$g(mainAttrs("transition"))
 . s alertTitle=$g(mainAttrs("alerttitle"))
 . s attr("type")=type
 . s attr("name")=name
 . s attr("value")=text
 . s attr("ajax")="true"
 . s attr("nextpage")=nextpage
 . s attr("targetid")=targetId
 . s attr("iwdtransition")=transition
 . s attr("iwdalerttitle")=alertTitle
 . s attr("style")="height:30px"
 . i action'="" s attr("action")=action
 . s iOID=$$addElementToDOM^%zewdDOM("input",liOID,,.attr)
 . s formOID=$$getFormTag^%zewdDOM(nodeOID)
 . i formOID'="" d
 . . ;s attrValue="this.action='';iWD.blurFields(this);document.getElementById('"_name_"').click(); return false;"
 . . s attrValue="this.action='';document.getElementById('loading').className='loadingOn';iWD.blurFields(this);document.getElementById('"_name_"').click();"
 . . ;s attrValue="this.action='';return false;"
 . . d setAttribute^%zewdDOM("onsubmit",attrValue,formOID) 
 ;
 i type="button" d
 . s text=$g(mainAttrs("text"))
 . i text="" s text=$g(mainAttrs("value"))
 . s attr("type")=type
 . s attr("name")=name
 . s attr("value")=text
 . s attr("style")="height:30px"
 . s attr("ontouchstart")="document.getElementById('loading').className='loadingOn';"
 . s iOID=$$addElementToDOM^%zewdDOM("input",liOID,,.attr)
 ;
 s attr=""
 f  s attr=$o(mainAttrs(attr)) q:attr=""  d
 . i attr="type"!(attr="name")!(attr="transition")!(attr="text")!(attr="value")!(attr="nextpage")!(attr="targetid")!(attr="fieldsize")!(attr="id")!(attr="action")!(attr="onsubmitted")!(attr="color") q
 . d setAttribute^%zewdDOM(attr,mainAttrs(attr),iOID) 
 ;
 i color'="" d setAttribute^%zewdDOM("style","background-color:"_color,iOID) 
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
setCheckboxNos(nodeOID)
 ;
 n checkboxNo,name,no,nodesArray,parentOID,stop,xOID
 ;
 i $$getAttribute^%zewdDOM("checkboxno",nodeOID)'="" QUIT
 s name=$$getAttribute^%zewdDOM("name",nodeOID)
 i name="" s name=$$getAttribute^%zewdDOM("id",nodeOID)
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 d getChildrenInOrder^%zewdDOM(parentOID,.nodesArray)
 s no="",stop=0
 s checkboxNo=-1
 f  s no=$o(nodesArray(no)) q:no=""  d  q:stop
 . s xOID=nodesArray(no)
 . i $$getAttribute^%zewdDOM("name",xOID)'=name q
 . i $$getAttribute^%zewdDOM("type",xOID)'="checkbox" q
 . s checkboxNo=checkboxNo+1
 . d setAttribute^%zewdDOM("checkboxno",checkboxNo,xOID)
 QUIT
 ;
title(nodeOID,attrValue,docOID,technology)
 ;
 n mainAttrs,textOID,title,zewdOID
 ;
 ; <iwd:title text="New Title" />
 ;
 s zewdOID=$$createZewdNode("title",docOID)
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s title=$g(mainAttrs("text"))
 i title="" s title="Missing Title Text"
 s textOID=$$createTextNode^%zewdDOM(title,docOID)
 s textOID=$$appendChild^%zewdDOM(textOID,zewdOID)
 i $$removeChild^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
footer(nodeOID,attrValue,docOID,technology)
 ;
 n divOID,footerId,id,jsOID,lineOID,text
 ;
 ; <iwd:footer>
 ;   New footer text
 ; </iwd:footer>
 ;
 s id=$p(filename,".ewd",1)_"-footerText"
 s footerId=$p(filename,".ewd",1)_"-content-footer"
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
 d setAttribute^%zewdDOM("style","display:none",divOID)
 d setAttribute^%zewdDOM("id",id,divOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n configOID,nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 s text="document.getElementById('"_footerId_"').innerHTML=document.getElementById('"_id_"').innerHTML;"
 s text=text_"iWD.footerContent=document.getElementById('"_id_"').innerHTML;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s isIwd=1
 QUIT
 ;
toolbar(nodeOID,attrValue,docOID,technology)
 ;
 n divOID,fcOID,hOID,mainAttrs,textOID,title,titleId
 n jsOID,lineOID,text
 ;
 ; <iwd:toolbar title="Toolbar Title">
 ;   button tags
 ; </iwd:footer>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s title=$g(mainAttrs("title"))
 s titleId=$p(filename,".ewd",1)_"-toolbarTitle"
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n configOID,nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 s text="var h1=document.getElementById('"_titleId_"');"
 s text=text_"var oldText=h1.firstChild;"
 s text=text_"h1.removeChild(oldText);"
 i title="" d
 .  s text=text_"var newText=document.createTextNode(iWD.toolbarTitle);"
 e  d
 . s text=text_"var newText=document.createTextNode('"_title_"');"
 s text=text_"h1.appendChild(newText);"
 i title'="" s text=text_"iWD.toolbarTitle='"_title_"';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ; 
 ;do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;s title=$g(mainAttrs("title"))
 ;s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
 ;;d setAttribute^%zewdDOM("class","toolbar",divOID)
 ;;
 ;s fcOID=$$getFirstChild^%zewdDOM(divOID)
 ;s hOID=$$createElement^%zewdDOM("h1",docOID)
 ;i fcOID'="" d
 ;. s hOID=$$insertBefore^%zewdDOM(hOID,fcOID)
 ;e  d
 ;. s hOID=$$appendChild^%zewdDOM(hOID,divOID) 
 ;s textOID=$$createTextNode^%zewdDOM(title,docOID)
 ;s textOID=$$appendChild^%zewdDOM(textOID,hOID)
 ;;
 ;d removeIntermediateNode^%zewdDOM(nodeOID)
 ;s isIwd=1
 ;QUIT
 ;
toolbarbutton(nodeOID,attrValue,docOID,technology)
 ;
 n aOID,attr,lineOID,mainAttrs,nodes,OIDArray,ok,page,stop,target,text,transition,type,zewdOID,zOID
 ;
 ; <iwd:toolbarButton type="back" text="Return" />
 ;
 s page=$p(filename,".ewd",1)
 s ok=$$getElementsByTagName^%zewdDOM("zewd",docOID,.nodes)
 s zOID="",stop=0
 f  s zOID=$o(nodes(zOID)) q:zOID=""  d  q:stop
 . s target=$$getAttribute^%zewdDOM("target",zOID)
 . i target=(page_"-toolbarButtons") s stop=1
 i 'stop d
 . s zewdOID=$$createZewdNode(page_"-toolbarButtons",docOID)
 e  d
 . s zewdOID=zOID
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type"))
 s transition=$g(mainAttrs("transition"))
 i transition="",$g(mainAttrs("onclick"))'="",type'="back" s transition="dummy"
 i transition="",type="back" d
 . n onclick
 . s onclick=$g(mainAttrs("onclick"))
 . s attr("class")="button back"
 . s attr("onmousedown")="if (iWD.lastForwardButton) {iWD.lastForwardButton.className='button'};"
 . i onclick="" d
 . . s attr("href")="#"
 . e  d
 . . s attr("href")="javascript:return true;"
 . . s attr("onmousedown")=attr("onmousedown")_onclick
 . . ;s attr("onmousedown")=onclick
 . s text=$g(mainAttrs("text"))
 . i text="" s text="Back"
 . s aOID=$$addElementToDOM^%zewdDOM("a",zewdOID,,.attr,text)
 ;
 i transition'="" d
 . n class,fetchOnce,onclick,nextpage,reverse,text
 . s onclick=$g(mainAttrs("onclick"))
 . s addEvent=$g(mainAttrs("addevent"))
 . i addEvent'="",$e(addEvent,$l(addEvent))'=";" s addEvent=addEvent_";"
 . s nextpage=$g(mainAttrs("nextpage"))
 . s fetchOnce=$g(mainAttrs("fetchonce"))
 . i fetchOnce="" s fetchOnce="false"
 . s text=$g(mainAttrs("text"))
 . i type="back" s text="Back"
 . ;s attr("class")="button "_transition
 . s class="button"
 . i type="back" s class="button back"
 . s attr("class")=class
 . s reverse="false"
 . i type="back" s reverse="true"
 . ;s attr("onmousedown")="alert(1);iWD.onTap('"_nextpage_"',"_fetchOnce_");alert(2);jQT.goTo('#"_nextpage_"','"_transition_"');"
 . i onclick="" d
 . . ;s attr("onmousedown")="jQT.goTo('#"_nextpage_"','"_transition_"',"_reverse_");iWD.onTap('"_nextpage_"',"_fetchOnce_");iWD.lastButton=this;if (iWD.lastBackButton) {iWD.lastBackButton.className='button back';};"
 . . s attr("onmousedown")=addEvent_"jQT.goTo('#"_nextpage_"','"_transition_"',"_reverse_");iWD.onTap('"_nextpage_"',"_fetchOnce_");iWD.lastForwardButton=this;"
 . e  d
 . . s attr("onmousedown")=onclick
 . s attr("ontouchstart")="document.getElementById('loading').className='loadingOn';"
 . s attr("href")="javascript:return true;" ;_nextpage
 . ;s attr("onclick")="alert(1)" ;iWD.onTap('"_nextpage_"',"_fetchOnce_");"
 . s aOID=$$addElementToDOM^%zewdDOM("a",zewdOID,,.attr,text)
 . i nextpage'="" d
 . . s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 . . i jsOID="" d
 . . . n configOID,nsOID
 . . . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . . . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . . . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 . . s text="iWD.loadFragment['"_nextpage_"'] = function() {"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . . s text="ewd.ajaxRequest('"_nextpage_"','"_nextpage_"-content-body') ;"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . . s text="};"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . . s text="iWD.createNewPage('"_nextpage_"');"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 i $g(mainAttrs("hideif"))'="" d
 . n ifOID,var
 . s ifOID=$$insertNewParentElement^%zewdDOM(aOID,"ewd:if",docOID)
 . s var=mainAttrs("hideif")
 . s var=$p(var,"&php;",2)
 . s var=$g(phpVars(var))
 . s var=$$stripSpaces^%zewdAPI(var)
 . d setAttribute^%zewdDOM("firstvalue",var,ifOID)
 . d setAttribute^%zewdDOM("operation","=",ifOID)
 . d setAttribute^%zewdDOM("secondvalue",0,ifOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
createZewdNode(target,docOID)
 ;
 n fcOID,zewdOID
 ;
 s fcOID=$$getFirstChild^%zewdDOM(docOID)
 s zewdOID=$$createElement^%zewdDOM("zewd",docOID)
 s zewdOID=$$insertBefore^%zewdDOM(zewdOID,fcOID)
 d setAttribute^%zewdDOM("target",target,zewdOID)
 s isIwd=1
 QUIT zewdOID
 ;
navButton(nodeOID,attrValue,docOID,technology)
 ;
 n childNo,childOID,mainAttrs,OIDArray,position,tagName,zewdOID
 ;
 ; <iwd:navButton position="left">
 ;   <iwd:button
 ;     nextpage="mainmenu" 
 ;     targetId="content" 
 ;     alt="home" 
 ;     image="/iwd/images/home.png" 
 ; or  home="true" for the home image
 ; or  text="Compiler"
 ;   />
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s position=$g(mainAttrs("position"))
 i position="" s position="left"
 ;
 s zewdOID=$$createZewdNode(position_"nav",docOID)
 ; 
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="iwd:button" d
 . . d button(childOID,zewdOID)
 . e  d
 . . n xOID
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . d appendChild^%zewdDOM(childOID,zewdOID)
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 ;
 s isIwd=1
 QUIT
 ;
button(nodeOID,zewdOID)
 ;
 n alt,aOID,attr,buttonText,home,image,imgOID,mainAttrs,page,phpVar
 n suppressIf,targetId
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s suppressIf=$g(mainAttrs("suppressif"))
 i suppressIf'="" d
 . n ifOID,no
 . s no=$p(suppressIf,"&php;",2)
 . s suppressIf=$g(phpVars(no))
 . s suppressIf=$$stripSpaces^%zewdAPI(suppressIf)
 . s ifOID=$$insertNewParentElement^%zewdDOM(zewdOID,"ewd:if",docOID)
 . d setAttribute^%zewdDOM("firstvalue",suppressIf,ifOID)
 . d setAttribute^%zewdDOM("operation","!=",ifOID)
 . d setAttribute^%zewdDOM("secondvalue",1,ifOID)
 s image=$g(mainAttrs("image"))
 s alt=$g(mainAttrs("alt"))
 s buttonText=$g(mainAttrs("text"))
 s page=$g(mainAttrs("nextpage"))
 i page="" s page="missingPage" 
 s targetId=$g(mainAttrs("targetid"))
 i targetId="" s targetId="content"
 s home=$g(mainAttrs("home"))
 s phpVar=$$addPhpVar^%zewdCustomTags("#iwd_rootPath")
 i home="true" s image=phpVar_"images/home.png",alt="home"
 ;
 s attr("href")="#"
 s attr("event")="onclick"
 s attr("ajaxpage")=page
 s attr("targetid")=targetId
 s aOID=$$addElementToDOM^%zewdDOM("a",zewdOID,,.attr,buttonText)
 ;
 i image'="" d
 . i alt'="" s attr("alt")=alt
 . s attr("src")=image
 . s imgOID=$$addElementToDOM^%zewdDOM("img",aOID,,.attr) 
 ;
 s isIwd=1
 QUIT
 ;
findZewdNode(target,docOID)
 ;
 n nodes,OIDArray,ok,stop,zOID,zTarget
 ;
 s ok=$$getElementsByTagName^%zewdDOM("zewd",docOID,.nodes)
 s zOID="",stop=0
 f  s zOID=$o(nodes(zOID)) q:zOID=""  d  q:stop
 . s zTarget=$$getAttribute^%zewdDOM("target",zOID)
 . i zTarget=target s stop=1
 QUIT zOID
 ;
tabPanel(nodeOID,attrValue,docOID,technology)
 ;
 n attr,childNo,childOID,divOID,jsOID,lineOID,mainAttrs,OIDArray
 n page,panelId,tagName,text,zdivOID
 ;
 ; <iwd:tabPanel>
 ;   <iwd:tab text="Tab1" nextpage="tab1" />
 ;   <iwd:tab text="Tab2" nextpage="tab2" />
 ;   <iwd:tab text="Tab3" nextpage="tab3" />
 ;   <iwd:tab text="Tab4" nextpage="tab4" />
 ; </iwd:tabPanel>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s page=$p(filename,".ewd",1)
 s zewdOID=$$createZewdNode(page_"-tabbar",docOID)
 s attr("class")="tab"
 s zdivOID=$$addElementToDOM^%zewdDOM("div",zewdOID,,.attr)
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n configOID,nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 s panelId=page_"-tabpanel"
 s attr("id")=panelId
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr) 
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="iwd:tab" q
 . d tab(childOID,zdivOID,jsOID,panelId,page)
 ;
 s attr("class")="tabborder"
 s divOID=$$addElementToDOM^%zewdDOM("div",zewdOID,,.attr) 
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
tab(nodeOID,zDivOID,jsOID,panelId,page)
 ;
 n aOID,attr,lineOID,mainAttrs,nextPage,selected,tabNo,text
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s text=$g(mainAttrs("text"))
 s selected=$g(mainAttrs("selected"))
 s nextPage=$g(mainAttrs("nextpage"))
 ;
 s tabNo=$p(nodeOID,"-",2)
 s attr("id")="tab-"_tabNo
 s attr("onclick")="iWD.getTab"_tabNo_"(this);"
 i selected="true" s attr("class")="pressed"
 s text="&nbsp;&nbsp;"_text_"&nbsp;&nbsp;"
 s aOID=$$addElementToDOM^%zewdDOM("a",zDivOID,,.attr,text) 
 ;
 s text="iWD.getTab"_tabNo_" = function(obj) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="if (iWD.currentTab != obj.id) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="iWD.switchTab(obj);"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="ewd.ajaxRequest("""_nextPage_""","""_panelId_""");"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="document.getElementById('"_page_"-content').style.webkitTransform = 'translate3d(0,0,0)';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="}"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 i selected="true" d
 . s text="iWD.currentTab='tab-"_tabNo_"';"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . s text="ewd.ajaxRequest("""_nextPage_""","""_panelId_""");"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
redirect(nodeOID,attrValue,docOID,technology)
 ;
 n childNo,childOID,jsOID,mainAttrs,OIDArray,tagName
 ;
 ; <iwd:redirect>
 ;   <iwd:test name="isPasswordProtected" value="0" page="mainMenu" />
 ; </iwd:redirect>
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n configOID,nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="iwd:test" q
 . d iwdtest(childOID,jsOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
iwdtest(nodeOID,jsOID)
 ;
 n mainAttrs,page,phpVar,value,varName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s varName=$g(mainAttrs("name"))
 s value=$g(mainAttrs("value"))
 s page=$g(mainAttrs("page"))
 ;
 s phpVar=$$addPhpVar^%zewdCustomTags("#"_varName)
 s text="var test='"_phpVar_"';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="if (test=='"_value_"'){"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="iWD.createNewPage('"_page_"');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="ewd.ajaxRequest('"_page_"','"_page_"-content-body');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="jQT.goTo('#"_page_"');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="}"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
bottomTabBar(nodeOID,attrValue,docOID,technology)
 ;
 n attr,childNo,childOID,jsOID,lineOID,mainAttrs,noOfTabs,OIDArray
 n tagName,text,zdivOID,zewdOID
 ;
 ; <iwd:bottomTabBar>
 ;   <iwd:bottomTab text="Home" iconSelected="/iwd/images/icon_home.png" iconUnselected="/iwd/images/icon_home.png" selected="true" nextPage="home" />
 ;   <iwd:bottomTab text="About" iconSelected="/iwd/images/icon_information.png" iconUnselected="/iwd/images/icon_information.png" selected="true" nextPage="home" transition="slideUp" />
 ; </iwd:bottomTabBar>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s page=$p(filename,".ewd",1)
 s zewdOID=$$createZewdNode(page_"-bottomToolbar",docOID)
 s attr("class")="tabbar"
 s zdivOID=$$addElementToDOM^%zewdDOM("div",zewdOID,,.attr)
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 s text="document.getElementById("""_page_"-content-scrollWrapper"").style.height = '366px';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 s text="iWD.selectBottomTab = function(obj) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text) 
 s text="currentlySelected = iWD.selectedBottomTab;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text) 
 s text="if (currentlySelected != obj.id) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text) 
 s text="document.getElementById(currentlySelected).className='bottomTabUnselected';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="obj.className='bottomTabSelected';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="iWD.selectedBottomTab=obj.id;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="}"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text) 
 s text="};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text) 
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo="",noOfTabs=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s noOfTabs=noOfTabs+1
 s pc=(100\noOfTabs)-1
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="iwd:bottomtab" q
 . d bottomTab(childOID,zdivOID,jsOID,page,pc)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 s isIwd=1
 QUIT
 ;
bottomTab(nodeOID,zDivOID,jsOID,page,percent)
 ;
 n aOID,attr,class,iconSelected,iconUnselected,id,iOID,lineOID,mainAttrs,nextPage
 n selected,targetId,text,textOID,transition
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s text=$g(mainAttrs("text"))
 s iconSelected=$g(mainAttrs("icon"))
 s iconUnselected=$g(mainAttrs("icon"))
 i $g(mainAttrs("iconselected"))'="" s iconSelected=mainAttrs("iconselected")
 i $g(mainAttrs("iconunselected"))'="" s iconUnselected=mainAttrs("iconunselected")
 s selected=$g(mainAttrs("selected"))
 s nextPage=$g(mainAttrs("nextpage"))
 s transition=$g(mainAttrs("transition"))
 ;
 s id="Btab"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s class="bottomTabUnselected"
 i selected="true" s class="bottomTabSelected"
 s attr("id")=id
 s attr("class")=class
 s attr("href")="javascript:false;"
 s attr("style")="width:"_percent_"%"
 s attr("ontouchstart")="iWD.get"_id_"(this);"
 s aOID=$$addElementToDOM^%zewdDOM("a",zDivOID,,.attr)
 s attr("src")=iconUnselected
 i selected="true" s attr("src")=iconSelected
 s attr("class")="bottomTabIcon"
 s iOID=$$addElementToDOM^%zewdDOM("img",aOID,,.attr)
 s textOID=$$createTextNode^%zewdDOM(text,docOID)
 s textOID=$$appendChild^%zewdDOM(textOID,aOID)
 ;
 i selected="true" d
 . s text="iWD.selectedBottomTab='"_id_"' ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text) 
 s targetId=page_"-content-body"
 s text="iWD.get"_id_" = function(obj) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="if (iWD.selectedBottomTab != obj.id) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 i transition="" s transition="none"
 s targetId=page_"-content-body"
 i transition'="none" d
 . s targetId=nextPage_"-content-body"
 . s text="iWD.createNewPage('"_nextPage_"');"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 . s text="jQT.goTo('#"_nextPage_"','"_transition_"',false);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="ewd.ajaxRequest("""_nextPage_""","""_targetId_""");"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="}"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="iWD.selectBottomTab(obj);"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s text="};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
manifest(sessid)
 n appName,delim,files,inputPath,name,technology
 ;
 s appName=$$getSessionValue^%zewdAPI("ewd_appName",sessid)
 d mergeArrayFromSession^%zewdAPI(.files,"ewd_manifest",sessid)
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
expandPageToURL(name,appName,technology,sessid)
 ;
 i technology="wl" d
 . n mgwlpn
 . s mgwlpn=$$getSessionValue^%zewdAPI("ewd_mgwlpn",sessid)
 . i mgwlpn="" s mgwlpn="LOCAL"
 . s url=$$getRootURL^%zewdCompiler("wl")_"?MGWLPN="_mgwlpn_"&MGWAPP=ewdwl&app="_appName_"&page="_$p(name,".ewd",1)
 QUIT url
 ;
