%zewdExt4Code ; Extjs 4 Runtime Logic
 ;
 ; Product: Enterprise Web Developer (Build 920)
 ; Build Date: Fri, 25 May 2012 11:57:23
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
writeGridStore(sessionName,columnDef,id,storeId,groupField,sessid)
 ;
 ; Generate and write out the Model, Store and Column 
 ; definitions for a gridPanel
 ;
 n cols,comma,comma2,data,grouping,name,namex,no,value
 ;
 i columnDef'="" d mergeArrayFromSession^%zewdAPI(.cols,columnDef,sessid)
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 ;
 w "EWD.ext4.grid['"_id_"'] = {"_$c(13,10)
 w "  combo: {"_$c(13,10)
 w "    index: {},"_$c(13,10)
 w "    store: {}"_$c(13,10)
 w "  }"_$c(13,10)
 w "};"_$c(13,10)
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
 . w "Ext.define('"_id_"Model',{"
 . w "extend:'Ext.data.Model',"
 . w "fields:["
 . ;s no="",comma=""
 . s no="",comma=","
 . w "{name: 'zewdRowNo'}"
 . f  s no=$o(cols(no)) q:no=""  d
 . . s name=$g(cols(no,"name"))
 . . w comma_"{name:'"_name_"'"
 . . i $g(cols(no,"xtype"))="booleancolumn" w ",type: 'boolean'"
 . . i $g(cols(no,"xtype"))="datecolumn" w ",type: 'date'"
 . . i $g(cols(no,"xtype"))="numbercolumn" w ",type: 'number'"
 . . w "}"
 . . i $g(cols(no,"groupField"))="true" d
 . . . s grouping=name
 . . s comma=","
 . w "]"
 . w "});"_$c(13,10)
 ;
 ; Store
 ;
 w "var "_storeId_"=Ext.create('Ext.data.Store',{"
 w "model:'"_id_"Model',"
 w "id:'"_storeId_"',"
 w "data:["
 s no="",comma=""
 f  s no=$o(data(no)) q:no=""  d
 . w comma_"{"
 . ;s name="",comma2=""
 . s name="",comma2=","
 . w "zewdRowNo: '"_no_"'"
 . f  s name=$o(data(no,name)) q:name=""  d
 . . s value=$g(data(no,name))
 . . w comma2_$$quotedName(name)_":"_$$quotedValue(value)
 . . s comma2=","
 . s comma=","
 . w "}"
 w "]"
 i grouping'=0 w ",groupField:'"_grouping_"'"
 w "});"_$c(13,10)
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
 . . w "EWD.ext4.grid['"_id_"'].combo.store['"_dataIndex_"']=["_$c(13,10)
 . . s ono="",comma=""
 . . f  s ono=$o(cols(no,"options",ono)) q:ono=""  d
 . . . w comma_"['"_$g(cols(no,"options",ono,"value"))_"','"_$g(cols(no,"options",ono,"displayValue"))_"']"
 . . . s comma=","
 . . w "];"_$c(13,10)
 . . w "EWD.ext4.grid['"_id_"'].combo.index['"_dataIndex_"']={"_$c(13,10)
 . . s ono="",comma=""
 . . f  s ono=$o(cols(no,"options",ono)) q:ono=""  d
 . . . w comma_"'"_$g(cols(no,"options",ono,"value"))_"':'"_$g(cols(no,"options",ono,"displayValue"))_"'"
 . . . s comma=","
 . . w "};"_$c(13,10)
 . . s cols(no,"renderer")=".function (value, metaData, record, rowIndex, colIndex) {return EWD.ext4.grid['"_id_"'].combo.index['"_dataIndex_"'][value];}"
 ;
 ; Columns
 ;
 i columnDef'="" d
 . w "EWD.ext4.grid['"_id_"'].cols=["
 . ;w "var "_id_"Cols=["
 . ;s no="",comma=""
 . s no="",comma=","
 . w "{dataIndex:'zewdRowNo', hidden: true}"
 . f  s no=$o(cols(no)) q:no=""  d
 . . w comma_"{"
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
 . . . . . w comma2_"items:["
 . . . . . s comma2=","
 . . . . s iconNo="",comma3=""
 . . . . f  s iconNo=$o(cols(no,"icon",iconNo)) q:iconNo=""  d
 . . . . . w comma3_"{"
 . . . . . s comma4="",attr=""
 . . . . . i $g(cols(no,"icon",iconNo,"nextPage"))'="" d
 . . . . . . n fn,i
 . . . . . . s fn="function(me,rowIndex) {"
 . . . . . . s fn=fn_"var nvp=""row=""+EWD.ext4.getGridRowNo(me,rowIndex);"
 . . . . . . i $g(cols(no,"icon",iconNo,"addTo"))'="" s fn=fn_"nvp=nvp+""&ext4_addTo="_cols(no,"icon",iconNo,"addTo")_""";"
 . . . . . . i $g(cols(no,"icon",iconNo,"replacePreviousPage"))="true" s fn=fn_"nvp=nvp+""&ext4_removeAll=true"";"
 . . . . . . s fn=fn_"; EWD.ajax.getPage({page:"""_cols(no,"icon",iconNo,"nextPage")_""",nvp:nvp});"
 . . . . . . s fn=fn_"}"
 . . . . . . s cols(no,"icon",iconNo,"handler")=fn
 . . . . . . f i="nextPage","addTo","replacePreviousPage" k cols(no,"icon",iconNo,i)
 . . . . . f  s attr=$o(cols(no,"icon",iconNo,attr)) q:attr=""  d
 . . . . . . s value=cols(no,"icon",iconNo,attr)
 . . . . . . w comma4_attr_":"_$$quotedValue(value)
 . . . . . . s comma4=","
 . . . . . w "}"
 . . . . . s comma3=","
 . . . . w "]"
 . . . i name="editas" d  ;  q
 . . . . n key,value2
 . . . . w comma2_"editor: {xtype:'"_value_"'"
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
 . . . . . w ","_key_":"_$$quotedValue(value2)
 . . . . w "}"_$c(13,10)
 . . . . s comma2=","
 . . . w comma2_namex_":"_$$quotedValue(value)
 . . . s comma2=","
 . . s comma=","
 . . w "}"
 . w "];"_$c(13,10)
 ;
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
writeGroupFields(sessionName,id,name,xtype,sessid)
 ;
 n checkedValue,cv,fieldName,fields,itemsId,no,selected
 ;
 d mergeArrayFromSession^%zewdAPI(.fields,sessionName,sessid)
 i xtype="radiofield" s checkedValue=$$getSessionValue^%zewdAPI(name,sessid)
 i xtype="checkboxfield" d mergeFromSelected^%zewdAPI(name,.selected,sessid)
 s itemsId=id_"Items"
 w itemsId_"="_$c(13,10)
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
 w ";"_$c(13,10)
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
 w "var "_storeId_"=Ext.create('Ext.data.TreeStore',"
 d streamArrayToJSON^%zewdJSON("yArray")
 w ");"_$c(13,10)
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
 w text
 d mergeArrayFromSession^%zewdAPI(.menu,sessionName,sessid)
 d expandMenuArray(.menu,.xArray,page,addTo,replace,menuId)
 w "var "_menuId_"="
 d streamArrayToJSON^%zewdJSON("xArray")
 w ";"_$c(13,10)
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
 w "var "_fieldName_"=Ext.create('Ext.data.Store',{"_$c(13,10)
 w " fields:['name','value'],"_$c(13,10)
 w " data:["
 s no="",comma=""
 f  s no=$o(list(fieldName,no)) q:no=""  d
 . s d=list(fieldName,no)
 . s name=$p(d,$c(1),1)
 . s value=$p(d,$c(1),2)
 . w comma_"  {'name':'"_name_"','value':'"_value_"'}"_$c(13,10)
 . s comma=","
 w " ]"_$c(13,10)
 w "});"_$c(13,10)
 ;
 d getMultipleSelectValues^%zewdAPI(fieldName,.values,sessid)
 i $d(values) d
 . w "EWD.ext4.form['"_fieldName_"'] = ["
 . s value="",comma=""
 . f  s value=$o(values(value)) q:value=""  d
 . . w comma_"'"_value_"'"
 . . s comma=","
 . w "];"_$c(13,10)
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
 w "EWD.ext4.grid['"_gridId_"'].combo.store['"_dataIndex_"']=["_$c(13,10)
 w array1_$c(13,10)
 w "];"_$c(13,10)
 w "EWD.ext4.grid['"_gridId_"'].combo.index['"_dataIndex_"']={"_$c(13,10)
 w array2_$c(13,10)
 w "};"_$c(13,10)
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
 . w "EWD.ext4.chart['"_id_"'] = {};"_$c(13,10)
 . w "EWD.ext4.chart['"_id_"'].axes="
 . d streamArrayToJSON^%zewdJSON("axes")
 . w ";"_$c(13,10)
 . w "EWD.ext4.chart['"_id_"'].series="
 . d streamArrayToJSON^%zewdJSON("series")
 . w ";"_$c(13,10)
 . w "EWD.ext4.chart['"_id_"'].legend="
 . i $d(legend) d
 . . d streamArrayToJSON^%zewdJSON("legend")
 . e  d
 . . w "false"
 . w ";"_$c(13,10)
 ;
 w "var "_storeId_"=Ext.create('Ext.data.JsonStore',"
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
 w ");"_$c(13,10)
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
 w "EWD.desktop="
 d streamArrayToJSON^%zewdJSON("desktop")
 w ";"_$c(13,10)
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
createExtFuncs()
 n text
 ;
 s text=""
 s text=text_"EWD.ext4={"_$c(13,10)
 s text=text_"  form: {},"_$c(13,10)
 s text=text_"  chart: {},"_$c(13,10)
 s text=text_"  items: {},"_$c(13,10)
 s text=text_"  grid: {},"_$c(13,10)
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
 s text=text_"            value = escape(item.getValue());"_$c(13,10)
 s text=text_"            value = value.replace(/\+/g, '%2B');"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else if (item.xtype === 'htmleditor') {"_$c(13,10)
 s text=text_"            value = escape(item.getValue());"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else {"_$c(13,10)
 s text=text_"            if (item.getSubmitValue() !== null) value = item.getSubmitValue();"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          if ((item.xtype !== 'radiofield')&&(item.xtype !== 'checkboxfield')) {"_$c(13,10)
 s text=text_"            nvp = nvp + amp + item.getName() + '=' + value;"_$c(13,10)
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
 s text=text_"    EWD.ajax.getPage({page:nextPage,nvp:nvp})"_$c(13,10)
 s text=text_"  }"_$c(13,10)
 s text=text_"};"_$c(13,10)
 QUIT text
 ;
