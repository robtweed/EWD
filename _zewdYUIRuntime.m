%zewdYUIRuntime ; YUI Tags: Runtime logic
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
menuBarRedirect(sessid)
 ;
 n allowed,nvp,page,widgetId
 ;
 d mergeArrayFromSession^%zewdAPI(.allowed,"YUIMenuBarAllowedPages",sessid)
 s widgetId=$$getRequestValue^%zewdAPI("widgetId",sessid)
 s page=$$getRequestValue^%zewdAPI("fragment",sessid)
 s nvp=$$getRequestValue^%zewdAPI("nvp",sessid)
 i nvp'="" d setSessionValue^%zewdAPI("yui_TreeView.nvp",nvp,sessid)
 i $d(allowed(widgetId,page)) d setRedirect^%zewdAPI(page,sessid) QUIT ""
 QUIT "Unauthorised page request"
 ;
getDTPageParams(sessid)
 ;
 n count,data,direction,n,newDir,newSort,prevDir,prevSort,sessionName
 ;
 s sessionName=$$getRequestValue^%zewdAPI("data",sessid)
 i sessionName="" QUIT ""
 i '$$sessionNameExists^%zewdAPI(sessionName,sessid) QUIT ""
 d setSessionValue^%zewdAPI("YUIDataTableData",sessionName,sessid)
 s count=$$getSessionValue^%zewdAPI("YUIDataTableTotalRows",sessid)
 i count="" d
 . s count=0,n=""
 . d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 . f  s n=$o(data(n)) q:n=""  s count=count+1
 . k data
 . d setSessionValue^%zewdAPI("YUIDataTableTotalRows",count,sessid)
 s prevDir=$$getSessionValue^%zewdAPI("dir",sessid)
 d copyRequestValueToSession^%zewdAPI("dir",sessid)
 s newDir=$$getSessionValue^%zewdAPI("dir",sessid)
 d copyRequestValueToSession^%zewdAPI("results",sessid)
 d copyRequestValueToSession^%zewdAPI("startIndex",sessid)
 s prevSort=$$getSessionValue^%zewdAPI("sort",sessid)
 d copyRequestValueToSession^%zewdAPI("sort",sessid)
 s newSort=$$getSessionValue^%zewdAPI("sort",sessid)
 i prevDir'=newDir,prevSort'="" s prevSort=""
 s direction=1 i newDir="desc" s direction=-1
 i newSort'=prevSort d
 . n data2,sort,value
 . d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 . s n=""
 . f  s n=$o(data(n)) q:n=""  d
 . . s value=$g(data(n,newSort))
 . . s sort(value,n)=""
 . s value="",no=0
 . f  s value=$o(sort(value),direction) q:value=""  d
 . . s n=""
 . . f  s n=$o(sort(value,n)) q:n=""  d
 . . . s no=no+1
 . . . m data2(no)=data(n)
 . d deleteFromSession^%zewdAPI(sessionName,sessid)
 . d mergeArrayToSession^%zewdAPI(.data2,sessionName,sessid)
 QUIT ""
 ;
DTPagedData(sessid)
 ;
 n count,data,dir,result,row,sArray,sessionName,sort,startIndex
 ;
 s startIndex=$$getSessionValue^%zewdAPI("startIndex",sessid)
 s result=$$getSessionValue^%zewdAPI("results",sessid)
 s sort=$$getSessionValue^%zewdAPI("sort",sessid)
 s dir=$$getSessionValue^%zewdAPI("dir",sessid)
 s sessionName=$$getSessionValue^%zewdAPI("YUIDataTableData",sessid)
 d mergeArrayFromSession^%zewdAPI(.data,sessionName,sessid)
 s count=$$getSessionValue^%zewdAPI("YUIDataTableTotalRows",sessid)
 ;
 f row=(startIndex+1):1:(startIndex+result) d
 . m sArray("zobj1","records",row,"zobj1")=data(row)
 s sArray("zobj1","recordsReturned")=result
 s sArray("zobj1","totalRecords")=count
 s sArray("zobj1","startIndex")=startIndex
 s sArray("zobj1","sort")=sort
 s sArray("zobj1","dir")=dir
 s sArray("zobj1","pageSize")=result
 d walkObjectArray^%zewdCompiler19("sArray")
 w $c(13,10)
 w !
 QUIT
 ;
