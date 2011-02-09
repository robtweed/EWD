%zewdCompiler20	; Enterprise Web Developer Compiler : Combo+ tag processor
 ;
 ; Product: Enterprise Web Developer (Build 846)
 ; Build Date: Wed, 09 Feb 2011 13:14:57
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
setNextPageToken(nextpage)
 n i,string,token
 ;
 ;s token=$$createToken()
 ;
 s string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
 s token=""
 f  d  q:'$d(^%zewdSession("tokens",token))  s token=""
 . f i=1:1:30 s token=token_$e(string,($r(62)+1))
 ;s sessionArray("ewd_NextPage",token)=nextpage
 s sessionArray("ewd_NextPage",token,nextpage)=""
 QUIT token 
 ;
lcSubstring(string,substring)
 ;
 n buff,from,lcString,lcSubstring,stop,to
 ;
 s buff=""
 s lcSubstring=$$zcvt^%zewdAPI(substring,"l")
 s lcString=$$zcvt^%zewdAPI(string,"l")
 f  q:lcString'[lcSubstring  d
 . s to=$f(lcString,lcSubstring)
 . s from=to-$l(substring)-1
 . s buff=buff_$e(string,1,from)_lcSubstring
 . s string=$e(string,to,$l(string))
 . s lcString=$$zcvt^%zewdAPI(string,"l")
 s string=buff_string
 QUIT string 
 ;
setMethodAndNextPage(name,method,nextpage,nameList,sessionArray)
 n token
 i $g(name)="" QUIT
 s token=$$createToken()
 s sessionArray("ewd_Action",name,"method")=method
 s sessionArray("ewd_Action",name,"nextpage")=nextpage
 s sessionArray("ewd_Action",name,"token")=token
 s sessionArray("ewd_Action",name,"nameList")=nameList
 ;s sessionArray("ewd_NextPage",token)=nextpage
 i nextpage'="" s sessionArray("ewd_NextPage",token,nextpage)=""
 QUIT
 ;
createToken()
 n i,string,token
 s string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
 s token=""
 f  d  q:'$d(^%zewdSession("tokens",token))
 . f i=1:1:30 s token=token_$e(string,($r($l(string))+1))
 QUIT token
 ;
