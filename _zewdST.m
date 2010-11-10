%zewdST ; Sencha Touch Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 830)
 ; Build Date: Wed, 10 Nov 2010 13:15:10
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-10 M/Gateway Developments Ltd,                        |
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
uui(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n appTitle,attr,bodyOID,childNo,childOID,debug,headOID,htmlOID,images,jsText
 n launchScreen,launchScreenId,line,lineNo
 n mainAttrs,navigationMenu,nullId,OIDArray,panelHeight,panelWidth,path
 n resourcePath,rootPath,tagName,text,uiPath,xOID
 ;
 ; <st:universalUI rootPath="/sencha/" resourcePath="resources/" uiPath="examples/kitchensink/">
 ;   <st:UUIappTitle phone="Sink" tablet="Kitchen Sink" />
 ;   <st:UUIlaunchscreen src="intro.ewd" login="true"/>
 ;   <st:UUInavigationMenu buttonText="Navigation" src="mainMenu.ewd">
 ;   <st:UUIimages>
 ;     <st:UUIimage type="tabletStartupScreen" src="resources/img/tablet_startup.png" />
 ;     <st:UUIimage type="phoneStartupScreen" src="resources/img/phone_startup.png" />
 ;     <st:UUIimage type="icon" src="resources/img/icon.png" addGloss="true" />
 ;   </st:UUIimages>
 ; </st:universalUI>
 ;
 ; Constants:
 ;
 s nullId="st-uui-nullId"
 s launchScreenId="st-uui-launchScreenContents"
 s panelWidth=500
 s panelHeight=500
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s rootPath=$g(mainAttrs("rootpath"))
 i rootPath="" s rootPath="/sencha/"
 s rootPath=$$addSlashAtEnd(rootPath)
 s resourcePath=$g(mainAttrs("resourcepath"))
 i resourcePath="" s resourcePath="resources/"
 s resourcePath=$$addSlashAtEnd(resourcePath)
 s uiPath=$g(mainAttrs("uipath"))
 i uiPath="" s uiPath="examples/kitchensink/"
 s uiPath=$$addSlashAtEnd(uiPath)
 s debug=$g(mainAttrs("debug"))
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:uuiapptitle" d uuiAppTitle(childOID,.appTitle) q
 . i tagName="st:uuilaunchscreen" d uuiLaunchScreen(childOID,.launchScreen) q
 . i tagName="st:uuinavigationmenu" d uuiNavigationMenu(childOID,.navigationMenu) q
 . i tagName="st:uuiimages" d uuiImages(childOID,.images)
 ;
 s htmlOID=$$addElementToDOM^%zewdDOM("ewd:xhtml",nodeOID)
 ; head
 s headOID=$$addElementToDOM^%zewdDOM("head",htmlOID)
 ;
 s attr("http-equiv")="Content-Type"
 s attr("content")="text/html; charset=utf-8"
 s xOID=$$addElementToDOM^%zewdDOM("meta",headOID,,.attr)
 ;
 s xOID=$$addElementToDOM^%zewdDOM("title",headOID,,,appTitle("tablet"))
 ;
 s attr("rel")="stylesheet"
 s attr("type")="text/css"
 s attr("href")=rootPath_resourcePath_"css/ext-touch.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr)
 ;
 s attr("rel")="stylesheet"
 s attr("type")="text/css"
 s attr("href")=rootPath_uiPath_"resources/css/sink.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr)
 ;
 s attr("rel")="stylesheet"
 s attr("type")="text/css"
 s attr("href")=rootPath_uiPath_"resources/css/codebox.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr)
 ;
 s text=".stBlueHighlight {height:44px;background-image: -webkit-gradient(linear, 0% 0, 0% 100%, from(#76B7EF), color-stop(0.02, #1C87E3), to(#135F9F));border-bottom-color: #0B365B;border-top-color: #105189;color: white;text-shadow: rgba(0, 0, 0, 0.496094) 0px 1px 0px;padding:10px 0 10px 10px;}"
 ;s text=".stBlueHighlight {background-image: -webkit-gradient(linear, 0% 0, 0% 100%, from(#76B7EF), color-stop(0.02, #1C87E3), to(#135F9F));border-bottom-color: #0B365B;border-top-color: #105189;color: white;text-shadow: rgba(0, 0, 0, 0.496094) 0px 1px 0px;padding:10px 0 10px 10px;height:30px}"
 s attr("type")="text/css"
 s xOID=$$addElementToDOM^%zewdDOM("style",headOID,,.attr,text)
 ;
 s attr("type")="text/javascript"
 s attr("src")=rootPath_"ext-touch.js"
 i debug="true" s attr("src")=rootPath_"ext-touch-debug.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s attr("type")="text/javascript"
 s attr("src")=rootPath_uiPath_"src/CodeBox.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s attr("language")="javascript"
 s text="EWD.isLogin = "_launchScreen("login")_";"_$c(13,10)
 ;
 s text=text_"EWD.senchaStartup={"
 s text=text_"tabletStartupScreen:'"_rootPath_uiPath_images("tabletStartupScreen","src")_"'"
 s text=text_",phoneStartupScreen:'"_rootPath_uiPath_images("phoneStartupScreen","src")_"'"
 s text=text_",icon:'"_rootPath_uiPath_images("icon","src")_"'"
 s text=text_",addGlossToIcon:'"_images("icon","addgloss")_"'"
 s text=text_"};"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
 ;
 s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 s path=$$addSlashAtEnd(path)
 s attr("type")="text/javascript"
 s attr("src")=path_"ewdST.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s jsText=""
 f lineNo=1:1 s line=$t(uiJS+lineNo) q:line["***END***"  d
 . s line=$p(line,";;",2,200)
 . s line=$$replace^%zewdAPI(line,"<navigationMenu>",navigationMenu("src"))
 . s line=$$replace^%zewdAPI(line,"<launchPage>",launchScreen("src"))
 . i line["<login>" d  q:line=""
 . . i launchScreen("login")="true" s line=" setTimeout('EWD.sencha.navigationOff()',1000);" q
 . . i launchScreen("login")="false" d  q
 . . . s line=" setTimeout('EWD.sencha.noLoginMode("""_navigationMenu("buttontext")_""")',1000);"_$c(13,10)
 . . . s line=line_"ewd.ajaxRequest("""_navigationMenu("src")_""",""st-uui-nullId"");"
 . . s line=""
 . i line["<islogin>" s line=$$replace^%zewdAPI(line,"<islogin>",launchScreen("login"))
 . s line=$$replace^%zewdAPI(line,"<rootPath>",rootPath)
 . s line=$$replace^%zewdAPI(line,"<uiPath>",uiPath)
 . s line=$$replace^%zewdAPI(line,"<tabletScreen>",images("tabletStartupScreen","src"))
 . s line=$$replace^%zewdAPI(line,"<phoneScreen>",images("phoneStartupScreen","src"))
 . s line=$$replace^%zewdAPI(line,"<icon>",images("icon","src"))
 . s line=$$replace^%zewdAPI(line,"<addGloss>",images("icon","addgloss"))
 . s line=$$replace^%zewdAPI(line,"<phoneTitle>",appTitle("phone"))
 . s line=$$replace^%zewdAPI(line,"<tabletTitle>",appTitle("tablet"))
 . s line=$$replace^%zewdAPI(line,"<navigationButtonText>",navigationMenu("buttontext"))
 . s line=$$replace^%zewdAPI(line,"<nullId>",nullId)
 . s line=$$replace^%zewdAPI(line,"<launchScreenId>",launchScreenId)
 . s line=$$replace^%zewdAPI(line,"<panelWidth>",panelWidth)
 . s line=$$replace^%zewdAPI(line,"<panelHeight>",panelHeight)
 . s jsText=jsText_line_$c(13,10)
 s attr("language")="javascript"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,jsText)
 ;
 s attr("onLoad")="setTimeout('EWD.sencha.loadMenu()',1500);" 
 s bodyOID=$$addElementToDOM^%zewdDOM("body",htmlOID,,.attr)
 ;
 s jsOID=$$errorHandler^%zewdCompiler(docName,technology)
 ;
 s attr("id")=nullId
 s attr("style")="display:none"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 s attr("id")=launchScreenId
 s attr("style")="display:none"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 d createJSFile
 QUIT
 ;
createJSFile ;
 ;
 n delim,filePath,io,line,lineNo,outputPath
 ;
 s outputPath=$g(^zewd("config","jsScriptPath",technology,"outputPath"))
 s delim=$$getDelim^%zewdAPI()
 i $e(outputPath,$l(outputPath))'=delim s outputPath=outputPath_delim
 s filePath=outputPath_"ewdST.js"
 s io=$io
 i '$$openNewFile^%zewdCompiler(filePath) q
 u filePath
 f lineNo=1:1 s line=$t(ewdST+lineNo^%zewdSTJS) q:line["***END***"  d
 . s line=$p(line,";;",2,200)
 . w line_$c(10)
 c filePath u io
 ;
 QUIT
 ;
uuiAppTitle(nodeOID,mainAttrs)
 ;
 ;  <st:UUIappTitle phone="Sink" tablet="Kitchen Sink" />
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("tablet"))="" s mainAttrs("tablet")="Unamed Application"
 i $g(mainAttrs("phone"))="" s mainAttrs("phone")="Unamed"
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
uuiLaunchScreen(nodeOID,mainAttrs)
 ;
 ;  <st:UUIlaunchscreen src="intro.ewd" login="true"/>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("src"))="" s mainAttrs("src")="missingLaunchPage"
 i $g(mainAttrs("src"))[".ewd" s mainAttrs("src")=$p(mainAttrs("src"),".ewd",1)
 i $g(mainAttrs("login"))'="true" s mainAttrs("login")="false"
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
uuiNavigationMenu(nodeOID,mainAttrs)
 ;
 ;  <st:UUInavigationMenu buttonText="Navigation" src="mainMenu.ewd">
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i $g(mainAttrs("buttontext"))="" s mainAttrs("buttontext")="Navigation"
 i $g(mainAttrs("src"))="" s mainAttrs("src")="missingNavigationMenuPage"
 i $g(mainAttrs("src"))[".ewd" s mainAttrs("src")=$p(mainAttrs("src"),".ewd",1)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
uuiImages(nodeOID,images)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:uuiimage" d uuiImage(childOID,.images)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
uuiImage(nodeOID,images)
 ;
 ;  <st:UUIimage type="tabletStartupScreen" src="resources/img/tablet_startup.png" />
 ;  <st:UUIimage type="phoneStartupScreen" src="resources/img/phone_startup.png" />
 ;  <st:UUIimage type="icon" src="resources/img/icon.png" addGloss="true" />
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
uuiMenu(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n attr,childNo,childOID,firstMenuItemFound,jsNVPOID,jsObjOID,jsOID,jsSetOID
 n mainAttrs,OIDArray,scriptOID,tagName
 ;
 ; <st:UUIMenu>
 ;  <st:menuItem text="User Interface">
 ;     <st:menuItem text="Buttons" src="buttons.ewd">
 ;       <st:toolbarButton text="Test">
 ;          <st:popupPanel src="hello.ewd" scroll="both" width="300" height="300" animation="slide" />
 ;       </st:toolbarButton>
 ;     </st:menuItem>
 ;  </st:menuItem>
 ;  etc...
 ; </st:UUIMenu>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 s jsOID=$$insertBefore^%zewdDOM(jsOID,nodeOID)
 s attr("return")="EWD.sencha.mainMenu"
 s attr("type")="array"
 s jsSetOID=$$addElementToDOM^%zewdDOM("ewd:jsset",jsOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 s firstMenuItemFound=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:menuitem" d
 . . s jsObjOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jsSetOID)
 . . i 'firstMenuItemFound d
 . . . s attr("name")="id"
 . . . s attr("value")="menuOption0"
 . . . s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsObjOID,,.attr)
 . . . s attr("name")="cls"
 . . . s attr("value")="launchscreen"
 . . . s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsObjOID,,.attr)
 . . . s firstMenuItemFound=1
 . . d uuiMenuItem(childOID,jsObjOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT 
 ;
uuiMenuItem(nodeOID,parentOID)
 ;
 n animation,attr,childNo,childOID,itemsAdded,jsNVPOID,mainAttrs,OIDArray
 n preventHide,showPageOnPhone,src,tagName,text,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s text=$g(mainAttrs("text"))
 i text="" s text="Undefined option"
 s src=$g(mainAttrs("src"))
 s animation=$g(mainAttrs("animation"))
 s showPageOnPhone=$g(mainAttrs("showpageonphone"))
 i showPageOnPhone="" s showPageOnPhone="true" 
 s preventHide=$g(mainAttrs("preventhide"))
 i preventHide="" s preventHide="false"
 ;
 s attr("name")="text"
 s attr("value")=text
 s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 ;
 i src'="" d
 . s src=$$expandPageName^%zewdCompiler8(src,.nextPageList,.urlNameList,technology)
 . s type="literal"
 . i showPageOnPhone="false" d
 . . s src="Ext.platform.isPhone ? false : '"_src_"'"
 . . s type="reference"
 . s attr("name")="page"
 . s attr("value")=src
 . s attr("type")=type
 . s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 i preventHide="true" d
 . s attr("name")="preventHide"
 . s attr("value")=preventHide
 . s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 ;
 i animation'="" d
 . s attr("name")="animation"
 . s attr("value")=animation
 . s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 s itemsAdded=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:menuitem" d
 . . i 'itemsAdded d 
 . . . s attr("name")="items"
 . . . s attr("type")="array"
 . . . s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 . . . s itemsAdded=1
 . . s jsObjOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jsNVPOID)
 . . d uuiMenuItem(childOID,jsObjOID) 
 . ;
 . i tagName="st:toolbarbutton" d
 . . d uuiToolbarButton(childOID,parentOID) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT 
 ;
uuiToolbarButton(nodeOID,parentOID)
 ;
 n childNo,childOID,jsNVPOID,mainAttrs,OIDArray,subparams,tagName,text,xOID
 ;
 s attr("name")="button"
 s attr("type")="object"
 s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s text=$g(mainAttrs("text"))
 i text="" s text="Popup"
 s attr("name")="text"
 s attr("value")=text
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr) 
 s attr("name")="show"
 s attr("value")="true"
 s attr("type")="boolean"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr)  
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:popuppanel" d
 . . d uuiPopupPanel(childOID,jsNVPOID) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT 
 ;
uuiPopupPanel(nodeOID,parentOID)
 ;
 n anim,height,jsNVPOID,mainAttrs,OIDArray,scroll,src,width,xOID
 ;
 s attr("name")="popup"
 s attr("type")="object"
 s jsNVPOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s src=$g(mainAttrs("src"))
 i src="" s src="undefPopupPage.ewd"
 s attr("name")="src"
 s attr("value")=src
 s attr("type")="url"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr) 
 ;
 s anim=$g(mainAttrs("animation"))
 i anim="" s anim="slide"
 s attr("name")="animation"
 s attr("value")=anim
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr) 
 ;
 s scroll=$g(mainAttrs("scroll"))
 i scroll="" s scroll="vertical"
 s attr("name")="scroll"
 s attr("value")=scroll
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr)
 ;
 s width=$g(mainAttrs("width"))
 i width'="" d
 . s attr("name")="width"
 . s attr("value")=width
 . s attr("type")="numeric"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr)
 ;
 s height=$g(mainAttrs("height"))
 i height'="" d
 . s attr("name")="height"
 . s attr("value")=height
 . s attr("type")="numeric"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",jsNVPOID,,.attr) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT 
 ;
card(nodeOID,attrValue,docOID,technology)
 ;
 ;<st:card animation="fade" displayBackButton="false" displayDetailButton="false">
 ;
 n animation,attr,jsOID,jsText,mainAttrs,postSTOID,preSTOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s jsOID=$$createJS()
 s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 ;
 s animation=$g(mainAttrs("animation")) i animation="" s animation="slide"
 ;
 ;s jsText="EWD.sencha.loadCard({animation:'"_animation_"'"
 s jsText="EWD.sencha.displayCard({animation:'"_animation_"'"
 i $g(mainAttrs("displaybackbutton"))'="" s jsText=jsText_",displayBackButton:"_mainAttrs("displaybackbutton")
 i $g(mainAttrs("displaydetailbutton"))'="" s jsText=jsText_",displayDetailButton:"_mainAttrs("displaydetailbutton")
 s jsText=jsText_"});"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s jsText="if (EWD.sencha.nestedList) EWD.sencha.nestedList.height = EWD.sencha.nestedList.maxHeight;"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT  
 ;
js(nodeOID,attrValue,docOID,technology)
 ;
 ; <st:js block="ewdPreST" position="end">...javascript code </st:js>
 ;
 n attr,block,jsOID,mainAttrs,no,position,stOID,text,textarr,textOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s block=$g(mainAttrs("block")) i block="" s block="ewdST"
 s position=$g(mainAttrs("position")) i position="" s position="end"
 ;
 s stOID=$$getElementById^%zewdDOM(block,docOID)
 i stOID="" QUIT
 ;
 s jsOID=""
 i position="start"!(position="before") d
 . s jsOID=$$createElement^%zewdDOM("ewd:jssection",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,stOID)
 i position="end"!(position="after") d
 . s jsOID=$$insertNewNextSibling("ewd:jssection",stOID)
 i jsOID="" QUIT
 ;
 s text=$$getElementText^%zewdDOM(nodeOID,.textarr)
 s no=""
 f  s no=$o(textarr(no)) q:no=""  d
 . s text=textarr(no)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text) 
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 QUIT
 ; 
form(nodeOID,attrValue,docOID,technology)
 ;
 ; <st:form id="contentDiv">
 ;   <st:fieldset title="Welcome to the Minimal Hold Order System">
 ;      <st:field type="text" id="username" label="Username" />
 ;      <st:field type="password" id="password" label="Password" />
 ;      <st:field type="submit" text="Login" style="drastic_round" targetId="contentDiv" nextpage="loggedIn" />
 ;   </st:fieldset>
 ; </st:form>
 ;
 n attr,attrName,autoRender,childNo,childOID,fcOID,formOID,fsOID,itemOID,itemsOID,jsOID
 n mainAttrs,OIDArray,parentOID,postSTOID,tagName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s jsOID=$$createJS()
 s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 ;
 s autoRender=$g(mainAttrs("autorender")) k mainAttrs("autorender")
 s formOID=$$insertNewNextSibling("st:class",nodeOID)
 d setAttribute^%zewdDOM("name","Ext.form.FormPanel",formOID)
 i $g(mainAttrs("return"))="" d
 . i autoRender="" d
 . . s mainAttrs("return")="EWD.sencha.card"
 . e  d
 . . s mainAttrs("return")="var ewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 i autoRender'="" d
 . n id,xOID
 . s id="ewdSTFormDiv"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s xOID=$$insertNewNextSibling("div",nodeOID)
 . d setAttribute^%zewdDOM("id",id,xOID)
 . d setAttribute^%zewdDOM("renderto",id,formOID)
 ;
 s attrName=""
 f  s attrName=$o(mainAttrs(attrName)) q:attrName=""  d
 . d setAttribute^%zewdDOM(attrName,mainAttrs(attrName),formOID)
 s itemsOID=$$addElementToDOM^%zewdDOM("st:items",formOID)
 ;
 ; If form has a fieldset it will be the first child
 ;
 s parentOID=nodeOID
 s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(fcOID)="st:fieldset" d
 . n hasChildren,itemsAttr
 . s fsOID=$$fieldset(fcOID,itemsOID)
 . s itemsAttr=$$getAttribute^%zewdDOM("items",fcOID)
 . s hasChildren=$$hasChildNodes^%zewdDOM(fcOID)
 . i itemsAttr="",hasChildren="true" s itemsOID=$$addElementToDOM^%zewdDOM("st:items",fsOID)
 . s parentOID=fcOID
 ;
 d getChildrenInOrder^%zewdDOM(parentOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:field" d field(childOID,itemsOID,mainAttrs("return"))  q
 . i tagName="st:checkboxes" d  q
 . . n parentOID
 . . s parentOID=formOID
 . . i $$getTagName^%zewdDOM(fcOID)="st:fieldset" s parentOID=fsOID
 . . d checkboxes(childOID,parentOID)
 i $$removeChild^%zewdDOM(nodeOID)
 QUIT  
 ;
checkboxes(nodeOID,parentOID)
 ;
 n attr,checkIf,fcOID,idRoot,itemsOID,jsOID,jsText,jsVar,labelAlign,mainAttrs
 n nameRoot,preSTOID,sessionName,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s sessionName=$g(mainAttrs("sessionname")) i sessionName="" s sessionName="missingSessionValue" 
 s idRoot=$g(mainAttrs("idroot"))
 i idRoot="" s idRoot="ewdSTCheckbox"
 s checkIf=$g(mainAttrs("checkif"))
 i checkIf["&php;" d
 . n no
 . s no=$p(checkIf,"&php;",2)
 . s checkIf=$g(phpVars(no))
 . s checkIf=$$stripSpaces^%zewdAPI(checkIf)
 . s checkIf=$e(checkIf,3,$l(checkIf))
 ;
 s jsVar="ewdSTCheckboxes"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s nameRoot=$g(mainAttrs("nameroot"))
 i nameRoot="" s nameRoot=jsVar
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s jsText="EWD.sencha.checkBox={idRoot:'"_idRoot_"',nameRoot:'"_nameRoot_"'};"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 ;
 s labelAlign=$g(mainAttrs("labelalign"))
 i labelAlign="" s labelAlign="left"
 ;
 ;
 s attr("method")="writeCheckboxes^%zewdST"
 s attr("param1")=sessionName
 s attr("param2")=jsVar
 s attr("param3")=idRoot
 s attr("param4")=nameRoot
 s attr("param5")=checkIf
 s attr("param6")=labelAlign
 s attr("param7")="#ewd_sessid"
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",preSTOID,,.attr)
 ;
 d setAttribute^%zewdDOM("items","."_jsVar,parentOID)
 s itemsOID=$$getFirstChild^%zewdDOM(parentOID)
 i $$getTagName^%zewdDOM(itemsOID)="st:items" s itemsOID=$$removeChild^%zewdDOM(itemsOID)
 ;
 s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(fcOID)="st:onchecked" d
 . n attr,funcOID,jsOID,no,preSTOID,text,textarr,textOID
 . s text=$$getElementText^%zewdDOM(fcOID,.textarr)
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . s attr("return")="EWD.sencha.onCheckboxChecked"
 . s attr("addVar")="false"
 . s attr("parameters")="value,id,checked"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",postSTOID,,.attr)
 . s no=""
 . f  s no=$o(textarr(no)) q:no=""  d
 . . s text=textarr(no)
 . . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . . s textOID=$$appendChild^%zewdDOM(textOID,funcOID) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
fieldset(nodeOID,parentOID)
 ;
 ;   <st:fieldset title="Welcome to the Minimal Hold Order System">
 ;
 n fsOID,mainAttrs
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s mainAttrs("xtype")="fieldset"
 s fsOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.mainAttrs)
 ;
 QUIT fsOID
 ;
field(nodeOID,parentOID,return)
 ;
 ;      <st:field type="text" id="username" label="Username" />
 ;      <st:field type="password" id="password" label="Password" />
 ;      <st:field type="submit" text="Login" style="drastic_round" targetId="contentDiv" nextpage="loggedIn" />
 ;
 n attr,fieldOID,id,mainAttrs,type,value,xtype
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type")) i type="" s type="text"
 s xtype="textfield"
 i type="password" s xtype="passwordfield"
 i type="submit" s xtype="button"
 s attr("xtype")=xtype
 s id=$g(mainAttrs("id"))
 i id="" s id=$g(mainAttrs("name"))
 i id="" s id="ewdSTField"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s attr("id")=id
 s attr("name")=id
 i $g(mainAttrs("label"))'="" s attr("label")=mainAttrs("label")
 i xtype="button" d
 . i $g(mainAttrs("style"))'="" s attr("ui")=mainAttrs("style")
 . s attr("text")=$g(mainAttrs("text"))
 i $g(mainAttrs("value"))'="" s attr("value")=mainAttrs("value")
 s fieldOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.attr)
 i xtype="button" d
 . n attr,childNo,childOID,fieldNames,formOID,funcOID,handler,jsText
 . n name,nextPage,OIDArray,plus,postSTOID,preSTOID,tagName,targetId
 . s formOID=$$getParentNode^%zewdDOM(nodeOID)
 . d getChildrenInOrder^%zewdDOM(formOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName="st:field" d
 . . . s name=$$getAttribute^%zewdDOM("id",childOID)
 . . . i name="" s name=$$getAttribute^%zewdDOM("name",childOID)
 . . . i name'="" s fieldNames(name)=""
 . ; <ewd:jsFunction return="xxx" addVar="true">...</ewd:jsFunction>
 . s handler="ewdSTHandler"_$$uniqueId^%zewdAPI(fieldOID,filename)
 . s attr("return")=handler
 . s attr("addVar")="false"
 . s jsText="EWD.sencha.blurFields(document);"_$c(13,10)
 . s jsText=jsText_"var nvp="
 . s name="",plus="'"
 . f  s name=$o(fieldNames(name)) q:name=""  d
 . . s jsText=jsText_plus_name_"=' + "_return_".getValues()."_name
 . . s plus=" + '&"
 . s jsText=jsText_";"_$c(13,10)
 . s nextPage=$g(mainAttrs("nextpage")) i nextPage="" s nextPage="missingNextPage"
 . s targetId=$g(mainAttrs("targetid")) i targetId="" s targetId="st-uui-nullId"
 . s jsText=jsText_"ewd.ajaxRequest("""_nextPage_""","""_targetId_""",nvp);"
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 . d setAttribute^%zewdDOM("handler",handler,fieldOID)
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 . s jsText="document.getElementById("_return_".body.id).parentNode.onsubmit = function() {"_handler_"();};"
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 ;
 QUIT
 ;
navigationMenu(nodeOID,attrValue,docOID,technology)
 ;
 n attr,comma,funcOID,jsText,jsOID,mainAttrs,nextPage,no,postSTOID,preSTOID,sessionName,xOID
 ;
 s jsOID=$$createJS()
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s sessionName=$g(mainAttrs("sessionname"))
 s nextPage=$g(mainAttrs("nextpage"))
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 i sessionName="" d
 . n childNo,childOID,objects,tagName
 . ;d getChildrenInOrder^%zewdDOM(panelOID,.OIDArray)
 . d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName="st:menuoption" d menuOption(childOID,.objects)
 . i $d(objects) d
 . . s no="",jsText="EWD.sencha.mainMenu=[",comma=""
 . . f  s no=$o(objects("json",no)) q:no=""  d
 . . . s jsText=jsText_comma_objects("json",no)
 . . . s comma=","
 . . s jsText=jsText_"];"_$c(13,10)
 . . s jsText=jsText_"EWD.sencha.replaceNavigationMenu();"_$c(13,10)
 . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 . . s attr("return")="EWD.sencha.menuPage"
 . . s attr("addVar")="false"
 . . s attr("parameters")="key"
 . . s jsText=""
 . . s no=""
 . . f  s no=$o(objects("xref",no)) q:no=""  d
 . . . s jsText=jsText_"if (key=="_no_") "_objects("xref",no)_"(key);"_$c(13,10)
 . . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 e  d
 . s attr("method")="replaceMenuOptions^%zewdST"
 . s attr("param1")=sessionName
 . s attr("param2")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",preSTOID,,.attr)
 . ;
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 . s attr("return")="EWD.sencha.menuPage"
 . s attr("addVar")="false"
 . s attr("parameters")="key"
 . s jsText="var nvp='key='+key;"_$c(13,10)
 . s jsText=jsText_"ewd.ajaxRequest("""_nextPage_""",EWD.sencha.div.nullId,nvp);"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",postSTOID,,.attr,jsText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
menuOption(nodeOID,objects)
 ;
 n attr,card,funcOID,jsText,mainAttrs,optionNo,preSTOID,return,text
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s text=$g(mainAttrs("text")) i text="" s text="Undefined Option"
 s card=$g(mainAttrs("card")) 
 i card="" s card=$g(mainAttrs("nextpage")) 
 i card="" s card="UndefinedFragment"
 s optionNo=$o(objects("json",""),-1)+1
 s text="{text:'"_text_"',key:"_optionNo_"}"
 s objects("json",optionNo)=text
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s return="ewdSTFunc"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s attr("return")=return
 s attr("addVar")="false"
 s attr("parameters")="key"
 s jsText="var nvp='key='+key;"_$c(13,10)
 s jsText=jsText_"ewd.ajaxRequest("""_card_""",EWD.sencha.div.nullId,nvp);"
 s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 s objects("xref",optionNo)=return
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
loggedInView(nodeOID,attrValue,docOID,technology)
 ;
 n jsOID,jsText,mainAttrs,postSTOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s jsOID=$$createJS()
 s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 s jsText="EWD.sencha.navigationOn({displayBackButton:false,displayDetailButton:false});"_$c(13,10)
 s jsText=jsText_"EWD.sencha.replaceNavigationMenu();"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
stclass(nodeOID,attrValue,docOID,technology)
 ;
 n mainAttrs,name
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s name=$g(mainAttrs("name"))
 d removeAttribute^%zewdDOM("name",nodeOID)
 d class(name,nodeOID)
 QUIT
 ;
panel(nodeOID,attrValue,docOID,technology)
 ;
 n childNo,childOID,itemsAdded,itemsOID,mainAttrs,OIDArray,panelOID,parentOID,return,stop,thisOID
 ;
 ; move up parents until no more panels found
 ;
 s stop=0
 s thisOID=nodeOID
 f  d  q:stop
 . s parentOID=$$getParentNode^%zewdDOM(thisOID)
 . i $$getTagName^%zewdDOM(parentOID)'="st:panel" s stop=1
 s nodeOID=thisOID
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s panelOID=$$renameTag^%zewdDOM("st:class",nodeOID)
 d setAttribute^%zewdDOM("name","Ext.Panel",panelOID)
 s return=$g(mainAttrs("return")) i return="" s return="EWD.sencha.card"
 d setAttribute^%zewdDOM("return",return,panelOID)
 ;
 d getChildrenInOrder^%zewdDOM(panelOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:panel" s stop=1 q
 . i tagName="st:menu" s stop=1 q
 . i tagName="st:button" s stop=1 q
 . i tagName="st:form" s stop=1 q
 s itemsOID=""
 i stop s itemsOID=$$addElementToDOM^%zewdDOM("st:items",panelOID)
 s childNo="",itemsAdded=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:toolbar" d toolbar(childOID,panelOID) q
 . i tagName="st:panel" d subPanel(childOID,parentOID,itemsOID)  q
 . i tagName="st:menu" d menu(childOID,itemsOID)  q
 . i tagName="st:button" d button(childOID,itemsOID) q
 . i tagName="st:form" d formPanel(childOID,parentOID,itemsOID) q
 . i tagName'["st:" d contentEl(childOID,panelOID)
 ;
 QUIT
 ;
formPanel(nodeOID,bodyOID,itemsOID)
 ;
 n itemOID,return,xOID
 ;
 s xOID=$$removeChild^%zewdDOM(nodeOID)
 s xOID=$$appendChild^%zewdDOM(nodeOID,bodyOID)
 s return="ewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 d setAttribute^%zewdDOM("return",return,nodeOID)
 d setAttribute^%zewdDOM("placeattop","true",nodeOID)
 s itemOID=$$addElementToDOM^%zewdDOM("st:object",itemsOID)
 d setAttribute^%zewdDOM("name",return,itemOID)
 QUIT
 ;
contentEl(nodeOID,parentOID)
 ;
 n class,gpOID,id
 ;
 s id=$$getAttribute^%zewdDOM("id",nodeOID)
 i id="" d
 . s id="ewdSTTag"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . d setAttribute^%zewdDOM("id",id,nodeOID)
 d setAttribute^%zewdDOM("contentEl",id,parentOID)
 s class=$$getAttribute^%zewdDOM("class",nodeOID)
 s nodeOID=$$removeChild^%zewdDOM(nodeOID)
 s gpOID=$$getParentNode^%zewdDOM(parentOID)
 s nodeOID=$$appendChild^%zewdDOM(nodeOID,gpOID)
 ;
 i class="stBlueHighlight" d
 . n jsOID,text,preSTOID
 . s text="EWD.sencha.resetMenuHeight('stBlueHighlight');"
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,text)
 ;
 QUIT
 ;
button(nodeOID,parentOID)
 ;
 n attr,mainAttrs,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s mainAttrs("xtype")="button"
 i $g(mainAttrs("style"))'="" d
 . s mainAttrs("ui")=mainAttrs("style")
 . k mainAttrs("style")
 s xOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.mainAttrs)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
menu(nodeOID,parentOID)
 ;
 n attr,childOID,fitHeight,fitWidth,funcOID,items,jsText,listChange,lOID,lsOID,mainAttrs,menuOID,nextPage
 n postSTOID,preSTOID,sessionName,title,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s fitWidth=$g(mainAttrs("fitwidth")) k mainAttrs("fitwidth")
 s fitHeight=$g(mainAttrs("fitheight")) k mainAttrs("fitheight")
 s sessionName=$g(mainAttrs("sessionname")) k mainAttrs("sessionname")
 s title=$g(mainAttrs("title")) k mainAttrs("title")
 s nextPage=$g(mainAttrs("nextpage")) k mainAttrs("nextpage")
 s items=$g(mainAttrs("return"))
 i items="" s items="ewdSTNList"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 s attr("xtype")="nestedlist"
 i fitWidth="true" s attr("width")=".EWD.sencha.nestedList.width"
 i fitHeight="true" s attr("height")=".EWD.sencha.nestedList.height"
 s attr("store")="."_items_"Store"
 s menuOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.attr)
 s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",menuOID)
 s listChange="ewdSTListchange"_$$uniqueId^%zewdAPI(lsOID,filename)
 s attr("itemtap")="."_listChange
 s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 ;
 i title'="" d
 . s attr("title")=title
 . s xOID=$$addElementToDOM^%zewdDOM("st:toolbar",menuOID,,.attr)
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s attr("method")="writeMenuOptions^%zewdST"
 s attr("param1")=sessionName
 s attr("param2")=items
 s attr("param3")="#ewd_sessid"
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",preSTOID,,.attr)
 ;
 i nextPage'="" d
 . s attr("return")=listChange
 . s attr("addVar")="false"
 . s attr("parameters")="subList, subIdx"
 . s jsText="var store=subList.getStore();"_$c(13,10)
 . s jsText=jsText_"var record=store.getAt(subIdx);"_$c(13,10)
 . s jsText=jsText_"var nvp='menuItemNo='+record.get('key');"_$c(13,10)
 . s jsText=jsText_"ewd.ajaxRequest("""_nextPage_""",EWD.sencha.div.nullId,nvp);"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 ;
 s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 i childOID'="" d
 . i $$getTagName^%zewdDOM(childOID)="st:popup" d popup(childOID,listChange)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
popup(nodeOID,jsVar)
 ;
 n attr,buttonText,height,hideDetailButton,jsText,mainAttrs,page,preSTOID
 n return,title,width,x,xOID,y
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s page=$g(mainAttrs("page")) i page="" s page="missingPopupPage"
 i page'[".ewd" s page=page_".ewd"
 s height=$g(mainAttrs("height")) i height="" s height="500"
 s width=$g(mainAttrs("width")) i width="" s width="500"
 s x=$g(mainAttrs("x")) i x="" s x=200
 s y=$g(mainAttrs("y")) i y="" s y=200
 s title=$g(mainAttrs("title"))
 s hideDetailButton=$g(mainAttrs("hidedetailbutton")) i hideDetailButton="" s hideDetailButton="true"
 s buttonText=$g(mainAttrs("buttontext")) i buttonText="" s buttonText="Back"
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s attr("src")=page
 s return="ewdSTPageURL"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s attr("return")=return
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jspage",preSTOID,,.attr)
 s attr("return")=jsVar
 s attr("addVar")="false"
 s attr("parameters")="subList, subIdx"
 s jsText="var store=subList.getStore();"_$c(13,10)
 s jsText=jsText_"var record=store.getAt(subIdx);"_$c(13,10)
 s jsText=jsText_"var nvp='menuItemNo='+record.get('key');"_$c(13,10)
 s jsText=jsText_"EWD.sencha.selectedMenuItem=record;"_$c(13,10)
 s jsText=jsText_"EWD.sencha.openPopup({src:"_return_",nvp:nvp"
 i height'="" s jsText=jsText_",height:"_height
 i width'="" s jsText=jsText_",width:"_width
 i x'="" s jsText=jsText_",x:"_x
 i y'="" s jsText=jsText_",y:"_y
 i title'="" s jsText=jsText_",title:"""_title_""""
 i hideDetailButton'="" s jsText=jsText_",hideDetailButton:"_hideDetailButton
 i buttonText'="" s jsText=jsText_",buttonText:"""_buttonText_""""
 s jsText=jsText_"});"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
subPanel(nodeOID,bodyOID,itemsOID)
 ;
 n attr,childNo,childOID,itemOID,mainAttrs,name,OIDArray,tagName,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID)
 d setAttribute^%zewdDOM("xtype","panel",itemOID)
 i $g(mainAttrs("fitwidth"))'="" d
 . s mainAttrs("minwidth")=".EWD.sencha.nestedList.width"
 . s mainAttrs("maxwidth")=".EWD.sencha.nestedList.width"
 . k mainAttrs("fitwidth")
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . d setAttribute^%zewdDOM(name,mainAttrs(name),itemOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'["st:" d  q
 . . n class,id,jsOID,jsText,postSTOID,preSTOID
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,bodyOID)
 . . s id=$$getAttribute^%zewdDOM("id",childOID)
 . . i id="" d
 . . . s id="ewdSTMarkup"_$$uniqueId^%zewdAPI(childOID,filename)
 . . . d setAttribute^%zewdDOM("id",id,childOID)
 . . d setAttribute^%zewdDOM("contentEl",id,itemOID)
 . . s class=$$getAttribute^%zewdDOM("class",childOID)
 . . s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 . . s jsText="EWD.sencha.contentEl='"_id_"';"
 . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 . . i class="stBlueHighlight" d
 . . . s jsText="EWD.sencha.resetMenuHeight('stBlueHighlight');"
 . . . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 . ;
 . i tagName="st:form" d  q
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,bodyOID)
 . . s return="ewdSTForm"_$$uniqueId^%zewdAPI(childOID,filename)
 . . d setAttribute^%zewdDOM("return",return,childOID)
 . . d setAttribute^%zewdDOM("placeattop","true",childOID)
 . . d setAttribute^%zewdDOM("items","."_return,itemOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
toolbar(nodeOID,parentOID)
 ;
 n attr,childNo,childOID,diOID,itemOID,itemsOID,jsOID
 n mainAttrs,OIDArray,preSTOID,tagName,text
 ;
 ;   <st:toolbar style="light" position="bottom" spaced="true">
 ;     <st:toolbarButton style="action" text="Logout" nextPage="logout" />
 ;   </st:toolbar>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s diOID=$$insertNewNextSibling("st:dockeditems",nodeOID)
 i $g(mainAttrs("style"))'="" s attr("ui")=mainAttrs("style")
 i $g(mainAttrs("position"))'="" s attr("dock")=mainAttrs("position")
 s attr("xtype")="toolbar"
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",diOID,,.attr)
 s itemsOID=$$addElementToDOM^%zewdDOM("st:items",itemOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:toolbarbutton" d toolbarButton(childOID,itemsOID) 
 . i tagName="st:spacer" d
 . . n attr,spacerOID
 . . s attr("xtype")="spacer"
 . . s spacerOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID,,.attr)
 ;
 s text="EWD.sencha.resetMenuHeight('toolbar');"
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,text)
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
toolbarButton(nodeOID,parentOID)
 ;
 n attr,funcOID,handler,itemOID,jsText,mainAttrs,nextPage,preSTOID,targetId,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type")) i type="" s type="action" 
 i type'="back" d
 . s handler=$g(mainAttrs("handler"))
 . i handler="" d
 . . s handler="ewdSTHandler"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . . s attr("return")=handler
 . . s attr("addVar")="false"
 . . s nextPage=$g(mainAttrs("nextpage")) i nextPage="" s nextPage="missingNextPage"
 . . s targetId=$g(mainAttrs("targetid")) i targetId="" s targetId="st-uui-nullId"
 . . s jsText="ewd.ajaxRequest("""_nextPage_""","""_targetId_""");"
 . . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 e  d
 . s handler="EWD.sencha.onToolbarBack"
 ;
 i $g(mainAttrs("type"))'="" s attr("ui")=mainAttrs("type")
 i $g(mainAttrs("text"))'="" s attr("text")=mainAttrs("text")
 s attr("handler")=handler
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.attr)
 ;
 QUIT
 ;
class(className,nodeOID)
 ;
 n attr,childNo,childOID,cOID,jsOID
 n mainAttrs,OIDArray,oOID,pOID,sOID,subTagName,tagName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d convertAttrsToCamelCase(.mainAttrs)
 s jsOID=$$createJS()
 s jsOID=$$getElementById^%zewdDOM("ewdST",docOID)
 s cOID=$$addConstructor(jsOID,.mainAttrs,className)
 s pOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",cOID)
 s oOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",pOID)
 d addNVPs(.mainAttrs,oOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . s subTagName=$p(tagName,"st:",2)
 . s subTagName=$$convertToCamelCase(subTagName)
 . s sOID=$$subTag(subTagName,childOID,oOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT  
 ;
subTag(subTagName,nodeOID,parentOID)
 ;
 n attr,childNo,childOID,mainAttrs,OIDArray,sOID,stOID,subName,subTagOID,tagName
 ;
 i subTagName="item" d
 . s subTagOID=parentOID
 e  i subTagName="listener" d
 . s subTagOID=parentOID
 e  i subTagName="object" d  QUIT subTagOID
 . do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 . d setAttribute^%zewdDOM("ref",$g(mainAttrs("name")),parentOID)
 . d removeIntermediateNode^%zewdDOM(nodeOID)
 . s subTagOID=parentOID
 e  d
 . s attr("name")=subTagName
 . s attr("type")="object"
 . i subTagName="items" s attr("type")="array"
 . s subTagOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d addNVPs(.mainAttrs,subTagOID)
 s stOID=subTagOID
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . s subName=$p(tagName,"st:",2)
 . i subTagName="items" s subTagOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",stOID)
 . s sOID=$$subTag(subName,childOID,subTagOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT subTagOID
 ;
addNVPs(mainAttrs,parentOID)
 ;
 n attr,attrcc,attrlc,nvpOID,terms,type,value
 ;
 d defineCamelCaseTerms(.terms)
 s attrlc=""
 f  s attrlc=$o(mainAttrs(attrlc)) q:attrlc=""  d
 . s attrcc=$$getCamelCase(attrlc,.terms)
 . s value=mainAttrs(attrlc)
 . s type="literal"
 . i value="true"!(value="false") s type="boolean" q
 . i $$numeric^%zewdJSON(value) s type="numeric"
 . i attrcc="handler" s type="reference"
 . i $e(value,1)="." s value=$e(value,2,$l(value)),type="reference"
 . s attr("name")=attrcc
 . s attr("value")=value
 . s attr("type")=type
 . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 QUIT
 ;
addConstructor(parentOID,mainAttrs,className)
 ;
 n attr,cOID,placeAtTop,return
 ;
 s return=$g(mainAttrs("return"))
 i return="" s return="ExtPanel"_$$uniqueId^%zewdAPI(nodeOID,filename)
 k mainAttrs("return")
 ;
 s placeAtTop=$g(mainAttrs("placeattop"))
 i placeAtTop="" d
 . s cOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",parentOID)
 e  d
 . s cOID=$$insertNewFirstChildElement^%zewdDOM(parentOID,"ewd:jsconstructor",docOID)
 ;
 d setAttribute^%zewdDOM("return",return,cOID)
 d setAttribute^%zewdDOM("object",className,cOID)
 QUIT cOID
 ;
createJS()
 ;
 n attr,jsOID,postSTOID,preSTOID,stOID
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 s stOID=$$getElementById^%zewdDOM("ewdST",docOID)
 i stOID="" d
 . s attr("id")="ewdPreST"
 . s preSTOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 . s attr("id")="ewdST"
 . s stOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 . s attr("id")="ewdPostST"
 . s postSTOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 QUIT jsOID
 ;
addSlashAtEnd(string)
 i $e(string,$l(string))'="/" s string=string_"/"
 QUIT string
 ;
convertToCamelCase(string)
 ;
 n terms
 ;
 d defineCamelCaseTerms(.terms)
 QUIT $$getCamelCase(string,.terms)
 ;
convertAttrsToCamelCase(mainAttrs)
 ;
 n attrcc,attrlc,copyAttrs,terms
 ;
 m copyAttrs=mainAttrs
 k mainAttrs
 d defineCamelCaseTerms(.terms)
 s attrlc=""
 f  s attrlc=$o(copyAttrs(attrlc)) q:attrlc=""  d
 . s attrcc=$$getCamelCase(attrlc,.terms)
 . s mainAttrs(attrcc)=copyAttrs(attrlc)
 QUIT
 ;
defineCamelCaseTerms(options)
 ;
 n line,lineNo
 ;
 k options
 f lineNo=1:1 s line=$t(camelCaseTerms+lineNo) q:line["***END***"  d
 . s line=$p(line,";;",2,200)
 . s options($$zcvt^%zewdAPI(line,"l"))=line
 QUIT
 ;
getCamelCase(string,options)
 ;
 n camelCase
 ;
 s camelCase=$g(options(string))
 i camelCase="" s camelCase=string
 ;
 QUIT camelCase
 ;
insertNewNextSibling(elementName,nodeOID)
 ;
 n elOID,nsOID,parentOID
 ;
 s elOID=$$createElement^%zewdDOM(elementName,docOID)
 s nsOID=$$getNextSibling^%zewdDOM(nodeOID)
 i nsOID'="" d
 . s elOID=$$insertBefore^%zewdDOM(elOID,nsOID)
 e  d
 . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 . s elOID=$$appendChild^%zewdDOM(elOID,parentOID)
 ;
 QUIT elOID
 ;
replaceMenuOptions(sessionName,sessid)
 ;
 n array,in,no
 ;
 d mergeArrayFromSession^%zewdAPI(.in,sessionName,sessid)
 s no=""
 f  s no=$o(in(no)) q:no=""  d
 . s array(1,"zobj"_no,"text")=in(no)
 . s array(1,"zobj"_no,"leaf")="<?= true ?>"
 . s array(1,"zobj"_no,"key")=no
 w "EWD.sencha.mainMenu="
 d walkObjectArray^%zewdCompiler19("array")
 w ";"
 w $c(13,10)
 w "EWD.sencha.replaceNavigationMenu();"_$c(13,10)
 QUIT
 ;
writeMenuOptions(sessionName,jsVarName,sessid)
 ;
 n array,len,no,plist,xno
 ;
 d mergeArrayFromSession^%zewdAPI(.plist,sessionName,sessid)
 s no=""
 f  s no=$o(plist(no)) q:no=""  d
 . s xno="0000"_no
 . s len=$l(xno)
 . s xno=$e(xno,len-3,len)
 . s array(1,"zobj"_xno,"text")=plist(no,"text")
 . s array(1,"zobj"_xno,"key")=no
 . s array(1,"zobj"_xno,"id")=sessionName_no
 . s array(1,"zobj"_xno,"leaf")="<?= true ?>"
 ;
 w jsVarName_"="
 d walkObjectArray^%zewdCompiler19("array")
 w ";"
 w $c(13,10)
 ;
 w "Ext.regModel('"_jsVarName_"List',{"
 w "fields: [{name: 'text',type: 'string'},{name: 'key',type: 'string'}]"
 w "});"
 w jsVarName_"Store=new Ext.data.TreeStore({"
 w "model: '"_jsVarName_"List',"
 w "root: {"
 w "items: "_jsVarName
 w "},"
 w "proxy: {type: 'ajax',reader: {type: 'tree',root: 'items'}}"
 w "});"
 ; 
 QUIT
 ;
writeCheckboxes(sessionName,jsVarName,idRoot,nameRoot,checkIf,labelAlign,sessid)
 ;
 n array,code,no,plist,result,text,x
 ;
 d mergeArrayFromSession^%zewdAPI(.plist,sessionName,sessid)
 s no=""
 f  s no=$o(plist(no)) q:no=""  d
 . s code=$g(plist(no,"code"))
 . s text=$g(plist(no,"text"))
 . s array(1,"zobj"_no,"id")=idRoot_no
 . s array(1,"zobj"_no,"label")=text
 . s array(1,"zobj"_no,"labelAlign")=labelAlign
 . s array(1,"zobj"_no,"name")=nameRoot_code
 . s array(1,"zobj"_no,"xtype")="checkbox"
 . s array(1,"zobj"_no,"listeners","zobj1","check")="<?= EWD.sencha.checkBoxHandler ?>"
 . i $g(checkIf)'="" d
 . . i $e(checkIf,1,5)="class" s checkIf="##"_checkIf
 . . i $e(checkIf,1,2)'="$$",$e(checkIf,1,2)'="##" s checkIf="$$"_checkIf
 . . i checkIf'["(code,text,sessid)" s checkIf=checkIf_"(code,text,sessid)"
 . . s x="s result="_checkIf
 . . x x
 . . i result s array(1,"zobj"_no,"checked")="true"
 ;
 w jsVarName_"="
 d walkObjectArray^%zewdCompiler19("array")
 w ";"
 w $c(13,10)
 QUIT
 ;
uiJS ;;
 ;;EWD.sencha.loadMenu = function() {
 ;; ewd.ajaxRequest("<launchPage>","st-uui-launchScreenContents");
 ;; <login>
 ;;};
 ;;EWD.sencha.resourcesPath = '<rootPath><uiPath>';
 ;;EWD.sencha.appTitle = {phone: '<phoneTitle>',tablet: '<tabletTitle>'};
 ;;EWD.sencha.navigationButtonText = '<navigationButtonText>';
 ;;EWD.sencha.codePanel = {scroll: 'vertical', height: <panelHeight>, width: <panelWidth>};
 ;;EWD.sencha.div = {nullId: '<nullId>',launchScreen: '<launchScreenId>'};
 ;;***END***
 ;;
camelCaseTerms
 ;;activeItem
 ;;autoDestroy
 ;;baseCls
 ;;componentLayout
 ;;contentEl
 ;;defaultType
 ;;disabledClass
 ;;dockedItems
 ;;floatingCls
 ;;hideOnMaskTap
 ;;labelWidth
 ;;layoutConfig
 ;;labelAlign
 ;;maxHeight
 ;;maxWidth
 ;;minHeight
 ;;minWidth
 ;;monitorOrientation
 ;;overCls
 ;;renderTo
 ;;renderTpl
 ;;showAnimation
 ;;styleHtmlContent
 ;;tplWriteMode
 ;;***END***
 ;;
