%zewdYUI ; YUI Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 844)
 ; Build Date: Fri, 04 Feb 2011 14:54:35
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
DataTable(nodeOID,attrValue,docOID,technology)
 ;
 n addEditor,attr,buttonClickOID,captionObj,childNo,childOID,colDefsObj,columnAttrs
 n columnRef,constructorOID,dataTableOID,datasource,dataSourceObj,dataStoreOID,divOID
 n docName,dsType,editAs,func,functionObj,functionOID,functionPresent,hasButtons,header,jsOID
 n jspOID,key,lineOID,linkFunc,mainAttrs,name,nvpOID,objOID,OIDArray,onclick,paging
 n sectionOID,tableObj,tableObjName,tagName,targetId,targetOID,text,type
 n userFunc,varOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;	
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s dataTableOID=$$getElementById^%zewdDOM("yui-DataTable",docOID)
 i dataTableOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-DataTable"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.DataTable() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s dataStoreOID=$$getElementById^%zewdDOM("yuiDataStores",docOID)
 s datasource=""
 i $g(mainAttrs("datastore"))'="" d
 . n xOID
 . s attr("method")="writeObjectAsJSON^%zewdCompiler19"
 . s attr("param1")=$g(mainAttrs("datastore"))
 . s attr("param2")=0
 . s attr("param3")=0
 . s attr("param4")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",dataStoreOID,,.attr)
 . s datasource="datastore"
 ;
 s paging=$$zcvt^%zewdAPI($g(mainAttrs("paging")))
 i paging'="" d
 . i paging="onserver" d
 . . n dir,files,results,sort
 . . s sort=$g(mainAttrs("sort"))
 . . i sort="" s sort=$g(mainAttrs("columnkey"))
 . . i sort="" s sort="id"
 . . s dir=$g(mainAttrs("dir"))
 . . i dir="" s dir=$g(mainAttrs("sortdirection"))
 . . i dir="" s dir="asc"
 . . s results=$g(mainAttrs("results"))
 . . i results="" s results=$g(mainAttrs("resultsperpage"))
 . . i results="" s results=$g(mainAttrs("rowsperpage"))
 . . i results="" s results=25
 . . d paginator(inputPath,.files)
 ;
 s buttonClickOID=$$getElementById^%zewdDOM("yuiButtonOnClickFunctions",docOID)
 s text="if (typeof(buttonFuncs) == 'undefined') buttonFuncs = {} ;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",buttonClickOID,,,text)
 ;
 s tableObjName=$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("object"))'="" s tableObjName=mainAttrs("object")
 s tableObj="EWD.yui.widget."_tableObjName
 ;
 i $g(mainAttrs("columndefinition"))'="" d
 . n xOID
 . s attr("method")="writeDataTableFunctions^%zewdYUIRuntime"
 . s attr("param1")=mainAttrs("columndefinition")
 . s attr("param2")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",buttonClickOID,,.attr)
 ;
 s targetId="yuiDataTableDiv"_$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("renderto"))'="" s targetId=$g(mainAttrs("renderto"))
 ;
 s attr("class")="yui-skin-sam"
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
 s attr("id")=targetId
 s targetOID=$$addElementToDOM^%zewdDOM("div",divOID,,.attr,"Please wait...")
 ;	
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 ;
 s functionOID=$$getTagOID^%zewdDOM("ewd:jsfunction",docName)
 s functionPresent=0
 i functionOID="" d
 . s functionObj="fReturn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=functionObj
 . s attr("addvar")="true"
 . s functionOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",sectionOID,,.attr)
 e  d
 . s functionObj=$$getAttribute^%zewdDOM("return",functionOID)
 . s functionPresent=1
 ;
 s hasButtons=0,addEditor=0
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="yui:datatablecolumn" q
 . do getAttributeValues^%zewdCustomTags(childOID,.columnAttrs)
 . s editAs=$g(columnAttrs("editas")) k columnAttrs("editas")
 . s editAs=$$zcvt^%zewdAPI(editAs,"l")
 . i editAs="text" d
 . . s columnAttrs("editor")="new YAHOO.widget.TextboxCellEditor({disableBtns:true})"
 . . s addEditor=1
 . i editAs="singlecheckbox" d
 . . n funcName,key
 . . s columnAttrs("formatter")="'checkbox'"
 . . s funcName="fn"_$$uniqueId^%zewdAPI(childOID,filename)
 . . s key=$g(columnAttrs("key"))
 . . i key'="" s checkboxEditor(key)=funcName
 . i editAs="dropdown" d
 . . n ddAttrs,ddOID,ddOIDArray,editorCOID,editorOOID,editorPOID,gchildNo,gchildOID
 . . n optionsFound,tagName
 . . s columnAttrs("editor")="editorObj"
 . . s addEditor=1
 . . s attr("return")="editorObj"
 . . s attr("object")="YAHOO.widget.DropdownCellEditor"
 . . s editorCOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 . . s editorPOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",editorCOID)
 . . s editorOOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",editorPOID)
 . . d getChildrenInOrder^%zewdDOM(childOID,.ddOIDArray)
 . . s gchildNo="",optionsFound=0
 . . f  s gchildNo=$o(ddOIDArray(gchildNo)) q:gchildNo=""  d
 . . . s gchildOID=ddOIDArray(gchildNo)
 . . . s tagName=$$getTagName^%zewdDOM(gchildOID)
 . . . i tagName="yui:dropdown" d
 . . . . do getAttributeValues^%zewdCustomTags(gchildOID,.ddAttrs)
 . . . . i $g(ddAttrs("disablebtns"))'="" d
 . . . . . s attr("name")="disableBtns"
 . . . . . s attr("type")="boolean"
 . . . . . s attr("value")=ddAttrs("disablebtns")
 . . . . . s ddOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",editorOOID,,.attr)
 . . . i tagName="yui:dropdownoption" d
 . . . . n ddLabel,ddOOID,ddValue,nvpOID
 . . . . i 'optionsFound d
 . . . . . s attr("name")="dropdownOptions"
 . . . . . s attr("type")="array"
 . . . . . s ddOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",editorOOID,,.attr)
 . . . . . s optionsFound=1
 . . . . ;<yui:dropdownoption label="Integer" value="integer" />
 . . . . do getAttributeValues^%zewdCustomTags(gchildOID,.ddAttrs)
 . . . . s ddLabel=$g(ddAttrs("label"))
 . . . . s ddValue=$g(ddAttrs("value"))
 . . . . s ddOOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",ddOID,,.attr)
 . . . . s attr("name")="label"
 . . . . s attr("value")=ddLabel
 . . . . s attr("type")="literal"
 . . . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",ddOOID,,.attr)
 . . . . s attr("name")="value"
 . . . . s attr("value")=ddValue
 . . . . s attr("type")="literal"
 . . . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",ddOOID,,.attr)
 . . . d removeIntermediateNode^%zewdDOM(gchildOID)
 . s header(childNo)=columnAttrs("header")
 . i header(childNo)="" s header(childNo)=columnAttrs("key")
 . s key(childNo)=columnAttrs("key")
 . s attr("addvar")="true"
 . s columnRef(childNo)="yuiDataTableCol"_$$uniqueId^%zewdAPI(childOID,filename)
 . s attr("return")=columnRef(childNo)
 . s attr("object")="YAHOO.widget.Column"
 . s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 . s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID)
 . s type=$g(columnAttrs("type"))
 . s onclick=$g(columnAttrs("onclick"))
 . i type'="button",onclick'="" d
 . . n funcName
 . . s funcName="fn"_$$uniqueId^%zewdAPI(childOID,filename)
 . . s onclick(columnAttrs("key"))=onclick_$c(1)_funcName
 . s name=""
 . f  s name=$o(columnAttrs(name)) q:name=""  d
 . . s attr("type")="literal"
 . . i name="sortable"!(name="resizeable")!(name="hidden")!(name="selected") s attr("type")="boolean"
 . . i name="formatter"!(name="editor")!(name="currencyoptions")!(name="dateoptions")!(name="sortoptions.sortfunction") s attr("type")="reference"
 . . i columnAttrs(name)?1N.N s attr("type")="reference"
 . . s attr("name")=name
 . . d
 . . . i name="header" s attr("name")="label" q
 . . . i name="classname" s attr("name")="className" q
 . . . i name="currencyoptions" s attr("name")="currencyOptions" q
 . . . i name="dateoptions" s attr("name")="dateOptions" q
 . . . i name="maxautowidth" s attr("name")="maxAutoWidth" q
 . . . i name="minwidth" s attr("name")="minWidth" q
 . . . i name="sortoptions.defaultdir" s attr("name")="sortOptions.defaultDir" q
 . . . i name="sortoptions.field" s attr("name")="sortOptions.field" q
 . . . i name="sortoptions.sortfunction" s attr("name")="sortOptions.sortFunction" q
 . . s attr("value")=columnAttrs(name)
 . . i name="header" s attr("value")="$$$systemMessage^%zewdAPI("""_attr("value")_""",""yui"",sessid)"
 . . i name="type",columnAttrs(name)="date" d
 . . . s attr("name")="formatter"
 . . . s attr("value")="YAHOO.widget.DataTable.formatDate"
 . . . s attr("type")="reference"
 . . i name="type",columnAttrs(name)="number" d
 . . . s attr("name")="formatter"
 . . . s attr("value")="YAHOO.widget.DataTable.formatNumber"
 . . . s attr("type")="reference"
 . . i name="type",columnAttrs(name)="currency" d
 . . . s attr("name")="formatter"
 . . . s attr("value")="YAHOO.widget.DataTable.formatCurrency"
 . . . s attr("type")="reference"
 . . i name="type",columnAttrs(name)="button" d
 . . . s attr("name")="formatter"
 . . . s attr("value")="YAHOO.widget.DataTable.formatButton"
 . . . s attr("type")="reference"
 . . . i $g(columnAttrs("onclick"))'="" d
 . . . . n butOID
 . . . . s text="buttonFuncs["""_columnAttrs("key")_"""] = function(rowNo,oRecord) {"_columnAttrs("onclick")_"(rowNo,oRecord);};"
 . . . . s butOID=$$addElementToDOM^%zewdDOM("ewd:jsline",buttonClickOID,,,text)
 . . . s hasButtons=1
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 s colDefsObj="yuiColumnDefs"_$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("columndefinition"))="" d
 . n arrOID,colNo,jspOID,varOID
 . s attr("addvar")="true"
 . s attr("return")=colDefsObj
 . s attr("object")="YAHOO.widget.ColumnSet"
 . s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 . s arrOID=$$addElementToDOM^%zewdDOM("ewd:jsarray",jspOID)
 . s colNo=""
 . f  s colNo=$o(columnRef(colNo)) q:colNo=""  d
 . . s attr("name")=columnRef(colNo)
 . . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",arrOID,,.attr)
 ;
 s dataSourceObj="unknown"
 i paging="onserver" d
 . n jsArray,pageRef,scriptOID,varOID
 . s attr("addvar")="true"
 . s dataSourceObj="yuiDataFragment"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=dataSourceObj
 . s attr("object")="YAHOO.util.DataSource"
 . s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 . s pageRef="yuiPage"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("name")=pageRef
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 . s jsarray(1)="var "_pageRef_"='zYUIDTPaginator.ewd&data="_$g(mainAttrs("sessionname"))_"&';"
 . s scriptOID=$$addJavascriptFunction^%zewdAPI(docName,.jsarray)
 ;
 i datasource="datastore" d
 . n varOID
 . s attr("addvar")="true"
 . s dataSourceObj="yuiDataSource"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=dataSourceObj
 . s attr("object")="YAHOO.util.DataSource"
 . s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 . s attr("name")=mainAttrs("datastore")
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 s dsType="TYPE_JSARRAY"
 i paging="onserver" s dsType="TYPE_JSON"
 s text=dataSourceObj_".responseType = YAHOO.util.DataSource."_dsType_";"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 i $g(mainAttrs("columndefinition"))'="" d
 . n xOID
 . s attr("method")="writeDataTableColumns^%zewdYUIRuntime"
 . s attr("param1")=$p(filename,".",1)
 . s attr("param2")=$p(nodeOID,"-",2)
 . s attr("param3")=mainAttrs("columndefinition")
 . s attr("param4")="<?= .addEditor ?>"
 . s attr("param5")="<?= .editorControlKey ?>"
 . s attr("param6")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",functionOID,,.attr)
 ;
 i $g(mainAttrs("columndefinition"))="" d
 . n setOID
 . s attr("return")=dataSourceObj_".responseSchema"
 . s attr("addvar")="false"
 . s attr("type")="object"
 . s setOID=$$addElementToDOM^%zewdDOM("ewd:jsset",functionOID,,.attr)
 . ;
 . i paging="onserver" d
 . . n colNo,faOID,foOID,mfOID,nvpOID
 . . s attr("name")="resultsList"
 . . s attr("value")="records"
 . . s attr("type")="literal"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)	
 . . s attr("name")="metaFields"
 . . s attr("type")="object"
 . . s mfOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)	
 . . s attr("name")="totalRecords"
 . . s attr("value")="totalRecords"
 . . s attr("type")="literal"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",mfOID,,.attr)
 . . s attr("name")="fields"
 . . s attr("type")="array"
 . . s faOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)	
 . . s colNo=""
 . . f  s colNo=$o(key(colNo)) q:colNo=""  d
 . . . s foOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",faOID,,.attr)
 . . . s attr("name")="key"
 . . . s attr("value")=key(colNo)
 . . . s attr("type")="literal"
 . . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",foOID,,.attr)
 . e  d
 . . n colNo,nvpOID,varOID
 . . s attr("name")="fields"
 . . s attr("type")="array"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)	
 . . s colNo=""
 . . f  s colNo=$o(key(colNo)) q:colNo=""  d
 . . . s attr("name")=key(colNo)
 . . . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",nvpOID,,.attr)
 ;
 i $g(mainAttrs("caption"))'=""!(paging="onserver")!(paging="onclient")!($g(mainAttrs("height"))'="")!($g(mainAttrs("width"))'="")!($g(mainAttrs("scrollable"))'="") d
 . n nvpOID,param,setOID
 . s captionObj="yuiCaption"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=captionObj
 . s attr("addvar")="true"
 . s attr("type")="object"
 . s setOID=$$addElementToDOM^%zewdDOM("ewd:jsset",functionOID,,.attr)
 . i $g(mainAttrs("caption"))="" s mainAttrs("caption")=" "
 . f param="caption","height","width" d
 . . i $g(mainAttrs(param))'="" d
 . . . s attr("name")=param
 . . . s attr("value")=mainAttrs(param)
 . . . i param="caption" s attr("value")="$$$systemMessage^%zewdAPI("""_mainAttrs(param)_""",""yui"",sessid)"
 . . . s attr("type")="literal"
 . . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr) 
 . i $g(mainAttrs("scrollable"))'="" d
 . . s attr("name")="scrollable"
 . . s attr("value")=mainAttrs("scrollable")
 . . s attr("type")="boolean"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr) 
 . i paging="onserver" d
 . . n sbOID
 . . s attr("name")="initialRequest"
 . . s attr("value")="sort="_sort_"&dir="_dir_"&startIndex=0&results="_results
 . . s attr("type")="literal"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr) 
 . . s attr("name")="dynamicData"
 . . s attr("value")="true"
 . . s attr("type")="boolean"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)
 . . s attr("name")="sortedBy"
 . . s attr("type")="object"
 . . s sbOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)	
 . . s attr("name")="key"
 . . s attr("value")=sort
 . . s attr("type")="literal"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",sbOID,,.attr)
 . . s attr("name")="dir"
 . . s attr("value")="YAHOO.widget.DataTable.CLASS_"_$$zcvt^%zewdAPI(dir,"U")
 . . s attr("type")="reference"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",sbOID,,.attr)
 . . s attr("name")="paginator"
 . . s attr("value")="new YAHOO.widget.Paginator({ rowsPerPage:"_results_" })"
 . . s attr("type")="reference"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)
 . i paging="onclient" d
 . . n nvpOID,results
 . . s results=$g(mainAttrs("results"))
 . . i results="" s results=$g(mainAttrs("resultsperpage"))
 . . i results="" s results=$g(mainAttrs("rowsperpage"))
 . . i results="" s results=25
 . . s attr("name")="paginator"
 . . s attr("value")="new YAHOO.widget.Paginator({ rowsPerPage:"_results_" })"
 . . s attr("type")="reference"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",setOID,,.attr)
 ;
 s attr("addvar")="false"
 ;
 s text="EWD.yui.widgetIndex["""_targetId_"""]={widgetName:"""_tableObjName_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s attr("return")=tableObj
 s attr("object")="YAHOO.widget.DataTable"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")=targetId
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 s attr("name")=colDefsObj
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 s attr("name")=dataSourceObj
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 i $g(mainAttrs("caption"))'="" d
 . s attr("name")=captionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 i addEditor d
 . s text=tableObj_".subscribe('cellClickEvent',"_tableObj_".onEventShowCellEditor);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . s text=tableObj_".subscribe('cellMouseoverEvent',"_tableObj_".onEventHighlightCell);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . s text=tableObj_".subscribe('cellMouseoutEvent',"_tableObj_".onEventUnhighlightCell);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 i $g(mainAttrs("columndefinition"))'="" d
 . n xOID
 . s attr("method")="writeEditorHandlers^%zewdYUIRuntime"
 . s attr("param1")=tableObj
 . s attr("param2")="<?= addEditor ?>"
 . s attr("param3")="<?= .editorControlKey ?>"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",functionOID,,.attr)
 ;
 s key=""
 f  s key=$o(checkboxEditor(key)) q:key=""  d
 . s func=checkboxEditor(key)
 . s text=tableObj_".subscribe('checkboxClickEvent',"_func_");"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . s text=checkboxEditor(key)_"=function(oArgs) {"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text="if (this.getColumn(oArgs.target).key == '"_key_"') this.getRecord(oArgs.target).setData('use',oArgs.target.checked);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text="};"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s key=""
 f  s key=$o(onclick(key)) q:key=""  d
 . s userFunc=$p(onclick(key),$c(1),1)
 . i $e(userFunc,$e(userFunc))'=")" s userFunc=userFunc_"(this.getRecordIndex(oArgs.target))"
 . s linkFunc=$p(onclick(key),$c(1),2)
 . s text=tableObj_".subscribe('cellClickEvent',"_linkFunc_");"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . s text=linkFunc_"=function(oArgs) {"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text=" if (this.getColumn(oArgs.target).key == '"_key_"') "_userFunc_";"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text="};"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 i paging="onserver" d
 . n i,text
 . s text(1)=tableObj_".handleDataReturnPayload = function(oRequest, oResponse, oPayload) {"
 . s text(2)="oPayload.totalRecords = oResponse.meta.totalRecords; "
 . s text(3)="return oPayload;"
 . s text(4)="} ;"
 . f i=1:1:4 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text(i))
 ;
 i hasButtons!($g(mainAttrs("columndefinition"))'="") d
 . n i,text
 . s text(1)=tableObj_".subscribe(""buttonClickEvent"", function(oArgs){"
 . s text(2)="var key = this.getColumn(oArgs.target).key;"
 . s text(3)="var oRecord = this.getRecord(oArgs.target);"
 . s text(4)="var rowNo = oRecord.getCount() ;"
 . s text(5)="if (typeof(buttonFuncs[key]) != ""undefined"") buttonFuncs[key](rowNo,oRecord) ;"
 . s text(6)="});"
 . f i=1:1:6 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text(i))	    
 ;
 i 'functionPresent d
 . n methodOID,varOID
 . s attr("name")="YAHOO.util.Event.onAvailable"
 . s methodOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",sectionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",methodOID)
 . s attr("value")=targetId
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)  
 . s attr("name")=functionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