comboPlus(nodeOID,attrValues,docOID,technology)
	;
	n attr,attrName,attrs,jsText,linkOID,xOID
	;
	d getAttributeValues(nodeOID,.attrs)
	i $g(attrs("allowanytext"))'="true" s attrs("allowanytext")="false"
	;
	i '$$javascriptObjectExists^%zewdAPI("EWD.utils.comboPlus.getNextOptions",docName) d
	. n idx,jsText,prefix,scriptOID
	. s prefix="-1"
	. s idx=0
	. s jsText($i(idx))="EWD.utils.comboPlus.clear = function (id) {"
	. s jsText($i(idx))="  document.getElementById(id).value = '' ;"
	. s jsText($i(idx))="  document.getElementById('scrollRegion' + id).innerHTML = '' ;"
	. s jsText($i(idx))="  EWD.utils.comboPlus.optSelected = '' ;"
  	. s jsText($i(idx))="  EWD.utils.comboPlus.selectedOption[id]  = 0 ;"
	. s jsText($i(idx))="  ewd:clear^%zewdCompiler20(id) ;"
	. s jsText($i(idx))="};"
	. s jsText($i(idx))="EWD.utils.comboPlus.defineFieldRefs = function() {"
	. s jsText($i(idx))="  EWD.utils.comboPlus.fieldRef['"_$g(attrs("name"))_"'] = '"_$g(attrs("methodreference"))_"' ;"
	. s jsText($i(idx))="};"
	. s jsText($i(idx))="EWD.utils.comboPlus.defineFieldRefs() ;"
	. s jsText($i(idx))="EWD.utils.comboPlus.getNextOptions = function (id) {"
	. s jsText($i(idx))="  var prefix = -1 ;" ;EWD.utils.comboPlus.fieldRef[id]['prefix'] ;"
	. s jsText($i(idx))="  var methodRef = EWD.utils.comboPlus.fieldRef[id] ;"
	. s jsText($i(idx))="  ewd:getNextOptions^%zewdCompiler20(id,prefix,methodRef) ;"
	. s jsText($i(idx))="} ;"
	. s jsText($i(idx))="EWD.utils.comboPlus.quickListMatches = function (id,prefix) {"
	. s jsText($i(idx))="  var methodRef = EWD.utils.comboPlus.fieldRef[id] ;"
	. s jsText($i(idx))="  ewd:getNextOptions^%zewdCompiler20(id,prefix,methodRef) ;"
	. s jsText($i(idx))="} ;"
	. s scriptOID=$$addJavascriptObject^%zewdAPI(docName,.jsText)
	e  d
	. n jsText,ok,prefix
	. s prefix="-1"
	. s jsText=$$getJavascriptObjectBody^%zewdAPI("EWD.utils.comboPlus.defineFieldRefs",docName)
	. s jsText=jsText_$c(13,10)_"  EWD.utils.comboPlus.fieldRef['"_$g(attrs("name"))_"'] = '"_$g(attrs("methodreference"))_"' ;"
	. s ok=$$replaceJavascriptObjectBody^%zewdAPI("EWD.utils.comboPlus.defineFieldRefs",jsText,docName)
	;
	; Modify the <body> tag to include onmouseDown="popupsOff(event)"
	; 
	; Replace the ewd:comboPlus with an <input type=text> tag
	; and also add the button that invokes the drop-down panel
	; eg
	; 
	;   <input type="text" name="xxx" id="xxx" value="1" size=30>
	;   <input type="button" name="xxxBtn" id="xxxBtn" value="v" class="qstDsButton" onclick="toggleDropdown('scrollRegionxxx')">
	;
	s attr("type")="text"
	s attr("contentEditable")="true"
	s attr("onclick")="EWD.utils.comboPlus.initialise('scrollRegion"_$g(attrs("name"))_"',"_$g(attrs("allowanytext"))_")"
	s attr("onkeyUp")="EWD.utils.comboPlus.quickList(event,this.id,this.value,"_$g(attrs("allowanytext"))_")"
	s attr("style")="cursor:default"
	s attrName=""
	f  s attrName=$o(attrs(attrName)) q:attrName=""  d
	. i attrName="script"!(attrName="freetext") q
	. s attr(attrName)=attrs(attrName)
	s xOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr)
	;
	s attr("type")="button"
	s attr("name")=$g(attrs("name"))_"Btn"
	s attr("tabindex")=-1
	s attr("value")=""
	s attr("class")="cpSelButton"
	s attr("onclick")="EWD.utils.comboPlus.initialise('scrollRegion"_$g(attrs("name"))_"',"_$g(attrs("allowanytext"))_")"
	s xOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr,"")
	;
	s jsText=""
	s jsText=jsText_$c(13,10)_"EWD.utils.comboPlus.getBrowserInfo() ;"
	s jsText=jsText_$c(13,10)_"EWD.utils.comboPlus.setButtonStyle("""_$g(attrs("name"))_""") ;"
	s jsText=jsText_$c(13,10)_"EWD.utils.comboPlus.lastTime = EWD.utils.comboPlus.curDate.getTime() ;"
	s jsText=jsText_$c(13,10)_"EWD.utils.comboPlus.curTime = EWD.utils.comboPlus.lastTime ;"
	s jsText=jsText_$c(13,10)_"document.onmousedown = EWD.utils.comboPlus.popupsOff;"
	s jsText=jsText_$c(13,10)_"document.onkeydown = EWD.utils.comboPlus.moveSelected;"
	s attr("language")="javascript"
	s linkOID=$$addElementToDOM^%zewdDOM("script",nodeOID,,.attr,jsText)
	;
	;
	; Add the <iframe> tag that sits beneath the dropdown panel to keep other select
	; boxes from bleeding through.
	; 
	; <iframe id="scrollRegionShimxxx" frameborder=0 style="display:none; position:absolute>
	; </iframe>
	;
	s attr("id")="scrollRegionShim"_$g(attrs("name"))
	s attr("frameborder")=0
	s attr("style")="display:none; position:absolute"
	s attr("src")="javascript:false;"
	s xOID=$$addElementToDOM^%zewdDOM("iframe",nodeOID,,.attr,,1)
	;
	; Finally add the <div> tag that represents the drop-down panel
	; This can be added to the end of the body section
	; 
	; <div id="scrollRegionxxx" class="qstScrollArea" onScroll="checkScrolling(this)" onmouseover="this.setAttribute('active','1')" onmouseout="setMouseOut(this.id)" active="">
	; </div>
	;
	s attr("id")="scrollRegion"_$g(attrs("name"))
	s attr("class")="cpScrollArea"
	s attr("onscroll")="EWD.utils.comboPlus.checkScrolling(this)"
	s attr("onmouseover")="this.setAttribute('active','1')"
	s attr("onmouseout")="EWD.utils.comboPlus.setMouseOut(this.id)"
	; add onKeyDown handler to check cursor up/down events
	s attr("active")=""
	s xOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr,,1)
	;
	d registerResource^%zewdCustomTags("js","ewdComboPlus.js","comboPlus^%zewdCompiler21",app)
	;d registerResource^%zewdCustomTags("css","touchGrid.css","touchGrid^%zewdSTCSS",app)
	d removeIntermediateNode^%zewdDOM(nodeOID) 
	QUIT
	;
updateDropdown(id,array)
	n no,str
	;
	s str="",no=""
	f  s no=$o(array(no)) q:no=""  d
	. s str=str_"EWD.utils.comboPlus.addOption("""_id_""","""_no_""","""_array(no)_""") ;"
	s str=str_" EWD.utils.comboPlus.checkScrollRegionSize("""_id_""");"
	QUIT str
	;
clear(id,sessid)
    d deleteFromSession^%zewdAPI(("last"_id_"Number"),sessid)
	QUIT ""
	;
getNextOptions(id,prefix,methodRef)
 ;
 n lastSeedValue,optionNo,options,seedValue
 ;
 ; prefix =-1 means just update using current prefix
 ;d trace^%zewdAPI("id="_id)
 i prefix="-1" d
 . s prefix=$$getSessionValue^%zewdAPI("ewd.comboPlus."_id_".prefix",sessid)
 . s seedValue=$$getSessionValue^%zewdAPI("ewd.comboPlus."_id_".seedValue",sessid)
 . s optionNo=$$getSessionValue^%zewdAPI("ewd.comboPlus."_id_".lastNo",sessid)
 . s lastSeedValue=seedValue
 e  d
 . ; new clean search using prefix
 . s seedValue=""
 . s optionNo=0
 . s lastSeedValue=""
 . ;d trace^%zewdAPI("prefix="_prefix)
 . d setSessionValue^%zewdAPI("ewd.comboPlus."_id_".prefix",prefix,sessid)
 . ;d trace^%zewdAPI("session value set")
 ;d trace^%zewdAPI("methodRef="_methodRef)
 d runUserMethod(methodRef,prefix,seedValue,.lastSeedValue,.optionNo,.options)
 i '$d(options) d
 . d setSessionValue^%zewdAPI("ewd.comboPlus."_id_".prefix","",sessid)
 . d setSessionValue^%zewdAPI("ewd.comboPlus."_id_".seedValue","",sessid)
 . d setSessionValue^%zewdAPI("ewd.comboPlus."_id_".lastNo",0,sessid)
 d setSessionValue^%zewdAPI("ewd.comboPlus."_id_".seedValue",lastSeedValue,sessid)
 d setSessionValue^%zewdAPI("ewd.comboPlus."_id_".lastNo",optionNo,sessid)
 QUIT $$updateDropdown(id,.options)
 ;
runUserMethod(methodRef,prefix,seedValue,lastSeedValue,optionNo,options)
 ;
 ; This provides a stub for each cross-referenced method reference
 ; This matches the methodReference="xxx" attribute in the
 ; <ewd:comboPlus> tag
 ;
 n maxNo,noFound,rou
 ;
 s rou=$g(^zewd("comboPlus","methodMap",methodRef))
 s rou="d "_rou_"(prefix,seedValue,.lastSeedValue,.optionNo,.options)"
 x rou
 QUIT
 ;
dumpDOM(docName)
 ;
 i docName["-1" s docName=$$getDocumentName^%eDOMAPI(docName)
 s no=$increment(^rltDOM)
 d outputDOM^%eDOMAPI(docName,1,2,"file",,"rtDOM"_no_".txt")
 QUIT
 ;
decodeDataType(name,dataType,sessid)
 ;
 n value,inputMethod,x,decodedValue
 ;
 q:$g(name)=""
 q:$g(dataType)=""
 s value=$$getSessionValue^%zewdAPI(name,sessid)
 s inputMethod=$$getInputMethod^%zewdCompiler(dataType)
 q:inputMethod=""
 s x="s decodedValue=$$"_inputMethod_"("""_value_""",sessid)"
 x x
 d setSessionValue^%zewdAPI(name,decodedValue,sessid)
 QUIT
 ;
getUploadedFileSize(fieldName,sessid)
 ;
 n size,technology
 ;
 set $zt="getUploadedFileSizeErr"
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 QUIT 0
 ;
getUploadedFileSizeErr ;
 set $zt=""
 QUIT ""
 ;
getUploadedFileName(fieldName,sessid)
 ;
 n filename,technology
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 QUIT 0
 ;
getUploadedFileNameErr
 set $zt=""
 QUIT ""
 ;
clearSessionByPrefix(prefix,sessid)
 ;
 n len,name
 QUIT:$g(sessid)=""
 QUIT:$g(prefix)=""
 s prefix=$tr(prefix,".","_")
 s len=$l(prefix)
 ;
 s name=prefix
 f  s name=$o(^%zewdSession("session",sessid,name)) q:name=""  q:$e(name,1,len)'=prefix  d
 . i $e(name,1,4)="ewd_" q
 . d deleteFromSession^%zewdAPI(name,sessid) 
 s name=prefix
 f  s name=$o(^%zewdSession("session",sessid,"ewd_selected",name)) q:name=""  q:$e(name,1,len)'=prefix  d
 . d clearSelected^%zewdAPI(name,sessid)
 s name=prefix
 f  s name=$o(^%zewdSession("session",sessid,"ewd_list",name)) q:name=""  q:$e(name,1,len)'=prefix  d
 . d clearList^%zewdAPI(name,sessid)
 s name=prefix
 f  s name=$o(^%zewdSession("session",sessid,"ewd_textarea",name)) q:name=""  q:$e(name,1,len)'=prefix  d
 . d clearTextArea^%zewdAPI(name,sessid)
 QUIT
 ; 
JSObjectDeclaration(arrayName,objectRef,varName,addVar)
 n jsText
 ;
 s jsText=""
 s addVar=$g(addVar) i addVar="" s addVar=1
 i addVar s jsText="var "
 s jsText=jsText_$g(varName)_"="
 i $g(objectRef)'="" s jsText=jsText_objectRef_"("
 s jsText=jsText_$$convertToJSON^%zewdAPI(arrayName,1)
 i $g(objectRef)'="" s jsText=jsText_")" 
 s jsText=jsText_";"
 QUIT jsText
 ;
js(nodeOID,attrValues,docOID,technology)
	;
	; replace <ewd:js"> with <div id="ewdscript">
	; 
	n childNo,childOID,found,id,jsText,jsTextArray,jsTextOID,lineNo,np,nvp,OIDArray,p1,p2,p3,p4,p5,textArray,trace,url
	;
	s nodeOID=$$renameTag^%zewdDOM("pre",nodeOID) ; ***
	d setAttribute^%zewdDOM("id","ewdscript",nodeOID)
	; Now expand any ewd:ajaxRequest calls
	;
	;d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
	d getDescendantNodes^%zewdDOM(nodeOID,.OIDArray)
	s childOID=""
	f  s childOID=$o(OIDArray(childOID)) q:childOID=""  d
	. ;s childOID=OIDArray(childNo)
	. i $$getNodeType^%zewdDOM(childOID)'=3 q
	. s jsText=$$getData^%zewdDOM(childOID)
	. i jsText'["ewd.ajaxRequest",jsText'["ewd.ajaxSynchRequest" q	
	. f  q:jsText'["ewd.ajaxRequest"  d
	. . s p1=$p(jsText,"ewd.ajaxRequest(",1)
	. . s p2=$p(jsText,"ewd.ajaxRequest(",2,2000)
	. . s p3=$p(p2,")",1),p4=$p(p2,")",2,2000)
	. . s np=$p(p3,",",1)
	. . s id=$p(p3,",",2) i id="" s id=""""""
	. . s nvp=$p(p3,",",3)
	. . s trace=$p(p3,",",4)
	. . s trace=$$zcvt^%zewdAPI(trace,"l")
	. . s trace=$$removeQuotes^%zewdAPI(trace)
	. . i trace'="",trace'="alert",trace'="window" s trace=""
	. . s np=$$removeQuotes^%zewdAPI(np)
	. . s url=$$expandPageName^%zewdCompiler8(np,.nextPageList,.urlNameList,technology,.jsParams)
	. . i nvp="" d
	. . . s p5="EWD.ajax.makeRequest('"_url_"',"_id_",'get','','"_trace_"')"
	. . e  i $e(nvp,1)="""" d
	. . . s url=url_"&"_$$removeQuotes^%zewdAPI(nvp)
	. . . s p5="EWD.ajax.makeRequest('"_url_"',"_id_",'get','','"_trace_"')"
	. . e  d
	. . . s p5="EWD.ajax.makeRequest('"_url_"&' + "_nvp_","_id_",'get','','"_trace_"')"
	. . s jsText=p1_p5_p4
	. f  q:jsText'["ewd.ajaxSynchRequest"  d
	. . s p1=$p(jsText,"ewd.ajaxSynchRequest(",1)
	. . s p2=$p(jsText,"ewd.ajaxSynchRequest(",2,2000)
	. . s p3=$p(p2,")",1),p4=$p(p2,")",2,2000)
	. . s np=$p(p3,",",1)
	. . s id=$p(p3,",",2) i id="" s id=""""""
	. . s nvp=$p(p3,",",3)
	. . s trace=$p(p3,",",4)
	. . s trace=$$zcvt^%zewdAPI(trace,"l")
	. . s trace=$$removeQuotes^%zewdAPI(trace)
	. . i trace'="",trace'="alert",trace'="window" s trace=""
	. . s np=$$removeQuotes^%zewdAPI(np)
	. . s url=$$expandPageName^%zewdCompiler8(np,.nextPageList,.urlNameList,technology,.jsParams)
	. . i nvp="" d
	. . . s p5="EWD.ajax.makeRequest('"_url_"',"_id_",'synch','','"_trace_"')"
	. . e  i $e(nvp,1)="""" d
	. . . s url=url_"&"_$$removeQuotes^%zewdAPI(nvp)
	. . . s p5="EWD.ajax.makeRequest('"_url_"',"_id_",'synch','','"_trace_"')"
	. . e  d
	. . . s p5="EWD.ajax.makeRequest('"_url_"&' + "_nvp_","_id_",'synch','','"_trace_"')"
	. . s jsText=p1_p5_p4
	. s jsTextOID=$$modifyTextData^%zewdDOM(jsText,childOID)
	;
	QUIT
	;
jsSection(nodeOID,attrValues,docOID,technology)
	;
	; replace the jsSection node with its text if present
	;
	n childOID,text,textOID
	;
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	i $$getNodeType^%zewdDOM(childOID)=3 d
	. s text=$$getData^%zewdDOM(childOID)
	. i text["ewd.ajaxRequest" d
	. . s text=$$parseAjaxRequest(text)
	. . i $$modifyTextData^%zewdDOM(text,childOID)
	. s textOID=$$convertNodeToText^%zewdDOM(nodeOID)
	e  d
	. d removeIntermediateNode^%zewdDOM(nodeOID)
	QUIT
	;
convertNodeToText(nodeOID)
	;
	; replace an element with its text node
	; 
	n data,ok,textOID
	s textOID=$$getFirstChild^%zewdDOM(nodeOID)
	i $$getNodeType^%zewdDOM(textOID)'=3 QUIT ""
	s textOID=$$removeChild^%zewdDOM(textOID)
	s data=$$getData^%zewdDOM(textOID)
	s ok=$$modifyTextData^%zewdDOM(data_$c(13,10),nodeOID)
	s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	s ok=$$removeChild^%zewdDOM(nodeOID)
	QUIT textOID
	;
jsConstructor(nodeOID,attrValues,docOID,technology)
	;
	; create a Javascript Constructor statement
	;
	n addVar,attrs,c,comma,i,jsText,object,ok,paramsOID,return,stop,text,textOID
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	s return=$g(attrs("return"))
	s addVar=$g(attrs("addvar"))
	s object=$g(attrs("object"))
	s jsText="" i addVar="true" s jsText="var "
	s jsText=jsText_return_"=new "_object_"("
	s comma=""
	s paramsOID=$$getFirstChild^%zewdDOM(nodeOID)
	i paramsOID'="" d
	. i $$getTagName^%zewdDOM(paramsOID)="ewd:jsparameters" d
	. . n childNo,childOID,OIDArray,tagName
	. . d getChildrenInOrder^%zewdDOM(paramsOID,.OIDArray)
	. . s childNo=""
	. . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. . . s childOID=OIDArray(childNo)
	. . . s tagName=$$getTagName^%zewdDOM(childOID)
	. . . i tagName="ewd:jsobject" d
	. . . . n json
	. . . . s json=$$jsObject(childOID)
	. . . . s jsText=jsText_comma_json
	. . . i tagName="ewd:jsarray" d
	. . . . n json
	. . . . s json=$$jsArray(childOID)
	. . . . s jsText=jsText_comma_json
	. . . i tagName="ewd:jsvariable" d
	. . . . n var
	. . . . s var=$$getAttribute^%zewdDOM("name",childOID)
	. . . . s jsText=jsText_comma_var
	. . . i tagName="ewd:jsliteral" d
	. . . . n var
	. . . . s var=$$getAttribute^%zewdDOM("value",childOID)
	. . . . s jsText=jsText_comma_""""_var_""""
	. . . s comma=","
	s jsText=jsText_");"
	f  q:jsText=""  d
	. s text=$e(jsText,1,100)
	. s jsText=$e(jsText,101,$l(jsText))
	. s stop=0
	. f  q:jsText=""  q:stop  d
	. . s c=$e(jsText,1)
	. . s text=text_c
	. . s jsText=$e(jsText,2,$l(jsText))
	. . i c="}" s stop=1
	. s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	s ok=$$removeChild^%zewdDOM(nodeOID)
	QUIT
	;
addJSText(jsText,nodeOID,docOID)
	n textOID
	;
	s textOID=$$createTextNode^%zewdDOM(jsText,docOID)
	s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	s jsText=""
	QUIT
	;
jsPage(nodeOID,attrValues,docOID,technology)
	;
	; expand an ewd page reference and return tokenised URL as a Javascript variable
	;
	; <ewd:jsPage src="myPage.ewd" return="page" addvar="true" />
	;
	n addVar,apos,attrs,return,src,text,textOID,url
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	s addVar=$g(attrs("addvar"))
	s return=$g(attrs("return"))
	s src=$g(attrs("src"))
	s url=$$expandPageName^%zewdCompiler8(src,.nextPageList,.urlNameList,technology,.jsParams)
	s text="" i addVar="true" s text="var "
	s apos="'" i url["'" s apos=""""
	s text=text_return_"="_apos_url_apos_";"
	s textOID=$$createTextNode^%zewdDOM(text,docOID)
	s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	s ok=$$removeChild^%zewdDOM(nodeOID)
	QUIT
	;
