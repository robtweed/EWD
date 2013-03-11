%zewdExt4Code ; Extjs 4 Runtime Logic
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
preProcess(sessid)
 ;
 n name,page,var,xname
 ;
 ; Panel addTo pre-processing
 ;
 ;d trace^%zewdAPI("in preProcess")
 ;s page=$$getRequestValue^%zewdAPI("page",sessid)
 f name="ext4_addTo","ext4_removeAll" d
 . s xname="tmp_"_$p(name,"_",2)
 . d deleteFromSession^%zewdAPI(xname,sessid)
 . ;d deleteSessionArrayValue^%zewdAPI(name,page,sessid)
 . s var=$$getRequestValue^%zewdAPI(name,sessid)
 . i var'="" d
 . . ;n arr
 . . ;s arr(page)=var
 . . ;d mergeArrayToSession^%zewdAPI(.arr,name,sessid)
 . . ;d trace^%zewdAPI("xname="_xname)
 . . d setSessionValue^%zewdAPI(xname,var,sessid)
 ;
 QUIT
 ;
gridValidationPass()
 n js
 s js="js"
 i $$isCSP^%zewdAPI(sessid) s js="javascript"
 QUIT js_":var e=EWD.ext4.e;e.record.commit();"
 ;
gridValidationFail(sessid,alertMessage,alertTitle)
 n js,originalValue,value
 s originalValue=$$getRequestValue^%zewdAPI("originalValue",sessid)
 s value=$$getRequestValue^%zewdAPI("value",sessid)
 s alertTitle=$g(alertTitle) i alertTitle="" s alertTitle="Validation Error"
 s alertMessage=$g(alertMessage) i alertMessage="" s alertMessage="Invalid value: "_value
 s js="js"
 i $$isCSP^%zewdAPI(sessid) s js="javascript"
 QUIT js_":var e=EWD.ext4.e;e.record.data[e.field] = '"_originalValue_"'; e.record.commit();Ext.Msg.alert('"_alertTitle_"','"_alertMessage_"');"
 ;
setTextAreaValue(array,fieldName,sessid)
 d createTextArea^%zewdAPI($g(fieldName),.array,sessid)
 QUIT
 ;
 ;n lf,lineNo,text
 ;
 ;s text=""
 ;s lf=""
 ;s lineNo=""
 ;f  s lineNo=$o(array(lineNo)) q:lineNo=""  d
 ;. s text=text_lf_array(lineNo)
 ;. s lf="\n"
 ;d setSessionValue^%zewdAPI(fieldName,text,sessid)
 ;
 ;QUIT
 ;
setHtmlEditorValue(array,fieldName,sessid)
 d createTextArea^%zewdAPI($g(fieldName),.array,sessid)
 QUIT
 ;
 ;n lf,lineNo,text
 ;
 ;s text=""
 ;s lf=""
 ;s lineNo=""
 ;f  s lineNo=$o(array(lineNo)) q:lineNo=""  d
 ;. s text=text_lf_array(lineNo)
 ;. s lf="<br>"
 ;d setSessionValue^%zewdAPI(fieldName,text,sessid)
 ;
 ;QUIT
 ;
addToText(line,textArray)
 s textArray($increment(textArray))=line
 QUIT
 ;
