%zewdSTch2Code ; Sencha Touch 2 Runtime Logic
 ;
 ; Product: Enterprise Web Developer (Build 935)
 ; Build Date: Tue, 14 Aug 2012 12:11:59
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
 ;QUIT
 ;
 ;
preProcess(sessid)
 ;
 n name,page,var,xname
 ;
 ; Panel addTo pre-processing
 ;
 f name="st2_addTo","st2_removeAll","st2_pushTo","st2_masked" d
 . s xname="tmp_"_$p(name,"_",2)
 . d deleteFromSession^%zewdAPI(xname,sessid)
 . s var=$$getRequestValue^%zewdAPI(name,sessid)
 . i var'="" d setSessionValue^%zewdAPI(xname,var,sessid)
 QUIT
 ;
writeLine(line)
 i $$getSessionValue^%zewdAPI("ewd_technology",sessid)="node" d
 . s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=line
 e  d
 . w line
 QUIT
 ;
createExtFuncs()
 n text
 ;
 s text=""
 s text=text_"EWD.st2={"_$c(13,10)
 s text=text_"  form: {},"_$c(13,10)
 s text=text_"  chart: {},"_$c(13,10)
 s text=text_"  items: {},"_$c(13,10)
 s text=text_"  options: {},"_$c(13,10)
 s text=text_"  grid: {},"_$c(13,10)
 s text=text_"  textarea: {},"_$c(13,10)
 s text=text_"  getGridRowNo: function(grid,rowIndex) {"_$c(13,10)
 s text=text_"    return grid.store.getAt(rowIndex).get('zewdRowNo');"_$c(13,10)
 s text=text_"  },"_$c(13,10)
 s text=text_"  submit: function (formPanelId,nextPage,addTo,replace) {"_$c(13,10)
 s text=text_"    var nvp='';"_$c(13,10)
 s text=text_"    var amp='';"_$c(13,10)
 s text=text_"    var value;"_$c(13,10)
 s text=text_"    var name;"_$c(13,10)
 s text=text_"    var i;"_$c(13,10)
 s text=text_"    var values = Ext.getCmp(formPanelId).getValues()"_$c(13,10)
 s text=text_"    var fields = Ext.getCmp(formPanelId).getFields()"_$c(13,10)
 s text=text_"    EWD.fields = fields;"_$c(13,10)
 ;s text=text_"    alert(JSON.stringify(values));"_$c(13,10)
 s text=text_"    for (name in values) {"_$c(13,10)
 s text=text_"      var value = values[name];"_$c(13,10)
 s text=text_"      if (value instanceof Array) {"_$c(13,10)
 ;s text=text_"        alert(name + ' is an array');"_$c(13,10)
 s text=text_"        if (value.length > 0) {"_$c(13,10)
 s text=text_"          for (i = 0; i < value.length; i++) {"_$c(13,10)
 s text=text_"            if (value[i]) nvp = nvp + amp + name + '=' + escape(value[i]);"_$c(13,10)
 s text=text_"            amp='&';"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"        }"_$c(13,10)
 s text=text_"        else {"_$c(13,10)
 s text=text_"          if (fields[name].xtype === 'datepickerfield') {"_$c(13,10)
 ;s text=text_"            alert('day = ' + value.getDate());"_$c(13,10)
 s text=text_"            nvp = nvp + amp + name + '_day=' + value.getDate();"_$c(13,10)
 s text=text_"            amp='&';"_$c(13,10)
 s text=text_"            nvp = nvp + amp + name + '_month=' + (value.getMonth()+1);"_$c(13,10)
 s text=text_"            nvp = nvp + amp + name + '_year=' + value.getFullYear();"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"          else {"_$c(13,10)
 s text=text_"            nvp = nvp + amp + name + '=' + escape(value);"_$c(13,10)
 s text=text_"          }"_$c(13,10)
 s text=text_"        }"_$c(13,10)
 s text=text_"      }"_$c(13,10)
 s text=text_"      else {"_$c(13,10)
 s text=text_"        if (!value) value = '';"_$c(13,10)
 s text=text_"        nvp = nvp + amp + name + '=' + escape(value);"_$c(13,10)
 s text=text_"      }"_$c(13,10)
 s text=text_"      amp='&';"_$c(13,10)
 s text=text_"    }"_$c(13,10)
 ;s text=text_"    alert(JSON.stringify(values));"_$c(13,10)
 ;s text=text_"    Ext.getCmp(formPanelId).getValues().each("_$c(13,10)
 ;s text=text_"      function(key,value,obj) {"_$c(13,10)
 ;s text=text_"        if ((item.xtype === 'combobox')&&(item.multiSelect)) {"_$c(13,10)
 ;s text=text_"          var values=item.getSubmitValue();"_$c(13,10)
 ;s text=text_"          for (var i=0; i<values.length; i++) {"_$c(13,10)
 ;s text=text_"            value=values[i];"_$c(13,10)
 ;s text=text_"            nvp = nvp + amp + name + '=' + escape(value);"_$c(13,10)
 ;s text=text_"            amp='&';"_$c(13,10)
 ;s text=text_"          }"_$c(13,10)
 ;s text=text_"        }"_$c(13,10)
 ;s text=text_"        else if ((item.xtype !== 'radiogroup')&&(item.xtype !== 'checkboxgroup')) {"_$c(13,10)
 ;s text=text_"          value = '';"_$c(13,10)
 ;s text=text_"          if (item.xtype === 'textareafield') {"_$c(13,10)
 ;s text=text_"            value = escape(item.getValue());"_$c(13,10)
 ;s text=text_"            value = value.replace(/\+/g, '%2B');"_$c(13,10)
 ;s text=text_"          }"_$c(13,10)
 ;s text=text_"          else if (item.xtype === 'htmleditor') {"_$c(13,10)
 ;s text=text_"            value = escape(item.getValue());"_$c(13,10)
 ;s text=text_"          }"_$c(13,10)
 ;s text=text_"          else {"_$c(13,10)
 ;s text=text_"            if (item.getSubmitValue() !== null) value = item.getSubmitValue();"_$c(13,10)
 ;s text=text_"          }"_$c(13,10)
 ;s text=text_"          if ((item.xtype !== 'radiofield')&&(item.xtype !== 'checkboxfield')) {"_$c(13,10)
 ;s text=text_"            nvp = nvp + amp + item.getName() + '=' + value;"_$c(13,10)
 ;s text=text_"            amp='&';"_$c(13,10)
 ;s text=text_"          }"_$c(13,10)
 ;s text=text_"          else {"_$c(13,10)
 ;s text=text_"            if (value !== '') {"_$c(13,10)
 ;s text=text_"              nvp = nvp + amp + item.getName() + '=' + value;"_$c(13,10)
 ;s text=text_"            }"_$c(13,10)
 ;s text=text_"          }"_$c(13,10)
 ;s text=text_"        }"_$c(13,10)
 ;s text=text_"      }"_$c(13,10)
 ;s text=text_"    );"_$c(13,10)
 s text=text_"    if (addTo !== '') nvp = nvp + '&st2_addTo=' + addTo;"_$c(13,10)
 s text=text_"    if (replace === 1) nvp = nvp + '&st2_removeAll=true';"_$c(13,10)
 s text=text_"    EWD.ajax.getPage({page:nextPage,nvp:nvp})"_$c(13,10)
 s text=text_"  }"_$c(13,10)
 s text=text_"};"_$c(13,10)
 QUIT text
 ;
