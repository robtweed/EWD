%zewdCompiler13	; Enterprise Web Developer Compiler Functions
 ;
 ; Product: Enterprise Web Developer (Build 907)
 ; Build Date: Fri, 20 Apr 2012 11:29:31
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
ifArrayExists(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:ifArrayExists arrayName="$myArray" param1="xxx" param2="$yyy" param3="#zzz">
	;
	n arrayName,comma,param,subs,pval
	set arrayName=$$getAttrValue^%zewdAPI("arrayname",.attrValues,technology)
	s param="param",subs="",comma=""
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. d
	. . s pval=$$replaceAll^%zewdHTMLParser(pval,"""","&quot;")
	. . s subs=subs_comma_pval,comma=","
	d
	. ;
	. n cwOID,attr
	. ;
	. s cwOID=$$addIntermediateNode^%zewdCompiler4("csp:if",nodeOID)
	. ;
	. ; <csp:if condition="$d(%ewdVar(&quote;ewdTabMenu&quote;,&quote;5&quote;))">
	. ; 
	. s arrayName=$$removeQuotes^%zewdAPI(arrayName)
	. i arrayName="" s arrayName="%ewdVar"
	. i subs="" s attr="$d("_arrayName_")"
	. e  s attr="$d("_arrayName_"("_subs_"))"
	. d setAttribute^%zewdDOM("condition",attr,cwOID)
	;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
url(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:url return="$fullUrl" url="$url" />
	;
	n return,url
	;
	set url=$$getAttrValue^%zewdAPI("url",.attrValues,technology)
	set return=$$getAttrValue^%zewdAPI("return",.attrValues,technology)
	;
	d
	. n page,serverOID,text
	. s page=url,text=""
	. s url=$$getRootURL^%zewdCompiler("gtm")_app_"/"_url_".mgwsi?"
	. s url=url_"ewd_token=""_$g(^%zewdSession(""session"",sessid,""ewd_token""))_""&n=""_tokens("_$tr(page,"'","")_")"
	. s text=text_" s "_return_"="""_url
	. s serverOID=$$addCSPServerScript^%zewdCompiler4(nodeOID,text)
	;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
tabMenuOption(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:tabMenuOption position="1" text="Configuration" nextpage="config" defaultSelected="true" help="This is some help" greyIf="grey^%zewdMgr">
	;
	n attr,decOID,defaultSelected,docName,greyIf,help,newOID,nextpage
	n position,text,value
	;
	set position=$$getAttrValue^%zewdAPI("position",.attrValues,technology)
	s position=$$removeQuotes^%zewdAPI(position)
	set text=$$getAttrValue^%zewdAPI("text",.attrValues,technology)
	s text=$$removeQuotes^%zewdAPI(text)
	set nextpage=$$getAttrValue^%zewdAPI("nextpage",.attrValues,technology)
	s nextpage=$$removeQuotes^%zewdAPI(nextpage)
	set defaultSelected=$$getAttrValue^%zewdAPI("defaultselected",.attrValues,technology)
	s defaultSelected=$$removeQuotes^%zewdAPI(defaultSelected)
	set help=$$getAttrValue^%zewdAPI("help",.attrValues,technology)
	s help=$$removeQuotes^%zewdAPI(help)
	set greyIf=$$getAttrValue^%zewdAPI("greyif",.attrValues,technology)
	s greyIf=$$removeQuotes^%zewdAPI(greyIf)
	; 
	; Map to
	; <ewd:setArrayValue arrayName="ewdTabMenu" param1="1" value="$menuInfo">
	; and place just after <body> tag
	; 
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s value=text_"|"_nextpage_"|"_defaultSelected_"|"_help_"|"_greyIf
	s newOID=$$getFirstElementByTagName^%zewdDOM("ewd:tabmenuarray",docName,"")
	i $$getParentNode^%zewdDOM(newOID)="" s newOID=""
	i newOID="" d
	. n parentOID,xOID
	. s parentOID=$$getFirstElementByTagName^%zewdDOM("head",docName,"")
	. s newOID=$$getFirstElementByTagName^%zewdDOM("ewd:new","",parentOID)
	. i newOID="" d
	. . s newOID=$$addNewFirstChild^%zewdCompiler4("ewd:tabmenuarray",docOID,parentOID)
	. e  d
	. . n fcOID,nextOID,tagOID
	. . s nextOID=$$getNextSibling^%zewdDOM(newOID)
	. . s tagOID=$$createElement^%zewdDOM("ewd:tabmenuarray",docOID)
 	. . s newOID=$$insertBefore^%zewdDOM(tagOID,nextOID)
	s attr("arrayname")="$ewdTabMenu"
	s attr("param1")=position
	s attr("value")=value
	s decOID=$$addElementToDOM^%zewdDOM("ewd:setarrayvalue",newOID,,.attr,"")
	;
	i nextpage'="" d
	. d
	. . n phpString
	. . s phpString=" s tokens("""_nextpage_""")=$$setNextPageToken^%zewdCompiler20("""_nextpage_""")"
	. . d addVBHeaderPreCache^%zewdCompiler8(phpString) 
	;
	; $tokens['run'] = setNextPageToken('run', $ewd_session) ;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
xhtml(nodeOID,attrValues,docOID,technology)
	;
	n attr,dtOID,fcOID,htmlOID,mainAttrs
	;
	do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	s dtOID=$$createDocumentType^%zewdDOM("html","-//W3C//DTD XHTML 1.0 Strict//EN","http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd",docOID)
	;<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	s dtOID=$$insertBefore^%zewdDOM(dtOID,nodeOID)
	;<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
	s htmlOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"html",docOID)
	d setAttribute^%zewdDOM("xmlns","http://www.w3.org/1999/xhtml",htmlOID)
	d setAttribute^%zewdDOM("xml:lang","en",htmlOID)
	;
	s attr=""
	f  s attr=$o(mainAttrs(attr)) q:attr=""  d
	. d setAttribute^%zewdDOM(attr,mainAttrs(attr),htmlOID) 
	;
	do removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT
	;
getSessionArrayValue(arrayName,subscript,sessid,exists)
	;
	n value
	;
	i $g(subscript)="" QUIT ""
	i $g(arrayName)="" QUIT ""
	;
	s arrayName=$tr(arrayName,".","_")
	s exists=1
	i $$isTemp^%zewdAPI(arrayName) d  QUIT $g(value)
	. m value=zewdSession(arrayName,subscript)
	. i '$d(value) s exists=0
	m value=^%zewdSession("session",sessid,arrayName,subscript)
	i '$d(value) s exists=0
	QUIT $g(value)
 ;
sessionArrayValueExists(arrayName,subscript,sessid)
 ;
 n exists,value
 ;
 s value=$$getSessionArrayValue(arrayName,subscript,sessid,.exists)
 QUIT exists
 ;
deleteSessionArrayValue(arrayName,subscript,sessid)
	;
	i $g(subscript)="" QUIT ""
	i $g(arrayName)="" QUIT ""
	s arrayName=$tr(arrayName,".","_")
	;
	i $$isTemp^%zewdAPI(arrayName) k zewdSession(arrayName,subscript) QUIT
	k ^%zewdSession("session",sessid,arrayName,subscript)
	d setWLDSymbol^%zewdAPI(arrayName,sessid)
	QUIT
 ;
setSessionObject(objectName,propertyName,propertyValue,sessid)
	;
	n comma,i,np,p,sessionArray,x
	;
	i $g(objectName)="" QUIT
	i $g(propertyName)="" QUIT
	;i $g(propertyValue)="" QUIT
	i $g(sessid)="" QUIT
    s np=$l(objectName,".")
    s objectName=$$replace^%zewdAPI(objectName,".","_")
    i np=1 d  QUIT
	. i $$isTemp^%zewdAPI(objectName) s zewdSession(objectName_"_"_propertyName)=propertyValue  q
	. s ^%zewdSession("session",sessid,(objectName_"_"_propertyName))=propertyValue
    ;
    f i=1:1:np-1 s p(i)=$p(objectName,".",i)
    s comma=","
    i $$isTemp^%zewdAPI(objectName) d
    . s x="s zewdSession(",comma=""
	e  d
    . s x="s ^%zewdSession(""session"","_sessid
    f i=1:1:np-1 s x=x_comma_""""_p(i)_"""",comma=","
    s x=x_","""_propertyName_""")="""_propertyValue_""""
    x x
    QUIT
	;
deleteFromSessionObject(objectName,propertyName,sessid)
	;
	d deleteSessionArrayValue(objectName,propertyName,sessid)
	QUIT
	;
sessionObjectPropertyExists(objectName,propertyName,sessid)
	QUIT $$sessionArrayValueExists(objectName,propertyName,sessid)
	;
deleteSessionObject(objectName,sessid)
	d deleteFromSession^%zewdAPI(objectName,sessid)
	QUIT
	;
	;
countResultSetRecords(sessionName,sessid)
	i $$isTemp^%zewdAPI(sessionName) QUIT $o(zewdSession(sessionName,""),-1)
	QUIT $o(^%zewdSession("session",sessid,sessionName,""),-1)
	;
addToResultSet(sessionName,propertyName,value,sessid)
	;
	n array,recNo
	;
	s recNo=$$countResultSetRecords(sessionName,sessid)+1
	s array(recNo,propertyName)=value
	d mergeArrayToSession^%zewdAPI(.array,sessionName,sessid)
	QUIT
	;
mergeRecordArrayToResultSet(sessionName,array,sessid)
	;
	n recArray,recNo
	;
	s recNo=$$countResultSetRecords(sessionName,sessid)+1
	m recArray(recNo)=array
	d mergeArrayToSession^%zewdAPI(.recArray,sessionName,sessid)
	QUIT
	;
getResultSetValue(resultSetName,index,propertyName,sessid)
	;
	n exists,value
	;
	i $g(resultSetName)="" QUIT ""
	i $g(index)="" QUIT ""
	i $g(propertyName)="" QUIT ""
	i $g(sessid)="" QUIT ""
	;
	i $$isTemp^%zewdAPI(resultSetName) d  QUIT $g(value)
	. m value=zewdSession(resultSetName,index,propertyName)
	. i '$d(value) s exists=0
	m value=^%zewdSession("session",sessid,resultSetName,index,propertyName)
	i '$d(value) s exists=0
	QUIT $g(value)
	;
saveJSON(objectName,jsonString)
 i objectName="ewd" QUIT "alert(""Invalid request"")"
 i $$JSONAccess^%zewdAPI(objectName,sessid)'="rw" QUIT "alert(""Invalid request"")"
 i jsonString["\""" s jsonString=$$replaceAll^%zewdAPI(jsonString,"\""","""")
 i jsonString["\'" s jsonString=$$replaceAll^%zewdAPI(jsonString,"\'",$c(1))
 d JSONToSessionObject(objectName,jsonString,sessid)
 QUIT "var dummy;"
 ;
getJSON(objectName,addRefCol)
 i objectName="ewd" QUIT "alert(""Invalid request"")"
 ;d trace^%zewdAPI("*** sessid="_sessid_"; JSONAccess="_$$JSONAccess^%zewdAPI(objectName,sessid))
 i $$JSONAccess^%zewdAPI(objectName,sessid)="" QUIT "alert(""Invalid request"")"
 QUIT $$sessionObjectToJSON($g(objectName),sessid,$g(addRefCol))
 ;
JSONToSessionObject(objectName,jsonString,sessid) ;
 ;
 n array,obj,prop
 ;
 ;d parseJSON(jsonString,.array)
 d parseJSON^%zewdCompiler19(jsonString,.array)
 d deleteSessionObject^%zewdAPI(objectName,sessid)
 d mergeArrayToSessionObject^%zewdAPI(.array,objectName,sessid)
 ;s prop=""
 ;f  s prop=$o(array(prop)) q:prop=""  d
 ;. s obj=objectName_"."_prop
 ;. d trace^%zewdAPI("obj="_obj_"; "_$g(array(prop)))
 ;. d setSessionValue^%zewdAPI(obj,$g(array(prop)),sessid)
 ;;d deleteFromSession^%zewdAPI(objectName,sessid)
 ;;d mergeArrayToSession^%zewdAPI(.array,objectName,sessid)
 QUIT
 ;
parseJSON(jsonString,propertiesArray)
 ;
 n c,i,len,name,processing,started,type,value
 ;
 k propertiesArray
 s jsonString=$g(jsonString)
 s started=0
 s processing=""
 s name="",value="",type=""
 s len=$l(jsonString)
 ;
 f i=1:1:len d
 . s c=$e(jsonString,i)
 . i 'started,c="{" s started=1,processing="name" q
 . i processing="",c="""" s processing="name",name="" q
 . i processing="",c=":" s processing="value",value="",type="" q
 . i processing="name" d  q
 . . i c=",",name="" q
 . . i c="""" s processing="" q
 . . i c=":" s processing="value" q
 . . s name=name_c
 . i processing="value" d
 . . i value="" d  q
 . . . i c="""" s type="literal"
 . . . i c?1N s type="number"
 . . . i c="-" s type="number"
 . . . i c="f" s type="boolean"
 . . . i c="t" s type="boolean"
 . . . i c="n" s type="null"
 . . . i c="[" d  q
 . . . . n arr,no,j,val
 . . . . s no=0,val=""
 . . . . f j=i+1:1 d  q:c="]"
 . . . . . s c=$e(jsonString,j)
 . . . . . i c="]" s no=$$saveSubArray(no,.val,.arr) q 
 . . . . . i c="," s no=$$saveSubArray(no,.val,.arr) q
 . . . . . s val=val_c
 . . . . m propertiesArray(name)=arr
 . . . . s i=j,name="",value="",processing="name"
 . . . s value=value_c
 . . ;i c="]" break  s name="",value="",processing="name",i=j q
 . . i type="literal",c="""" s type="literalComplete",value=value_c q
 . . i ((c=",")!(c="}")),type'="literal" d  q
 . . . i type="literalComplete" s value=$e(value,2,$l(value)-1)
 . . . s processing="name"
 . . . s propertiesArray(name)=value
 . . . s name="",value=""
 . . s value=value_c
 QUIT
 ;
saveSubArray(no,value,arr)
 i $e(value,1)=""""!($e(value,1)="'") s value=$e(value,2,$l(value)-1)
 s no=no+1
 s arr(no)=value
 s value=""
 QUIT no
 ;
sessionObjectToJSON(objectName,sessid,addRefCol)
 ;
 n object,poropName,sub
 ;
 s sub=objectName_"_"
 i $$isTemp^%zewdAPI(objectName) d
 . f  s sub=$o(zewdSession(sub)) q:sub=""  q:sub'[(objectName_"_")  d
 . . s propName=$p(sub,(objectName_"_"),2)
 . . m object(propName)=zewdSession(sub)
 . i '$d(object) m object=zewdSession(objectName)
 e  d
 . f  s sub=$o(^%zewdSession("session",sessid,sub)) q:sub=""  q:sub'[(objectName_"_")  d
 . . s propName=$p(sub,(objectName_"_"),2)
 . . m object(propName)=^%zewdSession("session",sessid,sub)
 . i '$d(object) m object=^%zewdSession("session",sessid,objectName)
 QUIT $$createJSONString(objectName,.object,,$g(addRefCol))
 ;
mergeToJSObject(sessionObjRef,JSObjRef,sessid)
 ;
 ; eg sessionObjRef = wld.%User.bridge
 ;    JSObjRef      = EZBRIDGE.Config
 ;
 n i,json,nsub,objName,ref,sessRef
 ;
 s sessRef=$$replace^%zewdAPI(sessionObjRef,".","_")
 s nsub=$l(sessRef,".")
 ;
 s objName=$p(sessionObjRef,".",1)
 i objName="ewd" QUIT "alert(""Invalid request"")"
 i $$JSONAccess^%zewdAPI(objName,sessid)="" QUIT "alert(""Invalid request"")"
 ;
 s ref="",comma=""
 f i=1:1:nsub s ref=ref_comma_""""_$p(sessRef,".",i)_"""",comma=","
 i $$isTemp^%zewdAPI(sessRef) d
 . s ref="m jsArray=zewdSession("_ref_")"
 e  d
 . s ref="m jsArray=^%zewdSession(""session"",sessid,"_ref_")"
 x ref
 s json=$$createJSONString(JSObjRef,.jsArray)
 QUIT json
 ;
objectGlobalToJSON(objectName)
 ;
 QUIT $g(^zewd("jsObject",objectName))
 ;
createJSONString(objectName,objectArray,isDojo,addRefCol,directOutput)
 ;
 n comma,dd,json,name,object,type
 ;
 s directOutput=+$g(directOutput)
 s isDojo=$g(isDojo)
 i isDojo=1 s directOutput=0
 i '$d(objectArray) QUIT ""
 s name=""
 s json=""
 i isDojo'=1 d
 . i directOutput w objectName_"=" q
 . s json=objectName_"="
 i $g(addRefCol)=1 d
 . n rowNo
 . s rowNo=""
 . f  s rowNo=$o(objectArray(rowNo)) q:rowNo=""  d
 . . s objectArray(rowNo,0)=rowNo-1
 s json=$$walkArray(json,$name(objectArray),isDojo)
 ;
 ;s json=$e(json,1,$l(json)-1)_"}"
 i isDojo=1 s json="{identifier:'id',"_$e(json,2,$l(json))
 i isDojo'=1 d
 . i directOutput w ";" q
 . s json=json_" ;"
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("json="_json)
 QUIT json
 ;
walkArray(json,name,dojo,subscripts,isObject,mixed)
 ;
 n arrComma,brace,comma,cr,dd,i,no,numsub,dblquot,quot,ref,sub,subNo,subscripts1,type,valquot,value,xref,zobj
 ;
 s cr=$c(13,10),comma=","
 s mixed=+$g(mixed)
 s (dblquot,valquot)=""""
 s dojo=+$g(dojo)
 i dojo=1 s dblquot="",valquot="'"
 i $g(isObject) d
 . s json=json_"("
 s dd=$d(@name)
 i dd=1!(dd=11) d  i dd=1 QUIT json
 . s value=@name
 . i value'[">" q
 . i dojo=2,value="<mixed>" d  q
 . . i $d(subscripts) q
 . . s mixed=1
 . i dojo=2,$e(value,1)="<",$e(value,$l(value))=">" q
 . i dojo=2 d
 . . s json=json_$p(value,">",1) ;_"("_cr
 . i dojo=2 d
 . . s json=$$walkArray(json,$p(value,">",2),$g(dojo),,1)
 . e  d
 . . s json=$$walkArray(json,value,$g(dojo),,1)
 . ;s json=json_cr_")"
 i 'mixed d
 . s json=json_"{"
 s ref=name_"("
 s no=$o(subscripts(""),-1)
 i no>0 f i=1:1:no d
 . s quot=""""
 . i subscripts(i)?."-"1N.N s quot=""
 . s ref=ref_quot_subscripts(i)_quot_","
 ;i no>0 f i=1:1:no s ref=ref_dblquot_subscripts(i)_dblquot_","
 s ref=ref_"sub)"
 s sub="",numsub=0,subNo=0
 f  s sub=$o(@ref) q:sub=""  d
 . s subscripts(no+1)=sub
 . s subNo=subNo+1
 . i 'mixed,subNo=1,sub?1N.N d
 . . s numsub=1
 . . s json=$e(json,1,$l(json)-1)_"["
 . s dd=$d(@ref)
 . i dd=1 d
 . . ;w ref_"="_@ref,!
 . . s value=@ref 
 . . ;i sub'?1N.N s json=json_dblquot_sub_dblquot_":"
 . . i sub'?1N.N d
 . . . s json=json_sub_":"
 . . s type="literal"
 . . i dojo=2,value[">",value'["?>" d
 . . . i $e(value,$l(value))=">" q
 . . . d
 . . . . s json=json_$p(value,">",1) ;_"("_cr
 . . . s json=$$walkArray(json,$p(value,">",2),$g(dojo),,1)
 . . . s type="object"
 . . . s value=""
 . . i value?1N.N s type="numeric"
 . . i value?1"-"1N.N s type="numeric"
 . . i value?1N.N1"."1N.N s type="numeric"
 . . i value?1"-"1N.N1"."1N.N s type="numeric"
 . . i value="true"!(value="false") s type="boolean"
 . . i $e(value,1)="{",$e(value,$l(value))="}" s type="variable"
 . . i dojo=2,value["<?=",value["?>" d
 . . . n p1,p2
 . . . s p1=$p(value,"<?=",1)
 . . . s p2=$p(value,"?>",2)
 . . . s value=$p(value,"<?=",2)
 . . . s value=$p(value,"?>",1)
 . . . s value=$$stripSpaces^%zewdAPI(value)
 . . . s type="variable"
 . . . i p1'="" d
 . . . . s value=p1_value_p2
 . . ;i type="literal" s value=""""_value_""""
 . . i type="literal" s value=valquot_value_valquot
 . . i dojo=1,type="numeric" s value=valquot_value_valquot
 . . d
 . . . s json=json_value_","
 . k subscripts1
 . m subscripts1=subscripts
 . i dd>9 d
 . . i sub?1N.N d
 . . . i 'mixed,subNo=1 d
 . . . . s numsub=1
 . . . . s json=$e(json,1,$l(json)-1)_"["
 . . e  d
 . . . ;s json=json_dblquot_sub_dblquot_":"
 . . . i $e(sub,1,4)'="zobj" d
 . . . . s json=json_sub_":"
 . . . i $e(sub,1,4)="zobj" d
 . . . . i $e(json,$l(json))'="," d
 . . . . . s json=$e(json,1,$l(json)-1),zobj=1 ; remove { at end
 . . s json=$$walkArray(json,name,dojo,.subscripts1)
 . . i dojo=1,numsub d
 . . . s json=$e(json,1,$l(json)-1)
 . . . s json=json_",id:'"_sub_"'}"
 . . d
 . . . s json=json_","
 ;
 s json=$e(json,1,$l(json)-1)
 s brace="}"
 i mixed s brace=""
 i $g(isObject) s brace=brace_")"
 i numsub s brace="]"
 i $g(zobj)'=1 d
 . s json=json_brace
 QUIT json ; exit!
 ;
createRef(name,subscripts)
 ;
 n no,ref
 ;
 s ref=name_"("
 s no=$o(subscripts(""),-1)
 i no>0 f i=1:1:no d
 . s quot=""""
 . i subscripts(i)?."-"1N.N s quot=""
 . s ref=ref_quot_subscripts(i)_quot_","
 s ref=ref_""""")"
 QUIT ref
 ;
test
 k array
 s array("label")="name"
 s array("items",1,"name")="Fruit"
 s array("items",1,"type")="category"
 s array("items",2,"name")="Cinammon"
 s array("items",2,"type")="category"
 s array("items",2,"children",1,"name")="Cinnamon Lozenge"
 s array("items",2,"children",1,"type")="category"
 s array("items",2,"children",2,"name")="Cinnamon Toast"
 s array("items",2,"children",2,"type")="category"
 s array("items",2,"children",3,"name")="Cinnamon Spread"
 s array("items",2,"children",3,"type")="category"
 s array("items",3,"name")="Apple"
 s array("items",3,"type")="category"
 w $$createJSONString("myTest",.array,1)
 QUIT
 ;
addJavascriptObject(docName,jsText)
 ;
 n childOID,lastLineNo,line,lineNo,OIDArray,scriptOID,text,textArray,textOID
 ;
 s scriptOID=$$getLastJavascriptTag(docName,.textArray)
 s lastLineNo=$o(textArray(""),-1)
 s lineNo="",text=""
 f  s lineNo=$o(jsText(lineNo)) q:lineNo=""  d
 . i jsText(lineNo)["<?="!(jsText(lineNo)["<%") d
 . . k ^CacheTempEWD($j)
 . . s ^CacheTempEWD($j,1)=jsText(lineNo)
 . . d tokenisePHPVariables^%zewdHTMLParser(.phpVars)
 . . s jsText(lineNo)=^CacheTempEWD($j,1)
 . . k ^CacheTempEWD($j)
 . i $l(text)+$l(jsText(lineNo))<4000 s text=text_jsText(lineNo)_$c(13,10) q
 . s lastLineNo=lastLineNo+1
 . s textArray(lastLineNo)=text
 . s text=jsText(lineNo)_$c(13,10)
 s lastLineNo=lastLineNo+1
 s textArray(lastLineNo)=text
 f  q:$$hasChildNodes^%zewdDOM(scriptOID)="false"  d
 . s childOID=$$getFirstChild^%zewdDOM(scriptOID)
 . s childOID=$$removeChild^%zewdAPI(childOID)
 ;
 s lineNo=""
 f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . s text=textArray(lineNo)
 . q:text=""
 . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
 QUIT scriptOID 
 ;
getLastJavascriptTag(docName,textArray)
 ;
 n attr,childNodes,eArray,headOID,jsText,language,nodeNo,nodeOID,ntags
 n OIDArray,scriptOID,src,stop,tagName
 ;
 s headOID=$$getTagOID^%zewdAPI("head",docName)
 i headOID="" s headOID=$$addElementToDOM^%zewdDOM("head",docOID,,,,1)
 d getChildrenInOrder^%zewdDOM(headOID,.childNodes)
 s nodeNo="",scriptOID="",stop=0
 f  s nodeNo=$o(childNodes(nodeNo),-1) q:nodeNo=""  d  q:stop
 . s scriptOID=childNodes(nodeNo)
 . s tagName=$$getTagName^%zewdDOM(scriptOID)
 . i tagName'="script" q
 . s language=$$getAttribute^%zewdDOM("language",scriptOID)
 . q:$$zcvt^%zewdAPI(language,"l")'="javascript"
 . s src=$$getAttribute^%zewdDOM("src",scriptOID)
 . q:src'=""
 . s stop=1
 i scriptOID="" d
 . n attr
 . s attr("language")="javascript"
 . set scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,"")
 k textArray
 s jsText=$$getElementValueByOID^%zewdDOM(scriptOID,"textArray",1)
 i '$d(textArray) s textArray(1)=jsText
 QUIT scriptOID
 ;
javascriptObjectExists(objectName,docName)
 ;
 QUIT $$getJavascriptObject(objectName,docName)'=""
 ;
getJavascriptObject(objectName,docName,eOID) ;
 ;
 n c,comm,dqlvl,eArray,slcomm,language,lc,line,lineNo,lvl
 n mlcomm,ntags,OIDArray,%p1,%p2,pos,refString,sqlvl,stop,stop2,text,textArr
 n textArray
 ;
 s text="",eOID=""
 s refString=objectName_"="
 s ntags=$$getElementsArrayByTagName^%zewdDOM("script",docName,,.eArray)
 s eOID="",stop=0
 f  s eOID=$o(eArray(eOID)) q:eOID=""  d  q:stop
 . s language=$$getAttribute^%zewdDOM("language",eOID)
 . q:$$zcvt^%zewdAPI(language,"l")'["javascript"
 . k textArray
 . s text=$$getElementValueByOID^%zewdDOM(eOID,"textArr",1)
 . i '$d(textArr) s textArr(1)=text
 . s lineNo="",text=""
 . f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d  q:stop
 . . s stop2=0
 . . s textArr(lineNo)=$$replaceAll^%zewdAPI(textArr(lineNo)," =","=")
 . . i textArr(lineNo)[refString f  d  q:textArr(lineNo)'[refString  q:stop2
 . . . s %p1=$p(textArr(lineNo),refString,1)
 . . . s %p1=$re(%p1)
 . . . s %p1=$p(%p1,$c(10,13),1)
 . . . s %p1=$re(%p1)
 . . . i %p1["//"!(%p1["/*") d  q
 . . . . s textArr(lineNo)=$p(textArr(lineNo),refString,2,1000)
 . . . s stop2=1
 . . q:textArr(lineNo)'[refString
 . . s text=refString_$p(textArr(lineNo),refString,2,1000)
 . . s %p1=$p(text,"{",1),%p2=$p(text,"{",2,1000)
 . . s text=%p1_"{",lvl=1,c="",dqlvl=0,sqlvl=0,slcomm=0,mlcomm=0
 . . f pos=1:1:$l(%p2) d  q:stop
 . . . s lc=c
 . . . s c=$e(%p2,pos)
 . . . i lc="\",c="{" s text=text_c q
 . . . i lc="\",c="}" s text=text_c q
 . . . i lc="\",c="""" s text=text_c q
 . . . i lc="\",c="'" s text=text_c q
 . . . i lc="/",c="/" s slcomm=1,text=text_c q
 . . . i lc="/",c="*" s mlcomm=1,text=text_c q
 . . . i lc="*",c="/" s mlcomm=0,text=text_c q
 . . . i slcomm,c=$c(10) s slcomm=0,text=text_c q
 . . . i c="""",dqlvl=0,'slcomm,'mlcomm s dqlvl=1
 . . . i c="""",dqlvl=1,'slcomm,'mlcomm s dqlvl=0
 . . . i c="'",sqlvl=0,'slcomm,'mlcomm s sqlvl=1
 . . . i c="'",sqlvl=1,'slcomm,'mlcomm s sqlvl=0
 . . . i slcomm!mlcomm s text=text_c q
 . . . i c="{",dqlvl=1 s text=text_c q
 . . . i c="}",dqlvl=1 s text=text_c q
 . . . i c="{",sqlvl=1 s text=text_c q
 . . . i c="}",sqlvl=1 s text=text_c q
 . . . i c="{" s lvl=lvl+1
 . . . i c="}" s lvl=lvl-1 i lvl=0 s stop=1 q
 . . . s text=text_c
 . . s text=text_"}"
 QUIT text
 ;
getJavascriptObjectBody(functionName,docName)
 ;
 n body,crlf,eOID,jsText,nLines
 ;
 s jsText=$$getJavascriptObject(functionName,docName,.eOID)
 s crlf=$c(13,10)
 s nLines=$l(jsText,crlf)
 s body=$p(jsText,crlf,2,nLines-1)
 QUIT body
 ;
replaceJavascriptObjectBody(functionName,newBody,docName)
 ;
 n body,call,crlf,eOID,jsText
 ;
 s jsText=$$getJavascriptObject(functionName,docName,.eOID)
 s crlf=$c(13,10)
 s call=$p(jsText,crlf,1)
 s body=call_crlf_newBody_crlf_"   }"
 s ok=$$replaceJavascriptObject(functionName,body,docName)
 QUIT 1
 ;
replaceJavascriptObject(objectName,newFunctionText,docName)
 ;
 n childOID,eOID,docOID,found,funcText,lineNo,stop,text,textArray,textOID
 ;
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 s found=$$getJavascriptObjectBlock(objectName,docName,.textArray)
 i 'found QUIT 0
 ;
 s funcText=$$getJavascriptObject(objectName,docName,.eOID)
 s lineNo="",stop=0
 f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d  q:stop
 . s text=textArray(lineNo)
 . i text[funcText s textArray(lineNo)=$$replace^%zewdAPI(text,funcText,newFunctionText),stop=1
 i 'stop QUIT 0
 f  q:$$hasChildNodes^%zewdDOM(eOID)="false"  d
 . s childOID=$$getFirstChild^%zewdDOM(eOID)
 . s childOID=$$removeChild^%zewdAPI(childOID)
 ;
 s lineNo=""
 f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . s text=textArray(lineNo)
 . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,eOID)
 QUIT 1
 ;
getJavascriptObjectBlock(objectName,docName,textArr) ;
 ;
 n eArray,eOID,language,lineNo,ntags,OIDArray,refString,stop,text,textArray
 ;
 s text="",eOID="" k textArr
 s refString=objectName_"="
 s ntags=$$getElementsArrayByTagName^%zewdDOM("script",docName,,.eArray)
 s eOID="",stop=0
 f  s eOID=$o(eArray(eOID)) q:eOID=""  d  q:stop
 . s language=$$getAttribute^%zewdDOM("language",eOID)
 . q:$$zcvt^%zewdAPI(language,"l")'="javascript"
 . s text=$$getElementValueByOID^%zewdDOM(eOID,"textArr",1)
 . i '$d(textArr) s textArr(1)=text
 . s lineNo="",text=""
 . f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d  q:stop
 . . s textArr(lineNo)=$$replaceAll^%zewdAPI(textArr(lineNo)," =","=")
 . . i textArr(lineNo)[refString s stop=1 q
 QUIT stop
 ;
 ;
createDirectory(path)
 zsystem "mkdir "_path
 QUIT 1
 ;
renameFile(filepath,newpath)
 zsystem "mv "_filepath_" "_newpath
 QUIT 1
 ;
deleteFile(filepath)
 n status
 d gtmDeleteFile
 QUIT status
 ;
gtmDeleteFile
 s status=1
 o filepath:(readonly:exception="g deleteNotExists") 
 c filepath:DELETE
 QUIT
deleteNotExists
 s status=0
 QUIT
 ;
fileExists(path)
 o path:(readonly:exception="g fileNotExists") 
 c path
 QUIT 1
fileNotExists
 i $p($zs,",",1)=2 QUIT 0
 QUIT 1
 ;
fileInfo(path,info)
	d fileInfo^%zewdGTM(path,.info)
	QUIT
	;n line,results
	;k info
	;i '$$fileExists(path) QUIT
	;d shellCommand^%zewdGTM("ls -l """_path_"""",.results)
	;s line=$g(results(1))
	;s info("date")=$p(line," ",6,7)
	;s info("size")=$p(line," ",5)
	;QUIT
 ;
directoryExists(path)
 n line,temp
 s temp="temp"_$p($h,",",2)_".txt"
 zsystem "test -d "_path_" && echo ""1"">"_temp_" || echo ""0"">"_temp
 o temp:(readonly:exception="g dirFileNotExists") 
 u temp
 r line
 c temp
 s ok=$$deleteFile(temp)
 QUIT line
dirFileNotExists
 i $p($zs,",",1)=2 QUIT 0
 QUIT 0
 ;
fileSize(path)
 n line,temp
 i '$$fileExists(path) QUIT 0
 d shellCommand^%zewdGTM("ls -s """_path_"""",.results)
 s line=$g(results(1))
 s line=$$stripLeadingSpaces^%zewdAPI(line)
 s line=$p(line," ",1)
 QUIT +line
 ;
displayText(textID,reviewMode,sessid)
	;
	i $g(textID)="" QUIT ""
	s reviewMode=+$g(reviewMode)
	n text,language,phraseType,appName
	s language=$$getSessionValue^%zewdAPI("ewd_Language",sessid)
	i $g(language)="" d
	. n appName
	. s appName=$$getTextAppName^%zewdCompiler5(textID)
	. s language=$$getDefaultLanguage^%zewdCompiler5(appName)
	i '$d(^ewdTranslation("textid",textID)) QUIT "textid "_textID_" : text missing"
	s text=$g(^ewdTranslation("textid",textID,language))
	i text="" s text=$g(^ewdTranslation("textid",textID,$$getDefaultLanguage^%zewdCompiler5($$getTextAppName^%zewdCompiler5(textID))))
	i language="xx" s text=textID_" ("_text_")"
	i reviewMode d
	. s text=text_" {textid="_textID_" : "_$g(^ewdTranslation("textid",textID,$$getDefaultLanguage^%zewdCompiler5($$getTextAppName^%zewdCompiler5(textID))))_"}"
	s phraseType=$$getTextPhraseType^%zewdCompiler5(textID)
	;d trace^%zewdAPI("phraseType="_phraseType_" ; text="_text)
	i phraseType'="error" d
	. s text=$$replaceAll^%zewdAPI(text,"\'","'")
	. s text=$$replaceAll^%zewdAPI(text,"\""","""")
	. s text=$$replaceAll^%zewdAPI(text,"'","&#39;")
	e  d
	. s text=$$replaceAll^%zewdAPI(text,"'",$c(5))
	. s text=$$replaceAll^%zewdAPI(text,$c(5),"\'")
	QUIT text
 ;
mergeGlobalToSession(globalName,sessionName,sessid)
 s globalName=$$stripSpaces^%zewdAPI(globalName)
 QUIT:$g(sessid)=""
 QUIT:$g(sessionName)=""
 s sessionName=$tr(sessionName,".","_")
 i $$isTemp^%zewdAPI(sessionName) m zewdSession(sessionName)=@globalName QUIT
 m ^%zewdSession("session",sessid,sessionName)=@globalName
 QUIT
 ;
mergeGlobalFromRequest(globalName,fieldName,sessid)
 ;
 n x
 ;
 QUIT:fieldName=""
 s x="m "_globalName_"=requestArray(fieldName)"
 x x
 QUIT
 ;
mergeGlobalFromSession(globalName,sessionName,sessid)
 ;
 n x
 ;
 s globalName=$$stripSpaces^%zewdAPI(globalName)
 QUIT:$g(sessid)=""
 QUIT:$g(sessionName)=""
 s sessionName=$tr(sessionName,".","_")
 i $$isTemp^%zewdAPI(sessionName) s x="m "_globalName_"=zewdSession(sessionName)" x x QUIT
 s x="m "_globalName_"=^%zewdSession(""session"",sessid,sessionName)" x x
 QUIT
 ;
createCSSFile(outputPath,mode,verbose,technology) ;
	;
	n filePath,label,line,lineNo,no,stop,x
	;
	i $d(^zewd("config","jsScriptPath",technology,"outputPath")) d
	. n dlim
	. s dlim=$$getDelim^%zewdAPI()
	. s outputPath=^zewd("config","jsScriptPath",technology,"outputPath")
	. i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
	s filePath=outputPath_"ewd.css"
	i '$$openNewFile^%zewdCompiler(filePath) QUIT
	u filePath
	f label="ewdStyles" d
	. s stop=0
	. f lineNo=1:1 d  q:stop
	. . s x="s line=$t("_label_"+lineNo^%zewdCompiler18)"
	. . x x
	. . i line["***END***" s stop=1 q
	. . i line[";;*php*",technology'="php" q
	. . i line[";;*csp*",((technology'="csp")!(technology="wl")!(technology="ewd")!(technology="gtm")) q
	. . i line[";;*jsp*",technology'="jsp" q
	. . i line[";;*vb.net*",technology'="vb.net" q
	. . i line["left(up)" d
	. . . ;   left(up):-4px
	. . . s line=$$replace^%zewdAPI(line,"(up)","")
	. . . i mode="collapse" s line=";;   left:0px;"
	. . i line["left(down)" d
	. . . ;;   left(down):-33px ;
	. . . s line=$$replace^%zewdAPI(line,"(down)","")
	. . . i mode="collapse" s line=";;   left:-25px;"
	. . s line=$$replace^%zewdHTMLParser(line,"*php*","     ")
	. . s line=$$replace^%zewdHTMLParser(line,"*csp*","     ")
	. . s line=$$replace^%zewdHTMLParser(line,"*jsp*","     ")
	. . s line=$$replace^%zewdHTMLParser(line,"*vb.net*","     ")
	. . w $p(line,";;",2,250),!
	c filePath
	QUIT
 ;
spinner(nodeOID,attrValues,docOID,technology)
	;
	n attr,attrName,elOID,imagePath,increment,max,min,name,onBlur
	n onDown,onUp,onUpOrDown,size,value,width
	;
	s name=$$getAttrValue^%zewdAPI("name",.attrValues,technology)
	s name=$$removeQuotes^%zewdAPI(name)
	i name="" s name="spinner"_$p(nodeOID,"-",2)
	s size=$$getAttrValue^%zewdAPI("size",.attrValues,technology)
	s size=$$removeQuotes^%zewdAPI(size)
	i size="" s size=2
	s width=size*8
	s value=$$getAttrValue^%zewdAPI("value",.attrValues,technology)
	s value=$$removeQuotes^%zewdAPI(value)
	i value="" s value="*"
	s max=$$getAttrValue^%zewdAPI("max",.attrValues,technology)
	s max=$$removeQuotes^%zewdAPI(max)
	i max="" s max="9999999999"	
	s min=$$getAttrValue^%zewdAPI("min",.attrValues,technology)
	s min=$$removeQuotes^%zewdAPI(min)
	i min="" s min="0"
	s increment=$$getAttrValue^%zewdAPI("increment",.attrValues,technology)
	s increment=$$removeQuotes^%zewdAPI(increment)
	i increment="" s increment="100"
	s imagePath=$$getAttrValue^%zewdAPI("imagepath",.attrValues,technology)
	s imagePath=$$removeQuotes^%zewdAPI(imagePath)
	s onUp=$$getAttrValue^%zewdAPI("onup",.attrValues,technology)
	s onUp=$$removeQuotes^%zewdAPI(onUp)
	s onDown=$$getAttrValue^%zewdAPI("ondown",.attrValues,technology)
	s onDown=$$removeQuotes^%zewdAPI(onDown)
	s onBlur=$$getAttrValue^%zewdAPI("onblur",.attrValues,technology)
	s onBlur=$$removeQuotes^%zewdAPI(onBlur)
	s onUpOrDown=$$getAttrValue^%zewdAPI("onupordown",.attrValues,technology)
	s onUpOrDown=$$removeQuotes^%zewdAPI(onUpOrDown)
	s attrName=""
	f  s attrName=$o(attrValues(attrName)) q:attrName=""  d
	. i "|name|size|value|max|min|increment|onup|ondown|onupordown|"[("|"_attrName_"|") q
	. s attr(attrName)=$$removeQuotes^%zewdAPI(attrValues(attrName))
	s attr("type")="text"
	s attr("name")=name
	s attr("value")=value
	s attr("class")="ewdSpinnerText"
	s attr("style")="width:"_width_"px"
	s attr("onKeyDown")="EWD.page.spinnerControl(event,'"_name_"',"_min_","_max_")"
	i onBlur="" d
	. s attr("onBlur")="EWD.page.spinnerValueCheck(this.value,'"_name_"',"_min_","_max_")"
	e  d
	. s attr("onBlur")=onBlur
	s elOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr)
	i onUp'="" s attr("onClick")=onUp
	i onUpOrDown'="" d
	. i onUp'="" s onUpOrDown=onUp_" ; "_onUpOrDown
	. s attr("onClick")=onUpOrDown
	s attr("type")="button"
	s attr("name")=name_"Up"
	s attr("tabIndex")="-1"
	s attr("class")="ewdSpinnerButtonUp"
	i imagePath'="" s attr("style")="background: url("_imagePath_"spinnerUp.gif) no-repeat;"
	s attr("onMouseDown")="EWD.page.spinnerKeyDown = true ;EWD.page.incrementSpinner('"_name_"',"_max_","_increment_")"
	s attr("onMouseUp")="EWD.page.spinnerKeyDown=false"
	s elOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr)
	i onDown'="" s attr("onClick")=onDown
	i onUpOrDown'="" d
	. i onDown'="" s onUpOrDown=onDown_" ; "_onUpOrDown
	. s attr("onClick")=onUpOrDown
	s attr("type")="button"
	s attr("name")=name_"Down"
	s attr("tabIndex")="-1"
	s attr("class")="ewdSpinnerButtonDown"
	i imagePath'="" s attr("style")="background: url("_imagePath_"spinnerDown.gif) no-repeat;"
	s attr("onMouseDown")="EWD.page.spinnerKeyDown = true ;EWD.page.decrementSpinner('"_name_"',"_min_","_increment_")"
	s attr("onMouseUp")="EWD.page.spinnerKeyDown=false"
	s elOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr)
	;
	do removeIntermediateNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
popups(allArray,docOID,jsOID,nextPageList,urlNameList,technology)
	;
	; Process pop-up directives
	;
	n attr,eh,ehx,ehy,ehz,event,found,jsName,jsParams,nextPage
	n nodeOID,nodeType,nvp,properties,props,tagName,url,useCurrentPosition
	n winHandle,winName
	;
	;d getAllNodes^%zewdCompiler(docOID,.allArray)
	s nodeOID="",found=0
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. ;
	. ; popup="eHelpWindow" page="sysConfigHelp" event="OnClick" x=50 y=50 height=400 width=600
	. ; ewdOpenWindow(url,winName,x,y,height,width,toolbar,location,directories,status,menubar,scrollbars,resizable)
	. ; toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes
	. ; 
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. i nodeType'=1 q
	. s winHandle=$$getAttributeValue^%zewdDOM("popup",1,nodeOID)
	. if winHandle="" quit
	. s winName=winHandle
	. i winHandle["[]" d
	. . n attr,headOID,jsOID,jsText
	. . s winName=$$getAttributeValue^%zewdDOM("windowname",1,nodeOID)
	. . s jsOID=$$getTagByNameAndAttr^%zewdAPI("script","id","ewdWinNames",1,docName)
	. . i jsOID="" d
	. . . s attr("language")="javascript"
	. . . s attr("id")="ewdWinNames"
	. . . s headOID=$$getTagOID^%zewdAPI("head",docName)
	. . . s jsText=$p(winHandle,"[",1)_" = new Array() ;"
	. . . s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,jsText)
	. . e  d
	. . . n refStr,textOID
	. . . s textOID=$$getFirstChild^%zewdDOM(jsOID)
	. . . s jsText=$$getData^%zewdDOM(textOID)
	. . . s refStr=$p(winHandle,"[",1)_" = new Array() ;"
	. . . i jsText'[refStr s jsText=jsText_$c(13,10)_refStr
	. . . s textOID=$$modifyTextData^%zewdDOM(jsText,textOID)
	. ;
	. s found=1
	. s event=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("event",1,nodeOID),"L")
	. i event="" set event="onclick"
	. s nextPage=$$getAttributeValue^%zewdDOM("page",0,nodeOID)
	. s props("x")=+$$getAttributeValue^%zewdDOM("x",1,nodeOID)
	. s props("y")=+$$getAttributeValue^%zewdDOM("y",1,nodeOID)
	. s useCurrentPosition=$$getAttributeValue^%zewdDOM("usecurrentposition",1,nodeOID)
	. i $$zcvt^%zewdAPI(useCurrentPosition,"l")="true" d
	. . s props("x")="EWD.utils.findPosX(this)+"_props("x")
	. . s props("y")="EWD.utils.findPosY(this)+"_props("y")
	. e  d
	. . s props("x")="'"_props("x")_"'"
	. . s props("y")="'"_props("y")_"'"
	. s props("width")=$$getAttributeValue^%zewdDOM("width",1,nodeOID) if props("width")="" set props("width")=100
	. s props("height")=$$getAttributeValue^%zewdDOM("height",1,nodeOID) if props("height")="" set props("height")=100
	. s props("toolbar")=$$getAttributeValue^%zewdDOM("toolbar",1,nodeOID) if props("toolbar")="" set props("toolbar")="no"
	. s props("location")=$$getAttributeValue^%zewdDOM("location",1,nodeOID) if props("location")="" set props("location")="no"
	. s props("directories")=$$getAttributeValue^%zewdDOM("directories",1,nodeOID) if props("directories")="" set props("directories")="no"
	. s props("status")=$$getAttributeValue^%zewdDOM("status",1,nodeOID) if props("status")="" set props("status")="no"
	. s props("menubar")=$$getAttributeValue^%zewdDOM("menubar",1,nodeOID) if props("menubar")="" set props("menubar")="no"
	. s props("scrollbars")=$$getAttributeValue^%zewdDOM("scrollbars",1,nodeOID) if props("scrollbars")="" set props("scrollbars")="yes"
	. s props("resizable")=$$getAttributeValue^%zewdDOM("resizable",1,nodeOID) if props("resizable")="" set props("resizable")="yes"
	. f attr="useCurrentPosition","popup","event","page","x","y","width","height","toolbar","location","directories","status","menubar","scrollbars","resizable" do
	. . d removeAttribute^%zewdAPI(attr,nodeOID,1)
	. ;
	. s ehx=$$getAttributeValue^%zewdDOM(event,1,nodeOID)
	. s ehy=$$getAttributeValue^%zewdDOM("onclickpre",1,nodeOID)
	. s ehz=$$getAttributeValue^%zewdDOM("onclickpost",1,nodeOID)
	. d removeAttribute^%zewdAPI("onclickpre",nodeOID,1)
	. d removeAttribute^%zewdAPI("onclickpost",nodeOID,1)
	. s url=$$expandPageName^%zewdCompiler8(nextPage,.nextPageList,.urlNameList,technology,.jsParams)
	. ; allow popup names defined in JS reference - ie use unquoted
	. s winHandle=$s($e($$zcvt^%zewdAPI($tr(winHandle,"",""),"L"),1,9)="document.":winHandle,1:"'"_winHandle_"'")
	. s winName=$s($e($$zcvt^%zewdAPI($tr(winName,"",""),"L"),1,9)="document.":winName,1:"'"_winName_"'")
	. set eh="EWD.page.openWindow('"_url_"',"_winHandle_","_winName
	. for attr="x","y","height","width","toolbar","location","directories","status","menubar","scrollbars","resizable" do
	. . i attr'="x",attr'="y" d
	. . . set eh=eh_",'"_props(attr)_"'"
	. . e  d
	. . . set eh=eh_","_props(attr)
	. set jsName=""
	. for  set jsName=$order(jsParams(jsName)) quit:jsName=""  do
	. . set eh=eh_","_jsParams(jsName)
	. set eh=eh_")"
	. if ehx'="" set eh=eh_" ; "_ehx
	. if ehz'="" set eh=eh_" ; "_ehz
	. if ehy'="" set eh=ehy_" ; "_eh
	. do setAttribute^%zewdDOM(event,eh,nodeOID)
	;
	QUIT
	;
addServerToSession(sessid,serverArray)
 QUIT:$g(sessid)=""
 ;
 k ^%zewdSession("session",sessid,"ewd_Server")
 m ^%zewdSession("session",sessid,"ewd_Server")=serverArray
 d setWLDSymbol^%zewdAPI("ewd_Server",sessid)
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
 . . i $g(^zewd("xssEncoding")) d
 . . . w $$htmlOutputEncode^%zewdAPI2(text)
 . . e  d
 . . . s text=$$replaceAll^%zewdHTMLParser(text,"&#39;","'")
 . . . w $$zcvt^%zewdAPI(text,"o","HTML")
 . . i lineNo'=lastLineNo w $c(13,10)
 QUIT
 ;
isNextPageTokenValid(token,sessid,page)
 ;
 n allowedFrom,expectedPage,fromPage
 ;
 s expectedPage=$p($g(^%zewdSession("nextPageTokens",sessid,token)),"~",1)
 ;s allowedFrom=$p($g(^%zewdSession("nextPageTokens",sessid,token)),"~",2)
 i expectedPage="" QUIT 0
 ;d trace^%zewdAPI("token="_token_" ; allowedFrom="_allowedFrom_" ; actual from page="_fromPage)
 ;i allowedFrom'=fromPage QUIT 0
 i page[".php" d
 . s page=$p(page,"/",$l(page,"/"))
 . s page=$p(page,".php",1)
 QUIT $$zcvt^%zewdAPI(expectedPage,"L")=$$zcvt^%zewdAPI(page,"L")
 ;
existsInSessionArray(name,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11)
 ;
 n exists,i,nparams,param,ref,sessid,stop,technology,value
 ;
 s stop=0
 f i=11:-1:1 d  q:stop
 . s param="p"_i
 . i $g(@param)'="" s stop=1
 s sessid=@("p"_i)
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 s nparams=i-1
 s name=$tr($g(name),".","_")
 i $$isTemp^%zewdAPI(name) d
 . s ref="s exists=$d(zewdSession("""_name_""""
 . s ref="s exists=$d(sessionArray("""_name_""""
 e  s ref="s exists=$d(^%zewdSession(""session"","""_sessid_""","""_name_""""
 i nparams>0 d
 . f i=1:1:nparams s ref=ref_","""_$g(@("p"_i))_""""
 s ref=ref_"))"
 ;d trace^%zewdAPI("ref="_$g(ref))
 x ref
 ;d trace^%zewdAPI("ref="_ref_" ; exists="_exists)
 QUIT exists
 ;
getSchemaFormErrors(errorArray,sessid)
 ;
 n error,num
 ;
 k errorArray
 d mergeArrayFromSession^%zewdAPI(.errorArray,"ewd_SchemaFormError",sessid)
 s error=""
 s num=""
 f  s num=$o(errorArray("list",num)) q:num=""  d
 . s error=error_errorArray("list",num)_$c(13,10)
 QUIT error
 ;
existsInSession(name,sessid)
 n result,technology
 ;
 s name=$$stripSpaces^%zewdAPI(name)
 i $g(name)="" QUIT 0
 s name=$tr(name,".","_")
 i $g(sessid)="" QUIT 0
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 i $$isTemp^%zewdAPI(name) QUIT $d(sessionArray(name))
 QUIT $d(^%zewdSession("session",sessid,name))
 ;
encodeDataType(name,dataType,sessid)
 ;
 n value,outputMethod,x,encodedValue,Error
 ;
 i $g(name)="" QUIT "Data Type encoding attempted but field name was not specified"
 i $g(dataType)="" QUIT "Data Type encoding attempted for the "_name_" field, but no data type was defined"
 s value=$$getSessionValue^%zewdAPI(name,sessid)
 s outputMethod=$$getOutputMethod^%zewdCompiler(dataType)
 i outputMethod="" QUIT ""
 s x="s encodedValue=$$"_outputMethod_"("""_value_""",.Error,sessid)"
 x x
 i $g(Error)="" d setSessionValue^%zewdAPI(name,encodedValue,sessid)
 ;i Error'="" s Error=name_" : "_Error
 QUIT Error
 ;
