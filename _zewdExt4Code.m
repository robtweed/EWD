%zewdExt4Code ; Extjs 4 Runtime Logic
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
preProcess(sessid)
 ;
 n name,var
 ;
 ; Panel addTo pre-processing
 ;
 f name="ext4_addTo","ext4_removeAll" d
 . d deleteFromSession^%zewdAPI(name,sessid)
 . s var=$$getRequestValue^%zewdAPI(name,sessid)
 . i var'="" d setSessionValue^%zewdAPI(name,var,sessid)
 ;
 QUIT
 ;
gridValidationPass()
 QUIT "js:var e=EWD.ext4.e;e.record.commit();"
 ;
gridValidationFail(sessid,alertMessage,alertTitle)
 n js,originalValue,value
 s originalValue=$$getRequestValue^%zewdAPI("originalValue",sessid)
 s value=$$getRequestValue^%zewdAPI("value",sessid)
 s alertTitle=$g(alertTitle) i alertTitle="" s alertTitle="Validation Error"
 s alertMessage=$g(alertMessage) i alertMessage="" s alertMessage="Invalid value: "_value
 QUIT "js:var e=EWD.ext4.e;e.record.data[e.field] = '"_originalValue_"'; e.record.commit();Ext.Msg.alert('"_alertTitle_"','"_alertMessage_"');"
 ; 
writeGridStore(sessionName,columnDef,id,storeId,sessid)
 ;
 ; Generate and write out the Model, Store and Column 
 ; definitions for a gridPanel
 ;
 n cols,comma,comma2,data,grouping,name,namex,no,value
 ;
 i columnDef'="" d mergeArrayFromSession^%zewdAPI(.cols,columnDef,sessid)
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 ;
 ; Model
 ;
 s grouping=0
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
 . . s value=data(no,name)
 . . w comma2_name_":"_$$quotedValue(value)
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
 w "var comboIndex = {};"_$c(13,10)
 f  s no=$o(cols(no)) q:no=""  d
 . i $d(cols(no,"options")) d
 . . n comma,ono
 . . w "var combo"_no_"Store=["_$c(13,10)
 . . s ono="",comma=""
 . . f  s ono=$o(cols(no,"options",ono)) q:ono=""  d
 . . . w comma_"['"_$g(cols(no,"options",ono,"value"))_"','"_$g(cols(no,"options",ono,"displayValue"))_"']"
 . . . s comma=","
 . . w "];"_$c(13,10)
 . . ;w "comboIndex['"_(no-1)_"']={"_$c(13,10)
 . . w "comboIndex['"_(no)_"']={"_$c(13,10)
 . . s ono="",comma=""
 . . f  s ono=$o(cols(no,"options",ono)) q:ono=""  d
 . . . w comma_"'"_$g(cols(no,"options",ono,"value"))_"':'"_$g(cols(no,"options",ono,"displayValue"))_"'"
 . . . s comma=","
 . . w "};"_$c(13,10)
 . . s cols(no,"renderer")=".function (value, metaData, record, rowIndex, colIndex) {return comboIndex[colIndex][value];}"
 ;
 ; Columns
 ;
 i columnDef'="" d
 . w "var "_id_"Cols=["
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
 . . . . . f  s attr=$o(cols(no,"icon",iconNo,attr)) q:attr=""  d
 . . . . . . s value=cols(no,"icon",iconNo,attr)
 . . . . . . w comma4_attr_":"_$$quotedValue(value)
 . . . . . . s comma4=","
 . . . . . w "}"
 . . . . . s comma3=","
 . . . . w "]"
 . . . i name="editas" d  q
 . . . . n key,value2
 . . . . w comma2_"editor: {xtype:'"_value_"'"
 . . . . i value="combobox" d
 . . . . . i $g(cols(no,"editor","typeAhead"))="" s cols(no,"editor","typeAhead")="true"
 . . . . . i $g(cols(no,"editor","triggerAction"))="" s cols(no,"editor","triggerAction")="all"
 . . . . . i $g(cols(no,"editor","selectOnTab"))="" s cols(no,"editor","selectOnTab")="true"
 . . . . . i $g(cols(no,"editor","lazyRender"))="" s cols(no,"editor","lazyRender")="true"
 . . . . . i $g(cols(no,"editor","listClass"))="" s cols(no,"editor","listClass")="x-combo-list-small"
 . . . . . s cols(no,"editor","store")=".combo"_no_"Store"
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
 . i value="true"!(value="false") q
 . i $$numeric^%zewdJSON(value) q
 . i $e(value,1)="." s value=$e(value,2,$l(value)) q
 . i $e(value,1,9)="function(" q
 . i $e(value,1)="|" s value=$e(value,2,$l(value))
 . s value="'"_value_"'"
 QUIT value
 ;