writeStore(modelName,sessionName,groupField,sortField,sessid)
 ;
 n data,fields,line,name,no
 ;
 ; params:
 ;  "groupField" = grouping field
 ;  "sortField" = sorter field
 ;  "modelName" = store model name
 ;  "sessionName" = EWD Session Name holding the data
 ;
 d mergeArrayFromSession^%zewdAPI(.data,$g(sessionName),sessid)
 ;
 s no=""
 f  s no=$o(data(no)) q:no=""  d
 . s data(no,"recordNo")=no
 ;
 s no=0
 s name=""
 f  s name=$o(data(1,name)) q:name=""  d
 . s no=no+1
 . s fields(no)=name
 ;
 s line="Ext.define('"_$g(modelName)_"',{"_$c(13,10)
 d writeLine(line)
 s line=" extend: 'Ext.data.Model',"_$c(13,10)
 d writeLine(line)
 s line=" config: {"_$c(13,10)
 d writeLine(line) 
 s line="  fields: "
 d writeLine(line)
 d streamArrayToJSON^%zewdJSON("fields")
 s line=$c(13,10)
 d writeLine(line)
 s line=" }"_$c(13,10)
 d writeLine(line)
 s line="});"_$c(13,10)
 d writeLine(line)
 s line="if (typeof EWD.st2.store === 'undefined') EWD.st2.store = [];"_$c(13,10)
 d writeLine(line)
 s line="EWD.st2.store['"_$g(modelName)_"'] = Ext.create('Ext.data.Store',{"_$c(13,10)
 d writeLine(line)
 s line=" model: '"_$g(modelName)_"',"_$c(13,10)
 d writeLine(line)
 i $g(sortField)'="" d
 . s line="sorters: '"_sortField_"',"_$c(13,10)
 . d writeLine(line)
 i $g(groupField)'="" d
 . s line="grouper: {"_$c(13,10)
 . d writeLine(line)
 . s line=" groupFn: function(record) {"_$c(13,10)
 . d writeLine(line)
 . s line="  return record.get('"_groupField_"')[0];"_$c(13,10)
 . d writeLine(line)
 . s line=" }"_$c(13,10)
 . d writeLine(line)
 . s line="},"_$c(13,10)
 . d writeLine(line)
 s line=" data: "
 d writeLine(line)
 d streamArrayToJSON^%zewdJSON("data")
 s line=$c(13,10)
 d writeLine(line)
 s line="});"_$c(13,10)
 d writeLine(line)
 QUIT
 ;