createDataTableStore(array,sessionName,sessid)
 ;
 n jrow,name,row,sArray,value
 ;
 s row=""
 f  s row=$o(array(row)) q:row=""  d
 . s name=""
 . f  s name=$o(array(row,name)) q:name=""  d
 . . s value=array(row,name)
 . . s jrow=$j(row,6)
 . . s jrow=$tr(jrow," ","0")
 . . s sArray(1,"zobj"_jrow,name)=value
 d deleteFromSession^%zewdAPI(sessionName,sessid)
 d mergeArrayToSession^%zewdAPI(.sArray,sessionName,sessid)
 QUIT
 ;
writeTreeOptions(sessionName,onclick,widgetId,widgetObj,targetId,sessid)
 ;
 n allowed,allowedList,array,node,ref
 ;
 d mergeArrayFromSession^%zewdAPI(.array,sessionName,sessid)
 d mergeArrayFromSession^%zewdAPI(.allowed,"YUIMenuBarAllowedPages",sessid)
 k allowed(widgetId)
 s node=widgetObj_".getRoot()"
 s ref="array("
 w "EWD.yui.treeViewOptions['"_widgetId_"'] = {} ;"
 d getSubTreeOptions(.array,ref,node,widgetId,0,targetId,.allowedList,sessid)
 m allowed(widgetId)=allowedList
 d deleteFromSession^%zewdAPI("YUIMenuBarAllowedPages",sessid)
 d mergeArrayToSession^%zewdAPI(.allowed,"YUIMenuBarAllowedPages",sessid)
 QUIT
 ;
getSubTreeOptions(array,refn,parentNode,widgetId,nodeNo,targetId,allowed,sessid)
 ;
 n comma,expanded,id1,nvp,page,refb,refExpanded,refId,refNVP
 n refPage,refTarget,refText,refTitle,refTranslate,subref
 n subrefx,target,text,title,translate,x,xtext,zzno
 ;
 s comma=""
 i $e(refn,$l(refn))'="(" s comma=","
 s refb=refn_comma_"zzno)"
 s refText=refn_comma_"zzno,""text"")"
 s refId=refn_comma_"zzno,""id"")"
 s refPage=refn_comma_"zzno,""page"")"
 s refTarget=refn_comma_"zzno,""target"")"
 s refNVP=refn_comma_"zzno,""nvp"")"
 s refExpanded=refn_comma_"zzno,""expanded"")"
 s refTitle=refn_comma_"zzno,""title"")"
 s refTranslate=refn_comma_"zzno,""translate"")"
 s zzno=""
 s x="s zzno=$o("_refb_")"
 f  x x q:zzno=""  d
 . s text=$g(@refText)
 . s translate=$g(@refTranslate)
 . s xyext=""
 . i translate'=0 s xtext=$$systemMessage^%zewdAPI(text,"yui",sessid)
 . i xtext'="",translate'=0 s text=xtext
 . s id1=$g(@refId)
 . s page=$g(@refPage)
 . s target=$g(@refTarget)
 . i target="" s target=targetId
 . s nvp=$g(@refNVP)
 . s expanded=$g(@refExpanded)
 . i expanded="" s expanded="false"
 . s title=$g(@refTitle)
 . i title'="" s title=",title:"""_title_""""
 . s nodeNo=nodeNo+1
 . w "var treeNode"_nodeNo_" = new YAHOO.widget.TextNode({label:"""_text_""",expanded:"_expanded_title_"}, "_parentNode_");"
 . i page'="" d
 . . w "treeNode"_nodeNo_".href=""javascript:EWD.yui.treeViewSelector('"_widgetId_"',"_nodeNo_")"";"
 . . i target'="" s $p(page,"~",2)=target
 . . i nvp'="" s $p(page,"~",3)=nvp
 . . s $p(page,"~",4)=expanded
 . . w "EWD.yui.treeViewOptions['"_widgetId_"']["_nodeNo_"]='"_page_"' ;"
 . . s allowed($p(page,"~",1))=""
 . s subref=refn_comma_zzno_",""submenu"""
 . s subrefx=subref_")"
 . i $d(@subrefx) d
 . . n node,nox
 . . s node="treeNode"_nodeNo
 . . s nox=zzno
 . . d getSubTreeOptions(.array,subref,node,widgetId,.nodeNo,targetId,.allowed,sessid)
 . . s zzno=nox
 QUIT
 ;
