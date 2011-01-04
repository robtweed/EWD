%zewdST2 ; Sencha Touch Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 834)
 ; Build Date: Tue, 04 Jan 2011 22:40:13
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
container(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n attr,bodyOID,childNo,childOID,contentPage,debug,funcOID,headOID,htmlOID
 n images,jsOID,jsText,locale,mainAttrs,OIDArray,path,resourcePath,rootPath
 n tagName,text,title,xOID
 ;
 ;<st:container rootPath="/sencha-1.0/" contentPage="intro" title="ST Demo App">
 ;  <st:images>
 ;    <st:image type="tabletStartupScreen" src=/images/tablet_startup.png" />
 ;    <st:image type="phoneStartupScreen" src="/images/phone_startup.png" />
 ;    <st:image type="icon" src="/images/icon.png" addGloss="true" />
 ;  </st:images>
 ;</st:container>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s contentPage=$g(mainAttrs("contentpage"))
 i contentPage="" s contentPage="pageNotDefined"
 s title=$g(mainAttrs("title"))
 i title="" s title="EWD/Sencha Touch Application"
 s rootPath=$g(mainAttrs("rootpath"))
 i rootPath="" s rootPath="/sencha/"
 s rootPath=$$addSlashAtEnd^%zewdST(rootPath)
 s debug=$g(mainAttrs("debug"))
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:images" d images(childOID,.images)
 . i tagName="st:locale" d locale(childOID,.locale)
 ;
 s htmlOID=$$addElementToDOM^%zewdDOM("ewd:xhtml",nodeOID)
 ; head
 s headOID=$$addElementToDOM^%zewdDOM("head",htmlOID)
 ;
 s attr("http-equiv")="Content-Type"
 s attr("content")="text/html; charset=utf-8"
 s xOID=$$addElementToDOM^%zewdDOM("meta",headOID,,.attr)
 ;
 s xOID=$$addElementToDOM^%zewdDOM("title",headOID,,,title)
 ;
 s attr("rel")="stylesheet"
 s attr("type")="text/css"
 s attr("href")=rootPath_"resources/css/sencha-touch.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr)
 ;
 s attr("type")="text/javascript"
 s attr("src")=rootPath_"sencha-touch.js"
 i debug="true" s attr("src")=rootPath_"sencha-touch-debug.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 d createJSFile^%zewdST("stJS","ewdSTJS.js")
 s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 s path=$$addSlashAtEnd^%zewdST(path)
 s attr("type")="text/javascript"
 s attr("src")=path_"ewdSTJS.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="script" d
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,headOID)
 ;
 s attr("type")="text/javascript"
 s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s text=""
 s text=text_"Ext.setup({"
 s text=text_"tabletStartupScreen:'"_images("tabletStartupScreen","src")_"',"
 s text=text_"phoneStartupScreen:'"_images("phoneStartupScreen","src")_"',"
 s text=text_"icon:'"_images("icon","src")_"',"
 s text=text_"addGlossToIcon:"_images("icon","addgloss")_","
 s text=text_"onReady:function(){"
 s text=text_"EWD.sencha.loadContentPage()"
 s text=text_"}"
 s text=text_"});"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 s attr("return")="EWD.sencha.loadContentPage"
 s attr("addVar")="false"
 s attr("parameters")=""
 s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",jsOID,,.attr)
 ;
 s jsText=""
 i $g(locale("dateformat"))'="" s jsText=jsText_"Ext.util.Format.defaultDateFormat='"_locale("dateformat")_"';"_$c(13,10)
 s jsText=jsText_"ewd.ajaxRequest("""_contentPage_""",""ewdContent"");"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",funcOID,,,jsText)
 ;
 ;s attr("onLoad")="EWD.sencha.loadContentPage();"
 s bodyOID=$$addElementToDOM^%zewdDOM("body",htmlOID,,.attr)
 ;
 s attr("id")="ewdNullId"
 s attr("style")="display:none"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 s attr("id")="ewdContent"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
images(nodeOID,images)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:image" d image(childOID,.images)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
image(nodeOID,images)
 ;
 ;    <st:image type="tabletStartupScreen" src=/images/tablet_startup.png" />
 ;    <st:image type="phoneStartupScreen" src="/images/phone_startup.png" />
 ;    <st:image type="icon" src="/images/icon.png" addGloss="true" />
 ;
 n mainAttrs,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("type"))="" QUIT
 s type=mainAttrs("type")
 i $g(mainAttrs("src"))="" QUIT
 i type="icon",$g(mainAttrs("addgloss"))="" s mainAttrs("addgloss")="false"
 m images(type)=mainAttrs
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
locale(nodeOID,images)
 ;
 ;    <st:locale dateFormat="d/m/Y" />
 ;
 n mainAttrs,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 m locale=mainAttrs
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
