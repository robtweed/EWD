%zewdExtJS	; Ext-JS tag processors
 ;
 ; Product: Enterprise Web Developer (Build 906)
 ; Build Date: Wed, 28 Mar 2012 12:52:00
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
extConfig(nodeOID,attrValues,docOID,technology)
	;
	; <ext:config path="/ext-2.0.1" debug="true"/>
	; 
	;    <script type="text/javascript" src="/ext-2.0.1/adapter/ext/ext-base.js"></script>
	;    <script type="text/javascript" src="/ext-2.0.1/ext-all-debug.js"></script>
	;    <link rel="stylesheet" type="text/css" href="/ext-2.0.1/resources/css/ext-all.css">
	;
	n attr,attrs,biURL,cr,dtOID,fileName,filePath,headOID,io,js,jsText
	n line,lineNo,scriptOID,style,x
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	;
	s headOID=$$getTagOID^%zewdDOM("head",docName)
	s style=$$zcvt^%zewdAPI($g(attrs("style")),"l")
	i style="grey"!(style="gray") d
	. s attr("rel")="stylesheet"
	. s attr("type")="text/css"
	. s attr("href")=attrs("path")_"/resources/css/xtheme-gray.css"
	. s scriptOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr,,1)
	s attr("rel")="stylesheet"
	s attr("type")="text/css"
	s attr("href")=attrs("path")_"/resources/css/ext-all.css"
	s scriptOID=$$addElementToDOM^%zewdDOM("link",headOID,,.attr,,1)
	s js="/ext-all"
	i $$zcvt^%zewdAPI($g(attrs("debug")),"l")="true" s js=js_"-debug"
	s js=js_".js"
	s attr("type")="text/javascript"
	s attr("src")=attrs("path")_js
	s scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,,1)
	s attr("type")="text/javascript"
	s attr("src")=attrs("path")_"/adapter/ext/ext-base.js"
	s scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,,1)
	;
	s cr=$c(13,10)
	s attr("language")="javascript"
	s attr("id")="extjs"
	s attr("key")=$$license()
	s jsText="/*"_cr
	s jsText=jsText_" * Ext JS Library 2.0.1"_cr
	s jsText=jsText_" * Copyright(c) 2006-2008, Ext JS, LLC."_cr
	s jsText=jsText_" * licensing@extjs.com"_cr
	s jsText=jsText_" * "_cr
	s jsText=jsText_" * http://extjs.com/license"_cr
	s jsText=jsText_" */"_cr_cr
	i attr("key")="unlicensed" d
	. s jsText=jsText_"/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */"_cr
	. s jsText=jsText_"/* ++++++++     Unlicensed copy of EWD/ExtJS Tag library        +++++++ */"_cr
	. s jsText=jsText_"/* +++++++ Purchase an ExtJS license + support and then contact +++++++ */"_cr
	. s jsText=jsText_"/* +++++++       M/Gateway for the unrestricted version         +++++++ */"_cr
	. s jsText=jsText_"/* +++++++            Email: rtweed@mgateway.com                +++++++ */"_cr
	. s jsText=jsText_"/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */"_cr_cr
	. s jsText=jsText_"alert('You must have a valid ExtJS license to use these custom tags!');"_cr
	s biURL=$g(attrs("blankImageURL"))
	i biURL="" s biURL=attrs("path")_"/resources/images/default/s.gif"
	s jsText=jsText_"Ext.BLANK_IMAGE_URL='"_biURL_"';"_cr
	s jsText=jsText_"Ext.onReady(function() {"_cr
	s jsText=jsText_"/*ext*/"_cr
	s jsText=jsText_"/*ext*/"_cr
	s jsText=jsText_"});"_cr
	s jsText=jsText_"EWD.ext.loadWindowFragment = function(fragmentName,targetId,dataStoreName,treeValue,currentPageName,nvp) {"_cr
	;s jsText=jsText_"  var targetId = id + 'Content' ;"_cr
    s jsText=jsText_"  if (!dataStoreName) dataStoreName='';"_cr
    s jsText=jsText_"  if (!treeValue) treeValue='';"_cr
	s jsText=jsText_"  if (document.getElementById(targetId).innerHTML=='Please wait...'){"_cr
	s jsText=jsText_"  if (typeof(nvp)!='undefined') {"_cr
	s jsText=jsText_"    if (nvp != '') nvp = nvp + '&' ;"_cr
	s jsText=jsText_"  }"_cr
	s jsText=jsText_"  else {"_cr
	s jsText=jsText_"    nvp='' ;"_cr
	s jsText=jsText_"  }"_cr
	s jsText=jsText_"  nvp = nvp + 'frag=' + fragmentName + '&ds=' + dataStoreName + '&tv=' + treeValue + '&cp=' + currentPageName ;"_cr
	s jsText=jsText_"  ewd.ajaxRequest(""zextDesktopWindowLoader"",targetId,nvp) ;"_cr
	s jsText=jsText_"  }"_cr
	s jsText=jsText_"  };"_cr
	s scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,jsText)
	;
	s dtOID=$$getTagOID^%zewdDOM("ext:desktop",docName)
	i dtOID'="" d setAttribute^%zewdDOM("path",$g(attrs("path")),dtOID)
	;
	d removeIntermediateNode^%zewdAPI(nodeOID)
	;
	s io=$io
	s fileName="zextDesktopWindowLoader"
	s filePath=inputPath_fileName_".ewd"
	i '$$openNewFile^%zewdCompiler(filePath) QUIT
	u filePath
	f lineNo=1:1 s x="s line=$t("_fileName_"+lineNo^%zewdExtJSCode)" x x q:line["***END***"  d
	. w $p(line,";;",2,1000),!
	c filePath
	u io
	s files(fileName_".ewd")=""
	;
	QUIT
	;
	;
grid(nodeOID,attrValues,docOID,technology)
	;
	; <ext:grid datastore="myData" title="My First Grid" width="500" frame="true">
	;
	n attr,cbno,checkboxObject,comboboxList,cr,datefieldList,divOID,editable
	n endText,fcOID
	n grid,gridObject,id,jsOID,live,mainAttrs,name,no,nullOID,objectList,olno
	n preText,reader,readerObject,startText,store,storeObject
	n tempOID,text,textOID,xname,xOID,widgetAttribs
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s cr=$c(13,10)
	s no=$$uniqueId^%zewdAPI(nodeOID,filename)
	s editable=0
	;
	i $g(mainAttrs("validationscript"))'="" d
	. n lineno,script
	. s script=mainAttrs("validationscript")
	. i technology="php" d
	. . s lineno=$o(phpHeaderArray(1,""),-1)+1
	. . s phpHeaderArray(1,lineno)="   $ewd_session[""ext_GridEditFunc""]["""_$g(mainAttrs("datastore"))_"""] = '"_script_"' ;"
	. i technology="wl"!(technology="ewd") d
	. . s lineno=$o(phpHeaderArray(1,""),-1)+1
	. . s phpHeaderArray(1,lineno)=" s sessionArray(""ext_GridEditFunc"","""_$g(mainAttrs("datastore"))_""")="""_script_""""
	. i technology="csp" d
	. . s lineno=$o(phpHeaderArray(1,""),-1)+1
	. . s phpHeaderArray(1,lineno)=" s extGridEditFunc("""_$g(mainAttrs("datastore"))_""")="""_script_""""
	;
	s id="extgrid"_no
	s attr("id")=id
	s attr("style")="text-align:left"
	i $g(mainAttrs("width"))'="" d
	. s attr("style")=attr("style")_";width:"_mainAttrs("width")
	. i mainAttrs("width")?1N.N s attr("style")=attr("style")_"px"
	. s mainAttrs("width")="auto"
	s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	s attr("style")="display:none"
	s nullOID=$$getElementById^%zewdDOM("gridNullId",docOID)
	i nullOID="" d
	. s attr("id")="gridNullId"
	. s nullOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	;
	s live="false"
	i $g(mainAttrs("liveupdate"))="true" d
	. d addSessionUpdatePage
	. s live="true"
	s storeObject="new Ext.data.Store>store"
	d getAttribs("Store",.widgetAttribs)
	d setAttribs(.store,.widgetAttribs,.mainAttrs)
	s store("data")="<?= "_$g(mainAttrs("datastore"))_" ?>"
	s store("reader")="<?= theReader"_no_" ?>"
	;
	s preText="EWD.ext.storeName= {};"_cr
	s textOID=$$updateExtJS(,,,docOID,preText)
	s preText="EWD.ext.storeName['grid"_no_"']="""_$g(mainAttrs("datastore"))_""";"_cr
	s textOID=$$updateExtJS(,,,docOID,preText)
	;
	s gridObject="new Ext.grid.GridPanel>grid"
	d getAttribs("GridPanel",.widgetAttribs)
	d setAttribs(.grid,.widgetAttribs,.mainAttrs)
	s grid("store")="<?= store"_no_" ?>"
	i $g(mainAttrs("autofill"))'="false" s grid("viewConfig","autoFill")="true"
	d gridCols(nodeOID,docOID,.grid,.readerObject,.reader,.editable)
	s grid("renderTo")=id
	i editable d
	. n line,lineNo,preText
	. s grid("clicksToEdit")=1
	. s gridObject="new Ext.grid.EditorGridPanel>grid"
	. ;s grid("listeners","afteredit","fn")="<?= function(e){e.cancel=!EWD.ext.updateStore("""_$g(mainAttrs("datastore"))_""",e.record.data[""col0""],e.field,e.value,"_live_");} ?>"
	. s grid("listeners","validateedit","fn")="<?= function(e){e.cancel=!EWD.ext.validateGridEdit("""_$g(mainAttrs("datastore"))_""",e,"_live_");} ?>"
	. s preText=""
	. f lineNo=1:1 s line=$t(updateSession+lineNo^%zewdExtJSCode) q:line["***END***"  d
	. . s preText=preText_$p(line,";;",2,200)_cr
	. s textOID=$$updateExtJS(,,,docOID,preText)
	;
	;s startText="EWD.utils.getObjectFromSession('"_$g(mainAttrs("datastore"))_"',true,true) ;"
	s startText=""
	s objectList(50)="var^readerObject^theReader"_no
	s objectList(51)="var^storeObject^store"_no
	s objectList(52)="var^gridObject^grid"_no
	s cbno="",olno=0
	f  s cbno=$o(checkboxObject(cbno)) q:cbno=""  d
	. s olno=olno+1
	. s objectList(olno)="var^checkboxObject"_cbno_"^checkBox"_cbno
	. i checkboxObject(cbno)="editable" s grid("plugins",olno)="<?= checkBox"_cbno_" ?>"
	i 'editable d
	. s endText=""
	. i $g(mainAttrs("selectfirstrow"))="true" d
	. . s endText="grid"_no_".getSelectionModel().selectFirstRow();"
	. i $g(mainAttrs("selectrow"))'="" d
	. . s endText="grid"_no_".getSelectionModel().selectRow("_(mainAttrs("selectrow"))_"-1);"
	. i $g(mainAttrs("onrowselect"))'="" d
	. . n lt
	. . s lt="<"
	. . i isAjax s lt="&lt;"
	. . s endText=endText_cr_"EWD.ext.rowEventHandler"_no_"=function(selectionModel, rowIndex, selectedRecord) {"
	. . s endText=endText_cr_"var currentRow = new Array();"
	. . s endText=endText_cr_"for (var col=0;col"_lt_"selectedRecord.fields.length;col++) {"
	. . s endText=endText_cr_"currentRow[col] = selectedRecord.get(selectedRecord.fields.keys[col]) ;"
	. . s endText=endText_cr_"}"
	. . s endText=endText_cr_mainAttrs("onrowselect")_"(currentRow[0] + 1,currentRow) ;"
	. . s endText=endText_cr_"};"
	. . s endText=endText_cr_"grid"_no_".getSelectionModel().on('rowselect',EWD.ext.rowEventHandler"_no_");"
	;
	s textOID=$$updateExtJS(startText,$g(endText),.objectList,docOID)
	; 
	;<ewd:execute method="xyz^myRoutine" param1="abc" param2="$x" param3="#y" type="function" return="$status">
	s attr("method")="writeObjectAsJSON^%zewdCompiler19"
	s attr("param1")=$g(mainAttrs("datastore"))
	s attr("param2")=1
	s attr("param3")=1
	i isAjax s attr("param3")=0
	s attr("param4")="#ewd_sessid"
	s attr("type")="procedure"
	;
	i isAjax d
	. n attrx,mjsOID
	. s attrx("id")="moveToJS"
	. s mjsOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attrx)
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",mjsOID,,.attr)
	e  d
	. s jsOID=$$getElementById^%zewdDOM("extjs",docOID)
	. i jsOID="" d
	. . s jsOID=$$getTagOID^%zewdAPI("script",docName)
	. . i jsOID="" s jsOID=$$addJavascriptFunction^%zewdAPI(docName,.jsArray)
	. s tempOID=$$createElement^%zewdDOM("temp",docOID)
	. s tempOID=$$insertBefore^%zewdDOM(tempOID,jsOID)
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",tempOID,,.attr)
	. d removeIntermediateNode^%zewdDOM(tempOID)
	;
	d removeIntermediateNode^%zewdDOM(nodeOID)
	k checkColumn,numberfield,textfield
	s cbno=""
	f  s cbno=$o(checkboxObject(cbno)) q:cbno=""  d
	. k @("checkbox"_cbno),@("checkboxObject"_cbno)
	s cbno=""
	f  s cbno=$o(comboboxList(cbno)) q:cbno=""  d
	. k @("combobox"_cbno)
	f  s cbno=$o(datefieldList(cbno)) q:cbno=""  d
	. k @("datefield"_cbno)
	;
	QUIT
	;
gridCols(nodeOID,docOID,grid,readerObject,reader,editable)
	;
	n addCheckbox,attr,attrs,childNo,childOID,column,index,OIDArray
	n sOID,tagName,type,widgetAttribs
	;
	i $$hasChildNodes^%zewdDOM(nodeOID)'="true" QUIT
	;
	s readerObject="new Ext.data.ArrayReader>reader"
	s reader="<mixed>"
	s reader(1)="<?= {} ?>"
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	d getAttribs("ColumnModel",.widgetAttribs)
	s childNo="",addCheckbox=0
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ext:gridcolumn" q
	. k attrs,checkColumn,column
	. d getAttributeValues^%zewdCustomTags(childOID,.attrs)
	. d setAttribs(.column,.widgetAttribs,.attrs)
	. i $g(attrs("editas"))'="" d
	. . n editAs
	. . s editable=1
	. . s editAs=$g(attrs("editas"))
	. . i editAs="text" d
	. . . s grid("columns",childNo,"editor")="new Ext.form.TextField>textfield"
	. . . s textfield("allowBlank")="<?= false ?>"
	. . i editAs="number" d
	. . . s grid("columns",childNo,"editor")="new Ext.form.NumberField>numberfield"
	. . . s numberfield("allowBlank")="<?= false ?>"
	. . . s numberfield("allowNegative")="<?= false ?>"
	. . . s numberfield("maxValue")="100000"
	. . i editAs="date" d
	. . . n datefield
	. . . s grid("columns",childNo,"editor")="new Ext.form.DateField>datefield"_childNo
	. . . s datefield("format")=$g(attrs("dateformat"))
	. . . i $g(attrs("disableddays"))'="" s datefield("disabledDays")=attrs("disableddays")
	. . . i $g(attrs("disableddaystext"))'="" s datefield("disabledDaysText")=attrs("disableddaystext")
	. . . m @("datefield"_childNo)=datefield
	. . . s datefieldList(childNo)=""
	. . i editAs="select" d
	. . . n combobox
	. . . s grid("columns",childNo,"editor")="new Ext.form.ComboBox>combobox"_childNo
	. . . s combobox("typeAhead")="<?= true ?>"
	. . . s combobox("triggerAction")="all"
	. . . s combobox("transform")=$g(attrs("name"))
	. . . s combobox("lazyRender")="<?= true ?>"
	. . . s combobox("listClass")="x-combo-list-small"
	. . . m @("combobox"_childNo)=combobox
	. . . s comboboxList(childNo)=""
	. . . s attr("name")=$g(attrs("name"))
	. . . s attr("style")="display:none"
	. . . s sOID=$$addElementToDOM^%zewdDOM("select",nodeOID,,.attr)
	. i $g(attrs("renderas"))="checkbox"!($g(attrs("editas"))="checkbox") d
	. . n checkbox,ix,preText,textOID
	. . s addCheckbox=1
	. . s ix=$p(childOID,"-",2)
	. . s grid("columns",childNo)="<?= checkBox"_ix_" ?>"
	. . s @("checkboxObject"_ix)="new Ext.grid.CheckColumn>checkbox"_ix
	. . s checkboxObject(ix)=""
	. . i $g(attrs("editas"))="checkbox" s checkboxObject(ix)="editable",editable=1
	. . m checkbox=column
	. . s index="col"_ix
	. . s checkbox("dataIndex")=index
	. . m @("checkbox"_ix)=checkbox
	. . ;s preText="EWD.ext.columnIndex["""_index_"""] = "_childNo_" ;"_$c(13,10)
	. . ;s textOID=$$updateExtJS(,,,docOID,preText)
	. e  d
	. . m grid("columns",childNo)=column
	. . s index="col"_$p(childOID,"-",2)
	. . s grid("columns",childNo,"dataIndex")=index
	. i editable d
	. . s preText="EWD.ext.columnIndex["""_index_"""] = "_childNo_" ;"_$c(13,10)
	. . s textOID=$$updateExtJS(,,,docOID,preText)
	. s reader(2,childNo,"name")=index
	. s type=$g(attrs("type"))
	. i type'="" d
	. . s reader(2,childNo,"type")=type
	. . i type="date" d
	. . . i $g(attrs("dateformat"))'="" d
	. . . . s reader(2,childNo,"dateFormat")=attrs("dateformat")
	. . . . s grid("columns",childNo,"renderer")="<?= Ext.util.Format.dateRenderer('"_attrs("dateformat")_"') ?>"
	. d removeIntermediateNode^%zewdDOM(childOID)
	s grid("columns",0,"dataIndex")="col0"
	s grid("columns",0,"hidden")="true"
	s grid("columns",0,"hideable")="false"
	s reader(2,0,"name")="col0"
	i addCheckbox d
	. n line,lineNo,preText,textOID
	. s preText=""
	. f lineNo=1:1 s line=$t(gridCheckbox+lineNo^%zewdExtJSCode) q:line["***END***"  d
	. . s preText=preText_$p(line,";;",2,200)_cr
	. . i isAjax d
	. . . s preText=$$replaceAll^%zewdAPI(preText,"<","&lt;")
	. . . s preText=$$replaceAll^%zewdAPI(preText,">","&gt;")
	. s textOID=$$updateExtJS(,,,docOID,preText)
	QUIT
	;
	;updateSession(sessid)
    ;
updateSession(sessionName,row,column,value)
	;
    n array,browser,error,oldValue,rou
    ;
    d setSessionValue^%zewdAPI("extGridDatastore",sessionName,sessid)
    d setSessionValue^%zewdAPI("extGridRow",row+1,sessid)
    d setSessionValue^%zewdAPI("extGridColumn",column,sessid)
    ;d trace^%zewdAPI("date value="_value)
	s browser=$$getSessionValue^%zewdAPI("ewd.browserType",sessid)
	i browser="ie6"!(browser="ie7") d
	. i value?3A1" "3A1" "1N.E,value["00:00:00" d
	. . ;d trace^%zewdAPI("converting date..")
	. . s value=$$convertToHDate(value,1)
	. . ;d trace^%zewdAPI("ie6: "_value)
	e  d
	. i value?3A1" "3A1" "1N.E,value["00:00:00" d
	. . ;d trace^%zewdAPI("non-IE converting date...")
	. . s value=$$convertToHDate(value,0)
	. . ;d trace^%zewdAPI("others: "_value)
    d setSessionValue^%zewdAPI("extGridValue",value,sessid)
    i $$JSONAccess^%zewdAPI(sessionName,sessid)'="rw" QUIT "EWD.ext.error='Unauthorised access';"
    d mergeArrayFromSession^%zewdAPI(.array,sessionName,sessid)
    s oldValue=$g(array(row+1,column))
    d setSessionValue^%zewdAPI("extGridOriginalValue",oldValue,sessid)
    s array(row+1,column)=value
    d mergeArrayToSession^%zewdAPI(.array,sessionName,sessid)
	s rou=$$getSessionArrayValue^%zewdAPI("ext.GridEditFunc",sessionName,sessid)
	s error=""
	i rou'="" d
	. i rou["class(" d
	. . s rou="s error=##"_rou
	. e  d
	. . s rou="s error=$$"_rou
	. i rou'["(sessid)" s rou=rou_"(sessid)"
	. x rou
    ;
    i error["'" d
    . s error=$$replaceAll^%zewdAPI(error,"'",$c(1))
    . s error=$$replaceAll^%zewdAPI(error,$c(1),"\'")
    i error'="" d
    . s array(row+1,column)=oldValue
    . d mergeArrayToSession^%zewdAPI(.array,sessionName,sessid)    
	QUIT "EWD.ext.error='"_error_"';"
	;
convertToHDate(extjsDate,isIE)
	;
	n dd,mmm,yyyy
	;
	s dd=$p(extjsDate," ",3)
	s mmm=$p(extjsDate," ",2)
	i isIE d
	. n np
	. s np=$l(extjsDate," ")
	. s yyyy=$p(extjsDate," ",np)
	e  d
	. s yyyy=$p(extjsDate," ",4)
	s date=dd_" "_mmm_" "_yyyy
	s date=$$encodeDate^%zewdGTM(date)
	QUIT date
	;
addSessionUpdatePage
	;
	n fileName,filePath,io,line,lineNo,x
	;
	q:'$d(files)
	s io=$io
	f fileName="zextUpdateSession" d
	. s filePath=inputPath_fileName_".ewd"
	. i '$$openNewFile^%zewdCompiler(filePath) QUIT
	. u filePath
	. f lineNo=1:1 s x="s line=$t("_fileName_"+lineNo^%zewdExtJSCode)" x x q:line["***END***"  d
	. . w $p(line,";;",2,1000),!
	. c filePath
	. u io
	. s files(fileName_".ewd")=""
	QUIT
	;
updateExtJS(startText,endText,objectList,docOID,preText,postText,insertAtTop,moveFromOnReady)
	;
	n array,cr,d,dlim,jsText,jsTextArr,newJSText,objectNo
	n p0,p1,p2,p3,scriptOID,textOID,var,varText
	;
	s cr=$c(13,10)
	s scriptOID=$$getElementById^%zewdDOM("extjs",docOID)
	i scriptOID="" d
	. i 'isAjax q
	. ; use <script language="javascript"> tag as target
	. ; create script tag if necessary
	. n hasText,language,ntags,OIDArray,stop
	. s ntags=$$getTagsByName^%zewdCompiler("script",docName,.OIDArray)
	. s scriptOID="",stop=0
	. f  s scriptOID=$o(OIDArray(scriptOID)) q:scriptOID=""  d  q:stop
	. . s language=$$getAttribute^%zewdDOM("language",scriptOID)
	. . i $$zcvt^%zewdAPI(language,"l")="javascript" s stop=1
	. i scriptOID="" s scriptOID=$$addJavascriptFunction^%zewdAPI(docName,.jsArray)
	. s jsText=$$getElementText^%zewdDOM(scriptOID,.jsTextArr)
	. i $g(preText)'="",jsText[preText q
	. s hasText=1
	. i jsText="" s hasText=0
	. i jsText'["/*ext*/" d
	. . s jsText=jsText_"Ext.onReady(function() {"_cr
	. . s jsText=jsText_"/*ext*/"_cr
	. . s jsText=jsText_"/*ext*/"_cr
	. . s jsText=jsText_"});"_cr
	. . i $$license()="unlicensed" d
	. . . s jsText=jsText_cr_"/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */"_cr
	. . . s jsText=jsText_"/* ++++++++     Unlicensed copy of EWD/ExtJS Tag library        +++++++ */"_cr
	. . . s jsText=jsText_"/* +++++++ Purchase an ExtJS license + support and then contact +++++++ */"_cr
	. . . s jsText=jsText_"/* +++++++       M/Gateway for the unrestricted version         +++++++ */"_cr
	. . . s jsText=jsText_"/* +++++++            Email: rtweed@mgateway.com                +++++++ */"_cr
	. . . s jsText=jsText_"/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */"_cr_cr
	. . . s jsText=jsText_"alert('You must have a valid ExtJS license to use these custom tags!');"_cr
	. . i hasText d
	. . . s textOID=$$modifyElementText^%zewdDOM(scriptOID,jsText)
	. . e  d
	. . . s textOID=$$createTextNode^%zewdDOM(jsText,docOID)
	. . . s textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
	;
	s newJSText=""
	i $g(startText)'="" s newJSText=startText_cr
	;
	s objectNo=""
	f  s objectNo=$o(objectList(objectNo)) q:objectNo=""  d
	. s d=objectList(objectNo)
	. s varText=$p(d,"^",1)
	. i varText'="" s varText=varText_" "
	. s array=$p(d,"^",2)
	. s var=$p(d,"^",3)
	. i var'="" s newJSText=newJSText_varText_var_"="
	. s newJSText=newJSText_$$convertToJSON^%zewdAPI(array,1)_";"_cr
	i $g(endText)'="" s newJSText=newJSText_endText_cr
	;
	s jsText=$$getElementText^%zewdDOM(scriptOID,.jsTextArr)
	s dlim="/*ext*/"
	s p1=$p(jsText,dlim,1)
	s p2=$p(jsText,dlim,2)
	s p3=$p(jsText,dlim,3)
	i $g(moveFromOnReady)=1 d  QUIT textOID
	. s p0=$p(p1,"Ext.onReady",1)
	. s p1="Ext.onReady"_$p(p1,"Ext.onReady",2,200)
	. s jsText=p0_p2_p1_dlim_$c(13,10)_dlim_p3
	. s textOID=$$modifyElementText^%zewdDOM(scriptOID,jsText)
	i newJSText'="" d
	. i $g(insertAtTop)=1 s p2=$c(13,10)_newJSText_p2
	. e  s p2=p2_newJSText
	i $g(preText)'="" d
	. n a1,a2,sig
	. q:jsText[preText
	. s sig="Ext.onReady("
	. s a1=$p(p1,sig,1)
	. s a2=$p(p1,sig,2,200)
	. s p1=a1_preText_sig_a2
	s jsText=p1_dlim_p2_dlim
	i $g(postText)'="" s p3=cr_postText_p3
	s jsText=jsText_p3
	s textOID=$$modifyElementText^%zewdDOM(scriptOID,jsText)
	QUIT textOID
	;
widget(thisOID,attrValues,docOID,technology)
	;
	n nodeOID
	;
	s nodeOID=$$getOuterExtTag(thisOID)
	i $$widget^%zewdExtJS2(nodeOID,docOID)
	QUIT
	;
getOuterExtTag(nodeOID)
	;
	n parentOID,stop,tagName,thisOID
	;
	s thisOID=nodeOID
	s stop=0
	f  d  q:stop
	. s parentOID=$$getParentNode^%zewdDOM(thisOID)
	. s tagName=$$getTagName^%zewdDOM(parentOID)
	. i tagName["ext:" s thisOID=parentOID q
	. s stop=1
	QUIT thisOID
	;
panel(nodeOID,attrValues,docOID,technology)
	;
	; <ext:panel frame="true" title="Actions" collapsible="true" titleCollapse="true">
	;
	i $$widget^%zewdExtJS2(nodeOID,"panel",docOID)
	QUIT
	;
	n attr,cr,d,divOID,id,mainAttrs,no,objectList,p1,p2,panel,panelObject
	n text,textOID,type,viewport,viewportObject,widgetAttribs
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s cr=$c(13,10)
	s no=$$uniqueID^%zewdAPI(nodeOID,filename)
	;
	s id=$g(mainAttrs("id"))
	i id="" s id="extpanel"_no
	s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
	d setAttribute^%zewdDOM("id",id,divOID)
	;
	s panelObject="new Ext.Panel>panel"
	d getAttribs("Panel",.widgetAttribs)
	d setAttribs(.panel,.widgetAttribs,.mainAttrs)
	s panel("contentEl")=id
	;
	s objectList(1)="var^panelObject^panel"_no
	i $g(mainAttrs("inwindow"))'="true" d
	. s viewportObject="new Ext.Viewport>viewport"
	. s viewport("items",1)="<?= panel"_no_" ?>"
	. s objectList(2)="^viewportObject^viewport"
	s textOID=$$updateExtJS(,,.objectList,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
tabPanel(nodeOID,attrValues,docOID,technology)
	;
	; <ext:tabPanel region="center">
	;
	n attr,cr,d,divOID,id,mainAttrs,no,objectList,p1,p2,panel,panelObject
	n text,textOID,type,viewport,viewportObject,widgetAttribs
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s cr=$c(13,10)
	s no=$$uniqueId^%zewdAPI(nodeOID,filename)
	;
	s id=$g(mainAttrs("id"))
	i id="" s id="exttabpanel"_no
	;
	s panelObject="new Ext.TabPanel>panel"
	d getAttribs("TabPanel",.widgetAttribs)
	d setAttribs(.panel,.widgetAttribs,.mainAttrs)
	s panel("renderTo")=id
	;
	;
	d tabPanelTabs(nodeOID,.panel,docOID)
	s objectList(1)="var^panelObject^panel"_no
	s textOID=$$updateExtJS(,,.objectList,docOID)
	;
	s attr("id")=id
	s divOID=$$addElementToDOM^%zewdDOM("span",nodeOID,,.attr)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
tabPanelTabs(nodeOID,array,docOID)
	;
	n attrs,childNo,childOID,height,id,OIDArray,panelTabs,tabNo,widgetAttribs
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo="",tabNo=-1
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ext:tab" q
	. s tabNo=tabNo+1
	. d getAttributeValues^%zewdCustomTags(childOID,.attrs) 
	. i $g(attrs("autoscroll"))'="" s array("items",1,"zobj"_childNo,"autoScroll")=attrs("autoScroll")
	. i $g(attrs("closable"))="true" s array("items",1,"zobj"_childNo,"closable")="<?= "_attrs("closable")_" ?>"
	. i $g(attrs("title"))'="" s array("items",1,"zobj"_childNo,"title")=attrs("title")
	. s height=$g(attrs("height"))
	. i height="" s height=800
	. s array("items",1,"zobj"_childNo,"height")=height
	. i $g(attrs("autoload"))'="" s array("items",1,"zobj"_childNo,"autoLoad")=attrs("autoload")
	. s id="tab"_$p(nodeOID,"-",2)_"t"_tabNo
	. i $g(attrs("active"))="true" s array("activeItem")=tabNo
	. s array("items",1,"zobj"_childNo,"html")="&lt;span id='"_id_"Content'&gt;Please wait...&lt;/span&gt;"
	. i $g(attrs("src"))'="" d
	. . n endText,page,tabOID,textOID,xattr
	. . s array("items",1,"zobj"_childNo,"listeners","activate","fn")="<?= function(e){EWD.ext.populateTab"_childNo_"("""_id_"Content"");} ?>"
	. . s page=$p(attrs("src"),".ewd",1)
	. . s endText="EWD.ext.populateTab"_childNo_" = function(targetId) {try {  if (document.getElementById(targetId).innerHTML == 'Please wait...'){ewd.ajaxRequest('"_page_"',targetId) ;}}catch(err) {return}};"_$c(13,10)
	. . ;s endText="ewd.ajaxRequest('"_page_"','"_id_"Content') ;"
	. . s textOID=$$updateExtJS(,,,docOID,endText)
	. i $g(attrs("onselect"))'="" d
	. . n func
	. . s func=attrs("onselect")
	. . s array("items",1,"zobj"_childNo,"listeners","activate","fn")="<?= function(e){"_attrs("onselect")_"("""_id_""");} ?>"
	. . i $$getElementById^%zewdDOM(id,docOID)="" d
	. . . n tabOID,xattr
	. . . s xattr("id")=id
	. . . s tabOID=$$addElementToDOM^%zewdDOM("div",childOID,,.xattr,"&nbsp;")
	. d removeIntermediateNode^%zewdDOM(childOID)
	;
	QUIT
	;
viewport(nodeOID,attrValues,docOID,technology)
	;
	; <ext:viewport>
	;
	n array,i,mainAttrs,noOfChildArrays,objectList
	n textOID,viewport,viewportObject,widgetAttribs
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s viewportObject="new Ext.Viewport>viewport"
	d getAttribs("Viewport",.widgetAttribs)
	d setAttribs(.viewport,.widgetAttribs,.mainAttrs)
	s noOfChildArrays=$$getViewportChildren(.viewport,nodeOID,docOID)
	s objectList(1)="^viewportObject^viewport"
	s textOID=$$updateExtJS(,,.objectList,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	f i=1:1:noOfChildArrays d
	. s array="child"_i
	. k @array
	;
	QUIT
	;
getViewportChildren(viewport,nodeOID,docOID)
	;
	n attrs,childNo,childOID,no,OIDArray
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo="",no=0
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s no=no+1
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName="ext:panel" d vpPanel("panel",childOID,.viewport,childNo,docOID)
	. i tagName="ext:tabpanel" d vpTabPanel(childOID,.viewport,childNo,docOID)
	. i tagName="ext:accordionpanel" d vpPanel("accordion",childOID,.viewport,childNo,docOID)
	. d removeIntermediateNode^%zewdDOM(childOID)
	;
	QUIT no
	;
vpPanel(type,nodeOID,viewport,childNo,docOID)
	;
	n attrs,divOID,id,widgetAttribs,xtra
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	;
	s array="child"_childNo
	i childNo'=99999 s viewport("items",childNo)="new Ext.Panel>"_array
	d getAttribs("Panel",.widgetAttribs)
	;s id=$g(attrs("id"))
	;i id="" s id="tab"_$p(nodeOID,"-",2)
	s id="tab"_$p(nodeOID,"-",2)
	;k attrs("id")
	i $g(attrs("region"))="north" s attrs("el")=id
	i $g(attrs("region"))="south" s attrs("contentel")=id
	i childNo'=99999,$g(attrs("src"))'="" d
	. n endText,nvp,page,tabOID,textOID,xattr
	. s attrs("contentel")=id
	. s page=$p(attrs("src"),".ewd",1)
	. s nvp=$p(attrs("src"),"?",2)
	. s endText="ewd.ajaxRequest('"_page_"','"_id_"','"_nvp_"') ;"
	. s textOID=$$updateExtJS(,,,docOID,,endText)
	;
	d setAttribs(.@array,.widgetAttribs,.attrs)
	i childNo=99999,$g(attrs("src"))'="" d
	. n event,textOID
	. s xtra("html")="<span id='"_id_"Content'>Please wait...</span>"
	. s event="expand"
	. i $g(isFirstPanel) s event="resize",isFirstPanel=0
	. s xtra("listeners",event,"fn")="<?= function(e){EWD.ext.populateTab"_id_"("""_id_"Content"");} ?>"
	. m @array=xtra
	. s page=$p(attrs("src"),".ewd",1)
	. s endText="EWD.ext.populateTab"_id_" = function(targetId) {try {  if (document.getElementById(targetId).innerHTML == 'Please wait...'){ewd.ajaxRequest('"_page_"',targetId) ;}}catch(err) {return}};"_$c(13,10)
	. s textOID=$$updateExtJS(,,,docOID,endText)
	;
	i type="accordion" d
	. n temp
	. s temp("layout")="accordion"
	. s temp("layoutConfig","zobj1","animate")="<?= true ?>"
	. m @array=temp
	. d accordionItems(nodeOID,.@array,docOID)
	;
	s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
	d setAttribute^%zewdDOM("id",id,divOID)
	;
	QUIT
	;
accordionItems(nodeOID,panelArray,docOID)
	;
	n childNo,childOID,isFirstPanel,no,OIDArray,tagName
	;
	i $g(attrs("datastore"))'="" d  QUIT
	. s panelArray("items",1)="<?= EWD.ext.panelItems ?>"
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo="",no=0,isFirstPanel=1
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s no=99999
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName="ext:panel" d vpPanel("panel",childOID,.viewport,no,docOID)
	. m panelArray("items",1,"zobj"_childNo)=child99999
	. d removeIntermediateNode^%zewdDOM(childOID)
	. k child99999
	;
	QUIT
	;
vpTabPanel(nodeOID,viewport,childNo,docOID)
	;
	n attrs,divOID,widgetAttribs
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	;
	s array="child"_childNo
	s viewport("items",childNo)="new Ext.TabPanel>"_array
	d getAttribs("TabPanel",.widgetAttribs)
	d setAttribs(.@array,.widgetAttribs,.attrs)
	;
	d vpTabs(nodeOID,.@array,docOID)
	;
	s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
	d setAttribute^%zewdDOM("id",attrs("region"),divOID)
	;
	QUIT
	;
vpTabs(nodeOID,array,docOID)
	;
	n attrs,childNo,childOID,id,OIDArray,tab,tabNo,widgetAttribs
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo="",tabNo=-1
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ext:tab" q
	. s tabNo=tabNo+1
	. d getAttributeValues^%zewdCustomTags(childOID,.attrs)
	. d getAttribs("TabPanel",.widgetAttribs)
	. d setAttribs(.tab,.widgetAttribs,.attrs)
	. m array("items",1,"zobj"_childNo)=tab
	. ;i $g(attrs("autoscroll"))'="" s array("items",1,"zobj"_childNo,"autoScroll")=attrs("autoScroll")
	. i $g(attrs("closable"))="true" s array("items",1,"zobj"_childNo,"closable")="<?= "_attrs("closable")_" ?>"
	. ;i $g(attrs("title"))'="" s array("items",1,"zobj"_childNo,"title")=attrs("title")
	. ;i $g(attrs("autoload"))'="" s array("items",1,"zobj"_childNo,"autoLoad")=attrs("autoload")
	. s id="tab"_$p(nodeOID,"-",2)_"t"_tabNo
	. i $g(attrs("active"))="true" s array("activeItem")=tabNo
	. s array("items",1,"zobj"_childNo,"contentEl")=id
	. i $g(attrs("src"))'="" d
	. . n endText,page,tabOID,textOID,xattr
	. . s page=$p(attrs("src"),".ewd",1)
	. . s endText="ewd.ajaxRequest('"_page_"','"_id_"') ;"
	. . s textOID=$$updateExtJS(,,,docOID,,endText)
	. . s xattr("id")=id
	. . s tabOID=$$addElementToDOM^%zewdDOM("div",childOID,,.xattr,"&nbsp;")
	. i $g(attrs("onselect"))'="" d
	. . n func
	. . s func=attrs("onselect")
	. . s array("items",1,"zobj"_childNo,"listeners","activate","fn")="<?= function(e){"_attrs("onselect")_"("""_id_""");} ?>"
	. . i $$getElementById^%zewdDOM(id,docOID)="" d
	. . . n tabOID,xattr
	. . . s xattr("id")=id
	. . . s tabOID=$$addElementToDOM^%zewdDOM("div",childOID,,.xattr,"&nbsp;")
	. d removeIntermediateNode^%zewdDOM(childOID)
	;
	;
	QUIT
	;
toolbar(nodeOID,attrValues,docOID,technology)
	;
	; <ext:toolbar>
	;
	n attrs,id,mainAttrs,noOfChildArrays,objectList,textOID,toolbar,toolbarObject
	n varName,widgetAttribs,xOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s id=$g(mainAttrs("id"))
	i id="" s id="tb"_$p(nodeOID,"-",2)
	s mainAttrs("id")="x"_id
	s mainAttrs("renderto")=id
	;
	s toolbarObject="new Ext.Toolbar>toolbar"
	d getAttribs("Toolbar",.widgetAttribs)
	d setAttribs(.toolbar,.widgetAttribs,.mainAttrs)
	s varName="toolbar"_$p(nodeOID,"-",2)
	s objectList(1)="var^toolbarObject^"_varName
	s textOID=$$updateExtJS(,,.objectList,docOID)
	s noOfChildArrays=$$getToolbarChildren(nodeOID,docOID,varName)
	s xOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
	d setAttribute^%zewdDOM("id",$g(mainAttrs("renderto")),xOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
getToolbarChildren(nodeOID,docOID,tbName)
	;
	n childNo,childOID,no,OIDArray,tagName
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo="",no=0
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s no=no+1
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName="ext:menu" d
	. . d tbMenu(childOID,childNo,docOID,tbName)
	. . d removeIntermediateNode^%zewdDOM(childOID)
	;
	QUIT no
	;
tbMenu(nodeOID,childNo,docOID,tbName)
	;
	n attrs,button,buttonObject,divOID,id,menu,menuObject,ref,textOID,widgetAttribs
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	;
	s buttonObject=tbName_".add>button"
	s button("text")=$g(attrs("text"))
	s button("menu")="new Ext.menu.Menu>menu"
	s menu("id")="menu"_$p(nodeOID,"-",2)
	s ref="menu(""items"",1,"
	d getTbMenuOptions(nodeOID,docOID,.menu,ref)
	s objectList(1)="^buttonObject^"
	s textOID=$$updateExtJS(,,.objectList,docOID)
	;
	QUIT
	;
getTbMenuOptions(nodeOID,docOID,menu,ref)
	;
	n attrs,childNo,childOID,menux,no,OIDArray,optNo,tagName,widgetAttribs,x
	;
	QUIT:'$$hasChildNodes^%zewdDOM(nodeOID)="true"
	;
	s optNo=0
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo=""
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. k attrs,menux,widgetAttribs
	. s childOID=OIDArray(childNo)
	. s optNo=optNo+1
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName'="ext:menuoption" q
	. d getAttributeValues^%zewdCustomTags(childOID,.attrs)
	. d getAttribs("MenuItem",.widgetAttribs)
	. d setAttribs(.menux,.widgetAttribs,.attrs)
	. s x="m "_ref_"""zobj""_optNo)=menux"
	. x x
	. i $$hasChildNodes^%zewdDOM(childOID)="true" d
	. . n xref
	. . s xref=ref_"""zobj"_optNo_""",""menu"",""zobj"_optNo_""",""items"",1,"
	. . d getTbMenuOptions(childOID,docOID,.menu,xref)
	. d removeIntermediateNode^%zewdDOM(childOID)
	QUIT
	;