Dialog(nodeOID,attrValue,docOID,technology)
 ;
 n attr,bdOID,bobjOID,butOID,buttonFound,childArray,childNo,childOID
 n constructorOID,dialogObj,dialogObjName,dialogOID
 n divOID,docName,functionObj,functionOID,functionPresent,hdOID,jsOID
 n jspOID,lineOID,mainAttrs,name,nsOID,nvpOID,objOID,registerId
 n sectionOID,tagName,targetId,targetOID,text,textOID,varOID,widget
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d getChildrenInOrder^%zewdDOM(nodeOID,.childArray)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s dialogOID=$$getElementById^%zewdDOM("yui-Dialog",docOID)
 i dialogOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-Dialog"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.Dialog() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text="document.getElementsByTagName('body')[0].className = 'yui-skin-sam' ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;	
 s targetId="yuiDialogDiv"_$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("renderto"))'="" s targetId=$g(mainAttrs("renderto"))
 s registerId="yuiDialogReg"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
 d setAttribute^%zewdDOM("id",registerId,divOID)
 s targetOID=$$insertNewIntermediateElement^%zewdDOM(divOID,"div",docOID)
 d setAttribute^%zewdDOM("id",targetId,targetOID)
 d setAttribute^%zewdDOM("style","visibility:hidden",targetOID)
 s bdOID=$$insertNewIntermediateElement^%zewdDOM(targetOID,"div",docOID)
 d setAttribute^%zewdDOM("class","bd",bdOID)
 s nsOID=$$getNextSibling^%zewdDOM(bdOID)
 i nsOID="" d
 . n ftOID
 . s attr("class")="ft"
 . i $g(mainAttrs("footerid"))'="" s attr("id")=mainAttrs("footerid")
 . s text=$g(mainAttrs("footertext"))
 . s ftOID=$$addElementToDOM^%zewdDOM("div",targetOID,,.attr,text)
 e  d
 . n ft,ftOID
 . s ftOID=$$createElement^%zewdDOM("div",docOID)
 . s ft=$$insertBefore^%zewdDOM(ftOID,nsOID)
 . d setAttribute^%zewdDOM("class","hd",ftOID)
 . i $g(mainAttrs("footerid"))'="" d setAttribute^%zewdDOM("id",mainAttrs("footerid"),ftOID)
 . i $g(mainAttrs("footertext"))'="" d
 . . s textOID=$$createTextNode^%zewdDOM(mainAttrs("footertext"),docOID)
 . . s textOID=$$appendChild^%zewdDOM(textOID,ftOID)
 ;
 s hdOID=$$createElement^%zewdDOM("div",docOID)
 d setAttribute^%zewdDOM("class","hd",hdOID)
 s textOID=$$createTextNode^%zewdDOM($g(mainAttrs("headertext")),docOID)
 s textOID=$$appendChild^%zewdDOM(textOID,hdOID)
 s hdOID=$$insertBefore^%zewdDOM(hdOID,bdOID)
 ;
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 s dialogObjName=$$uniqueId^%zewdAPI(nodeOID,filename)	
 i $g(mainAttrs("object"))'="" s dialogObjName=mainAttrs("object")
 s dialogObj="EWD.yui.widget."_dialogObjName
 s functionOID=$$getTagOID^%zewdDOM("ewd:jsfunction",docName)
 s functionPresent=0
 i functionOID="" d
 . s functionObj="fReturn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=functionObj
 . s attr("addvar")="true"
 . s functionOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",sectionOID,,.attr)
 e  d
 . s functionObj=$$getAttribute^%zewdDOM("return",functionOID)
 . s functionPresent=1
 ;
 s text="EWD.yui.widgetIndex["""_registerId_"""]={widgetName:"""_dialogObjName_""",tagId:"""_targetId_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s text="EWD.yui.moveDialogToBody('"_targetId_"');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s attr("addvar")="false"
 s attr("return")=dialogObj
 s widget="Dialog" i $$getTagName^%zewdDOM(nodeOID)="yui:panel" s widget="Panel"
 s attr("object")="YAHOO.widget."_widget
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")=targetId
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID)
 ;	
 s mainAttrs("iframe")="true"
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i name="headertext"!(name="autorender")!(name="onclose") q
 . s attr("type")="literal"
 . i name="visible"!(name="close")!(name="draggable")!(name="iframe")!(name="monitorresize")!(name="constraintoviewport")!(name="fixedcenter")!(name="modal") s attr("type")="boolean"
 . i name="y"!(name="x") s attr("type")="reference"
 . i mainAttrs(name)?1N.N s attr("type")="reference"
 . s attr("name")=name
 . s attr("value")=mainAttrs(name)
 . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s childNo="",buttonFound=0
 f  s childNo=$o(childArray(childNo)) q:childNo=""  d
 . s childOID=childArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="yui:dialogbutton" q
 . do getAttributeValues^%zewdCustomTags(childOID,.columnAttrs)
 . i 'buttonFound d
 . . s attr("name")="buttons"
 . . s attr("type")="array"
 . . s butOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 . . s buttonFound=1
 . s bobjOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",butOID)
 . s name=""
 . f  s name=$o(columnAttrs(name)) q:name=""  d
 . . i name="cancel" d  q
 . . . i columnAttrs(name)="true" d
 . . . . s attr("name")="handler"
 . . . . s attr("type")="reference"
 . . . . s attr("value")="function() {this.cancel();}"
 . . . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",bobjOID,,.attr)
 . . i name="isdefault" d  q
 . . . s attr("name")="isDefault"
 . . . s attr("type")="boolean"
 . . . s attr("value")=columnAttrs(name)
 . . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",bobjOID,,.attr)
 . . s attr("type")="literal"
 . . i name="handler" s attr("type")="reference"
 . . s attr("name")=name
 . . s attr("value")=columnAttrs(name)
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",bobjOID,,.attr)
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 s text=dialogObj_".render();"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 i $g(mainAttrs("visible"))="true" d
 . s text=dialogObj_".show = true ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 i $g(mainAttrs("onclose"))'="" d
 . s text="YAHOO.util.Event.on(YAHOO.util.Dom.getElementsByClassName(""container-close"",""a"","""_targetId_"""),""click"",function() {"_mainAttrs("onclose")_";});"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;	
 i 'functionPresent d
 . n methodOID
 . s attr("name")="YAHOO.util.Event.onAvailable"
 . s methodOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",sectionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",methodOID)
 . s attr("value")=targetId
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)  
 . s attr("name")=functionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
TabView(nodeOID,attrValue,docOID,technology)
 ;
 n active,aOID,attr,childNo,childOID,constructorOID
 n displayControlName,divOID,docName,emOID,funcName,functionObj,functionOID
 n functionPresent,jsOID,jspOID,label,labelOID,lineOID,liOID,loadedObj
 n mainAttrs,OIDArray,sectionOID,synch,tabAttrs,tabViewOID,tagName,targetId
 n targetOID,text,ulOID,varOID,widgetObj,widgetObjName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s tabViewOID=$$getElementById^%zewdDOM("yui-TabView",docOID)
 i tabViewOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-TabView"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.TabView() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;	
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 ;
 s targetId="yuiTabViewDiv"_$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("renderto"))'="" s targetId=$g(mainAttrs("renderto"))
 ;
 s attr("class")="yui-skin-sam"
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
 s attr("class")="yui-navset"
 s attr("id")=targetId
 s targetOID=$$addElementToDOM^%zewdDOM("div",divOID,,.attr)
 s attr("class")="yui-nav"
 s ulOID=$$addElementToDOM^%zewdDOM("ul",targetOID,,.attr)	
 s attr("class")="yui-content"
 s labelOID=$$addElementToDOM^%zewdDOM("div",targetOID,,.attr)	
 ;
 s widgetObjName=$$uniqueId^%zewdAPI(nodeOID,filename)	
 i $g(mainAttrs("object"))'="" s widgetObjName=mainAttrs("object")
 s widgetObj="EWD.yui.widget."_widgetObjName
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 ;
 s functionOID=$$getTagOID^%zewdDOM("ewd:jsfunction",docName)
 s functionPresent=0
 i functionOID="" d
 . s functionObj="fReturn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=functionObj
 . s attr("addvar")="true"
 . s functionOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",sectionOID,,.attr)
 e  d
 . s functionObj=$$getAttribute^%zewdDOM("return",functionOID)
 . s functionPresent=1
 ;
 s text="EWD.yui.widgetIndex["""_targetId_"""]={widgetName:"""_widgetObjName_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s attr("addvar")="false"
 s attr("return")=widgetObj
 s attr("object")="YAHOO.widget.TabView"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")=targetId
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 ;
 i 'functionPresent d
 . n methodOID
 . s attr("name")="YAHOO.util.Event.onAvailable"
 . s methodOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",sectionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",methodOID)
 . s attr("value")=targetId
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)  
 . s attr("name")=functionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 s loadedObj="tabLoaded"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s text="var displayTab;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="yui:tab" q
 . s text="var tab"_(childNo-1)_" = "_widgetObj_".getTab("_(childNo-1)_");"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="yui:tab" q
 . k tabAttrs
 . do getAttributeValues^%zewdCustomTags(childOID,.tabAttrs)
 . s label=$g(tabAttrs("label"))
 . s active=$g(tabAttrs("active"))
 . i active="true" s attr("class")="selected"
 . s liOID=$$addElementToDOM^%zewdDOM("li",ulOID,,.attr)
 . s attr("href")="#tab"_$$uniqueId^%zewdAPI(nodeOID,filename)_childNo
 . s aOID=$$addElementToDOM^%zewdDOM("a",liOID,,.attr)
 . s emOID=$$addElementToDOM^%zewdDOM("em",aOID,,.attr,label)
 . s attr("id")="tab"_$$uniqueId^%zewdAPI(nodeOID,filename)_childNo
 . s text="Please wait..."
 . s divOID=$$addElementToDOM^%zewdDOM("div",labelOID,,.attr,text)
 . s displayControlName=$g(tabAttrs("displaycontrolname"))
 . i displayControlName'="" d
 . . n phpVar
 . . s phpVar=$$addPhpVar^%zewdCustomTags("#"_displayControlName)
 . . s text="displayTab = """_phpVar_""" ;"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . . s text="if (displayTab == 0) {"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . . s text=widgetObj_".removeTab(tab"_(childNo-1)_") ;"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . . s text="}"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . . s text="else {"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . . s funcName="tabClick"_$$uniqueId^%zewdAPI(childOID,filename)
 . . s text="tab"_(childNo-1)_".addListener(""click"",function() {"_funcName_"();});"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . . s text="}"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . e  d
 . . s funcName="tabClick"_$$uniqueId^%zewdAPI(childOID,filename)
 . . s text="tab"_(childNo-1)_".addListener(""click"",function() {"_funcName_"();});"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . s synch=""
 . i active="true" d
 . . s text=funcName_"();"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text,1)
 . . s synch="Synch"
 . ;
 . s page=$g(tabAttrs("datasrc"))
 . i page="" s page=$g(tabAttrs("src"))
 . i page'="" d
 . . n jsarray,scriptOID
 . . s jsarray(1)="function "_funcName_"() {"
 . . s jsarray(2)="if (typeof("_loadedObj_"["_(childNo-1)_"]) == 'undefined') {"
 . . s jsarray(3)="ewd.ajax"_synch_"Request("""_page_""",""tab"_$$uniqueId^%zewdAPI(nodeOID,filename)_childNo_""");"
 . . s jsarray(4)=loadedObj_"["_(childNo-1)_"]=true;"
 . . s jsarray(5)="}"
 . . s jsarray(6)="}"
 . . s scriptOID=$$addJavascriptFunction^%zewdAPI(docName,.jsarray)
 . ;
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 s text=loadedObj_"={};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text,1)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
TreeView(nodeOID,attrValue,docOID,technology)
 ;
 n attr,constructorOID,divOID,docName,files,functionObj,functionOID
 n functionPresent,jsOID,jspOID,jsText,lineOID,mainAttrs,onclick
 n OIDArray,sectionOID,target,targetId,text,treeViewOID
 n varOID,widgetObj,widgetObjName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;	
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s treeViewOID=$$getElementById^%zewdDOM("yui-TreeView",docOID)
 i treeViewOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-TreeView"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.TreeView() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;	
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 ;
 s targetId="yuiTreeViewDiv"_$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("renderto"))'="" s targetId=$g(mainAttrs("renderto"))
 ;
 s attr("class")="yui-skin-sam"
 s attr("id")=targetId
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
 ;	
 s widgetObjName=$$uniqueId^%zewdAPI(nodeOID,filename)	
 i $g(mainAttrs("object"))'="" s widgetObjName=mainAttrs("object")
 s widgetObj="EWD.yui.widget."_widgetObjName
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 ;
 s functionOID=$$getTagOID^%zewdDOM("ewd:jsfunction",docName)
 s functionPresent=0
 i functionOID="" d
 . s functionObj="fReturn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=functionObj
 . s attr("addvar")="true"
 . s functionOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",sectionOID,,.attr)
 e  d
 . s functionObj=$$getAttribute^%zewdDOM("return",functionOID)
 . s functionPresent=1
 ;
 s text="EWD.yui.widgetIndex["""_targetId_"""]={widgetName:"""_widgetObjName_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s attr("addvar")="false"
 s attr("return")=widgetObj
 s attr("object")="YAHOO.widget.TreeView"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")=targetId
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 ;
 i 'functionPresent d
 . n methodOID
 . s attr("name")="YAHOO.util.Event.onAvailable"
 . s methodOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",sectionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",methodOID)
 . s attr("value")=targetId
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)  
 . s attr("name")=functionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 s target=$g(mainAttrs("targetid"))
 s onclick=$g(mainAttrs("onclick"))
 i $g(mainAttrs("sessionname"))'="" d
 . n sessionName,xOID
 . s sessionName=mainAttrs("sessionname")
 . s attr("method")="writeTreeOptions^%zewdYUIRuntime"
 . s attr("param1")=sessionName
 . s attr("param2")=onclick
 . s attr("param3")=targetId
 . s attr("param4")=widgetObj
 . s attr("param5")=target
 . s attr("param6")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",functionOID,,.attr)
 ;
 k jsText
 s jsText(1)="EWD.yui.treeViewSelector = function(widgetId,nodeNo) {"
 s jsText(2)=" var page=EWD.yui.treeViewOptions[widgetId][nodeNo] ;"
 s jsText(3)=" var target ;"
 s jsText(4)=" var nvpx = '' ;"
 s jsText(5)=" if (EWD.utils.contains(page,'~')) {"
 s jsText(6)="   target = EWD.utils.getPiece(page,'~',2) ;"
 s jsText(7)="   nvpx = EWD.utils.getPiece(page,'~',3) ;"
 s jsText(8)="   expanded = EWD.utils.getPiece(page,'~',4) ;"
 s jsText(9)="   page = EWD.utils.getPiece(page,'~',1) ;"
 s jsText(10)=" }"
 s jsText(11)=" if (nvpx != '') nvpx = '&nvp=' + nvpx ;"
 s jsText(12)=" if (!target) target='"_target_"';"
 s jsText(13)=" var nvp='widgetId=' + widgetId + '&fragment=' + page + nvpx ;"
 s jsText(14)=" if (expanded == 'true') {"
 s jsText(15)="   var textNode = YAHOO.widget.TreeView.getNode (widgetId , nodeNo );"
 s jsText(16)="   if (textNode) textNode.expand() ;"
 s jsText(17)=" }" 
 s jsText(18)=" ewd.ajaxRequest(""zYUIMenuBarSelector"",target,nvp);"
 s jsText(19)="};"
 s jsOID=$$addJavascriptObject^%zewdAPI(docName,.jsText)
 ;
 s text=widgetObj_".draw() ;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 d menuBarRedirectPage(inputPath,.files)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