writeSelectOptions(id,sessid)
 n line,list,no,nvp,options
 ;
 d mergeArrayFromSession^%zewdAPI(.list,"ewd_list",sessid)
 s no=""
 f  s no=$o(list(id,no)) q:no=""  d
 . s nvp=list(id,no)
 . s options(no,"text")=$p(nvp,$c(1),1)
 . s options(no,"value")=$p(nvp,$c(1),2)
 s line="EWD.st2.options['"_id_"']="
 d writeLine(line)
 d streamArrayToJSON^%zewdJSON("options")
 s line=";"_$c(13,10)
 d writeLine(line)
 QUIT
 ;
writeTextArea(id,sessid)
 n lf,line,no,text
 ;
 d mergeArrayFromSession^%zewdAPI(.text,"ewd_textarea",sessid)
 s line="EWD.st2.textarea['"_id_"']="""
 d writeLine(line)
 s no=0,lf=""
 f  s no=$o(text(id,no)) q:no=""  d
 . s line=text(id,no)
 . s line=$$replaceAll^%zewdAPI(line,"""","\""")
 . d writeLine(lf_line)
 . s lf="\n"
 s line=""";"_$c(13,10)
 d writeLine(line)
 QUIT
 ;
writeTreeStore(modelName,sessionName,sessid)
 ;
 n data,fields,i,name,no
 ;
 ; params:
 ;  "groupField" = grouping field
 ;  "sortField" = sorter field
 ;  "modelName" = store model name
 ;  "sessionName" = EWD Session Name holding the data
 ;
 d mergeArrayFromSession^%zewdAPI(.data,$g(sessionName),sessid)
 d convertExt4TreeStore(.data)
 s fields(1,"name")="text"
 s fields(2,"name")="nextPage"
 s fields(3,"name")="addTo"
 s fields(4,"name")="replacePreviousPage"
 s fields(5,"name")="nvp"
 f i=1:1:5 s fields(i,"type")="string"
 ;
 d writeLine("Ext.define('"_$g(modelName)_"',{"_$c(13,10))
 d writeLine(" extend: 'Ext.data.Model',"_$c(13,10))
 d writeLine(" config: {"_$c(13,10))
 d writeLine("  fields: ")
 d streamArrayToJSON^%zewdJSON("fields")
 d writeLine($c(13,10))
 d writeLine(" }"_$c(13,10))
 d writeLine("});"_$c(13,10))
 d writeLine("if (typeof EWD.st2.store === 'undefined') EWD.st2.store = [];"_$c(13,10))
 d writeLine("EWD.st2.store['"_$g(modelName)_"'] = Ext.create('Ext.data.TreeStore',{"_$c(13,10))
 d writeLine(" model: '"_$g(modelName)_"',"_$c(13,10))
 d writeLine(" defaultRootProperty: 'items',"_$c(13,10))
 d writeLine(" root: ")
 d streamArrayToJSON^%zewdJSON("data")
 d writeLine($c(13,10))
 d writeLine("});"_$c(13,10))
 QUIT
 ;
convertExt4TreeStore(array)
 ;
 i $o(array(""))'=1 d
 . n temp
 . m temp(1)=array
 . k array
 . m array=temp
 ;
 d convertTreeStore(.array)
 ;
 i $o(array(""))=1 d
 . n temp
 . m temp=array(1)
 . k array
 . m array=temp
 QUIT
 ;
convertTreeStore(array,nvp)
 ;
 n level,nvp2,subscript
 ;
 s subscript=""
 s nvp=$g(nvp)
 i nvp="" d
 . s level=1
 e  d
 . s level=$l(nvp,"&")+1
 i nvp'="" s nvp=nvp_"&"
 f  s subscript=$o(array(subscript)) q:subscript=""  d
 . s nvp2=nvp_"sub"_level_"="_subscript
 . i $d(array(subscript,"child")) d
 . . n subArray
 . . m subArray=array(subscript,"child")
 . . d convertTreeStore(.subArray,nvp2)
 . . k array(subscript,"child")
 . . m array(subscript,"items")=subArray
 . i '$d(array(subscript,"items")) d
 . . s array(subscript,"leaf")="true"
 . . s nvp2=nvp2_"&noOfSubs="_level
 . . i '$d(array(subscript,"nvp")) s array(subscript,"nvp")=nvp2
 . i $d(array(subscript,"nextpage")) d
 . . s array(subscript,"nextPage")=array(subscript,"nextpage")
 . . k array(subscript,"nextpage")
 ;
 QUIT