desktop(nodeOID,attrValues,docOID,technology)
	;
	; <ext:desktop>
	;
	n appObject,attr,attrs,bgImage,bodyOID,divOID,endText,extPath
	n fileName,filePath,fn,funcStr
	n id,io,lib,line,lineNo,mainAttrs,noOfWindows,objectList
	n path,shortcutOID,scriptOID,sOID,textOID,tmpOID,toolbar,toolbarObject
	n varName,widgetAttribs,x,xOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s bgImage=$g(mainAttrs("backgroundimage"))
	i bgImage'="" d
	. n bodyOID
	. s bodyOID=$$getTagOID^%zewdDOM("body",docName)
	. d setAttribute^%zewdDOM("style","background:url("_bgImage_");background-position:bottom right",bodyOID)
	;
	s sOID=$$getElementById^%zewdDOM("extjs",docOID)
	s tmpOID=$$createElement^%zewdDOM("temp",docOID)
	s tmpOID=$$insertBefore^%zewdDOM(tmpOID,sOID)
	s path=mainAttrs("path")
	s extPath=path
	i $e(path,$l(path))'="/" s path=path_"/"
	s path=path_"desktop/"
	f lib="Module","App","Desktop","TaskBar","StartMenu" d
	f lib="StartMenu","TaskBar","Desktop","App","Module" d
	. s attr("type")="text/javascript"
	. s attr("src")=path_lib_".js"
	. s scriptOID=$$addElementToDOM^%zewdDOM("script",tmpOID,,.attr)
	s attr("rel")="stylesheet"
	s attr("type")="text/css"
	s attr("href")=path_"desktop.css"
	s scriptOID=$$addElementToDOM^%zewdDOM("link",tmpOID,,.attr)
	s attr("type")="text/css"
	s attr("id")="dtStyles"
	s scriptOID=$$addElementToDOM^%zewdDOM("style",tmpOID,,.attr)
	d removeIntermediateNode^%zewdDOM(tmpOID)
	;
	s bodyOID=$$getTagOID^%zewdDOM("body",docName)
	d setAttribute^%zewdDOM("scroll","no",bodyOID)
	;
	s attr("id")="x-desktop"
	s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	s attr("id")="x-shortcuts"
	s shortcutOID=$$addElementToDOM^%zewdDOM("dl",divOID,,.attr)
	;
	s attr("id")="ux-taskbar"
	s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	s attr("id")="ux-taskbar-start"
	s xOID=$$addElementToDOM^%zewdDOM("div",divOID,,.attr)
	s attr("id")="ux-taskbuttons-panel"
	s xOID=$$addElementToDOM^%zewdDOM("div",divOID,,.attr)
	s attr("class")="x-clear"
	s xOID=$$addElementToDOM^%zewdDOM("div",divOID,,.attr)
	;
	s noOfWindows=$$getdesktopChildren(nodeOID,docOID,shortcutOID)
	;
	s fn="return ["
	f i=1:1:noOfWindows d
	. s fn=fn_"new theDesktop.window"_i_"(),"
	s fn=fn_"new theDesktop.adhocModule()];"
	;s fn=$e(fn,1,$l(fn)-1)_"];"
	s fn="function(){"_fn_"}"
	s app("getModules")="<?= "_fn_" ?>"
	s config("title")=$g(mainAttrs("title"))
	s config("iconCls")=$g(mainAttrs("iconclass"))
	i config("iconCls")="" s config("iconCls")="user"
	s config("toolItems",1,"zobj1","text")="Logout"
	s config("toolItems",1,"zobj1","iconCls")="logout"
	s config("toolItems",1,"zobj1","scope")="<?= this ?>"
	s funcStr="{fn:function(e){document.location.href='ewdLogout.ewd' ;}}"
	s config("toolItems",1,"zobj1","listeners","zobj3","click")="<?= "_funcStr_" ?>"
	s funcStr=$$convertToJSON^%zewdAPI("config",1)
	s funcStr="return "_funcStr_";"
	s funcStr="function(){"_funcStr_"}"
	s app("getStartConfig")="<?= "_funcStr_" ?>"
	s appObject="new Ext.app.App>app"
	s objectList(1)="^appObject^theDesktop"
	s textOID=$$updateExtJS(,,.objectList,docOID,,,1)
	;
	s endText="var windowIndex = "_noOfWindows_";"_$c(13,10)
	f lineNo=1:1 s line=$t(desktop+lineNo^%zewdExtJSCode) q:line["***END***"  d
	. s endText=endText_$p(line,";;",2,200)_$c(13,10)
	s textOID=$$updateExtJS(,endText,,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	q:'$d(files)
	s io=$io
	f fileName="zextDesktopWindowLoader" d
	. s filePath=inputPath_fileName_".ewd"
	. i '$$openNewFile^%zewdCompiler(filePath) QUIT
	. u filePath
	. f lineNo=1:1 s x="s line=$t("_fileName_"+lineNo^%zewdExtJSCode)" x x q:line["***END***"  d
	. . w $p(line,";;",2,1000),!
	. c filePath
	. u io
	. s files(fileName_".ewd")=""
	;
	s textOID=$$updateExtJS(,,,docOID,,,,1)
	;
	QUIT
	;
getdesktopChildren(nodeOID,docOID,shortcutOID)
	;
	n childNo,childOID,no,OIDArray,tagName
	;
	d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	s childNo="",no=0
	f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. s childOID=OIDArray(childNo)
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. i tagName="ext:window" d
	. . s no=no+1
	. . ;d dtWindow(childOID,childNo,docOID,shortcutOID)
	. . d dtWindow(childOID,no,docOID,shortcutOID)
	. . d removeIntermediateNode^%zewdDOM(childOID)
	. . ;s no=no+1
	. i tagName="ext:login" d
	. . d dtLogin(childOID,docOID)
	. . d removeIntermediateNode^%zewdDOM(childOID)
	;
	QUIT no
	;
dtLogin(nodeOID,docOID)
	;
	n action,attr,bodyOID,fileName,filePath,headOID,io,line,lineNo
	n mainAttrs,onload,str,x,xOID
	;
	s bodyOID=$$getTagOID^%zewdDOM("body",docName)
	s headOID=$$getTagOID^%zewdDOM("head",docName)
	s attr("name")="zextDesktopLoginForm"
	s xOID=$$addElementToDOM^%zewdDOM("ext:allowchildwindow",bodyOID,,.attr)
	s attr("id")="nullId"
	s attr("style")="display:none"
	s xOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr)
	s xOID=$$addElementToDOM^%zewdDOM("ewd:helpPanel",bodyOID)
	;
	s str="EWD.ext.loadModalWindow = function() {EWD.ext.openWindow({id: 'loginWindow',title: 'Login',height: 110,width: 270,modal:true,closable:false,currentPageName:'"_$p(filename,".ewd",1)_"'},'zextDesktopLoginForm');};"
	s attr("language")="javascript"
	s xOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,str)
	;
	s onload=$$getAttribute^%zewdDOM("onload",bodyOID)
	s onload="EWD.ext.loadModalWindow();"_onload
	d setAttribute^%zewdDOM("onload",onload,bodyOID)
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	s action=$g(mainAttrs("action"))
	q:'$d(files)
	s io=$io
	f fileName="zextDesktopLoginForm","zextDesktopDestroyWindow" d
	. s filePath=inputPath_fileName_".ewd"
	. i '$$openNewFile^%zewdCompiler(filePath) QUIT
	. u filePath
	. f lineNo=1:1 s x="s line=$t("_fileName_"+lineNo^%zewdExtJSCode)" x x q:line["***END***"  d
	. . i line["zActionz" d
	. . . s line=$$replace^%zewdAPI(line,"zActionz",action)
	. . w $p(line,";;",2,1000),!
	. c filePath
	. u io
	. s files(fileName_".ewd")=""
	;
	QUIT
	;
dtWindow(nodeOID,winNo,docOID,shortcutOID)
	;
	n actStr,aOID,attr,attrs,css,cssText,cssTextArr,cw,dtOID,endText
	n fn,func,funcStr,hasText,objectList,src
	n styleOID,textOID,widgetAttribs,win,winObject,xOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)	
	;
	s winObject="Ext.extend>win"
	s win="<mixed>"
	s win(1)="<?= Ext.app.Module ?>"
	s win(2,"zobj1","id")="ewdwin"_winNo
	s func("text")=$g(attrs("title"))
	s func("iconCls")=$g(attrs("iconclass"))
	s func("handler")="<?= this.createWindow ?>"
	s func("scope")="<?= this ?>"
	s funcStr="this.launcher="_$$convertToJSON^%zewdAPI("func",1)
	s funcStr="function(){"_funcStr_"}"
	s win(2,"zobj1","init")="<?= "_funcStr_" ?>"
	;
	d getAttribs("Window",.widgetAttribs)
	d setAttribs(.cw,.widgetAttribs,.attrs)
	;
	s cw("id")="ewdwin"_winNo
	;s cw("title")=$g(attrs("title"))
	;s cw("width")=$g(attrs("width"))
	;s cw("height")=$g(attrs("height"))
	i $g(cw("iconCls"))'="" s cw("iconCls")=$g(attrs("iconclass"))
	i $g(attrs("backgroundcolor"))'="" d
	. s cw("bodyStyle")="background-color:#"_attrs("backgroundcolor")
	s cw("shim")="<?= false ?>"
	s cw("animCollapse")="<?= false ?>"
	s cw("constrainHeader")="<?= true ?>"
	s cw("border")="<?= false ?>"
	;s cw("html")="&lt;div id='window"_winNo_"'&gt;Please wait...&lt;/div&gt;"
	s cw("html")="<div id='window"_winNo_"'>Please wait...</div>"
	s actStr="fn:function(e){EWD.ext.populateWindow"_winNo_"('window"_winNo_"');}"
	s actStr="{"_actStr_"}"
	s cw("listeners","zobj1","activate")="<?= "_actStr_" ?>"
	s funcStr="win=desktop.createWindow("_$$convertToJSON^%zewdAPI("cw",1)_");"
	s funcStr=funcStr_$c(13,10)_"EWD.ext.desktopWindow"_winNo_"=win;"
	s funcStr="if(!win){"_funcStr_"}"
	s fn="var desktop=this.app.getDesktop();"_$c(13,10)
	s fn=fn_"var win=desktop.getWindow('ewdwin"_winNo_"');"_$c(13,10)
	s fn=fn_funcStr_$c(13,10)
	s fn=fn_"win.show();"
	s fn="function(){"_fn_"}"
	s win(2,"zobj1","createWindow")="<?= "_fn_" ?>"
	;
	s objectList(1)="^winObject^theDesktop.window"_winNo
	s endText="EWD.ext.populateWindow"_winNo_"=function(targetId){"_$c(13,10)
	s endText=endText_"if (document.getElementById(targetId).innerHTML=='Please wait...'){"_$c(13,10)
	s src=$g(attrs("src"))
	s src=$p(src,".ewd",1)
	s endText=endText_"ewd.ajaxRequest('"_src_"',targetId);"_$c(13,10)
	s endText=endText_"}};"
	s textOID=$$updateExtJS(,endText,.objectList,docOID)
	;
	QUIT:$g(attrs("showondesktop"))="false" 
	;
	s attr("id")="ewdwin"_winNo_"-shortcut"
	s dtOID=$$addElementToDOM^%zewdDOM("dt",shortcutOID,,.attr)
	s attr("href")="#"
	s aOID=$$addElementToDOM^%zewdDOM("a",dtOID,,.attr)
	s attr("src")=extPath_"/resources/images/default/s.gif"
	s xOID=$$addElementToDOM^%zewdDOM("img",aOID,,.attr)
	s xOID=$$addElementToDOM^%zewdDOM("div",aOID,,,$g(attrs("title")))
	;
	s styleOID=$$getElementById^%zewdDOM("dtStyles",docOID)
	s hasText=0
	s cssText=$$getElementText^%zewdDOM(styleOID,.cssTextArr)
	i cssText'="" s hasText=1
	s css=cssText_"#ewdwin"_winNo_"-shortcut img {width:48px;height:48px;"
	s css=css_"background-image:url("_$g(attrs("desktopicon"))_");"
	s css=css_"filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"_$g(attrs("desktopicon"))_"', sizingMethod='scale');}"_$c(13,10)
	i hasText d
	. s textOID=$$modifyElementText^%zewdDOM(styleOID,css)
	e  d
	. s textOID=$$createTextNode^%zewdDOM(css,docOID)
	. s textOID=$$appendChild^%zewdDOM(textOID,styleOID)
	;
	QUIT
	;
tree(nodeOID,attrValues,docOID,technology)
	;
	; <ext:tree datastore="myData" text="Ext JS">
	;
	n asyncTreeNodeObject,attr,cr,divOID,endText,tree,treeObject,id,mainAttrs,name,no
	n objectList,root,startText,text,textOID,tree,xname
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s cr=$c(13,10)
	s no=$p(nodeOID,"-",2)
	;
	s id=$g(mainAttrs("id"))
	i id="" s id="exttree"_no
	s attr("id")=id
	s attr("style")=$g(mainAttrs("style"))
	s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
	;
	s treeObject="new Tree"_no_".TreePanel>tree"
	s asyncTreeNodeObject="new Tree"_no_".AsyncTreeNode>root"
	s tree("el")="<?= "_id_" ?>"
	s tree("autoScroll")="true"
	s tree("animate")="true"
	s tree("enableDD")="true"
	s tree("bodyBorder")="false"
	s tree("border")="false"
	s tree("containerScroll")="true"
	s tree("loader")="<?= new Tree"_no_".TreeLoader() ?>"
	s root("text")=$g(mainAttrs("text"),"Tree")
	s root("draggable")="false"
	s root("id")="<?= 'ewd' ?>"
	s root("children")="<?="_$g(mainAttrs("datastore"))_" ?>"
	;
	;s startText="EWD.utils.getObjectFromSession('"_$g(mainAttrs("datastore"))_"',true); var Tree"_no_" = Ext.tree ;"_$c(13,10)
	;<ewd:execute method="xyz^myRoutine" param1="abc" param2="$x" param3="#y" type="function" return="$status">
	s attr("method")="writeObjectAsJSON^%zewdCompiler19"
	s attr("param1")=$g(mainAttrs("datastore"))
	s attr("param2")=0
	s attr("param3")=1
	i isAjax s attr("param3")=0
	s attr("param4")="#ewd_sessid"
	s attr("type")="procedure"
	;
	i isAjax d
	. n attrx,mjsOID
	. s attrx("id")="moveToJS"
	. s mjsOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attrx)
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",mjsOID,,.attr)
	e  d
	. s jsOID=$$getElementById^%zewdDOM("extjs",docOID)
	. i jsOID="" d
	. . s jsOID=$$getTagOID^%zewdAPI("script",docName)
	. . i jsOID="" s jsOID=$$addJavascriptFunction^%zewdAPI(docName,.jsArray)
	. s tempOID=$$createElement^%zewdDOM("temp",docOID)
	. s tempOID=$$insertBefore^%zewdDOM(tempOID,jsOID)
	. s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",tempOID,,.attr)
	. d removeIntermediateNode^%zewdDOM(tempOID)
	s startText="var Tree"_no_" = Ext.tree ;"_$c(13,10)
	s startText=startText_"EWD.ext.treeClickHandler['"_$g(mainAttrs("datastore"))_"'] = function(id,value){"
	i $g(mainAttrs("onclick"))'="" d
	. s startText=startText_$g(mainAttrs("onclick"))_"(id,value);"
	e  d
	. i $g(mainAttrs("autowindow"))="true" d
	. . n winName
	. . s startText=startText_"EWD.ext.openDesktopWindow("
	. . s winName="'"_$g(mainAttrs("windowname"))_"'"
	. . i winName="" s winName="value"
	. . s startText=startText_winName_",'',"
	. . s startText=startText_$g(mainAttrs("windowwidth"))_","
	. . s startText=startText_$g(mainAttrs("windowheight"))_","
	. . s startText=startText_"'"_$g(mainAttrs("datastore"))_"',value,"
	. . s startText=startText_"'"_$p(filename,".ewd",1)_"');"
	s startText=startText_"};"_$c(13,10)
	s objectList(1)="var^treeObject^tree"_no
	s objectList(2)="var^asyncTreeNodeObject^root"_no
	s endText="tree"_no_".setRootNode(root"_no_"); tree"_no_".render(); root"_no_".expand();"
	;
	s textOID=$$updateExtJS(startText,endText,.objectList,docOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
createGridDatastore(array,sessionName,access,sessid)
	s access=$g(access)
	i access="" s access="r"
	i access'="r",access'="rw" s access="r"
	d deleteFromSession^%zewdAPI(sessionName,sessid)
	d mergeArrayToSession^%zewdAPI(.array,sessionName,sessid)
	d allowJSONAccess^%zewdAPI(sessionName,access,sessid)
	QUIT
	;
createItemSelectorDatastore(array,sessionName,access,sessid)
	n no,storeArray
	s access=$g(access)
	i access="" s access="r"
	i access'="r",access'="rw" s access="r"
	s no=""
	f  s no=$o(array(no)) q:no=""  d
	. s storeArray(no,1)=no
	. s storeArray(no,2)=array(no)
	i '$d(array) s storeArray="[]"
	d deleteFromSession^%zewdAPI(sessionName,sessid)
	d mergeArrayToSession^%zewdAPI(.storeArray,sessionName,sessid)
	d allowJSONAccess^%zewdAPI(sessionName,access,sessid)
	QUIT
	;
createTreeDatastore(array,sessionName,sessid)
 ;
 n asubscr,cls,currentPage,data,ds,dsubscr,leaf,no,onclickAllLevels,optNo,page
 ;
 s currentPage=$$getSessionValue^%zewdAPI("ewd.pageName",sessid)
 ;d trace^%zewdAPI("** currentPage="_currentPage)
 d deleteFromSession^%zewdAPI(sessionName_"PageMap",sessid)
 s onclickAllLevels=0
 i $g(array)'="" d
 . n directive,i,name,nd,nvp,value
 . s directive=array
 . s nd=$l(directive,"&")
 . f i=1:1:nd d
 . . s nvp=$p(directive,"&",i)
 . . s name=$p(nvp,"=",1)
 . . s value=$p(nvp,"=",2,200)
 . . i $$zcvt^%zewdAPI(name,"l")="onclickalllevels" d
 . . . i value=1 s onclickAllLevels=1
 s optNo="",no=0
 f  s optNo=$o(array(optNo)) q:optNo=""  d
 . s no=no+1
 . s data=$p($g(array(optNo)),$c(1),1)
 . s ds(no,"zobj1","text")=data
 . s ds(no,"zobj1","id")="extTreeData"_no
 . s leaf="false",cls="folder"
 . i $d(array(optNo))=1 d
 . . n allowed,map
 . . s leaf="true",cls=$p(array(optNo),$c(1),3)
 . . s page=$p(array(optNo),$c(1),2)
 . . i page'="" d
 . . . s allowed(currentPage,page)="" d mergeArrayToSession^%zewdAPI(.allowed,"ext_allowPage",sessid)
 . . . s map($$zcvt^%zewdAPI($p(data,$c(1),1),"I","URL"))=page
 . . . d mergeArrayToSession^%zewdAPI(.map,sessionName_"PageMap",sessid)
 . . i cls="" s cls="file"
 . . s click="{click:function(){EWD.ext.treeClickHandler['"_sessionName_"']('extTreeData"_no_"','"_data_"')}}"
 . . s ds(no,"zobj1","listeners")=click
 . ;**************************************
 . e  d
 . . i onclickAllLevels d
 . . . s click="{click:function(){EWD.ext.treeClickHandler['"_sessionName_"']('extTreeData"_no_"','"_data_"')}}"
 . . . s ds(no,"zobj1","listeners")=click
 . ; ***************************************
 . s ds(no,"zobj1","leaf")=leaf
 . s ds(no,"zobj1","cls")=cls
 . s asubscr="array("_optNo_","
 . s dsubscr="ds("_no_",""zobj1"",""children"","
 . d treeDSLevel(asubscr,dsubscr,"extTreeData"_no)
 d deleteFromSession^%zewdAPI(sessionName,sessid)
 d mergeArrayToSession^%zewdAPI(.ds,sessionName,sessid)
 d allowJSONAccess^%zewdAPI(sessionName,"r",sessid)
 QUIT
 ;
treeDSLevel(asubscr,dsubscr,level)
 ;
 n asubscr2,cls,data,dd,dsubscr2,id,leaf,no,optNo,stop,str,x
 ;
 s optNo="",no=0,stop=0
 f  d  q:stop
 . s x="s optNo=$o("_asubscr_"optNo))" x x
 . i optNo="" s stop=1 q
 . s x="s data=$g("_asubscr_"optNo))" 
 . x x
 . i data="" s data="Missing Option"
 . s x="s dd=$d("_asubscr_"optNo))" x x
 . s no=no+1
 . s str="s "_dsubscr_no_",""zobj1"","
 . s x=str_"""text"")="""_$p(data,$c(1),1)_"""" x x
 . ;s id=level_"x"_no
 . s id=level_"x"_optNo
 . s x=str_"""id"")="""_id_"""" x x
 . s leaf="false",cls="folder",click=""
 . i dd=1 d
 . . n allowed,map,page
 . . s leaf="true",cls=$p(data,$c(1),3)
 . . i cls="" s cls="file"
 . . s page=$p(data,$c(1),2)
 . . i page'="" d
 . . . s allowed(currentPage,page)=""
 . . . d mergeArrayToSession^%zewdAPI(.allowed,"ext_allowPage",sessid)
 . . . s map($$zcvt^%zewdAPI($p(data,$c(1),1),"I","URL"))=page
 . . . d mergeArrayToSession^%zewdAPI(.map,sessionName_"PageMap",sessid)
 . . s click="{click:function(){EWD.ext.treeClickHandler['"_sessionName_"']('"_id_"','"_$p(data,$c(1),1)_"')}}"
 . s x=str_"""leaf"")="""_leaf_"""" x x
 . s x=str_"""cls"")="""_cls_"""" x x
 . ;****************
 . i onclickAllLevels d
 . . s click="{click:function(){EWD.ext.treeClickHandler['"_sessionName_"']('"_id_"','"_$p(data,$c(1),1)_"')}}"
 . ;****************
 . i click'="" s x=str_"""listeners"")="""_click_"""" x x
 . s asubscr2=asubscr_optNo_","
 . s dsubscr2=dsubscr_no_",""zobj1"",""children"","
 . d treeDSLevel(asubscr2,dsubscr2,id)
 QUIT
	;
