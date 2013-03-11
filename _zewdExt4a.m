%zewdExt4a ; Extjs Tag Processors (continued)
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
 QUIT
 ;
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
 . ;d topLevelTag(tagName,childOID,jsSectionOID,.tagNameMap) q
 . i tagName="ext4:json" d json^%zewdExt4(childOID)
 . i tagName="ext4:html" d
 . . n bodyOID
 . . s childOID=$$removeChild^%zewdDOM(childOID)
 . . s bodyOID=$$getTagOID^%zewdDOM("body",docName)
 . . s childOID=$$appendChild^%zewdDOM(childOID,bodyOID)
 . . d removeIntermediateNode^%zewdDOM(childOID)
 QUIT
 ;
ExtDefine(nodeOID)
 ;
 n attr,callBack,className,dataOID
 n mainAttrs,mOID,paramsOID,parentOID,xOID
 ;
 do getAttributes^%zewdExt4(nodeOID,.mainAttrs)
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
 . do getAttributes^%zewdExt4(dataOID,.mainAttrs)
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
 . d getChildNodes^%zewdExt4(dataOID,objOID)
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
ExtCreate(nodeOID,parentOID,isFragment)
 ;
 n add,attr,className,dataOID,id
 n mainAttrs,mOID,paramsOID,xOID
 ;
 s add=1
 do getAttributes^%zewdExt4(nodeOID,.mainAttrs)
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
 . do getAttributes^%zewdExt4(dataOID,.mainAttrs)
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
 . d getChildNodes^%zewdExt4(dataOID,objOID)
 ;
 i isFragment d
 . n addTo,remove,text
 . q:className["Store"
 . q:'add
 . s addTo=$$addPhpVar^%zewdCustomTags("#tmp_addTo")
 . s remove=$$addPhpVar^%zewdCustomTags("#tmp_removeAll")
 . ;s text="var addTo='"_addTo_"';"_$c(13,10)
 . s text="var addTo='"_addTo_"';"_$c(13,10)
 . s text=text_"var remove='"_remove_"';"_$c(13,10)
 . s text=text_"if (remove === 'true') Ext.getCmp('"_addTo_"').removeAll(true);"_$c(13,10)
 . s text=text_"if (addTo !== '') Ext.getCmp('"_addTo_"').add(Ext.getCmp('"_id_"'));"
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",parentOID,,,text)
 i $$removeChild^%zewdDOM(nodeOID,1)
 QUIT
 ;
architect(nodeOID)
 n array,id,ok,text,textArr,xOID
 ;
 s id=$$getAttribute^%zewdDOM("id",nodeOID)
 i id="" d
 . s id=$$uniqueId^%zewdExt4(nodeOID)
 . d setAttribute^%zewdDOM("id",id,nodeOID)
 s text=$$getElementText^%zewdDOM(nodeOID,.textArr)
 i text'="" d
 . s ok=$$parseJSON^%zewdJSON(text,.array,1)
 . i ok="" d
 . . s app=$$zcvt^%zewdAPI(app,"l")
 . . k ^zewd("extjs",app,id)
 . . m ^zewd("extjs",app,id)=array
 . . d setAttribute^%zewdDOM("global",app,nodeOID)
 . . s textOID=$$getFirstChild^%zewdDOM(nodeOID)
 . . s textOID=$$removeChild^%zewdDOM(textOID,1)
 s xOID=$$renameTag^%zewdDOM("ext4:container",nodeOID,1)
 d setAttribute^%zewdDOM("items",".EWD.ext4.items['"_id_"']['items']",nodeOID)
 QUIT
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
 . s no=""
 . f  s no=$o(ewdActions(no)) q:no=""  d
 . . s name=ewdActions(no)
 . . m ^zewd("form",$$zcvt^%zewdAPI(app,"l"),"ewd_action",name)=nameList
 ;
 QUIT
 ;
nextPageHandler(nodeOID)
 ;
 n actionCol,addTo,amp,argOID,argsOID,attr,codeOID,fnOID,handlerOID,nextPage,nvp,replace,text
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
 s replace=$$getAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 d removeAttribute^%zewdDOM("replacepreviouspage",nodeOID)
 s handlerOID=$$addElementToDOM^%zewdDOM("ext4:handler",nodeOID)
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
 i addTo'="" d
 . s text=text_"nvp=nvp+'"_amp_"ext4_addTo="_addTo
 . i replace="true" d
 . . s text=text_"&ext4_removeAll=true"
 . i actionCol s text=text_"&rowIndex=' + rowIndex + '&row=' + EWD.ext4.getGridRowNo(me,rowIndex) + '"
 . s text=text_"';"_$c(13,10)
 e  d
 . i actionCol d
 . . s text=text_"nvp=nvp+'"_amp_"rowIndex=' + rowIndex + '&row=' + EWD.ext4.getGridRowNo(me,rowIndex)"
 . ;e  d
 . ;. s text="var nvp='';"
 . s text=text_";"_$c(13,10)
 s text=text_"EWD.ajax.getPage({page:'"_nextPage_"',nvp:nvp});"
 s codeOID=$$addElementToDOM^%zewdDOM("ewd:code",fnOID,,,text)
 ;
 QUIT
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
 s attrs("value")=".EWD.ext4.textarea['"_id_"']"
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 s text=" d writeTextArea^%zewdExt4Code("""_id_""",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="textareafield" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandHtmlEditor(nodeOID,attr,parentOID)
 n ok
 s ok=$$htmlEditorInstance(.attr,nodeOID,parentOID)
 QUIT
 ;
htmlEditorInstance(attrs,nodeOID,instanceOID)
 ;
 n argumentsOID,cspOID,id,mainAttrs,tagName,text,xOID
 ;
 m mainAttrs=attrs
 s id=$g(attrs("id"))
 s attrs("value")=".EWD.ext4.textarea['"_id_"']"
 s xOID=$$createElement^%zewdDOM("temp",docOID)
 s xOID=$$insertBefore^%zewdDOM(xOID,nodeOID)
 s text=" d writeHtmlEditorText^%zewdExt4Code("""_id_""",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(xOID,text)
 ;
 i $g(attrs("xtype"))'="htmleditor" d
 . s argumentsOID=$$addElementToDOM^%zewdDOM("ext4:arguments",instanceOID,,.attrs)
 e  d
 . s argumentsOID=nodeOID
 ;
 d removeIntermediateNode^%zewdDOM(xOID)
 ;
 QUIT argumentsOID
 ;
expandCalendarPanel(nodeOID)
 ;
 n applc,src
 ;
 s applc=$$zcvt^%zewdAPI(app,"l")
 s src="examples/calendar/resources/css/calendar.css"
 d registerResource^%zewdCustomTags("css",src,"",app,,1)
 s src="examples/calendar/resources/css/examples.css"
 d registerResource^%zewdCustomTags("css",src,"",app,,1)
 s src="examples/calendar/src/Ewd.js"
 d registerResource^%zewdCustomTags("js",src,"",app,,1)
 s ^zewd("loader",applc,"configs","enabled")="true"
 s ^zewd("loader",applc,"configs","paths","Ext.calendar")="examples/calendar/src"
 s ^zewd("loader",applc,"requires",1)="Ext.calendar.CalendarPanel"
 s ^zewd("loader",applc,"requires",2)="Ext.calendar.data.Calendars"
 s ^zewd("loader",applc,"requires",3)="Ext.calendar.util.Date"
 QUIT
 ;
expandCalendar(nodeOID)
 ;
 n applc,attr,mainAttrs,src,targetId,text,xOID
 ;
 s applc=$$zcvt^%zewdAPI(app,"l")
 s src="examples/calendar/resources/css/calendar.css"
 d registerResource^%zewdCustomTags("css",src,"",app,,1)
 s src="examples/calendar/resources/css/examples.css"
 d registerResource^%zewdCustomTags("css",src,"",app,,1)
 s ^zewd("loader",applc,"configs","enabled")="true"
 s ^zewd("loader",applc,"configs","paths","Ext.calendar")="examples/calendar/src"
 s ^zewd("loader",applc,"requires",1)="Ext.calendar.AppFrag"
 ;
 s xOID=$$getTagByNameAndAttr^%zewdDOM("ext4:js","at","top",1,docName)
 d getAttributes^%zewdExt4(nodeOID,.mainAttrs)
 s targetId=$g(mainAttrs("targetid"))
 i targetId="" s targetId="undefinedTargetId"
 ;
 ;s text="EWD.calendar.load("""_targetId_""");"
 s text="EWD.calendar.targetId = '"_targetId_"';"_$c(13,10)_"EWD.calendar.load();"
 i xOID="" d
 . s attr("at")="top"
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:js",nodeOID,,.attr,text)
 e  d
 . n textOID
 . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,xOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
requires(docName)
 ;
 n attrName,attrs,childNo,childOID,component,lcApp,module,OIDArray,path,rOID,rsOID,tagName
 ;
 s lcApp=$$zcvt^%zewdAPI(appName,"L")
 k ^zewd("requires",lcApp)
 s rsOID=$$getTagOID^%zewdDOM("ext4:requires",docName)
 i rsOID'="" d
 . d getChildrenInOrder^%zewdDOM(rsOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName'="ext4:require" q
 . . d getAttributeValues^%zewdDOM(childOID,.attrs)
 . . s module=$g(attrs("modulename"))
 . . s path=$g(attrs("path"))
 . . i path="" d
 . . . s path=$g(attrs("cachepath"))
 . . . i technology="gtm" s path=$g(attrs("gtmpath"))
 . . s component=$g(attrs("component"))
 . . i component'="" d
 . . . ;^zewd("loader","scheduling","requires",1)="Ext.calendar.AppFrag"
 . . . ;^zewd("loader","scheduling","configs","enabled")="true"
 . . . ;^zewd("loader","scheduling","configs","paths","Ext.calendar")="examples/calendar/src"
 . . . n index
 . . . s index=$increment(^zewd("loader",lcApp,"requires"))
 . . . s ^zewd("loader",lcApp,"requires",index)=component
 . . . s ^zewd("loader",lcApp,"configs","enabled")="true"
 . . e  d
 . . . s ^zewd("requires",lcApp,module)=path
 . i $$removeChild^%zewdDOM(rsOID)
 d configs(docName)
 ;
 QUIT
 ;
configs(docName)
 ;
 n attrName,attrs,childNo,childOID,csOID,lcApp,mainAttrs,OIDArray,tagName
 ;
 s lcApp=$$zcvt^%zewdAPI(appName,"L")
 k ^zewd("configs",lcApp)
 s csOID=$$getTagOID^%zewdDOM("ext4:configs",docName)
 i csOID'="" d
 . n enabled
 . d getAttributeValues^%zewdDOM(csOID,.mainAttrs)
 . s enabled=$g(mainAttrs("enabled"))
 . i enabled="" s enabled="false"
 . s ^zewd("loader",lcApp,"configs","enabled")=enabled
 . d getChildrenInOrder^%zewdDOM(csOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName'="ext4:config",tagName'="ext4:require" q
 . . d getAttributeValues^%zewdDOM(childOID,.attrs)
 . . i tagName="ext4:config" d
 . . . n name,path
 . . . s name=$g(attrs("name"))
 . . . s path=$g(attrs("path"))
 . . . i name'="" s ^zewd("loader",lcApp,"configs","paths",name)=path
 . . i tagName="ext4:require" d
 . . . n component
 . . . s component=$g(attrs("component"))
 . . . i component'="" d
 . . . . ;^zewd("loader","scheduling","requires",1)="Ext.calendar.AppFrag"
 . . . . n index
 . . . . s index=$increment(^zewd("loader",lcApp,"requires"))
 . . . . s ^zewd("loader",lcApp,"requires",index)=component
 . i $$removeChild^%zewdDOM(csOID)
 ;
 QUIT