jsSet(nodeOID,attrValues,docOID,technology)
	;
	; create a Javascript Set statement
	;
	n addVar,attrs,c,jsText,ok,return,stop,text,textOID,type,value
	;
	d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
	s return=$g(attrs("return"))
	s addVar=$g(attrs("addvar"))
	s type=$g(attrs("type"))
	s value=$g(attrs("value"))
	s jsText="" i addVar="true" s jsText="var "
	s jsText=jsText_return_"="
	d
	. i type="literal" d  q
	. . s jsText=jsText_""""_value_""";"
	. i type="object" d  q
	. . n json
	. . s json=$$jsObject(nodeOID)
	. . s jsText=jsText_json_";"
	. i type="array" d  q
	. . n json
	. . s json=$$jsArray(nodeOID)
	. . s jsText=jsText_json_";"
	f  q:jsText=""  d
	. s text=$e(jsText,1,100)
	. s jsText=$e(jsText,101,$l(jsText))
	. s stop=0
	. f  q:jsText=""  q:stop  d
	. . s c=$e(jsText,1)
	. . s text=text_c
	. . s jsText=$e(jsText,2,$l(jsText))
	. . i c="}" s stop=1
	. s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	s ok=$$removeChild^%zewdDOM(nodeOID)
	QUIT
	;