htmlEditor(nodeOID,attrValues,docOID,technology)
	;
	; <ext:htmlEditor>
	;
	n attrs,editor,editorObject,id,mainAttrs,name,objectList
	n renderTo,textOID,varName,widgetAttribs,xOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	;
	s id=$g(mainAttrs("id"))
	s name=$g(mainAttrs("name"))
	d
	. i id="",name="" d  q
	. . s name="editor"_$p(nodeOID,"-",2),renderTo="ewd"_name,id=name_"x"
	. i id="",name'="" d  q
	. . s renderTo="ewd"_name,id=name_"x"
	. i id'="",name="" d  q
	. . s name=id,renderTo="ewd"_id,id=id_"x"
	s mainAttrs("id")=id
	s mainAttrs("renderto")=id
	s mainAttrs("name")=name
	;
	s editorObject="new Ext.form.HtmlEditor>editor"
	d getAttribs("HtmlEditor",.widgetAttribs)
	d setAttribs(.editor,.widgetAttribs,.mainAttrs)
	s varName="editor"_$p(nodeOID,"-",2)
	s objectList(1)="var^editorObject^"_varName
	s textOID=$$updateExtJS("Ext.QuickTips.init();",,.objectList,docOID)
	s xOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
	d setAttribute^%zewdDOM("id",$g(mainAttrs("renderto")),xOID)
	d removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