writeMenuOptions(sessionName,onclick,widgetId,sessid)
 ;
 n allowed,allowedList,array,idx,ref
 ;
 d mergeArrayFromSession^%zewdAPI(.array,sessionName,sessid)
 d mergeArrayFromSession^%zewdAPI(.allowed,"YUIMenuBarAllowedPages",sessid)
 k allowed(widgetId)
 w "<div class='bd'>"
 w "<ul class='first-of-type'>"
 s ref="array("
 s idx=""
 d getSubMenuOptions(.array,ref,idx,onclick,widgetId,.allowedList,sessid)
 w "</ul>"
 w "</div>"
 m allowed(widgetId)=allowedList
 d deleteFromSession^%zewdAPI("YUIMenuBarAllowedPages",sessid)
 d mergeArrayToSession^%zewdAPI(.allowed,"YUIMenuBarAllowedPages",sessid)
 QUIT
 ;
getSubMenuOptions(array,refn,id,onclick,widgetId,allowed,sessid)
 ;
 n bar,comma,fot,href,id1,page,refb,refId,refPage,refTarget,refText
 n refTranslate,subref,subrefx,target,text,translate,x,xtext,zzno
 ;
 s comma="",bar="bar"
 i $e(refn,$l(refn))'="(" s comma=",",bar=""
 s refb=refn_comma_"zzno)"
 s refText=refn_comma_"zzno,""text"")"
 s refId=refn_comma_"zzno,""id"")"
 s refPage=refn_comma_"zzno,""page"")"
 s refTarget=refn_comma_"zzno,""target"")"
 s refTranslate=refn_comma_"zzno,""translate"")"
 s zzno=""
 s x="s zzno=$o("_refb_")"
 f  x x q:zzno=""  d
 . s text=$g(@refText)
 . s translate=$g(@refTranslate)
 . s xtext=""
 . i translate'=0 s xtext=$$systemMessage^%zewdAPI(text,"yui",sessid)
 . i xtext'=0,xtext'="" s text=xtext
 . s id1=$g(@refId)
 . s page=$g(@refPage)
 . s target=$g(@refTarget)
 . s fot=""
 . w "<li class='yuimenu"_bar_"item"_fot_"'>"
 . s href="'#'"
 . i onclick'="",id1'="" s href="javascript:"_onclick_"('"_id1_"')"
 . i page'="" d
 . . n tgt
 . . s tgt="" i target'="" s target=",'"_target_"'"
 . . s href="""javascript:EWD.yui.menuBarSelector('"_widgetId_"','"_page_"'"_target_")"""
 . . s allowed(page)=""
 . s subref=refn_comma_zzno_",""submenu"""
 . s subrefx=subref_")"
 . s href="href="_href
 . ;i $d(@subrefx) s href=""
 . w "<a class='yuimenu"_bar_"itemlabel' "_href_">"_text_"</a>"
 . i $d(@subrefx) d
 . . n idx,nox
 . . w "<div id='MenuBar"_id_zzno_"' class='yuimenu' style='z-index:20'>"
 . . w "<div class='bd'>"
 . . ;w "<ul class='first-of-type'>"
 . . w "<ul>"
 . . s nox=zzno
 . . s idx=id_zzno_"-"
 . . d getSubMenuOptions(.array,subref,idx,onclick,widgetId,.allowed,sessid)
 . . w "</ul>"
 . . w "</div>"
 . . w "</div>"
 . . s zzno=nox
 . w "</li>"
 QUIT
 ;