jsMethod(nodeOID,attrValues,docOID,technology)
	;
	; create a Javascript Set statement
	;
	n comma,jsText,name,ok,paramsOID,textOID,type
	;
	s name=$$getAttribute^%zewdDOM("name",nodeOID)
	s jsText=name_"("
	s comma=""
	s paramsOID=$$getFirstChild^%zewdDOM(nodeOID)
	i paramsOID'="" d
	. i $$getTagName^%zewdDOM(paramsOID)="ewd:jsparameters" d
	. . n childNo,childOID,OIDArray,tagName
	. . d getChildrenInOrder^%zewdDOM(paramsOID,.OIDArray)
	. . s childNo=""
	. . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
	. . . s childOID=OIDArray(childNo)
	. . . s tagName=$$getTagName^%zewdDOM(childOID)
	. . . i tagName="ewd:jsobject" d
	. . . . n json
	. . . . s json=$$jsObject(childOID)
	. . . . s jsText=jsText_comma_json
	. . . i tagName="ewd:jsarray" d
	. . . . n json
	. . . . s json=$$jsArray(childOID)
	. . . . s jsText=jsText_comma_json
	. . . i tagName="ewd:jsvariable" d
	. . . . n var
	. . . . s var=$$getAttribute^%zewdDOM("name",childOID)
	. . . . s jsText=jsText_comma_var
	. . . i tagName="ewd:jsliteral" d
	. . . . n var
	. . . . s var=$$getAttribute^%zewdDOM("value",childOID)
	. . . . s jsText=jsText_comma_""""_var_""""
	. . . s comma=","
	s jsText=jsText_");"
	s textOID=$$createTextNode^%zewdDOM(jsText,docOID)
	s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	s ok=$$removeChild^%zewdDOM(nodeOID)
	QUIT
	;