getAttribs(widgetName,widgetAttribs)
 ;
 n line,lineNo,x
 ;
 s x="f lineNo=1:1 s line=$t("_widgetName_"+lineNo^%zewdExtJSData) q:line[""***END***""  d addAttrib("""_widgetName_""",line,.widgetAttribs)"
 x x
 QUIT
 ;
addAttrib(widgetName,line,widgetAttribs)
 ;
 n attribName,lcName,type
 ;
 s attribName=$p(line,";;",2)
 s type=$p(attribName,":",2)
 s attribName=$p(attribName,":",1)
 s lcName=$$zcvt^%zewdAPI(attribName,"l")
 s widgetAttribs(lcName)=attribName_":"_type
 QUIT
 ;
setAttribs(array,widgetAttribs,mainAttrs)
	;
	n d,name,p1,p2,type,xname
	;
	s name=""
	f  s name=$o(widgetAttribs(name)) q:name=""  d
	. i $g(mainAttrs(name))="" q
	. s d=widgetAttribs(name)
	. s xname=$p(d,":",1)
	. s type=$p(d,":",2)
	. s p1="",p2=""
	. i type["bool"!(type["ref") s p1="<?= ",p2=" ?>"
	. i type="array" s p1="<?= [",p2="] ?>"
	. i type["function" s p1="<?= "_type_" {",p2="} ?>"
	. s array(xname)=p1_mainAttrs(name)_p2
	QUIT
	;
registerDesktopPage(pageName,sessid)
 ;
 n appName
 ;
 s appName=$$getSessionValue^%zewdAPI("ewd_appName",sessid)
 s ^zewd("desktopPageRegister",appName,pageName)=""
 QUIT
 ;
allowChildWindow(nodeOID,attrValues,docOID,technology)
	;
	;  <ext:allowChildWindow name="loginForm" />
	;
	n allowedString,currentPage,mainAttrs,toPage
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	s toPage=$g(mainAttrs("name"))
	s currentPage=$p(filename,".ewd",1)
	;
	i technology="php" d
	. n appDeclared,arrayDeclared,lastLineNo,line,lineNo
	. ;
	. s allowedString="$ewd_session['ext_allowPage']['"_currentPage_"']"
	. s lineNo="",lastLineNo=0,arrayDeclared=0,appDeclared=0
	. f  s lineNo=$o(phpHeaderArray(1,lineNo)) q:lineNo=""  d
	. . s lastLineNo=lineNo
	. . s line=phpHeaderArray(1,lineNo)
	. . i line["$ewd_session['ext_allowPage'] = array()" s arrayDeclared=1
	. . i line[allowedString s appDeclared=1
	. s lineNo=lastLineNo+1
	. i 'arrayDeclared d
	. . s phpHeaderArray(1,lineNo)="  $ewd_session['ext_allowPage'] = array() ;"
	. . s lineNo=lineNo+1
	. i 'appDeclared d
	. . s phpHeaderArray(1,lineNo)="  "_allowedString_" = array() ;"
	. . s lineNo=lineNo+1
	. s phpHeaderArray(1,lineNo)="  "_allowedString_"['"_toPage_"'] = '' ;"
	;
	i technology="wl"!(technology="gtm")!(technology="ewd") d
	. n appDeclared,arrayDeclared,lastLineNo,line,lineNo
	. ;
	. s allowedString=" s sessionArray(""ext_allowPage"","""_$$zcvt^%zewdAPI(currentPage,"l")_""","
	. s lineNo="",lastLineNo=0,arrayDeclared=0,appDeclared=0
	. f  s lineNo=$o(phpHeaderArray(1,lineNo)) q:lineNo=""  d
	. . s lastLineNo=lineNo
	. s lineNo=lastLineNo+1
	. s phpHeaderArray(1,lineNo)=allowedString_""""_toPage_""")="""""
	;
	i technology="csp" d
	. n appDeclared,arrayDeclared,lastLineNo,line,lineNo
	. ;
	. s allowedString=" s allowPage("""_$$zcvt^%zewdAPI(currentPage,"l")_""","
	. s lineNo="",lastLineNo=0,arrayDeclared=0,appDeclared=0
	. f  s lineNo=$o(phpHeaderArray(1,lineNo)) q:lineNo=""  d
	. . s lastLineNo=lineNo
	. s lineNo=lastLineNo+1
	. s phpHeaderArray(1,lineNo)=allowedString_""""_toPage_""")="""""
	;
	d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT
	;
license() ;
 n supportKey
 s supportKey=201001629
 ;s supportKey="unlicensed"
 QUIT supportKey
 ;
extFormHandler(docName)
 ;
 ;
 n attr,nodeOID,pageType,rcOID,xOID
 ;
 s nodeOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 s pageType=$$getAttribute^%zewdDOM("pagetype",nodeOID)
 i $$zcvt^%zewdAPI(pageType,"l")'="extformhandler" QUIT
 ;
 s rcOID=$$addElementToDOM^%zewdDOM("ewd:rawcontent",docOID)
 s attr("method")="formErrors^%zewdExtJS"
 s attr("param1")="#ewd_sessid"
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",rcOID,,.attr)
 d setAttribute^%zewdDOM("pagetype","rawfragment",nodeOID)
 ;
 QUIT
 ;
setFieldError(field,error,sessid)
 ;
 n fieldErrors,message
 ;
 s fieldErrors("fieldError",field)=error
 d mergeArrayToSession^%zewdAPI(.fieldErrors,"ewd.form",sessid)
 s message=$$getSessionValue^%zewdAPI("ewd.form.errorMessage",sessid)
 i message="" d setSessionValue^%zewdAPI("ewd.form.errorMessage","Validation error(s) were reported",sessid)
 ;
 QUIT
 ;
isFormErrors()
 n fieldErrors
 d mergeArrayFromSession^%zewdAPI(.fieldErrors,"ewd.form",sessid)
 QUIT $d(fieldErrors)
 ;
formErrors(sessid)
 ;
 n array,errors,field,fieldErrors,message
 ;
 d mergeArrayFromSession^%zewdAPI(.errors,"ewd_form",sessid)
 s message=$g(errors("errorMessage"))
 i message="",$d(errors("fieldError")) s message="Errors were reported in your form"
 i message="" d
 . s array("zobj1","success")="true"
 e  d
 . s array("zobj1","success")="false"
 . s array("zobj1","errors","zobj1","alert")=message
 . s field=""
 . f  s field=$o(errors("fieldError",field)) q:field=""  d
 . . s array("zobj1","errors","zobj1",field)=errors("fieldError",field)
 d walkObjectArray^%zewdCompiler19("array")
 d deleteFromSession^%zewdAPI("ewd_form",sessid)
 ;
 QUIT
 ;
setAlertMessage(message,sessid)
 d setSessionValue^%zewdAPI("ewd.form.errorMessage",message,sessid)
 QUIT
 ;
appendToComboBoxStore(text,value,storeName,sessid)
 ;
 n store
 ;
 s store=$$getSessionValue^%zewdAPI(storeName,sessid)
 i store'="" s store=$e(store,2,$l(store)-1)_","
 s store="["_store_"['"_value_"','"_text_"']]"
 d setSessionValue^%zewdAPI(storeName,store,sessid)
 QUIT
 ;
writeTextArea(fieldName,sessid)
 n text
 w "<div style=""display:none"" id=""zewdTextarea"_fieldName_""">"
 s text=$$getSessionValue^%zewdAPI(fieldName,sessid)
 i text'="" d
 . w text
 e  d
 . d displayTextArea(fieldName)
 w "&nbsp;"
 w "</div>"_$c(13,10)
 QUIT
 ;
displayTextArea(fieldName)
 n lineNo,text,lastLineNo
 ;
 s fieldName=$tr(fieldName,".","_")
 d
 . s lastLineNo=$o(^%zewdSession("session",sessid,"ewd_textarea",fieldName,""),-1)
 . s lineNo=0
 . f  s lineNo=$o(^%zewdSession("session",sessid,"ewd_textarea",fieldName,lineNo)) q:lineNo=""  d
 . . k text
 . . s text=^%zewdSession("session",sessid,"ewd_textarea",fieldName,lineNo)
 . . s text=$$replaceAll^%zewdHTMLParser(text,"&#39;","'")
 . . w $$zcvt^%zewdAPI(text,"o","JS")
 . . i lineNo'=lastLineNo w "\r\n"
 QUIT