Menu(nodeOID,attrValue,docOID,technology)
 ;
 n attr,childNo,childOID,constructorOID,divOID
 n docName,functionObj,functionOID,functionPresent,itemAttrs
 n jsOID,jspOID,lineOID,mainAttrs,menuName,menuOID,name,nvpOID,objOID
 n OIDArray,onclick,sectionOID,tagName,targetId,text
 n varOID,widgetName,widgetObj,widgetObjName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s menuOID=$$getElementById^%zewdDOM("yui-Menu",docOID)
 i menuOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-Menu"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.Menu() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 s functionOID=$$getTagOID^%zewdDOM("ewd:jsfunction",docName)
 s functionPresent=0
 i functionOID="" d
 . s functionObj="fReturn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=functionObj
 . s attr("addvar")="true"
 . s functionOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",sectionOID,,.attr)
 e  d
 . s functionObj=$$getAttribute^%zewdDOM("return",functionOID)
 . s functionPresent=1
 ;
 s menuName="Menu"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s widgetObj=$$uniqueId^%zewdAPI(nodeOID,filename)
 s widgetObjName=widgetObj	
 i $g(mainAttrs("object"))'="" s widgetObj=mainAttrs("object")
 s text="EWD.yui.widgetIndex["""_menuName_"Div""]={widgetName:"""_widgetObj_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 s attr("addvar")="false"
 s attr("return")="EWD.yui.widget."_widgetObj
 s attr("object")="YAHOO.widget.Menu"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")=menuName
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID)
 ;
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i name="object" q
 . s attr("type")="literal"
 . i name="fixedcenter" s attr("type")="boolean"
 . i name="zindex"!(name="x")!(name="y") s attr("type")="numeric"
 . s attr("name")=name
 . s attr("value")=mainAttrs(name)
 . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="yui:menuitem" q
 . do getAttributeValues^%zewdCustomTags(childOID,.itemAttrs)
 . s attr("addvar")="true"
 . s attr("return")="miObj"
 . s attr("object")="YAHOO.widget.MenuItem"
 . s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 . s attr("value")=$g(itemAttrs("text"))
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 . s onclick=$g(itemAttrs("onclick"))
 . i onclick'="" d
 . . n objOID,uniqueName
 . . s uniqueName=$$uniqueId^%zewdAPI(childOID,filename)
 . . s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID)
 . . s attr("name")="onclick"
 . . s attr("value")="{fn:EWD.yui.method."_uniqueName_"}"
 . . s attr("type")="reference"
 . . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 . . ;
 . . s text="EWD.yui.method."_uniqueName_" = function(mType,mArgs,mItem) {"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . . s text=onclick_" ;"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . . s text="};"
 . . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . ;
 . s text="EWD.yui.widget."_widgetObj_".addItem(miObj);"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 . d removeIntermediateNode^%zewdDOM(childOID)
 ;
 s attr("id")=menuName_"Div"
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
 ;
 s text="EWD.yui.widget."_widgetObj_".render("""_menuName_"Div"");"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)    
 ;
 if 'functionPresent d
 . n methodOID
 . s attr("name")="YAHOO.util.Event.onAvailable"
 . s methodOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",sectionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",methodOID)
 . s attr("value")=menuName_"Div"
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)  
 . s attr("name")=functionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
