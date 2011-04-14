%zewdCompiler16	; Enterprise Web Developer Compiler Functions
 ;
 ; Product: Enterprise Web Developer (Build 859)
 ; Build Date: Thu, 14 Apr 2011 11:50:57
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
mergeToJSObject(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:mergeToJSObject sessionName="wld.%USER.bridge" jsName="EZBRIDGE.Config" />
	;
	n attr,codeOID,jsName,jsText,scriptOID,sessionName
	;
	set jsName=$$getAttrValue^%zewdAPI("jsname",.attrValues,technology)
	set sessionName=$$getAttrValue^%zewdAPI("sessionname",.attrValues,technology)
	;
	s attr("language")="javascript"
	d
	. s jsText="zewd.mcode w $$mergeToJSObject^%zewdCompiler13("_sessionName_","_jsName_",sessid)"
	s scriptOID=$$addElementToDOM^%zewdDOM("script",nodeOID,,.attr,jsText)
	d
	. s jsText=" w $$mergeToJSObject^%zewdCompiler13("_sessionName_","_jsName_",sessid)"
	. s codeOID=$$addCSPServerScript^%zewdAPI(scriptOID,jsText)
	d removeIntermediateNode^%zewdAPI(nodeOID)
	QUIT
	;
ifBrowser(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:ifBrowser type="ie7">
	; <ewd:ifBrowser os="xp">
	; 
	;   convert to:
	; 
	; <ewd:if firstValue="#ewd.browserType" operation="=" secondValue="ie7">
	;
	n ifOID,os,type
	;
	set type=$$getAttrValue^%zewdCompiler4("type",.attrValues,technology)
	s type=$$removeQuotes^%zewdAPI(type)
	set os=$$getAttrValue^%zewdCompiler4("os",.attrValues,technology)
	s os=$$removeQuotes^%zewdAPI(os)
	;
	i type'="" d
	. s ifOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ewd:if",docOID)
	. d setAttribute^%zewdDOM("firstvalue","#ewd.browserType",ifOID)
	. d setAttribute^%zewdDOM("operation","=",ifOID)
	. d setAttribute^%zewdDOM("secondvalue",type,ifOID)
	;
	i os'="" d
	. i type="" d
	. . s ifOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ewd:if",docOID)
	. e  d
	. . s ifOID=$$insertNewIntermediateElement^%zewdDOM(ifOID,"ewd:if",docOID)
	. d setAttribute^%zewdDOM("firstvalue","#ewd.browserOS",ifOID)
	. d setAttribute^%zewdDOM("operation","=",ifOID)
	. d setAttribute^%zewdDOM("secondvalue",os,ifOID)
	;
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
image(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:image height="100" width="200">
	;   <ewd:imageMap variableName="#myVar" value="1" src="/images/one.jpg" />
	; </ewd:image>
	; 
	; <ewd:if firstValue="#myVar" operation="=" secondValue="1">
	;   <ewd:set return="$src" value="/images/one.jpg">
	; </ewd:if>
	; <img src="$src" height="100" width="200">
	;
	n attr,attrList,attrName,attrs,attrValue,childList,childOID,height,ifOID,imgOID,ok,setOID
	n src,value,var,width
	;
	s childOID=""
	f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
	. k attrs
	. i $$zcvt^%zewdAPI($$getNodeName^%zewdDOM(childOID),"l")="ewd:imagemap" s childList(childOID)=""
	;
	s childOID=""
	f  s childOID=$o(childList(childOID)) q:childOID=""  d
	. s ok=$$getAttributes^%zewdCompiler(childOID,.attrs)
	. s attrName=""
	. f  s attrName=$o(attrs(attrName)) q:attrName=""  d
	. . s attrValue=$$getAttributeValue^%zewdDOM(attrName,1,childOID)
	. . s attrList($$zcvt^%zewdAPI(attrName,"l"))=attrValue
	. . s attrList(attrName)=attrValue
	. s var=$g(attrList("variablename"))
	. s value=$g(attrList("value"))
	. s src=$g(attrList("src"))
	. k attr
	. s attr("firstvalue")=var
	. s attr("operation")="="
	. s attr("secondvalue")=value
	. s ifOID=$$addElementToDOM^%zewdDOM("ewd:if",nodeOID,,.attr,"")
	. k attr
	. s attr("return")="$src"
	. s attr("value")=src
	. s setOID=$$addElementToDOM^%zewdDOM("ewd:set",ifOID,,.attr,"")
	. i $$removeChild^%zewdAPI(childOID)
    ;
	s height=$$getAttrValue^%zewdAPI("height",.attrValues,technology)
	s width=$$getAttrValue^%zewdAPI("width",.attrValues,technology)
	;
	s height=$$removeQuotes^%zewdAPI(height)
	s width=$$removeQuotes^%zewdAPI(width)
	;
	s attrName=""
	f  s attrName=$o(attrValues(attrName)) q:attrName=""  d
	. i "|height|width|src|"[("|"_attrName_"|") q
	. s value=$$getAttrValue^%zewdAPI(attrName,.attrValues,technology)
	. i value'="" s attr(attrName)=$$removeQuotes^%zewdAPI(value)
	;
	i height'="" s attr("height")=height
	i width'="" s attr("width")=width
	s attr("src")="$src"
	s imgOID=$$addElementToDOM^%zewdDOM("img",nodeOID,,.attr,"")
	;
	d removeIntermediateNode^%zewdAPI(nodeOID)
	;
	QUIT
	;
addPHPHeader(docOID,phpHeaderArray)
	;
	n blockno,data,htmlOID,lineno,procInsOID,sOID
	;
	s data=$c(13,10)
	s data=data_"/*"_$c(13,10)
	s data=data_"   Page created using "_$$version^%zewdAPI()_$c(13,10)
	s data=data_"   Compiled on "_$$inetDate^%zewdAPI($h)_$c(13,10)
	s data=data_"*/"_$c(13,10)
	s blockno=""
	f  s blockno=$o(phpHeaderArray(blockno)) q:blockno=""  d
	. s lineno=""
	. f  s lineno=$o(phpHeaderArray(blockno,lineno)) q:lineno=""  d
	. . s data=data_phpHeaderArray(blockno,lineno)_$c(13,10)
	;
	s sOID=$$getTagByNameAndAttr^%zewdAPI("script","language","php",0,docName)
	i sOID'="" d
	. n dlim,lineNo,scriptText,tOID,textArray
	. s tOID=""
	. f  s tOID=$$getNextChild^%zewdDOM(sOID,tOID) q:tOID=""  d
	. . s scriptText=$$getData^%zewdDOM(tOID,.textArray)
	. . i '$d(textArray) s textArray(1)=scriptText
	. . s lineNo=""
	. . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
	. . . s data=data_textArray(lineNo)
	. i $$removeChild^%zewdDOM(sOID)
	s procInsOID=$$createProcessingInstruction^%zewdDOM("php",data,docOID)
	s htmlOID=$$getFirstChild^%zewdDOM(docOID)
	s procInsOID=$$insertBefore^%zewdDOM(procInsOID,htmlOID)
	QUIT
	;
parseConfigFile()
 ;
 n docName,fileName,io,os
 ;
 s io=$io
 s os=$$os^%zewdHTMLParser()
 s fileName="c:\ewd\"
 i os="unix"!(os="gtm") s fileName="/usr/ewd/"
 s fileName=fileName_"ewd.conf"
 s docName="ewdConfig"
 ;
 s ok=$$parseFile^%zewdHTMLParser(fileName,docName)
 u io
 i ok="" QUIT docName
 QUIT ""
	;
saveConfigFile(docName)
	;
	n fileName,io,ok,os
	;
	s io=$io
	s os=$$os^%zewdHTMLParser()
	s fileName="c:\ewd\"
	i os="unix"!(os="gtm") s fileName="/usr/ewd/"
	s fileName=fileName_"ewd.conf"
	i '$$openNewFile^%zewdAPI(fileName) QUIT "Unable to open ewd.conf"
	u fileName
	s ok=$$outputDOM^%zewdDOM(docName,1,2)
	c fileName
	u io
	QUIT ""
	;
getConfig(ewd)
	;
	n backEndLanguage,docName,frontEndLanguage,nodes
	n ok,outputPath,persistenceDatabase,rootURL
	;
	s frontEndLanguage=$g(^zewd("config","frontEndTechnology"))
	i frontEndLanguage="" s frontEndLanguage="gtm"
	s backEndLanguage=$g(^zewd("config","backEndTechnology"))
	i backEndLanguage="" s backEndLanguage="m"
	s persistenceDatabase=$g(^zewd("config","sessionDatabase"))
	i persistenceDatabase="" s persistenceDatabase="gtm"
	;
	s rootURL=$$getRootURL^%zewdAPI(frontEndLanguage)
	s outputPath=$$getOutputRootPath^%zewdAPI(frontEndLanguage)
	;
	s ewd("RootURL",frontEndLanguage)=rootURL
	s ewd("applicationRootPath")=$$applicationRootPath^%zewdAPI()
	s ewd("defaultFormat")=$$getDefaultFormat^%zewdAPI()
	s ewd("defaultTechnology")=frontEndLanguage
	s ewd("homePage")=$$getHomePage^%zewdAPI()
	s ewd("jsScriptPath",frontEndLanguage,"mode")=$$getJSScriptsPathMode^%zewdAPI(frontEndLanguage)
	s ewd("jsScriptPath",frontEndLanguage,"path")=$$getJSScriptsRootPath^%zewdAPI(frontEndLanguage)
	s ewd("outputRootPath",frontEndLanguage)=outputPath
	s ewd("frontEndTechnology")=frontEndLanguage
	s ewd("backEndTechnology")=backEndLanguage
	s ewd("sessionDatabase","type")=persistenceDatabase
	i persistenceDatabase="mysql" d
	. s ewd("sessionDatabase","host")=$g(^zewd("config","database",persistenceDatabase,"host"))
	. s ewd("sessionDatabase","username")=$g(^zewd("config","database",persistenceDatabase,"username"))
	. s ewd("sessionDatabase","password")=$g(^zewd("config","database",persistenceDatabase,"password"))
	i persistenceDatabase="gtm"!(persistenceDatabase="cache") d
	. s ewd("sessionDatabase","mgwsiServer")=$g(^zewd("config","database",persistenceDatabase,"mgwsiServer"))
	QUIT "" 
	;
getConfigDetails(config)
	;
	n database,docName,nodes,ok,outputPath,technology
	;
	k config
	;
	s config("main","frontEndTechnology")=$g(^zewd("config","frontEndTechnology"))
	s config("main","backEndTechnology")=$g(^zewd("config","backEndTechnology"))
	s config("main","sessionDatabase")=$g(^zewd("config","sessionDatabase"))
	s config("main","applicationRootPath")=$$applicationRootPath^%zewdAPI()
	s config("main","markupFormat")=$$getDefaultFormat^%zewdAPI()
	s config("main","homePage")=$$getHomePage^%zewdAPI()	
	;
	s technology="gtm" d
	. s config("technology",technology,"RootURL")=$g(^zewd("config","RootURL",technology))
	. s config("technology",technology,"outputRootPath")=$g(^zewd("config","jsScriptPath","gtm","outputPath"))
	. s config("technology",technology,"jsScriptPath","mode")=$$getJSScriptsPathMode^%zewdAPI(technology)
	. i config("technology",technology,"jsScriptPath","mode")="" s config("technology",technology,"jsScriptPath","mode")="fixed"
	. s config("technology",technology,"jsScriptPath","path")=$$getJSScriptsRootPath^%zewdAPI(technology)
	;
	QUIT
	;
getApplications(appList)
 ;
 n appName,appPath,dlim,noOfApps,os
 ;
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 ;
 s appPath=$$getApplicationRootPath^%zewdAPI()
 i os="windows",appPath="" s appPath="\inetpub\wwwroot\php"
 i os="unix",appPath="" s appPath="/usr/ewd"
 ;
 i $e(appPath,$l(appPath))=dlim s appPath=$e(appPath,1,$l(appPath)-1)
 ;
 d getDirectoriesInPath^%zewdHTMLParser(appPath,.appList)
 s noOfApps=0
 s appName=""
 f  s appName=$o(appList(appName)) q:appName=""  s noOfApps=noOfApps+1
 QUIT noOfApps
 ;
getPages(application,pageList)
 ;
 n dlim,name,noOfPages,os,path
 ;
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 ;
 s path=$$getApplicationRootPath^%zewdAPI()
 i os="windows",path="" s path="\inetpub\wwwroot\php"
 i os="unix",path="" s path="/usr/ewd"
 ;
 i $e(path,$l(path))'=dlim s path=path_dlim
 s path=path_application
 ;
 d getFilesInPath^%zewdHTMLParser(path,"ewd",.pageList)
 s noOfPages=0
 s name=""
 f  s name=$o(pageList(name)) q:name=""  s noOfPages=noOfPages+1
 QUIT noOfPages
 ;
tokeniseURL(url,sessid)
 ;
 n pageName,nvp,n,technology,token
 ;
 s nvp=""
 i url'[".ewd" d
 . s pageName=url 
 e  d
 . s pageName=$p(url,".ewd",1)
 i url["?" d
 . s nvp=$p(url,"?",2,500)
 . s pageName=$p(pageName,"?",1)
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 i technology'="csp" d
 . s n=$$setNextPageToken^%zewdAPI(pageName,sessid)
 . s token=$$getSessionValue^%zewdAPI("ewd_token",sessid)
 s technology="ewd"
 s url=pageName_"."_technology_"?"
 s url=url_"ewd_token="_token_"&n="_n
 i nvp'="" s url=url_"&"_nvp
 QUIT url
 ;
 ;
exportCustomTags(tagList,filepath)
 ;
 n tagName
 ;
 i $g(filepath)="" QUIT "You must enter a filepath"
 i $$openNewFile^%zewdAPI(filepath) e  QUIT "Unable to create output file "_filepath
 u filepath
 s tagName=""
 f  s tagName=$o(tagList(tagName)) q:tagName=""  d
 . w tagName,!
 . w ^%zewd("customTag",tagName),!
 w "eof",!,"eof",!
 c filepath
 ;
 QUIT ""
 ;
exportAllCustomTags(filepath)
 ;
 n tagName
 ;
 i $g(filepath)="" QUIT "You must enter a filepath"
 i $$openNewFile^%zewdAPI(filepath) e  QUIT "Unable to create output file "_filepath
 u filepath
 s tagName=""
 f  s tagName=$o(^%zewd("customTag",tagName)) q:tagName=""  d
 . i $e(tagName,1,4)="ewd:" q
 . i $e(tagName,1,4)="yui:" q
 . i tagName="textarea" q
 . w tagName,!
 . w ^%zewd("customTag",tagName),!
 w "eof",!,"eof",!
 c filepath
 ;
 QUIT ""
 ;
clearCustomTags
 ;
 n tagName
 ;
 s tagName=""
 f  s tagName=$o(^%zewd("customTag",tagName)) q:tagName=""  d
 . i $e(tagName,1,4)="ewd:" q
 . i $e(tagName,1,4)="yui:" q
 . i tagName="textarea" q
 . k ^%zewd("customTag",tagName)
 QUIT
 ;
createTraceDiv(docName)
 ;
 n attr,bodyOID,childOID,divOID,xOID
 ;
 s divOID=$$getElementById^%zewdDOM("traceWindow",docName)
 i divOID'="" QUIT
 ;
 s bodyOID=$$getTagOID^%zewdCompiler("body",docName)
 s childOID=$$getFirstChild^%zewdDOM(bodyOID)
 s divOID=$$createElement^%zewdDOM("div",docOID)
 s divOID=$$insertBefore^%zewdDOM(divOID,childOID)
 do setAttribute^%zewdDOM("id","traceWindow",divOID)
 do setAttribute^%zewdDOM("style","display : none",divOID)
 s xOID=$$addElementToDOM^%zewdDOM("hr",divOID,,,"")
 s xOID=$$addElementToDOM^%zewdDOM("h2",divOID,,,"EWD Ajax Trace : Raw Received Response")
 s attr("id")="traceContent"
 s attr("rows")=50
 s attr("cols")=120
 s xOID=$$addElementToDOM^%zewdDOM("textarea",divOID,,.attr,"*")
 s xOID=$$addElementToDOM^%zewdDOM("hr",divOID,,,"")
 QUIT
 ;
parseArray(arrayName,docName,isHTML)
 ;
 n ok
 ;
 k ^CacheTempEWD($j)
 m ^CacheTempEWD($j)=arrayName
 s ok=$$parseDocument^%zewdHTMLParser(docName,isHTML)
 k ^CacheTempEWD($j)
 QUIT ok
 ;
mainTabMenu(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:mainTabMenu class="optionalClass">
	;
	n attr,class,divOID,loadPage,tableOID,targetId,text,trOID
	;
	set class=$$getAttrValue^%zewdAPI("class",.attrValues,technology)
	s class=$$removeQuotes^%zewdAPI(class)
	i class="" s class="tabs"
	set targetId=$$getAttrValue^%zewdAPI("targetid",.attrValues,technology)
	s targetId=$$removeQuotes^%zewdAPI(targetId)
	i targetId="" s targetId="mainTabMenuPanel"
	;
	s attr("class")=class
	s tableOID=$$addElementToDOM^%zewdDOM("table",nodeOID,,.attr)
	s trOID=$$addElementToDOM^%zewdDOM("tr",tableOID)
	;
	s loadPage=$$mainTabMenuOptions(nodeOID,trOID,targetId,technology,docOID)
	;
	s attr("id")=targetId
	s attr("class")=targetId
	s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	s attr("language")="javascript"
	s text="  ewd.ajaxRequest('"_loadPage_"','"_targetId_"') ;"_$c(13,10)
	s text=text_"  EWD.page.currentPage = '"_loadPage_"' ;"
	s jsOID=$$addElementToDOM^%zewdDOM("script",nodeOID,,.attr,text)
	d removeIntermediateNode^%zewdAPI(nodeOID)
	;
	QUIT
	;
mainTabMenuOptions(parentOID,trOID,targetId,technology,docOID)
	;
	n childNo,childOID,class,docName,help,loadPage,nextpage,OIDArray
	n preSelected,scriptOID,tagName,tdOID,text,visibleIf
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	d getChildrenInOrder^%zewdCompiler4(parentOID,.OIDArray)
	s childNo="",loadPage=""
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ewd:maintabmenuoption" q
	. s text=$$getAttributeValue("text",childOID,technology)
	. s nextpage=$$getAttributeValue("nextpage",childOID,technology)
	. s preSelected=$$getAttributeValue("preselected",childOID,technology)
	. s visibleIf=$$getAttribute^%zewdDOM("visibleif",childOID)
	. i visibleIf'="" d
	. . s attr("firstvalue")=visibleIf
	. . s attr("operation")="="
	. . s attr("secondvalue")="1"
	. . s ifOID=$$addElementToDOM^%zewdDOM("ewd:if",trOID,,.attr)
	. e  d
	. . s ifOID=trOID
	. s class="unselectedTab"
	. i preSelected="true" s class="selectedTab",loadPage=nextpage
	. s help=$$getAttributeValue("help",childOID,technology)
	. s attr("class")=class
	. s attr("id")=nextpage_"Tab"
	. s attr("onClick")="EWD.page.fetch"_nextpage_"(); EWD.page.getTabPage('"_nextpage_"')" 
	. s attr("onMouseOut")="EWD.page.deSelectTab(this)"
	. s attr("onMouseOver")="EWD.page.selectTab(this)"
	. i help'="" s attr("title")=help
	. s tdOID=$$addElementToDOM^%zewdDOM("td",ifOID,,.attr,text)
	. ;
	. s jsText(1)="EWD.page.fetch"_nextpage_" = function () {"
	. s jsText(2)="  ewd.ajaxRequest('"_nextpage_"','"_targetId_"') ;"
	. s jsText(3)="} ;"
	. s scriptOID=$$addJavascriptObject^%zewdCompiler13(docName,.jsText)
	. d removeIntermediateNode^%zewdCompiler4(childOID)
	QUIT loadPage
	;
subTabMenu(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:subTabMenu id="home" panelColor="#f6f6f6" 
	;   unselectedTabColor="#ffffff" class="xxx">
	;
	n attr,childOID,class,crlf,divOID,id,innerTableOID,isMainMenu
	n jsText,lineNo,loadPage,panelColor,scriptOID
	n tableOID,tdOID,text,textArr,textOID,trOID,unselectedColor
	;
	set isMainMenu=$$getAttrValue^%zewdAPI("ismainmenu",.attrValues,technology)
    s isMainMenu=$$removeQuotes^%zewdAPI(isMainMenu)
    s isMainMenu=$$zcvt^%zewdAPI(isMainMenu,"l")="true"
	set class=$$getAttrValue^%zewdAPI("class",.attrValues,technology)
	s class=$$removeQuotes^%zewdAPI(class)
	i class="" s class="innerTabs"
	set id=$$getAttrValue^%zewdAPI("id",.attrValues,technology)
	s id=$$removeQuotes^%zewdAPI(id)
	set panelColor=$$getAttribute^%zewdDOM("panelcolor",nodeOID)
	set unselectedColor=$$getAttribute^%zewdDOM("unselectedtabcolor",nodeOID)
	s crlf=$c(13,10)
	;
	s attr("border")=0
	s attr("width")="98%"
	i isMainMenu s attr("width")="100%"
	s tableOID=$$addElementToDOM^%zewdDOM("table",nodeOID,,.attr)
	s trOID=$$addElementToDOM^%zewdDOM("tr",tableOID)
	s tdOID=$$addElementToDOM^%zewdDOM("td",trOID)
	s attr("class")=class
	s attr("id")=id_"Menu"
	i isMainMenu s attr("style")="top: -55px;"
	s innerTableOID=$$addElementToDOM^%zewdDOM("table",tdOID,,.attr)
	s attr("class")="innerPanel"
	s attr("id")=id
	i isMainMenu s attr("style")="top: -58px;width:100%"
	s divOID=$$addElementToDOM^%zewdDOM("div",tdOID,,.attr,"&nbsp;")
	s trOID=$$addElementToDOM^%zewdDOM("tr",innerTableOID)
	;
	s jsText=""
	i panelColor'="" s jsText=jsText_"EWD.page.selectedColor['"_id_"'] = '"_panelColor_"' ;"_crlf
	i unselectedColor'="" s jsText=jsText_"EWD.page.unselectedColor['"_id_"'] = '"_unselectedColor_"' ;"_crlf
	;
	s loadPage=$$subTabMenuOptions(nodeOID,trOID,id,.jsText,docOID)
	;
	s scriptOID=$$getTagOID^%zewdCompiler("script",docName)
	i scriptOID'="" d
	. n lastLine,text,textArray
	. s text=$$getElementValueByOID^%zewdDOM(scriptOID,"textArr",1)
	. i '$d(textArr) s textArr(1)=text
	. s lastLine=$o(textArr(""),-1)
	. s textArr(lastLine+1)=jsText
	e  d
	. s attr("language")="javascript"
	. s scriptOID=$$addElementToDOM^%zewdDOM("script",docOID,,.attr,,1)
	. s textArr(1)=jsText
	f  q:$$hasChildNodes^%zewdDOM(scriptOID)="false"  d
	. s childOID=$$getFirstChild^%zewdDOM(scriptOID)
	. s childOID=$$removeChild^%zewdDOM(childOID)
	;
	s lineNo=""
	f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d
	. s text=textArr(lineNo)
	. s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. s textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
	;
	d removeIntermediateNode^%zewdAPI(nodeOID)
	;
	QUIT
	;
subTabMenuOptions(parentOID,trOID,id,jsText,docOID)
	;
	; <ewd:subTabMenuOption preSelected="true" text="API Guide" nextPage="api" help="API guide" />
	;
	n childNo,childOID,class,docName,help,ifOID,loadPage
	n nextpage,OIDArray,preSelected,tagName,tdOID,text,visibleIf
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	d getChildrenInOrder^%zewdCompiler4(parentOID,.OIDArray)
	s childNo="",loadPage=""
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ewd:subtabmenuoption" q
	. s text=$$getAttributeValue("text",childOID,technology)
	. s nextpage=$$getAttributeValue("nextpage",childOID,technology)
	. s preSelected=$$getAttributeValue("preselected",childOID,technology)
	. i preSelected="true" s loadPage=nextpage
	. i preSelected'="true" s preSelected="false"
	. s help=$$getAttributeValue("help",childOID,technology)
	. ;
	. s visibleIf=$$getAttribute^%zewdDOM("visibleif",childOID)
	. i visibleIf'="" d
	. . s attr("firstvalue")=visibleIf
	. . s attr("operation")="="
	. . s attr("secondvalue")="1"
	. . s ifOID=$$addElementToDOM^%zewdDOM("ewd:if",trOID,,.attr)
	. e  d
	. . s ifOID=trOID
	. ;
	. ;<td id="ewdWebLinkTab" onclick="MGW.page.getInnerTabPage(this)" 
	. ; onmouseout="MGW.page.deSelectInnerTab(this)" 
	. ; onmouseover="MGW.page.selectInnerTab(this)">
	. ;
	. s attr("id")=nextpage_"Tab"
	. s attr("onClick")="EWD.page.fetch"_nextpage_"(); EWD.page.setInnerTabPage(this)"
	. s attr("onMouseOut")="EWD.page.deSelectInnerTab(this)"
	. s attr("onMouseOver")="EWD.page.selectInnerTab(this)"
	. i help'="" s attr("title")=help
	. s tdOID=$$addElementToDOM^%zewdDOM("td",ifOID,,.attr,text)
	. ;
	. s jsText=jsText_"EWD.page.defineInnerTab('"_id_"','"_nextpage_"Tab',"_preSelected_") ;"_$c(13,10)
	. ;
	. s jsText=jsText_"EWD.page.fetch"_nextpage_" = function () {"_$c(13,10)
	. s jsText=jsText_"  ewd.ajaxRequest('"_nextpage_"','"_id_"') ;"_$c(13,10)
	. s jsText=jsText_"} ;"_$c(13,10)
	. i preSelected="true" s jsText=jsText_"EWD.page.fetch"_nextpage_"() ;"_$c(13,10)
	. ;s scriptOID=$$addJavascriptObject^%zewdCompiler13(docName,.jsText)
	. d removeIntermediateNode^%zewdCompiler4(childOID)
	QUIT loadPage
	;
getAttributeValue(attrName,nodeOID,technology)
	;
	n attrValue
	s attrValue=$$getNormalisedAttributeValue^%zewdAPI(attrName,nodeOID,technology)
	QUIT $$removeQuotes^%zewdAPI(attrValue)
	;
mergeArrayToSessionObject(array,sessionName,sessid)
 QUIT:$g(sessid)=""
 QUIT:$g(sessionName)=""
 s sessionName=$tr(sessionName,".","_")
 i $$isTemp^%zewdAPI(sessionName) m zewdSession(sessionName)=array QUIT
 s sub=""
 f  s sub=$o(array(sub)) q:sub=""  d
 . m ^%zewdSession("session",sessid,sessionName_"_"_sub)=array(sub)
 QUIT
 ;
setJSONValue(JSONName,objectName,sessid)
 n json
 s json=$$sessionObjectToJSON^%zewdAPI(objectName,sessid)
 d setSessionValue^%zewdAPI(JSONName,json,sessid)
 QUIT
 ;
 ;
iframe(docOID)
 ;
 n docName,nodeOID,ntags,OIDArray,src,var
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s ok=$$getElementsArrayByTagName^%zewdDOM("iframe",docName,,.OIDArray)
 s nodeOID=""
 f  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
 . s src=$$getAttribute^%zewdDOM("src",nodeOID)
 . i src="" d setAttribute^%zewdDOM("src","javascript:false;",nodeOID)
 QUIT
 ;
help(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:help sourceId="about_this" src="yyy.gif" width="250px">
	;
	n attr,class,imgOID,sourceId,src,width,x,y
	;
	s sourceId=$$getAttrValue^%zewdAPI("sourceid",.attrValues,technology)
    s sourceId=$$removeQuotes^%zewdAPI(sourceId)
	s src=$$getAttrValue^%zewdAPI("src",.attrValues,technology)
    s src=$$removeQuotes^%zewdAPI(src)
	s width=$$getAttrValue^%zewdAPI("width",.attrValues,technology)
    s width=$$removeQuotes^%zewdAPI(width)
	s method=$$getAttrValue^%zewdAPI("contentmethod",.attrValues,technology)
    s method=$$removeQuotes^%zewdAPI(method)
	s x=$$getAttrValue^%zewdAPI("x",.attrValues,technology)
    s x=$$removeQuotes^%zewdAPI(x)
	s y=$$getAttrValue^%zewdAPI("y",.attrValues,technology)
    s y=$$removeQuotes^%zewdAPI(y)
    i x'="",y="" s y=0
    i y'="",x="" s x=0
    i width="" s width="240px"
    i src="" s src="icn_help_blue.gif"
    s src=$g(^zewd("config","jsScriptPath","gtm","path"))_src
    s attr("src")=src
    i sourceId'="" d
    . s attr("onmouseover")="MGW.page.help(this,'"_sourceId_"','"_width_"'"
    i method'="" d
    . s method=$$replaceAll^%zewdAPI(method,"'",$c(1))
    . s method=$$replaceAll^%zewdAPI(method,$c(1),"\'")
    . s attr("onmouseover")="MGW.page.help(this,'','"_width_"','"_method_"'"
    i x'="" s attr("onmouseover")=attr("onmouseover")_","_x
    i y'="" s attr("onmouseover")=attr("onmouseover")_","_y
    s attr("onmouseover")=attr("onmouseover")_")"
    s attr("onmouseout")="MGW.page.helpOff()"
    s imgOID=$$addElementToDOM^%zewdDOM("img",nodeOID,,.attr)
    d removeIntermediateNode^%zewdDOM(nodeOID)
    QUIT
    ;
helpPanel(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:helpPanel />
	;
	; <iframe id="helpShim" src="javascript:';'" frameborder="0" style="display:none; position:absolute; width:240px;"></iframe>
    ; <div id="helpPanel" class="alertPanelOff"></div>
	;
	n attr,cOID
	;
    s attr("id")="helpShim"
	s attr("src")="javascript:';'"
	s attr("frameborder")="0"
	s attr("style")="display:none; position:absolute;"
    s cOID=$$addElementToDOM^%zewdDOM("iframe",nodeOID,,.attr)
    s attr("id")="helpPanel"
    s attr("class")="alertPanelOff"
    s cOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
    d removeIntermediateNode^%zewdDOM(nodeOID)
    QUIT 
    ;
copyFile(fromPath,toPath)
	;
	n command,ok,os,x
	;
	s os=$$os^%zewdHTMLParser()
	s command="cp"
	i os="windows" s command="COPY"
	i fromPath[" " s fromPath=""""_fromPath_""""
	i toPath[" " s toPath=""""_toPath_""""
	s x=command_" "_fromPath_" "_toPath
	s ok=$ZF(-1,x)
	QUIT ok
    ;
 ;
getClassFromClassMethod(method)
 ;
 n className
 ;
 s className=$p(method,"(",2,200)
 s className=$p(className,")",1)
 QUIT className
getMethodFromClassMethod(method)
 ;
 n name,p1
 ;
 s p1=$p(method,"(",2,200)
 s p1=$p(p1,")",2,200)
 s name=$p(p1,".",2)
 QUIT name
 ;
    ;
countList(listName,sessid)
 ;
 n count,position
 s count=0
 ;
 ;
 s position=""
 f  s position=$o(^%zewdSession("session",sessid,"ewd_list",listName,position)) q:position=""  d
 . s count=count+1
 QUIT count
 ;
    ;
addToList(listName,textValue,codeValue,position,sessid,otherAttrs)
 ;
 n attrList,attrName
 ;
 QUIT:$g(listName)=""
 QUIT:$g(sessid)=""
 QUIT:$g(position)=""
 i $g(codeValue)="",$g(textValue)="" QUIT
 s position=+position
 d removeFromList^%zewdAPI(listName,codeValue,sessid) ; just in case
 s attrName="",attrList=""
 f  s attrName=$o(otherAttrs(attrName)) q:attrName=""  d
 . s attrList=attrList_attrName_$c(3)_otherAttrs(attrName)_$c(1)
 ;
 s codeValue=$g(codeValue) i codeValue="" s codeValue=textValue
 s ^%zewdSession("session",sessid,"ewd_list",listName,position)=textValue_$c(1)_codeValue_$c(1)_attrList
 s ^%zewdSession("session",sessid,"ewd_listIndex",listName,codeValue)=position
 k otherAttrs
 QUIT
 ;
setLoadPath(app,page,path,expiryDays,loginPage)
 ;
 n expiry,i,id,length,now
 ;
 ; http://myServer.com/ewd.html?id=4AWPMzTqMUPhtntLyP5X
 ;
 s id="",length=20
 f  d  q:'$d(^%zewd("siteMapLink",id))
 . f i=1:1:length s id=id_$$randChar^%zewdAPI()
 s now=$$convertDateToSeconds^%zewdAPI($h)
 i $g(expiryDays)="" s expiryDays=30
 i $g(loginPage)'="" s ^%zewd("siteMapLink",id,"login")=loginPage
 i expiry'=0 s expiry=now+(expiryDays*86400)
 s ^%zewd("siteMapLink",id,"page")=page
 s ^%zewd("siteMapLink",id,"expiry")=expiry
 s ^%zewd("siteMapLink",id,"app")=app
 s np=$l(path,"&")
 f i=1:1:np d
 . s step=$p(path,"&",i)
 . s ^%zewd("siteMapLink",id,"path",i)=step
 ;
 QUIT id
 ;
compressJavascriptFile(file)
 ;
 n i,io,line
 ;
 s $zt="eojs"
 i '$$openFile^%zewdAPI(file) QUIT "Unable to open "_file
 s io=$io
 u file
 k ^CacheTempJS($j)
 f i=1:1 r line s ^CacheTempJS($j,i)=line
eojs ;
 c file u io
 s i=""
 f  s i=$o(^CacheTempJS($j,i)) q:i=""  d
 . s line=^CacheTempJS($j,i)
 . s line=$$stripSpaces^%zewdAPI(line)
 . s line=$$replaceAll^%zewdAPI(line,"  "," ")
 . s ^CacheTempJS($j,i)=line
 s newfile=file_".txt"
 i '$$openNewFile^%zewdAPI(newfile) QUIT "Unable to create "_file_".txt"
 u newfile
 s i=""
 f  s i=$o(^CacheTempJS($j,i)) q:i=""  d
 . s line=^CacheTempJS($j,i)
 . w line_$c(10) 
 c newfile u io
 k ^CacheTempJS($j)
 QUIT
 ;
scriptsTag(app,docName,technology)
	;
	n attr,djOID,ewdScriptsOID,headOID,path,scriptOID
	;
	i $g(isAjax) QUIT
	i $e($g(pageName),1,3)="ewd" QUIT
	s path=$$getJSScriptsPath^%zewdCompiler8(app,technology)
	s headOID=$$getTagOID^%zewdCompiler("head",docName)
	s djOID=$$getTagByNameAndAttr^%zewdAPI("script","djConfig","parseOnLoad: true",1,docName)
	s ewdScriptsOID=""
	i '$g(isIwd) d
	. s attr("src")=path_"ewdScripts.js"
	. ;i $g(isIwd) s attr("src")=path_"iwdScripts.js"
	. s ewdScriptsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,"",1)
	i djOID'="" d
	. n djScriptOID,text,textOID
	. s djScriptOID=$$createElement^%zewdDOM("script",docOID)
	. s djScriptOID=$$insertBefore^%zewdDOM(djScriptOID,scriptOID)
	. s text="var EWDdojo = {};"_$c(13,10)
	. s text=text_"EWDdojo.widget={};"
	. s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. s textOID=$$appendChild^%zewdDOM(textOID,djScriptOID)	
	i '$g(isIwd) d
	. n cspOID,nsOID,text,textOID
	. s text=" d loadFiles^%zewdCustomTags("""_$$zcvt^%zewdAPI(app,"l")_""",""css"",sessid)"
	. s cspOID=$$addCSPServerScript^%zewdAPI(headOID,text,1)
	. s cspOID=$$renameTag^%zewdDOM("script",cspOID)
	. s attr("href")=path_"ewd.css"
	. s attr("rel")="stylesheet"
	. s attr("type")="text/css"
	. s scriptOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr,"",1)
	. s text=" d writePageLinks^%zewdCompiler20("""_$$zcvt^%zewdAPI(app,"l")_""",sessid)"
	. s cspOID=$$createElement^%zewdDOM("script",docOID)
	. s nsOID=$$getNextSibling^%zewdDOM(ewdScriptsOID)
	. i nsOID="" d
	. . n parentOID
	. . s parentOID=$$getParentNode^%zewdDOM(ewdScriptsOID)
	. . s cspOID=$$appendChild^%zewdDOM(cspOID,parentOID)
	. e  d
	. . s cspOID=$$insertBefore^%zewdDOM(cspOID,nsOID)
	. d setAttribute^%zewdDOM("language","cache",cspOID)
	. d setAttribute^%zewdDOM("runat","server",cspOID)
	. s textOID=$$addTextToElement^%zewdDOM(cspOID,text)
	QUIT
	;
modulo(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:modulo return="$value" data="$input" modulus=2>
	;
	n name,data,mod
	set name=$$getAttrValue^%zewdCompiler4("return",.attrValues,technology)
	set data=$$getAttrValue^%zewdCompiler4("data",.attrValues,technology)
	set mod=$$getAttrValue^%zewdCompiler4("modulus",.attrValues,technology)
	i $e(mod,1)="""" s mod=$e(mod,2,$l(mod)-1)
	;
	d
	. n text,serverOID
	. s text=" s "_name_"="_data_"#"_mod
	. s serverOID=$$addCSPServerScript^%zewdCompiler4(nodeOID,text)
	;
	;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
location(docOID,allArray,nextPageList,technology)
	;
	n attr,bodyAttrs,bodyOID,childOID,docName,dlim,language
	n line,nodeOID,nline,nlines,ntags
	n OIDArray,ok,%stop,text
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s nodeOID=""
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. ;
	. ;s bodyOID=$$getTagOID("body",docName)
	. s ok=$$getAttributes^%zewdCompiler(nodeOID,.bodyAttrs)
	. s attr=""
	. f  s attr=$o(bodyAttrs(attr)) q:attr=""  d
	. . n attrValue,valuelc
	. . q:$e(attr,1,2)'="on"
	. . s attrValue=$$getAttributeValue^%zewdDOM(attr,1,nodeOID)
	. . s valuelc=$$zcvt^%zewdAPI(attrValue,"l")
	. . i valuelc'[".ewd" q
	. . i valuelc[".ewd_" q
	. . ; should just be .ewd URLs
	. .  s attrValue=$$expandPageURL^%zewdCompiler(attrValue,.nextPageList,technology)
	. . d setAttribute^%zewdDOM(attr,attrValue,nodeOID)
	;
	s ntags=$$getTagsByName^%zewdCompiler("script",docName,.OIDArray)
	s nodeOID="",%stop=0
	;
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  q:%stop
	. s language=$$getAttributeValue^%zewdDOM("language",1,nodeOID)
	. i language="" s language="javascript"
	. QUIT:$$zcvt^%zewdAPI(language,"l")'["javascript"
	. new attrValue,line,modified
	. s childOID=""
	. f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
	. . s modified=0
	. . set text=$$getData^%zewdDOM(childOID)
	. . s dlim=$c(13,10)
	. . i text'[$c(13,10),text[$c(10) s dlim=$c(10)
	. . set nlines=$l(text,dlim)
	. . for nline=1:1 QUIT:nline>nlines  DO  ; --- Process All JavaScript Lines ---
	. . . set line=$p(text,dlim,nline)
	. . . QUIT:line'[".ewd"
	. . . QUIT:line["document.ewdNP"
	. . . QUIT:line["EWD.ajax.makeRequest("
	. . . if $e($$stripSpaces^%zewdAPI(line),1,12)="document.ewd",$p(line,".ewd")'="" QUIT
	. . . set attrValue=$$expandPageURL^%zewdCompiler(line,.nextPageList,technology)
	. . . set modified=1  ; Mark that 'text' was modified
	. . . set text=$s(nline>1:$p(text,dlim,1,nline-1)_$c(13,10),1:"")_attrValue_$c(13,10)_$p(text,dlim,nline+1,nlines)
	. . . set nlines=$l(text,dlim)
	. . i modified i $$modifyTextData^%zewdDOM(text,childOID) ; Modify after ALL expansions have occurred (faster to do only once)!
	;
	QUIT
	;
	;
ajaxFileUpload(docOID)
	;
	; pre-prepare Ajax mechanism for file uploads, generating ewd.ajaxRequest
	; prior to them being processed
	;
	n ajax,docName,formOID,i,line,nodeOID,ntags,OIDArray,path,type
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. s type=$$getAttribute^%zewdDOM("type",nodeOID)
	. i $$zcvt^%zewdAPI(type,"L")'="submit" q
	. i $g(config("pageType"))="ajax" d setAttribute^%zewdDOM("ajax","true",nodeOID)
	. s ajax=$$getAttribute^%zewdDOM("ajax",nodeOID)
	. i ajax'="true" q
	. s formOID=$$getParentForm^%zewdDOM(nodeOID)
	. i formOID'="",$$getAttribute^%zewdDOM("method",formOID)="uploadFile" d
	. . n attr,filename,inputOID,jsArray,nextpage,nextpage2,OIDArray2,parentOID,scriptOID,targetId
	. . s ntags=$$getElementsArrayByTagName^%zewdDOM("input",,formOID,.OIDArray2)
	. . s inputOID="",filename=""
	. . f  s inputOID=$o(OIDArray2(inputOID)) q:inputOID=""  d  q:filename'=""
	. . . s type=$$getAttribute^%zewdDOM("type",inputOID)
	. . . q:type'="file"
	. . . s filename=$$getAttribute^%zewdDOM("name",inputOID)
	. . i filename="" q
	. . s targetId=$$getAttribute^%zewdDOM("targetid",nodeOID)
	. . s nextpage2=$$getAttribute^%zewdDOM("nextpage",nodeOID)
	. . s nextpage="zewdFormRedirect"
	. . d setAttribute^%zewdDOM("nextpage",nextpage,nodeOID)
	. . d setAttribute^%zewdDOM("target","zewdResponseFrame",nodeOID)
	. . d setAttribute^%zewdDOM("ajax","false",nodeOID)
	. . d removeAttribute^%zewdDOM("targetid",nodeOID)
	. . s parentOID=$$getElementById^%zewdDOM(targetId,docOID)
	. . i parentOID="" s parentOID=$$getParentNode^%zewdDOM(formOID)
	. . s attr("name")="zewdResponseFrame"
	. . s attr("style")="display:none"
	. . s attr("src")="javascript:false;"
	. . d addElementToDOM^%zewdDOM("iframe",parentOID,,.attr)
	. . i filename'="" d
	. . . s jsArray(1)="function zewdFragmentResponse(id) {"
	. . . s jsArray(2)=" if (id == '"_filename_"') {"
	. . . s jsArray(3)="  ewd.ajaxRequest('"_nextpage2_"','"_targetId_"') ;"
	. . . s jsArray(4)=" }"
	. . . s jsArray(5)="}"
	. . . s scriptOID=$$addJavascriptFunction^%zewdAPI(docName,.jsArray)
	. . ;
	. . ; create zewdFormRedirect page here
	. . ; deliberately name zewd... to force it to end of compilation list
	. . ; so it doesn't get left out!
	. . ;
	. . s line(1)="<ewd:config isFirstPage=""false"">"
	. . s line(2)="<html><head></head>"
	. . s line(3)="<body onload=""parent.zewdFragmentResponse('"_filename_"')"">"
	. . s line(4)="</body>"
	. . s line(5)="</html>"
	. . s path=inputPath_nextpage_".ewd"
	. . i $$openNewFile^%zewdAPI(path) e  q
	. . u path
	. . f i=1:1:5 w line(i),!
	. . c path
	. . s files(nextpage_".ewd")=""
	QUIT
	;
export(fileName,prefix,extension)
 ;
 n lc,list,rou,rouName,zewd
 ;
 s extension=$g(extension)
 i extension="" s extension="obj"
 i $g(fileName)="" s fileName="zewd.xml"
 i $g(prefix)="" s prefix="%zewd"
 s lc=$e(prefix,$l(prefix))
 s lc=$c($a(lc)-1)
 ;
 s rouName=$e(prefix,1,$l(prefix)-1)_lc
 f  s rouName=$o(^ROUTINE(rouName)) q:rouName=""  q:rouName'[prefix  d
 . i prefix="%e",rouName="%eXtc2" q
 . s list(rouName_"."_extension)=""
 . i extension="mac" s list(rouName_".obj")=""
 QUIT
 ;
copyToWLDSymbolTable(sessid)
 ;
 n %zzvarName
 ;
 d copySessionToSymbolTable^%zewdAPI(sessid)
 s PRESSED=$$getPRESSED^%zewdAPI(sessid)
 s %zzvarName=""
 f  s %zzvarName=$o(^%zewdSession("session",sessid,"ewd_selected",%zzvarName)) q:%zzvarName=""  d
 . d copyToSELECTED^%zewdAPI(%zzvarName,sessid)
 f  s %zzvarName=$o(^%zewdSession("session",sessid,"ewd_list",%zzvarName)) q:%zzvarName=""  d
 . d copyToLIST^%zewdAPI(%zzvarName,sessid)
 QUIT
 ;
mergeListToSession(fieldName,sessid)
 ;
 ;  Merges the contents of LIST(fieldName) to the ewd Developer session
 ;
 n code,text,pos
 ;
 d clearList^%zewdAPI(fieldName,sessid)
 s pos=""
 f  s pos=$o(LIST(fieldName,pos)) q:pos=""  d
 . s text=LIST(fieldName,pos)
 . s code=$p(text,"~",2)
 . s text=$p(text,"~",1)
 . i code="" s code=text
 . d appendToList^%zewdAPI(fieldName,text,code,sessid)
 QUIT
 ;
convertDaysToSeconds(days)
 QUIT days*86400
 ;
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 ;
parseHTMLFile(filepath,docName)
 ;
 n ok
 i $g(filepath)="" QUIT "File Path not defined"
 i $g(docName)="" QUIT "DOM Document Name not defined"
 s ok=$$openDOM^%zewdDOM(0,,,,,,,,,,,,,,,,,)
 i ok'="" QUIT ok
 s ok=$$removeDocument^%zewdDOM(docName,0,0)
 s ok=$$closeDOM^%zewdDOM()
 QUIT $$parseFile^%zewdHTMLParser(filepath,docName,,,1)
 ;
parseXMLFile(filepath,docName)
 ;
 n ok
 i $g(filepath)="" QUIT "File Path not defined"
 i $g(docName)="" QUIT "DOM Document Name not defined"
 s ok=$$openDOM^%zewdDOM(0,,,,,,,,,,,,,,,,,)
 i ok'="" QUIT ok
 s ok=$$removeDocument^%zewdDOM(docName,0,0)
 s ok=$$closeDOM^%zewdDOM()
 QUIT $$parseFile^%zewdHTMLParser(filepath,docName,,,0)
 ;
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 ;
parseStream(streamName,docName,error,isHTML)
 ;
 i $g(streamName)="" s error="Stream not defined" QUIT
 i $g(docName)="" s error="DOM Document Name not defined" QUIT
 s error=$$parseStream^%zewdHTMLParser(streamName,docName,$g(isHTML))
 QUIT
 ;
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 ;
parseHTMLStream(streamName,docName)
 ;
 n error
 d parseStream($g(streamName),$g(docName),.error)
 QUIT error
 ;
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 ;
 ;
exportToGTM(routine)
