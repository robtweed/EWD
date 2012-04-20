%zewdCompiler19	; Runtime Functions
 ;
 ; Product: Enterprise Web Developer (Build 907)
 ; Build Date: Fri, 20 Apr 2012 11:29:32
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
writeObjectAsJSON(objectName,addRefCol,addScriptTag,sessid)
 ;
 n object,propName,showExtJSWarning,sub
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
 d writeJSONString^%zewdCompiler19(objectName,.object,$g(addRefCol),$g(addScriptTag))
 QUIT
 ;
writeJSONString(objectName,objectArray,addRefCol,addScriptTag)
 ;
 n name
 ;
 i $d(objectArray)=1 w objectName_"="_objectArray_";"_$c(13,10) QUIT
 i '$d(objectArray) QUIT
 i $g(addRefCol)=1 d
 . n rowNo
 . s rowNo=""
 . f  s rowNo=$o(objectArray(rowNo)) q:rowNo=""  d
 . . s objectArray(rowNo,0)=rowNo-1
 i $g(addScriptTag)=1 w "<script language=""javascript"">"
 w objectName_"="
 s name=""
 d walkObjectArray($name(objectArray))
 w ";"
 i $g(addScriptTag)=1 w "</script>"
 QUIT
 ;
walkObjectArray(name,subscripts)
 ;
 n dd,no,ref,ref2,subscripts1,value,xd,xref,xsub
 ;
 s xref="s xsub=$o("_$$createNextRef(name,.subscripts)_")"
 x xref
 i xsub="" QUIT
 i xsub?1N.N d  QUIT
 . w "["
 . f  d  QUIT:xsub=""
 . . m subscripts1=subscripts
 . . s no=$o(subscripts(""),-1)+1
 . . s subscripts1(no)=xsub
 . . d walkObjectArray(name,.subscripts1)
 . . s ref=$$createRef(name,xsub,.subscripts)
 . . s xref="s dd=$d("_ref_")"
 . . x xref
 . . i dd=1 d
 . . . s xref="s value=$g("_ref_")"
 . . . x xref
 . . . d displayValue(value)
 . . s xref="s xsub=$o("_ref_")"
 . . x xref
 . . s ref2=$$createRef(name,xsub,.subscripts)
 . . i ref2["""""" q
 . . s xref="s xd=$d("_ref2_")"
 . . x xref
 . . i dd=10,xsub'="" w "," q
 . . i xsub'="",xd'=1,xsub?1N.N w "],[" q
 . . i xsub'="",xd=1,dd'=1,xsub?1N.N w "]," q
 . . i xsub'="" w ","
 . w "]"
 i xsub["zobj" d  QUIT
 . w "{"
 . f  d  QUIT:xsub=""
 . . m subscripts1=subscripts
 . . s no=$o(subscripts(""),-1)+1
 . . s subscripts1(no)=xsub
 . . d walkObjectArray(name,.subscripts1)
 . . s ref=$$createRef(name,xsub,.subscripts)
 . . s xref="s xsub=$o("_ref_")"
 . . x xref
 . . i xsub'="",xsub["zobj" w "},{"
 . w "}"
 f  d  QUIT:xsub=""
 . w """"_xsub_""":"
 . m subscripts1=subscripts
 . s no=$o(subscripts(""),-1)+1
 . s subscripts1(no)=xsub
 . d walkObjectArray(name,.subscripts1)
 . s ref=$$createRef(name,xsub,.subscripts)
 . s xref="s value=$d("_ref_")"
 . x xref
 . i value=1 d
 . . s xref="s value=$g("_ref_")"
 . . x xref
 . . d displayValue(value)
 . s xref="s xsub=$o("_ref_")"
 . x xref
 . i xsub'="" w ","
 QUIT
 ;
displayValue(value)
 i value?1N.N w value QUIT
 i value?1N.N1"."1N.N w value QUIT
 i value?1"-"1N.N w value QUIT
 i value?1"-"1N.N1"."1N.N w value QUIT
 i $e(value,1)="{" w value QUIT
 i value="true"!(value="false") w value QUIT
 i value["<?=",value["?>" d  QUIT
 . s value=$p(value,"<?=",2)
 . s value=$p(value,"?>",1)
 . s value=$$stripSpaces^%zewdAPI(value)
 . w value
 w """"_value_""""
 QUIT
 ;
createRef(name,xsub,subscripts)
 ;
 n i,no,ref,quot
 ;
 s ref=name_"("
 s no=$o(subscripts(""),-1)
 i no>0 f i=1:1:no d
 . s quot=""""
 . i subscripts(i)?."-"1N.N s quot=""
 . s ref=ref_quot_subscripts(i)_quot_","
 s ref=ref_""""_xsub_""")"
 QUIT ref
 ;
createNextRef(name,subscripts)
 ;
 n i,no,ref,quot
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
createPrintDiv(outputPath,verbose)
 ; No longer used but retained here for future reference
 ; See compiler15 in build 714 for ewdScripts Javascript for handling it
 ; and for ewdPrintDiv.html text source
 n line,i,filePath
 ;
 i $d(^zewd("config","jsScriptPath",technology,"outputPath")) d
 . n dlim
 . s dlim=$$getDelim^%zewdAPI()
 . s outputPath=^zewd("config","jsScriptPath",technology,"outputPath")
 . i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s filePath=outputPath_"ewdPrintDiv.html"
 i '$$openNewFile^%zewdAPI(filePath) QUIT
 u filePath
 f i=1:1 s line=$t(printDiv+i^%zewdCompiler15) q:line["***END**"  d
 . w $p(line,";;",2,250),!
 c filePath
 i verbose=1 w filePath,!
 i verbose=2 d addToReport^%zewdCompiler(filePath,.results)
 QUIT
 ;
createJSFile(outputPath,verbose,technology) ;
	;
	n filePath,io,label,line,lineNo,no,stop,x
	;
	i $d(^zewd("config","jsScriptPath",technology,"outputPath")) d
	. n dlim
	. s dlim=$$getDelim^%zewdAPI()
	. s outputPath=^zewd("config","jsScriptPath",technology,"outputPath")
	. i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
	;
	i $g(isIwd) d  QUIT
	. n buildNo,ip
	. s buildNo=$$getVersion^%zewdCompiler()_": "_$$inetDate^%zewdAPI($h)
	. s ^zewd("manifest",app,"build")=buildNo
	. s filePath=outputPath_"iwdScripts.js"
	. s io=$io
	. i '$$openNewFile^%zewdCompiler(filePath) q
	. u filePath
	. f label="iWD","ajaxLoader","JSON2" d
	. . s stop=0
	. . f lineNo=1:1 d  q:stop
	. . . i label="JSON2" s no=9
	. . . i label="ajaxLoader" s no=9
	. . . i label="iWD" s no=14
	. . . s x="s line=$t("_label_"+lineNo^%zewdCompiler"_no_")"
	. . . x x
	. . . i line["***END***" s stop=1 q
	. . . s line=$p(line,";;",2,250)
	. . . i $e(line,1,2)="//" q
	. . . s line=$$stripSpaces^%zewdAPI(line)
	. . . s line=$$replaceAll^%zewdAPI(line," = ","=")
	. . . s line=$$replaceAll^%zewdAPI(line," != ","!=")
	. . . s line=$$replaceAll^%zewdAPI(line," == ","==")
	. . . s line=$$replaceAll^%zewdAPI(line," + ","+")
	. . . s line=$$replaceAll^%zewdAPI(line," < ","<")
	. . . s line=$$replaceAll^%zewdAPI(line," > ",">")
	. . . i line["<buildnumber>" s line=$$replace^%zewdAPI(line,"<buildnumber>",buildNo)
	. . . w line_$c(10)
	. c filePath u io
	. ;
	. s filePath=outputPath_"iwdLoader.js"
	. s io=$io
	. i '$$openNewFile^%zewdCompiler(filePath) q
	. u filePath
	. s stop=0
	. s ip=$$getIP^%zewdGTM()
	. i ip="" s ip=$$convertDateToSeconds^%zewdAPI($h)
	. s buildNo=$$getVersion^%zewdCompiler()_"-"_ip
	. f lineNo=1:1 d  q:stop
	. . s line=$t(iWDLoader+lineNo^%zewdCompiler14)
	. . i line["***END***" s stop=1 q
	. . s line=$p(line,";;",2,250)
	. . i $e(line,1,2)="//" q
	. . i line["<buildnumber>" s line=$$replace^%zewdAPI(line,"<buildnumber>",buildNo)
	. . s line=$$stripSpaces^%zewdAPI(line)
	. . s line=$$replaceAll^%zewdAPI(line," = ","=")
	. . s line=$$replaceAll^%zewdAPI(line," != ","!=")
	. . s line=$$replaceAll^%zewdAPI(line," == ","==")
	. . s line=$$replaceAll^%zewdAPI(line," + ","+")
	. . s line=$$replaceAll^%zewdAPI(line," < ","<")
	. . s line=$$replaceAll^%zewdAPI(line," > ",">")
	. . w line_$c(10)
	. c filePath u io
	;
	s filePath=outputPath_"ewdScripts.js"
	s io=$io
	i '$$openNewFile^%zewdCompiler(filePath) QUIT
	u filePath:width=1000000
	;
	;f label="jsBlock","openWindowJS","ajaxLoader","JSON2","comboPlus" d
	f label="jsBlock","openWindowJS","ajaxLoader","JSON2" d
	. s stop=0
	. f lineNo=1:1 d  q:stop
	. . s no=2
	. . i label="ajaxLoader"!(label="JSON2") s no=9
	. . i label="jsBlock" s no=15
	. . i label="slideshow" s no=18
	. . i label="comboPlus" s no=21
	. . i label="iWD" s no=14
	. . s x="s line=$t("_label_"+lineNo^%zewdCompiler"_no_")"
	. . i label="jsBlock" s x="s line=$t(jsBlock+lineNo^%zewdJS)"
	. . i label="EWDext" s x="s line=$t("_label_"+lineNo^%zewdExtJSCode)"
	. . x x
	. . i line["***END***" s stop=1 q
	. . i line[";;*php*",technology'="php" q
	. . i line[";;*csp*",((technology'="csp")!(technology="wl")!(technology="gtm")!(technology="ewd")) q
	. . i line[";;*jsp*",technology'="jsp" q
	. . i line[";;*vb.net*",technology'="vb.net" q
	. . i line["<buildnumber>" s line=$$replace^%zewdAPI(line,"<buildnumber>",$$getVersion^%zewdCompiler())
	. . s line=$$replace^%zewdHTMLParser(line,"*php*","     ")
	. . s line=$$replace^%zewdHTMLParser(line,"*csp*","     ")
	. . s line=$$replace^%zewdHTMLParser(line,"*jsp*","     ")
	. . s line=$$replace^%zewdHTMLParser(line,"*vb.net*","     ")
	. . s line=$p(line,";;",2,250)
	. . i $e(line,1,2)="//" q
	. . s line=$$stripSpaces^%zewdAPI(line)
	. . s line=$$replaceAll^%zewdAPI(line," = ","=")
	. . s line=$$replaceAll^%zewdAPI(line," != ","!=")
	. . s line=$$replaceAll^%zewdAPI(line," == ","==")
	. . s line=$$replaceAll^%zewdAPI(line," + ","+")
	. . s line=$$replaceAll^%zewdAPI(line," < ","<")
	. . s line=$$replaceAll^%zewdAPI(line," > ",">")
	. . i label="ajaxLoader",line["There was a problem reported in the Ajax response" d
	. . . i $g(^zewd("config","ajaxError","customMessage"))'="" d
	. . . . s line="var ajaxError='"_^zewd("config","ajaxError","customMessage")_"';"
	. . . i $g(^zewd("config","ajaxError","suppressMessage"))=1 s line="var ajaxError='';"
	. . . i $g(^zewd("config","ajaxError","reportToURL"))'="" d
	. . . . n dlim,url
	. . . . s url="'"_^zewd("config","ajaxError","reportToURL")
	. . . . s dlim="&"
	. . . . i url'["?" s delim="?"
	. . . . s url=url_dlim_"status='+http_request.status+'&url='+escape(url)"
	. . . . s line=line_$c(10)_"EWD.ajax.makeRequest("_url_",id,'get');"
	. . i $e(line,$l(line)-1,$l(line))=" ;" s line=$e(line,1,$l(line)-2)_";"
	. . w line_$c(10)
	c filePath u io
	;
	d createCustomResources^%zewdCustomTags(app)
	;
	;i verbose=1 w filePath,!
	;i verbose=2 d addToReport^%zewdCompiler(filePath,.results)
	QUIT
 ;
logAjaxError(sessid)
 ;
 n status,url
 ;
 s status=$$getRequestValue^%zewdAPI("status",sessid)
 s status=status_"; IP="_$$getServerValue^%zewdAPI("REMOTE_ADDR",sessid)
 s status=status_"; "_$$inetDate^%zewdAPI($h)
 d trace^%zewdAPI("Ajax Error: status="_status)
 s url=$$getRequestValue^%zewdAPI("url",sessid)
 d trace^%zewdAPI("URL = "_url)
 d setSessionValue^%zewdAPI("response"," ",sessid)
 QUIT
 ;
listDOMsByPrefix(prefix)
    i $g(prefix)="" s prefix="eXtcDOM"
	s name=prefix
	f  s name=$o(^zewdDOM("docNameIndex",name)) q:name=""  d
	. i name'[prefix Q
	. w name,!
	QUIT
 ;
removeDOMsByPrefix(prefix)
    i $g(prefix)="" s prefix="eXtcDOM"
	s name=prefix
	f  s name=$o(^zewdDOM("docNameIndex",name)) q:name=""  d
	. i name'[prefix Q
	. w name,!
	. i $$removeDocument^%zewdDOM(name)
	QUIT
	;
getPREVPAGE(sessid) ;
 n PREVPAGE
 s PREVPAGE=$$getSessionValue^%zewdAPI("ewd_previousPage",sessid)
 s PREVPAGE=$p(PREVPAGE,"/",$l(PREVPAGE,"/"))
 s PREVPAGE=$p(PREVPAGE,".",1)
 s PREVPAGE=$$zcvt^%zewdAPI(PREVPAGE,"U")
 QUIT PREVPAGE
  ;
loadErrorSymbols(sessid)
 n ok
 n %zzv
 s %zzv=""
 f  s %zzv=$o(^%zewdError(sessid,%zzv)) QUIT:%zzv=""  d
 . m @%zzv=^%zewdError(sessid,%zzv)
 ;
confirmLoad
 m %zewdSession=^%zewdError(sessid,"session")
 ;
 w "The symbol table for Session "_sessid_" at the time of error has been loaded into your partition",!!
 w "The Session Object contents at the time of the error have been copied into the local array %zewdSession",!
 ;
 QUIT
 ;
inputFile(docName,sessid,phpHeaderArray)
	;
	; Process nextpage attribute for <input type=file>
	; 
	new filePath,formFound,formOID,lineNo,name,nodeOID,ntags,OIDArray,parentOID,type
	; 
	set ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. set type=$$getAttributeValue^%zewdDOM("type",1,nodeOID)
	. set name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(type,"L")'="file"
	. set filePath=$$getAttributeValue^%zewdDOM("filepath",0,nodeOID)
	. quit:filePath=""
	. d
	. . s uploadText(name)=" s sessionArray(""ewd_fileUpload"","""_name_""")="""_filePath_""""
	. ;
	. s formOID=$$getParentForm^%zewdDOM(nodeOID)
	. i formOID'="" d setAttribute^%zewdDOM("method","uploadFile",formOID)
	. ;
	. do removeAttribute^%zewdAPI("filepath",nodeOID,1)
	QUIT
	;
parseJSON(jsonString,propertiesArray)
 ;
 n array,arrRef,buff,c
 ;
 k propertiesArray
 s buff=$g(jsonString)
 s arrRef="array"
 f  q:buff=""  d
 . s c=$e(buff,1)
 . s buff=$e(buff,2,$l(buff))
 . i c="{" d parseJSONArray(.buff,"")
 . i c="[" d parseJSONArrayA(.buff,"")
 m propertiesArray=array
 QUIT
 ;
parseJSONArrayA(buff,subs)
 n c,n,qlvl,stop,subs2,value,x
 s stop=0,value="",n=0,qlvl=0
 f  d  q:stop
 . s c=$e(buff,1)
 . s buff=$e(buff,2,$l(buff))
 . i c="""" d
 . . i qlvl=0 d
 . . . s qlvl=qlvl+1
 . . e  d
 . . . s qlvl=qlvl-1
 . i c="[" d  q
 . . i n=0 s n=1
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_n
 . . d parseJSONArrayA(.buff,subs2)
 . i c="]" d  q
 . . s stop=1
 . . i value="" q
 . . s n=n+1
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_n
 . . s x="s "_arrRef_"("_subs2_")="_value ;111
 . . x x
 . i c=",",qlvl=0 d  s value="" q
 . . s n=n+1
 . . i $e(buff,1)="[" q
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_n
 . . s x="s "_arrRef_"("_subs2_")="_value
 . . x x
 . s value=value_c q
 QUIT
 ;
 ;
parseJSONArray(buff,subs)
 n c,name,stop,subs2,value,x
 s stop=0,name=""
 f  d  q:stop
 . s c=$e(buff,1)
 . s buff=$e(buff,2,$l(buff))
 . i c="{" d  q
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_""""_name_""""
 . . d parseJSONArray(.buff,subs2)
 . i c="}" d  q
 . . s stop=1
 . i c=":" d  q
 . . n subs2
 . . s value=$$getJSONValue(.buff)
 . . i value="",$e(buff,1)="{" q
 . . i subs'="" d
 . . . s subs2=subs_","
 . . e  d
 . . . s subs2=""
 . . i $e(name,1)="'",$e(name,$l(name))="'" s name=$e(name,2,$l(name)-1)
 . . i value[$c(1) s value=$$replaceAll^%zewdAPI(value,$c(1),"'")
 . . i $e(value,1)="'",$e(value,$l(value))="'" s value=""""_$e(value,2,$l(value)-1)_""""
 . . s subs2=subs2_""""_name_""""
 . . s x="s "_arrRef_"("_subs2_")="_value
 . . i $g(^zewd("trace")) d trace^%zewdAPI("parseJSONArray: "_x)
 . . x x
 . i c="," s name="" q
 . s name=name_c q
 QUIT
 ;
getJSONValue(buff)
 n c,stop,value
 s stop=0,value=""
 f  d  q:stop  q:buff=""
 . s c=$e(buff,1)
 . i c="{" s stop=1 q
 . i c="}" s stop=1 q
 . i c="," s stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . s value=value_c
 QUIT value
 ;
evalStream(nodeOID,attrValues,docOID,technology)
 ;
 n attr,divOID,mainAttrs,xOID
 ;
 d getAttributeValues^%zewdCompiler17(nodeOID,.mainAttrs)
 s attr("id")="ewdEBResponse"
 s divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr)
 s attr("method")=$g(mainAttrs("method"))
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",divOID,,.attr)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
eval(nodeOID,attrValues,docOID,technology)
 ;
 n attr,divOID,mainAttrs,xOID
 ;
 s divOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"div",docOID)
 d setAttribute^%zewdDOM("id","ewdEBResponse",divOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
writeOptionsByID(fieldID,sessid)
 ;
 n codeValue,codeValueEsc,%d,ewdList,fieldRef,i,pos,textValue,textValueEsc
 ;
 s fieldRef="document.getElementById('"_fieldID_"')"
 ;
 w fieldRef_".options.length = 0;"
 d mergeArrayFromSession^%zewdAPI(.ewdList,"ewd_list",sessid)
 s pos="",i=-1
 f  s pos=$o(ewdList(fieldID,pos)) q:pos=""  d
 . s %d=ewdList(fieldID,pos)
 . s textValue=$p(%d,$c(1),1)
 . s textValueEsc=textValue
 . s textValueEsc=$$replaceAll^%zewdHTMLParser(textValueEsc,"&#39;","'")
 . s codeValue=$p(%d,$c(1),2)
 . i codeValue="" s codeValue=textValue
 . s codeValueEsc=codeValue
 . s codeValueEsc=$$replaceAll^%zewdHTMLParser(codeValueEsc,"&#39;","'")
 . s i=i+1
 . w fieldRef_".options["_i_"] = new Option("""_textValueEsc_""","""_codeValueEsc_""");"
 ;
 QUIT
 ;
script(nodeOID,attrValue,docOID,technology)
 ;
 n sOID
 ;
 d removeAttribute^%zewdDOM("id",nodeOID)
 s sOID=$$renameTag^%zewdDOM("script",nodeOID)
 ;
 QUIT
 ;
incrementCounter(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:incrementCounter return="$counter">
	;
	n return,serverOID,text
	;
	set return=$$getAttrValue^%zewdCompiler4("return",.attrValues,technology)
	;
	s text=" s "_return_"=$g("_return_")+1"
	s serverOID=$$addCSPServerScript^%zewdCompiler4(nodeOID,text)
	;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	QUIT
	;
forEach(nodeOID,attrValues,docOID,technology)
	;
	n param,pval,subs
	;
	s param="param",subs=""
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. i technology="csp"!(technology="wl")!(technology="gtm")!(technology="ewd") d
	. . i $e(pval,1)="""" s pval=$e(pval,2,$l(pval)-1) q
	. . i $e(pval,1)'="$" s pval="$"_pval
	. . i $e(pval,1,2)="$$" s pval=$$replaceAll^%zewdAPI(pval,",",$c(0))
	. s subs=subs_pval_","
	s subs=$e(subs,1,$l(subs)-1)
	;
	d
	. n startValue,endValue,cwOID,dummyOID,text,index,no,serverOID
	. ;
	. s no=$p(nodeOID,"-",2)
	. s startValue=$$getAttrValue^%zewdCompiler4("startvalue",.attrValues,technology)
	. s endValue=$$getAttrValue^%zewdCompiler4("endvalue",.attrValues,technology)
	. s index=$$getAttrValue^%zewdCompiler4("index",.attrValues,technology)
	. s cwOID=$$addIntermediateNode^%zewdCompiler4("csp:while",nodeOID)
	. ;
	. s dummyOID=$$addNewFirstChild^%zewdCompiler4("temp",docOID,nodeOID)
	. s text=" s "_index_"="_startValue_$c(13,10)
	. s text=text_" i "_index_"?1N.N s "_index_"="_index_"-1"_$c(13,10)
	. s text=text_" i "_index_"?1AP.ANP d"_$c(13,10)
	. s text=text_" . s p1=$e("_index_",1,$l("_index_")-1)"_$c(13,10)
	. s text=text_" . s p2=$e("_index_",$l("_index_"))"_$c(13,10)
	. s text=text_" . s p2=$c($a(p2)-1)"_$c(13,10)
	. s text=text_" . s "_index_"=p1_p2"_$c(13,10)
	. s text=text_" s nul="""""_$c(13,10)
	. s text=text_" s endValue"_no_"="_endValue_$c(13,10)
	. s text=text_" i endValue"_no_"?1N.N s endValue"_no_"=endValue"_no_"+1"
	. s serverOID=$$addCSPServerScript^%zewdCompiler4(dummyOID,text)
	. d removeIntermediateNode^%zewdCompiler4(dummyOID)
	. ;
	. ; <csp:while condition="$o(%session.Data(&quot;appList&quot;,no))'=nul">
	. ;
	. n lname,localName,obj,subList,subListq,subscripts,sessionName,sname,attr,return
	. n useSessGlo
	. ;
	. s obj="^%zewdSession(""session"",sessid,"
	. s subscripts=$$getAttrValue^%zewdCompiler4("subscriptlist",.attrValues,technology)
	. i $e(subscripts,1)'="""" s subscripts="$"_subscripts
	. i $e(subscripts,1)="""" s subscripts=$e(subscripts,2,$l(subscripts)-1)
	. i subscripts="" s subscripts=subs
	. s sessionName=$$getAttrValue^%zewdCompiler4("sessionname",.attrValues,technology)
	. s sessionName=$$replace^%zewdAPI(sessionName,".","_")
	. s localName=$$getAttrValue^%zewdCompiler4("localname",.attrValues,technology)
	. i sessionName["tmp_" s obj="sessionArray("
	. s return=$$getAttrValue^%zewdCompiler4("return",.attrValues,technology)
	. i return="""""" s return="dummy"
	. s subList="",subListq=""
	. i subscripts'="" d
	. . n nsubs,i
	. . s nsubs=$l(subscripts,",")
	. . f i=1:1:nsubs d
	. . . n sub
	. . . s sub=$p(subscripts,",",i)
	. . . s sub=$$replaceAll^%zewdAPI(sub,$c(0),",")
	. . . i $e(sub,1)="$" d
	. . . . i $e(sub,2)'="$" s sub=$e(sub,2,$l(sub))
	. . . . s subList=subList_","_sub
	. . . . s subListq=subListq_","_sub
	. . . e  d
	. . . . s subList=subList_","""_sub_""""
	. . . . s subListq=subListq_",&quot;"_sub_"&quot;"
	. ; 
	. i $e(sessionName,1)="""" s sname="&quot;"_$e(sessionName,2,$l(sessionName)-1)_"&quot;"
	. e  s sname=sessionName
	. i $e(localName,1)="""" s lname="&quot;"_$e(localName,2,$l(localName)-1)_"&quot;"
	. e  s lname="&quot;"_localName_"&quot;"
	. i sessionName'="""""" d
	. . s attr="($o("_obj_sname_subListq_","_index_"))'=endValue"_no_")&($o("_obj_sname_subListq_","_index_"))'=nul)"
	. e  d
	. . n %p
	. . s %p=lname_subListq
	. . s attr="($o(%ewdVar("_%p_","_index_"))'=endValue"_no_")&($o(%ewdVar("_%p_","_index_"))'=nul)"
	. d setAttribute^%zewdDOM("condition",attr,cwOID)
	. ;
	. s dummyOID=$$addNewFirstChild^%zewdCompiler4("temp",docOID,cwOID)
	. i sessionName'="""""" d
	. . ;s text=" s "_index_"=$o("_obj_sessionName_subList_","_index_"))"_$c(13,10)
	. . s text=" s "_index_"=$o("_obj_sessionName_subList_","_index_"))"_$c(13,10)
	. . s text=text_" s "_return_"=$g("_obj_sessionName_subList_","_index_"))"
	. e  d
	. . n %p
	. . s %p=localName_subListq
	. . s text=" s "_index_"=$o(%ewdVar("_%p_","_index_"))"_$c(13,10)
	. . s text=text_" s "_return_"=$g(%ewdVar("_%p_","_index_"))"
	. s serverOID=$$addCSPServerScript^%zewdCompiler4(dummyOID,text)
	. d removeIntermediateNode^%zewdCompiler4(dummyOID)
	;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
requote(string)
 i $e(string,1)="'" QUIT """"_$e(string,2,$l(string)-1)_""""
 QUIT string
 ;