MenuBar(nodeOID,attrValue,docOID,technology)
 ;
 n attr,constructorOID,divOID,docName,files,functionObj
 n functionOID,functionPresent,jsOID,jspOID,lineOID,mainAttrs,menuBarOID,nvpOID
 n objOID,OIDArray,onclick,sectionOID,target,targetId,text
 n widgetObj,widgetObjName,varOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;	
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s menuBarOID=$$getElementById^%zewdDOM("yui-MenuBar",docOID)
 i menuBarOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-MenuBar"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.MenuBar() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text="document.getElementsByTagName('body')[0].className = 'yui-skin-sam' ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s targetId="MenuBar"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 s onclick=$g(mainAttrs("onclick"))
 ;	
 i $g(mainAttrs("sessionname"))'="" d
 . n sessionName,xOID
 . s sessionName=mainAttrs("sessionname")
 . s attr("id")=targetId
 . s attr("class")="yuimenubar yuimenubarnav"
 . s attr("style")="display:none"
 . s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
 . s attr("method")="writeMenuOptions^%zewdYUIRuntime"
 . s attr("param1")=sessionName
 . s attr("param2")=onclick
 . s attr("param3")=targetId
 . s attr("param4")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",divOID,,.attr)
 ;
 s target=$g(mainAttrs("targetid"))
 i target'="" d
 . n jsOID,jsText
 . s jsText(1)="EWD.yui.menuBarSelector = function(widgetId,page,target) {"
 . s jsText(2)=" if (!target) target='"_target_"';"
 . s jsText(3)=" var nvp='widgetId=' + widgetId + '&fragment=' + page ;"
 . s jsText(4)=" ewd.ajaxRequest(""zYUIMenuBarSelector"",target,nvp);"
 . s jsText(5)="};"
 . s jsOID=$$addJavascriptObject^%zewdAPI(docName,.jsText)
 ; 
 s functionOID=$$getTagOID^%zewdDOM("ewd:jsfunction",docName)
 s functionPresent=0
 i functionOID="" d
 . s functionObj="fReturn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s attr("return")=functionObj
 . s attr("addvar")="true"
 . s functionOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",sectionOID,,.attr)
 e  d
 . s functionObj=$$getAttribute^%zewdDOM("return",functionOID)
 . s functionPresent=1
 ;
 s widgetObjName=$$uniqueId^%zewdAPI(nodeOID,filename)
 i $g(mainAttrs("object"))'="" s widgetObjName=mainAttrs("object")
 s widgetObj="EWD.yui.widget."_widgetObjName
 ;
 s text="EWD.yui.widgetIndex["""_targetId_"""]={widgetName:"""_widgetObjName_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s attr("addvar")="false"
 s attr("return")=widgetObj
 s attr("object")="YAHOO.widget.MenuBar"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",functionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")=targetId
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID,,.attr)
 s attr("name")="autosubmenudisplay"
 s attr("value")="true"
 s attr("type")="boolean"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s attr("name")="hidedelay"
 s attr("value")="750"
 s attr("type")="numeric"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s attr("name")="lazyload"
 s attr("value")="true"
 s attr("type")="boolean"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 ;
 i 'functionPresent d
 . n methodOID
 . s attr("name")="YAHOO.util.Event.onAvailable"
 . s methodOID=$$addElementToDOM^%zewdDOM("ewd:jsmethod",sectionOID,,.attr)
 . s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",methodOID)
 . s attr("value")=targetId
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)  
 . s attr("name")=functionObj
 . s varOID=$$addElementToDOM^%zewdDOM("ewd:jsvariable",jspOID,,.attr)
 . s text=widgetObj_".render();"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",functionOID,,,text)
 ;
 s text="document.getElementById('"_targetId_"').style.display='';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 d menuBarRedirectPage(inputPath,.files)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
