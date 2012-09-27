%zewdExt4 ; Extjs Tag Processors
 ;
 ; Product: Enterprise Web Developer (Build 939)
 ; Build Date: Thu, 27 Sep 2012 12:04:50
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
 ;d container^%zewdExt4X(nodeOID,.attrValue,docOID,technology)
 ;QUIT
 ;
 n appName,attr,bodyOID,configOID,cspScriptsOID,cssVersion,ewdActions,headOID,htmlOID
 n jsOID,jsSectionOID,jsVersion,mainAttrs,nameList,ocOID,outerOID,rootPath,src
 n tagNameMap,text,title,xOID
 ;
 ;<ext4:container rootPath="/ext-4" jsVersion="ext-all.js" title="Hello Ext" appName="HelloExt">
 ; .... etc
 ;</ext4:container>
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
 s configOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 d setAttribute^%zewdDOM("preprocess","preProcess^%zewdExt4Code",configOID)
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
 i title="" s title="ExtJS 4 Application"
 s rootPath=$g(mainAttrs("rootpath"))
 i rootPath="" s rootPath="/ext-4/"
 s rootPath=$$addSlashAtEnd^%zewdST(rootPath)
 s jsVersion=$g(mainAttrs("jsversion"))
 i jsVersion="" s jsVersion="ext-all.js"
 s cssVersion=$g(mainAttrs("cssversion"))
 i cssVersion="" s cssVersion="ext-all.css"
 s appName=$g(mainAttrs("appname"))
 i appName="" s appName=$g(app)
 i appName="" s appName="Ext4App"
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
 s attr("id")="Ext4Init"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s text=$$createExtFuncs^%zewdExt4Code() ; ** Ext4 functions in container page header!
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
 ; Create container for any user defined script code
 s attr("id")="UserDefinedCode"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ; Create container for any Ext4 Class Definitions
 s attr("id")="Ext4ClassDefinitions"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 ;s text="EWD.ext4 = {};"_$c(13,10)
 s text="Ext.application({"_$c(13,10)
 s text=text_" name:'"_appName_"',"_$c(13,10)
 s text=text_" launch: function() {"_$c(13,10)
 i $g(mainAttrs("enableloader"))="true" s text=text_"   Ext.Loader.setConfig({enabled:true});"_$c(13,10)
 s text=text_"   EWD.ext4.content()"_$c(13,10)
 s text=text_" }"_$c(13,10)
 s text=text_"});"_$c(13,10)
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 s text="EWD.ext4.content = function() {"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 s attr("id")="ext4Content"
 s jsSectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s text="}"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 d childTags^%zewdExt4a(nodeOID,jsSectionOID)
 i technology="csp" d
 . n cspOID
 . s text=" w ""<""_""/script>"""_$c(13,10)
 . s cspOID=$$addCSPServerScript^%zewdAPI(cspScriptsOID,text)
 s xOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 d removeAttribute^%zewdDOM("id",xOID)
 ; move any endOfHead code
 ;
 s ocOID=$$getTagOID^%zewdDOM("ext4:optioncode",docName)
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
getMappings(tagNameMap) ;
 ;
 n arr,className,itemExpander,line,lineNo,ok,tagName
 ;
 k tagNameMap
 s tagName=""
 f  s tagName=$o(^zewd("mappingObject","ext4",tagName)) q:tagName=""  d
 . s line=^zewd("mappingObject","ext4",tagName)
 . s ok=$$parseJSON^%zewdJSON(line,.arr,1)
 . m tagNameMap(arr("tagName"))=arr
 f lineNo=1:1 s line=$t(mappingObjects+lineNo^%zewdExt4Map) q:line["***END***"  d
 . s line=$p(line,";;",2,200)
 . s ok=$$parseJSON^%zewdJSON(line,.arr,1)
 . k tagNameMap(arr("tagName")) ; official versions take precedence!
 . m tagNameMap(arr("tagName"))=arr
 QUIT
 ;
fragment(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n botJSOID,configOID,ewdActions,jsOID,nameList,outerOID,tagNameMap,text,topJSOID,xOID
 ;
 ;<ext4:fragment>
 ; .... etc
 ;</ext4:fragment>
 ;
 s outerOID=nodeOID
 s configOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 d setAttribute^%zewdDOM("preprocess","preProcess^%zewdExt4Code",configOID)
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
 s topJSOID=$$getTagByNameAndAttr^%zewdDOM("ext4:js","at","top",1,docName)
 i topJSOID'="" d
 . s jsOID=$$getElementById^%zewdDOM("Ext4PreCode",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID)
 . s topJSOID=$$removeChild^%zewdDOM(topJSOID)
 . s topJSOID=$$appendChild^%zewdDOM(topJSOID,jsOID)
 . d removeIntermediateNode^%zewdDOM(topJSOID)
 s botJSOID=$$getTagByNameAndAttr^%zewdDOM("ext4:js","at","bottom",1,docName)
 i botJSOID'="" d
 . s jsOID=$$getElementById^%zewdDOM("Ext4PostCode",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID)
 . s botJSOID=$$removeChild^%zewdDOM(botJSOID)
 . s botJSOID=$$appendChild^%zewdDOM(botJSOID,jsOID)
 . d removeIntermediateNode^%zewdDOM(botJSOID)
 s jsOID=$$getElementById^%zewdDOM("Ext4Code",docOID)
 d childTags^%zewdExt4a(nodeOID,jsOID)
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
 s attr("id")="Ext4ClassDefinitions"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="cspScripts"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="Ext4PreCode"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="Ext4Code"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s attr("id")="Ext4PostCode"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 QUIT jsOID
 ;
topLevelTag(tagName,nodeOID,jsSectionOID,tagNameMap)
 ;
 ; <ext4:viewPort id="theViewPort" layout="fit" object="viewPort" var="true">
 ;   </ext4:panel title="Hello Ext" html="Hello! Welcome to Ext 4">
 ;     <ext4:listeners>
 ;       <ext4:listener render=".function(){Ext.MessageBox.alert('rendered!');}" />
 ;     </ext4:listeners>
 ;   </ext4:panel>
 ; </etx4:viewPort>
 ;
 ; becomes
 ;
 ;<ewd:jsMethod name="Ext.create" return="viewport" var="true">
 ; <ewd:jsParameters>
 ;  <ewd:jsLiteral value="Ext.container.viewport" />
 ;  <ewd:jsObject>
 ;    <ewd:jsNVP name="id" value="theViewport" type="literal" />
 ;    <ewd:jsNVP name="layout" value="fit" type="literal" />
  ;  </ewd:jsObject>
 ; </ewd:jsParameters>
 ;</ewd:jsMethod>
 ;
 ;<ewd:jsMethod name="Ext.create" return="panel1" var="true">
 ; <ewd:jsParameters>
 ;  <ewd:jsLiteral value="Ext.panel.Panel" />
 ;  <ewd:jsObject>
 ;    <ewd:jsNVP name="title" value="Hello Ext" type="literal" />
 ;    <ewd:jsNVP name="html" value="Hello World!" type="literal" />
 ;  </ewd:jsObject>
 ; </ewd:jsParameters>
 ;</ewd:jsMethod>
 ;
 ; Add each class to its parent Javascript section, unless it's the topmost one
 ; in the container page
 ;
 ; Recurse down through the children, unless they are listeners which are handled
 ; separately as an object with name/value pairs
 ;
 n attr,className,childTagName,jsChildSectionOID,mainAttrs,mOID,name
 n objOID,paramsOID,parentId,xOID
 ;
 s className=$g(tagNameMap(tagName,"className"))
 i className="" QUIT
 do getAttributes(nodeOID,.mainAttrs)
 s attr("name")="Ext.create"
 i $g(mainAttrs("object"))'="" d
 . s attr("return")=mainAttrs("object")
 . i $g(mainAttrs("var"))="true" s attr("var")="true"
 k mainAttrs("var")
 k mainAttrs("object")
 s parentId=$$getAttribute^%zewdDOM("id",jsSectionOID)
 i parentId="ext4Content" d
 . i tagName'="ext4:viewport" d
 . . i $g(mainAttrs("renderTo"))="" s mainAttrs("renderTo")=".Ext.getBody()"
 s mOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",jsSectionOID,,.attr)
 s paramsOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",mOID)
 s attr("value")=className
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",paramsOID,,.attr)
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",paramsOID)
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . s attr("name")=name
 . s attr("value")=mainAttrs(name)
 . s attr("type")="literal"
 . i attr("value")="true"!(attr("value")="false") s attr("type")="boolean"
 . i attr("value")="this" s attr("type")="reference"
 . i $e(attr("value"),1,9)="function(" s attr("type")="reference"
 . i $$numeric^%zewdJSON(attr("value")) s attr("type")="numeric"
 . i $e(attr("value"),1)="." d
 . . s attr("type")="reference"
 . . s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . i $e(attr("value"),1)="|" s attr("value")=$e(attr("value"),2,$l(attr("value")))
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 ;
 ; find and add any listeners etc
 ;
 d getChildNodes(nodeOID,objOID)
 ;
 ; add the current class to its parent class
 ;
 ;<ewd:jsMethod name="Ext.getCmp('viewportindex111').add">
 ; <ewd:jsParameters>
 ;  <ewd:jsVariable name="Ext.getCmp('panelindex222')" />
 ; </ewd:jsParameters>
 ;</ewd:jsMethod>
 ;
 s attr("id")=mainAttrs("id")
 s jsChildSectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsSectionOID,,.attr)
 ;
 ; recurse through any child tags
 ;
 d childTags^%zewdExt4a(nodeOID,jsChildSectionOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
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
 s tagName=$p(tagName,"ext4:",2)
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
 ; Generic Config Option: <ext4:configOption optionName="features" optionType="arrayOfOptions">
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
 s optionName(1)=$p(tagName,"ext4:",2)
 d convertAttrsToCamelCase^%zewdST2(.optionName)
 i type="arrayofoptions" d arrayOfOptions(optionName(1),nodeOID,parentOID) QUIT
 i type="object" d object(optionName(1),nodeOID,parentOID) QUIT
 QUIT
 ;
array(name,nodeOID,parentOID)
 ;
 ;     <ext4:axisFields>
 ;       <ext4:axisField name="data1" />
 ;       <ext4:axisField name="data2" /> 
 ;     </ext4:items>
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
 ;     <ext4:layout type="vbox" align="left">
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
 ;     <ext4:listeners>
 ;       <ext4:listener render="function(){Ext.MessageBox.alert('rendered!');}" />
 ;     </ext4:listeners>
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
 . i tagName="ext4:listener" d
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
arrayOfOptions(type,nodeOID,objOID)
 ;
 ;     <ext4:items>
 ;       <ext4:item region="north" html="hello" autoheight="true" border="false" />
 ;     </ext4:items>
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
desktop(nodeOID)
 d desktop^%zewdExt4DT(nodeOID)
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
 i $$getAttribute^%zewdDOM("hoistToExt4Init",nodeOID)'="" d
 . n jOID,text,xOID
 . s jOID=$$getElementById^%zewdDOM("Ext4Init",docOID)
 . s text=$$getAttribute^%zewdDOM("hoistToExt4Init",nodeOID)
 . d removeAttribute^%zewdDOM("hoistToExt4Init",nodeOID)
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
 i tagName="ext4:item",$g(mainAttrs("id"))="",$g(mainAttrs("xtype"))="" QUIT
 i $g(mainAttrs("id"))="" s mainAttrs("id")=$$uniqueId(nodeOID)
 i $g(tagNameMap(tagName,"hasId"))="false" k mainAttrs("id")
 QUIT
 ;
createNVPs(nodeOID,parentOID)
 ;
 n attr,mainAttrs,name,value,xOID
 ;
 d getAttributes(nodeOID,.mainAttrs)
 i $$getTagName^%zewdDOM(nodeOID)="ext4:sorter" d
 . k mainAttrs("id")
 i $$getTagName^%zewdDOM(nodeOID)="ext4:field" d
 . k mainAttrs("id")
 . i $g(mainAttrs("type"))="" s mainAttrs("type")="auto"
 i $$getTagName^%zewdDOM(nodeOID)="ext4:childel" d
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
 . . i $$getTagName^%zewdDOM(nodeOID)="ext4:fragment" s lt="&lt;"
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
replaceModalWindow(nodeOID)
 ;
 n xOID
 s xOID=$$renameTag^%zewdDOM("ext4:window",nodeOID,1)
 d setAttribute^%zewdDOM("modal","true",xOID)
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
 . i $$getTagName^%zewdDOM(childOID)="ext4:tips" d
 . . s xOID=$$renameTag^%zewdDOM("ext4:charttips",childOID,1)
 QUIT
 ;
addEwdActionField(nodeOID)
 ;
 n attr,items,no,prefix,xOID
 ;
 s prefix=$p($$getTagName^%zewdDOM(nodeOID),":",1)
 s items=$$getAttribute^%zewdDOM("items",nodeOID)
 i $e(items,1)="[",$e(items,$l(items))="]" QUIT
 s attr("name")="ewd_action"
 s attr("id")="ewd_action"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s attr("value")="zewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;s nameList("ewd_action")="hidden|"_attr("value")
 s no=$increment(ewdActions)
 s ewdActions(no)=attr("value")
 s xOID=$$addElementToDOM^%zewdDOM(prefix_":hiddenfield",nodeOID,,.attr)
 QUIT
 ;
swapFormFields(nodeOID)
 ;
 n parentOID,type,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="ext4:axisfields" d  QUIT
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("ext4:axisfield",nodeOID,1)
 ;
 i $$getTagName^%zewdDOM(parentOID)="ext4:axis" d  QUIT
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("ext4:axisfield",nodeOID,1)
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"ext4:axisfields",docOID)
 ;
 s type=$$getAttribute^%zewdDOM("type",nodeOID)
 i type["field" d
 . s xOID=$$renameTag^%zewdDOM("ext4:"_type,nodeOID,1)
 . d removeAttribute^%zewdDOM("type",xOID)
 . d setNameList(xOID)
 ;
 QUIT
 ;
expandSubmitButton(nodeOID)
 ;
 n addTo,attr,formId,handler,nextPage,pOID,replace,stop,text,xOID
 ;
 s pOID=nodeOID
 s stop=0
 f  d  q:stop
 . s pOID=$$getParentNode^%zewdDOM(pOID)
 . i $$getTagName^%zewdDOM(pOID)="ext4:formpanel" s stop=1
 i pOID="" QUIT  ; erroneous situation!
 s formId=$$getAttribute^%zewdDOM("id",pOID)
 i formId="" d
 . s formId=$$uniqueId(pOID)
 . d setAttribute^%zewdDOM("id",formId,pOID)
 s nextPage=$$getAttribute^%zewdDOM("nextpage",nodeOID)
 s addTo=$$getAttribute^%zewdDOM("addto",nodeOID)
 s replace=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)="true"
 f attr="nextpage","addto","replacepreviouspage" d removeAttribute^%zewdDOM(attr,nodeOID)
 s handler=".function() {EWD.ext4.submit('"_formId_"','"_nextPage_"','"_addTo_"',"_replace_")}"
 d setAttribute^%zewdDOM("handler",handler,nodeOID)
 ;
 QUIT
 ;
convertMenu(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="ext4:menuitem" d
 . s xOID=$$renameTag^%zewdDOM("ext4:buttonmenu",nodeOID,1)
 ;
 QUIT
 ;
convertMenuItem(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="ext4:menuitem" d
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"ext4:buttonmenu",docOID)
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
 i $$getTagName^%zewdDOM(parentOID)'="ext4:axisfields" d
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"ext4:axisfields",docOID)
 QUIT
 ;
addYFields(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)'="ext4:yfields" d
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"ext4:yfields",docOID)
 QUIT
 ;
