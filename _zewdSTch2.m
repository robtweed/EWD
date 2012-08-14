%zewdSTch2 ; Sencha Touch v2 Tag Processors
 ;
 ; Product: Enterprise Web Developer (Build 935)
 ; Build Date: Mon, 13 Aug 2012 14:12:21
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
 QUIT
 ;
 ;
container(nodeOID,attrValue,docOID,technology)
 ;
 n appName,attr,bodyOID,configOID,cspScriptsOID,cssVersion,ewdActions,headOID,htmlOID
 n imgArray,jsOID,jsSectionOID,jsVersion
 n mainAttrs,nameList,ocOID,outerOID,rootPath,src,tagNameMap,text,title,xOID
 ;
 ;<st2:container rootPath="/ext-4" jsVersion="ext-all.js" title="Hello Ext" appName="HelloExt">
 ; .... etc
 ;</st:container>
 ;
 ; becomes:
 ;
 ;<ewd:xhtml>
 ; <head>
 ;  <title>Hello Ext</title>
 ;  <link rel="stylesheet" type="text/css" href="/ext-4/resources/css/ext-all.css">
 ;  <script type="text/javascript" src="/ext-4/ext-all.js"></script>
 ;  <script language="javascript">
 ;   Ext.application({
 ;    name: 'HelloExt',
 ;    launch: function() {
 ;      ...etc
 ;    }
 ;   });
 ;  </script>
 ; </head>
 ; <body></body>
 ;</ewd:xhtml>
 ;
 ; reset to outmost instance if it exists
 ;
 s xOID=nodeOID
 f  s xOID=$$getParentNode^%zewdDOM(xOID) q:xOID=""  d
 . i $$getTagName^%zewdDOM(xOID)="st2:container" s nodeOID=xOID
 ;
 s configOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 d setAttribute^%zewdDOM("preprocess","preProcess^%zewdSTch2Code",configOID)
 ;
 ; basic pre-processing of specific widget tags
 d getMappings(.tagNameMap)
 ;
 i $$getAttribute^%zewdDOM("smartcontainer",nodeOID)="true" d container^%zewdSmart(nodeOID)
 ;
 s outerOID=nodeOID
 d pass1(nodeOID,.tagNameMap)
 ; Expand out into items inside the outer widgets
 d pass2(nodeOID,.tagNameMap)
 ; post-processing of specific expanded tags
 d pass3(nodeOID,.tagNameMap)
 ;
 d getAttributes(nodeOID,.mainAttrs)
 ;
 s title=$g(mainAttrs("title"))
 i title="" s title="Sencha Touch 2 Application"
 s rootPath=$g(mainAttrs("rootpath"))
 i rootPath="" s rootPath="/st2.0/"
 s rootPath=$$addSlashAtEnd^%zewdST(rootPath)
 s jsVersion=$g(mainAttrs("jsversion"))
 i jsVersion="" s jsVersion="sencha-touch-all.js"
 s cssVersion=$g(mainAttrs("cssversion"))
 i cssVersion="" s cssVersion="sencha-touch.css"
 s appName=$g(mainAttrs("appname"))
 i appName="" s appName=$g(app)
 i appName="" s appName="ST2App"
 ;
 s htmlOID=$$addElementToDOM^%zewdDOM("ewd:xhtml",nodeOID)
 s headOID=$$addElementToDOM^%zewdDOM("head",htmlOID)
 s bodyOID=$$addElementToDOM^%zewdDOM("body",htmlOID)
 ;
 s xOID=$$addElementToDOM^%zewdDOM("title",headOID,,,title)
 ;
 s src=rootPath_"resources/css/"_cssVersion
 d registerResource^%zewdCustomTags("css",src,"",app)
 s src=rootPath_jsVersion
 d registerResource^%zewdCustomTags("js",src,"",app)
 ;
 ;d registerResource^%zewdCustomTags("js","ewdSTJS.js","stJS^%zewdSTJS",app)
 ;
 s attr("id")="ewdNullId"
 s attr("style")="display:none"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 ;s attr("id")="ewdContent"
 ;s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 ;
 s attr("id")="scriptTags"
 s cspScriptsOID=$$addElementToDOM^%zewdDOM("ewd:jssection",headOID,,.attr)
 ;
 ;s attr("id")="cspScripts"
 ;
 s attr("type")="text/javascript"
 s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s attr("id")="ST2Init"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s text=$$createExtFuncs^%zewdSTch2Code() ; ** ST2 functions in container page header!
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",xOID,,,text)
 ;
 s cspScriptsOID=$$addElementToDOM^%zewdDOM("ewd:jssection",headOID,,.attr)
 i technology="csp" d
 . n attr,cspOID
 . s text=" w ""<""_""script type='text/javascript'>"""_$c(13,10)
 . s cspOID=$$addCSPServerScript^%zewdAPI(cspScriptsOID,text)
 . d setAttribute^%zewdDOM("id","cspScripts",cspScriptsOID)
 e  d
 . n attr
 . s attr("type")="text/javascript"
 . s attr("id")="cspScripts"
 . s cspScriptsOID=$$addElementToDOM^%zewdDOM("script",cspScriptsOID,,.attr)
 ;
 d images(nodeOID,.imgArray)
 ; Create container for any user defined script code
 s attr("id")="UserDefinedCode"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ; Create container for any Sencha Touch Class Definitions
 s attr("id")="ST2ClassDefinitions"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 s text="Ext.application({"_$c(13,10)
 s text=text_" name:'"_appName_"',"_$c(13,10)
 i $d(imgArray) d
 . n comma,lcname,name,size,url
 . i $d(imgArray("icon")) d
 . . s text=text_" icon: {"_$c(13,10)
 . . s size="",comma=""
 . . f  s size=$o(imgArray("icon",size)) q:size=""  d
 . . . s url=imgArray("icon",size)
 . . . i $e(url,1)'="/" s url=rootPath_url
 . . . s text=text_"   "_comma_size_":'"_url_"'"_$c(13,10)
 . . . s comma=","
 . . s text=text_" },"_$c(13,10)
 . i $d(imgArray("startupImage")) d
 . . s text=text_" startupImage: {"_$c(13,10)
 . . s size="",comma=""
 . . f  s size=$o(imgArray("startupImage",size)) q:size=""  d
 . . . s url=imgArray("startupImage",size)
 . . . i $e(url,1)'="/" s url=rootPath_url
 . . . s text=text_"   "_comma_"'"_size_"':'"_url_"'"_$c(13,10)
 . . . s comma=","
 . . s text=text_" },"_$c(13,10)
 . ;f name="phoneStartupScreen","tabletStartupScreen" d
 . ;. s lcname=$$zcvt^%zewdAPI(name,"l")
 . ;. i $g(imgArray(lcname))'="" d
 . ;. . s url=imgArray(lcname)
 . ;. . i $e(url,1)'="/" s url=rootPath_url
 . ;. . s text=text_" "_name_":'"_url_"',"_$c(13,10)
 s text=text_" launch: function() {"_$c(13,10)
 i $g(mainAttrs("enableloader"))="true" s text=text_"   Ext.Loader.setConfig({enabled:true});"_$c(13,10)
 s text=text_"   EWD.st2.content()"_$c(13,10)
 s text=text_" }"_$c(13,10)
 s text=text_"});"_$c(13,10)
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 s text="EWD.st2.content = function() {"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s attr("id")="st2Content"
 s jsSectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s text="}"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 d childTags(nodeOID,jsSectionOID)
 i technology="csp" d
 . n cspOID
 . s text=" w ""<""_""/script>"""_$c(13,10)
 . s cspOID=$$addCSPServerScript^%zewdAPI(cspScriptsOID,text)
 s xOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 d removeAttribute^%zewdDOM("id",xOID)
 ; move any endOfHead code
 ;
 s ocOID=$$getTagOID^%zewdDOM("st2:optioncode",docName)
 i ocOID'="" d
 . n sOID
 . s ocOID=$$removeChild^%zewdDOM(ocOID)
 . s attr("type")="text/javascript"
 . s sOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 . s ocOID=$$appendChild^%zewdDOM(ocOID,sOID)
 . d removeIntermediateNode^%zewdDOM(ocOID)
 ;
 ; process nameList if it was created
 d removeIntermediateNode^%zewdDOM(nodeOID)
 d processNameList(.nameList,.formDeclarations)
 QUIT
 ;
images(nodeOID,imgArray)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st2:homescreen" d
 . . n attr,value
 . . ;f attr="phonestartupscreen","tabletstartupscreen" d
 . . ;. s value=$$getAttribute^%zewdDOM(attr,childOID)
 . . ;. s imgArray(attr)=value
 . . d icons(childOID,.imgArray)
 . . d removeIntermediateNode^%zewdDOM(childOID)
 QUIT
 ;
icons(nodeOID,imgArray)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st2:icon" d
 . . n size,url
 . . s size=$$getAttribute^%zewdDOM("size",childOID)
 . . s url=$$getAttribute^%zewdDOM("url",childOID)
 . . s imgArray("icon",size)=url
 . . d removeIntermediateNode^%zewdDOM(childOID)
 . i tagName="st2:startupimage" d
 . . n size,url
 . . s size=$$getAttribute^%zewdDOM("size",childOID)
 . . s url=$$getAttribute^%zewdDOM("url",childOID)
 . . s imgArray("startupImage",size)=url
 . . d removeIntermediateNode^%zewdDOM(childOID)
 QUIT
 ;