writeGridStore(sessionName,columnDef,id,storeId,groupField,sessid)
 ;
 ; Generate and write out the Model, Store and Column 
 ; definitions for a gridPanel
 ;
 n cols,comma,comma2,data,grouping,name,namex,no,text,value
 ;
 i columnDef'="" d mergeArrayFromSession^%zewdAPI(.cols,columnDef,sessid)
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 ;
 d addToText("EWD.ext4.grid['"_id_"'] = {"_$c(13,10),.text)
 d addToText("  combo: {"_$c(13,10),.text)
 d addToText("    index: {},"_$c(13,10),.text)
 d addToText("    store: {}"_$c(13,10),.text)
 d addToText("  }"_$c(13,10),.text)
 d addToText("};"_$c(13,10),.text)
 ;
 ; Model
 ;
 s grouping=0
 i $g(groupField)'="" s grouping=groupField
 ;
 s no=""
 f  s no=$o(cols(no)) q:no=""  d
 . i $d(cols(no,"dataIndex")),'$d(cols(no,"name")) d
 . . s cols(no,"name")=cols(no,"dataIndex")
 . k cols(no,"dataIndex")
 . i $d(cols(no,"text")),'$d(cols(no,"header")) d
 . . s cols(no,"header")=cols(no,"text")
 . k cols(no,"text")
 ;
 d
 . ; if columns are explicitly defined in tags, use data array to get the names for the model
 . i '$d(cols),$d(data(1)) d
 . . n name,no
 . . s name="",no=0
 . . f  s name=$o(data(1,name)) q:name=""  d
 . . . s no=no+1
 . . . s cols(no,"name")=name
 d
 . d addToText("Ext.define('"_id_"Model',{",.text)
 . d addToText("extend:'Ext.data.Model',",.text)
 . d addToText("fields:[",.text)
 . ;s no="",comma=""
 . s no="",comma=","
 . d addToText("{name: 'zewdRowNo'}",.text)
 . f  s no=$o(cols(no)) q:no=""  d
 . . s name=$g(cols(no,"name"))
 . . d addToText(comma_"{name:'"_name_"'",.text)
 . . i $g(cols(no,"xtype"))="booleancolumn" d addToText(",type: 'boolean'",.text)
 . . i $g(cols(no,"xtype"))="datecolumn" d addToText(",type: 'date'",.text)
 . . i $g(cols(no,"xtype"))="numbercolumn" d addToText(",type: 'number'",.text)
 . . d addToText("}",.text)
 . . i $g(cols(no,"groupField"))="true" d
 . . . s grouping=name
 . . s comma=","
 . d addToText("]",.text)
 . d addToText("});"_$c(13,10),.text)
 ;
 ; Store
 ;
 d addToText("var "_storeId_"=Ext.create('Ext.data.Store',{",.text)
 d addToText("model:'"_id_"Model',",.text)
 d addToText("id:'"_storeId_"',",.text)
 d addToText("data:[",.text)
 s no="",comma=""
 f  s no=$o(data(no)) q:no=""  d
 . d addToText(comma_"{",.text)
 . ;s name="",comma2=""
 . s name="",comma2=","
 . d addToText("zewdRowNo: '"_no_"'",.text)
 . f  s name=$o(data(no,name)) q:name=""  d
 . . s value=$g(data(no,name))
 . . d addToText(comma2_$$quotedName(name)_":"_$$quotedValue(value),.text)
 . . s comma2=","
 . s comma=","
 . d addToText("}",.text)
 d addToText("]",.text)
 i grouping'=0 d addToText(",groupField:'"_grouping_"'",.text)
 d addToText("});"_$c(13,10),.text)
 ;
 ; ComboBox editor Options
 ;
 s no=""
 f  s no=$o(cols(no)) q:no=""  d
 . i $g(cols(no,"useList"))'="" d  q
 . . n dataIndex,listName
 . . s listName=cols(no,"useList")
 . . k cols(no,"useList")
 . . s dataIndex=$g(cols(no,"name"))
 . . d optionsFromList(listName,dataIndex,id,sessid)
 . . s cols(no,"renderer")=".function (value, metaData, record, rowIndex, colIndex) {return EWD.ext4.grid['"_id_"'].combo.index['"_dataIndex_"'][value];}"
 . ;
 . i $d(cols(no,"options")) d
 . . n comma,dataIndex,ono
 . . s dataIndex=$g(cols(no,"name"))
 . . d addToText("EWD.ext4.grid['"_id_"'].combo.store['"_dataIndex_"']=["_$c(13,10),.text)
 . . s ono="",comma=""
 . . f  s ono=$o(cols(no,"options",ono)) q:ono=""  d
 . . . d addToText(comma_"['"_$g(cols(no,"options",ono,"value"))_"','"_$g(cols(no,"options",ono,"displayValue"))_"']",.text)
 . . . s comma=","
 . . d addToText("];"_$c(13,10),.text)
 . . d addToText("EWD.ext4.grid['"_id_"'].combo.index['"_dataIndex_"']={"_$c(13,10),.text)
 . . s ono="",comma=""
 . . f  s ono=$o(cols(no,"options",ono)) q:ono=""  d
 . . . d addToText(comma_"'"_$g(cols(no,"options",ono,"value"))_"':'"_$g(cols(no,"options",ono,"displayValue"))_"'",.text)
 . . . s comma=","
 . . d addToText("};"_$c(13,10),.text)
 . . s cols(no,"renderer")=".function (value, metaData, record, rowIndex, colIndex) {return EWD.ext4.grid['"_id_"'].combo.index['"_dataIndex_"'][value];}"
 ;
 ; Columns
 ;
 i columnDef'="" d
 . d addToText("EWD.ext4.grid['"_id_"'].cols=[",.text)
 . ;w "var "_id_"Cols=["
 . ;s no="",comma=""
 . s no="",comma=","
 . d addToText("{dataIndex:'zewdRowNo', hidden: true}",.text)
 . f  s no=$o(cols(no)) q:no=""  d
 . . d addToText(comma_"{",.text)
 . . s name="",comma2=""
 . . f  s name=$o(cols(no,name)) q:name=""  d
 . . . s namex=name
 . . . i name="dateFormat" d
 . . . . s cols(no,"renderer")=".Ext.util.Format.dateRenderer('"_cols(no,name)_"')"
 . . . i name="name" s namex="dataIndex"
 . . . i name="header" s namex="text"
 . . . i name="groupField" q
 . . . i name="editor" q
 . . . i name="options" q
 . . . s value=$g(cols(no,name))
 . . . i name="icon" d  q
 . . . . n attr,iconNo,comma3,comma4,value
 . . . . i $d(cols(no,"icon")) d
 . . . . . d addToText(comma2_"items:[",.text)
 . . . . . s comma2=","
 . . . . s iconNo="",comma3=""
 . . . . f  s iconNo=$o(cols(no,"icon",iconNo)) q:iconNo=""  d
 . . . . . d addToText(comma3_"{",.text)
 . . . . . s comma4="",attr=""
 . . . . . i $g(cols(no,"icon",iconNo,"nextPage"))'="" d
 . . . . . . n fn,i
 . . . . . . s fn="function(me,rowIndex) {"
 . . . . . . s fn=fn_"var nvp=""row=""+EWD.ext4.getGridRowNo(me,rowIndex);"
 . . . . . . i $g(cols(no,"icon",iconNo,"nvp"))'="" s fn=fn_"nvp=nvp+""&"_cols(no,"icon",iconNo,"nvp")_""";"
 . . . . . . i $g(cols(no,"icon",iconNo,"addTo"))'="" s fn=fn_"nvp=nvp+""&ext4_addTo="_cols(no,"icon",iconNo,"addTo")_""";"
 . . . . . . i $g(cols(no,"icon",iconNo,"replacePreviousPage"))="true" s fn=fn_"nvp=nvp+""&ext4_removeAll=true"";"
 . . . . . . s fn=fn_"; EWD.ajax.getPage({page:"""_cols(no,"icon",iconNo,"nextPage")_""",nvp:nvp});"
 . . . . . . s fn=fn_"}"
 . . . . . . s cols(no,"icon",iconNo,"handler")=fn
 . . . . . . f i="nextPage","addTo","replacePreviousPage","nvp" k cols(no,"icon",iconNo,i)
 . . . . . f  s attr=$o(cols(no,"icon",iconNo,attr)) q:attr=""  d
 . . . . . . s value=cols(no,"icon",iconNo,attr)
 . . . . . . d addToText(comma4_attr_":"_$$quotedValue(value),.text)
 . . . . . . s comma4=","
 . . . . . d addToText("}",.text)
 . . . . . s comma3=","
 . . . . d addToText("]",.text)
 . . . i name="editas" d  ;  q
 . . . . n key,value2
 . . . . d addToText(comma2_"editor: {xtype:'"_value_"'",.text)
 . . . . i value="combobox" d
 . . . . . n dataIndex
 . . . . . s dataIndex=$g(cols(no,"name"))
 . . . . . i $g(cols(no,"editor","typeAhead"))="" s cols(no,"editor","typeAhead")="true"
 . . . . . i $g(cols(no,"editor","triggerAction"))="" s cols(no,"editor","triggerAction")="all"
 . . . . . i $g(cols(no,"editor","selectOnTab"))="" s cols(no,"editor","selectOnTab")="true"
 . . . . . i $g(cols(no,"editor","lazyRender"))="" s cols(no,"editor","lazyRender")="true"
 . . . . . i $g(cols(no,"editor","listClass"))="" s cols(no,"editor","listClass")="x-combo-list-small"
 . . . . . s cols(no,"editor","store")=".EWD.ext4.grid['"_id_"'].combo.store['"_dataIndex_"']"
 . . . . s key=""
 . . . . f  s key=$o(cols(no,"editor",key)) q:key=""  d
 . . . . . s value2=cols(no,"editor",key)
 . . . . . d addToText(","_key_":"_$$quotedValue(value2),.text)
 . . . . d addToText("}"_$c(13,10),.text)
 . . . . s comma2=","
 . . . d addToText(comma2_namex_":"_$$quotedValue(value),.text)
 . . . s comma2=","
 . . s comma=","
 . . d addToText("}",.text)
 . d addToText("];"_$c(13,10),.text)
 ;
 i $$getSessionValue^%zewdAPI("ewd_technology",sessid)="node" d
 . n i
 . f i=1:1:text s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=text(i)
 e  d
 . n i
 . f i=1:1:text w text(i)
 QUIT
 ;
quotedValue(value)
 d
 . i $e(value,1,9)'="function(" s value=$$replaceAll^%zewdAPI(value,"'","\'")
 . i value="true"!(value="false") q
 . i $$numeric^%zewdJSON(value) q
 . i $e(value,1)=".",$e(value,2)'?1N s value=$e(value,2,$l(value)) q
 . i $e(value,1,9)="function(" q
 . i $e(value,1)="|" s value=$e(value,2,$l(value))
 . s value="'"_value_"'"
 QUIT value
 ;
quotedName(name)
 i name'?.AN s name="'"_name_"'"
 QUIT name
 ;
writeTextArea(id,sessid)
 n lf,line,no,text,textArray
 d mergeArrayFromSession^%zewdAPI(.text,"ewd_textarea",sessid)
 d addToText("EWD.ext4.textarea['"_id_"']=""",.textArray)
 s no=0,lf=""
 f  s no=$o(text(id,no)) q:no=""  d
 . s line=text(id,no)
 . s line=$$replaceAll^%zewdAPI(line,"""","\""")
 . d addToText(lf_line,.textArray)
 . s lf="\n"
 d addToText(""";"_$c(13,10),.textArray)
 i $$getSessionValue^%zewdAPI("ewd_technology",sessid)="node" d
 . n i
 . f i=1:1:textArray s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=textArray(i)
 e  d
 . n i
 . f i=1:1:textArray w textArray(i)
 QUIT
 ;
writeHtmlEditorText(id,sessid)
 n lf,line,no,text,textArray
 d mergeArrayFromSession^%zewdAPI(.text,"ewd_textarea",sessid)
 d addToText("EWD.ext4.textarea['"_id_"']=""",.textArray)
 s no=0,lf=""
 f  s no=$o(text(id,no)) q:no=""  d
 . s line=text(id,no)
 . s line=$$replaceAll^%zewdAPI(line,"""","\""")
 . d addToText(lf_line,.textArray)
 . s lf="<br />"
 d addToText(""";"_$c(13,10),.textArray)
 i $$getSessionValue^%zewdAPI("ewd_technology",sessid)="node" d
 . n i
 . f i=1:1:textArray s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=textArray(i)
 e  d
 . n i
 . f i=1:1:textArray w textArray(i)
 QUIT
 ;
writeLine(line)
 i $$getSessionValue^%zewdAPI("ewd_technology",sessid)="node" d
 . s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=line
 e  d
 . w line
 QUIT
 ;
defineLoader(sessid)
 ;
 n app,array,isCsp,line,name,rootPath,text,xRootPath
 ;
 s line=""
 s isCsp=$$getSessionValue^%zewdAPI("ewd.technology",sessid)="csp"
 s app=$$getSessionValue^%zewdAPI("ewd.appName",sessid)
 s app=$$zcvt^%zewdAPI(app,"l")
 i app="" QUIT
 s rootPath=$g(^zewd("rootPath",app))
 s xRootPath=$$getSessionValue^%zewdAPI("extjs.rootPath",sessid)
 i xRootPath'="" s rootPath=xRootPath
 i $e(rootPath,$l(rootPath))'="/" s rootPath=rootPath_"/"
 i $d(^zewd("loader",app,"configs")) d
 . m array=^zewd("loader",app,"configs")
 . i $g(^zewd("config","cacheRequires"))=1 d
 . . s array("disableCaching")="false"
 . e  d
 . . k array("disableCaching")
 . s name=""
 . f  s name=$o(array("paths",name)) q:name=""  d
 . . s array("paths",name)=rootPath_array("paths",name)
 . i isCsp d
 . . s line=line_"EWD.loader = "
 . . s line=line_$$arrayToJSON^%zewdJSON("array")
 . . s line=line_";"_$c(13,10)
 . e  d
 . . d writeLine("EWD.loader = ")
 . . d streamArrayToJSON^%zewdJSON("array")
 . . d writeLine(";"_$c(13,10))
 . i $d(^zewd("loader",app,"requires")) d
 . . k array
 . . m array=^zewd("loader",app,"requires")
 . . d mergeArrayFromSession^%zewdAPI(.array,"ewd_require",sessid)
 . . i isCsp d
 . . . s line=line_"EWD.requires = "
 . . . s line=line_$$arrayToJSON^%zewdJSON("array")
 . . . s line=line_";"_$c(13,10)
 . . e  d
 . . . d writeLine("EWD.requires = ")
 . . . d streamArrayToJSON^%zewdJSON("array")
 . . . d writeLine(";"_$c(13,10))
 . e  d
 . . i isCsp d
 . . . s line=line_"EWD.requires = '';"_$c(13,10)
 . . e  d
 . . . d writeLine("EWD.requires = '';"_$c(13,10))
 e  d
 . i isCsp d
 . . s line=line_"EWD.loader = {enabled: false};"_$c(13,10)
 . . s line=line_"EWD.requires = '';"_$c(13,10)
 . e  d
 . . d writeLine("EWD.loader = {enabled: false};"_$c(13,10))
 . . d writeLine("EWD.requires = '';"_$c(13,10))
 ;
 QUIT
 ;
writeGroupFields(sessionName,id,name,xtype,sessid)
 ;
 n checkedValue,cv,fieldName,fields,itemsId,no,selected,textArray
 ;
 d mergeArrayFromSession^%zewdAPI(.fields,sessionName,sessid)
 i xtype="radiofield" s checkedValue=$$getSessionValue^%zewdAPI(name,sessid)
 i xtype="checkboxfield" d mergeFromSelected^%zewdAPI(name,.selected,sessid)
 s itemsId=id_"Items"
 d writeLine(itemsId_"="_$c(13,10))
 s no=""
 f  s no=$o(fields(no)) q:no=""  d
 . i xtype="radiofield" d
 . . s fields(no,"xtype")="radiofield"
 . e  d
 . . s fields(no,"ptype")="checkboxfield"
 . i $g(fields(no,"id"))="" s fields(no,"id")=id_no
 . i xtype="radiofield" d
 . . s cv=checkedValue
 . . s fieldName=$g(fields(no,"name"))
 . . i fieldName="" d
 . . . s fields(no,"name")=name
 . . e  d
 . . . i fieldName'=name s cv=$$getSessionValue^%zewdAPI(fieldName,sessid)
 . . i $g(fields(no,"inputValue"))=cv s fields(no,"checked")="true"
 . i xtype="checkboxfield" d
 . . n value
 . . k cv
 . . m cv=selected
 . . s fieldName=$g(fields(no,"name"))
 . . i fieldName="" d
 . . . s fields(no,"name")=name
 . . e  d
 . . . i fieldName'=name d
 . . . . k cv
 . . . . d mergeFromSelected^%zewdAPI(fieldName,.cv,sessid)
 . . s value=$g(fields(no,"inputValue"))
 . . i value="" s value="undefinedValue"
 . . i $d(cv(value)) s fields(no,"checked")="true"
 d streamArrayToJSON^%zewdJSON("fields")
 d writeLine(";"_$c(13,10))
 QUIT
 ;
writeTreeStore(sessionName,storeId,page,addTo,replace,expanded,sessid)
 ;
 n data,xArray,yArray
 ;
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 d expandTreeArray(.data,.xArray,page,addTo,replace,expanded)
 m yArray("root","children")=xArray
 s yArray("id")=storeId
 s yArray("root","expanded")="false"
 i expanded s yArray("root","expanded")="true"
 d writeLine("var "_storeId_"=Ext.create('Ext.data.TreeStore',")
 d streamArrayToJSON^%zewdJSON("yArray")
 d writeLine(");"_$c(13,10))
 ;
 QUIT
 ;
expandTreeArray(inArray,outArray,page,addTo,replace,expanded)
 ;
 n data,index
 ;
 s index=""
 f  s index=$o(inArray(index)) q:index=""  d
 . s data=$d(inArray(index))
 . i $d(inArray(index,"child")) d
 . . n arr,out
 . . m arr=inArray(index,"child")
 . . d expandTreeArray(.arr,.out,page,addTo,replace,expanded)
 . . m outArray(index,"children")=out
 . . i $g(inArray(index,"text"))'="" s outArray(index,"text")=inArray(index,"text")
 . . i $g(page)'="" s outArray(index,"page")=page
 . . i $g(addTo)'="" s outArray(index,"addTo")=page
 . . i $g(inArray(index,"page"))="",$g(inArray(index,"nextPage"))="",$g(replace)'="" s outArray(index,"replace")=replace
 . . i $g(inArray(index,"page"))'="" s outArray(index,"page")=inArray(index,"page")
 . . i $g(inArray(index,"nextPage"))'="" s outArray(index,"page")=inArray(index,"nextPage")
 . . i $g(inArray(index,"addTo"))'="" s outArray(index,"addTo")=inArray(index,"addTo")
 . . i $g(inArray(index,"replacePreviousPage"))="true" s outArray(index,"replace")=1
 . . ;i $g(outArray(index,"page"))'="" d
 . . ;. s outArray(index,"nvp")=$g(inArray(index,"nvp"))
 . . i $g(inArray(index,"nvp"))'="" s outArray(index,"nvp")=inArray(index,"nvp")
 . i $g(inArray(index,"text"))'="" d
 . . n value
 . . s value=inArray(index,"text")
 . . i '$d(inArray(index,"child")) d
 . . . s outArray(index,"leaf")="true"
 . . e  d
 . . . i expanded s outArray(index,"expanded")="true" 
 . . s outArray(index,"text")=value
 . . i $g(page)'="" s outArray(index,"page")=page
 . . i $g(addTo)'="" s outArray(index,"addTo")=addTo
 . . i $g(inArray(index,"page"))="",$g(inArray(index,"nextPage"))="",$g(replace)'="" s outArray(index,"replace")=replace
 . . i $g(inArray(index,"page"))'="" s outArray(index,"page")=inArray(index,"page")
 . . i $g(inArray(index,"expanded"))'="" s outArray(index,"expanded")=inArray(index,"expanded")
 . . i $g(inArray(index,"nextPage"))'="" s outArray(index,"page")=inArray(index,"nextPage")
 . . i $g(inArray(index,"addTo"))'="" s outArray(index,"addTo")=inArray(index,"addTo")
 . . i $g(inArray(index,"replacePreviousPage"))="true" s outArray(index,"replace")=1
 . . ;i $g(outArray(index,"page"))'="" s outArray(index,"nvp")=$g(inArray(index,"nvp"))
 . . i $g(inArray(index,"nvp"))'="" s outArray(index,"nvp")=inArray(index,"nvp")
 ;
 QUIT
 ;
writeButtonMenu(sessionName,menuId,page,addTo,replace,sessid)
 ;
 n comma,menu,xArray
 ;
 s text="var "_menuId_"Handler=function(item) {"
 s text=text_"if (typeof item.page !== 'undefined') {"_$c(13,10)
 s text=text_"  var nvp = 'itemId=' + item.id + '&itemText=' + item.text;"_$c(13,10)
 s text=text_"  if (item.nvp !== '') nvp = nvp + '&' + item.nvp;"_$c(13,10)
 s text=text_"  if (typeof item.addTo !== 'undefined') nvp = nvp + '&ext4_addTo=' + item.addTo;"_$c(13,10)
 s text=text_"  if (item.replace === 1) nvp = nvp + '&ext4_removeAll=true';"_$c(13,10)
 s text=text_"  EWD.item=item;"_$c(13,10)
 s text=text_"  EWD.nvp=nvp;"_$c(13,10)
 s text=text_"  EWD.ajax.getPage({page:item.page,nvp:nvp});"_$c(13,10)
 s text=text_"}"_$c(13,10)
 s text=text_"};"_$c(13,10)
 d writeLine(text)
 d mergeArrayFromSession^%zewdAPI(.menu,sessionName,sessid)
 d expandMenuArray(.menu,.xArray,page,addTo,replace,menuId)
 d writeLine("var "_menuId_"=")
 d streamArrayToJSON^%zewdJSON("xArray")
 d writeLine(";"_$c(13,10))
 QUIT
 ;
expandMenuArray(inArray,outArray,page,addTo,replace,menuId,id)
 ;
 n data,index
 ;
 s index=""
 s id=+$g(id)
 f  s index=$o(inArray(index)) q:index=""  d
 . s data=$d(inArray(index))
 . s id=id+1
 . s outArray(index,"id")=menuId_"Item"_id
 . i $d(inArray(index,"child")) d
 . . n arr,out
 . . m arr=inArray(index,"child")
 . . d expandMenuArray(.arr,.out,page,addTo,replace,menuId,.id)
 . . m outArray(index,"menu")=out
 . . i $g(inArray(index,"text"))'="" s outArray(index,"text")=inArray(index,"text")
 . . i $g(page)'="" s outArray(index,"page")=page
 . . i $g(addTo)'="" s outArray(index,"addTo")=addTo
 . . i $g(inArray(index,"page"))="",$g(inArray(index,"nextPage"))="",$g(replace)'="" s outArray(index,"replace")=replace
 . . i $g(inArray(index,"page"))'="" s outArray(index,"page")=inArray(index,"page")
 . . i $g(inArray(index,"nextPage"))'="" s outArray(index,"page")=inArray(index,"nextPage")
 . . i $g(inArray(index,"addTo"))'="" s outArray(index,"addTo")=inArray(index,"addTo")
 . . i $g(inArray(index,"replacePreviousPage"))="true" s outArray(index,"replace")=1
 . . i $g(outArray(index,"page"))'="" d
 . . . s outArray(index,"nvp")=$g(inArray(index,"nvp"))
 . i $g(inArray(index,"text"))'="" d
 . . n value
 . . s value=inArray(index,"text")
 . . s outArray(index,"text")=value
 . . i $g(page)'="" s outArray(index,"page")=page
 . . i $g(addTo)'="" s outArray(index,"addTo")=addTo
 . . i $g(inArray(index,"page"))="",$g(inArray(index,"nextPage"))="",$g(replace)'="" s outArray(index,"replace")=replace
 . . i $g(inArray(index,"page"))'="" s outArray(index,"page")=inArray(index,"page")
 . . i $g(inArray(index,"nextPage"))'="" s outArray(index,"page")=inArray(index,"nextPage")
 . . i $g(inArray(index,"addTo"))'="" s outArray(index,"addTo")=inArray(index,"addTo")
 . . i $g(inArray(index,"replacePreviousPage"))="true" s outArray(index,"replace")=1
 . . i $g(outArray(index,"page"))'="" s outArray(index,"nvp")=$g(inArray(index,"nvp"))
 . . i '$d(inArray(index,"child")) s outArray(index,"listeners","click")="<?= "_menuId_"Handler ?>"
 ;
 QUIT
 ;
writeComboBoxStore(fieldName,sessid)
 ;
 n comma,d,list,name,no,value,values
 ;
 d mergeArrayFromSession^%zewdAPI(.list,"ewd_list",sessid)
 d writeLine("var "_fieldName_"=Ext.create('Ext.data.Store',{"_$c(13,10))
 d writeLine(" fields:['name','value'],"_$c(13,10))
 d writeLine(" data:[")
 s no="",comma=""
 f  s no=$o(list(fieldName,no)) q:no=""  d
 . s d=list(fieldName,no)
 . s name=$p(d,$c(1),1)
 . s value=$p(d,$c(1),2)
 . ;d writeLine(comma_"  {'name':'"_name_"','value':'"_value_"'}"_$c(13,10))
 . d writeLine(comma_"  {'name':'"_name_"','value':'"_value_"'}")
 . w !
 . s comma=","
 d writeLine(" ]"_$c(13,10))
 d writeLine("});"_$c(13,10))
 ;
 d getMultipleSelectValues^%zewdAPI(fieldName,.values,sessid)
 i $d(values) d
 . d writeLine("EWD.ext4.form['"_fieldName_"'] = [")
 . s value="",comma=""
 . f  s value=$o(values(value)) q:value=""  d
 . . d writeLine(comma_"'"_value_"'")
 . . s comma=","
 . d writeLine("];"_$c(13,10))
 ;
 QUIT
 ;
optionsFromList(listName,dataIndex,gridId,sessid)
 ;
 n array1,array2,comma,d,display,lists,no,value
 ;
 d mergeArrayFromSession^%zewdAPI(.lists,"ewd_list",sessid)
 s array1="",array2="",comma=""
 s no=""
 f  s no=$o(lists(listName,no)) q:no=""  d
 . s d=lists(listName,no)
 . s display=$p(d,$c(1),1)
 . s value=$p(d,$c(1),2)
 . s array1=array1_comma_"['"_value_"','"_display_"']"
 . s array2=array2_comma_"'"_value_"':'"_display_"'"
 . s comma=","
 d writeLine("EWD.ext4.grid['"_gridId_"'].combo.store['"_dataIndex_"']=["_$c(13,10))
 d writeLine(array1_$c(13,10))
 d writeLine("];"_$c(13,10))
 d writeLine("EWD.ext4.grid['"_gridId_"'].combo.index['"_dataIndex_"']={"_$c(13,10))
 d writeLine(array2_$c(13,10))
 d writeLine("};"_$c(13,10))
 QUIT
 ;
writeJSONStore(sessionName,chartDef,id,storeId,sessid)
 ;
 n array,chart,chartProps,fieldName,fieldNo,json,lastRow,recordNo,value
 ;
 s storeId=$g(storeId)
 i chartDef'="" d
 . n axes,legend,series
 . d mergeArrayFromSession^%zewdAPI(.chartProps,chartDef,sessid)
 . m axes=chartProps("axes")
 . m series=chartProps("series")
 . m legend=chartProps("legend")
 . d writeLine("EWD.ext4.chart['"_id_"'] = {};"_$c(13,10))
 . d writeLine("EWD.ext4.chart['"_id_"'].axes=")
 . d streamArrayToJSON^%zewdJSON("axes")
 . d writeLine(";"_$c(13,10))
 . d writeLine("EWD.ext4.chart['"_id_"'].series=")
 . d streamArrayToJSON^%zewdJSON("series")
 . d writeLine(";"_$c(13,10))
 . d writeLine("EWD.ext4.chart['"_id_"'].legend=")
 . i $d(legend) d
 . . d streamArrayToJSON^%zewdJSON("legend")
 . e  d
 . . d writeLine("false")
 . d writeLine(";"_$c(13,10))
 ;
 d writeLine("var "_storeId_"=Ext.create('Ext.data.JsonStore',")
 d mergeArrayFromSession^%zewdAPI(.chart,sessionName,sessid)
 ;
 ; find maximum row number
 s fieldName="",maxRow=0
 f  s fieldName=$o(chart(fieldName)) q:fieldName=""  d
 . s lastRow=$o(chart(fieldName,""),-1)
 . i lastRow>maxRow s maxRow=lastRow
 ;
 s fieldName="",fieldNo=0
 f  s fieldName=$o(chart(fieldName)) q:fieldName=""  d
 . s fieldNo=fieldNo+1
 . s array("fields",fieldNo)=fieldName
 . f recordNo=1:1:maxRow d
 . . s value=$g(chart(fieldName,recordNo))
 . . s array("data",recordNo,fieldName)=value
 s array("id")=storeId
 d streamArrayToJSON^%zewdJSON("array")
 d writeLine(");"_$c(13,10))
 QUIT
 ;
writeDesktopConfig(sessionName,sessid)
 ;
 n desktop,no
 ;
 d mergeArrayFromSession^%zewdAPI(.desktop,sessionName,sessid)
 s no=""
 f  s no=$o(desktop("windows",no)) q:no=""  d
 . i $g(desktop("windows",no,"title"))="" s desktop("windows",no,"title")="Unnamed Window"
 . i $g(desktop("windows",no,"name"))="" s desktop("windows",no,"name")="Unnamed Icon"
 . i $g(desktop("windows",no,"iconCls"))="" s desktop("windows",no,"iconCls")="accordion-shortcut"
 . i $g(desktop("windows",no,"id"))="" s desktop("windows",no,"id")="win"_no
 . i $g(desktop("windows",no,"width"))="" s desktop("windows",no,"width")=300
 . i $g(desktop("windows",no,"height"))="" s desktop("windows",no,"height")=400
 . i $g(desktop("windows",no,"fragment"))="" s desktop("windows",no,"fragment")="unspecifiedFragment"
 . i $g(desktop("windows",no,"quickStart"))="" s desktop("windows",no,"quickStart")="false"
 i $g(desktop("logoutFn"))="" s desktop("logoutFn")="function() {alert('No Logout Function was specified');}"
 s desktop("logoutFn")="<?= "_desktop("logoutFn")_" ?>"
 i $g(desktop("username"))="" s desktop("username")="Unspecified User"
 d writeLine("EWD.desktop=")
 d streamArrayToJSON^%zewdJSON("desktop")
 d writeLine(";"_$c(13,10))
 QUIT
 ;
writeJSONContent(sessionName,parentId,configOption,xtype,sessid)
 ;
 n def,no
 ;
 d mergeArrayFromSession^%zewdAPI(.def,sessionName,sessid)
 ;i xtype="form" d formArray(configOption,.def)
 i xtype="form" d
 . n id,no
 . s no=$o(def(""),-1)+1
 . s id="ewd_action"_parentId
 . s def(no,"name")="ewd_action"
 . s def(no,"id")=id
 . s def(no,"value")="zewdSTForm"_parentId
 . s def(no,"xtype")="hiddenfield"
 i $$substValues(.def,sessid)
 d formArray(configOption,.def)
 d writeLine("if (typeof EWD.ext4.items['"_parentId_"'] === 'undefined') EWD.ext4.items['"_parentId_"']={};"_$c(13,10))
 d writeLine("EWD.ext4.items['"_parentId_"']['"_configOption_"']=")
 d streamArrayToJSON^%zewdJSON("def")
 d writeLine(";"_$c(13,10))
 QUIT
 ;
writeArchitectContent(device,filepath,parentId,configOption,sessid)
 ;
 n array,def,ok
 ;
 i device="file" d
 . s ok=$$ExtJSToArray(filepath,.array)
 i device="global" d
 . m array=^zewd("extjs",filepath,parentId)
 i '$d(array(1)) d
 . m def(1)=array
 e  d
 . m def=array
 i $$substValues(.def,sessid)
 d formArray(configOption,.def)
 d writeLine("if (typeof EWD.ext4.items['"_parentId_"'] === 'undefined') EWD.ext4.items['"_parentId_"']={};"_$c(13,10))
 d writeLine("EWD.ext4.items['"_parentId_"']['"_configOption_"']=")
 d streamArrayToJSON^%zewdJSON("def")
 d writeLine(";"_$c(13,10))
 QUIT
 ;
substValues(def,sessid)
 ;
 n changed,config,value
 ;
 s config=""
 s changed=0
 f  s config=$o(def(config)) q:config=""  d
 . s value=$g(def(config))
 . d
 . . i $e(value,1)="#",$e(value,2)'="#" d  q
 . . . s value=$e(value,2,$l(value))
 . . . s def(config)=$$getSessionValue^%zewdAPI(value,sessid)
 . . . s changed=1
 . . i $e(value,1)="[" d
 . . . n array,sessionName
 . . . s sessionName=$e(value,2,$l(value-1))
 . . . d mergeArrayToSession^%zewdAPI(.array,sessionName,sessid)
 . . . m def(config)=array
 . i $d(def(config))=10 d
 . . n subArray
 . . m subArray=def(config)
 . . s changed=$$substValues(.subArray,sessid)
 . . i changed d
 . . . k def(config)
 . . . m def(config)=subArray
 QUIT changed
 ;
formArray(configOption,def,subLevel,formInfo,formId)
 ;
 n array,id,info,ino,name,no,sarray,sessionArray,type,xtype
 ;
 i '$d(def(1)) d  q
 . s xtype=$g(def("xtype"))
 . i xtype="form" d
 . . n subItems
 . . m subItems=def("items")
 . . i $d(subItems) d
 . . . d formArray("items",.subItems)
 . . . k def("items")
 . . . m def("items")=subItems
 ;
 i configOption="items" d
 . s ino=""
 . i $g(subLevel)="" s formInfo=""
 . f  s ino=$o(def(ino)) q:ino=""  d
 . . s id=$g(def(ino,"id"))
 . . s name=$g(def(ino,"name"))
 . . i name="ewd_action" d
 . . . d setMethodAndNextPage^%zewdWLD(def(ino,"value"),"","",formInfo,.sessionArray)
 . . . m ^%zewdSession("action",sessid)=sessionArray("ewd_Action") break
 . . s xtype=$g(def(ino,"xtype"))
 . . i xtype="" s xtype=$g(def(ino,"ptype"))
 . . ;
 . . i xtype="form" d
 . . . n aid,subItems
 . . . i id="" d
 . . . . s id=parentId_"form"_ino
 . . . . s def(ino,"id")=id
 . . . m subItems=def(ino,"items")
 . . . i $d(subItems) d
 . . . . d formArray("items",.subItems,1,.formInfo,id)
 . . . . k def(ino,"items")
 . . . . m def(ino,"items")=subItems
 . . . s no=$o(def(ino,"items",""),-1)+1
 . . . s aid="ewd_action"_id
 . . . s def(ino,"items",no,"name")="ewd_action"
 . . . s def(ino,"items",no,"id")=aid
 . . . s def(ino,"items",no,"value")="zewdSTForm"_parentId
 . . . s def(ino,"items",no,"xtype")="hiddenfield"
 . . . d setMethodAndNextPage^%zewdWLD(def(ino,"items",no,"value"),"","",formInfo,.sessionArray)
 . . . m ^%zewdSession("action",sessid)=sessionArray("ewd_Action") 
 . . ;
 . . i xtype="radiogroup"!(xtype="checkboxgroup")!(xtype="fieldset")!(xtype="fieldcontainer")!(xtype="toolbar") d  q
 . . . n subItems
 . . . m subItems=def(ino,"items")
 . . . i $d(subItems) d
 . . . . d formArray(configOption,.subItems,$g(subLevel)+1,.formInfo,$g(formId))
 . . . . k def(ino,"items")
 . . . . m def(ino,"items")=subItems
 . . s type="text"
 . . i xtype="radiofield" s type="radio"
 . . i xtype="checkboxfield" s type="checkbox"
 . . i xtype="textareafield" s type="textarea"
 . . i xtype["field" d
 . . . d
 . . . . i id="",name'="" d  q
 . . . . . i type="checkbox"!(type="radio") s def(ino,"id")=name_ino q
 . . . . . s def(ino,"id")=name q
 . . . . i id'="",name="" s def(ino,"name")=id q
 . . . . i id="",name="" d
 . . . . . s def(ino,"id")="undefinedField"
 . . . . . s def(ino,"name")="undefinedField"
 . . . s info=def(ino,"name")_"|"_type
 . . . i formInfo'[info s formInfo=formInfo_info_"`"
 . . . i type="text"!(type="textarea"),name'="ewd_action" s def(ino,"value")=$$getSessionValue^%zewdAPI(def(ino,"name"),sessid)
 . . . i type="radio"!(type="checkbox") d  q
 . . . . k def(ino,"checked")
 . . . . i type="radio",$g(def(ino,"inputValue"))=$$getSessionValue^%zewdAPI(def(ino,"name"),sessid) s def(ino,"checked")="true"
 . . . . i type="checkbox",$$isCheckboxOn^%zewdAPI(def(ino,"name"),$g(def(ino,"inputValue")),sessid) s def(ino,"checked")="true"
 . . i xtype="combobox" d
 . . . n d,fname,list,name,no,store,value
 . . . s fname=def(ino,"name")
 . . . k def(ino,"store")
 . . . s def(ino,"displayField")="name"
 . . . s def(ino,"valueField")="value"
 . . . s def(ino,"queryMode")="local"
 . . . s def(ino,"store","fields",1)="name"
 . . . s def(ino,"store","fields",2)="value"
 . . . d mergeArrayFromSession^%zewdAPI(.list,"ewd_list",sessid)
 . . . s no=""
 . . . f  s no=$o(list(fname,no)) q:no=""  d
 . . . . s d=list(fname,no)
 . . . . s name=$p(d,$c(1),1)
 . . . . s value=$p(d,$c(1),2)
 . . . . s def(ino,"store","data",no,"name")=name
 . . . . s def(ino,"store","data",no,"value")=value
 . . i xtype="button" d buttonHandler(ino,$g(formId),.def)
 . . i xtype="form",$d(def(ino,"dockedItems")) d
 . . . n subItems
 . . . m subItems=def(ino,"dockedItems")
 . . . i $d(subItems) d
 . . . . d formArray(configOption,.subItems,$g(subLevel)+1,.formInfo,id)
 . . . . k def(ino,"dockedItems")
 . . . . m def(ino,"dockedItems")=subItems
 ;
 i configOption="buttons" d
 . n addTo,bno,nextpage,replace
 . s bno=""
 . f  s bno=$o(def(bno)) q:bno=""  d
 . . d buttonHandler(bno,parentId,.def)
 QUIT
 ;
buttonHandler(no,parentId,def)
 ;
 n addTo,nextpage,replace
 ;
 s nextpage=$g(def(no,"nextpage")) k def(no,"nextpage")
 s addTo=$g(def(no,"addTo")) 
 k def(no,"addTo")
 ;i addTo="" s addTo="undefinedContainer"
 s replace=$g(def(no,"replacePreviousPage"))
 k def(no,"replacePreviousPage")
 i replace="" s replace=0
 i replace="true" s replace=1
 i nextpage'="" s def(no,"handler")="function() {EWD.ext4.submit('"_parentId_"','"_nextpage_"','"_addTo_"',"_replace_")}"
 QUIT
 ;
clearFieldErrors(sessid)
 d deleteFromSession^%zewdAPI("ewd_form",sessid)
 QUIT
 ;
setFieldError(field,error,sessid)
 ;
 n fieldErrors,message
 ;
 s fieldErrors("fieldError",field)=error
 d mergeArrayToSession^%zewdAPI(.fieldErrors,"ewd.form",sessid)
 ;
 QUIT
 ;
isFormErrors(sessid)
 n fieldErrors
 d mergeArrayFromSession^%zewdAPI(.fieldErrors,"ewd.form",sessid)
 QUIT $d(fieldErrors("fieldError"))
 ;
formErrors(sessid)
 ;
 n alertMessage,alertTitle,error,errorMsg,errors,field,fieldErrors,js
 ;
 d mergeArrayFromSession^%zewdAPI(.errors,"ewd_form",sessid)
 i '$d(errors("fieldError")) QUIT ""
 s alertMessage=$g(errors("alertMessage"))
 i alertMessage="" s alertMessage="Errors were reported in your form"
 s alertTitle=$g(errors("alertTitle"))
 i alertTitle="" s alertTitle="Form Validation"
 ;
 s error="Ext.Msg.alert('"_alertTitle_"','"_alertMessage_"');"
 s field=""
 f  s field=$o(errors("fieldError",field)) q:field=""  d
 . s errorMsg=errors("fieldError",field)
 . s error=error_"Ext.getCmp('"_field_"').markInvalid('"_errorMsg_"');"
 d deleteFromSession^%zewdAPI("ewd_form",sessid)
 ;
 s js="js"
 i $$isCSP^%zewdAPI(sessid) s js="javascript"
 QUIT js_": "_error
 ;
setFieldErrorAlert(title,message,sessid)
 s title=$$zcvt^%zewdPHP($g(title),"o","JS")
 s message=$$zcvt^%zewdPHP($g(message),"o","JS")
 d setSessionValue^%zewdAPI("ewd.form.alertTitle",title,sessid)
 d setSessionValue^%zewdAPI("ewd.form.alertMessage",message,sessid)
 QUIT
 ;
writeCalendarData(appts)
 ;
 n data
 ;
 m data("evts")=appts
 d writeLine("EWD.calendar.apptData = ")
 d streamArrayToJSON^%zewdJSON("data")
 d writeLine(";"_$c(13,10))
 QUIT
 ;
createJSONObject(varName,array,addVar)
 ;
 n line
 ;
 s addVar=$g(addVar) i addVar="" s addVar=1
 ;
 s line="data = "
 i addVar s line="var "_line
 d writeLine(line)
 d streamArrayToJSON^%zewdJSON($name(array))
 d writeLine(";"_$c(13,10))
 QUIT
 ;
addCalendarEvent(varName,mrefresh)
 ;
 n refresh
 ;
 s varName=$g(varName) i varName="" s varName="data"
 s refresh="false"
 i $g(mrefresh) s refresh="true"
 ;
 d writeLine("EWD.calendar.addEvent("_varName_","_refresh_");"_$c(13,10))
 QUIT
 ;
calendarRefresh
 ;
 d writeLine("EWD.calendar.refresh();"_$c(13,10))
 QUIT
 ;
calendarClear
 ;
 n io
 ;
 s io=$io
 u io:width=1048576 ;Set device's logical record size to the max
 d writeLine("EWD.calendar.clear();"_$c(13,10))
 QUIT
 ;
ExtJSToArray(filepath,array,maxlength)
 ;
 n i,io,line,nlines,ok,json
 ;
 s io=$io
 k ^CacheTempEWD($j)
 s nlines=$$importFile^%zewdHTMLParser(filepath,$g(maxLength))
 u io
 s json=""
 f i=1:1:nlines d
 . s line=$g(^CacheTempEWD($j,i))
 . s line=$$replaceAll^%zewdAPI(line,$c(13,10),"")
 . s line=$$replaceAll^%zewdAPI(line,$c(10),"")
 . s json=json_line
 k ^CacheTempEWD($j)
 i nlines'>0 QUIT 0
 s ok=$$parseJSON^%zewdJSON(json,.array,1)
 i ok'="" QUIT 0
 QUIT 1
 ;
importExtJS(filepath,app,id,maxlength)
 ;
 n array,i,line,nlines,ok,json
 ;
 s ok=$$ExtJSToArray(filepath,.array,$g(maxlength))
 i 'ok QUIT 0
 s app=$$zcvt^%zewdAPI(app,"l")
 s id=$$zcvt^%zewdAPI(id,"l")
 k ^zewd("extjs",app,id)
 m ^zewd("extjs",app,id)=array
 QUIT 1
 ;
getExtJS(sessionName,app,id,sessid)
 ;
 n array
 ;
 i $g(app)="" QUIT
 i $g(id)="" QUIT
 m array=^zewd("extjs",app,id)
 d deleteFromSession^%zewdAPI(sessionName,sessid)
 d mergeArrayToSession^%zewdAPI(.array,sessionName,sessid)
 QUIT
 ;
createExtFuncs()
 n text
 ;
 s text=""
 s text=text_"EWD.ext4={"_$c(13,10)
 s text=text_"  form: {},"_$c(13,10)
 s text=text_"  chart: {},"_$c(13,10)
 s text=text_"  items: {},"_$c(13,10)
 s text=text_"  grid: {},"_$c(13,10)
 s text=text_"  textarea: {},"_$c(13,10)
 s text=text_"  setGauge: function(id,value) {"_$c(13,10)
 s text=text_"    Ext.getCmp(id).store.loadData([{value:value}]);"_$c(13,10)
 s text=text_"  },"_$c(13,10)
 s text=text_"  setScatterRadius: function(series,field,factor) {"_$c(13,10)
 s text=text_"    if (typeof(factor) === 'undefined') factor = 1;"_$c(13,10)
 s text=text_"    var chart = series.chart;"_$c(13,10)
 s text=text_"    var store = chart.store;"_$c(13,10)
 s text=text_"    var items = chart.series.items[0].items;"_$c(13,10)
 s text=text_"    var value;"_$c(13,10)
 s text=text_"    for (var i=0; i < items.length; i++) {"_$c(13,10)
 s text=text_"      value = store.getAt(i).get(field) * factor;"_$c(13,10)
 s text=text_"      items[i].sprite.setAttributes({radius:value},true);"_$c(13,10)
 s text=text_"    }"_$c(13,10)
 s text=text_"  },"_$c(13,10)
 s text=text_"  getGridRowNo: function(grid,rowIndex) {"_$c(13,10)
 s text=text_"    return grid.store.getAt(rowIndex).get('zewdRowNo');"_$c(13,10)
 ;s text=text_"   }"_$c(13,10)
 s text=text_"  },"_$c(13,10)
 s text=text_"  submit: function (formPanelId,nextPage,addTo,replace) {"_$c(13,10)
 s text=text_"    var nvp='';"_$c(13,10)
 s text=text_"    var amp='';"_$c(13,10)
 s text=text_"    var value;"_$c(13,10)
 s text=text_"    var values;"_$c(13,10)
 s text=text_"    Ext.getCmp(formPanelId).getForm().getFields().eachKey("_$c(13,10)
 s text=text_"      function(key,item) {"_$c(13,10)
 s text=text_"        if ((item.xtype === 'combobox')&&(item.multiSelect)) {"_$c(13,10)
 s text=text_"          var values=item.getSubmitValue();"_$c(13,10)
 s text=text_"          for (var i=0; i<values.length; i++) {"_$c(13,10)
 s text=text_"            value=values[i];"_$c(13,10)
 s text=text_"            nvp = nvp + amp + item.getName() + '=' + escape(value);"_$c(13,10)
 s text=text_"            amp='&';"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"        }"_$c(13,10)
 s text=text_"        else if ((item.xtype !== 'radiogroup')&&(item.xtype !== 'checkboxgroup')) {"_$c(13,10)
 s text=text_"          value = '';"_$c(13,10)
 s text=text_"          if (item.xtype === 'textareafield') {"_$c(13,10)
 ;s text=text_"            value = escape(item.getValue());"_$c(13,10)
 s text=text_"            value = item.getValue();"_$c(13,10)
 s text=text_"            value = value.replace(/\+/g, '%2B');"_$c(13,10)
 ;s text=text_"            console.log('ta: ' + value)"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else if (item.xtype === 'htmleditor') {"_$c(13,10)
 ;s text=text_"            value = escape(item.getValue());console.log(value);"_$c(13,10)
 s text=text_"            value = item.getValue();"_$c(13,10)
 s text=text_"            value = value.replace(/%3Cbr%3E/g, '%0A');"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else {"_$c(13,10)
 s text=text_"            if (item.getSubmitValue() !== null) value = item.getSubmitValue();"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          if ((item.xtype !== 'radiofield')&&(item.xtype !== 'checkboxfield')) {"_$c(13,10)
 s text=text_"            nvp = nvp + amp + item.getName() + '=' + escape(value);"_$c(13,10)
 s text=text_"            amp='&';"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else {"_$c(13,10)
 s text=text_"            if (value !== '') {"_$c(13,10)
 s text=text_"              nvp = nvp + amp + item.getName() + '=' + value;"_$c(13,10)
 s text=text_"            }"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"        }"_$c(13,10)
 s text=text_"      }"_$c(13,10)
 s text=text_"    );"_$c(13,10)
 s text=text_"    if (addTo !== '') nvp = nvp + '&ext4_addTo=' + addTo;"_$c(13,10)
 s text=text_"    if (replace === 1) nvp = nvp + '&ext4_removeAll=true';"_$c(13,10)
 s text=text_"    nvp = nvp + '&ewd_framework=extjs4';"_$c(13,10)
 s text=text_"    EWD.ajax.getPage({page:nextPage,nvp:nvp})"_$c(13,10)
 s text=text_"  }"_$c(13,10)
 s text=text_"};"_$c(13,10)
 QUIT text
 ;