addXFields(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)'="ext4:xfields" d
 . s xOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,"ext4:xfields",docOID)
 QUIT
 ;
editableColumn(nodeOID)
 ;
 n childNo,childOID,editAs
 ;
 s editAs=$$getAttribute^%zewdDOM("editas",nodeOID)
 d removeAttribute^%zewdDOM("editas",nodeOID)
 i editAs'="" d addEditor(nodeOID,editAs)
 ;
 i $$getAttribute^%zewdDOM("groupfield",nodeOID)="true" d
 . n dataIndex,gpOID
 . ; move to the gridPanel tag as a groupField tag
 . s gpOID=$$getParentNode^%zewdDOM(nodeOID)
 . s dataIndex=$$getAttribute^%zewdDOM("dataindex",nodeOID)
 . d setAttribute^%zewdDOM("groupfield",dataIndex,gpOID)
 . if $$getAttribute^%zewdDOM("grouping",gpOID)="" d setAttribute^%zewdDOM("grouping","true",gpOID)
 d removeAttribute^%zewdDOM("groupfield",nodeOID)
 ;
 QUIT
 ;
addEditor(nodeOID,type)
 ;
 n attr,OIDArray,stop,xOID
 ;
 s stop=0
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . s childOID=OIDArray(childNo)
 . i $$getTagName^%zewdDOM(childOID)="ext4:editor" s stop=1
 i childNo="" d
 . s attr("xtype")=type
 . i type="combobox" d
 . . n colName,fn,id
 . . s attr("lazyRender")="true"
 . . s attr("listClass")="x-combo-list-small"
 . . s attr("selectOnTab")="true"
 . . s attr("triggerAction")="all"
 . . s attr("typeAhead")="true"
 . . s colName=$$getAttribute^%zewdDOM("dataindex",nodeOID)
 . . s id=$$getGridPanelId(nodeOID)
 . . s attr("store")=".EWD.ext4.grid['"_id_"'].combo.store['"_colName_"']"
 . . s fn=""
 . . s fn=fn_".function (value, metaData, record, rowIndex, colIndex) {"
 . . s fn=fn_"  var index = EWD.ext4.grid['"_id_"'].combo.index['"_colName_"']; EWD.record = record;"
 . . s fn=fn_"  if (typeof(index[value]) !== 'undefined') {"
 . . s fn=fn_"    return index[value];"
 . . s fn=fn_"  }"
 . . s fn=fn_"  else {"
 . . s fn=fn_"    record.data['"_colName_"'] = '';"
 . . s fn=fn_"    return '';"
 . . s fn=fn_"  }"
 . . s fn=fn_"}"
 . . d setAttribute^%zewdDOM("renderer",fn,nodeOID)
 . . d getOptionTags(nodeOID,id)
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:editor",nodeOID,,.attr)
 . d addCellEditor(nodeOID)
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
 s ocOID=$$getTagOID^%zewdDOM("ext4:optioncode",docName)
 i ocOID="" d
 . n cOID
 . s cOID=$$getTagOID^%zewdDOM("ext4:container",docName)
 . s ocOID=$$addElementToDOM^%zewdDOM("ext4:optioncode",cOID)
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
 . i $$getTagName^%zewdDOM(childOID)="ext4:options" s stop=1
 QUIT childOID
 ;