Submit(nodeOID,attrValue,docOID,technology)
 ;
 n action,attr,butOID,constructorOID,divOID
 n docName,formOID,functionOID,functionPresent,jsOID,jspOID,lineOID
 n mainAttrs,name,nextpage,nvpOID,objOID,OIDArray,onsubmit
 n sectionOID,span1OID,span2OID,submitOID,targetId,text
 n value,varOID,widgetObj,widgetObjName,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s submitOID=$$getElementById^%zewdDOM("yui-Button",docOID)
 i submitOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-Button"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.Button() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s name=$g(mainAttrs("name")) i name="" s name=$$uniqueId^%zewdAPI(nodeOID,filename)
 s value=$g(mainAttrs("value")) i value="" s value="Submit"
 s nextpage=$g(mainAttrs("nextpage"))
 s targetId=$g(mainAttrs("targetid"))
 s action=$g(mainAttrs("action"))
 s onsubmit=$g(mainAttrs("onsubmit"))
 ;   
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 ;
 s text="EWD.yui.method."_name_" = function(e) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 s text=" document.getElementById('"_name_"').click();"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 s text="};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s widgetObjName="submit"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;   
 s text="EWD.yui.widgetIndex[""but"_name_"""]={widgetName:"""_widgetObjName_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s attr("addvar")="false"
 s attr("return")="EWD.yui.widget."_widgetObjName
 s attr("object")="YAHOO.widget.Button"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",sectionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")="but"_name
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID,,.attr)
 s attr("name")="type"
 s attr("value")="button"
 s attr("type")="literal"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s attr("name")="name"
 s attr("value")="but"_name
 s attr("type")="literal"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s attr("name")="onclick"
 s attr("value")="{fn:EWD.yui.method."_name_"}"
 s attr("type")="reference"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 ;
 s attr("id")="but"_name
 s attr("class")="yui-button"
 s span1OID=$$addElementToDOM^%zewdDOM("span",nodeOID,,.attr)
 s attr("class")="first-child"
 s span2OID=$$addElementToDOM^%zewdDOM("span",span1OID,,.attr)
 s attr("type")="button"
 s butOID=$$addElementToDOM^%zewdDOM("button",span2OID,,.attr,value)
 s attr("type")="submit"
 s attr("name")=name
 s attr("value")=value
 s attr("style")="display:none"
 i nextpage'="" s attr("nextpage")=nextpage
 s attr("ajax")="true"
 s attr("targetid")=targetId
 i action'="" d
 . i $e(action,1,5)="&php;" d
 . . s action=$p(action,"&php;",2)
 . . s action=$g(phpVars(action))
 . . s action=$$stripSpaces^%zewdAPI(action)
 . s attr("action")=action
 i onsubmit'="" d
 . n onclick
 . s onclick="if (!"_onsubmit_") return ;"
 . s attr("onclick")=onclick
 s xOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr)
 ;	
 s formOID=$$getFormTag^%zewdDOM(nodeOID)
 i formOID'="" d
 . s attrValue="document.getElementById('"_name_"').click(); return false;"
 . d setAttribute^%zewdDOM("onsubmit",attrValue,formOID)
 . d setAttribute^%zewdDOM("class","yui-skin-sam",formOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
Button(nodeOID,attrValue,docOID,technology)
 ;
 n attr,butOID,buttonOID,buttonText,constructorOID,divOID
 n docName,functionOID,functionPresent,handler
 n jsOID,jspOID,lineOID,mainAttrs,name,nvpOID,objOID,OIDArray
 n sectionOID,span1OID,span2OID,targetId,text
 n varOID,widgetObj,widgetObjName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s buttonOID=$$getElementById^%zewdDOM("yui-Button",docOID)
 i buttonOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-Button"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.Button() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s buttonText=$g(mainAttrs("text")) i buttonText="" s buttonText="Button"
 s handler=$g(mainAttrs("handler"))
 ;
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 ;
 s name=$$uniqueId^%zewdAPI(nodeOID,filename)
 s text="EWD.yui.method."_name_" = function(e) {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 s text=handler
 i $e(text,$l(text)-1,$l(text))'="()" s text=text_"();"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 s text="};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s widgetObjName="button"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 s text="EWD.yui.widgetIndex[""but"_name_"""]={widgetName:"""_widgetObjName_"""};"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s attr("addvar")="false"
 s attr("return")="EWD.yui.widget."_widgetObjName
 s attr("object")="YAHOO.widget.Button"
 s constructorOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",sectionOID,,.attr)
 s jspOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",constructorOID)
 s attr("value")="but"_name
 s varOID=$$addElementToDOM^%zewdDOM("ewd:jsliteral",jspOID,,.attr)
 s objOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",jspOID,,.attr)
 s attr("name")="type"
 s attr("value")="button"
 s attr("type")="literal"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s attr("name")="name"
 s attr("value")="but"_name
 s attr("type")="literal"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 s attr("name")="onclick"
 s attr("value")="{fn:EWD.yui.method."_name_"}"
 s attr("type")="reference"
 s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",objOID,,.attr)
 ;
 s attr("id")="but"_name
 s attr("class")="yui-button"
 s span1OID=$$addElementToDOM^%zewdDOM("span",nodeOID,,.attr)
 s attr("class")="first-child"
 s span2OID=$$addElementToDOM^%zewdDOM("span",span1OID,,.attr)
 s attr("type")="button"
 s butOID=$$addElementToDOM^%zewdDOM("button",span2OID,,.attr,buttonText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
DisplayTable(nodeOID,attrValue,docOID,technology)
 ;
 n attr,displayTableOID,divOID,docName,elseOID,feOID,functionOID
 n functionPresent,ifOID,jsOID,lineOID,mainAttrs,modOID,nameWidth
 n OIDArray,phpVar,sectionOID,sessionName,setOID,tableOID,targetId
 n tdOID,text,title,trOID,widgetObj,widgetObjName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s displayTableOID=$$getElementById^%zewdDOM("yui-displaytable",docOID)
 i displayTableOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-displaytable"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.DisplayTable() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s sessionName=$g(mainAttrs("sessionname"))
 QUIT:sessionName=""
 s nameWidth=$g(mainAttrs("namewidth"))
 i nameWidth="" s nameWidth="50%"
 ;
 s attr("class")="yui-skin-sam"
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)	
 s attr("border")=0
 s attr("width")="100%"
 s attr("style")="border:solid 1px #000;border-collapse:collapse"
 s tableOID=$$addElementToDOM^%zewdDOM("table",divOID,,.attr)
 s title=$g(mainAttrs("title"))
 i title'="" d
 . n tdOID,trOID
 . s trOID=$$addElementToDOM^%zewdDOM("tr",tableOID)
 . s attr("class")="yui-displaytable-header"
 . s attr("colspan")=2
 . s attr("align")="center"
 . s tdOID=$$addElementToDOM^%zewdDOM("td",trOID,,.attr,title)
 ;
 s attr("sessionname")=sessionName
 s attr("index")="$recNo"
 s feOID=$$addElementToDOM^%zewdDOM("ewd:foreach",tableOID,,.attr)
 ;
 s attr("return")="$modValue"
 s attr("data")="$recNo"
 s attr("modulus")=2
 s modOID=$$addElementToDOM^%zewdDOM("ewd:modulo",feOID,,.attr)
 s attr("firstvalue")="$modValue"
 s attr("operation")="="
 s attr("secondvalue")=0
 s ifOID=$$addElementToDOM^%zewdDOM("ewd:if",feOID,,.attr)
 s attr("return")="$class"
 s attr("value")="yui-dt-even"
 s setOID=$$addElementToDOM^%zewdDOM("ewd:set",ifOID,,.attr)
 ;
 s elseOID=$$addElementToDOM^%zewdDOM("ewd:else",ifOID)
 s attr("return")="$class"
 s attr("value")="yui-dt-odd"
 s setOID=$$addElementToDOM^%zewdDOM("ewd:set",ifOID,,.attr)
 ;
 s phpVar=$$addPhpVar^%zewdCustomTags("$class")
 s attr("class")=phpVar
 s attr("style")="height:26px;"
 s trOID=$$addElementToDOM^%zewdDOM("tr",feOID,,.attr)
 s phpVar=$$addPhpVar^%zewdCustomTags("#"_sessionName_"[$recNo].name")
 s attr("width")=nameWidth
 s attr("class")="yui-dt-liner"
 s attr("style")="border-right:solid 1px #cbcbcb; padding-left:8px;"
 s tdOID=$$addElementToDOM^%zewdDOM("td",trOID,,.attr,phpVar)
 s phpVar=$$addPhpVar^%zewdCustomTags("#"_sessionName_"[$recNo].value")
 s attr("style")="padding-left:8px;"
 s tdOID=$$addElementToDOM^%zewdDOM("td",trOID,,.attr,phpVar)	
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
DateField(nodeOID,attrValue,docOID,technology)
 ;
 n attr,btnId,dateOID,divOID,docName,functionOID,functionPresent
 n id,imgOID,inputOID,jsOID,lineOID,mainAttrs,name,OIDArray,sectionOID,targetId,text
 n widgetObj,widgetObjName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d createYUIJSBlock(docOID)
 ;
 s dateOID=$$getElementById^%zewdDOM("yui-calendar",docOID)
 i dateOID="" d
 . n widgetLoadersOID
 . s widgetLoadersOID=$$getElementById^%zewdDOM("yuiWidgetLoaders",docOID)
 . s attr("id")="yui-calendar"
 . s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",widgetLoadersOID,,.attr)
 . s text="EWD.yui.resourceLoader.Calendar() ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 . s text="document.getElementsByTagName('body')[0].className = 'yui-skin-sam' ;"
 . s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 s sectionOID=$$getElementById^%zewdDOM("yuiWidgets",docOID)
 s id=$g(mainAttrs("id"))
 s name=$g(mainAttrs("name"))
 i id="",name'="" s id=name
 i id="" s id="dateField"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s btnId="dateFieldBtn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s text="EWD.yui.widget.Calendar.Opener['"_btnId_"'] = '';"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",sectionOID,,,text)
 ;
 m attr=mainAttrs
 s attr("type")="text"
 s attr("id")=id
 s inputOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr)
 s attr("id")=btnId
 s attr("title")="Show Calendar"
 s attr("onclick")="EWD.yui.calendarEventHandler(this,'"_id_"') ;"
 s attr("src")="/yui-2.6.0/build/calendar/assets/calbtn.gif"
 s attr("width")=18
 s attr("height")="18"
 s attr("alt")="Calendar"
 s imgOID=$$addElementToDOM^%zewdDOM("img",inputOID,,.attr)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