writeTreeStore(sessionName,storeId,page,addTo,replace,expanded,sessid)
 ;
 n data,xArray,yArray
 ;
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 d expandTreeArray(.data,.xArray,page,addTo,replace)
 m yArray("root","children")=xArray
 s yArray("id")=storeId
 s yArray("expanded")="false"
 i expanded s yArray("expanded")="true"
 w "var "_storeId_"=Ext.create('Ext.data.TreeStore',"
 d streamArrayToJSON^%zewdJSON("yArray")
 w ");"_$c(13,10)
 ;
 QUIT
 ;
expandTreeArray(inArray,outArray,page,addTo,replace)
 ;
 n data,index
 ;
 s index=""
 f  s index=$o(inArray(index)) q:index=""  d
 . s data=$d(inArray(index))
 . i $d(inArray(index,"child")) d
 . . n arr,out
 . . m arr=inArray(index,"child")
 . . d expandTreeArray(.arr,.out,page,addTo,replace)
 . . m outArray(index,"children")=out
 . . i $g(inArray(index,"text"))'="" s outArray(index,"text")=inArray(index,"text")
 . . i $g(page)'="" s outArray(index,"page")=page
 . . i $g(addTo)'="" s outArray(index,"addTo")=page
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
 . . i '$d(inArray(index,"child")) s outArray(index,"leaf")="true"
 . . s outArray(index,"text")=value
 . . i $g(page)'="" s outArray(index,"page")=page
 . . i $g(addTo)'="" s outArray(index,"addTo")=addTo
 . . i $g(inArray(index,"page"))="",$g(inArray(index,"nextPage"))="",$g(replace)'="" s outArray(index,"replace")=replace
 . . i $g(inArray(index,"page"))'="" s outArray(index,"page")=inArray(index,"page")
 . . i $g(inArray(index,"nextPage"))'="" s outArray(index,"page")=inArray(index,"nextPage")
 . . i $g(inArray(index,"addTo"))'="" s outArray(index,"addTo")=inArray(index,"addTo")
 . . i $g(inArray(index,"replacePreviousPage"))="true" s outArray(index,"replace")=1
 . . i $g(outArray(index,"page"))'="" s outArray(index,"nvp")=$g(inArray(index,"nvp"))
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
 n comma,d,list,name,no,value
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
 n alertMessage,alertTitle,error,errorMsg,errors,field,fieldErrors
 ;
 d mergeArrayFromSession^%zewdAPI(.errors,"ewd_form",sessid)
 k ^rltErrors m ^rltErrors=errors
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
 s ^rltError=error
 d deleteFromSession^%zewdAPI("ewd_form",sessid)
 ;
 QUIT "js: "_error
 ;
setFieldErrorAlert(title,message,sessid)
 s title=$$zcvt^%zewdPHP($g(title),"o","JS")
 s message=$$zcvt^%zewdPHP($g(message),"o","JS")
 d setSessionValue^%zewdAPI("ewd.form.alertTitle",title,sessid)
 d setSessionValue^%zewdAPI("ewd.form.alertMessage",message,sessid)
 QUIT
 ;