addCellEditor(nodeOID)
 ;
 n ceOID,parentOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="ext4:gridpanel" d
 . i $$getAttribute^%zewdDOM("clickstoedit",parentOID)="" d
 . . d setAttribute^%zewdDOM("clickstoedit",2,parentOID)
 ;
 QUIT
 ;
getGridPanelId(nodeOID)
 ;
 n gpOID,id
 ;
 s id=""
 s gpOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(gpOID)="ext4:gridpanel" d
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
 i $$getTagName^%zewdDOM(gpOID)="ext4:gridpanel" d
 . n childNo,childOID,OIDArray,stop
 . d getChildrenInOrder^%zewdDOM(gpOID,.OIDArray)
 . s childNo="",stop=0
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . . s childOID=OIDArray(childNo)
 . . i $$getTagName^%zewdDOM(childOID)="ext4:gridcolumn" d
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
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="ext4:axis" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("ext4:axislabel",nodeOID,1)
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="ext4:series" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("ext4:serieslabel",nodeOID,1)
 QUIT
 ;
switchFields(nodeOID)
 i $$getTagName^%zewdDOM($$getParentNode^%zewdDOM(nodeOID))="ext4:axis" d
 . n xOID
 . s xOID=$$renameTag^%zewdDOM("ext4:axisfields",nodeOID,1)
 QUIT
 ;
