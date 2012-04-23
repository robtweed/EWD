%zewdExtJS	; Ext-JS tag processors
 ;
 ; Product: Enterprise Web Developer (Build 908)
 ; Build Date: Mon, 23 Apr 2012 11:56:20
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
quickTips(nodeOID,attrValues,docOID,technology)
	i $$updateExtJS^%zewdExtJS("Ext.QuickTips.init();",,,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
modalWindow(nodeOID,attrValues,docOID,technology)
	;
	; <ext:modalWindow triggerTag="modal1" title="Modal Window Demo" 
	;  height="400" width="600" src="modalWindowContent.ewd" />
	; 
	n attr,attrs,eh,id,jsText,nvp,obj,on,tagId,tagOID,widgetAttribs,win,xOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	;
	s nvp=$g(attrs("nvp"))
	s id=$g(attrs("id"))
	i id="" s attrs("id")="modalWindow"_$$uniqueId^%zewdAPI(nodeOID,filename)
	s attrs("modal")="true"
	s attrs("closable")="false"
	d getAttribs^%zewdExtJS("Window",.widgetAttribs)
	d setAttribs^%zewdExtJS(.win,.widgetAttribs,.attrs)
	s win("currentPageName")=$p(filename,".ewd",1)
	s obj=$$convertToJSON^%zewdAPI("win",1)
	s jsText="EWD.ext.openWindow("_obj_","""_$p($g(attrs("src")),".ewd",1)_""",'',"_nvp_");"
	s tagId=$g(attrs("triggertag"))
	s tagOID=$$getElementById^%zewdDOM(tagId,docOID)
	s eh=$g(attrs("eventhandler"))
	i eh="" s eh="onclick"
	s eh=$$zcvt^%zewdAPI(eh,"l")
	s on=$$getAttribute^%zewdDOM(eh,tagOID)
	s on=jsText_on
	d setAttribute^%zewdDOM(eh,on,tagOID)
	s attr("name")=$p($g(attrs("src")),".ewd",1)
	s xOID=$$addElementToDOM^%zewdDOM("ext:allowchildwindow",nodeOID,,.attr)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	;s io=$io
	;f fileName="zextDesktopWindowLoader" d
	;. break  s filePath=inputPath_fileName_".ewd"
	;. i '$$openNewFile^%zewdCompiler(filePath) QUIT
	;. u filePath
	;. f lineNo=1:1 s x="s line=$t("_fileName_"+lineNo^%zewdExtJSCode)" x x q:line["***END***"  d
	;. . w $p(line,";;",2,1000),!
	;. c filePath
	;. u io
	;. s files(fileName_".ewd")="" break
	;
	QUIT
	;
desktopWindow(nodeOID,attrValues,docOID,technology)
	;
	; <ext:desktopWindow triggerTag="ws1" eventHandler="onclick"
	;  title="M/Gateway Web Server Activity" width="860" height="420" 
	;  src="wsChart1" />
	; 
	n attr,attrs,eh,jsText,on,tagId,tagOID,xOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	;
	s jsText="EWD.ext.openDesktopWindow("
	s jsText=jsText_""""_$g(attrs("title"))_""","
	s jsText=jsText_""""_$p($g(attrs("src")),".ewd",1)_""","
	s jsText=jsText_$g(attrs("width"))_","
	s jsText=jsText_$g(attrs("height"))_","""","""","
	s jsText=jsText_""""_$p(filename,".ewd",1)_""");"
	;	
	s tagId=$g(attrs("triggertag"))
	s tagOID=$$getElementById^%zewdDOM(tagId,docOID)
	s eh=$g(attrs("eventhandler"))
	i eh="" s eh="onclick"
	s eh=$$zcvt^%zewdAPI(eh,"l")
	s on=$$getAttribute^%zewdDOM(eh,tagOID)
	s on=jsText_on
	d setAttribute^%zewdDOM(eh,on,tagOID)
	s attr("name")=$p($g(attrs("src")),".ewd",1)
	s xOID=$$addElementToDOM^%zewdDOM("ext:allowchildwindow",nodeOID,,.attr)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT
	;
subPanelLayout(nodeOID,attrValues,docOID,technology)
	;
	; <ext:subPanelLayout parentPanelId="centerPanel">
	; 
	n attrs,jsText,no,panelRefs,ref,textOID
	;
	d getSubPanels(nodeOID,.panelRefs,docOID)
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	s jsText="var parentPanel = Ext.getCmp('"_$g(attrs("parentpanelid"))_"');"_$c(13,10)
	s no=""
	f  s no=$o(panelRefs(no)) q:no=""  d
	. s ref=panelRefs(no)
	. s jsText=jsText_"parentPanel.add("_ref_");"_$c(13,10)
	s jsText=jsText_"parentPanel.doLayout();"
	s textOID=$$updateExtJS^%zewdExtJS(,jsText,,docOID)
	;
	d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT
	;
getSubPanels(nodeOID,panelRefs,docOID)
	;
	n childNo,childOID,OIDArray,panelRef,tagName,widgetAttribs
	;
	i $$hasChildNodes^%zewdDOM(nodeOID)'="true" QUIT
	d getAttribs^%zewdExtJS("Panel",.widgetAttribs)
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo=""
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ext:panel" q
	. s panelRef="panel"_$p(childOID,"-",2)
	. s panelRefs(childNo)=panelRef
	. d subPanel(childOID,panelRef,.widgetAttribs,docOID)
	QUIT
	;
subPanel(nodeOID,panelRef,widgetAttribs,docOID)
	;
	n attr,mainAttrs,objectList,panel,panelObject,textOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	i $g(mainAttrs("layout"))="" s mainAttrs("layout")="card"
	s mainAttrs("contentel")=$g(mainAttrs("id"))_"Div"
	s panelObject="new Ext.Panel>panel"
	d setAttribs^%zewdExtJS(.panel,.widgetAttribs,.mainAttrs)
	s objectList(1)="var^panelObject^"_panelRef
	s textOID=$$updateExtJS^%zewdExtJS("",,.objectList,docOID)
	s attr("id")=mainAttrs("contentel")
	s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