writeDataTableFunctions(sessionName,sessid)
 ;
 n colDef,func,key,no
 ;
 d mergeArrayFromSession^%zewdAPI(.colDef,sessionName,sessid)
 f no=1:1 q:'$d(colDef(no))  d
 . i $d(colDef(no,"onclick")) d
 . . s key=$g(colDef(no,"key"))
 . . s func=$g(colDef(no,"onclick"))
 . . w "buttonFuncs["""_key_"""] = function(rowNo,oRecord) {"_func_"(rowNo,oRecord);};"_$c(13,10)
 QUIT
 ;
createDropdownOptionsJSON(menuArray)
 ;
 n comma,json,no
 ;
 s no="",json="[",comma=""
 f  s no=$o(menuArray(no)) q:no=""  d
 . s json=json_comma_"{"
 . s json=json_"label:'"_$g(menuArray(no,"label"))_"'"
 . s json=json_",value:'"_$g(menuArray(no,"value"))_"'"
 . s json=json_"}"
 . s comma=","
 s json=json_"]"
 QUIT json
 ;
writeDataTableColumns(uniqueName,nodeNo,sessionName,addEditor,editorControlKey,sessid)
 ;
 n colDef,columnSet,comma,comma2,comma3,fields,name,namex,no,value
 ;
 d mergeArrayFromSession^%zewdAPI(.colDef,sessionName,sessid)
 s no="",columnSet="",fields="",comma2="",comma3="",addEditor=0
 f no=1:1 q:'$d(colDef(no))  d
 . w "var yuiDataTableCol"_uniqueName_no_"=new YAHOO.widget.Column({"
 . s name="",comma=""
 . f  s name=$o(colDef(no,name)) q:name=""  d
 . . s value=colDef(no,name)
 . . d
 . . . n key
 . . . s namex=name
 . . . i name="type" d  q
 . . . . s namex="formatter"
 . . . . i value="button" s value="YAHOO.widget.DataTable.formatButton" q
 . . . . i value="date" s value="YAHOO.widget.DataTable.formatDate" q
 . . . . i value="number" s value="YAHOO.widget.DataTable.formatNumber" q
 . . . . i value="currency" s value="YAHOO.widget.DataTable.formatCurrency" q
 . . . i name="resizeable"!(name="sortable")!(name="hidden") q
 . . . i value?1N.N q
 . . . i name="header" d
 . . . . s namex="label"
 . . . . s value=$$systemMessage^%zewdAPI(value,"yui",sessid)
 . . . i $$zcvt^%zewdAPI(name)="editas" d  q
 . . . . s namex="editor"
 . . . . s value="new YAHOO.widget.TextboxCellEditor({disableBtns:true})"
 . . . . s addEditor=1
 . . . i $$zcvt^%zewdAPI(name)="dynamiceditorkey" d  q
 . . . . s key=$g(colDef(no,"key"))
 . . . . i key'="" s editorControlKey(key)=value
 . . . . s addEditor=1
 . . . . s namex="editor"
 . . . . s value="new YAHOO.widget.BaseCellEditor()"
 . . . i name="editor" s addEditor=1 q
 . . . i name="formatter" q
 . . . s value=""""_value_""""
 . . w comma_namex_":"_value
 . . i name="key" s fields=fields_comma3_value,comma3=","
 . . s comma=","
 . w "});"_$c(13,10)
 . s columnSet=columnSet_comma2_"yuiDataTableCol"_uniqueName_no
 . s comma2=","
 w "var yuiColumnDefs"_uniqueName_nodeNo_"=new YAHOO.widget.ColumnSet(["_columnSet_"]);"_$c(13,10)
 w "yuiDataSource"_uniqueName_nodeNo_".responseSchema={fields:["_fields_"]};"_$c(13,10)
 QUIT
 ;
writeEditorHandlers(tableObj,addEditor,editorControlKey)
 ;
 n controlKey,key
 ;
 i addEditor d
 . w tableObj_".subscribe('cellClickEvent',"_tableObj_".onEventShowCellEditor);"_$c(13,10)
 . w tableObj_".subscribe('cellMouseoverEvent',"_tableObj_".onEventHighlightCell);"_$c(13,10)
 . w tableObj_".subscribe('cellMouseoutEvent',"_tableObj_".onEventUnhighlightCell);"_$c(13,10)
 ;
 s key=""
 f  s key=$o(editorControlKey(key)) q:key=""  d
 . s controlKey=editorControlKey(key)
 . w tableObj_".subscribe(""cellClickEvent"", function(oArgs){"_$c(13,10)
 . w " var target = oArgs.target;"_$c(13,10)
 . w " var key = this.getColumn(target).getKey();"_$c(13,10)
 . w " if (key == '"_key_"') {"_$c(13,10)
 . w "   var editorType = this.getRecord(target).getData('"_controlKey_"');"_$c(13,10) 
 . w "   var params = EWD.utils.getPiece(editorType,'|',2);"_$c(13,10)
 . w "   var editorType = EWD.utils.getPiece(editorType,'|',1);"_$c(13,10)
 . w "   var editorRef = 'new YAHOO.widget.';"_$c(13,10)
 . w "   if (editorType == 'text') editorRef = editorRef + 'TextboxCellEditor(' + params + ')';"_$c(13,10)
 . w "   if (editorType == 'menu') editorRef = editorRef + 'DropdownCellEditor({disableBtns:true,dropdownOptions:' + params + '})';"_$c(13,10)
 . w "   eval('this.getColumn(target).editor=' + editorRef);"_$c(13,10)
 . w "   this.showCellEditor(target);"_$c(13,10)
 . w " }"_$c(13,10)
 . w "});"_$c(13,10)
 QUIT
 ;