jsObject(nodeOID)
 ;
 n attr,childNo,childOID,comma,json,OIDArray,ref,tagName
 ;
 s ref=$$getAttribute^%zewdDOM("ref",nodeOID)
 i ref'="" QUIT ref
 ;
 s json="{",comma=""
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="ewd:jsnvp" d
 . . n name,type,value
 . . d getAttributeValues^%zewdCustomTags(childOID,.attr)
 . . s name=$g(attr("name"))
 . . s value=$g(attr("value"))
 . . s type=$g(attr("type"))
 . . i type="" s type="literal"
 . . i type="url" d
 . . . s value=$$expandPageName^%zewdCompiler8(value,.nextPageList,.urlNameList,technology)
 . . . s type="literal"
 . . i type="objectname" d
 . . . s json=json_comma
 . . e  d
 . . . s json=json_comma_name_":"
 . . s comma=","
 . . i type="object" d  q
 . . . n json2
 . . . s json2=$$jsObject(childOID)
 . . . s json=json_json2
 . . i type="array" d  q
 . . . n json2
 . . . s json2=$$jsArray(childOID)
 . . . s json=json_json2
 . . i type="literal" s json=json_""""
 . . s json=json_value
 . . i type="literal" s json=json_""""
 QUIT json_"}"
 ;