widget(nodeOID,docOID)
	;
	n childNo,configOptions,extClass,files,items,ivalue,mainAttrs
	n object,objectList,objName,parent,ref,textOID,type,var,widgetAttribs
	n widgetName,x
	;
	s widgetName=$$getWidgetName(tagName)
	i widgetName="accordionpanel" d
	. n tagName
	. s nodeOID=$$accordionpanel(nodeOID,docOID)
	. s tagName=$$getTagName^%zewdDOM(nodeOID)
	. s widgetName=$$getWidgetName(tagName)
	i widgetName="panel" d panelProcess(nodeOID,docOID)
	i widgetName="menu" d menuProcess(nodeOID,docOID)
	i widgetName="statusbar" d statusBarProcess(nodeOID,docOID)
	i widgetName="itemselector" d itemSelectorProcess(nodeOID,docOID)
	i widgetName="toolbarbutton"!(widgetName="button") d toolbarButtonProcess(nodeOID,docOID)
	i widgetName="menuitem" d menuItemProcess(nodeOID,docOID)
	i widgetName="modalwindow" d modalWindowProcess(nodeOID,docOID)
	i widgetName="checkitem" d checkItemProcess(nodeOID,docOID)
	;i widgetName="modalwindow" d modalWindowProcess(nodeOID,docOID)
	i widgetName="gridvalue" s nodeOID=$$gridValue(nodeOID,docOID),widgetName="gridcolumn"
	i widgetName="gridcolumn" d gridColumnProcess(nodeOID,docOID)
	i widgetName="grid" s nodeOID=$$grid(nodeOID,docOID),widgetName="gridpanel"
	i widgetName="editorgridpanel" s nodeOID=$$grid(nodeOID,docOID)
	i widgetName="gridrowexpandermarkup" s nodeOID=$$gridRowExpanderMarkup(nodeOID,docOID),widgetName="gridrowexpander"
	d getChildWidgets(nodeOID,docOID,.items)
	i widgetName="handler" QUIT $$handler(nodeOID)
	i widgetName="listener"!(widgetName="renderer") QUIT $$listener(nodeOID)
	i widgetName="listeners" QUIT $$listeners(nodeOID,.items)
	i widgetName="template" QUIT $$template(nodeOID)
	s x="s extClass=$t("_widgetName_"^%zewdExtJSData2)" x x
	i extClass="" d  i extClass="" QUIT ""
	. s x="s extClass=$t("_widgetName_"^%zewdExtJSData3)" x x
	s extClass=$p(extClass,";;",2)
	;s x="s extClass=$p($t("_widgetName_"^%zewdExtJSData2),"";;"",2)"
	;x x
	s extClass=$$stripSpaces^%zewdAPI(extClass)
	d getAttribs(widgetName,.widgetAttribs)
    d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	i extClass["%" d
	. n attrName
	. s attrName=$p(extClass,"%",2)
	. s $p(extClass,"%",2)=$g(mainAttrs(attrName))
	. s extClass=$tr(extClass,"%","")
	i $g(mainAttrs("id"))="" s mainAttrs("id")=widgetName_$$uniqueId^%zewdAPI(nodeOID,filename)
	;
	i $g(mainAttrs("autorender"))="true" d
	. n attr,divOID
	. s attr("id")=mainAttrs("id")_"Div"
	. s mainAttrs("renderto")=attr("id")
	. i widgetName="gridpanel"!(widgetName="editorgridpanel") d
	. . i $g(mainAttrs("width"))>0 d
	. . . s attr("style")="text-align:left;width:"_mainAttrs("width")_"px"
	. . . s mainAttrs("width")="auto"
	. s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	;
	s objName=$g(mainAttrs("object")),var=""
	i objName="" s objName="extObj"_$$uniqueId^%zewdAPI(nodeOID,filename),var="var"
	s object=extClass_">configOptions"
	d setAttribs^%zewdExtJS(.configOptions,.widgetAttribs,.mainAttrs)
	;
	s childNo=""
	f  s childNo=$o(items(childNo)) q:childNo=""  d
	. s ivalue=items(childNo)
	. s ref=$p(ivalue,"~",1)
	. s parent=$p(ivalue,"~",2)
	. s type=$p($g(widgetAttribs(parent)),":",2)
	. i type="object"!(type["function") d
	. . s configOptions($p(widgetAttribs(parent),":",1))=ref
	. . i parent="listeners" d
	. . . n name,value
	. . . s name=""
	. . . f  s name=$o(configOptions(name)) q:name=""  d
	. . . . s value=$g(configOptions(name))
	. . . . i value["listeners:listenerObject" d
	. . . . . s configOptions(name)=$$replace^%zewdAPI(value,"listeners:listenerObject","listeners:"_ref)
	. e  d
	. . n opt
	. . i '$d(widgetAttribs(parent)) d
	. . . s opt=parent
	. . e  d
	. . . s opt=$p(widgetAttribs(parent),":",1)
	. . s configOptions(opt,childNo)=ref
	i widgetName="dataarrayreader" QUIT $$dataArrayReader(nodeOID,objName,object,.configOptions)
	i widgetName="gridcolumnmodel" QUIT $$gridColumnModel(nodeOID,objName,object,.configOptions)
	i widgetName="combobox" d comboboxStore(.configOptions)
	s objectList(1)=var_"^object^"_objName
	i extClass="" s objectList(1)=var_"^configOptions^"_objName
	s textOID=$$updateExtJS^%zewdExtJS("",,.objectList,docOID)
	i widgetName="datastore" d dataStore(nodeOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	i widgetName="button",$g(mainAttrs("isformfield"))'="true" QUIT objName_"~buttons"
	i widgetName="modalwindow" d
	. n src
	. s src=$p($g(mainAttrs("src")),".ewd",1)
	. s objName="function () {EWD.ext.openWindow("_objName_",'"_src_"',0)}"
	i $g(mainAttrs("parentattribute"))'="" s objName=objName_"~"_$$zcvt^%zewdAPI(mainAttrs("parentattribute"),"l")
	QUIT objName
	;
getChildWidgets(nodeOID,docOID,childObjects)
	;
	n childNo,childOID,objName,objRef,OIDArray,parentAttribute,tagName
	;
	i $$hasChildNodes^%zewdDOM(nodeOID)'="true" QUIT
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo=""
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'["ext:" q
	. s objName=$$widget(childOID,docOID)
	. q:objName=""
	. i objName["formSubmitlogin" q
	. s objRef="<?= "_$p(objName,"~",1)_" ?>"
	. i $p(objName,"~",2)'="" d
	. . s objRef=objRef_"~"_$p(objName,"~",2)
	. e  d
	. . s objRef=objRef_"~items"
	. s childObjects(childNo)=objRef
	QUIT
	;
comboboxStore(configOptions)
	;
	n store,store1
	;
	s store=$g(configOptions("store"))
	i store'="" d
	. s store1="new Ext.data.SimpleStore({"
	. s store1=store1_"fields:['code', 'text'],"
	. s store1=store1_"data: "_store
	. s store1=store1_"})"
	. s configOptions("store")=store1
	. i '$d(configOptions("displayField")) s configOptions("displayField")="text"
	. i '$d(configOptions("valueField")) s configOptions("valueField")="code"
	. i $d(configOptions("hiddenName")),'$d(configOptions("hiddenId")) s configOptions("hiddenId")="extCB"_$$uniqueId^%zewdAPI(nodeOID,filename)
	. i store["&php;" d
	. . n no
	. . s no=$p(store,"&php;",2)
	. . s no=$p(no,"&php;",1)
	. . s phpVars(no,"esc")=0 ; make sure it doesn't get output escaped
	QUIT
	;
getWidgetName(tagName)
	;
	n name
	;
	s name=$p(tagName,"ext:",2)
	s name=$$zcvt^%zewdAPI(name,"l")
	QUIT name
	;
getAttribs(widgetName,widgetAttribs)
 ;
 n line,lineNo,version,x
 ;
 s version=2
 s x="s line=$t("_widgetName_"^%zewdExtJSData2)" x x
 i line="" s version=3
 s x="f lineNo=1:1 s line=$t("_widgetName_"+lineNo^%zewdExtJSData"_version_") q:line[""***END***""  d addAttrib^%zewdExtJS("""_widgetName_""",line,.widgetAttribs)"
 x x
 QUIT
 ;
dataStore(nodeOID)
	;
	n attr,mjsOID
	;
	s attr("method")="writeObjectAsJSON^%zewdCompiler19"
	s attr("param1")=$g(mainAttrs("data"))
	s attr("param2")=1
	i $g(mainAttrs("addrefcol"))="false" s attr("param2")=0
	s attr("param3")=1
	i isAjax s attr("param3")=0
	s attr("param4")="#ewd_sessid"
	s attr("type")="procedure"
	;
	s mjsOID=$$getElementById^%zewdDOM("moveToJS",docOID)
	i mjsOID'="" d  QUIT
	. n xOID
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",mjsOID,,.attr)
	i isAjax d
	. n attrx,xOID
	. s attrx("id")="moveToJS"
	. s mjsOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attrx)
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",mjsOID,,.attr)
	e  d
	. n jsArray,jsOID,tempOID,xOID
	. s jsOID=$$getElementById^%zewdDOM("extjs",docOID)
	. i jsOID="" d
	. . s jsOID=$$getTagOID^%zewdAPI("script",docName)
	. . i jsOID="" s jsOID=$$addJavascriptFunction^%zewdAPI(docName,.jsArray)
	. s tempOID=$$createElement^%zewdDOM("temp",docOID)
	. s tempOID=$$insertBefore^%zewdDOM(tempOID,jsOID)
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",tempOID,,.attr)
	. d removeIntermediateNode^%zewdDOM(tempOID)
	;
 QUIT
 ;
gridCheckColumn(nodeOID,colName,docOID)
 ;
 n disabled,gcOID,header,objName,parentOID,preText,stop,width
 ;
 s gcOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ext:gridcheckcolumn",docOID)
 s header=$$getAttribute^%zewdDOM("header",nodeOID)
 s width=$$getAttribute^%zewdDOM("width",nodeOID)
 s disabled=$$getAttribute^%zewdDOM("menudisabled",nodeOID)
 d setAttribute^%zewdDOM("header",header,gcOID)
 d setAttribute^%zewdDOM("dataindex",colName,gcOID)
 d setAttribute^%zewdDOM("width",width,gcOID)
 i disabled'="" d setAttribute^%zewdDOM("menudisabled",disabled,gcOID)
 ;
 s stop=0,parentOID=nodeOID
 f  d  q:stop
 . s parentOID=$$getParentNode^%zewdDOM(parentOID)
 . i $$getTagName^%zewdDOM(parentOID)="ext:editorgridpanel" s stop=1
 . i $$getTagName^%zewdDOM(parentOID)="ext:grid" s stop=1
 i stop d
 . n plugins
 . s objName="gridcheckcol"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s plugins=$$getAttribute^%zewdDOM("plugins",parentOID)
 . i $e(plugins,1)="[" s plugins=$e(plugins,2,$l(plugins)-1)
 . i plugins'="" s plugins=plugins_","
 . s plugins="["_plugins_objName_"]"
 . d setAttribute^%zewdDOM("plugins",plugins,parentOID)
 . d setAttribute^%zewdDOM("object",objName,gcOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT gcOID
 ;
gridValue(nodeOID,docOID)
 ;
 n gcOID,name
 ;
 s gcOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ext:gridcolumn",docOID)
 s name=$$getAttribute^%zewdDOM("name",nodeOID)
 d setAttribute^%zewdDOM("object",name,gcOID)
 d setAttribute^%zewdDOM("hidden","true",gcOID)
 d setAttribute^%zewdDOM("hideable","true",gcOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT gcOID
 ;
outputSubTree(fromNodeOID)
 QUIT $$outputNode(fromNodeOID,"")
 ;
outputNode(nodeOID,text)
 ;
 n childNo,childOID,etext,nodeName,nodeType,OIDArray,textarr
 ;
 s nodeType=$$getNodeType^%zewdDOM(nodeOID)
 s nodeName=$$getNodeName^%zewdDOM(nodeOID)
 i nodeType=1 d
 . s text=text_"&lt;"_nodeName
 . i $$hasAttributes^%zewdDOM(nodeOID)="true" s text=text_$$outputAttr(nodeOID,text)
 . s text=text_"&gt;"
 . d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s text=$$outputNode(childOID,text)
 . s text=text_"&lt;/"_nodeName_"&gt;"
 i nodeType=3 s text=text_$$getData^%zewdDOM(nodeOID)
 ;
 QUIT text
 ;
outputAttr(nodeOID,text)
 ;
 n attr,attrName,ok,value
 ;
 s ok=$$getAttributeArray^%zewdDOM(nodeOID,.attr)
 s attrName=""
 f  s attrName=$o(attr(attrName)) q:attrName=""  d
 . s value=$$getAttribute^%zewdDOM(attrName,nodeOID)
 . s text=text_" "_attrName_"='"_value_"'"
 QUIT text
 ;
gridRowExpanderMarkup(nodeOID,docOID)
 ;
 n attr,fcOID,greOID,objName,parentOID,stop,text,textarr,tOID,xOID
 ;
 s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
 s text=$$outputSubTree(fcOID)
 s xOID=$$removeChild^%zewdDOM(fcOID)
 s greOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ext:gridrowexpander",docOID)
 s stop=0,parentOID=nodeOID
 f  d  q:stop
 . s parentOID=$$getParentNode^%zewdDOM(parentOID)
 . i $$getTagName^%zewdDOM(parentOID)="ext:gridpanel" s stop=1
 i stop d
 . s objName="exp"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . d setAttribute^%zewdDOM("plugins",objName,parentOID)
 . d setAttribute^%zewdDOM("object",objName,greOID)
 . s attr("parentattribute")="tpl"
 . s tOID=$$addElementToDOM^%zewdDOM("ext:template",greOID,,.attr,text)
 . d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT greOID
 ;
itemSelectorProcess(nodeOID,docOID)
 ;
 n attr,attrs,darOID,darrOID,dsOID,fromStore,toStore
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
 s fromStore=$g(attrs("fromstore"))
 i fromStore'="" d
 . i $e(fromStore,1)="#" s fromStore=$e(fromStore,2,$l(fromStore))
 . s attr("data")=fromStore
 . s attr("parentattribute")="fromstore"
 . s attr("addrefcol")="false"
 . s dsOID=$$addElementToDOM^%zewdDOM("ext:datastore",nodeOID,,.attr)
 . s attr("parentattribute")="reader"
 . s darOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreader",dsOID,,.attr)
 . s attr("name")="code"
 . s darrOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreaderrecord",darOID,,.attr)
 . s attr("name")="desc"
 . s darrOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreaderrecord",darOID,,.attr)
 . ;
 s toStore=$g(attrs("tostore"))
 i toStore'="" d
 . i $e(toStore,1)="#" s toStore=$e(toStore,2,$l(toStore))
 . s attr("data")=toStore
 . s attr("parentattribute")="tostore"
 . s attr("addrefcol")="false"
 . s dsOID=$$addElementToDOM^%zewdDOM("ext:datastore",nodeOID,,.attr)
 . s attr("parentattribute")="reader"
 . s darOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreader",dsOID,,.attr)
 . s attr("name")="code"
 . s darrOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreaderrecord",darOID,,.attr)
 . s attr("name")="desc"
 . s darrOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreaderrecord",darOID,,.attr)
 . ;
 i $g(attrs("datafields"))="" d setAttribute^%zewdDOM("datafields","['code','desc']",nodeOID)
 i $g(attrs("displayfield"))="" d setAttribute^%zewdDOM("displayfield","desc",nodeOID)
 i $g(attrs("valuefield"))="" d setAttribute^%zewdDOM("valuefield","code",nodeOID)
 i toStore="",$g(attrs("todata"))="" d setAttribute^%zewdDOM("todata","[]",nodeOID)
 QUIT
 ;
grid(nodeOID,docOID)
 ;
 n attr,childNo,childOID,colName,darOID,darrOID,dateFormat,dsOID,editAs,fieldType,gcOID
 n gcmOID,gpOID,gridAttrs,gvcOID,name,OIDArray,renderAs,tagName,type
 ;
 s gcmOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ext:gridcolumnmodel",docOID)
 d setAttribute^%zewdDOM("parentattribute","columns",gcmOID)
 d getAttributeValues^%zewdCustomTags(nodeOID,.gridAttrs)
 s attr("data")=$g(gridAttrs("datastore"))
 s attr("parentattribute")="store"
 s dsOID=$$addElementToDOM^%zewdDOM("ext:datastore",nodeOID,,.attr)
 s attr("parentattribute")="reader"
 s darOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreader",dsOID,,.attr)
 s gvcOID=$$addElementToDOM^%zewdDOM("ext:gridviewconfig",nodeOID,,.attr)
 d setAttribute^%zewdDOM("autofill","true",gvcOID)
 d setAttribute^%zewdDOM("parentattribute","viewconfig",gvcOID)
 i $g(gridAttrs("allowforscrollbar"))="false" d setAttribute^%zewdDOM("scrolloffset","0",gvcOID)
 s attr("hidden")="true"
 s attr("hideable")="false"
 s gcOID=$$addElementToDOM^%zewdDOM("ext:gridcolumn",gcmOID,,.attr,,1)
 i widgetName="editorgridpanel",$g(gridAttrs("validationscript"))'="" d
 . n attr,id,line,lineNo,lOID,lsOID,preText,script,text,textOID
 . s preText=""
 . f lineNo=1:1 s line=$t(updateSession+lineNo^%zewdExtJSCode) q:line["***END***"  d
 . . s preText=preText_$p(line,";;",2,200)_$c(13,10)
 . s textOID=$$updateExtJS^%zewdExtJS(,,,docOID,preText)
 . s id=$g(gridAttrs("id"))
 . i id="" s id=widgetName_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s preText="EWD.ext.storeName['"_id_"']="""_$g(gridAttrs("datastore"))_""";"_$c(13,10)
 . s textOID=$$updateExtJS^%zewdExtJS(,,,docOID,preText)
 . ;
 . s attr("parentattribute")="listeners"
 . s lsOID=$$addListenersTag(nodeOID)
 . ;s lsOID=$$addElementToDOM^%zewdDOM("ext:listeners",nodeOID,,.attr)
 . s attr("name")="validateedit"
 . s attr("param1")="e"
 . s text="e.cancel=!EWD.ext.validateGridEdit('"_$g(gridAttrs("datastore"))_"',e,true);"
 . s lOID=$$addElementToDOM^%zewdDOM("ext:listener",lsOID,,.attr,text)
 . ;
 . s script=gridAttrs("validationscript")
 . i technology="php" d
 . . s lineno=$o(phpHeaderArray(1,""),-1)+1
 . . s phpHeaderArray(1,lineno)="   $ewd_session[""ext_GridEditFunc""]["""_$g(gridAttrs("datastore"))_"""] = '"_script_"' ;"
 . i technology="wl"!(technology="gtm")!(technology="ewd") d
 . . s lineno=$o(phpHeaderArray(1,""),-1)+1
 . . s phpHeaderArray(1,lineno)=" s sessionArray(""ext_GridEditFunc"","""_$g(gridAttrs("datastore"))_""")="""_script_""""
 . i technology="csp" d
 . . s lineno=$o(phpHeaderArray(1,""),-1)+1
 . . s phpHeaderArray(1,lineno)=" s extGridEditFunc("""_$g(gridAttrs("datastore"))_""")="""_script_""""
 ;
 i $g(gridAttrs("onrowselect"))'="" d
 . n attr,listenersOID,lOID,sm,text,useArrows
 . s useArrows=0
 . i $g(gridAttrs("rowselectionmethod"))="arrowKeys" s useArrows=1
 . s listenersOID=$$addListenersTag(nodeOID)
 . s attr("name")="rowclick"
 . i useArrows s attr("name")="rowselect"
 . s attr("param1")="grid"
 . s attr("param2")="rowClicked"
 . s attr("param3")="e" 
 . s sm=".getSelectionModel()"
 . i useArrows s sm=""
 . s text="var selectionModel=grid"_sm_";var record = selectionModel.getSelected();var currentRow=EWD.ext.getSelectedGridRecord(record);"_gridAttrs("onrowselect")_"(currentRow,rowClicked);"
 . s lOID=$$addElementToDOM^%zewdDOM("ext:listener",listenersOID,,.attr,text)
 . i useArrows d
 . . s sm="new Ext.grid.RowSelectionModel({singleSelect:true,listeners:listenerObject})"
 . . s gridAttrs("sm")=sm
 . . k gridAttrs("rowselectionmethod")
 ;
 d getChildrenInOrder^%zewdDOM(gcmOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="ext:gridcolumn",tagName'="ext:gridvalue" q
 . i tagName="ext:gridvalue" s childOID=$$gridValue(childOID,docOID)
 . s type=$$zcvt^%zewdAPI($$getAttribute^%zewdDOM("datatype",childOID),"l")
 . s editAs=$$zcvt^%zewdAPI($$getAttribute^%zewdDOM("editas",childOID),"l")
 . s renderAs=$$zcvt^%zewdAPI($$getAttribute^%zewdDOM("renderas",childOID),"l")
 . s colName=$$getAttribute^%zewdDOM("object",childOID)
 . i colName="" s colName="col"_widgetName_$$uniqueId^%zewdAPI(childOID,filename)
 . i type="checkbox"!(editAs="checkbox")!(renderAs="checkbox") d
 . . s childOID=$$gridCheckColumn(childOID,colName,docOID)
 . e  d
 . . d setAttribute^%zewdDOM("dataindex",colName,childOID)
 . . s dateFormat=$$getAttribute^%zewdDOM("dateformat",childOID)
 . . i dateFormat="" s dateFormat="d/m/y"
 . . i type="date"!(editAs="date") d
 . . . d setAttribute^%zewdDOM("renderer","Ext.util.Format.dateRenderer('"_dateFormat_"')",childOID)
 . s fieldType=$$getAttribute^%zewdDOM("type",childOID)
 . i $$zcvt^%zewdAPI(fieldType,"l")="numberfield" d
 . . n allowDec
 . . s allowDec=$$getAttribute^%zewdDOM("allowdecimals",childOID)
 . . i allowDec="true",type="" s type="float"
 . . i allowDec="false",type="" s type="int"
 . i $$zcvt^%zewdAPI(fieldType,"l")="datefield"!(editAs="date") d
 . . s type="date"
 . . s attr("dateformat")=dateFormat
 . s attr("name")=colName
 . i type="float"!(type="bool")!(type="date") s attr("type")=type
 . s darrOID=$$addElementToDOM^%zewdDOM("ext:dataarrayreaderrecord",darOID,,.attr)
 . s editAs=$$getAttribute^%zewdDOM("editas",childOID)
 . i editAs="select" d setAttribute^%zewdDOM("type","combobox",childOID)
 . i editAs="number" d setAttribute^%zewdDOM("type","numberfield",childOID)
 . i editAs="text" d setAttribute^%zewdDOM("type","textfield",childOID)
 . i editAs="date" d setAttribute^%zewdDOM("type","datefield",childOID)
 . i editAs="textarea" d setAttribute^%zewdDOM("type","textarea",childOID)
 . i widgetName="editorgridpanel",childNo>1,$g(gridAttrs("validationscript"))'="" d
 . . n preText,textOID
 . . s preText="EWD.ext.columnIndex["""_colName_"""] = "_(childNo-1)_" ;"_$c(13,10)
 . . s textOID=$$updateExtJS^%zewdExtJS(,,,docOID,preText)
 ;
 i widgetName="editorgridpanel" QUIT nodeOID
 s gpOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ext:gridpanel",docOID)
 k gridAttrs("allowforscrollbar")
 s name=""
 f  s name=$o(gridAttrs(name)) q:name=""  d
 . d setAttribute^%zewdDOM(name,gridAttrs(name),gpOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT gpOID
 ;
addListenersTag(nodeOID)
 ;
 n attr,listenersOID
 ;
 s listenersOID=$$getListenersTag(nodeOID)
 i listenersOID="" d
 . s attr("parentattribute")="listeners"
 . s listenersOID=$$addElementToDOM^%zewdDOM("ext:listeners",nodeOID,,.attr)
 QUIT listenersOID
 ;
getListenersTag(nodeOID)
 ;
 n childNo,childOID,OIDArray,stop,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="ext:listeners" s stop=1
 i stop QUIT childOID
 QUIT ""
 ;
accordionpanel(nodeOID,docOID)
 ;
 n mainAttrs,attr,name
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d getAttribs("layoutconfig",.layoutAttrs)
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i $d(layoutAttrs(name)) d
 . . s attr(name)=mainAttrs(name)
 . . k mainAttrs(name)
 . . d removeAttribute^%zewdDOM(name,nodeOID)
 i $d(attr) d
 . s attr("parentattribute")="layoutconfig"
 . s lOID=$$addElementToDOM^%zewdDOM("ext:layoutconfig",nodeOID,,.attr,,1)
 s panelOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ext:panel",docOID)
 d setAttribute^%zewdDOM("layout","accordion",panelOID)
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . d setAttribute^%zewdDOM(name,mainAttrs(name),panelOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT panelOID
 ;
modalWindowProcessz(nodeOID,docOID)
 ;
 n mainAttrs,parentOID,tagName
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 s tagName=$$getTagName^%zewdDOM(parentOID)
 i tagName="ext:button" d 
 . n attr,xOID
 . d setAttribute^%zewdDOM("modal","true",nodeOID)
 . d setAttribute^%zewdDOM("closable","false",nodeOID)
 . d setAttribute^%zewdDOM("currentpagename",$p(filename,".ewd",1),nodeOID)
 . d setAttribute^%zewdDOM("parentattribute","handler",nodeOID)
 . s xOID=$$createElement^%zewdDOM("ext:allowchildwindow",docOID)
 . s xOID=$$insertBefore^%zewdDOM(xOID,parentOID)
 . d setAttribute^%zewdDOM("name",$p($g(mainAttrs("src")),".ewd",1),xOID)
 ;
 QUIT
 ;
statusBarProcess(nodeOID,docOID)
 ;
 n mainAttrs
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("parentattribute"))="" d setAttribute^%zewdDOM("parentattribute","bbar",nodeOID)
 ;
 QUIT
 ;
gridColumnProcess(nodeOID,docOID)
 ;
 n attr,buttonText,mainAttrs,onclick,rOID,text,type
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s type=$$zcvt^%zewdAPI($g(mainAttrs("type")),"l")
 i type="combobox" d
 . n cbOID,editable,lOID,lsOID,name,parentOID,stop,text
 . s name=$g(mainAttrs("name")) i name="" s name="dummy"
 . s editable=$g(mainAttrs("editable")) i editable="" s editable="false"
 . s attr("parentattribute")="editor"
 . s attr("editable")="false"
 . s attr("hidetrigger")="false"
 . s attr("forceselection")="true"
 . s attr("lazyrender")="true"
 . s attr("listclass")="x-combo-list-small"
 . s attr("triggeraction")="all"
 . s attr("lazyinit")="false"
 . s attr("transform")=name
 . s cbOID=$$addElementToDOM^%zewdDOM("ext:combobox",nodeOID,,.attr)
 . s lsOID=$$addListenersTag(cbOID)
 . s attr("name")="focus"
 . s attr("param1")="obj"
 . s text="obj.expand();"
 . s lOID=$$addElementToDOM^%zewdDOM("ext:listener",lsOID,,.attr,text)
 . s stop=0
 . s parentOID=nodeOID
 . f  d  q:stop
 . . s parentOID=$$getParentNode^%zewdDOM(parentOID)
 . . i $$getTagName^%zewdDOM(parentOID)'["ext:" s stop=1
 . i stop d
 . . n sOID
 . . s attr("name")=name
 . . s attr("style")="display:none"
 . . s sOID=$$addElementToDOM^%zewdDOM("select",parentOID,,.attr,,1)
 i type="textfield" d
 . n allowBlank,tOID
 . s allowBlank=$g(mainAttrs("allowblank"))
 . s attr("parentattribute")="editor"
 . i allowBlank'="" s attr("allowblank")=allowBlank
 . d removeAttribute^%zewdDOM("allowblank",nodeOID)
 . s tOID=$$addElementToDOM^%zewdDOM("ext:textfield",nodeOID,,.attr)
 ;
 i type="numberfield" d
 . n allowBlank,allowDecimals,allowNegative,maxValue,minValue,tOID,type
 . s type=$g(mainAttrs("datatype"))
 . s allowBlank=$g(mainAttrs("allowblank"))
 . s allowDecimals=$g(mainAttrs("allowdecimals"))
 . i allowDecimals="true",type="" d setAttribute^%zewdDOM("datatype","float",nodeOID)
 . i allowDecimals="false",type="" d setAttribute^%zewdDOM("datatype","int",nodeOID)
 . i allowDecimals="" d
 . . i type="float" s allowDecimals="true"
 . . i type="int" s allowDecimals="false"
 . s allowNegative=$g(mainAttrs("allownegative"))
 . s maxValue=$g(mainAttrs("maxvalue"))
 . s minValue=$g(mainAttrs("minvalue"))
 . s attr("parentattribute")="editor"
 . i allowBlank'="" s attr("allowblank")=allowBlank
 . i allowDecimals'="" s attr("allowdecimals")=allowDecimals
 . i allowNegative'="" s attr("allownegative")=allowNegative
 . i maxValue'="" s attr("maxvalue")=maxValue
 . i minValue'="" s attr("minvalue")=minValue
 . d removeAttribute^%zewdDOM("allowblank",nodeOID)
 . s tOID=$$addElementToDOM^%zewdDOM("ext:numberfield",nodeOID,,.attr)
 ;
 i type="datefield" d
 . n dateFormat,tOID,type
 . s type=$g(mainAttrs("datatype"))
 . s dateFormat=$g(mainAttrs("dateformat"))
 . i dateFormat="" s dateFormat="d/m/y"
 . s attr("parentattribute")="editor"
 . i dateFormat'="" s attr("format")=dateFormat
 . s tOID=$$addElementToDOM^%zewdDOM("ext:datefield",nodeOID,,.attr)
 ;
 i type="textarea" d
 . n attr,attrName,tOID
 . f attrName="allowblank","grow","growmax","height" d
 . . i $g(mainAttrs(attrName))'="" d
 . . . s attr(attrName)=mainAttrs(attrName)
 . . . d removeAttribute^%zewdDOM(attrName,nodeOID)
 . s attr("parentattribute")="editor"
 . s tOID=$$addElementToDOM^%zewdDOM("ext:textarea",nodeOID,,.attr)
 ;
 i $g(mainAttrs("button"))="true" d
 . s buttonText=$g(mainAttrs("buttontext"))
 . i buttonText="" s buttonText="Click Me"
 . s onclick=$g(mainAttrs("onclick"))
 . d removeAttribute^%zewdDOM("button",nodeOID)
 . d removeAttribute^%zewdDOM("buttontext",nodeOID)
 . d removeAttribute^%zewdDOM("onclick",nodeOID)
 . s attr("parentattribute")="renderer"
 . s attr("param1")="value"
 . s attr("param2")="metaData"
 . s attr("param3")="record"
 . s attr("param4")="rowIndex"
 . s attr("param5")="colIndex"
 . s attr("param6")="store"
 . s text="return '&lt;input type=""button"" value="""_buttonText_""" onClick="""_onclick_"('+rowIndex+')"" &gt;';"
 . s rOID=$$addElementToDOM^%zewdDOM("ext:renderer",nodeOID,,.attr,text)
 QUIT
 ;
menuProcess(nodeOID,docOID)
 ;
 n mainAttrs,parentOID,tagName
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("parentattribute"))="" d
 . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 . s tagName=$$getTagName^%zewdDOM(parentOID)
 . i tagName["ext:" d setAttribute^%zewdDOM("parentattribute","menu",nodeOID)
 ;
 QUIT
 ;
modalWindowProcess(nodeOID,docOID)
 ;
 n acwOID,currentPage,mainAttrs,page,parentOID,src
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("src"))'="" d
 i 'isAjax d
 . n bodyOID
 . s bodyOID=$$getTagOID^%zewdDOM("body",docName)
 . s parentOID=$$addElementToDOM^%zewdDOM("ewd:dummy",bodyOID,,,,1)
 e  d
 . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 s attr("name")=mainAttrs("src")
 s acwOID=$$addElementToDOM^%zewdDOM("ext:allowchildwindow",parentOID,,.attr)
 s page=$$zcvt^%zewdAPI($p(filename,".ewd",1),"l")
 d setAttribute^%zewdDOM("currentpagename",page,nodeOID)
 d setAttribute^%zewdDOM("modal","true",nodeOID)
 i 'isAjax d removeIntermediateNode^%zewdAPI(parentOID)
 ;
 QUIT
 ;
 ;
menuItemProcess(nodeOID,docOID)
 ;
 n attr,hOID,mainAttrs,text
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("onselect"))'="" d
 . s attr("param1")="item"
 . s attr("param2")="e"
 . s text=mainAttrs("onselect")
 . s hOID=$$addElementToDOM^%zewdDOM("ext:handler",nodeOID,,.attr,text)
 ;
 QUIT
 ;
toolbarButtonProcess(nodeOID,docOID)
 ;
 n attr,hOID,mainAttrs,text
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("onclick"))'="" d
 . s attr("param1")="item"
 . s attr("param2")="e"
 . s text=mainAttrs("onclick")
 . s hOID=$$addElementToDOM^%zewdDOM("ext:handler",nodeOID,,.attr,text)
 ;
 QUIT
 ;
checkItemProcess(nodeOID,docOID)
 ;
 n attr,hOID,mainAttrs,text
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("oncheck"))'="" d
 . s attr("param1")="item"
 . s attr("param2")="e"
 . s text=mainAttrs("oncheck")
 . s hOID=$$addElementToDOM^%zewdDOM("ext:handler",nodeOID,,.attr,text)
 ;
 QUIT
 ;
 ;
panelProcess(nodeOID,docOID)
 ;
 n mainAttrs,attr,event,eventType,fragName,lOID,lsOID,text
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 i $g(mainAttrs("id"))="" s mainAttrs("id")=widgetName_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 i $g(mainAttrs("src"))'="" s mainAttrs("fragmentonrender")=mainAttrs("src")
 s event="fragmenton"
 f  s event=$o(mainAttrs(event)) q:event=""  q:event'["fragmenton"  d
 . s fragName=mainAttrs(event)
 . s fragName=$p(fragName,".ewd",1)
 . s eventType=$p(event,"fragmenton",2)
 . i eventType="select" s eventType="activate"
 . s idx=mainAttrs("id")_"Src"
 . s html="<div id='"_idx_"'></div>"
 . d setAttribute^%zewdDOM("html",html,nodeOID)
 . s lsOID=$$addListenersTag(nodeOID)
 . s attr("name")=eventType
 . s attr("param1")="e"
 . s text="ewd.ajaxRequest('"_fragName_"','"_idx_"');"
 . s lOID=$$addElementToDOM^%zewdDOM("ext:listener",lsOID,,.attr,text)
 i $g(mainAttrs("active"))="true" d
 . n tpOID
 . s tpOID=$$getParentNode^%zewdDOM(nodeOID)
 . i $$getTagName^%zewdDOM(tpOID)="ext:tabpanel" d
 . . d setAttribute^%zewdDOM("activeitem",mainAttrs("id"),tpOID)
 i $g(mainAttrs("centered"))="true" d
 . d setAttribute^%zewdDOM("bodycfg","{tag:'center',cls:'x-panel-body'}",nodeOID)
 QUIT
 ;
handler(nodeOID)
	;
	n attr,comma,func,mainAttrs,objName,paramList,parentAttr,parentOID,text,textarr,textOID
	;
	s parentAttr="handler"
	s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	i $$getTagName^%zewdDOM(parentOID)["checkitem" s parentAttr="checkhandler"
    d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
    s paramList="",comma=""
    s attr="param"
    f  s attr=$o(mainAttrs(attr)) q:attr'["param"  d
    . s paramList=paramList_comma_mainAttrs(attr)
    . s comma=","
	s func="function("_paramList_")"
	s text=$$getElementText^%zewdDOM(nodeOID,.textarr)
	s objName="func"_$$uniqueId^%zewdAPI(nodeOID,filename)
	s func="var "_objName_" = "_func_"{"_text_"} ;"
	s textOID=$$updateExtJS^%zewdExtJS(func,,,docOID)
	i $$modifyElementText^%zewdDOM(nodeOID,"")
	d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT objName_"~"_parentAttr
	;
template(nodeOID)
	;
	n objName,text,textarr,textOID
	;
	s text=$$getElementText^%zewdDOM(nodeOID,.textarr)
	s objName="tpl"_$$uniqueId^%zewdAPI(nodeOID,filename)
	s func="var "_objName_" = new Ext.Template("""_text_""");"
	s textOID=$$updateExtJS^%zewdExtJS(func,,,docOID)
	i $$modifyElementText^%zewdDOM(nodeOID,"")
	d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT objName_"~tpl"
	;
listener(nodeOID)
	;
	n attr,comma,func,mainAttrs,objName,paramList,text,textarr,textOID
	;
    d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
    s paramList="",comma=""
    s attr="param"
    f  s attr=$o(mainAttrs(attr)) q:attr'["param"  d
    . s paramList=paramList_comma_mainAttrs(attr)
    . s comma=","
	s func="function("_paramList_")"
	s text=$$getElementText^%zewdDOM(nodeOID,.textarr)
	s objName="func"_$$uniqueId^%zewdAPI(nodeOID,filename)
	s func="var "_objName_" = "_func_"{"_text_"} ;"
	s textOID=$$updateExtJS^%zewdExtJS(func,,,docOID)
	i $$modifyElementText^%zewdDOM(nodeOID,"")
	d removeIntermediateNode^%zewdDOM(nodeOID)
	i widgetName="listener" QUIT $g(mainAttrs("name"))_":"_objName
	i widgetName="renderer" QUIT objName_"~renderer"
	QUIT objName
	;
listeners(nodeOID,items)
	;
	n comma,no,obj,objList 
	;
    s objList="",comma=""
    s no=""
    f  s no=$o(items(no)) q:no=""  d
    . s obj=items(no)
    . s obj=$p(obj,"<?=",2)
    . s obj=$p(obj,"?>",1)
    . s obj=$$stripSpaces^%zewdAPI(obj)
    . s objList=objList_comma_obj
    . s comma=","
	s objName="listener"_$$uniqueId^%zewdAPI(nodeOID,filename)
	s func="var "_objName_" = {"_objList_"} ;"
	s textOID=$$updateExtJS^%zewdExtJS(func,,,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT objName_"~listeners"
	;
dataArrayReader(nodeOID,objName,object,configOptions)
	;
	n comma,func,item,obj
	;
	s func="var "_objName_"="_$p(object,">",1)_"({},["
	s item="",comma=""
	f  s item=$o(configOptions("items",item)) q:item=""  d
	. s obj=configOptions("items",item)
	. s obj=$p(obj,"<?=",2)
    . s obj=$p(obj,"?>",1)
    . s obj=$$stripSpaces^%zewdAPI(obj)
	. s func=func_comma_obj
	. s comma=","
	s func=func_"]);"
	s textOID=$$updateExtJS^%zewdExtJS(func,,,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	i $g(mainAttrs("parentattribute"))'="" s objName=objName_"~"_$$zcvt^%zewdAPI(mainAttrs("parentattribute"),"l")
	QUIT objName
	;
gridColumnModel(nodeOID,objName,object,configOptions)
	;
	n comma,func,item,obj
	;
	s func="var "_objName_"=["
	s item="",comma=""
	f  s item=$o(configOptions("items",item)) q:item=""  d
	. s obj=configOptions("items",item)
	. s obj=$p(obj,"<?=",2)
    . s obj=$p(obj,"?>",1)
    . s obj=$$stripSpaces^%zewdAPI(obj)
	. s func=func_comma_obj
	. s comma=","
	s func=func_"];"
	s textOID=$$updateExtJS^%zewdExtJS(func,,,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	i $g(mainAttrs("parentattribute"))'="" s objName=objName_"~"_$$zcvt^%zewdAPI(mainAttrs("parentattribute"),"l")
	QUIT objName
	;
ewdForm(nodeOID,panelRef,widgetAttribs,docOID)
	;
	n attr,buttonObj,buttons,cbOID,comma,fpOID,formName,formPanelObj
	n hOID,id,n,name,nameList,nodeArray,objName,OIDArray,ok,parentOID,rOID,sbOID,tag,value
	;
	d getDescendantNodes^%zewdDOM(nodeOID,.OIDArray)
	s rOID=""
	f  s rOID=$o(OIDArray(rOID)) q:rOID=""  d
	. s tag=OIDArray(rOID)
	. i tag["ext:" q
	. i tag'="",$g(^%zewd("customTag",tag))'="" d
	. . i $$customTagProc^%zewdCompiler(tag,tag,docName,technology)
	k OIDArray
	;
	; specify the formPanel object
	s nameList=""
	s formName="ewdExtForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
	s ok=$$getElementsByTagName^%zewdDOM("ext:formpanel",nodeOID,.nodeArray)
	s fpOID=$o(nodeArray(""))
	s formPanelObj=""
	i fpOID'="" d
	. s formPanelObj="form"_$$uniqueId^%zewdAPI(nodeOID,filename)
	. d setAttribute^%zewdDOM("object",formPanelObj,fpOID)
	. i technology'="csp" d
	. . s attr("id")="ewd_action"
	. . s attr("name")="ewd_action"
	. . s attr("value")=formName
	. . s hOID=$$addElementToDOM^%zewdDOM("ext:hiddenField",fpOID,,.attr)
	. s hOID=$$addElementToDOM^%zewdDOM("ext:quicktips",nodeOID,,,,1)
	;
	; process any submit buttons
	;
	k nodeArray,OIDArray
	s ok=$$getElementsByTagName^%zewdDOM("ext:button",nodeOID,.nodeArray)
	s sbOID=""
	f  s sbOID=$o(nodeArray(sbOID)) q:sbOID=""  d
	. i $$getAttribute^%zewdDOM("isformfield",sbOID)="true" q
	. i $$getAttribute^%zewdDOM("usesamerow",sbOID)="true" d  q
	. . d setAttribute^%zewdDOM("cls","x-form-item",sbOID)
	. s objName=$$getAttribute^%zewdDOM("object",sbOID)
	. i objName="" s objName="extObj"_$$uniqueId^%zewdAPI(sbOID,filename)
	. s buttons=$$getAttribute^%zewdDOM("buttons",fpOID)
	. s comma="" i buttons'="" s comma=","
	. s buttons=buttons_comma_objName
	. d setAttribute^%zewdDOM("buttons",buttons,fpOID)
	;	
	s ok=$$getElementsByTagName^%zewdDOM("ext:submitbutton",nodeOID,.nodeArray)
	s sbOID=""
	f  s sbOID=$o(nodeArray(sbOID)) q:sbOID=""  d
	. n action,actionFragment,bOID,failMsgTitle,formSubmitObj,hidden,id,nextpage,success,targetID,text,waitMsg,xOID
	. s text=$$getAttribute^%zewdDOM("text",sbOID)
	. s action=$$getAttribute^%zewdDOM("action",sbOID)
	. i action="" s action="nullFunction^%zewdExtJS2"
	. d actionFragment(action,sbOID)
	. s actionFragment=$$getAttribute^%zewdDOM("actionfragment",sbOID)
	. s waitMsg=$$getAttribute^%zewdDOM("waitmsg",sbOID)
	. s success=$$getAttribute^%zewdDOM("success",sbOID)
	. s failMsgTitle=$$getAttribute^%zewdDOM("failmsgtitle",sbOID)
	. s nextpage=$$getAttribute^%zewdDOM("nextpage",sbOID)
	. s targetID=$$getAttribute^%zewdDOM("targetid",sbOID)
	. s hidden=$$getAttribute^%zewdDOM("hidden",sbOID)
	. s id=$$getAttribute^%zewdDOM("id",sbOID)
	. ;
	. s formSubmitObj="formSubmit"_$$uniqueId^%zewdAPI(sbOID,filename)
	. s attr("id")=id
	. i id="" s attr("id")="extButton"_$$uniqueId^%zewdAPI(sbOID,filename)
	. s attr("object")=attr("id")
	. s attr("text")=text
	. s attr("handler")=formPanelObj_".form.submit("_formSubmitObj_")"
	. i hidden'="" s attr("hidden")=hidden
	. s buttonObj=attr("object")
	. s bOID=$$addElementToDOM^%zewdDOM("ext:button",sbOID,,.attr)
	. s buttons=$$getAttribute^%zewdDOM("buttons",fpOID)
	. s comma="" i buttons'="" s comma=","
	. s buttons=buttons_comma_buttonObj
	. d setAttribute^%zewdDOM("buttons",buttons,fpOID)
	. s attr("object")=formSubmitObj
	. i technology'="csp" d
	. . s attr("url")=$$expandPageURL^%zewdCompiler(actionFragment,.nextPageList,technology)
	. e  d
	. . n url
	. . s url=actionFragment
	. . i url[".ewd" s url=$p(actionFragment,".ewd",1)_".csp"
	. . s url="#url("_url_")#"
	. . s attr("url")=url
	. s attr("waitmsg")=waitMsg
	. s attr("success")=success
	. i nextpage'="",targetID'="" d
	. . n func
	. . s func="ewd.ajaxRequest('"_nextpage_"','"_targetID_"');"
	. . s attr("success")=func
	. s attr("failure")="Ext.MessageBox.alert('"_failMsgTitle_"', action.result.errors.alert);"
	. s xOID=$$addElementToDOM^%zewdDOM("ext:formsubmit",fpOID,,.attr)
	. d removeIntermediateNode^%zewdDOM(sbOID)
	;
	; Add combobox listeners
	;
	n hiddenName,id,ifOID,inputValue,lOID,lsOID,name,nextpage,targetID,text
	k nodeArray,OIDArray
	s ok=$$getElementsByTagName^%zewdDOM("ext:combobox",nodeOID,.nodeArray)
	s cbOID=""
	f  s cbOID=$o(nodeArray(cbOID)) q:cbOID=""  d
	. s name=$$getAttribute^%zewdDOM("name",cbOID)
	. s id=$$getAttribute^%zewdDOM("id",cbOID)
	. i name="" s name=id
	. i id="" s id=name
	. d setAttribute^%zewdDOM("name",name,cbOID)
	. d setAttribute^%zewdDOM("id",id,cbOID)
	. ; Amendment from Chris Casey
	. s hiddenName=$$getAttribute^%zewdDOM("hiddenname",cbOID)
	. i hiddenName'="" d
	. . s nameList=nameList_hiddenName_"|text`"
	. e  d
	. . s nameList=nameList_name_"|text`"
	. ;s nameList=nameList_name_"|text`"
	. ; End of Chris's amendment
	. s value=$$getAttribute^%zewdDOM("value",cbOID)
	. i value="*" d setAttribute^%zewdDOM("value","#"_name,cbOID)
	. ;
	. s nextpage=$$getAttribute^%zewdDOM("nextpage",cbOID)
	. s targetID=$$getAttribute^%zewdDOM("targetid",cbOID)
	. i nextpage="" q
	. ;
	. ;d setAttribute^%zewdDOM("listeners","children",cbOID)
	. s lsOID=$$addListenersTag(cbOID)
	. s attr("name")="select"
	. s attr("param1")="combo"
	. s attr("param2")="record"
	. s attr("param3")="index"
	. s text="var nvp = '"_name_"=' + record.data.value ;"_$c(13,10)
	. s text=text_"ewd.ajaxRequest("""_nextpage_""","""_targetID_""",nvp) ;"
	. s lOID=$$addElementToDOM^%zewdDOM("ext:listener",lsOID,,.attr,text)
	. d removeAttribute^%zewdDOM("nextpage",cbOID)
	. d removeAttribute^%zewdDOM("targetid",cbOID)
	. ;
	k nodeArray,OIDArray
	s ok=$$getElementsByTagName^%zewdDOM("ext:textarea",nodeOID,.nodeArray)
	s rOID=""
	i 'isAjax d
	. n headOID
	. s headOID=$$getTagOID^%zewdDOM("head",docName)
	. s parentOID=$$addElementToDOM^%zewdDOM("ewd:dummy",headOID,,,,1)
	e  d
	. s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	f  s rOID=$o(nodeArray(rOID)) q:rOID=""  d
	. s name=$$getAttribute^%zewdDOM("name",rOID)
	. s nameList=nameList_name_"|textarea`"
	. s attr("method")="writeTextArea^%zewdExtJS"
	. s attr("param1")=name
	. s attr("param2")="#ewd_sessid"
	. s attr("type")="procedure"
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",parentOID,,.attr,,1)
	. d setAttribute^%zewdDOM("value","<?= document.getElementById('zewdTextarea"_name_"').firstChild.data.replace(/\\r\\n/g, '\r\n') ?>",rOID)
	i 'isAjax d removeIntermediateNode^%zewdDOM(parentOID)
	;
	k nodeArray,OIDArray
	s ok=$$getElementsByTagName^%zewdDOM("ext:radio",nodeOID,.nodeArray)
	s rOID=""
	i 'isAjax d
	. n headOID
	. s headOID=$$getTagOID^%zewdDOM("head",docName)
	. s parentOID=$$addElementToDOM^%zewdDOM("ewd:dummy",headOID,,,,1)
	f  s rOID=$o(nodeArray(rOID)) q:rOID=""  d
	. n id,ifOID,inputValue,lOID,lsOID,name,nextpage,setOID,statusVar,targetID,text
	. ;
	. s name=$$getAttribute^%zewdDOM("name",rOID)
	. s id=$$getAttribute^%zewdDOM("id",rOID)
	. i id=name d removeAttribute^%zewdDOM("id",rOID)
	. i nameList'[(name_"|") s nameList=nameList_name_"|text`"
	. ;
	. s inputValue=$$getAttribute^%zewdDOM("inputvalue",rOID)
	. s attr("return")="$status"_$$uniqueId^%zewdAPI(rOID,filename)
	. s attr("value")="false"
	. i isAjax s parentOID=rOID
	. s setOID=$$addElementToDOM^%zewdDOM("ewd:set",parentOID,,.attr)
	. s attr("firstvalue")="#"_name
	. s attr("operation")="="
	. s attr("secondvalue")=inputValue
	. s ifOID=$$addElementToDOM^%zewdDOM("ewd:if",parentOID,,.attr)
	. s attr("return")="$status"_$$uniqueId^%zewdAPI(rOID,filename)
	. s attr("value")="true"
	. s statusVar=attr("return")
	. s setOID=$$addElementToDOM^%zewdDOM("ewd:set",ifOID,,.attr)
	. d setAttribute^%zewdDOM("checked",statusVar,rOID)
	i 'isAjax d removeIntermediateNode^%zewdDOM(parentOID)
	;
	k nodeArray,OIDArray
	s ok=$$getElementsByTagName^%zewdDOM("ext:checkbox",nodeOID,.nodeArray)
	s rOID=""
	i 'isAjax d
	. n headOID
	. s headOID=$$getTagOID^%zewdDOM("head",docName)
	. s parentOID=$$addElementToDOM^%zewdDOM("ewd:dummy",headOID,,,,1)
	f  s rOID=$o(nodeArray(rOID)) q:rOID=""  d
	. n id,ifOID,inputValue,lOID,lsOID,name,nextpage,setOID,statusVar,targetID,text
	. ;
	. s name=$$getAttribute^%zewdDOM("name",rOID)
	. s id=$$getAttribute^%zewdDOM("id",rOID)
	. i id=name d removeAttribute^%zewdDOM("id",rOID)
	. i nameList'[(name_"|") s nameList=nameList_name_"|checkbox`"
	. i technology="php" d setAttribute^%zewdDOM("name",name_"[]",rOID)
	. ;
	. s inputValue=$$getAttribute^%zewdDOM("inputvalue",rOID)
	. s attr("return")="$status"_$$uniqueId^%zewdAPI(rOID,filename)
	. s attr("value")="false"
	. i isAjax s parentOID=rOID
	. s setOID=$$addElementToDOM^%zewdDOM("ewd:set",parentOID,,.attr)
	. s attr("arrayname")="ewd_session"
	. i technology="wl"!(technology="gtm")!(technology="ewd") s attr("arrayname")="sessionArray"
	. i technology="csp" s attr("arrayname")="%session.Data"
	. s attr("param1")="ewd_selected"
	. s attr("param2")=name
	. s attr("param3")=inputValue
	. ;<ewd:ifArrayExists arrayName="$myArray" param1="xxx" param2="$yyy" param3="#zzz">
	. s ifOID=$$addElementToDOM^%zewdDOM("ewd:ifarrayexists",parentOID,,.attr)
	. s attr("return")="$status"_$$uniqueId^%zewdAPI(rOID,filename)
	. s attr("value")="true"
	. s statusVar=attr("return")
	. s setOID=$$addElementToDOM^%zewdDOM("ewd:set",ifOID,,.attr)
	. d setAttribute^%zewdDOM("checked",statusVar,rOID)
	i 'isAjax d removeIntermediateNode^%zewdDOM(parentOID)
	;
	f tag="textfield","datefield","timefield","numberfield" d
	. s ok=$$getElementsByTagName^%zewdDOM("ext:"_tag,nodeOID,.nodeArray)
	. s rOID=""
	. f  s rOID=$o(nodeArray(rOID)) q:rOID=""  d
	. . s name=$$getAttribute^%zewdDOM("name",rOID)
	. . s id=$$getAttribute^%zewdDOM("id",rOID)
	. . s value=$$getAttribute^%zewdDOM("value",rOID)
	. . i name="" s name=id
	. . i id="" s id=name
	. . i id'=name s id=name
	. . d setAttribute^%zewdDOM("name",name,rOID)
	. . d setAttribute^%zewdDOM("id",id,rOID)
	. . i value="*" d setAttribute^%zewdDOM("value","#"_id,rOID)
	. . s nameList=nameList_name_"|text`"
	;
	i technology="csp" d
	. n attr,hOID
	. s attr("id")="ewd_nameList"
	. s attr("name")="ewd_nameList"
	. s attr("value")=nameList
	. s hOID=$$addElementToDOM^%zewdDOM("ext:hiddenField",fpOID,,.attr)
	;
	d removeIntermediateNode^%zewdDOM(nodeOID)
	s n=$o(formDeclarations(""),-1)+1
	s formDeclarations(n)=formName_"~~~"_nameList
	;
	QUIT
	;
actionFragment(action,nodeOID)
	;
	n page,text
	s text(1)="<ewd:config pageType='extFormHandler' isFirstPage='false' prePageScript='"_action_"' />"
	s page="zextAction"_$$uniqueId^%zewdAPI(nodeOID,filename)
	d addEWDPage(page,.text)
	d setAttribute^%zewdDOM("actionfragment",page_".ewd",nodeOID)
	;
	QUIT
	;
addEWDPage(pageName,text)
	;
	n fileName,filePath,io,lineNo
	;
	s io=$io
	s fileName=pageName
	s filePath=inputPath_fileName_".ewd"
	i '$$openNewFile^%zewdCompiler(filePath) QUIT
	u filePath
	s lineNo=""
	f  s lineNo=$o(text(lineNo)) q:lineNo=""  d
	. w text(lineNo),!
	c filePath
	u io
	s files(fileName_".ewd")=""
	QUIT
	;
desktopWindowLoader(sessid)
 ;
 n allowed,dataStore,dlim,frag,np,sourcePage,treeValue
 ;
 d mergeArrayFromSession^%zewdAPI(.allowed,"ext_allowPage",sessid)
 s windowNvp=$$getRequestValue^%zewdAPI("windowNvp",sessid)
 d setSessionValue^%zewdAPI("ext.windowNvp",windowNvp,sessid)
 s frag=$$getRequestValue^%zewdAPI("frag",sessid)
 s dataStore=$$getRequestValue^%zewdAPI("ds",sessid)
 s treeValue=$$getRequestValue^%zewdAPI("tv",sessid)
 i $g(^zewd("trace")) d trace^%zewdAPI("Desktop Window Loader: frag="_frag_"; dataStore="_dataStore_"; treeValue="_treeValue)
 d setSessionValue^%zewdAPI("ext.treeValue",treeValue,sessid)
 s sourcePage=$$getRequestValue^%zewdAPI("cp",sessid)
 i frag="",dataStore'="",treeValue'="" d
 . n map
 . d mergeArrayFromSession^%zewdAPI(.map,dataStore_"PageMap",sessid)
 . s frag=$g(map(treeValue))
 . ;d trace^%zewdAPI("frag from map = "_frag)
 e  i frag["?" d
 . s nvps=$p(frag,"?",2)
 . s frag=$p(frag,"?",1)
 . s n=$l(nvps,"&")
 . f i=1:1:n d
 . . s nvp=$p(nvps,"&",i)
 . . s name=$p(nvp,"=",1)
 . . s value=$p(nvp,"=",2)
 . . d setSessionValue^%zewdAPI(name,value,sessid)
 i $g(^zewd("trace")) d trace^%zewdAPI("Desktop Window Loader: sourcePage="_sourcePage_"; frag="_frag)
 i '$d(allowed(sourcePage,frag)) QUIT ""
 i $g(^zewd("trace")) d trace^%zewdAPI("Desktop Window Loader: redirecting to "_frag)
 d setRedirect^%zewdAPI(frag,sessid)
 QUIT ""
 ;
nullFunction(sessid)
 QUIT ""
 ;