setNameList(nodeOID)
 ;
 n name,id,prefix,tagName,type
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s prefix=$p(tagName,":",1)
 s name=$$getAttribute^%zewdDOM("name",nodeOID)
 i tagName'=("ext4:radiofield"),tagName'=("ext4:checkboxfield") d
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
 i tagName="st2:checkboxfield",$$getAttribute^%zewdDOM("cbgroup",nodeOID)="true" s type="checkbox"
 i type="" s type="text"
 i name="ewd_action" s type=type_"|"_$$getAttribute^%zewdDOM("value",nodeOID)
 i tagName'=(prefix_":displayfield") d
 . s nameList(name)=type ;leaks out to container or fragment!
 ;
 i tagName=(prefix_":timefield") d
 . n format
 . s format=$$getAttribute^%zewdDOM("format",nodeOID)
 . s format=$$zcvt^%zewdAPI(format,"l")
 . i format="24hour"!((format["24")&(format["h")) d
 . . d setAttribute^%zewdDOM("format","H:i",nodeOID)
 i tagName=(prefix_":radiofield") d
 . n phpVar,value,valueField
 . s valueField="inputvalue"
 . i prefix="st2" s valueField="value"
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_name,"j")
 . s value=$$getAttribute^%zewdDOM(valueField,nodeOID)
 . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 i tagName="st2:datepickerfield" d
 . n day,month,pOID,year,value,yearFrom,yearTo
 . i $$hasChildTag^%zewdDOM(nodeOID,"st2:picker",.pOID) d
 . . s pOID=$$renameTag^%zewdDOM("st2:datefieldpicker",pOID,1)
 . s day=$$addPhpVar^%zewdCustomTags("#"_name_".day","j")
 . s month=$$addPhpVar^%zewdCustomTags("#"_name_".month","j")
 . s year=$$addPhpVar^%zewdCustomTags("#"_name_".year","j")
 . s value=".{day:'"_day_"',month:'"_month_"',year:'"_year_"'}"
 . d setAttribute^%zewdDOM("value",value,nodeOID)
 . s nameList(name_"_day")="text"
 . s nameList(name_"_month")="text"
 . s nameList(name_"_year")="text"
 . s yearFrom=$$getAttribute^%zewdDOM("yearfrom",nodeOID)
 . s yearTo=$$getAttribute^%zewdDOM("yearto",nodeOID)
 . i yearFrom'=""!(yearTo'="") d
 . . i '$$hasChildTag^%zewdDOM(nodeOID,"st2:datefieldpicker",.pOID) d
 . . . s pOID=$$addElementToDOM^%zewdDOM("st2:datefieldpicker",nodeOID)
 . . i yearFrom'="" d
 . . . d setAttribute^%zewdDOM("yearfrom",yearFrom,pOID)
 . . . d removeAttribute^%zewdDOM("yearfrom",nodeOID)
 . . i yearTo'="" d
 . . . d setAttribute^%zewdDOM("yearto",yearTo,pOID)
 . . . d removeAttribute^%zewdDOM("yearto",nodeOID)
 i tagName="st2:checkboxfield" d
 . n group,phpVar,value
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_name,"j")
 . s value=$$getAttribute^%zewdDOM("value",nodeOID)
 . s group=$$getAttribute^%zewdDOM("cbgroup",nodeOID)
 . d removeAttribute^%zewdDOM("cbgroup",nodeOID)
 . i group="true" d
 . . s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_selected."_name_"."_value,"j")
 . . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 . e  d
 . . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 i tagName="ext4:checkboxfield" d
 . n phpVar,value
 . s value=$$getAttribute^%zewdDOM("inputvalue",nodeOID)
 . s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_selected."_name_"."_value,"j")
 . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 d
 . n value
 . s value=$$getAttribute^%zewdDOM("value",nodeOID)
 . i tagName="st2:selectfield" s value="*"
 . i value="*" d setAttribute^%zewdDOM("value",("#"_name),nodeOID)
 ;
 QUIT
 ;