jsArray(nodeOID)
 ;
 n attr,childNo,childOID,comma,json,OIDArray,tagName
 ;
 s json="[",comma="" 
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="ewd:jsvariable" d  q
 . . n var
 . . s var=$$getAttribute^%zewdDOM("name",childOID)
 . . s json=json_comma_var
 . . s comma=","
 . i tagName="ewd:jsliteral" d  q
 . . n var
 . . s var=$$getAttribute^%zewdDOM("name",childOID)
 . . s json=json_comma_""""_var_""""
 . . s comma=","
 . i tagName="ewd:jsobject" d  q
 . . n json2
 . . s json2=$$jsObject(childOID)
 . . s json=json_comma_json2
 . . s comma=","
 . i tagName="ewd:jsarray" d  q
 . . n json2
 . . s json2=$$jsArray(childOID)
 . . s json=json_comma_json2
 . . s comma=","
 QUIT json_"]"
 ;
jsFunction(nodeOID,attrValues,docOID,technology)
 ;<ewd:jsFunction return="xxx" addVar="true">...</ewd:jsFunction>
 ;
 n addVar,attrs,jsText,nsOID,params,return,textOID
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.attrs)
 s return=$g(attrs("return"))
 s addVar=$g(attrs("addvar"))
 s params=$g(attrs("parameters"))
 s jsText="" i addVar="true" s jsText="var "
 s jsText=jsText_return_"=function("_params_") {"
 s textOID=$$createTextNode^%zewdDOM(jsText,docOID)
 s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
 s textOID=$$createTextNode^%zewdDOM("};",docOID)
 s nsOID=$$getNextSibling^%zewdDOM(nodeOID)
 i nsOID'="" d
 . s textOID=$$insertBefore^%zewdDOM(textOID,nsOID)
 e  d
 . n parOID
 . s parOID=$$getParentNode^%zewdDOM(nodeOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,parOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
linkToParentSession(sessid)
 ;
 n ok,parentSessid,parentToken
 ;
 s parentToken=$$getRequestValue^%zewdAPI("ewd_parentToken",sessid)
 s parentSessid=$$getSessid^%zewdPHP(parentToken)
 i parentSessid="" QUIT 0
 ;
 d setSessionValue^%zewdAPI("ewd_parentSession",parentSessid,sessid)
 s ok=$$copySession(parentSessid,sessid)
 ;
 QUIT ok
 ;
copySession(fromSessid,toSessid)
 ;
 n name
 ;
 i $g(fromSessid)="" QUIT 0
 i $g(toSessid)="" QUIT 0
 s name=""
 f  s name=$o(^%zewdSession("session",fromSessid,name)) q:name=""  d
 . i $e(name,1,4)="ewd_",name'="ewd_Language" q
 . m ^%zewdSession("session",toSessid,name)=^%zewdSession("session",fromSessid,name)
 ;
 QUIT 1
 ;
metaRefresh(docName,nextPageList,technology) ;
	;
	;<ewd:refresh time=30 url="ewdLogout.ewd"> or
	;<meta http-equiv="Refresh" content="60;URL=First.ewd">
	;
	new ntags,OIDArray,nodeOID,headOID,urlNameList,jsParams
	new refresh,content,%p1,%p2,pageName,nvp,url,dlim
	new time,url,attr,nOID,metaOID
	;  
	set headOID=$$getTagOID^%zewdCompiler("head",docName)
	set ntags=$$getTagsByName^%zewdCompiler("ewd:refresh",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. set time=$$getAttributeValue^%zewdDOM("time",1,nodeOID)
	. if time="" set time=60
	. i $e(time,1)="#" d
	. . s time=$e(time,2,$l(time))
	. . s time="#($$getSessionValue^%zewdAPI("""_time_""",sessid))#"
	. set url=$$getAttributeValue^%zewdDOM("url",1,nodeOID)
	. i $e(url,1)="#" d
	. . s url=$e(url,2,$l(time))
	. . s time="#($$getSessionValue^%zewdAPI("""_url_""",sessid))#"
	. set attr("http-equiv")="Refresh"
	. set attr("content")=time_";URL="_url
	. set metaOID=$$addElementToDOM^%zewdDOM("meta",headOID,,.attr,"")
	. set nOID=$$removeChild^%zewdAPI(nodeOID,1)
	;
	kill OIDArray
	set ntags=$$getTagsByName^%zewdCompiler("meta",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. set refresh=$$getAttributeValue^%zewdDOM("http-equiv",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(refresh,"L")'="refresh"
	. set content=$$getAttributeValue^%zewdDOM("content",1,nodeOID)
	. quit:content=""
	. set content=$$convertSubstringCase^%zewdHTMLParser(content,"URL","U")
	. set %p1=$piece(content,"URL=",1)
	. set %p2=$piece(content,"URL=",2)
	. quit:%p2'[".ewd"
	. set url=$$expandPageName^%zewdCompiler8(%p2,.nextPageList,.urlNameList,technology,.jsParams)
	. set content=%p1_"URL="_url
	. do setAttribute^%zewdDOM("content",content,nodeOID)
	QUIT
	;
assignPageToken(page,sessid)
 ;
 n currentPage,sessionArray,technology,token
 ;
 s token=""
 s technology=$$getSessionValue^%zewdAPI("ewd.technology",sessid)
 i technology="wl" d
 . s token=$$setNextPageToken^%zewdWLD(page)
 . m ^%zewdSession("session",sessid)=sessionArray
 . s currentPage=$$getSessionValue^%zewdAPI("ewd.pageName",sessid)
 . d saveNextPageTokens^%zewdPHP(sessid,currentPage)
 QUIT token
 ;
setJSONPage(sessid)
 ;
 n app,js,nextPageList,technology,token,url
 ;
 s technology=$$getSessionValue^%zewdAPI("ewd.technology",sessid)
 s app=$$getSessionValue^%zewdAPI("ewd.appName",sessid)
 s token="&ewd_token="_$$getSessionValue^%zewdAPI("ewd.token",sessid)
 s token=token_"&n="_$$assignPageToken("json",sessid)
 ;
 i technology="wl" d
 . s url=$$getRootURL^%zewdCompiler("wl")
 . s url=url_"?MGWCHD="_$$getSessionValue^%zewdAPI("ewd_mgwchd",sessid)
 . s url=url_"&MGWAPP=ewdwl&app="_app_"&page=json"
 s url=url_token_"&ewd_JSONSource="
 s js="EWD.json.url='"_url_"';"
 QUIT js
 ;
initialiseJSON(sessid)
 d setSessionValue^%zewdAPI("tmp:js",$$setJSONPage^%zewdAPI(sessid),sessid)
 QUIT ""
 ;
returnJSON(sessid)
 ;
 n method,source,x
 ;
 s source=$$getSessionValue^%zewdAPI("ewd_JSONSource",sessid)
 s method=$g(^zewd("jsonSource",source))
 s x="d "_method_"(sessid)"
 i $g(^zewd("trace")) d trace^%zewdAPI("returnJSON dispatch: source="_source_"; x="_x)
 x x
 QUIT
 ;
parseAjaxRequest(jsText)
 ;
 n id,np,nvp,p1,p2,p3,p4,p5,url
 ;
 s p1=$p(jsText,"ewd.ajaxRequest(",1)
 s p2=$p(jsText,"ewd.ajaxRequest(",2,2000)
 s p3=$p(p2,")",1),p4=$p(p2,")",2,2000)
 s np=$p(p3,",",1)
 s id=$p(p3,",",2) i id="" s id=""""""
 s nvp=$p(p3,",",3)
 s np=$$removeQuotes^%zewdAPI(np)
 s url=$$expandPageName^%zewdCompiler8(np,.nextPageList,.urlNameList,technology,.jsParams)
 i nvp="" d
 . s p5="EWD.ajax.makeRequest('"_url_"',"_id_",'get','','')"
 e  i $e(nvp,1)="""" d
 . s url=url_"&"_$$removeQuotes^%zewdAPI(nvp)
 . s p5="EWD.ajax.makeRequest('"_url_"',"_id_",'get','','')"
 e  d
 . s p5="EWD.ajax.makeRequest('"_url_"&' + "_nvp_","_id_",'get','','')"
 s jsText=p1_p5_p4
 QUIT jsText
 ;
cspscript(nodeOID,attrValues,docOID,technology)
	;
	; replace <ewd:cspscript"> with <script">
	; 
	s nodeOID=$$renameTag^%zewdDOM("script",nodeOID)
	QUIT
	;
svgDocument(nodeOID,attrValues,docOID,technology)
 ;
 ;<ewd:svgDocument zoomAndPan="disable" onload="initialize()" >
 ;
 ; <svg xmlns="http://www.w3.org/2000/svg" 
 ;    xmlns:xlink="http://www.w3.org/1999/xlink" 
 ;    zoomAndPan="disable" 
 ;    width="<?= #svg_width ?>" 
 ;    height="<?= #svg_height ?>" 
 ;    onload="top.registerSVGDoc(document); top.injectSVG = injectSVG; Initialize()" 
 ;    viewBox="0 0 <?= #svg_width ?> <?= #svg_height ?>" > 
 ;
 n attr,height,mainAttrs,onload,scriptOID,styleOID,svgOID,width,viewBox
 ;
 d getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s width=$g(mainAttrs("width"))
 i width="" s width=$$addPhpVar^%zewdCustomTags("#svg_width")
 s height=$g(mainAttrs("height"))
 i height="" s height=$$addPhpVar^%zewdCustomTags("#svg_height")
 s onload=$g(mainAttrs("onload"))
 i onload'="" s onload=" "_onload
 s onload="top.registerSVGDoc(document); top.injectSVG = injectSVG;"_onload
 s viewBox="0 0 "_width_" "_height
 ;
 s svgOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"svg",docOID)
 d setAttribute^%zewdDOM("xmlns","http://www.w3.org/2000/svg",svgOID)
 d setAttribute^%zewdDOM("xmlns:xlink","http://www.w3.org/1999/xlink",svgOID)
 d setAttribute^%zewdDOM("width",width,svgOID)
 d setAttribute^%zewdDOM("height",height,svgOID)
 d setAttribute^%zewdDOM("onload",onload,svgOID)
 d setAttribute^%zewdDOM("viewBox",viewBox,svgOID)
 ;
 s styleOID=$$getTagOID^%zewdDOM("style",docName)
 i styleOID'="" d setAttribute^%zewdDOM("usecdata","true",styleOID)
 d
 . s scriptOID=$$getTagByNameAndAttr^%zewdDOM("script","language","javascript",1,docName)
 . i scriptOID'="" d  q
 . . d setAttribute^%zewdDOM("usecdata","true",scriptOID)
 . . d setAttribute^%zewdDOM("language","text/javascript",scriptOID)
 . s scriptOID=$$getTagByNameAndAttr^%zewdDOM("script","language","text/javascript",1,docName)
 . i scriptOID'="" d setAttribute^%zewdDOM("usecdata","true",scriptOID)
 ;
 i scriptOID'="" d
 . n js,text,textOID
 . s textOID=$$getFirstChild^%zewdDOM(scriptOID)
 . s text=$$getData^%zewdDOM(textOID)_$c(13,10)
 . s js(1)="function injectSVG(newtext,targetId) {"
 . s js(2)=" var parser = new DOMParser();"
 . s js(3)=" var xmlDoc = parser.parseFromString(newtext, 'application/xml');"
 . s js(4)=" var newsvg = document.importNode(xmlDoc.documentElement.childNodes[0], true);"
 . s js(5)=" var target=document.getElementById(targetId);"
 . s js(6)=" if (target) {"
 . s js(7)="   if (target.hasChildNodes()) {"
 . s js(8)="      while (target.childNodes.length >= 1) {"
 . s js(9)="        target.removeChild( target.firstChild);"
 . s js(10)="      }"
 . s js(11)="   }"
 . s js(12)=" }"
 . s js(13)=" target.appendChild(newsvg);"
 . s js(14)="}"
 . f i=1:1:14 s text=text_js(i)_$c(13,10)
 . s textOID=$$modifyTextData^%zewdDOM(text,textOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
 ;
getAttributeValues(nodeOID,attr)
	;
	n c1,name,value
	;
	d getAttributeValues^%zewdDOM(nodeOID,.attr)
	s name=""
	f  s name=$o(attr(name)) q:name=""  d
	. s value=attr(name)
	. s c1=$e(value,1)
	. i c1="#"!(c1="$") d  q
	. . s attr(name)=$$addPhpVar(value)
	QUIT
	;
	;
addPhpVar(sessionValue)
	;
	n phpVar,varNo
	;
	s varNo=$o(phpVars(""),-1)+1
	s phpVars(varNo)=" "_sessionValue_" "
	s phpVar="&php;"_varNo_"&php;"
	;
	QUIT phpVar
	;
writePageLinks(app,sessid)
 ;
 n page
 ;
 d loadFiles^%zewdCustomTags($$zcvt^%zewdAPI(app,"l"),"js",sessid)
 i $g(^zewd("config","stopTokenisedURLs",app))=1 QUIT
 i $g(^zewd("config","stopTokenizedURLs",app))=1 QUIT
 ;
 w "<script type='text/javascript'>"_$c(13,10)
 s page=""
 f  s page=$o(^%zewdIndex(app,"pages",page)) q:page=""  d
 . w "EWD.ajax.fetchPage['"_$$zcvt^%zewdAPI(page,"l")_"']=function(params) {"_$c(13,10)
 . w " params.url='"_$$tokeniseURL^%zewdCompiler16(page,sessid)_"';"_$c(13,10)
 . w " EWD.ajax.getURL(params);"_$c(13,10)
 . w "};"_$c(13,10)
 w "</script>"_$c(13,10)
 ;
 QUIT
 ;