desktopJS ;
 ;;Ext.Loader.setConfig({enabled:true});
 ;;Ext.override(Ext.ux.desktop.Desktop, {
 ;;  shortcutTpl: [
 ;;    '<tpl for=".">',
 ;;      '<div class="ux-desktop-shortcut" id="{name}-shortcut"',
 ;;        '<tpl if="position == \'absolute\'">',
 ;;          ' style="position:absolute;left:{left}px;top:{top}px;"',
 ;;        '</tpl>',
 ;;        '>',
 ;;        '<div class="ux-desktop-shortcut-icon {iconCls}">',
 ;;          '<img src="',Ext.BLANK_IMAGE_URL,'" title="{name}">',
 ;;        '</div>',
 ;;        '<span class="ux-desktop-shortcut-text">{name}{extra}</span>',
 ;;      '</div>',
 ;;    '</tpl>',
 ;;    '<div class="x-clear"></div>'
 ;;  ],
 ;;});
 ;;Ext.define('EWDDesktop.Window', {
 ;;  extend: 'Ext.ux.desktop.Module',
 ;;  init : function(){
 ;;    var window = this;
 ;;    this.launcher = {
 ;;      text: window.name,
 ;;      iconCls:'accordion',
 ;;      handler : this.createWindow,
 ;;      scope: this
 ;;    };
 ;;  },
 ;;  createWindow : function(){
 ;;    var desktop = this.app.getDesktop();
 ;;    var win = desktop.getWindow(this.id);
 ;;    var window = this;
 ;;    EWD.window = this;
 ;;    if (typeof window.windowIconCls === 'undefined') window.windowIconCls = 'accordion';
 ;;    if (typeof window.width === 'undefined') window.width = 300;
 ;;    if (typeof window.height === 'undefined') window.height = 400;
 ;;    if (typeof window.title === 'undefined') window.title = 'Unnamed Window';
 ;;    if (typeof window.fragment === 'undefined') window.fragment = 'undefinedFragment';
 ;;    if (!win) {
 ;;      win = desktop.createWindow({
 ;;        id: window.id,
 ;;        title: window.title,
 ;;        width: window.width,
 ;;        height: window.height,
 ;;        iconCls: window.windowIconCls,
 ;;        animCollapse: false,
 ;;        constrainHeader: true,
 ;;        bodyBorder: true,
 ;;        layout: 'accordion',
 ;;        border: false,
 ;;        listeners: {
 ;;          render: function() {
 ;;            EWD.ajax.getPage({page:window.fragment, nvp:'ext4_addTo=' + window.id});
 ;;          }
 ;;        }
 ;;      });
 ;;    }
 ;;    win.show();
 ;;    return win;
 ;;  }
 ;;});
 ;;Ext.define('EWDDesktop.App', {
 ;;  extend: 'Ext.ux.desktop.App',
 ;;  init: function() {
 ;;    // custom logic before getXYZ methods get called...
 ;;    this.callParent();
 ;;    // now ready...
 ;;  },
 ;;  getModules : function(){
 ;;    var window;
 ;;    var modules = [];
 ;;    for (var no = 0; no < EWD.desktop.windows.length; no++) {
 ;;      window = EWD.desktop.windows[no];
 ;;      modules[no] = new EWDDesktop.Window(window);
 ;;    }
 ;;    return modules;
 ;;  },
 ;;  getDesktopConfig: function () {
 ;;    var me = this, ret = me.callParent();
 ;;    var configData = [];
 ;;    var window;
 ;;    for (var no = 0; no < EWD.desktop.windows.length; no++) {
 ;;      window = EWD.desktop.windows[no];
 ;;      if (typeof window.iconCls === 'undefined') window.iconCls = 'accordion-shortcut';
 ;;      if (typeof window.name === 'undefined') window.name = 'Unnamed icon';
 ;;      configData[no] = {
 ;;        name: window.name,
 ;;        iconCls: window.iconCls,
 ;;        module: window.id,
 ;;      };
 ;;      if (window.position === 'absolute') {
 ;;        configData[no].position = 'absolute';
 ;;        configData[no].left = window.left;
 ;;        configData[no].top = window.top;
 ;;      }
 ;;    } 
 ;;    return Ext.apply(ret, {
 ;;      //cls: 'ux-desktop-black',
 ;;      contextMenuItems: [
 ;;        { text: 'Change Settings', handler: me.onSettings, scope: me }
 ;;      ],
 ;;      shortcuts: Ext.create('Ext.data.Store', {
 ;;        model: 'Ext.ux.desktop.ShortcutModel',
 ;;        data: configData
 ;;      }),
 ;;      wallpaper: EWD.desktop.wallpaper,
 ;;      wallpaperStretch: false
 ;;    });
 ;;  },
 ;;  // config for the start menu
 ;;  getStartConfig : function() {
 ;;    var me = this, ret = me.callParent();
 ;;    var cfg = Ext.apply(ret, {
 ;;      title: EWD.desktop.username,
 ;;      iconCls: 'user',
 ;;      id: 'startMenuPanel',
 ;;      height: 300,
 ;;      toolConfig: {
 ;;        width: 100,
 ;;        items: [
 ;;          /*
 ;;          {
 ;;            text:'Settings',
 ;;            iconCls:'settings',
 ;;            handler: me.onSettings,
 ;;            scope: me
 ;;          },
 ;;          '-',
 ;;          */
 ;;          {
 ;;            text:'Logout',
 ;;            iconCls:'logout',
 ;;            handler: me.onLogout,
 ;;            scope: me
 ;;          }
 ;;        ]
 ;;      }
 ;;    });
 ;;    return cfg;
 ;;  },
 ;;  getTaskbarConfig: function () {
 ;;    var ret = this.callParent();
 ;;    var quickStartArr = [];
 ;;    var window;
 ;;    var index = 0;
 ;;    for (var no = 0; no < EWD.desktop.windows.length; no++) {
 ;;      window = EWD.desktop.windows[no];
 ;;      if (typeof window.windowIconCls === 'undefined') window.windowIconCls = 'accordion';
 ;;      if (window.quickStart) {
 ;;        quickStartArr[index] = {
 ;;          name: window.name,
 ;;          iconCls: window.windowIconCls,
 ;;          module: window.id
 ;;        };
 ;;        index++;
 ;;      }
 ;;    }
 ;;    return Ext.apply(ret, {
 ;;      quickStart: quickStartArr,
 ;;      trayItems: [
 ;;        { xtype: 'trayclock', flex: 1 }
 ;;      ]
 ;;    });
 ;;  },
 ;;  onLogout: function () {
 ;;    if (typeof EWD.desktop.logoutFn !== 'undefined') EWD.desktop.logoutFn();
 ;;  },
 ;;  onSettings: function () {
 ;;    return;
 ;;    // optional stuff!
 ;;    var dlg = new MyDesktop.Settings({
 ;;      desktop: this.desktop
 ;;    });
 ;;    dlg.show();
 ;;  }
 ;;});
 ;;***END***
 ;
