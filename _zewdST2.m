%zewdST2 ; Sencha Touch Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 842)
 ; Build Date: Wed, 02 Feb 2011 09:31:08
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
 s text=" d loadFiles^%zewdCustomTags("""_$$zcvt^%zewdAPI(app,"l")_""",""css"",sessid)"
 i $$addCSPServerScript^%zewdAPI(headOID,text)
 ;
 s attr("type")="text/javascript"
 s attr("src")=rootPath_"sencha-touch.js"
 i debug="true" s attr("src")=rootPath_"sencha-touch-debug.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 ;d createJSFile^%zewdST("stJS","ewdSTJS.js")
 d registerResource^%zewdCustomTags("js","ewdSTJS.js","stJS^%zewdSTJS",app)
 ;
 ;s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 ;s path=$$addSlashAtEnd^%zewdST(path)
 ;s attr("type")="text/javascript"
 ;s attr("src")=path_"ewdSTJS.js"
 ;s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 s text=" d loadFiles^%zewdCustomTags("""_$$zcvt^%zewdAPI(app,"l")_""",""js"",sessid)"
 i $$addCSPServerScript^%zewdAPI(headOID,text)
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
qrCode(nodeOID,attrValue,docOID,technology)
 ;
 n attr,blockSize,correctionLevel,data,id,jsOID,jsText,mainAttrs,pointSize,stOID,xOID
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s blockSize=$g(mainAttrs("blocksize")) i blockSize="" s blockSize=7
 s correctionLevel=$g(mainAttrs("correctionlevel")) i correctionLevel="" s correctionLevel="H"
 s data=$g(mainAttrs("data")) i data="" s data="Undefined QRCode"
 s id=$g(mainAttrs("id")) i id="" s id="ewdSTQRCode"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s pointSize=$g(mainAttrs("pointsize")) i pointSize="" s pointSize=4
 ;
 s jsText="EWD.sencha.qrCode.draw({pointSize:"_pointSize_",correctionLevel:'"_correctionLevel_"',blockSize:"_blockSize_",data:'"_data_"',id:'"_id_"'});"
 s jsOID=$$createJS^%zewdST("standard")
 s stOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,jsText)
 ;
 s attr("id")=id
 s xOID=$$addElementToDOM^%zewdDOM("canvas",nodeOID,,.attr)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 ; s ^zewd("loader",$$zcvt^%zewdAPI(app,"l"),"js","qrCode.js")="QRCode^%zewdSTJS"
 ; registerResource(type,fileName,source,app)
 d registerResource^%zewdCustomTags("js","qrCode.js","QRCode^%zewdSTJS",app)
 ;
 QUIT
 ;
touchGridSub(nodeOID,itemsOID)
 ;
 n colDef,dataStore,editable,id,itemOID,mainAttrs,name,onEdit,onTap,store,tagName,xtype
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s xtype="touchgridpanel"
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID)
 ;
 s dataStore=$g(mainAttrs("sessionname"))
 k mainAttrs("sessionname")
 ;
 s store=$g(mainAttrs("store"))
 i store="" d
 . s store="ewdSTouchGridStore"_$$uniqueId^%zewdAPI(nodeOID,filename)
 k mainAttrs("store")
 ;
 s colDef=$g(mainAttrs("columndefinition"))
 k mainAttrs("columndefinition")
 ;
 s id=$g(mainAttrs("id")) 
 i id="" d
 . s id="ewdSTouchGrid"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s mainAttrs("id")=id
 ;
 s onTap="",editable=0
 s onEdit=$g(mainAttrs("onedit"))
 i onEdit'="" s editable=1,onTap="EWD.sencha.touchGrid.editCell"
 k mainAttrs("onedit")
 ;
 i editable d
 . n attr,fsOID,parentOID,xOID
 . s parentOID=$$getParentNode^%zewdDOM(bodyxOID) ; bodyxOID = top level panel node
 . s attr("id")="ewdSTTouchGridEditPanel"
 . s attr("floating")="true"
 . s attr("draggable")="false"
 . s attr("modal")="true"
 . s attr("height")=200
 . s attr("width")=350
 . s attr("scroll")="vertical"
 . s attr("hidden")="true"
 . s xOID=$$addElementToDOM^%zewdDOM("st:panel",parentOID,,.attr)
 . s attr("id")="ewdSTTouchGridEditForm"
 . s attr("submitOnAction")="false"
 . s xOID=$$addElementToDOM^%zewdDOM("st:form",xOID,,.attr)
 . s attr("title")="Edit Value"
 . s fsOID=$$addElementToDOM^%zewdDOM("st:fieldset",xOID,,.attr)
 . s attr("type")="text"
 . s attr("id")="ewdSTTouchGridCell"
 . s attr("label")="Value"
 . s attr("labelwidth")="20%"
 . s xOID=$$addElementToDOM^%zewdDOM("st:field",fsOID,,.attr)
 . s attr("type")="submit"
 . s attr("text")="Update"
 . s attr("style")="drastic_round"
 . s attr("handler")="EWD.sencha.touchGrid.updateCell"
 . s xOID=$$addElementToDOM^%zewdDOM("st:field",fsOID,,.attr)
 ;
 d setAttribute^%zewdDOM("xtype",xtype,itemOID)
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i name="object" q
 . d setAttribute^%zewdDOM(name,mainAttrs(name),itemOID)
 ;
 d touchGridCode(itemOID,dataStore,store,colDef,onTap,onEdit)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
touchGrid(nodeOID,attrValue,docOID,technology)
 ;
 n colDef,dataStore,i,id,mainAttrs,onTap,store
 ;
 s gridOID=$$renameTag^%zewdDOM("st:class",nodeOID)
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s dataStore=$g(mainAttrs("sessionname"))
 s store=$g(mainAttrs("store"))
 i store="" s store="ewdSTouchGridStore"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s colDef=$g(mainAttrs("columndefinition"))
 s id=$g(mainAttrs("id")) 
 i id="" d
 . s id="ewdSTouchGrid"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . d setAttribute^%zewdDOM("id",id,gridOID)
 s onTap=$g(mainAttrs("ontap"))
 ;
 d setAttribute^%zewdDOM("name","Ext.ux.TouchGridPanel",gridOID)
 f i="sessionname","columndefinition","ontap" d
 . d removeAttribute^%zewdDOM(i,gridOID)
 ;
 d touchGridCode(gridOID,dataStore,store,colDef,onTap)
 ;
 QUIT
 ;
touchGridCode(nodeOID,dataStore,store,colDef,onTap,onEdit)
 ;
 n attr,i,jsOID,lOID,lsOID,stOID,text
 ;
 s jsOID=$$createJS^%zewdST("standard")
 s stOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 ;
 s text=" d writeRegModel^%zewdST2("""_dataStore_""","""_store_""","""_colDef_""",sessid)"
 i $$addCSPServerScript^%zewdAPI(stOID,text)
 ;
 i $g(onEdit)'="" d
 . s text="EWD.sencha.touchGrid.onSave="_onEdit_";"_$c(13,10)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text)
 ;
 d setAttribute^%zewdDOM("store","."_store,nodeOID)
 d setAttribute^%zewdDOM("selModel",".{singleSelect:true}",nodeOID)
 d setAttribute^%zewdDOM("colModel",".EWD.sencha.colModel",nodeOID)
 i $g(onTap)'="" d
 . s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",nodeOID)
 . s attr("rowTap")="."_onTap
 . s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 ;
 d registerResource^%zewdCustomTags("js","touchGrid.js","touchGrid^%zewdSTJS2",app)
 d registerResource^%zewdCustomTags("css","touchGrid.css","touchGrid^%zewdSTCSS",app)
 QUIT
 ;
writeRegModel(sessionName,store,colDefName,sessid)
 ;
 n col,col1,colDef,comma,data,no
 ;
 s comma=""
 w "Ext.regModel('"_sessionName_"Model',{fields:["
 d mergeArrayFromSession^%zewdAPI(.colDef,colDefName,sessid)
 f col=1:1 q:'$d(colDef(col))  d
 . w comma_"'"_colDef(col,"name")_"'"
 . s comma=","
 w "]});"_$c(13,10)
 w store_"=new Ext.data.Store({model:'"_sessionName_"Model',data:"
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 s col1=$g(colDef(1,"name"))
 s no=""
 f  s no=$o(data(no)) q:no=""  s data(no,col1)="&nbsp;&nbsp;"_$g(data(no,col1))
 d streamArrayToJSON^%zewdJSON("data")
 w "});"_$c(13,10)
 w "EWD.sencha.colModel=["
 s col="",comma=""
 f  s col=$o(colDef(col)) q:col=""  d
 . w comma_"{header:'"_$g(colDef(col,"header"))_"',"
 . w "mapping:'"_$g(colDef(col,"name"))_"'"
 . i $g(colDef(col,"renderer"))'="" d
 . . w ",renderer:"_colDef(col,"renderer")
 . w "}"
 . s comma=","
 w "];"_$c(13,10)
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
getCamelCase(string,options)
 ;
 n camelCase
 ;
 s camelCase=$g(options(string))
 i camelCase="" s camelCase=string
 ;
 QUIT camelCase
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
convertToCamelCase(string)
 ;
 n terms
 ;
 d defineCamelCaseTerms(.terms)
 QUIT $$getCamelCase(string,.terms)
 ;
camelCaseTerms
 ;;activeCls
 ;;activeItem
 ;;autoDestroy
 ;;baseCls
 ;;baseParams
 ;;bodyBorder
 ;;bodyMargin
 ;;bodyPadding
 ;;bubbleEvents
 ;;cardSwitchAnimation
 ;;componentCls
 ;;componentLayout
 ;;contentEl
 ;;dayText
 ;;defaultType
 ;;disabledClass
 ;;disabledCls
 ;;dockedItems
 ;;doneButton
 ;;enterAnimation
 ;;exitAnimation
 ;;floatingCls
 ;;hideOnMaskTap
 ;;itemTpl
 ;;labelWidth
 ;;layoutConfig
 ;;layoutOnOrientationChange
 ;;labelAlign
 ;;maxHeight
 ;;maxWidth
 ;;minHeight
 ;;minWidth
 ;;monitorOrientation
 ;;monthText
 ;;overCls
 ;;renderSelectors
 ;;renderTo
 ;;renderTpl
 ;;showAnimation
 ;;slotOrder
 ;;standardSubmit
 ;;stopMaskTapEvent
 ;;stretchX
 ;;stretchY
 ;;styleHtmlCls
 ;;styleHtmlContent
 ;;submitOnAction
 ;;tplWriteMode
 ;;useTitles
 ;;waitTpl
 ;;yearFrom
 ;;yearText
 ;;yearTo
 ;;***END***
 ;;
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