treePanelListener(nodeOID)
 ;
 n argOID,argsOID,attr,codeOID,fnOID,icOID,lsOID,stop,text
 ;
 s stop=0
 i '$$hasChildTag^%zewdDOM(nodeOID,"ext4:listeners",.lsOID) d
 . s lsOID=$$addElementToDOM^%zewdDOM("ext4:listeners",nodeOID)
 e  d
 . n lOID
 . i $$hasChildTag^%zewdDOM(lsOID,"ext4:listener",.lOID) d
 . . i $$getAttribute^%zewdDOM("itemclick",lOID)'="" s stop=1
 i stop QUIT  ; already has a custom itemClick handler defined
 s icOID=$$addElementToDOM^%zewdDOM("ext4:itemClick",lsOID)
 s fnOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",icOID)
 s argsOID=$$addElementToDOM^%zewdDOM("ewd:arguments",fnOID)
 s attr("name")="view"
 s attr("quoted")="false"
 s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 s attr("name")="record"
 s attr("quoted")="false"
 s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 s text=""
 s text=text_"if (typeof record.raw.page !== 'undefined') {"_$c(13,10)
 s text=text_" EWD.record=record;"_$c(13,10)
 s text=text_" var nvp = ''"_$c(13,10)
 s text=text_" if (typeof record.raw.nvp !== 'undefined') nvp = record.raw.nvp;"_$c(13,10)
 s text=text_" if (typeof record.raw.addTo !== 'undefined') {"_$c(13,10)
 s text=text_"  if (nvp !== '') nvp = nvp + '&';"_$c(13,10)
 s text=text_"  nvp = nvp + 'ext4_addTo=' + record.raw.addTo;"_$c(13,10)
 s text=text_" }"_$c(13,10)
 s text=text_" if (typeof record.raw.replace !== 'undefined') {"_$c(13,10)
 s text=text_"  if (nvp !== '') nvp = nvp + '&';"_$c(13,10)
 s text=text_"  nvp = nvp + 'ext4_removeAll=true';"_$c(13,10)
 s text=text_" }"_$c(13,10)
 s text=text_" EWD.ajax.getPage({page:record.raw.page,nvp:nvp});"_$c(13,10)
 s text=text_"}"_$c(13,10)
 s codeOID=$$addElementToDOM^%zewdDOM("ewd:code",fnOID,,,text)
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
 . i $$getTagName^%zewdDOM(childOID)="ext4:panel" d
 . . i $$getAttribute^%zewdDOM("isactive",childOID)="true" d
 . . . d setAttribute^%zewdDOM("activeTab",childNo-1,nodeOID)
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
 ;<ext4:container rootPath="/ext-4" jsVersion="ext-all-debug.js" title="Extjs 4 Test" appName="HelloExt">
 ;  <ext4:viewPort object="theViewPort" layout="border" var="true">
 ;    <ext4:panel region="center" margins="5 5 5 0" bodyStyle="background:#f1f1f1" html="Empty center panelsdfs" />
 ;    <ext4:accordionPanel region="west" margins="5 0 5 5" split="true" width=210>
 ;      <ext4:panel title="Accordion Item 1" html="Currently empty" />
 ;      <ext4:panel title="Accordion Item 2" html="Currently empty" />
 ;      <ext4:panel title="Accordion Item 3" html="Currently empty" />
 ;    </ext4:accordionPanel>
 ;  </etx4:viewPort>
 ;</ext4:container>
 ;
 ; into:
 ;
 ;<ext4:container rootPath="/ext-4" jsVersion="ext-all-debug.js" title="Extjs 4 Test" appName="HelloExt">
 ;  <ext4:viewPort object="theViewPort" layout="border" var="true">
 ;    <ext4:items>
 ;      <ext4:item xtype="panel" region="center" margins="5 5 5 0" bodyStyle="background:#f1f1f1" html="Empty center panel" />
 ;      <ext4:item xtype="panel" region="west" margins="5 0 5 5" split="true" width=210 layout="accordion">
 ;        <ext4:items>
 ;          <ext4:item xtype="panel" title="Accordion Item 1" html="Currently empty" />
 ;          <ext4:item xtype="panel" title="Accordion Item 2" html="Currently empty" />
 ;          <ext4:item xtype="panel" title="Accordion Item 3" html="Currently empty" />
 ;        </ext4:items>
 ;      </ext4:item>
 ;    </ext:items>
 ;  </etx4:viewPort>
 ;</ext4:container>
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
 s instanceOID=$$addElementToDOM^%zewdDOM("ext4:createinstance",nodeOID,,.attr)
 ; automatically render to container body unless stated otherwise
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="ext4:container" d
 . n renderTo
 . s renderTo=$g(mainAttrs("renderto"))
 . i renderTo=""!($$zcvt^%zewdAPI(renderTo,"l")="autorender") d
 . . s mainAttrs("renderto")=".Ext.getBody()"
 m attr=mainAttrs
 ;d
 i $g(tagNameMap(tagName,"instanceMethod"))'="" d
 . n x
 . s x="s argumentsOID=$$"_tagNameMap(tagName,"instanceMethod")_"(.attr,nodeOID,instanceOID)"
 . x x
 e  d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attr)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT argumentsOID
 ;