paginator(inputPath,files)
 ;
 n fileName,filePath,io
 ;
 s io=$io
 s fileName="zYUIDTPaginator"
 s filePath=inputPath_fileName_".ewd"
 i '$$openNewFile^%zewdCompiler(filePath) QUIT
 u filePath
 w "<ewd:config isFirstPage=""false"" pagetype=""rawFragment"" prePageScript=""getDTPageParams^%zewdYUIRuntime"" />",!
 w "<ewd:responseHeader name=""Content-type"" value=""application/json"">",!
 w "<ewd:responseHeader name=""Connection"" value=""close"">",!
 w "<ewd:rawContent>",!
 w "<ewd:execute method=""DTPagedData^%zewdYUIRuntime"" type=""procedure"" param1=""#ewd_sessid"" />",!
 w "</ewd:rawContent>",!
 c filePath
 u io
 s files(fileName_".ewd")=""
 QUIT
 ;
createYUIJSBlock(docOID)
 ;	  
 n attr,build,configOID,coreLoaderOID,docName,jsOID,lineOID
 n pageType,phpVar,phpVar2,sectionOID,text,widgetLoadersOID,yuiVersion
 ;
 s build=$$stripSpaces^%zewdAPI($p($t(version^%zewdCompiler2),";;",2))
 ;
 i $g(^zewd("config","YUI","buildNo"))'=build d createJS^%zewdYUIJS(build)
 i '$d(^zewd("config","YUI","app",$$zcvt^%zewdAPI(app,"l"))) d installApplication^%zewdYUIConf($$zcvt^%zewdAPI(app,"l"))
 s docName=$$getDocumentName^%zewdDOM(docOID)
 s configOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 s pageType=$$getAttribute^%zewdDOM("pagetype",configOID)
 i isAjax!($$zcvt^%zewdAPI(pageType,"l")="rawcontent") d
 . n nsOID
 . s configOID=$$getTagOID^%zewdDOM("ewd:config",docName)
 . s nsOID=$$getNextSibling^%zewdDOM(configOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)			
 e  d
 . n headOID
 . s headOID=$$getTagOID^%zewdDOM("head",docName)
 . i headOID'="" s jsOID=$$addElementToDOM^%zewdDOM("ewd:js",headOID)
 ;
 s attr("id")="yuiCoreLoader"
 s coreLoaderOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 s yuiVersion=$$addPhpVar^%zewdCustomTags("#yui.resourcePath")
 s text="EWD.page.yuiResourcePath = """_yuiVersion_""" ;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text="if (EWD.page.yuiResourcePath == '') {"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text=" alert('Unable to determine path to YUI resource file.  Did you run d install^%zewdYUIConf()?') ;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text="}"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s phpVar=$$addPhpVar^%zewdCustomTags("#yui.resourceLoaderPath")
 s phpVar2=$$addPhpVar^%zewdCustomTags("#yui.resourceLoader")
 s text="EWD.page.loadResource("""_phpVar_phpVar2_""",""js"") ;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text="if (!EWD.yui) alert('YUI Javascript resource file ewdYUIResources.js was not found in the web server root path');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text="if (!EWD.yui.build) alert('YUI Javascript resource file ewdYUIResources.js is out of date.  You must be using build "_build_"');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text="if (EWD.yui.build != "_build_") alert('YUI Javascript resource file ewdYUIResources.js is out of date.  You are using build ' + EWD.yui.build + ' but you should be using build "_build_"');"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 s text="EWD.yui.version = """_yuiVersion_""" ;"
 s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",coreLoaderOID,,,text)
 ;
 s attr("id")="yuiWidgetLoaders"
 s widgetLoadersOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 s attr("id")="yuiDataStores"
 s widgetLoadersOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 s attr("id")="yuiButtonOnClickFunctions"
 s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 s attr("id")="userFunctions"
 s sectionOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 s attr("id")="yuiWidgets"
 s widgetLoadersOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 ;
 QUIT
 ;
menuBarRedirectPage(inputPath,files)
 ;
 n fileName,filePath,io
 ;
 s io=$io
 s fileName="zYUIMenuBarSelector"
 s filePath=inputPath_fileName_".ewd"
 i '$$openNewFile^%zewdCompiler(filePath) QUIT
 u filePath
 w "<ewd:config isFirstPage=""false"" pagetype=""ajax"" prePageScript=""menuBarRedirect^%zewdYUIRuntime"" />",!
 w "<div>",!
 w "Please wait.."
 w "</div>",!
 c filePath
 u io
 s files(fileName_".ewd")=""
 QUIT
 ;
