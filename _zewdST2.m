%zewdST2 ; Sencha Touch Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 855)
 ; Build Date: Tue, 22 Feb 2011 12:53:41
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
 n images,jsOID,jsText,locale,mainAttrs,OIDArray,path,phpVar,resourcePath,rootPath
 n src,tagName,text,title,timeoutAction,xOID
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
 ;i contentPage="" s contentPage="pageNotDefined"
 s title=$g(mainAttrs("title"))
 i title="" s title="EWD/Sencha Touch Application"
 s rootPath=$g(mainAttrs("rootpath"))
 i rootPath="" s rootPath="/sencha/"
 s rootPath=$$addSlashAtEnd^%zewdST(rootPath)
 s debug=$g(mainAttrs("debug"))
 s timeoutAction=$g(mainAttrs("timeoutpage")) i timeoutAction="" s timeoutAction="reload"
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
 ;s attr("rel")="stylesheet"
 ;s attr("type")="text/css"
 ;s attr("href")=rootPath_"resources/css/sencha-touch.css"
 s src=rootPath_"resources/css/sencha-touch.css"
 d registerResource^%zewdCustomTags("css",src,"",app)
 ;s xOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr)
 ;
 ;s text=" d loadFiles^%zewdCustomTags("""_$$zcvt^%zewdAPI(app,"l")_""",""css"",sessid)"
 ;i $$addCSPServerScript^%zewdAPI(headOID,text)
 ;
 ;s attr("type")="text/javascript"
 ;s attr("src")=rootPath_"sencha-touch.js"
 ;i debug="true" s attr("src")=rootPath_"sencha-touch-debug.js"
 ;s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 s src=rootPath_"sencha-touch.js"
 i debug="true" s src=rootPath_"sencha-touch-debug.js"
 d registerResource^%zewdCustomTags("js",src,"",app)
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
 ;s text=" d loadFiles^%zewdCustomTags("""_$$zcvt^%zewdAPI(app,"l")_""",""js"",sessid)"
 ;i $$addCSPServerScript^%zewdAPI(headOID,text)
 ;
 s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_startupImage")
 s attr("style")="background-image: url("_phpVar_");background-repeat: no-repeat"
 s bodyOID=$$addElementToDOM^%zewdDOM("body",htmlOID,,.attr)
 ;
 s attr("id")="ewdNullId"
 s attr("style")="display:none"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 s attr("id")="ewdContent"
 s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"&nbsp;")
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:content" d
 . . d containerContent(childOID,headOID)
 . i tagName="script" d
 . . n src
 . . s src=$$getAttribute^%zewdDOM("src",childOID)
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . d registerResource^%zewdCustomTags("js",src,"",app)
 . . ;s xOID=$$appendChild^%zewdDOM(childOID,headOID)
 ;
 s attr("type")="text/javascript"
 s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr)
 ;
 ;s attr("return")="EWD.sencha.loadContentPage"
 ;s attr("addVar")="false"
 ;s attr("parameters")=""
 ;s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",jsOID,,.attr)
 ;
 ;s jsText=""
 ;i $g(locale("dateformat"))'="" s jsText=jsText_"Ext.util.Format.defaultDateFormat='"_locale("dateformat")_"';"_$c(13,10)
 ;s jsText=jsText_"ewd.ajaxRequest("""_contentPage_""",""ewdContent"");"
 ;s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",funcOID,,,jsText)
 ;
 s text=""
 s text=text_"Ext.setup({"_$c(13,10)
 s text=text_"tabletStartupScreen:'"_images("tabletStartupScreen","src")_"',"_$c(13,10)
 s text=text_"phoneStartupScreen:'"_images("phoneStartupScreen","src")_"',"_$c(13,10)
 s text=text_"icon:'"_images("icon","src")_"',"_$c(13,10)
 s text=text_"addGlossToIcon:"_images("icon","addgloss")_","_$c(13,10)
 s text=text_"onReady:function(){"_$c(13,10)
 i $g(locale("dateformat"))'="" s text=text_"Ext.util.Format.defaultDateFormat='"_locale("dateformat")_"';"_$c(13,10)
 i contentPage'="" d
 . s text=text_"EWD.ajax.getPage({page:'"_contentPage_"',targetId:'ewdContent'});"_$c(13,10)
 e  d
 . n preOID
 . s text=text_"EWD.sencha.init();"_$c(13,10)
 s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_sessid_timeout")
 ;s text=text_"EWD.sencha.loadContentPage()"_$c(13,10)
 s text=text_"}"_$c(13,10)
 s text=text_"});"_$c(13,10)
 s text=text_"EWD.sencha.timer("_phpVar_",'"_timeoutAction_"');"_$c(13,10)
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
 ;
 ;s attr("onLoad")="EWD.sencha.loadContentPage();"
 ;
 s attr("method")="startupImage^%zewdCustomTags"
 s attr("param1")=images("phoneStartupScreen","src")
 s attr("param2")=images("tabletStartupScreen","src")
 s attr("param3")="#ewd_sessid"
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",headOID,,.attr)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
containerContent(nodeOID,headOID)
 ;
 n childNo,childOID,OIDArray,scriptOID,scriptOID2,tagName
 ;
 s attr("type")="text/javascript"
 s attr("id")="ewdSTJS"
 s scriptOID=$$addElementToDOM^%zewdDOM("st:script",headOID,,.attr)
 s scriptOID2=$$createElement^%zewdDOM("st:script",docOID)
 s scriptOID2=$$insertBefore^%zewdDOM(scriptOID2,scriptOID)
 d setAttribute^%zewdDOM("id","ewdPreSTJS",scriptOID2)
 d setAttribute^%zewdDOM("type","text/javascript",scriptOID2)
 s attr("type")="text/javascript"
 s attr("id")="ewdPostSTJS"
 s scriptOID2=$$addElementToDOM^%zewdDOM("st:script",headOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:panel" d
 . . n classOID
 . . d panel^%zewdST(childOID,,docOID,technology)
 . . s classOID=$$getFirstChild^%zewdDOM(nodeOID)
 . . s classOID=$$removeChild^%zewdDOM(classOID)
 . . s classOID=$$appendChild^%zewdDOM(classOID,scriptOID)
 . . ;s contentJS="EWD.sencha.init=function() {"_$c(13,10)_contentJS_"};"_$c(13,10)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
script(nodeOID,attrValue,docOID,technology)
 ;
 n fcOID,id,line,sOID,txOID
 ;
 s id=$$getAttribute^%zewdDOM("id",nodeOID)
 i id="ewdSTJS" d
 . s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
 . d removeAttribute^%zewdDOM("id",nodeOID)
 . s sOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"ewd:jssection",docOID)
 . d setAttribute^%zewdDOM("id","ewdSTJS",sOID)
 . s line="EWD.sencha.init=function() {"
 . s txOID=$$addElementToDOM^%zewdDOM("ewd:jsline",nodeOID,,,line,1)
 . s line="};"
 . s txOID=$$addElementToDOM^%zewdDOM("ewd:jsline",nodeOID,,,line)
 e  d
 s txOID=$$renameTag^%zewdDOM("ewd:script",nodeOID)
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
 d registerResource^%zewdCustomTags("js","qrCode.js","QRCode^%zewdSTJS3",app)
 ;
 QUIT
 ;
pageItem(nodeOID,attrValue,docOID,technology)
 ;
 n attr,childNo,childOID,class,divOID,dOID,header,id,labelWidth
 n mainAttrs,noOfFields,OIDArray,shadow,sOID,tagName,title
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s title=$g(mainAttrs("title"))
 s shadow=$g(mainAttrs("shadow")) i shadow="" s shadow="true"
 i shadow'="true",shadow'="false" s shadow="false"
 s id=$g(mainAttrs("id")) i id="" s id="ewdSTpageItem"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s header=$g(mainAttrs("header"))
 s labelWidth=+$g(mainAttrs("labelwidth"))
 ;
 s sOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"span",docOID)
 d setAttribute^%zewdDOM("id",id,sOID)
 ;
 s dOID=$$insertNewIntermediateElement^%zewdDOM(sOID,"div",docOID)
 s class="stRoundedBox"
 i shadow="true" s class="stShadowBox"
 d setAttribute^%zewdDOM("class",class,dOID)
 ;
 i title'="" d
 . n textOID,titleOID
 . s titleOID=$$createElement^%zewdDOM("div",docOID)
 . s titleOID=$$insertBefore^%zewdDOM(titleOID,dOID)
 . d setAttribute^%zewdDOM("class","x-form-fieldset-title",titleOID)
 . d setAttribute^%zewdDOM("style","margin-left:20px;",titleOID)
 . s textOID=$$addTextToElement^%zewdDOM(titleOID,title)
 ;
 i header'="" d
 . n fcOID,textOID,titleOID
 . s fcOID=$$getFirstChild^%zewdDOM(dOID)
 . i dOID="" d
 . . s attr("class")="stFieldBoxTitle"
 . . s titleOID=$$addElementToDOM^%zewdDOM("div",dOID,,.attr,header)
 . e  d
 . . s titleOID=$$createElement^%zewdDOM("div",docOID)
 . . s titleOID=$$insertBefore^%zewdDOM(titleOID,fcOID)
 . . d setAttribute^%zewdDOM("class","stFieldBoxTitle",titleOID)
 . . s textOID=$$addTextToElement^%zewdDOM(titleOID,header)
 ;
 d getChildrenInOrder^%zewdDOM(dOID,.OIDArray)
 s childNo="",noOfFields=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:pageitemfield" d
 . . n boxOID,label,subAttrs,textOID,value,xOID
 . . s noOfFields=noOfFields+1
 . . d getAttributeValues^%zewdCustomTags(childOID,.subAttrs)
 . . s label=$g(subAttrs("label"))
 . . s value=$g(subAttrs("value"))
 . . s attr("class")="stFieldBoxField"
 . . s boxOID=$$addElementToDOM^%zewdDOM("div",childOID,,.attr) 
 . . i label'="" d
 . . . s attr("class")="stFieldBoxLabel"
 . . . i labelWidth>0 s attr("style")="width:"_labelWidth_"px"
 . . . s xOID=$$addElementToDOM^%zewdDOM("span",boxOID,,.attr,label) 
 . . s textOID=$$addTextToElement^%zewdDOM(boxOID,value)
 . . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 i noOfFields=0 d setAttribute^%zewdDOM("style","padding-bottom:14px",dOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
list(nodeOID,attrValue,docOID,technology)
 ;
 n panelOID,parentOID,stop
 ;
 ; check if list is inside a panel - if so, ignore for now
 ;
 s stop=0
 s parentOID=nodeOID
 f  q:stop  d  q:parentOID=""
 . s parentOID=$$getParentNode^%zewdDOM(parentOID)
 . i $$getTagName^%zewdDOM(parentOID)="st:panel" s stop=1
 i stop QUIT
 ;
 s panelOID=nodeOID
 d list^%zewdST(nodeOID)
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
combo(nodeOID,mainAttrs,formOID)
 ;
 n attr,bodyOID,fOID,height,i,id,jsOID,lOID,lsOID,lyOID,method,pOID,stOID,width
 ;
 s bodyOID=$$getParentNode^%zewdDOM(formOID)
 s method=$g(mainAttrs("method"))
 s height=$g(mainAttrs("panelheight"))
 s width=$g(mainAttrs("panelwidth"))
 s id=$g(mainAttrs("id"))
 i id="" s id="ewdSTField"_$$uniqueId^%zewdAPI(nodeOID,filename)
 f i="method","panelheight","panelwidth" k mainAttrs(i)
 s ^zewd("comboMethod",app,id)=method
 s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",nodeOID)
 s attr("keyup")=".{fn: function(){EWD.sencha.combo.filter({seed:this.getValue(),id:'"_id_"',width:"_width_",height:"_height_"}); }}"
 s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 ;
 s attr("id")="ewdComboPanel"
 s attr("floating")="true"
 s attr("draggable")="false"
 s attr("modal")="false"
 s attr("scroll")="vertical"
 s attr("hideonmasktap")="true"
 s attr("width")=400
 s attr("height")=200
 s attr("hidden")="true"
 s pOID=$$addElementToDOM^%zewdDOM("st:panel",bodyOID,,.attr)
 s attr("id")="ewdComboMatches"
 s attr("sessionname")="ewdComboMatches"
 s attr("store")="EWD.sencha.combo.store"
 s attr("scroll")="true"
 s attr("ontap")="EWD.sencha.combo.selectItem"
 s lOID=$$addElementToDOM^%zewdDOM("st:list",pOID,,.attr)
 s lyOID=$$addElementToDOM^%zewdDOM("st:layout",lOID)
 s attr("name")="text"
 s attr("displayinlist")="true"
 s fOID=$$addElementToDOM^%zewdDOM("st:field",lyOID,,.attr)
 s jsOID=$$createJS^%zewdST("standard")
 s stOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 ;s attr("method")="setSessionValue^%zewdAPI"
 ;s attr("param1")="ewdComboMatches"
 ;s attr("param2")="[]"
 ;s attr("param3")="#ewd_sessid"
 ;s attr("type")="procedure"
 ;s pOID=$$addElementToDOM^%zewdDOM("ewd:execute",stOID,,.attr)
 d comboMatchesPage(inputPath,.files)
 d registerResource^%zewdCustomTags("js","ewdCombo.js","combo^%zewdSTJS2",app)
 ;
 QUIT
 ;
json(nodeOID,attrValue,docOID,technology)
 ;
 n at,jsOID,mainAttrs,return,sessionName,stOID,text,var
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s sessionName=$g(mainAttrs("sessionname")) i sessionName="" s sessionName="missingSessionName"
 s return=$g(mainAttrs("return")) i return="" s return="missingVar"
 s var=0
 i $g(mainAttrs("var"))="true" s var=1
 s at=$g(mainAttrs("at")) i at="" s at="start"
 ;
 s jsOID=$$createJS^%zewdST("standard")
 i at="start"!(at="top") d
 . s stOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 e  d
 . s stOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID) 
 ;
 s text=" d streamJSON^%zewdJSON("""_sessionName_""","""_return_""","""_var_""",sessid)"
 i $$addCSPServerScript^%zewdAPI(stOID,text)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
panelLayout(layoutOID,itemOID)
 ;
 s layoutOID=$$removeChild^%zewdDOM(layoutOID)
 s layoutOID=$$appendChild^%zewdDOM(layoutOID,itemOID)
 ;
 QUIT
 ;
comboMatchesPage(inputPath,files)
 ;
 n fileName,filePath,io
 ;
 s io=$io
 s fileName="zewdcm"
 s filePath=inputPath_fileName_".ewd"
 i '$$openNewFile^%zewdCompiler(filePath) QUIT
 u filePath
 w "<ewd:config isFirstPage=""false"" pagetype=""ajax"" prePageScript=""getComboMatches^%zewdCustomTags"" />",!
 w "<ewd:js>",!
 w "<ewd:cspscript language=""cache"" runat=""server"">",!
 w "d writeListData^%zewdST2(""ewdComboMatches"",sessid)",!
 w "</ewd:cspscript>",!
 w " EWD.sencha.combo.store.loadData(EWD.sencha.jsonData,false);",!
 w "</ewd:js>",!
 c filePath
 u io
 s files(fileName_".ewd")=""
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
 ;f  s no=$o(data(no)) q:no=""  s data(no,col1)="&nbsp;&nbsp;"_$g(data(no,col1))
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
writeListData(sessionName,sessid)
 ;
 n data
 ;
 w "EWD.sencha.jsonData="
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 d streamArrayToJSON^%zewdJSON("data")
 w ";"_$c(13,10)
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