expandComboBox(nodeOID,attr,parentOID)
 ;
 n cspOID,fieldName,text,xOID
 ;
 i $g(attr("queryMode"))="" s attr("queryMode")="local"
 s fieldName=$g(attr("name")) i fieldName="" s fieldName="unnamedCombobox"
 i $g(attr("multiselect"))="true" d
 . s attr("value")=".EWD.ext4.form['"_fieldName_"']"
 i $g(attr("store"))="" d
 . s attr("displayField")="name"
 . s attr("valueField")="value"
 . s attr("store")="."_fieldName
 . s xOID=$$createElement^%zewdDOM("cspTemp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeComboBoxStore^%zewdExt4Code("""_fieldName_""",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 . d removeIntermediateNode^%zewdDOM(xOID)
 QUIT
 ;
expandButtonMenu(nodeOID,attr,parentOID)
 ;
 n addTo,attrName,cspOID,id,menuId,page,replacePreviousPage,sessionName,tagName,text,xOID
 ;
 s sessionName=$g(attr("sessionname"))
 q:sessionName=""
 k attr("sessionname")
 s page=$g(attr("page"))
 k attr("page")
 i page="" d
 . s page=$g(attr("nextpage"))
 . k attr("nextpage")
 s addTo=$g(attr("addto"))
 k attr("addto")
 s replacePreviousPage=$g(attr("replacepreviouspage"))="true"
 k attr("replacepreviouspage")
 s id=$g(attr("id"))
 i id="" s id=$$uniqueId(nodeOID)
 s menuId=id_"Menu"
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 i tagName="ext4:buttonmenu" d
 . s attrName="menu"
 e  d
 . s attrName="items"
 s attr(attrName)="."_menuId
 s xOID=$$createElement^%zewdDOM("cspTemp",docOID)
 s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 s text=" d writeButtonMenu^%zewdExt4Code("""_sessionName_""","""_menuId_""","""_page_""","""_addTo_""","_replacePreviousPage_",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT
 ;
buttonInstance(attrs,nodeOID,instanceOID)
 ;
 n addTo,argumentsOID,id,nextPage
 ;
 s nextpage=$g(attrs("nextpage"))
 s addTo=$g(attrs("addto"))
 k attrs("nextpage")
 k attrs("addto")
 ;
 s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 i nextPage'="" d
 . n attr,listenersOID,xOID
 . s listenersOID=$$addElementToDOM^%zewdDOM("ext4:listeners",argumentsOID)
 . s attr("render")="EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"'})"
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:listener",listenersOID,,.attr)
 ;
 QUIT argumentsOID
 ;
panelInstance(attrs,nodeOID,instanceOID)
 ;
 n addPage,addTo,argumentsOID,id,src
 ;
 s addTo=""
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
 s id="Ext4Panel"_$$uniqueId^%zewdAPI(nodeOID,filename)_"Div"
 i src'="",'addPage d
 . s attrs("html")="<span id='"_id_"'></span>"
 . i $g(attrs("addto")) d
 . . s addTo=attrs("addto")
 . . k attrs("addto")
 ;
 s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 i src'="" d
 . n attr,listenersOID,text,xOID
 . s listenersOID=$$addElementToDOM^%zewdDOM("ext4:listeners",argumentsOID)
 . i addTo'="" d
 . . s text="var nvp='ext4_addTo="_addTo_"';"_$c(13,10)
 . . i addPage d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',nvp:nvp});"
 . . e  d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"',nvp:nvp});"
 . e  d
 . . s text="EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"'});"
 . s attr("render")=text
 . ;s attr("render")="EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"'})"
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:listener",listenersOID,,.attr)
 ;
 QUIT argumentsOID
 ;
expandTreePanel(nodeOID,attr,parentOID)
 n ok
 s ok=$$treePanelInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
treePanelInstance(attrs,nodeOID,instanceOID)
 ;
 n addTo,argumentsOID,cspOID,expandedTree,id,mainAttrs,page,replace
 n sessionName,storeId,tagName,text,xOID
 ;
 ;m mainAttrs=attrs
 i $g(attrs("rootvisible"))="" s attrs("rootvisible")="false"
 s expandedTree=$g(attrs("expandedtree"))
 i expandedTree="" s expandedTree="true"
 s expandedTree=expandedTree="true"
 s addTo=$g(attrs("addto"))
 k attrs("addto")
 s replace=$g(attr("replacepreviouspage"))="true"
 k attrs("replacepreviouspage")
 s page=$g(attrs("nextpage"))
 i page="" s page=$g(attrs("page"))
 k attrs("expandedtree"),attrs("page"),attrs("nextpage")
 s sessionName=$g(attrs("sessionname"))
 s storeId=$g(attrs("storeid"))
 s id=$g(attrs("id"))
 i storeId="",id="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . ;s mainAttrs("id")=id
 i id="",storeId'="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . ;s mainAttrs("id")=id
 k attrs("sessionname")
 k attrs("storeid")
 i storeId="" s storeId=id_"Store"
 s attrs("store")="."_storeId
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 s text=" d writeTreeStore^%zewdExt4Code("""_sessionName_""","""_storeId_""","""_page_""","""_addTo_""","_replace_","_expandedTree_",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="treepanel" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandGauge(nodeOID)
 ;
 n attr,axisOID,color1,color2,colorSet,donut,seriesOID,store,tagName,value
 ;
 i $$getAttribute^%zewdDOM("type",nodeOID)'="gauge" QUIT
 d removeAttribute^%zewdDOM("type",nodeOID)
 s value=$$getAttribute^%zewdDOM("value",nodeOID)
 d removeAttribute^%zewdDOM("value",nodeOID)
 i value'=""  d
 . n argsOID,ciOID,daOID,fieldsOID,xOID
 . s attr("classname")="Ext.data.JsonStore"
 . s attr("var")="true"
 . s attr("object")=$$uniqueId(nodeOID)_"JsonStore"
 . s store=attr("object")
 . s ciOID=$$addElementToDOM^%zewdDOM("ext4:createinstance",outerOID,,.attr,,1)
 . s attr("model")=$$uniqueId(nodeOID)_"Model"
 . s argsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",ciOID,,.attr)
 . s fieldsOID=$$addElementToDOM^%zewdDOM("ext4:fields",argsOID)
 . s attr("name")="value"
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:fielditem",fieldsOID,,.attr)
 . s daOID=$$addElementToDOM^%zewdDOM("ext4:dataarray",argsOID)
 . s attr("value")=value
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:dataitem",daOID,,.attr)
 . d setAttribute^%zewdDOM("store","."_store,nodeOID)
 ;
 i '$$hasChildTag^%zewdDOM(nodeOID,"ext4:axis",.axisOID) d
 . s axisOID=$$addElementToDOM^%zewdDOM("ext4:axis",nodeOID)
 d setAttribute^%zewdDOM("type","gauge",axisOID)
 d setAttribute^%zewdDOM("position","gauge",axisOID)
 ;
 i '$$hasChildTag^%zewdDOM(nodeOID,"ext4:series",.seriesOID) d
 . s seriesOID=$$addElementToDOM^%zewdDOM("ext4:series",nodeOID)
 d setAttribute^%zewdDOM("type","gauge",seriesOID)
 d setAttribute^%zewdDOM("field","value",seriesOID)
 s donut=$$getAttribute^%zewdDOM("donut",seriesOID)
 i donut="" d setAttribute^%zewdDOM("donut","false",seriesOID)
 s color1=$$getAttribute^%zewdDOM("color1",seriesOID)
 s color2=$$getAttribute^%zewdDOM("color2",seriesOID)
 s colorSet=$$getAttribute^%zewdDOM("colorset",seriesOID)
 i colorSet="" d
 . d removeAttribute^%zewdDOM("color1",seriesOID)
 . d removeAttribute^%zewdDOM("color2",seriesOID)
 . i color1="" s color1="#f49d10"
 . i color2="" s color2="#ddd"
 . i $e(color1,1,2)="##" s color1=$e(color1,2,$l(color1))
 . i $e(color2,1,2)="##" s color2=$e(color2,2,$l(color2))
 . s colorSet=".['"_color1_"','"_color2_"']"
 . d setAttribute^%zewdDOM("colorset",colorSet,seriesOID)
 ;
 QUIT
 ;
expandGroupField(nodeOID,attr,parentOID)
 n ok
 s ok=$$groupFieldInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
groupFieldInstance(attrs,nodeOID,instanceOID)
 n argumentsOID,cspOID,fieldName,id,itemsId,sessionName,tagName,text,xOID,xtype
 ;
 s sessionName=$g(attrs("sessionname"))
 i sessionName'="" d
 . s tagName=$$getTagName^%zewdDOM(nodeOID)
 . s id=$g(attrs("id"))
 . i id="" d
 . . s id=$$uniqueId(nodeOID)
 . . s attrs("id")=id
 . s itemsId=id_"Items"
 . s attrs("items")="."_itemsId
 . k attrs("sessionname")
 . s fieldName=$g(attrs("name"))
 . i fieldName="" s fieldName="undefinedFieldName"
 . k attrs("name")
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s xtype=""
 . i tagName="ext4:radiogroup" s xtype="radiofield"
 . i tagName="ext4:checkboxgroup" s xtype="checkboxfield"
 . s text=" d writeGroupFields^%zewdExt4Code("""_sessionName_""","""_id_""","""_fieldName_""","""_xtype_""",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 s xtype=$g(attrs("xtype"))
 i xtype'="radiogroup",xtype'="checkboxgroup" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 i sessionName'="" d removeIntermediateNode^%zewdDOM(xOID)
 QUIT argumentsOID
 ;
expandTextArea(nodeOID,attr,parentOID)
 i $$textAreaInstance^%zewdExt4a(.attr,nodeOID,parentOID)
 QUIT
 ;
textAreaInstance(attrs,nodeOID,instanceOID)
 QUIT $$textAreaInstance^%zewdExt4a(.attrs,nodeOID,instanceOID)
 ;
expandHtmlEditor(nodeOID,attr,parentOID)
 i $$htmlEditorInstance^%zewdExt4a(.attr,nodeOID,parentOID)
 QUIT
 ;
htmlEditorInstance(attrs,nodeOID,instanceOID)
 QUIT $$htmlEditorInstance^%zewdExt4a(.attrs,nodeOID,instanceOID)
 ;
gridPanelInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,clicksToEdit,colDef,cspOID,groupField,grouping,id
 n mainAttrs,sessionName,storeId,tagName,text,validationPage,xOID
 ;
 m mainAttrs=attrs
 s colDef=$g(attrs("columndefinition"))
 s sessionName=$g(attrs("sessionname"))
 s storeId=$g(attrs("storeid"))
 s clicksToEdit=$g(attrs("clicksToEdit"))
 s validationPage=$g(attrs("validationpage"))
 s groupField=$g(attrs("groupfield"))
 i validationPage'="",clicksToEdit="" s clicksToEdit=1
 ;s grouping=$g(attrs("grouping"))
 s id=$g(attrs("id"))
 i storeId="",id="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . s mainAttrs("id")=id
 i id="",storeId'="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . s mainAttrs("id")=id
 k attrs("columndefinition")
 k attrs("sessionname")
 k attrs("storeid")
 k attrs("grouping")
 k attrs("clicksToEdit")
 k attrs("validationpage")
 i storeId="" s storeId=id_"Store"
 i $g(attrs("store"))="" s attrs("store")="."_storeId
 i colDef'="" s attrs("columns")=".EWD.ext4.grid['"_id_"'].cols"
 i sessionName'="" d
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeGridStore^%zewdExt4Code("""_sessionName_""","""_colDef_""","""_id_""","""_storeId_""","""_groupField_""",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="gridpanel" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 i $g(mainAttrs("grouping"))="true"!($g(mainAttrs("groupingsummary"))="true") d
 . n featuresOID,xOID
 . i '$$hasChildTag^%zewdDOM(argumentsOID,"ext4:features",.featuresOID) d
 . . s featuresOID=$$addElementToDOM^%zewdDOM("ext4:features",argumentsOID)
 . s attr("ftype")="grouping"
 . i $g(mainAttrs("groupingsummary"))="true" s attr("ftype")="groupingsummary"
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:item",featuresOID,,.attr)
 i clicksToEdit'="" d
 . n pluginsOID,xOID
 . i '$$hasChildTag^%zewdDOM(argumentsOID,"ext4:plugins",.pluginsOID) d
 . . s pluginsOID=$$addElementToDOM^%zewdDOM("ext4:plugins",argumentsOID)
 . s attr("clickstoedit")=clicksToEdit
 . s attr("ptype")="cellediting"
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:item",pluginsOID,,.attr)
 . i validationPage'="" d
 . . n argOID,argsOID,codeOID,fnOID,lOID,lsOID,text
 . . s lsOID=$$addElementToDOM^%zewdDOM("ext4:listeners",xOID)
 . . s lOID=$$addElementToDOM^%zewdDOM("ext4:edit",lsOID)
 . . s fnOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",lOID)
 . . s argsOID=$$addElementToDOM^%zewdDOM("ewd:arguments",fnOID)
 . . s attr("name")="editor"
 . . s attr("quoted")="false"
 . . s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 . . s attr("name")="e"
 . . s attr("quoted")="false"
 . . s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 . . s text="EWD.ext4.e = e;"_$c(13,10)
 . . s text=text_"var ov = e.originalValue;"_$c(13,10)
 . . s text=text_"var value = e.value;"_$c(13,10)
 . . s text=text_"var editAs = e.grid.columns[e.colIdx].editas;"_$c(13,10)
 . . s text=text_"if (editAs === 'datefield') {"_$c(13,10)
 . . s text=text_"  value = Ext.Date.format(value,'m/d/Y');"_$c(13,10)
 . . s text=text_"  if (ov.toString().indexOf('/') === -1) ov = Ext.Date.format(ov, 'm/d/Y');"_$c(13,10)
 . . s text=text_"}"_$c(13,10)
 . . s text=text_"if (value !== ov) {"_$c(13,10)
 . . s text=text_" value = encodeURIComponent(value);"_$c(13,10)
 . . s text=text_" var nvp = 'row=' + e.record.data.zewdRowNo + '&colName=' + e.field + '&value=' + value + '&originalValue=' + ov;"_$c(13,10)
 . . s text=text_" EWD.ajax.getPage({page:'"_validationPage_"',nvp:nvp});"_$c(13,10)
 . . s text=text_"}"_$c(13,10)
 . . s codeOID=$$addElementToDOM^%zewdDOM("ewd:code",fnOID,,,text)
 ;
 i sessionName'="" d removeIntermediateNode^%zewdDOM(xOID)
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
 . . n ptype,xtype
 . . s ptype=$g(tagNameMap(tagName,"ptype"))
 . . s xtype=$g(tagNameMap(tagName,"xtype"))
 . . i xtype'=""!(ptype'="") d
 . . . i xtype'="" s attr("xtype")=xtype
 . . . i ptype'="" s attr("ptype")=ptype
 . . . s xtypeTagName=$g(tagNameMap(tagName,"xtypeTagName"))
 . . . ;i xtypeTagName="" s xtypeTagName="ext4:item"
 . . . s containerTag=$g(tagNameMap(tagName,"containerTag"))
 . . . ;i containerTag="" s containerTag="ext4:items"
 . . . i containerTag="ext4:dockeditems",$$hasChildTag^%zewdDOM(parentOID,containerTag,.itemsOID) d
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
 . . i $$getTagName^%zewdDOM(nodeOID)="ext4:actioncolumn" d
 . . . d setAttribute^%zewdDOM("xtype","actioncolumn",itemOID)
 . . d nextPageHandler(itemOID)
 . i $$hasChildNodes^%zewdDOM(childOID)="true" d expand(childOID,itemOID,.tagNameMap)
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 QUIT
 ;
expandChart(nodeOID,attr,parentOID)
 n ok
 s ok=$$chartInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
chartInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,chartDef,cspOID,id,mainAttrs,sessionName,storeId,xOID
 ;
 s xOID=""
 m mainAttrs=attrs
 s chartDef=$g(attrs("chartdefinition"))
 s sessionName=$g(attrs("sessionname"))
 s storeId=$g(attrs("storeid"))
 s id=$g(attrs("id"))
 i storeId="",id="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . s mainAttrs("id")=id
 i id="",storeId'="" d
 . s id=$$uniqueId(nodeOID)
 . s attrs("id")=id
 . s mainAttrs("id")=id
 k attrs("sessionname")
 k attrs("storeid")
 k attrs("chartdefinition")
 i storeId="" s storeId=id_"Store"
 i $g(attrs("store"))="" s attrs("store")="."_storeId
 i chartDef'="" d
 . s attrs("axes")=".EWD.ext4.chart['"_id_"'].axes"
 . s attrs("series")=".EWD.ext4.chart['"_id_"'].series"
 . s attrs("legend")=".EWD.ext4.chart['"_id_"'].legend"
 i sessionName'="" d
 . n text
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeJSONStore^%zewdExt4Code("""_sessionName_""","""_chartDef_""","""_id_""","""_storeId_""",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="chart" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 i sessionName'="" d removeIntermediateNode^%zewdDOM(xOID)
 QUIT argumentsOID
 ;
expandGridPanel(nodeOID,attr,parentOID)
 n ok
 s ok=$$gridPanelInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
addQuickTipManager(nodeOID,attr,parentOID)
 s attr("hoistToExt4Init")="Ext.tip.QuickTipManager.init();"
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
 . n addTo,html,id,lattr,lOID,lsOID,src,text
 . s src=attr("src")
 . s src=$p(src,".ewd",1)
 . s id="Ext4Panel"_$$uniqueId^%zewdAPI(nodeOID,filename)_"Div"
 . i 'addPage d
 . . s html="<span id='"_id_"'></span>"
 . . s attr("html")=html
 . k attr("src")
 . i '$$hasChildTag^%zewdDOM(nodeOID,"ext4:listeners",.lsOID) d
 . . s lsOID=$$addElementToDOM^%zewdDOM("ext4:listeners",nodeOID)
 . s addTo=$g(attr("addto"))
 . k attr("addto") 
 . i addTo'="" d
 . . s text="var nvp='ext4_addTo="_addTo_"';"_$c(13,10)
 . . i addPage d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',nvp:nvp});"
 . . e  d
 . . . s text=text_"EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"',nvp:nvp});"
 . e  d
 . . i addPage d
 . . . s text="EWD.ajax.getPage({page:'"_src_"'});"
 . . e  d
 . . . s text="EWD.ajax.getPage({page:'"_src_"',targetId:'"_id_"'});"
 . s lattr("render")=text
 . s lOID=$$addElementToDOM^%zewdDOM("ext4:listener",lsOID,,.lattr)
 ;
 QUIT
 ;
nextPageHandler(nodeOID)
 d nextPageHandler^%zewdExt4a($g(nodeOID))
 QUIT
 ;
pass3(nodeOID,tagNameMap)
 ;
 n aOID,nodeArray,OIDArray,xOID
 ;
 i $$getElementsByTagName^%zewdDOM("ext4:arguments",docOID,.nodeArray)
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
 ;s lsOID=$$addElementToDOM^%zewdDOM("ext4:listeners",nodeOID)
 ;s lOID=$$addElementToDOM^%zewdDOM("ext4:listener",lsOID)
 ;d setAttribute^%zewdDOM("afterrender","EWD.ext4.items['"_id_"']()",lOID)
 d setAttribute^%zewdDOM(attrName,".EWD.ext4.items['"_id_"']['"_attrName_"']",nodeOID)
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s cspOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 s xOID=$$appendChild^%zewdDOM(xOID,cspOID)
 s text=" d writeJSONContent^%zewdExt4Code("""_jsonDef_""","""_id_""","""_attrName_""","""_xtype_""",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 d removeIntermediateNode^%zewdDOM(xOID)
 QUIT
 ;
expandContainer(nodeOID,attr,parentOID)
 n ok
 s ok=$$containerInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
containerInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,delim,fileName,global,id,path,text,xOID
 ;
 s fileName=$g(attrs("filename"))
 s global=$g(attrs("global"))
 k attrs("filename"),attrs("global")
 s id=$g(attrs("id"))
 i fileName'="" d
 . s xOID=$$createElement^%zewdDOM("cspTemp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s path=$$getApplicationRootPath^%zewdAPI()
 . s delim=$$getDelim^%zewdAPI()
 . i $e(path,$l(path))'=delim s path=path_delim
 . s path=path_$$zcvt^%zewdAPI(app,"l")_delim_fileName
 . s text=" d writeArchitectContent^%zewdExt4Code(""file"","""_path_""","""_id_""",""items"",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i global'="" d
 . s xOID=$$createElement^%zewdDOM("cspTemp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeArchitectContent^%zewdExt4Code(""global"","""_global_""","""_id_""",""items"",sessid)"
 . s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="container" d
 . n prefix
 . s prefix=$p($$getTagName^%zewdDOM(nodeOID),":",1)
 . s argumentsOID=$$addElementToDOM^%zewdDOM(prefix_":arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 d
 . i fileName'="" d removeIntermediateNode^%zewdDOM(xOID) q
 . i global'="" d removeIntermediateNode^%zewdDOM(xOID)
 ;
 ;i fileName="",global="" d
 ;. n prefix
 ;. s prefix=$p($$getTagName^%zewdDOM(nodeOID),":",1)
 ;. i prefix="ext4" d
 ;. . s argumentsOID=$$panelInstance(.attrs,nodeOID,instanceOID)
 ;. e  d
 ;. . s argumentsOID=$$panelInstance^%zewdSTch2(.attrs,nodeOID,instanceOID) break
 QUIT argumentsOID
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
architect(nodeOID)
 d architect^%zewdExt4a($g(nodeOID))
 QUIT
 ;
processNameList(nameList,formDeclarations)
 d processNameList^%zewdExt4a(.nameList,.formDeclarations)
 QUIT
 ;
