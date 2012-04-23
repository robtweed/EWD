%zewdExt4 ; Extjs Tag Processors
 ;
 ; Product: Enterprise Web Developer (Build 908)
 ; Build Date: Mon, 23 Apr 2012 11:56:19
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
 n appName,attr,bodyOID,configOID,cspScriptsOID,headOID,htmlOID,jsOID,jsSectionOID,jsVersion
 n mainAttrs,nameList,rootPath,src,tagNameMap,text,title,xOID
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
 s src=rootPath_"resources/css/ext-all.css"
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
 s attr("type")="text/javascript"
 s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s attr("id")="Ext4Init"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s text=""
 s text=text_"EWD.ext4={"_$c(13,10)
 s text=text_"  grid: {"_$c(13,10)
 s text=text_"    getRowNo: function(grid,rowIndex) {"_$c(13,10)
 s text=text_"      return grid.store.getAt(rowIndex).get('zewdRowNo');"_$c(13,10)
 s text=text_"    }"_$c(13,10)
 s text=text_"  },"_$c(13,10)
 s text=text_"  submit: function (formPanelId,nextPage,addTo,replace) {"_$c(13,10)
 s text=text_"    var nvp='';"_$c(13,10)
 s text=text_"    var amp='';"_$c(13,10)
 s text=text_"    Ext.getCmp(formPanelId).getForm().getFields().eachKey("_$c(13,10)
 s text=text_"      function(key,item) {"_$c(13,10)
 s text=text_"        if ((item.xtype !== 'radiogroup')&&(item.xtype !== 'checkboxgroup')) {"_$c(13,10)
 s text=text_"          var value = '';"_$c(13,10)
 s text=text_"          if (item.xtype === 'htmleditor') {"_$c(13,10)
 s text=text_"            value = item.getValue();"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else {"_$c(13,10)
 s text=text_"            if (item.getSubmitValue() !== null) value = item.getSubmitValue();"_$c(13,10)
 s text=text_"          }"
 s text=text_"          nvp = nvp + amp + item.getName() + '=' + value;"_$c(13,10)
 s text=text_"          amp='&';"_$c(13,10)
 s text=text_"        }"_$c(13,10)
 s text=text_"      }"_$c(13,10)
 s text=text_"    );"_$c(13,10)
 s text=text_"    if (addTo !== '') nvp = nvp + '&ext4_addTo=' + addTo;"_$c(13,10)
 s text=text_"    if (replace === 1) nvp = nvp + '&ext4_removeAll=true';"_$c(13,10)
 s text=text_"    EWD.ajax.getPage({page:nextPage,nvp:nvp})"_$c(13,10)
 s text=text_"  }"_$c(13,10)
 s text=text_"};"_$c(13,10)
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",xOID,,,text)
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
 d childTags(nodeOID,jsSectionOID)
 i technology="csp" d
 . n cspOID
 . s text=" w ""<""_""/script>"""_$c(13,10)
 . s cspOID=$$addCSPServerScript^%zewdAPI(cspScriptsOID,text)
 s xOID=$$getElementById^%zewdDOM("cspScripts",docOID)
 d removeAttribute^%zewdDOM("id",xOID)
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
childTags(nodeOID,jsSectionOID)
 ;
 n childNo,childOID,isFragment,OIDArray,parentTagName,tagName
 ;
 s parentTagName=$$getTagName^%zewdDOM(nodeOID)
 s isFragment=parentTagName="ext4:fragment"
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="ewd:xhtml" q
 . ;i tagName="ext4:listeners" q
 . i tagName="ext4:jsLine" d
 . . n contentOID,text,xOID
 . . s text=$$getElementText^%zewdDOM(childOID)
 . . s contentOID=$$getElementById^%zewdDOM("ext4Content",docOID)
 . . s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",contentOID,,,text)
 . . i $$removeChild^%zewdDOM(childOID,1)
 . i tagName="ext4:defineclass" d ExtDefine(childOID) q
 . i tagName="ext4:createinstance" d ExtCreate(childOID,jsSectionOID,isFragment) q
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
 . ;d topLevelTag(tagName,childOID,jsSectionOID,.tagNameMap) q
 . i tagName="ext4:json" d json(childOID)
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
 i $$getTagName^%zewdDOM(dataOID)="ext4:arguments" d
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
 . n addTo,remove,text
 . q:className["Store"
 . q:'add
 . s addTo=$$addPhpVar^%zewdCustomTags("#ext4_addTo")
 . s remove=$$addPhpVar^%zewdCustomTags("#ext4_removeAll")
 . s text="var addTo='"_addTo_"';"_$c(13,10)
 . s text=text_"var remove='"_remove_"';"_$c(13,10)
 . s text=text_"if (remove === 'true') Ext.getCmp('"_addTo_"').removeAll(true);"_$c(13,10)
 . s text=text_"if (addTo !== '') Ext.getCmp('"_addTo_"').add(Ext.getCmp('"_id_"'));"
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",parentOID,,,text)
 i $$removeChild^%zewdDOM(nodeOID,1)
 QUIT
 ;
fragment(nodeOID,attrValue,docOID,technology)
 ;
 ;
 n botJSOID,configOID,jsOID,nameList,tagNameMap,text,topJSOID,xOID
 ;
 ;<ext4:fragment>
 ; .... etc
 ;</ext4:fragment>
 ;
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
 d childTags(nodeOID,jsOID)
 d processNameList^%zewdST2(.nameList,.formDeclarations)
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
ExtDefine(nodeOID)
 ;
 n attr,callBack,className,dataOID
 n mainAttrs,mOID,paramsOID,parentOID,xOID
 ;
 do getAttributes(nodeOID,.mainAttrs)
 i $g(mainAttrs("object"))'="" d
 . s attr("return")=mainAttrs("object")
 . i $g(mainAttrs("var"))="true" s attr("var")="true"
 s parentOID=$$getElementById^%zewdDOM("Ext4ClassDefinitions",docOID)
 s attr("name")="Ext.define"
 s mOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",parentOID,,.attr)
 s paramsOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",mOID)
 s className=$g(mainAttrs("classname")) i className="" s className="unnamedClass"
 s callBack=$g(mainAttrs("callback"))
 s attr("value")=className
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",paramsOID,,.attr)
 s dataOID=$$getFirstChild^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(dataOID)="ext4:data" d
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
 ;i parentId'="ext4Content" d
 ;. n mOID,pOID
 ;. s attr("name")="Ext.getCmp('"_parentId_"').add"
 ;. s mOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",jsSectionOID,,.attr)
 ;. s pOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",mOID)
 ;. s attr("name")="Ext.getCmp('"_mainAttrs("id")_"')"
 ;. s xOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",pOID,,.attr)
 ;. s attr("name")="Ext.getCmp('"_parentId_"').doLayout"
 ;. s mOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",jsSectionOID,,.attr)
 s attr("id")=mainAttrs("id")
 s jsChildSectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsSectionOID,,.attr)
 ;
 ; recurse through any child tags
 ;
 d childTags(nodeOID,jsChildSectionOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
getChildNodes(nodeOID,objOID)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
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
 ;
 n attr,cspOID,i,line,logoutFn,parentOID,phpVar,rootPath,sessionName,srcs,stop,text,wallpaper,xOID
 ;
 s sessionName=$$getAttribute^%zewdDOM("sessionname",nodeOID)
 i sessionName'="" d
 . s text=" d writeDesktopConfig^%zewdExt4Code("""_sessionName_""",sessid)"
 e  d
 . n childNo,childOID,comma,OIDArray
 . s text=" w ""EWD.desktop = {windows:["""_$c(13,10)
 . d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 . s childNo="",comma=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . i $$getTagName^%zewdDOM(childOID)="ext4:window" d
 . . . n comma2,mainAttrs,name,value
 . . . s comma2=""
 . . . d getAttributes(childOID,.mainAttrs)
 . . . i $g(mainAttrs("title"))="" s mainAttrs("title")="Unnamed Window"
 . . . i $g(mainAttrs("name"))="" s mainAttrs("name")="Unnamed Icon"
 . . . i $g(mainAttrs("iconCls"))="" s mainAttrs("iconCls")="accordion-shortcut"
 . . . i $g(mainAttrs("width"))="" s mainAttrs("width")=300
 . . . i $g(mainAttrs("height"))="" s mainAttrs("height")=400
 . . . i $g(mainAttrs("fragment"))="" s mainAttrs("title")="unspecifiedFragment"
 . . . i $g(mainAttrs("quickStart"))="" s mainAttrs("quickStart")="false"
 . . . s text=text_" w """_comma_"{"
 . . . s name=""
 . . . f  s name=$o(mainAttrs(name)) q:name=""  d
 . . . . s value=mainAttrs(name)
 . . . . d
 . . . . . i value="true"!(value="false") q
 . . . . . i $$numeric^%zewdJSON(value) q
 . . . . . s value="'"_value_"'"
 . . . . s text=text_comma2_name_":"_value
 . . . . s comma2=","
 . . . s text=text_"}"""_$c(13,10)
 . . . s comma=","
 . . i $$removeChild^%zewdDOM(childOID,1)
 . s text=text_" w ""]};"""_$c(13,10)
 s cspOID=$$addCSPServerScript^%zewdAPI(nodeOID,text)
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 s rootPath=$$getAttribute^%zewdDOM("rootpath",parentOID)
 i $e(rootPath,$l(rootPath))'="/" s rootPath=rootPath_"/"
 s wallpaper=$$getAttribute^%zewdDOM("wallpaper",nodeOID)
 i wallpaper="" s wallpaper=rootPath_"examples/desktop/wallpapers/Blue-Sencha.jpg"
 ;
 s stop=0
 s text="if (typeof EWD.desktop.wallpaper === 'undefined') EWD.desktop.wallpaper = '"_wallpaper_"';"_$c(13,10)
 s phpVar=$$addPhpVar^%zewdCustomTags("#EWD.desktop.username","j")
 s text=text_"EWD.desktop.username = '"_phpVar_"';"_$c(13,10)
 s logoutFn=$$getAttribute^%zewdDOM("logoutfn",nodeOID)
 i logoutFn="" s logoutFn="function() {alert('undefined logout function');}"
 s text=text_"EWD.desktop.logoutFn="_logoutFn_";"
 s xOID=$$addElementToDOM^%zewdDOM("ext4:jsLine",nodeOID,,,text)
 f i=1:1 d  q:stop
 . s line=$t(desktopJS+i^%zewdExt4Code)
 . i line["***END***" s stop=1 q
 . s text=$p(line,";;",2,200)_$c(13,10)
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:jsLine",nodeOID,,,text)
 s text="EWD.desktop.app = new EWDDesktop.App();"
 s xOID=$$addElementToDOM^%zewdDOM("ext4:jsLine",nodeOID,,,text)
 s attr("href")=rootPath_"examples/desktop/css/desktop.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",parentOID,,.attr)
 s srcs(1)="Desktop"
 s srcs(2)="FitAllLayout"
 s srcs(3)="Module"
 s srcs(4)="ShortcutModel"
 s srcs(5)="StartMenu"
 s srcs(6)="TaskBar"
 s srcs(7)="Video"
 s srcs(8)="Wallpaper"
 s srcs(9)="App"
 f i=1:1:9 d
 . s attr("src")=rootPath_"examples/desktop/js/"_srcs(i)_".js"
 . s attr("type")="text/javascript"
 . s attr("defer")="defer"
 . s xOID=$$addElementToDOM^%zewdDOM("script",parentOID,,.attr)
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
 i $g(mainAttrs("id"))="" s mainAttrs("id")=$$uniqueId(nodeOID)
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
 s xOID=$$renameTag^%zewdDOM("ext4:window",nodeOID)
 d setAttribute^%zewdDOM("modal","true",xOID)
 QUIT
 ;
addEwdActionField(nodeOID)
 ;
 n attr,xOID
 ;
 s attr("name")="ewd_action"
 s attr("id")="ewd_action"
 s attr("value")="zewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;s nameList("ewd_action")="hidden|"_attr("value")
 s xOID=$$addElementToDOM^%zewdDOM("ext4:hiddenfield",nodeOID,,.attr)
 QUIT
 ;
swapFormFields(nodeOID)
 ;
 n type,xOID
 ;
 s type=$$getAttribute^%zewdDOM("type",nodeOID)
 i type["field" d
 . s xOID=$$renameTag^%zewdDOM("ext4:"_type,nodeOID)
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
 ;d setAttribute^%zewdDOM("formid",formId,nodeOID)
 ;s text=$$getAttribute^%zewdDOM("text",nodeOID)
 s nextPage=$$getAttribute^%zewdDOM("nextpage",nodeOID)
 s addTo=$$getAttribute^%zewdDOM("addto",nodeOID)
 s replace=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)="true"
 f attr="nextpage","addto","replacepreviouspage" d removeAttribute^%zewdDOM(attr,nodeOID)
 ;s btnsOID=$$addElementToDOM^%zewdDOM("ext4:buttons",nodeOID)
 ;s attr("text")=text
 s handler=".function() {EWD.ext4.submit('"_formId_"','"_nextPage_"','"_addTo_"',"_replace_")}"
 d setAttribute^%zewdDOM("handler",handler,nodeOID)
 ;s xOID=$$addElementToDOM^%zewdDOM("ext4:item",btnsOID,,.attr)
 ;d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
convertMenu(nodeOID)
 ;
 n parentOID,xOID
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(parentOID)="ext4:menuitem" d
 . s xOID=$$renameTag^%zewdDOM("ext4:buttonmenu",nodeOID)
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
setNameList(nodeOID)
 ;
 n name,id,tagName,type
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s name=$$getAttribute^%zewdDOM("name",nodeOID)
 i tagName'="ext4:radiofield",tagName'="ext4:checkboxfield" d
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
 i tagName'="ext4:displayfield" d
 . s nameList(name)=type ;leaks out to container or fragment!
 ;
 i tagName="ext4:timefield" d
 . n format
 . s format=$$getAttribute^%zewdDOM("format",nodeOID)
 . s format=$$zcvt^%zewdAPI(format,"l")
 . i format="24hour"!((format["24")&(format["h")) d
 . . d setAttribute^%zewdDOM("format","H:i",nodeOID)
 i tagName="ext4:radiofield" d
 . n phpVar,value
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_name,"j")
 . s value=$$getAttribute^%zewdDOM("inputvalue",nodeOID)
 . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 i tagName="ext4:checkboxfield" d
 . n phpVar,value
 . s value=$$getAttribute^%zewdDOM("inputvalue",nodeOID)
 . s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_selected."_name_"."_value,"j")
 . d setAttribute^%zewdDOM("checked",".'"_phpVar_"' === '"_value_"'",nodeOID)
 d
 . n value
 . s value=$$getAttribute^%zewdDOM("value",nodeOID)
 . i value="*" d setAttribute^%zewdDOM("value",("#"_name),nodeOID)
 ;
 QUIT
 ;
treePanelListener(nodeOID)
 ;
 n argOID,argsOID,attr,codeOID,fnOID,icOID,lsOID,text
 ;
 i '$$hasChildTag^%zewdDOM(nodeOID,"ext4:listeners",.lsOID) d
 . s lsOID=$$addElementToDOM^%zewdDOM("ext4:listeners",nodeOID)
 s icOID=$$addElementToDOM^%zewdDOM("ext4:itemClick",lsOID)
 s fnOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",icOID)
 s argsOID=$$addElementToDOM^%zewdDOM("ewd:arguments",fnOID)
 s attr("name")="view"
 s attr("quoted")="false"
 s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 s attr("name")="record"
 s attr("quoted")="false"
 s argOID=$$addElementToDOM^%zewdDOM("ewd:argument",argsOID,,.attr)
 s text="if (typeof record.raw.page !== '') {"_$c(13,10)
 s text=text_"EWD.record=record;"_$c(13,10)
 s text=text_"var nvp = record.raw.nvp;"_$c(13,10)
 s text=text_"if (typeof record.raw.addTo !== 'undefined') {"_$c(13,10)
 s text=text_"if (nvp !== '') nvp = nvp + '&';"_$c(13,10)
 s text=text_"nvp = nvp + 'ext4_addTo=' + record.raw.addTo;"_$c(13,10)
 s text=text_" }"_$c(13,10)
 s text=text_"if (typeof record.raw.replace !== 'undefined') {"_$c(13,10)
 s text=text_"if (nvp !== '') nvp = nvp + '&';"_$c(13,10)
 s text=text_"nvp = nvp + 'ext4_removeAll=true';"_$c(13,10)
 s text=text_" }"_$c(13,10)
 s text=text_"EWD.ajax.getPage({page:record.raw.page,nvp:nvp});"_$c(13,10)
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
 i $g(attr("store"))="" d
 . s attr("displayField")="name"
 . s attr("valueField")="value"
 . s fieldName=$g(attr("name")) i fieldName="" s fieldName="unnamedCombobox"
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
 s ok=$$treePanelInstance(.attr,childOID,parentOID)
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
gridPanelInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,clicksToEdit,colDef,cspOID,grouping,id
 n mainAttrs,sessionName,storeId,tagName,text,validationPage,xOID
 ;
 m mainAttrs=attrs
 s colDef=$g(attrs("columndefinition"))
 s sessionName=$g(attrs("sessionname"))
 s storeId=$g(attrs("storeid"))
 s clicksToEdit=$g(attrs("clicksToEdit"))
 s validationPage=$g(attrs("validationpage"))
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
 i colDef'="" s attrs("columns")="."_id_"Cols"
 i sessionName'="" d
 . s xOID=$$createElement^%zewdDOM("temp",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 . s text=" d writeGridStore^%zewdExt4Code("""_sessionName_""","""_colDef_""","""_id_""","""_storeId_""",sessid)"
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
 i validationPage'="",clicksToEdit'="" d
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
 . . ;s text=text_"var nvp = 'row=' + e.rowIdx + '&col=' + e.colIdx + '&colName=' + e.field + '&value=' + e.value + '&originalValue=' + e.originalValue;"_$c(13,10)
 . . s text=text_"var nvp = 'row=' + e.record.data.zewdRowNo + '&colName=' + e.field + '&value=' + e.value + '&originalValue=' + e.originalValue;"_$c(13,10)
 . . s text=text_"EWD.ajax.getPage({page:'"_validationPage_"',nvp:nvp});"_$c(13,10)
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
 i $$getTagName^%zewdDOM(nodeOID)["grid"
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
 . i $$getAttribute^%zewdDOM("nextpage",itemOID)'="" d nextPageHandler(itemOID)
 . i $$hasChildNodes^%zewdDOM(childOID)="true" d expand(childOID,itemOID,.tagNameMap)
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 QUIT
 ;
expandGridPanel(nodeOID,attr,parentOID)
 n ok
 s ok=$$gridPanelInstance(.attr,childOID,parentOID)
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
 ;
 n addTo,codeOID,fnOID,handlerOID,nextPage,replace,text
 ;
 s nextPage=$$getAttribute^%zewdDOM("nextpage",nodeOID)
 i nextPage="" QUIT
 d removeAttribute^%zewdDOM("nextpage",nodeOID)
 s addTo=$$getAttribute^%zewdDOM("addto",nodeOID)
 d removeAttribute^%zewdDOM("addto",nodeOID)
 s replace=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 d removeAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 s handlerOID=$$addElementToDOM^%zewdDOM("ext4:handler",nodeOID)
 s fnOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",handlerOID)
 s text=""
 i addTo'="" d
 . s text=text_"var nvp='ext4_addTo="_addTo
 . i replace="true" d
 . . s text=text_"&ext4_removeAll=true"
 . s text=text_"';"_$c(13,10)
 . s text=text_"EWD.ajax.getPage({page:'"_nextPage_"',nvp:nvp});"
 e  d
 . s text=text_"EWD.ajax.getPage({page:'"_nextPage_"'});"
 s codeOID=$$addElementToDOM^%zewdDOM("ewd:code",fnOID,,,text)
 ;
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
 . ;q:type="submit"
 . ;s xtype="text"
 . ;i type="date" s xtype="ext4date"
 . ;s nameList(field)=xtype
 . s list=list_field_"|"_type_"`"
 s no=no+1
 s formDeclarations(no)=name_"~~~"_list
 i technology="csp" d
 . k nameList("ewd_action")
 . m ^zewd("form",$$zcvt^%zewdAPI(app,"l"),"ewd_action",name)=nameList
 ;
 QUIT
 ;
setTextAreaValue(array,fieldName,sessid)
 ;
 n lf,lineNo,text
 ;
 s text=""
 s lf=""
 s lineNo=""
 f  s lineNo=$o(array(lineNo)) q:lineNo=""  d
 . s text=text_lf_array(lineNo)
 . s lf="\n"
 d setSessionValue^%zewdAPI(fieldName,text,sessid)
 ;
 QUIT
 ;
setHtmlEditorValue(array,fieldName,sessid)
 ;
 n lf,lineNo,text
 ;
 s text=""
 s lf=""
 s lineNo=""
 f  s lineNo=$o(array(lineNo)) q:lineNo=""  d
 . s text=text_lf_array(lineNo)
 . s lf="<br>"
 d setSessionValue^%zewdAPI(fieldName,text,sessid)
 ;
 QUIT
 ;