getMappings(tagNameMap) ;
 ;
 n arr,className,itemExpander,line,lineNo,ok,tagName
 ;
 k tagNameMap
 s tagName=""
 f  s tagName=$o(^zewd("mappingObject","st2",tagName)) q:tagName=""  d
 . s line=^zewd("mappingObject","st2",tagName)
 . s ok=$$parseJSON^%zewdJSON(line,.arr,1)
 . m tagNameMap(arr("tagName"))=arr
 f lineNo=1:1 s line=$t(mappingObjects+lineNo^%zewdSTch2Map) q:line["***END***"  d
 . s line=$p(line,";;",2,200)
 . s ok=$$parseJSON^%zewdJSON(line,.arr,1)
 . k tagNameMap(arr("tagName")) ; official versions take precedence!
 . m tagNameMap(arr("tagName"))=arr
 QUIT
 ;
childTags(nodeOID,jsSectionOID)
 ;
 n childNo,childOID,isFragment,OIDArray,parentTagName,tagName
 ;
 s parentTagName=$$getTagName^%zewdDOM(nodeOID)
 s isFragment=parentTagName="st2:fragment"
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="ewd:xhtml" q
 . i tagName="st2:jsLine" d
 . . n contentOID,text,xOID
 . . s text=$$getElementText^%zewdDOM(childOID)
 . . s contentOID=$$getElementById^%zewdDOM("st2Content",docOID)
 . . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",contentOID,,,text)
 . . i $$removeChild^%zewdDOM(childOID,1)
 . i tagName="st2:defineclass" d ExtDefine(childOID) q
 . i tagName="st2:createinstance" d ExtCreate(childOID,jsSectionOID,isFragment) q
 . i tagName="meta" d
 . . n headOID,tempOID
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s headOID=$$getTagOID^%zewdDOM("head",docName)
 . . s tempOID=$$insertNewFirstChildElement^%zewdDOM(headOID,"temp",docOID)
 . . s xOID=$$appendChild^%zewdDOM(xOID,tempOID)
 . . d removeIntermediateNode^%zewdDOM(tempOID)
 . i tagName="link" d
 . . n src,xOID
 . . s src=$$getAttribute^%zewdDOM("href",childOID)
 . . i src="" s src=$$getAttribute^%zewdDOM("src",childOID)
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . d registerResource^%zewdCustomTags("css",src,"",app)
 . i tagName="script" d
 . . n text,textArray
 . . s text=$$getElementText^%zewdDOM(childOID,.textArray)
 . . i text'="" d
 . . . n jsOID,parentOID
 . . . s parentOID=$$getElementById^%zewdDOM("UserDefinedCode",docOID)
 . . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",parentOID,,,text)
 . . . i $$removeChild^%zewdDOM(childOID,1)
 . . e  d
 . . . n scriptOID,jsOID
 . . . s jsOID=$$getElementById^%zewdDOM("scriptTags",docOID)
 . . . s scriptOID=$$removeChild^%zewdDOM(childOID)
 . . . s scriptOID=$$appendChild^%zewdDOM(scriptOID,jsOID)
 . i tagName="ewd:cspscript" d
 . . n attr,ecdOID,script
 . . s childOID=$$removeChild^%zewdDOM(childOID)
 . . s ecdOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 . . s childOID=$$appendChild^%zewdDOM(childOID,ecdOID)
 . i tagName="st2:json" d json(childOID)
 QUIT
 ;
ExtCreate(nodeOID,parentOID,isFragment)
 ;
 n add,attr,className,dataOID,id
 n mainAttrs,mOID,paramsOID,xOID
 ;
 s add=1
 do getAttributes(nodeOID,.mainAttrs)
 i $g(mainAttrs("object"))'="" d
 . s attr("return")=mainAttrs("object")
 . i $g(mainAttrs("var"))="true" s attr("var")="true"
 s attr("name")="Ext.create"
 s mOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",parentOID,,.attr)
 s paramsOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",mOID)
 s className=$g(mainAttrs("classname")) i className="" s className="unnamedClass"
 s attr("value")=className
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",paramsOID,,.attr)
 s dataOID=$$getFirstChild^%zewdDOM(nodeOID)
 s id=""
 i $$getTagName^%zewdDOM(dataOID)="st2:arguments" d
 . n mainAttrs,name,objOID
 . s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",paramsOID)
 . do getAttributes(dataOID,.mainAttrs)
 . i $g(mainAttrs("add"))="false" d
 . . s add=0
 . . k mainAttrs("add")
 . i $$getAttribute^%zewdDOM("id",dataOID)="" k mainAttrs("id")
 . s name=""
 . f  s name=$o(mainAttrs(name)) q:name=""  d
 . . s attr("name")=name
 . . s attr("value")=mainAttrs(name)
 . . s attr("type")="literal"
 . . i attr("value")="true"!(attr("value")="false") s attr("type")="boolean"
 . . i attr("value")="this" s attr("type")="reference"
 . . i $e(attr("value"),1,9)="function(" s attr("type")="reference"
 . . i $$numeric^%zewdJSON(attr("value")) s attr("type")="numeric"
 . . i $e(attr("value"),1)="." d
 . . . s attr("type")="reference"
 . . . s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . . i $e(attr("value"),1)="|" s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . . i name="id" s id=mainAttrs(name)
 . . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 . ;
 . ; find any lower-level objects
 . ;
 . d getChildNodes(dataOID,objOID)
 ;
 i isFragment d
 . n addTo,masked,pushTo,remove,text
 . q:className["Store"
 . q:'add
 . s addTo=$$addPhpVar^%zewdCustomTags("#tmp_addTo")
 . s pushTo=$$addPhpVar^%zewdCustomTags("#tmp_pushTo")
 . s masked=$$addPhpVar^%zewdCustomTags("#tmp_masked")
 . s remove=$$addPhpVar^%zewdCustomTags("#tmp_removeAll")
 . ;s text="var addTo='"_addTo_"';"_$c(13,10)
 . s text="var addTo='"_addTo_"';"_$c(13,10)
 . s text=text_"var pushTo='"_pushTo_"';"_$c(13,10)
 . s text=text_"var masked='"_masked_"';"_$c(13,10)
 . s text=text_"var remove='"_remove_"';"_$c(13,10)
 . s text=text_"if (remove === 'true') Ext.getCmp('"_addTo_"').removeAll(true);"_$c(13,10)
 . s text=text_"if (addTo !== '') Ext.getCmp('"_addTo_"').add(Ext.getCmp('"_id_"'));"_$c(13,10)
 . s text=text_"if (pushTo !== '') Ext.getCmp('"_pushTo_"').push(Ext.getCmp('"_id_"'));"_$c(13,10)
 . s text=text_"if (masked !== '') Ext.getCmp('"_masked_"').setMasked(false);"
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",parentOID,,,text)
 i $$removeChild^%zewdDOM(nodeOID,1)
 QUIT
 ;
fragment(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n botJSOID,configOID,ewdActions,jsOID,nameList,outerOID,tagNameMap,text,topJSOID,xOID
 ;
 ;<st2:fragment>
 ; .... etc
 ;</st2:fragment>
 ;
 s outerOID=nodeOID
 s configOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 d setAttribute^%zewdDOM("preprocess","preProcess^%zewdSTch2Code",configOID)
 ;
 ; Expand it out into items inside the outer widget
 d getMappings(.tagNameMap)
 ;
 d pass1(nodeOID,.tagNameMap)
 ; Expand out into items inside the outer widgets
 d pass2(nodeOID,.tagNameMap)
 ; post-processing of specific expanded tags
 d pass3(nodeOID,.tagNameMap)
 ;
 s jsOID=$$createFragmentJS()
 s topJSOID=$$getTagByNameAndAttr^%zewdDOM("st2:js","at","top",1,docName)
 i topJSOID'="" d
 . s jsOID=$$getElementById^%zewdDOM("ST2PreCode",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID)
 . s topJSOID=$$removeChild^%zewdDOM(topJSOID)
 . s topJSOID=$$appendChild^%zewdDOM(topJSOID,jsOID)
 . d removeIntermediateNode^%zewdDOM(topJSOID)
 s botJSOID=$$getTagByNameAndAttr^%zewdDOM("st2:js","at","bottom",1,docName)
 i botJSOID'="" d
 . s jsOID=$$getElementById^%zewdDOM("ST2PostCode",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID)
 . s botJSOID=$$removeChild^%zewdDOM(botJSOID)
 . s botJSOID=$$appendChild^%zewdDOM(botJSOID,jsOID)
 . d removeIntermediateNode^%zewdDOM(botJSOID)
 s jsOID=$$getElementById^%zewdDOM("ST2Code",docOID)
 d childTags(nodeOID,jsOID)
 d processNameList(.nameList,.formDeclarations)
 i $$removeChild^%zewdDOM(nodeOID,1)
 ;
 QUIT
 ;
createFragmentJS()
 ;
 n attr,jsOID,nsOID,postOID,preOID,xOID
 ;
 s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 d setAttribute^%zewdDOM("id","FragmentJavascript",jsOID)
 s attr("id")="ST2ClassDefinitions"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="cspScripts"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="ST2PreCode"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="ST2Code"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="ST2PostCode"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 QUIT jsOID
 ;
ExtDefine(nodeOID)
 ;
 n attr,callBack,className,dataOID
 n mainAttrs,mOID,paramsOID,parentOID,xOID
 ;
 do getAttributes(nodeOID,.mainAttrs)
 i $g(mainAttrs("object"))'="" d
 . s attr("return")=mainAttrs("object")
 . i $g(mainAttrs("var"))="true" s attr("var")="true"
 s parentOID=$$getElementById^%zewdDOM("ST2ClassDefinitions",docOID)
 s attr("name")="Ext.define"
 s mOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",parentOID,,.attr)
 s paramsOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",mOID)
 s className=$g(mainAttrs("classname")) i className="" s className="unnamedClass"
 s callBack=$g(mainAttrs("callback"))
 s attr("value")=className
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",paramsOID,,.attr)
 s dataOID=$$getFirstChild^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(dataOID)="st2:data" d
 . n mainAttrs,name,objOID
 . s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",paramsOID)
 . do getAttributes(dataOID,.mainAttrs)
 . i $$getAttribute^%zewdDOM("id",dataOID)="" k mainAttrs("id")
 . s name=""
 . f  s name=$o(mainAttrs(name)) q:name=""  d
 . . s attr("name")=name
 . . s attr("value")=mainAttrs(name)
 . . s attr("type")="literal"
 . . i attr("value")="true"!(attr("value")="false") s attr("type")="boolean"
 . . i attr("value")="this" s attr("type")="reference"
 . . i $e(attr("value"),1,9)="function(" s attr("type")="reference"
 . . i $$numeric^%zewdJSON(attr("value")) s attr("type")="numeric"
 . . i $e(attr("value"),1)="." d
 . . . s attr("type")="reference"
 . . . s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . . i $e(attr("value"),1)="|" s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 . ;
 . ; find any lower-level objects
 . ;
 . d getChildNodes(dataOID,objOID)
 ;
 ; Add the optional callback
 ;
 i callBack'="" d
 . s attr("name")=callBack
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",paramsOID,,.attr)
 ;
 i $$removeChild^%zewdDOM(nodeOID,1)
 QUIT
 ;
getChildNodes(nodeOID,objOID)
 ;
 n attr,attrName,attrs,childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . d getAttributeValues^%zewdDOM(childOID,.attrs)
 . s attrName=""
 . f  s attrName=$o(attrs(attrName)) q:attrName=""  d
 . . s attr=attrs(attrName)
 . . i $e(attr,1)="[",$e(attr,$l(attr))="]" d jsonItems(childOID,attrName)
 . ;i $$getAttribute^%zewdDOM("json",childOID)'="" d jsonItems(childOID)
 . i $d(tagNameMap(tagName,"parse")) d  q
 . . n method,optionName,x
 . . s method=tagNameMap(tagName,"parse","method")
 . . s optionName=$g(tagNameMap(tagName,"parse","optionName"))
 . . s x="d "_method_"("
 . . i optionName'="" s x=x_""""_optionName_""","
 . . s x=x_"childOID,objOID)"
 . . x x
 . i $$hasFnValue(childOID) d fn(childOID,objOID) q
 QUIT
 ;
hasFnValue(nodeOID)
 ;
 n childOID
 ;
 s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 i childOID="" QUIT 0
 i $$getTagName^%zewdDOM(childOID)="ewd:jsfunction" QUIT 1
 QUIT 0
 ;
fn(nodeOID,parentOID)
 ;
 n attr,childOID,fnOID,objOID,optionName,tagName
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s tagName=$p(tagName,"st2:",2)
 i $$zcvt^%zewdAPI(tagName,"l")=tagName d
 . s optionName=$$convertToCamelCase^%zewdST2(tagName)
 e  d
 . ; already in camel case
 . s optionName=tagName
 s attr("name")=$g(optionName)
 s attr("type")="function"
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 s fnOID=$$getFirstChild^%zewdDOM(nodeOID)
 s fnOID=$$removeChild^%zewdDOM(fnOID)
 s fnOID=$$appendChild^%zewdDOM(fnOID,objOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
configOption(nodeOID,parentOID)
 ;
 ; Generic Config Option: <st2:configOption optionName="features" optionType="arrayOfOptions">
 ;
 n mainAttrs,name,optionName,tagName,type
 ;
 s type=$g(mainAttrs("optiontype")) i type="" s type="object"
 i type="item" d item(nodeOID,parentOID) QUIT
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 do getAttributes(nodeOID,.mainAttrs)
 s name=$g(mainAttrs("optionname")) i name="" s name="unnamedOption"
 s type=$$zcvt^%zewdAPI(type,"l")
 s optionName(1)=$p(tagName,"st2:",2)
 d convertAttrsToCamelCase^%zewdST2(.optionName)
 i type="arrayofoptions" d arrayOfOptions(optionName(1),nodeOID,parentOID) QUIT
 i type="object" d object(optionName(1),nodeOID,parentOID) QUIT
 QUIT
 ;
array(name,nodeOID,parentOID)
 ;
 ;     <st2:axisFields>
 ;       <st2:axisField name="data1" />
 ;       <st2:axisField name="data2" /> 
 ;     </st2:items>
 ;
 ; becomes:
 ;
 ;    <ewd:jsNVP name="fields" type="array">
 ;      <ewd:jsliteral name="data1">
 ;      <ewd:jsliteral name="data2">
 ;    </ewd:jsNVP>
 n attr,objOID
 ;
 s attr("name")=name
 s attr("type")="array"
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 d getChildNodes(nodeOID,objOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
arrayItem(nodeOID,parentOID)
 ;
 n attr,lOID,name
 ;
 s name=$$getAttribute^%zewdDOM("name",nodeOID)
 s attr("name")=name
 s lOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",parentOID,,.attr)
 QUIT
 ;
object(name,nodeOID,parentOID)
 ;
 ;     <st2:layout type="vbox" align="left">
 ;
 ; becomes:
 ;
 ;    <ewd:jsNVP name="layout" type="object">
 ;      <ewd:jsNVP name="type" type="literal" value="vbox" />
 ;      <ewd:jsNVP name="align" type="literal" value="left" />
 ;    </ewd:jsNVP>
 ;
 n attr,objOID
 ;
 i name="stop" d
 . s name=$$getAttribute^%zewdDOM("value",nodeOID)
 . d removeAttribute^%zewdDOM("value",nodeOID)
 s attr("name")=name
 s attr("type")="object"
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 d createNVPs(nodeOID,objOID)
 d getChildNodes(nodeOID,objOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
listeners(nodeOID,objOID)
 ;
 ;     <st2:listeners>
 ;       <st2:listener render="function(){Ext.MessageBox.alert('rendered!');}" />
 ;     </st2:listeners>
 ;
 ; becomes:
 ;
 ;    <ewd:jsNVP name="listeners" type="object">
 ;      <ewd:jsNVP name="render" type="reference" value="function(){Ext.MessageBox.alert('rendered!');}" />
 ;    </ewd:jsNVP>
 ;
 n attr,childNo,childOID,lsOID,OIDArray,tagName,xOID
 ;
 s attr("name")="listeners"
 s attr("type")="object"
 s lsOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st2:listener" d
 . . n mainAttrs,name,value
 . . do getAttributes(childOID,.mainAttrs)
 . . k mainAttrs("id")
 . . s name=$o(mainAttrs(""))
 . . s value="" i name'="" s value=mainAttrs(name)
 . . i value'="" d
 . . . s attr("name")=name
 . . . s attr("type")="reference"
 . . . s attr("value")=value
 . . . i $e(attr("value"),1,8)'="function" s attr("value")="function() {"_attr("value")_"}"
 . . . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",lsOID,,.attr)
 . . . d removeIntermediateNode^%zewdDOM(childOID)
 . e  d
 . . i $$hasFnValue(childOID) d fn(childOID,lsOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
hasListener(listenerName,nodeOID,childOID)
 ;
 n childNo,OIDArray,status,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 s status=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:status
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st2:listener" d
 . . i $$getAttribute^%zewdDOM(listenerName,childOID)'="" s status=1
 ;
 QUIT status
 ;
arrayOfOptions(type,nodeOID,objOID)
 ;
 ;     <st2:items>
 ;       <st2:item region="north" html="hello" autoheight="true" border="false" />
 ;     </st2:items>
 ;
 ; becomes:
 ;
 ;    <ewd:jsNVP name="items" type="array">
 ;      <ewd:jsobject>
 ;        <ewd:jsNVP name="region" type="literal" value="north" />
 ;        <ewd:jsNVP name="html" type="literal" value="hello" />
 ;        <ewd:jsNVP name="autoheight" type="boolean" value="true" />
 ;        <ewd:jsNVP name="border" type="boolean" value="false" />
 ;      </ewd:jsobject>
 ;    </ewd:jsNVP>
 ;
 n attr,childNo,childOID,itemOID,itemsOID,OIDArray,tagName
 ;
 i $$hasChildNodes^%zewdDOM(nodeOID)="false" d  q
 . s attr("name")=type
 . s attr("type")="literal"
 . s attr("value")=$$getAttribute^%zewdDOM(type,nodeOID)
 . i $e(attr("value"),1)="." d
 . . s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . . s attr("type")="reference"
 . s itemsOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 e  d
 . s attr("name")=type
 . s attr("type")="array"
 . s itemsOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 . d getChildNodes(nodeOID,itemsOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
json(nodeOID)
 ;
 n at,mainAttrs,return,sessionName,jsOID,text,var
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s sessionName=$g(mainAttrs("sessionname")) i sessionName="" s sessionName="missingSessionName"
 s return=$g(mainAttrs("return")) i return="" s return="missingVar"
 s var=0
 i $g(mainAttrs("var"))="true" s var=1
 s jsOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 s text=" d streamJSON^%zewdJSON("""_sessionName_""","""_return_""","""_var_""",sessid)"
 i $$addCSPServerScript^%zewdAPI(jsOID,text)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
item(nodeOID,parentOID)
 ;
 n itemOID,mainAttrs,name,tagName,value
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 i $$getAttribute^%zewdDOM("hoistToST2Init",nodeOID)'="" d
 . n jOID,text,xOID
 . s jOID=$$getElementById^%zewdDOM("St2Init",docOID)
 . s text=$$getAttribute^%zewdDOM("hoistToST2Init",nodeOID)
 . d removeAttribute^%zewdDOM("hoistToST2Init",nodeOID)
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jOID,,,text)
 i $$getAttribute^%zewdDOM("xtype",nodeOID)="dummy" d
 . d removeAttribute^%zewdDOM("xtype",nodeOID)
 s itemOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",parentOID)
 d createNVPs(nodeOID,itemOID)
 d getChildNodes(nodeOID,itemOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
getAttributes(nodeOID,mainAttrs)
 ;
 n tagName
 ;
 k mainAttrs
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d convertAttrsToCamelCase^%zewdST2(.mainAttrs)
 i tagName="st2:item",$g(mainAttrs("id"))="",$g(mainAttrs("xtype"))="" QUIT
 i $g(mainAttrs("id"))="" s mainAttrs("id")=$$uniqueId(nodeOID)
 i $g(tagNameMap(tagName,"hasId"))="false" k mainAttrs("id")
 QUIT
 ;
createNVPs(nodeOID,parentOID)
 ;
 n attr,mainAttrs,name,value,xOID
 ;
 d getAttributes(nodeOID,.mainAttrs)
 i $$getTagName^%zewdDOM(nodeOID)="st2:sorter" d
 . k mainAttrs("id")
 i $$getTagName^%zewdDOM(nodeOID)="st2:field" d
 . k mainAttrs("id")
 . i $g(mainAttrs("type"))="" s mainAttrs("type")="auto"
 i $$getTagName^%zewdDOM(nodeOID)="st2:childel" d
 . i $g(mainAttrs("itemid"))="",$g(mainAttrs("name"))'="" s mainAttrs("itemid")=mainAttrs("name")
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . s value=mainAttrs(name)
 . i value'="" d
 . . s attr("name")=name
 . . s attr("value")=value
 . . s attr("type")="literal"
 . . i value="true"!(value="false") s attr("type")="boolean"
 . . i value="this" s attr("type")="reference"
 . . i $e(attr("value"),1,9)="function(" s attr("type")="reference"
 . . i $$numeric^%zewdJSON(value) s attr("type")="numeric"
 . . i $e(value,1)="." d
 . . . s value=$e(value,2,$l(value))
 . . . s attr("type")="reference"
 . . . s attr("value")=value
 . . i $e(attr("value"),1)="|" s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 QUIT
 ;
pass1(nodeOID,tagNameMap)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . i $$getNodeType^%zewdDOM(childOID)'=1 q
 . i $$getAttribute^%zewdDOM("smartframediv",childOID)'="" d
 . . n div,html,lt
 . . s div=$$getAttribute^%zewdDOM("smartframediv",childOID)
 . . d removeAttribute^%zewdDOM("smartframediv",childOID)
 . . s lt="<"
 . . i $$getTagName^%zewdDOM(nodeOID)="st2:fragment" s lt="&lt;"
 . . s html=lt_"div id='"_div_"'>"
 . . s html=html_"***EMPTY***"
 . . s html=html_lt_"/div>"
 . . d setAttribute^%zewdDOM("html",html,childOID)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i $g(tagNameMap(tagName,"pass1Method"))'="" d
 . . n x
 . . s x="d "_tagNameMap(tagName,"pass1Method")_"(childOID)"
 . . x x
 . d pass1(childOID,.tagNameMap)
 QUIT
 ;
seriesChildren(nodeOID)
 ;
 n childNo,childOID,OIDArray,xOID
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . i $$getTagName^%zewdDOM(childOID)="st2:tips" d
 . . s xOID=$$renameTag^%zewdDOM("st2:charttips",childOID,1)
 QUIT
 ;
 ;addEwdActionField(nodeOID)
 ;
 ;n attr,items,no,xOID
 ;
 ;s items=$$getAttribute^%zewdDOM("items",nodeOID)
 ;i $e(items,1)="[",$e(items,$l(items))="]" QUIT
 ;s attr("name")="ewd_action"
 ;s attr("id")="ewd_action"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;s attr("value")="zewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;;s nameList("ewd_action")="hidden|"_attr("value")
 ;s no=$increment(ewdActions)
 ;s ewdActions(no)=attr("value")
 ;s xOID=$$addElementToDOM^%zewdDOM("st2:hiddenfield",nodeOID,,.attr)
 ;QUIT
 ;
swapFormFields(nodeOID)
 ;
 n parentOID,type,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="st2:axisfields" d  QUIT
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("st2:axisfield",nodeOID,1)
 ;
 i $$getTagName^%zewdDOM(parentOID)="st2:axis" d  QUIT
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("st2:axisfield",nodeOID,1)
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"st2:axisfields",docOID)
 ;
 s type=$$getAttribute^%zewdDOM("type",nodeOID)
 i type["field" d
 . s xOID=$$renameTag^%zewdDOM("st2:"_type,nodeOID,1)
 . d removeAttribute^%zewdDOM("type",xOID)
 . d setNameList(xOID)
 ;
 QUIT
 ;
convertMenu(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="st2:menuitem" d
 . s xOID=$$renameTag^%zewdDOM("st2:buttonmenu",nodeOID,1)
 ;
 QUIT
 ;
convertMenuItem(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="st2:menuitem" d
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"st2:buttonmenu",docOID)
 ;
 QUIT
 ;
fieldsAttr(nodeOID)
 ;
 n fields
 ;
 s fields=$$getAttribute^%zewdDOM("fields",nodeOID)
 i fields'="" d
 . i $e(fields,1,2)=".[",$e(fields,$l(fields))="]" q
 . i $e(fields,1)="[" d setAttribute^%zewdDOM("fields","."_fields,nodeOID) q
 . i $e(fields,1)'="[",$e(fields,$l(fields))'="]" d setAttribute^%zewdDOM("fields",".['"_fields_"']",nodeOID) q
 QUIT
 ;
addAxisFields(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)'="st2:axisfields" d
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"st2:axisfields",docOID)
 QUIT
 ;
getOptionTags(nodeOID,id)
 ;
 n array1,array2,childNo,childOID,comma,display,OIDArray,optionsOID,useList,value
 ;
 s array1="",array2="",comma=""
 s useList=$$getAttribute^%zewdDOM("uselist",nodeOID)
 i useList'="" d  QUIT
 . n dataIndex,gpOID,jsOID,text,xOID
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s gpOID=$$getParentNode^%zewdDOM(nodeOID)
 . s xOID=$$appendChild^%zewdDOM(xOID,$$getParentNode^%zewdDOM(gpOID))
 . ;. s jsOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 . s dataIndex=$$getAttribute^%zewdDOM("dataindex",nodeOID)
 . s text=" d optionsFromList^%zewdExt4Code("""_useList_""","""_dataIndex_""","""_id_""",sessid)"
 . i $$addCSPServerScript^%zewdAPI(xOID,text)
 . d removeIntermediateNode^%zewdDOM(xOID)
 ;
 s optionsOID=$$getOptionsTag(nodeOID)
 i optionsOID="" QUIT
 d getChildrenInOrder^%zewdDOM(optionsOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s value=$$getAttribute^%zewdDOM("value",childOID)
 . s display=$$getAttribute^%zewdDOM("displayvalue",childOID)
 . s array1=array1_comma_"['"_value_"','"_display_"']"
 . s array2=array2_comma_"'"_value_"':'"_display_"'"
 . s comma=","
 d addOptionCode(nodeOID,id,array1,array2)
 ;
 QUIT
 ;
addOptionCode(nodeOID,id,array1,array2)
 ;
 n comma,dataIndex,display,ocOID,text,textOID
 ;
 s ocOID=$$getTagOID^%zewdDOM("st2:optioncode",docName)
 i ocOID="" d
 . n cOID
 . s cOID=$$getTagOID^%zewdDOM("st2:container",docName)
 . s ocOID=$$addElementToDOM^%zewdDOM("st2:optioncode",cOID)
 ;
 s dataIndex=$$getAttribute^%zewdDOM("dataindex",nodeOID)
 s text="EWD.ext4.grid['"_id_"'].combo.store['"_dataIndex_"'] = ["
 s text=text_array1
 s text=text_"];"_$c(13,10)
 s text=text_"EWD.ext4.grid['"_id_"'].combo.index['"_dataIndex_"'] = {"
 s text=text_array2
 s text=text_"};"
 s textOID=$$createTextNode^%zewdDOM(text,docOID)
 s textOID=$$appendChild^%zewdDOM(textOID,ocOID)
 ;
 QUIT
 ;
getOptionsTag(nodeOID)
 ;
 n childNo,childOID,OIDArray,stop
 ;
 s childOID=""
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . s childOID=OIDArray(childNo)
 . i $$getTagName^%zewdDOM(childOID)="st2:options" s stop=1
 QUIT childOID
 ;
getGridPanelId(nodeOID)
 ;
 n gpOID,id
 ;
 s id=""
 s gpOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(gpOID)="st2:gridpanel" d
 . s id=$$getAttribute^%zewdDOM("id",gpOID)
 . i id="" s id=$$uniqueId(gpOID)
 QUIT id
 ;
getColNo(nodeOID)
 ;
 n gpOID,no
 ;
 s no=0
 s gpOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(gpOID)="st2:gridpanel" d
 . n childNo,childOID,OIDArray,stop
 . d getChildrenInOrder^%zewdDOM(gpOID,.OIDArray)
 . s childNo="",stop=0
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . . s childOID=OIDArray(childNo)
 . . i $$getTagName^%zewdDOM(childOID)="st2:gridcolumn" d
 . . . s no=no+1
 . . . i childOID=nodeOID s stop=1
 QUIT no
 ;
odd(nodeOID)
 ;
 n stroke
 ;
 s stroke=$$getAttribute^%zewdDOM("strokewidth",nodeOID)
 i stroke'="" d
 . d setAttribute^%zewdDOM("'stroke-width'",stroke,nodeOID)
 . d removeAttribute^%zewdDOM("strokewidth",nodeOID)
 QUIT
 ;
switchLabel(nodeOID)
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="st2:axis" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("st2:axislabel",nodeOID,1)
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="st2:series" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("st2:serieslabel",nodeOID,1)
 QUIT
 ;
switchFields(nodeOID)
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="st2:axis" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("st2:axisfields",nodeOID,1)
 QUIT
 ;
checkToolbar(nodeOID)
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="st2:picker" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("st2:pickertoolbar",nodeOID,1)
 QUIT
 ;
setPicker(nodeOID)
 ;
 n parentTagName,xOID
 ;
 s parentTagName=$$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))
 i parentTagName="st2:datepicker"!(parentTagName="st2:datepickerfield") d  QUIT
 . s xOID=$$renameTag^%zewdDOM("st2:datefieldpicker",nodeOID,1)
 QUIT
 ;
setDatePicker(nodeOID)
 n attr,day,id,lOID,lsOID,month,pOID,year,value,yearFrom,yearTo
 ;
 s id=$$getAttribute^%zewdDOM("id",nodeOID)
 i id="" s id=$$uniqueId(nodeOID)
 s day=$$addPhpVar^%zewdCustomTags("#"_id_".day","j")
 s month=$$addPhpVar^%zewdCustomTags("#"_id_".month","j")
 s year=$$addPhpVar^%zewdCustomTags("#"_id_".year","j")
 s value=".{day:"_day_",month:"_month_",year:"_year_"}"
 ;d setAttribute^%zewdDOM("value",value,nodeOID)
 i '$$hasChildTag^%zewdDOM(nodeOID,"st2:listeners",.lsOID) d
 . s lsOID=$$addElementToDOM^%zewdDOM("st2:listeners",nodeOID)
 s attr("painted")="function(me) {if ("_year_" !== '') this.setValueAnimated({day:"_day_",month:"_month_",year:"_year_"})}"
 s lOID=$$addElementToDOM^%zewdDOM("st2:listener",lsOID,,.attr)
 QUIT
 ;
setNameList(nodeOID)
 n tagName,xOID
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 i tagName="st2:datefield" s xOID=$$renameTag^%zewdDOM("st2:datepickerfield",nodeOID,1)
 i tagName="st2:checkboxfield"!(tagName="st2:radiofield") d
 . n groupAttr,id,name,OIDArray,pOID,stop,xOID
 . s groupAttr="cbgroup"
 . s id=$$getAttribute^%zewdDOM("id",nodeOID)
 . s name=$$getAttribute^%zewdDOM("name",nodeOID)
 . d
 . . i id="",name'="" d  q
 . . . s id=name_$p(nodeOID,"-",2)
 . . . d setAttribute^%zewdDOM("id",id,nodeOID)
 . i tagName="st2:radiofield" q
 . i $$getAttribute^%zewdDOM(groupAttr,nodeOID)="true" q
 . s pOID=nodeOID
 . s stop=0
 . f  d  q:stop
 . . s pOID=$$getParentNode^%zewdDOM(pOID)
 . . i pOID="" s stop=1  q
 . . i $$getTagName^%zewdDOM(pOID)="st2:formpanel" s stop=1
 . i pOID="" QUIT  ; erroneous situation!
 . d getDescendantNodes^%zewdDOM(pOID,.OIDArray)
 . s xOID=""
 . f  s xOID=$o(OIDArray(xOID)) q:xOID=""  d
 . . i xOID=nodeOID q
 . . i OIDArray(xOID)="st2:checkboxfield" d
 . . . i $$getAttribute^%zewdDOM("name",xOID)=name d
 . . . . d setAttribute^%zewdDOM(groupAttr,"true",xOID)
 . . . . d setAttribute^%zewdDOM(groupAttr,"true",nodeOID)
 ;
 d setNameList^%zewdExt4(nodeOID)
 QUIT
 ;
 n name,id,tagName,type
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s name=$$getAttribute^%zewdDOM("name",nodeOID)
 i tagName'="st2:radiofield" d  ;,tagName'="st2:checkboxfield" d
 . s id=$$getAttribute^%zewdDOM("id",nodeOID)
 . i id="" d
 . . i name="" d
 . . . s id=$$uniqueId(nodeOID)
 . . e  d
 . . . s id=name
 . . d setAttribute^%zewdDOM("id",id,nodeOID)
 . i name="" d
 . . d setAttribute^%zewdDOM("name",id,nodeOID)
 . . s name=id
 s type=$g(tagNameMap(tagName,"fieldType"))
 i type="" s type="text"
 i name="ewd_action" s type=type_"|"_$$getAttribute^%zewdDOM("value",nodeOID)
 i tagName'="st2:displayfield" d
 . s nameList(name)=type ;leaks out to container or fragment!
 ;
 i tagName="st2:timefield" d
 . n format
 . s format=$$getAttribute^%zewdDOM("format",nodeOID)
 . s format=$$zcvt^%zewdAPI(format,"l")
 . i format="24hour"!((format["24")&(format["h")) d
 . . d setAttribute^%zewdDOM("format","H:i",nodeOID)
 i tagName="st2:radiofield" d
 . n phpVar,value
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_name,"j")
 . s value=$$getAttribute^%zewdDOM("inputvalue",nodeOID)
 . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 i tagName="st2:checkboxfield" d
 . d setAttribute^%zewdDOM("value","*",nodeOID)
 . ;n phpVar,value
 . ;s value=$$getAttribute^%zewdDOM("inputvalue",nodeOID)
 . ;s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_selected."_name_"."_value,"j")
 . ;d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 d
 . n value
 . s value=$$getAttribute^%zewdDOM("value",nodeOID)
 . i value="*" d setAttribute^%zewdDOM("value",("#"_name),nodeOID)
 ;
 QUIT
 ;
submitButton(nodeOID)
 ;
 n addTo,attr,formId,handler,nextPage,pOID,replace,stop,text,xOID
 ;
 s xOID=$$renameTag^%zewdDOM("st2:button",nodeOID,1)
 s pOID=nodeOID
 s stop=0
 f  d  q:stop
 . s pOID=$$getParentNode^%zewdDOM(pOID)
 . i $$getTagName^%zewdDOM(pOID)="st2:formpanel" s stop=1
 i pOID="" QUIT  ; erroneous situation!
 s formId=$$getAttribute^%zewdDOM("id",pOID)
 i formId="" d
 . s formId=$$uniqueId(pOID)
 . d setAttribute^%zewdDOM("id",formId,pOID)
 s nextPage=$$getAttribute^%zewdDOM("nextpage",nodeOID)
 s addTo=$$getAttribute^%zewdDOM("addto",nodeOID)
 s replace=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)="true"
 f attr="nextpage","addto","replacepreviouspage" d removeAttribute^%zewdDOM(attr,nodeOID)
 s handler=".function() {EWD.st2.submit('"_formId_"','"_nextPage_"','"_addTo_"',"_replace_")}"
 d setAttribute^%zewdDOM("handler",handler,nodeOID)
 ;
 QUIT
 ;
tabPanelActiveTab(nodeOID)
 ;
 n childNo,childOID,OIDArray,stop,tpOID
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . s childOID=OIDArray(childNo)
 . i $$getTagName^%zewdDOM(childOID)="st2:panel" d
 . . i $$getAttribute^%zewdDOM("isactive",childOID)="true" d
 . . . d setAttribute^%zewdDOM("activeItem",childNo-1,nodeOID)
 . . . s stop=1
 . . . d removeAttribute^%zewdDOM("isactive",childOID)
 ;
 QUIT
 ;
pass2(nodeOID,tagNameMap)
 ;
 n argumentsOID,childNo,childOID,OIDArray,parentOID
 ;
 ; Get the top-level outer widgets and expand to items format: eg turns:
 ;
 ;<st2:container rootPath="/ext-4" jsVersion="ext-all-debug.js" title="Extjs 4 Test" appName="HelloExt">
 ;  <st2:viewPort object="theViewPort" layout="border" var="true">
 ;    <st2:panel region="center" margins="5 5 5 0" bodyStyle="background:#f1f1f1" html="Empty center panelsdfs" />
 ;    <st2:accordionPanel region="west" margins="5 0 5 5" split="true" width=210>
 ;      <st2:panel title="Accordion Item 1" html="Currently empty" />
 ;      <st2:panel title="Accordion Item 2" html="Currently empty" />
 ;      <st2:panel title="Accordion Item 3" html="Currently empty" />
 ;    </st2:accordionPanel>
 ;  </etx4:viewPort>
 ;</st2:container>
 ;
 ; into:
 ;
 ;<st2:container rootPath="/ext-4" jsVersion="ext-all-debug.js" title="Extjs 4 Test" appName="HelloExt">
 ;  <st2:viewPort object="theViewPort" layout="border" var="true">
 ;    <st2:items>
 ;      <st2:item xtype="panel" region="center" margins="5 5 5 0" bodyStyle="background:#f1f1f1" html="Empty center panel" />
 ;      <st2:item xtype="panel" region="west" margins="5 0 5 5" split="true" width=210 layout="accordion">
 ;        <st2:items>
 ;          <st2:item xtype="panel" title="Accordion Item 1" html="Currently empty" />
 ;          <st2:item xtype="panel" title="Accordion Item 2" html="Currently empty" />
 ;          <st2:item xtype="panel" title="Accordion Item 3" html="Currently empty" />
 ;        </st2:items>
 ;      </st2:item>
 ;    </ext:items>
 ;  </etx4:viewPort>
 ;</st2:container>
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . ;i $$hasChildNodes^%zewdDOM(childOID)="true" d
 . d
 . . n argumentsOIS,parentOID
 . . s parentOID=$$addElementToDOM^%zewdDOM("temp",nodeOID)
 . . d expand(childOID,parentOID,.tagNameMap)
 . . i $$getNodeType^%zewdDOM(childOID)=1 s argumentsOID=$$convertToInstance(childOID)
 . . i $$hasChildNodes^%zewdDOM(parentOID)="true" d
 . . . s parentOID=$$removeChild^%zewdDOM(parentOID)
 . . . s parentOID=$$appendChild^%zewdDOM(parentOID,argumentsOID)
 . . d removeIntermediateNode^%zewdDOM(parentOID)
 ;
 QUIT
 ;
convertToInstance(nodeOID)
 ;
 n argumentsOID,attr,className,instanceOID,mainAttrs,name,parentOID,tagNameMap
 ;
 d getMappings(.tagNameMap)
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s className=$g(tagNameMap(tagName,"className"))
 i className="" QUIT nodeOID
 s attr("classname")=className
 d getAttributes(nodeOID,.mainAttrs)
 f name="object","var" d
 . i $g(mainAttrs(name))'="" d
 . . s attr(name)=mainAttrs(name)
 . . k mainAttrs(name)
 s instanceOID=$$addElementToDOM^%zewdDOM("st2:createinstance",nodeOID,,.attr)
 ; automatically render to container body unless stated otherwise
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="st2:container" d
 . n renderTo
 . s renderTo=$g(mainAttrs("renderto"))
 . i renderTo=""!($$zcvt^%zewdAPI(renderTo,"l")="autorender") d
 . . ;s mainAttrs("renderto")=".Ext.getBody()"
 m attr=mainAttrs
 ;d
 i $g(tagNameMap(tagName,"instanceMethod"))'="" d
 . n x
 . s x="s argumentsOID=$$"_tagNameMap(tagName,"instanceMethod")_"(.attr,nodeOID,instanceOID)"
 . x x
 e  d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attr)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT argumentsOID
 ;
expandContainer(nodeOID,attr,parentOID)
 n ok
 s ok=$$containerInstance^%zewdExt4(.attr,nodeOID,parentOID)
 QUIT
 ;
containerInstance(attrs,nodeOID,instanceOID)
 QUIT $$containerInstance^%zewdExt4(.attr,nodeOID,parentOID)
 ;
panelInstance(attrs,nodeOID,instanceOID)
 ;
 n addPage,addTo,argumentsOID,id,pushTo,src
 ;
 s addTo="",pushTo=""
 s addPage=0
 i $g(attrs("addpage"))'="" d
 . s attrs("src")=attrs("addpage")
 . k attrs("addpage")
 . s addTo=$g(attrs("id"))
 . s addPage=1
 ;
 s src=$g(attrs("src"))
 s src=$p(src,".ewd",1)
 k attrs("src")
 s id="ST2Panel"_$$uniqueId^%zewdAPI(nodeOID,filename)_"Div"
 i src'="",'addPage d
 . s attrs("html")="<span id='"_id_"'></span>"
 . i $g(attrs("addto")) d
 . . s addTo=attrs("addto")
 . . k attrs("addto")
 . i $g(attrs("pushto")) d
 . . s pushTo=attrs("pushto")
 . . k attrs("pushto")
 ;
 s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attrs)
 i src'="" d
 . n attr,listenersOID,text,xOID
 . s listenersOID=$$addElementToDOM^%zewdDOM("st2:listeners",argumentsOID)
 . ;i '$$hasChildTag^%zewdDOM(nodeOID,"st2:listeners",.listenersOID) d
 . ;. s listenersOID=$$addElementToDOM^%zewdDOM("st2:listeners",argumentsOID)
 . s text="var nvp='';"
 . i pushTo'="" d
 . . s text=text_"nvp=nvp+'st2_pushTo="_pushTo_"';"_$c(13,10)
 . i addTo'="" d
 . . s text=text_"nvp=nvp+'st2_addTo="_addTo_"';"_$c(13,10)
 . . i addPage d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',nvp:nvp});"
 . . e  d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"',nvp:nvp});"
 . e  d
 . . s text="EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"'});"
 . s attr("initialize")=text
 . s xOID=$$addElementToDOM^%zewdDOM("st2:listener",listenersOID,,.attr)
 ;
 QUIT argumentsOID
 ;
expand(nodeOID,parentOID,tagNameMap)
 ;
 n attr,childNo,childOID,containerTag,isMapped,itemOID,itemsAdded,itemsOID
 n OIDArray,property,tagName,text,xtypeTagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s containerTag=""
 . i $$getNodeType^%zewdDOM(childOID)=3 d  q
 . . n textOID
 . . s textOID=$$removeChild^%zewdDOM(childOID)
 . . s textOID=$$appendChild^%zewdDOM(textOID,parentOID)
 . d getAttributeValues^%zewdCustomTags(childOID,.attr)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . s isMapped=0
 . i '$d(itemsOID) s itemsOID=parentOID
 . s xtypeTagName=tagName
 . i $d(tagNameMap(tagName)) d
 . . n ptype,xclass,xtype
 . . s xclass=$g(tagNameMap(tagName,"xclass"))
 . . s ptype=$g(tagNameMap(tagName,"ptype"))
 . . s xtype=$g(tagNameMap(tagName,"xtype"))
 . . i xclass="true" d
 . . . s xtype="dummy"
 . . . s attr("xclass")=$g(tagNameMap(tagName,"className"))
 . . i xtype'=""!(ptype'="") d
 . . . i xtype'="" s attr("xtype")=xtype
 . . . i ptype'="" s attr("ptype")=ptype
 . . . s xtypeTagName=$g(tagNameMap(tagName,"xtypeTagName"))
 . . . ;i xtypeTagName="" s xtypeTagName="st2:item"
 . . . s containerTag=$g(tagNameMap(tagName,"containerTag"))
 . . . ;i containerTag="" s containerTag="st2:items"
 . . . i containerTag="st2:dockeditems",$$hasChildTag^%zewdDOM(parentOID,containerTag,.itemsOID) d
 . . . . s itemsAdded(containerTag)=itemsOID
 . . . s isMapped=1
 . . i $d(tagNameMap(tagName,"addAttributes")) d
 . . . n name
 . . . s name=""
 . . . f  s name=$o(tagNameMap(tagName,"addAttributes",name)) q:name=""  d
 . . . . i $g(attr(name))="" s attr(name)=tagNameMap(tagName,"addAttributes",name)
 . . i $g(tagNameMap(tagName,"expandMethod"))'="" d
 . . . n x
 . . . s x="d "_tagNameMap(tagName,"expandMethod")_"(childOID,.attr,parentOID)"
 . . . x x
 . i isMapped,containerTag'="",'$d(itemsAdded(containerTag)) d
 . . i $$getTagName^%zewdDOM(parentOID)=containerTag d
 . . . s itemsOID=parentOID
 . . e  d
 . . . n allowedParent,altFound,no
 . . . s no="",altFound=0
 . . . f  s no=$o(tagNameMap(tagName,"allowedContainers",no)) q:no=""  d
 . . . . s allowedParent=tagNameMap(tagName,"allowedContainers",no)
 . . . . i allowedParent=$$getTagName^%zewdDOM(parentOID) d
 . . . . . s itemsOID=parentOID
 . . . . . s altFound=1
 . . . i 'altFound d
 . . . . s itemsOID=$$addElementToDOM^%zewdDOM(containerTag,parentOID)
 . . s itemsAdded(containerTag)=itemsOID
 . s itemsOID=parentOID
 . i containerTag'="",$d(itemsAdded(containerTag)) s itemsOID=itemsAdded(containerTag)
 . s itemOID=$$addElementToDOM^%zewdDOM(xtypeTagName,itemsOID,,.attr)
 . i $$getAttribute^%zewdDOM("nextpage",itemOID)'="" d
 . . i $$getTagName^%zewdDOM(nodeOID)="st2:actioncolumn" d
 . . . d setAttribute^%zewdDOM("xtype","actioncolumn",itemOID)
 . . d nextPageHandler(itemOID)
 . i $$hasChildNodes^%zewdDOM(childOID)="true" d expand(childOID,itemOID,.tagNameMap)
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 QUIT
 ;
listPass1(nodeOID)
 ;
 n addTo,attr,code,event,listenersOID,OID,maskMsg,maskObj,nextPage,params,pushTo
 n replacePreviousPage,setMask,tagName,xOID
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s nextPage=$$getAttribute^%zewdDOM("nextpage",nodeOID)
 d removeAttribute^%zewdDOM("nextpage",nodeOID)
 s addTo=$$getAttribute^%zewdDOM("addto",nodeOID)
 d removeAttribute^%zewdDOM("addto",nodeOID)
 s pushTo=$$getAttribute^%zewdDOM("pushto",nodeOID)
 d removeAttribute^%zewdDOM("pushto",nodeOID)
 s replacePreviousPage=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 d removeAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 s setMask=$$getAttribute^%zewdDOM("setmask",nodeOID)
 d removeAttribute^%zewdDOM("setmask",nodeOID)
 s maskMsg=$$getAttribute^%zewdDOM("maskmessage",nodeOID)
 d removeAttribute^%zewdDOM("maskmessage",nodeOID)
 ;
 s code=""
 i nextPage'="" d
 . i '$$hasChildTag^%zewdDOM(nodeOID,"st2:listeners",.listenersOID) d
 . . s listenersOID=$$addElementToDOM^%zewdDOM("st2:listeners",nodeOID)
 . i $$hasListener("itemtap",listenersOID,.xOID) d
 . . s code=$$getAttribute^%zewdDOM("itemtap",xOID)
 . . i $e(code,1,8)="function" d
 . . . n nb,rcode
 . . . s nb=$l(code,"}")
 . . . s rcode=$re(code)
 . . . s rcode=$p(rcode,"}",2,nb)
 . . . s code=$re(rcode)_";"
 . . e  d
 . . . i $e(code,$l(code))'=";" s code=code_";"
 . ;
 . ;s code=""
 . s code=code_"EWD.record=record;var page='"_$g(nextPage)_"';"
 . s code=code_"if (typeof record.raw.nextPage !== 'undefined') page = record.raw.nextPage;"
 . s code=code_"var addTo='"_$g(addTo)_"';"
 . s code=code_"if (typeof record.raw.addTo !== 'undefined') addTo = record.raw.addTo;"
 . s code=code_"var pushTo='"_$g(pushTo)_"';"
 . s code=code_"if (typeof record.raw.pushTo !== 'undefined') pushTo = record.raw.pushTo;"
 . s code=code_"var replace='"_$g(replacePreviousPage)_"';"
 . s code=code_"if (typeof record.raw.replacePreviousPage !== 'undefined') replace = record.raw.replacePreviousPage;"
 . s code=code_"var nvp='recordNo=' + (index + 1);"
 . s code=code_"if (typeof record.raw.recordNo !== 'undefined') nvp='recordNo=' + record.raw.recordNo;"
 . s code=code_"if (typeof record.raw.nvp !== 'undefined') nvp = nvp + '&' + record.raw.nvp;"
 . s code=code_"nvp = nvp + '&st2_addTo=' + addTo;"
 . s code=code_"nvp = nvp + '&st2_pushTo=' + pushTo;"
 . s code=code_"nvp = nvp + '&st2_removeAll=' + replace;"
 . i setMask'="" d
 . . s code=code_"nvp = nvp + '&st2_masked="_setMask_"';"
 . . s maskObj="{xtype:'loadmask'"
 . . i maskMsg'="" s maskObj=maskObj_",message:'"_maskMsg_"'"
 . . s maskObj=maskObj_"}"
 . . s code=code_"Ext.getCmp('"_setMask_"').setMasked("_maskObj_");"
 . s event="itemtap",params="dataView,index,target,record"
 . i tagName="st2:nestedlist" d
 . . s event="leafitemtap"
 . . s params="nestedList,list,index,target,record"
 . s attr(event)="function("_params_") {"_code_"EWD.ajax.getPage({page:page,nvp:nvp})}"
 . s xOID=$$addElementToDOM^%zewdDOM("st2:listener",listenersOID,,.attr)
 QUIT
 ;
expandSelectField(nodeOID,attr,parentOID)
 n ok
 s ok=$$selectFieldInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
selectFieldInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,id,mainAttrs,tagName,text,xOID
 ;
 m mainAttrs=attrs
 s id=$g(attrs("id"))
 s attrs("options")=".EWD.st2.options['"_id_"']"
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 s text=" d writeSelectOptions^%zewdSTch2Code("""_id_""",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="selectfield" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandSlot(nodeOID,attr,parentOID)
 n ok
 s ok=$$slotInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
slotInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,id,mainAttrs,name,tagName,text,xOID
 ;
 s id=$g(attrs("id"))
 s name=$g(attrs("name"))
 d
 . i id="",name'="" d  q
 . . s id=name
 . . s attrs("id")=id
 . i id'="",name="" d  q
 . . s name=id
 . . s attrs("name")=name
 i id'="" d
 . s attrs("data")=".EWD.st2.options['"_id_"']"
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeSelectOptions^%zewdSTch2Code("""_id_""",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("value"))="*",id'="" d
 . s attrs("value")="#"_id
 k attrs("id")
 i $g(attrs("xtype"))'="dummy" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 i id'="" d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandTextArea(nodeOID,attr,parentOID)
 n ok
 s ok=$$textAreaInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
textAreaInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,id,mainAttrs,tagName,text,xOID
 ;
 m mainAttrs=attrs
 s id=$g(attrs("id"))
 s attrs("value")=".EWD.st2.textarea['"_id_"']"
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 s text=" d writeTextArea^%zewdSTch2Code("""_id_""",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="textareafield" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandList(nodeOID,attr,parentOID)
 n ok
 s ok=$$listInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
listInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,groupField,groupField,id
 n mainAttrs,sessionName,sortField,storeName,tagName,text,validationPage,xOID
 ;
 m mainAttrs=attrs
 s sessionName=$g(attrs("sessionname"))
 s storeName=$g(attrs("storename"))
 s groupField=$g(attrs("groupfield"))
 i groupField'="" d
 . s attrs("grouped")="true"
 . s mainAttrs("grouped")="true"
 s sortField=$g(attrs("sortfield"))
 s id=$g(attrs("id"))
 i id="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . s mainAttrs("id")=id
 k attrs("sessionname")
 k attrs("storename")
 k attrs("groupfield")
 k attrs("sortfield")
 i storeName="",sessionName'="" s storeName="Store"_id
 i $g(attrs("store"))="",storeName'="" s attrs("store")=".EWD.st2.store['"_storeName_"']"
 i sessionName'="" d
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeStore^%zewdSTch2Code("""_storeName_""","""_sessionName_""","""_groupField_""","""_sortField_""",sessid)"
 . ;writeStore(modelName,sessionName,groupField,sortField,sessid)
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="list" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 i sessionName'="" d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandNestedList(nodeOID,attr,parentOID)
 n ok
 s ok=$$nestedListInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
nestedListInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,groupField,groupField,id
 n mainAttrs,sessionName,sortField,storeName,tagName,text,validationPage,xOID
 ;
 m mainAttrs=attrs
 s sessionName=$g(attrs("sessionname"))
 s storeName=$g(attrs("storename"))
 s id=$g(attrs("id"))
 i id="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . s mainAttrs("id")=id
 k attrs("sessionname")
 k attrs("storename")
 i storeName="" s storeName="Store"_id
 i $g(attrs("store"))="" s attrs("store")=".EWD.st2.store['"_storeName_"']"
 i sessionName'="" d
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeTreeStore^%zewdSTch2Code("""_storeName_""","""_sessionName_""",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="nestedlist" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("st2:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 i sessionName'="" d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
addEwdActionField(nodeOID)
 d addEwdActionField^%zewdExt4(nodeOID)
 QUIT
 ;
addQuickTipManager(nodeOID,attr,parentOID)
 s attr("hoistToExt4Init")="Ext.tip.QuickTipManager.init();"
 QUIT
 ;
mapContainer(nodeOID)
 n xOID
 i $$getParentNode^%zewdDOM(nodeOID)=$g(outerOID) d
 . i $$getAttribute^%zewdDOM("fullscreen",nodeOID)="" d setAttribute^%zewdDOM("fullscreen","true",nodeOID)
 . i $$getAttribute^%zewdDOM("layout",nodeOID)="" d setAttribute^%zewdDOM("layout","fit",nodeOID)
 s xOID=$$renameTag^%zewdDOM("st2:extcontainer",nodeOID,1)
 QUIT
 ;
expandPanel(nodeOID,attr,parentOID)
 ;
 n addPage
 ;
 ;i $g(attr("isactive"))'="" d tabPanelActiveTab(nodeOID)
 ;
 s addPage=0
 i $g(attr("addpage"))'="" d
 . s attr("src")=attr("addpage")
 . k attr("addpage")
 . s addPage=1
 . i $g(attr("id"))="" s attr("id")=$$uniqueId(nodeOID)
 . s attr("addto")=attr("id")
 ;
 i $g(attr("src"))'="" d
 . n addTo,html,id,lattr,lOID,lsOID,pushTo,src,text
 . s src=attr("src")
 . s src=$p(src,".ewd",1)
 . s id="ST2Panel"_$$uniqueId^%zewdAPI(nodeOID,filename)_"Div"
 . i 'addPage d
 . . s html="<span id='"_id_"'></span>"
 . . s attr("html")=html
 . k attr("src")
 . i '$$hasChildTag^%zewdDOM(nodeOID,"st2:listeners",.lsOID) d
 . . s lsOID=$$addElementToDOM^%zewdDOM("st2:listeners",nodeOID)
 . s addTo=$g(attr("addto"))
 . k attr("addto") 
 . s pushTo=$g(attr("pushto"))
 . k attr("pushto")
 . s text="var nvp='';"
 . i pushTo'="" d
 . . s text=text_"nvp='st2_pushTo="_pushTo_"';"_$c(13,10)
 . i addTo'="" d
 . . s text=text_"nvp='st2_addTo="_addTo_"';"_$c(13,10)
 . . i addPage d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',nvp:nvp});"
 . . e  d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"',nvp:nvp});"
 . e  d
 . . i addPage d
 . . . s text="EWD.ajax.getPage({page:'"_src_"'});"
 . . e  d
 . . . s text="EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"'});"
 . s lattr("initialize")=text
 . s lOID=$$addElementToDOM^%zewdDOM("st2:listener",lsOID,,.lattr)
 ;
 QUIT
 ;
nextPageHandler(nodeOID)
 ;
 n actionCol,addTo,amp,argOID,argsOID,attr,codeOID,fnOID,handlerOID
 n maskMsg,maskObj,nextPage,nvp,pushTo,replace,setMask,text
 ;
 s actionCol=$$getAttribute^%zewdDOM("xtype",nodeOID)="actioncolumn"
 s nextPage=$$getAttribute^%zewdDOM("nextpage",nodeOID)
 s nvp=$$getAttribute^%zewdDOM("nvp",nodeOID)
 i $e(nvp,1)="&" s nvp=$e(nvp,2,$l(nvp))
 i $e(nvp,$l(nvp))="&" s nvp=$e(nvp,1,$l(nvp)-1)
 i nextPage="" QUIT
 d removeAttribute^%zewdDOM("nextpage",nodeOID)
 d removeAttribute^%zewdDOM("nvp",nodeOID)
 s addTo=$$getAttribute^%zewdDOM("addto",nodeOID)
 d removeAttribute^%zewdDOM("addto",nodeOID)
 s pushTo=$$getAttribute^%zewdDOM("pushto",nodeOID)
 d removeAttribute^%zewdDOM("pushto",nodeOID)
 s replace=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 d removeAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 s setMask=$$getAttribute^%zewdDOM("setmask",nodeOID)
 d removeAttribute^%zewdDOM("setmask",nodeOID)
 s maskMsg=$$getAttribute^%zewdDOM("maskmessage",nodeOID)
 d removeAttribute^%zewdDOM("maskmessage",nodeOID)
 s handlerOID=$$addElementToDOM^%zewdDOM("st2:handler",nodeOID)
 s fnOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",handlerOID)
 s argsOID=$$addElementToDOM^%zewdDOM("ewd:arguments",fnOID)
 s attr("name")="me"
 s attr("quoted")="false"
 s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 i actionCol d
 . s attr("name")="rowIndex"
 . s attr("quoted")="false"
 . s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 s text="var nvp='"_nvp_"';"
 s amp="" i nvp'="" s amp="&"
 i pushTo'="" d
 . s text=text_"nvp=nvp+'"_amp_"st2_pushTo="_pushTo_"';"
 . s amp="&"
 i setMask'="" d
 . s text=text_"nvp=nvp+'"_amp_"st2_masked="_setMask_"';"
 . s amp="&"
 i addTo'="" d
 . s text=text_"nvp=nvp+'"_amp_"st2_addTo="_addTo
 . i replace="true" d
 . . s text=text_"&st2_removeAll=true"
 . i actionCol s text=text_"&rowIndex=' + rowIndex + '&row=' + EWD.ext4.getGridRowNo(me,rowIndex) + '"
 . s text=text_"';"_$c(13,10)
 e  d
 . i actionCol d
 . . s text=text_"nvp=nvp+'"_amp_"rowIndex=' + rowIndex + '&row=' + EWD.ext4.getGridRowNo(me,rowIndex)"
 . ;e  d
 . ;. s text="var nvp='';"
 . s text=text_";"_$c(13,10)
 s text=text_"EWD.ajax.getPage({page:'"_nextPage_"',nvp:nvp});"
 i setMask'="" d
 . s maskObj="{xtype:'loadmask'"
 . i maskMsg'="" s maskObj=maskObj_",message:'"_maskMsg_"'"
 . s maskObj=maskObj_"}"
 . s text=text_"Ext.getCmp('"_setMask_"').setMasked("_maskObj_");"
 s codeOID=$$addElementToDOM^%zewdDOM("ewd:code",fnOID,,,text)
 ;
 QUIT
 ;
pass3(nodeOID,tagNameMap)
 ;
 n aOID,nodeArray,OIDArray,xOID
 ;
 i $$getElementsByTagName^%zewdDOM("st2:arguments",docOID,.nodeArray)
 s aOID=""
 f  s aOID=$o(nodeArray(aOID)) q:aOID=""  d
 . d nextPageHandler(aOID)
 ;
 ;d jsonAttrs(nodeOID)
 QUIT
 ;
jsonAttrs(nodeOID)
 ;
 n childNo,childOID,OIDArray 
 ;
 i $$getAttribute^%zewdDOM("json",nodeOID)'="" d jsonItems(nodeOID)
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . d jsonAttrs(childOID)
 QUIT
 ;
jsonItems(nodeOID,attrName)
 ;
 n cspOID,id,jsonDef,lOID,lsOID,text,xOID,xtype
 ;
 s xtype=$$getAttribute^%zewdDOM("xtype",nodeOID)
 s jsonDef=$$getAttribute^%zewdDOM(attrName,nodeOID)
 s jsonDef=$e(jsonDef,2,$l(jsonDef)-1)
 s id=$$getAttribute^%zewdDOM("id",nodeOID)
 i id="" d
 . s id=$$uniqueId(nodeOID)
 . d setAttribute^%zewdDOM("id",id,nodeOID)
 ;s lsOID=$$addElementToDOM^%zewdDOM("st2:listeners",nodeOID)
 ;s lOID=$$addElementToDOM^%zewdDOM("st2:listener",lsOID)
 ;d setAttribute^%zewdDOM("afterrender","EWD.ext4.items['"_id_"']()",lOID)
 d setAttribute^%zewdDOM(attrName,".EWD.st2.items['"_id_"']['"_attrName_"']",nodeOID)
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s cspOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 s xOID=$$appendChild^%zewdDOM(xOID,cspOID)
 s text=" d writeJSONContent^%zewdExt4Code("""_jsonDef_""","""_id_""","""_attrName_""","""_xtype_""",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 d removeIntermediateNode^%zewdDOM(xOID)
 QUIT
 ;
getRequestValue(fieldName,sessid)
 n value,zt
 i $g(fieldName)="" QUIT ""
 s value=$g(%KEY(fieldName))
 QUIT value
 ;
uniqueId(nodeOID)
 QUIT $p($$getTagName^%zewdDOM(nodeOID),":",2)_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
processNameList(nameList,formDeclarations)
 ;
 n actions,field,list,name,no,type,xtype
 ;
 s name="zewdSTForm"
 s no=$o(formDeclarations(""),-1)
 s field=""
 s list=""
 f  s field=$o(nameList(field)) q:field=""  d
 . s type=nameList(field)
 . i field="ewd_action" d  q
 . . s name=$p(type,"|",2)
 . . s type=$p(type,"|",1)
 . s list=list_field_"|"_type_"`"
 s no=no+1
 s formDeclarations(no)=name_"~~~"_list
 i technology="csp" d
 . k nameList("ewd_action")
 . s no=""
 . f  s no=$o(ewdActions(no)) q:no=""  d
 . . s name=ewdActions(no)
 . . m ^zewd("form",$$zcvt^%zewdAPI(app,"l"),"ewd_action",name)=nameList
 ;
 QUIT
 ;
