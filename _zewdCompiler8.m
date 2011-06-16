%zewdCompiler8	; Enterprise Web Developer Compiler Functions
 ;
 ; Product: Enterprise Web Developer (Build 867)
 ; Build Date: Thu, 16 Jun 2011 18:10:22
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
expandPageName(pageName,nextPageList,urlNameList,technology,jsParams)
	;
	n amp,currPageName,ext,fn,ft,j,name,nameList,np,nvp,nvpx,str,url,urlNo,value
	;
	k jsParams
	s pageName=$$convertSubstringCase^%zewdHTMLParser(pageName,".ewd","L")
	s nvp=$p(pageName,"?",2,1000)
	s ext=$p(pageName,".",2),ext=$p(ext,"?",1)
	s pageName=$p(pageName,".ewd",1)
	i pageName'="" d
	. q:pageName="*"
	. q:$e(pageName,1)="#"
	. s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalls",$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"),$$zcvt^%zewdAPI(pageName,"l"))=""
	. s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalledBy",$$zcvt^%zewdAPI(pageName,"l"),$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"))=""
	i nvp="static",ext="ewd" s url=pageName_"."_technology QUIT url
	i nvp="static" QUIT pageName
	;i nvp="static"
	s urlNo=$p(filename,".ewd",1)_$i(urlNameList)
	s url=$$getRootURL^%zewdCompiler("gtm")_app_"/"_pageName_".mgwsi?"
	s url=url_"ewd_token=#($g(^%zewdSession(""session"",sessid,""ewd_token"")))#&n=#(tokens("""_$tr(pageName,"'","")_"""))#"
	s url=url_"&ewd_urlNo="_urlNo
	s nameList=""
	i nvp'="" d
	. n nnvp,i
	. ;s url=url_"&"_nvp b
	. s nvp=$$replaceAll^%zewdHTMLParser(nvp,"&php;","*php;")
	. i $$zcvt^%zewdAPI(nvp,"l")["ewdallfields" d
	. . n nvps
	. . s nnvp=$l(nvp,"&")
	. . f i=1:1:nnvp d
	. . . s nvpx=$p(nvp,"&",i)
	. . . s name=$p(nvpx,"=",1)
	. . . s value=$p(nvpx,"=",2)
	. . . i $$zcvt^%zewdAPI(name,"l")'="ewdallfields" s nvps(name)=value q 
	. . . s nameList=$$getFormFields^%zewdCompiler3(nodeOID)
	. . . s np=$l(nameList,"`")
	. . . f j=1:1:np d
	. . . . s str=$p(nameList,"`",j)
	. . . . s fn=$p(str,"|",1)
	. . . . s ft=$p(str,"|",2)
	. . . . q:fn=""
	. . . . i (ft="text")!(ft="select")!(ft="radio")!(ft="hidden")!(ft="password")!(ft="textarea") d
	. . . . . s nvps(fn)="javascript.this.form."_fn_".value"
	. . s name="",nvp="",amp=""
	. . f  s name=$o(nvps(name)) q:name=""  d
	. . . s nvp=nvp_amp_name_"="_nvps(name)
	. . . s amp="&"
	. s nnvp=$l(nvp,"&")
	. f i=1:1:nnvp d
	. . n nvpx,name,value
	. . s nvpx=$p(nvp,"&",i)
	. . s name=$p(nvpx,"=",1)
	. . s value=$p(nvpx,"=",2)
	. . s value=$$replaceAll^%zewdHTMLParser(value,"*php;","&php;")
	. . i $e(value,1,9)="document." d
	. . . s jsParams(name)=value
	. . . s value="[x]"
	. . i $$zcvt^%zewdAPI($e(value,1,11),"l")="javascript." d
	. . . s value=$e(value,12,$l(value))
	. . . s jsParams(name)=value
	. . . s value="[x]"
	. . i $e(value,1)="$" d
	. . . s value="#("_$e(value,2,$l(value))_")#"
	. . i $e(value,1)="#" d
	. . . i $e(value,1,2)'="#(" s value="#($$getSessionValue^%zewdAPI("""_$e(value,2,$l(value))_""",sessid))#"
	. . s nameList=nameList_name_"`"
	. . i value'="[x]" s url=url_"&"_name_"="_value
	s currPageName=$p(filename,".ewd",1)
	i nameList'="" s urlNameList(urlNo)=nameList
	s nextPageList(pageName)=""
	s name="",nvp=""
	f  s name=$o(jsParams(name)) q:name=""  d
	. s nvp=nvp_"&"_name_"=[x]"
	s url=url_nvp
	QUIT url
	;
submitActionNextpage(docName,phpHeaderArray,routineName,technology,dataTypeList,formDeclarations,config,pageName,multilingual,inputPath,filename,textidList)
	;
	; Find all <input type=submit> tags and get any nextpage and action attributes
	; 
	n ajax,appName,attrOID,dlim,dojoType,formId,nextpageRaw,ntags,OIDArray,OIDArray2
	n nodeOID,n,pageName,traceSet
	; 
	s dojoType="",formId=""
	s traceSet=0
	s appName=inputPath
	s dlim=$$getDelim^%zewdCompiler()
	s appName=$p(appName,$$getApplicationRootPath^%zewdCompiler(),2)
	s appName=$p(appName,dlim,2)
	s pageName=$p(filename,".ewd",1)
	s ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	s ntags=$$getTagsByName^%zewdCompiler("button",docName,.OIDArray2)
	m OIDArray=OIDArray2
	s nodeOID="",n=$o(formDeclarations(""),-1)
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. n name,nextpage,action,type,confirm,onSubmitConfirm,nameList
	. s type=$$getAttributeValue^%zewdDOM("type",1,nodeOID)
	. i $$zcvt^%zewdAPI(type,"L")'="submit",$$zcvt^%zewdAPI(type,"L")'="image" q
	. ;
	. s ajax=$$getAttributeValue^%zewdDOM("ajax",1,nodeOID)
	. s ajax=$$zcvt^%zewdAPI(ajax,"l")
	. i ajax="",$g(config("pageType"))="ajax" s ajax="true"
	. i ajax="false" d removeAttribute^%zewdDOM("ajax",nodeOID)
	. s onSubmitConfirm=""
	. s confirm=$$getAttributeValue^%zewdDOM("confirm",1,nodeOID)
	. ;i $$zcvt^%zewdAPI(confirm,"L")="true",$$zcvt^%zewdAPI(ajax,"l")'="true" d
	. i $$zcvt^%zewdAPI(confirm,"L")="true" d
	. . n onclick,oceh,confirmText
	. . s onclick=$$getAttributeValue^%zewdDOM("onclick",1,nodeOID)
	. . ;s oceh="ewdDel=1"
	. . s oceh="EWD.page.showConfirmMessage=true"
	. . i onclick'="" d
	. . . s onclick=onclick_" ; "
	. . . d removeAttribute^%zewdAPI("onclick",nodeOID)
	. . s onclick=onclick_oceh
	. . d setAttribute^%zewdDOM("onclick",onclick,nodeOID)
	. . d removeAttribute^%zewdAPI("confirm",nodeOID)
	. . s confirmText=$$getAttributeValue^%zewdDOM("confirmtext",1,nodeOID)
	. . s attrOID=$$getAttributeNode^%zewdDOM("onclick",nodeOID)
	. . i confirmText'="" d removeAttribute^%zewdAPI("confirmtext",nodeOID)
	. . i multilingual d
	. . . n textid,text,containsVars,outputText
	. . . s textid=$$encodeValue^%zewdCompiler5(confirmText,attrOID,appName,pageName,.text,.textidList,technology,.containsVars,.outputText) ;b:containsVars
	. . . i textid="" q
	. . . i 'containsVars d  q
	. . . . n xvalue
	. . . . s xvalue="#($$displayText^%zewdAPI("""_textid_""",0,"""_technology_"""))#"
	. . . . i multilingual=1 s xvalue="#($$displayText^%zewdAPI("""_textid_""",1,"""_technology_"""))#"
	. . . . s onSubmitConfirm="EWD.page.confirmText="""_$$zcvt^%zewdCompiler(xvalue)_""" ; EWD.page.setOnSubmit(this,EWD.page.confirmText)"
	. . . ;
	. . . ; contains variables
	. . . ;
	. . . s onSubmitConfirm="EWD.page.confirmText="""_$$zcvt^%zewdCompiler(text)_""" ; EWD.page.setOnSubmit(this,EWD.page.confirmText)"
	. . e  d
	. . . i ajax'="true" d
	. . . . s onSubmitConfirm="EWD.page.confirmText="""_$$zcvt^%zewdCompiler(confirmText)_""" ; EWD.page.setOnSubmit(this,EWD.page.confirmText)"
	. . . e  d
	. . . . s onSubmitConfirm="EWD.page.confirmText='"_$$zcvt^%zewdCompiler(confirmText)_"' ; EWD.ajax.confirmSubmit(EWD.page.confirmText)"
	. ;
	. s n=n+1
	. s name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. s action=$$getAttributeValue^%zewdDOM("action",1,nodeOID)
	. i $e(action,1,5)="&php;" d
	. . s action=$p(action,"&php;",2)
	. . s action=$g(phpVars(action))
	. . s action=$$stripSpaces^%zewdAPI(action)
	. i $e(action,1,7)'="##class",action'["^",$e(action,1)'="$",$g(routineName)'="" s action=action_"^"_routineName
	. i $e(action,1)="$" s action=action_"($ewd_session)"
	. s nextpage=$$getAttributeValue^%zewdDOM("nextpage",1,nodeOID)
	. s nextpageRaw=nextpage
	. i nextpage="" s nextpage=$g(pageName)
	. i nextpage[".ewd" s nextpage=$p(nextpage,".ewd",1)
	. i action'=""!(nextpageRaw'="") d
	. . n onclick,oceh,target,variableName
	. . s variableName=0
	. . i name["&php;" d
	. . . n nam,num
	. . . s name=$p(name,"&php;",1)
	. . . s variableName=1
	. . s formDeclarations(n)=name_"~"_action_"~"_nextpage
	. . i variableName s $p(formDeclarations(n),"~",5)="variable"
	. . d removeAttribute^%zewdAPI("action",nodeOID)
	. . d removeAttribute^%zewdAPI("nextpage",nodeOID)
	. . s onclick=$$getAttributeValue^%zewdDOM("onclick",1,nodeOID)
	. . s target=$$getAttributeValue^%zewdDOM("target",1,nodeOID)
	. . ;
	. . i $$zcvt^%zewdAPI(ajax,"l")="true" d
	. . . n formOID
	. . . s formOID=$$getParentForm^%zewdDOM(nodeOID)
	. . . i $$zcvt^%zewdAPI($$getAttribute^%zewdDOM("method",formOID),"l")="uploadfile" d
	. . . . s target="zewdResponseFrame"
	. . ;
	. . d removeAttribute^%zewdAPI("target",nodeOID)
	. . s dojoType=$$getAttribute^%zewdDOM("dojoType",nodeOID)
	. . i dojoType="dijit.form.Button" d  q
	. . . n formOID
	. . . s oceh=$$getAttribute^%zewdDOM("onclick",nodeOID)
	. . . s formOID=$$getFormTag^%zewdDOM(nodeOID)
	. . . s formId=$$getAttribute^%zewdDOM("id",formOID)
	. . . s onclick=oceh
	. . . i target'="" s onclick=oceh_" document.getElementById('"_formId_"').target='"_target_"'" 
	. . . i onSubmitConfirm'="" s onclick=onclick_" ; "_onSubmitConfirm
	. . . d setAttribute^%zewdDOM("onclick",onclick,nodeOID)
	. . s oceh="this.form.ewd_action.value=this.name ; this.form.ewd_pressed.value=this.name"
	. . i target'="" s oceh=oceh_" ; this.form.target='"_target_"'"
	. . i onclick'="" d
	. . . ;s onclick=onclick_" ; "
	. . . d removeAttribute^%zewdAPI("onclick",nodeOID)
	. . ;s onclick=onclick_oceh
	. . i onclick'="" s oceh=oceh_" ; "_onclick
	. . s onclick=oceh
	. . i onSubmitConfirm'="" s onclick=onclick_" ; "_onSubmitConfirm
	. . d setAttribute^%zewdDOM("onclick",onclick,nodeOID)
	. s nameList=$$getFormFields^%zewdCompiler3(nodeOID)
	. s $p(formDeclarations(n),"~",4)=nameList
	. ;
	. i $$zcvt^%zewdAPI(ajax,"l")="true" d
	. . n attr,eventpost,eventpre,formOID,id,iwdAlertTitle,iwdTransition,jsParams,onclick
	. . n synch,thisForm,thisName,trace,url
	. . ;   <input type="submit" name="save" class="viewButton" value="Save" nextpage="adminCodingSystems" 
	. . ;    action="saveCodeSystem^qmEMPIewd2" ajax="true" targetID="contentColumn" />
	. . d setAttribute^%zewdDOM("type","button",nodeOID)
	. . s id=$$getAttributeValue^%zewdDOM("targetid",1,nodeOID)
	. . s synch=$$getAttributeValue^%zewdDOM("synchronous",1,nodeOID)
	. . i synch'="true" s synch=""
	. . i synch="true" s synch=",true"
	. . s trace=$$getAttributeValue^%zewdDOM("trace",1,nodeOID)
	. . i trace="window" s traceSet=1
	. . s onclick=$$getAttributeValue^%zewdDOM("onclick",1,nodeOID)
	. . set eventpre=$$getAttributeValue^%zewdDOM("eventpre",1,nodeOID)
	. . set eventpost=$$getAttributeValue^%zewdDOM("eventpost",1,nodeOID)
	. . i onclick'="" s onclick=onclick_" ; "
	. . i eventpre'="" s onclick=eventpre_" ; "_onclick
	. . set url=$$expandPageName^%zewdCompiler8(pageName,.nextPageList,.urlNameList,technology,.jsParams)
	. . i dojoType="dijit.form.Button" d
	. . . s thisName="'"_$$getAttribute^%zewdDOM("name",nodeOID)_"'"
	. . . s thisForm="document.getElementById('"_formId_"')"
	. . e  d
	. . . s thisName="this.name"
	. . . s thisForm="this.form"
	. . set iwdTransition=$$getAttributeValue^%zewdDOM("iwdtransition",1,nodeOID)
	. . set iwdAlertTitle=$$getAttributeValue^%zewdDOM("iwdalerttitle",1,nodeOID)
	. . i iwdTransition'="" d
	. . . n reverse
	. . . s reverse="false"
	. . . i iwdTransition["reverse" d
	. . . . s reverse="true"
	. . . . s iwdTransition=$p(iwdTransition,"reverse",1)
	. . . s onclick=onclick_"document.getElementById('iWDAlertFrame').style.display='block';document.getElementById('loading').className='loadingOn';"
	. . . s onclick=onclick_"iWD.currentFragmentName='"_pageName_"';iWD.submitPressed=this;this.parentNode.className='submitPressed';"
	. . . ;s onclick=onclick_"document.getElementById('cover').className='cover';"
	. . . s onclick=onclick_"iWD.createNewPage('"_id_"');iWD.target={'panelId':'#"_id_"','transition':'"_iwdTransition_"','reverse':"_reverse_"};"
	. . . s id=id_"-content-body"
	. . i iwdAlertTitle'="" d
	. . . s onclick=onclick_"iWD.alertTitle='"_iwdAlertTitle_"';"
	. . s onclick=onclick_"EWD.ajax.submit("_thisName_","_thisForm_",'"_nextpage_"','"_url_"','"_id_"','"_trace_"'"_synch_") ;"
	. . i eventpost'="" s onclick=onclick_eventpost
	. . d setAttribute^%zewdDOM("onClick",onclick,nodeOID)
	. . for attr="targetid","iwdtransition","ajax","trace","eventpre","eventpost","onclick" d
	. . . do removeAttribute^%zewdAPI(attr,nodeOID,1)
	. ;
	d createPHPFormHeader^%zewdCompiler3(.formDeclarations,.phpHeaderArray,technology,.dataTypeList,.config,pageName)
	QUIT traceSet
	;
ajax(docName,technology,idList)
	;
	n changed,docOID,fcOID,file,filePath,fileSig,files,jsText,jsTextOID,language,ntags,nodeOID
	n OIDArray,olOID,oOID,pageType,%p1,%p2,%p3,%p4,setOID,src
	;
	; clear down any ExtJS action script pages
	;
	s nodeOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	s pageType=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("pagetype",1,nodeOID),"l")
	;
	s isAjax=0
	i pageType="ajax" d
	. n scriptOID,text
	. s isAjax=1
	. s docOID=$$getDocumentNode^%zewdDOM(docName)
	. s oOID=$$insertNewIntermediateElement^%zewdDOM(docOID,"ewd:if",docOID)
	. do setAttribute^%zewdDOM("firstvalue","$Error",oOID)
	. do setAttribute^%zewdDOM("operation","=",oOID)
	. do setAttribute^%zewdDOM("secondvalue","",oOID)
	. s text=" i $g(sessid)="""" s sessid=""unknown"""
	. set scriptOID=$$addCSPServerScript^%zewdCompiler4(docOID,text)
	. s olOID=$$getTagOID^%zewdCompiler("ewd:ajaxonload",docName)
	. i olOID="" d
	. . s olOID=$$addElementToDOM^%zewdDOM("ewd:ajaxonload",docOID,,,)
	. s olOID=$$removeChild^%zewdAPI(olOID)
	. s olOID=$$insertBefore^%zewdDOM(olOID,oOID)
	. ;
	. s fcOID=$$getFirstChild^%zewdDOM(oOID)
	. d
	. . n text,textOID
	. . s setOID=$$createElement^%zewdDOM("ewd:idlist",docOID)
	. . s setOID=$$insertBefore^%zewdDOM(setOID,fcOID)
	. . s text=" k ^%zewdSession(""session"",""ewd_idList"",sessid)"_$c(13,10)
	. . s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. . s textOID=$$appendChild^%zewdDOM(textOID,setOID)
	;
	set ntags=$$getTagsByName^%zewdCompiler("script",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. set language=$$getAttributeValue^%zewdDOM("language",1,nodeOID)
	. i language="" s language="javascript"
	. quit:$$zcvt^%zewdAPI(language,"L")'["javascript"
	. set src=$$getAttributeValue^%zewdDOM("src",1,nodeOID)
	. q:src'=""
	. s jsTextOID=""
	. f  s jsTextOID=$$getNextChild^%zewdAPI(nodeOID,jsTextOID) q:jsTextOID=""  d
	. . s jsText=$$getData^%zewdDOM(jsTextOID)
	. . s changed=0
	. . f  q:jsText'["ewd.getJSON("  d
	. . . s %p1=$p(jsText,"ewd.getJSON(",1)
	. . . s %p2=$p(jsText,"ewd.getJSON(",2,2000)
	. . . s %p3=$p(%p2,")",1),%p4=$p(%p2,")",2,2000)
	. . . s varNo=$o(phpVars(""),-1)+1
	. . . s phpVars(varNo)=%p3
	. . . s jsText=%p1_"eval('&php;"_varNo_"&php;')"_%p4
	. . . s changed=1
	. . i changed s jsTextOID=$$modifyTextData^%zewdDOM(jsText,jsTextOID)
	QUIT
	;
	s nodeOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	s pageType=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("pagetype",1,nodeOID),"l")
	;
	i pageType="ajax" d
	. n attr,docOID,nodeOID,procInsOID,respOID,target
	. s docOID=$$getDocumentNode^%zewdDOM(docName)
	. s nodeOID=$$getFirstChild^%zewdDOM(docOID)
	. s nodeOID=$$getNextSibling^%zewdDOM(nodeOID)
	. s nodeOID=$$insertNewParentElement^%zewdDOM(nodeOID,"ewdAjaxPayload",docOID)
	. s target="xml",data="version='1.0'"
	. s procInsOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
	. s procInsOID=$$insertBefore^%zewdDOM(procInsOID,nodeOID)
	. s attr("name")="Content-type"
	. s attr("value")="text/html"
	. s respOID=$$addElementToDOM^%zewdDOM("ewd:zresponseheader",nodeOID,,.attr,"")
	. s attr("name")="Expires"
	. s attr("suppress")="true"
	. s respOID=$$addElementToDOM^%zewdDOM("ewd:zresponseheader",nodeOID,,.attr,"")
	QUIT
	;
payload(docName,mode,technology)
	;
	; the <ewd:responsePayload> tag is simply an outer tag placeholder that gets removed 
	; at the end of page processing
	;
	n nodeOID
	;
	s nodeOID=$$getTagOID^%zewdCompiler("ewd:responsepayload",docName)
	i nodeOID'="" d removeIntermediateNode^%zewdCompiler4(nodeOID) i technology="php" QUIT "collapse"
	QUIT mode
	;
ajaxPage(allArray,docOID,jsOID,nextPageList,urlNameList,technology)
	;
	; Process AJAX page directives
	;
	new ajaxPageName,attr,eh,ehx,ehy,ehz,event,found,jsName,jsParams
	n lineNo,nodeOID,nodeType,targetID,trace,traceSet,url
	;
	set nodeOID="",found=0,traceSet=0
	for  set nodeOID=$order(allArray(0,nodeOID)) quit:nodeOID=""  do
	. ;
	. ; ajaxPage="myAjaxPage.ewd" event="OnClick" targetID="dataColumn"
	. ; 
	. set nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. if nodeType'=1 quit
	. set ajaxPageName=$$getAttributeValue^%zewdDOM("ajaxpage",1,nodeOID)
	. if ajaxPageName="" quit
	. ;
	. set found=1
	. set event=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("event",1,nodeOID),"l")
	. if event="" set event="onclick"
	. set targetID=$$getAttributeValue^%zewdDOM("targetid",1,nodeOID)
	. i event="onload"!(event="ontimer") s targetID=$$getAttributeValue^%zewdDOM("id",1,nodeOID)
	. set trace=$$getAttributeValue^%zewdDOM("trace",1,nodeOID)
	. i trace="window" s traceSet=1
	. set ehx=$$getAttributeValue^%zewdDOM(event,1,nodeOID)
	. set ehy=$$getAttributeValue^%zewdDOM("onclickpre",1,nodeOID)
	. set ehz=$$getAttributeValue^%zewdDOM("onclickpost",1,nodeOID)
	. i ehy="",ehz="" d
	. . set ehy=$$getAttributeValue^%zewdDOM("eventpre",1,nodeOID)
	. . set ehz=$$getAttributeValue^%zewdDOM("eventpost",1,nodeOID)
	. for attr="ajaxpage","event","targetid","trace","onclickpre","onclickpost","eventpre","eventpost" d
	. . ;do removeAttribute^%zewdAPI(attr,nodeOID,1)
	. ;
	. set url=$$expandPageName^%zewdCompiler8(ajaxPageName,.nextPageList,.urlNameList,technology,.jsParams)
	. ;
	. set eh="EWD.ajax.makeRequest('"_url_"','"_targetID_"','get','','"_trace_"'"
	. set jsName=""
	. for  set jsName=$order(jsParams(jsName)) quit:jsName=""  do
	. . set eh=eh_","_jsParams(jsName)
	. set eh=eh_")"
	. if ehx'="" set eh=eh_" ; "_ehx
	. if ehz'="" set eh=eh_" ; "_ehz
	. if ehy'="" set eh=ehy_" ; "_eh
	. i event="onload",$$getTagName^%zewdDOM(nodeOID)'="body" d
	. . n bodyOID,docName,jsText,onload,scriptOID
	. . s docName=$$getDocumentName^%zewdDOM(docOID)
	. . i '$$javascriptObjectExists^%zewdCompiler13("EWD.ajax.load",docName) d
	. . . s jsText(1)="EWD.ajax.load = function () {"
	. . . s jsText(2)="                  "_eh_" ;"
	. . . s jsText(3)="                };"
	. . . s scriptOID=$$addJavascriptObject^%zewdCompiler13(docName,.jsText)
	. . . s bodyOID=$$getTagOID^%zewdCompiler("body",docName)
	. . . s onload=$$getAttributeValue^%zewdDOM("onload",1,bodyOID)
	. . . i onload'["EWD.ajax.load()" s onload="EWD.ajax.load() ;"_onload
	. . . do setAttribute^%zewdDOM("onload",onload,bodyOID)
	. . e  d
	. . . s jsText=$$getJavascriptObjectBody^%zewdCompiler13("EWD.ajax.load",docName)
	. . . s jsText=jsText_$c(13,10)_"  "_eh_" ;"
	. . . s ok=$$replaceJavascriptObjectBody^%zewdCompiler13("EWD.ajax.load",jsText,docName)
	. e  i event="ontimer" d
	. . n bodyOID,docName,jsText,onload,scriptOID,time
	. . s docName=$$getDocumentName^%zewdDOM(docOID)
	. . set time=$$getAttributeValue^%zewdDOM("time",1,nodeOID)
	. . do removeAttribute^%zewdAPI("time",nodeOID,1)
	. . i '$$javascriptObjectExists^%zewdCompiler13("EWD.ajax.refreshInit",docName) d
	. . . n attr,headOID,jsOID,jsText,line,lineNo,scriptOID,scriptText,xtra
	. . . set jsName="",xtra=""
	. . . for  set jsName=$order(jsParams(jsName)) quit:jsName=""  do
	. . . . set xtra=xtra_","_jsParams(jsName)
	. . . s jsText(1)="EWD.ajax.refresh = function () {"
	. . . s jsText(2)="                     EWD.ajax.runFunc(1,"_time_","""_url_""","""_targetID_""""_xtra_") ; "
	. . . s jsText(3)="                   }"
	. . . s scriptOID=$$addJavascriptObject^%zewdCompiler13(docName,.jsText)
	. . . s scriptText=""
	. . . f lineNo=1:1 s line=$t(ajaxTimer+lineNo^%zewdCompiler14) q:line["***END***"  d
	. . . . s scriptText=scriptText_$p(line,";;",2,255)_$c(13,10)
	. . . s headOID=$$getTagOID^%zewdAPI("head",docName)
    . . . s attr("language")="javascript"
	. . . s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,scriptText)
	. . e  d
	. . . n jsText,line,np,ok,p1
	. . . ; ajax.refreshInit function found!
	. . . s jsText=$$getJavascriptObjectBody^%zewdCompiler13("EWD.ajax.refreshInit",docName)
	. . . s np=$l(jsText,$c(13,10))
	. . . s line=$p(jsText,$c(13,10),np)
	. . . s p1=$p(line,"[",2)
	. . . s p1=p1+1
	. . . s jsText=jsText_$c(13,10)_"  EWD.ajax.counter["_p1_"] = 0 ; "
	. . . s ok=$$replaceJavascriptObjectBody^%zewdCompiler13("EWD.ajax.refreshInit",jsText,docName)
	. . . s jsText=$$getJavascriptObjectBody^%zewdCompiler13("EWD.ajax.refresh",docName)
	. . . s jsText=jsText_$c(13,10)_"  EWD.ajax.runFunc("_p1_","_time_","""_url_""","""_targetID_""") ; "
	. . . s ok=$$replaceJavascriptObjectBody^%zewdCompiler13("EWD.ajax.refresh",jsText,docName)
	. . . ;
	. e  d
	. . do setAttribute^%zewdDOM(event,eh,nodeOID)
	;
	QUIT traceSet
	;
ajaxJS(docName,config,idList,traceSet,technology) ;
 ;
 n docOID,idListOID
 ;
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 i $g(traceSet)=1 d createTraceDiv^%zewdCompiler16(docName)
 ;
 ; process idlist event broker coding
 ;
 s idListOID=$$getTagOID^%zewdCompiler("ewd:idlist",docName)
 i '$d(idList) d
 . s idListOID=$$removeChild^%zewdAPI(idListOID,1)
 e  d
 . n code,setOID,textOID,textArray
 . s code=$$getElementValueByOID^%zewdDOM(idListOID,"jsTextArray","")
 . s setOID=$$createElement^%zewdDOM("script",docOID)
 . s setOID=$$insertBefore^%zewdDOM(setOID,idListOID)
 . d setAttribute^%zewdDOM("language","cache",setOID)
 . d setAttribute^%zewdDOM("runat","server",setOID)
 . s textOID=$$createTextNode^%zewdDOM(code,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,setOID)
 . s idListOID=$$removeChild^%zewdAPI(idListOID,1)
 ;
 QUIT:$g(config("pageType"))'="ajax"
 ;
 n allJSText,attr,childOID,docOID,divOID,id,jsText,jsTextArray,nodeOID,nScripts
 n OIDArray,ok,scriptOID,textArray,textOID
 ;
 s nextPageList("ewdAjaxError")=""
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 s nScripts=$$getTagsByName^%zewdCompiler("script",docName,.OIDArray)
 s nodeOID=""
 f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
 . q:$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("language",0,nodeOID),"l")'="javascript"
 . s jsText=$$getElementValueByOID^%zewdDOM(nodeOID,"jsTextArray","")
 . i jsText="***Array***" d
 . . m allJSText(nodeOID)=jsTextArray
 . e  d
 . . s allJSText(nodeOID,1)=jsText
 . s ok=$$removeChild^%zewdAPI(nodeOID,1)
 ;
 i $d(allJSText) d
 . n lineNo,m2JSOID,text
 . s scriptOID=$$getElementById^%zewdDOM("ewdscript",docOID)
 . i scriptOID="" d
 . . s divOID=$$insertNewIntermediateElement^%zewdDOM(docOID,"span",docOID)
 . . s attr("id")="ewdscript"
 . . s attr("style")="visibility : hidden"
 . . s scriptOID=$$addElementToDOM^%zewdDOM("pre",divOID,,.attr,,) ; ***
 . s m2JSOID=$$getElementById^%zewdDOM("moveToJS",docOID)
 . i m2JSOID'="" d
 . . n childNo,fcOID,OIDArray
 . . d getChildrenInOrder^%zewdDOM(m2JSOID,.OIDArray)
 . . s childNo=""
 . . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . . s fcOID=OIDArray(childNo)
 . . . ;s fcOID=$$getFirstChild^%zewdDOM(m2JSOID)
 . . . s fcOID=$$removeChild^%zewdDOM(fcOID)
 . . . s fcOID=$$appendChild^%zewdDOM(fcOID,scriptOID)
 . . d removeIntermediateNode^%zewdDOM(m2JSOID)
 . s nodeOID=""
 . f  s nodeOID=$o(allJSText(nodeOID)) q:nodeOID=""  d
 . . s lineNo=""
 . . f  s lineNo=$o(allJSText(nodeOID,lineNo)) q:lineNo=""  d
 . . . s text=allJSText(nodeOID,lineNo)
 . . . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . . . s textOID=$$appendChild^%zewdDOM(textOID,scriptOID) 
 ;
 QUIT
 ;
getJSScriptsPathMode(technology)
	;
	; mode = fixed|relative
	;
	QUIT $g(^zewd("config","jsScriptPath",technology,"mode"))
	;
setJSScriptsPathMode(technology,mode)
	;
	s ^zewd("config","jsScriptPath",technology,"mode")=mode
	QUIT
	;
getJSScriptsRootPath(technology)
	;
	QUIT $g(^zewd("config","jsScriptPath",technology,"path"))
	;
setJSScriptsRootPath(technology,path)
	;
	s ^zewd("config","jsScriptPath",technology,"path")=path
	QUIT
	;
getJSScriptsPath(app,technology)
	;
	n dlim,mode,path
	;
	s mode=$$getJSScriptsPathMode(technology)
	i mode="" QUIT ""
	i mode="fixed" QUIT $$getJSScriptsRootPath(technology)
	;
	s dlim="/"
	s path=$$getJSScriptsRootPath(technology)
	i path'="",$e(path,$l(path))'=dlim s path=path_dlim
	QUIT path_app
	;
addStyle(label,docOID)
	;
	n docName,i,line,no,styleCodeOID,styleOID,styleText,text,x
	; 
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s styleOID=$$getTagOID^%zewdCompiler("style",docName)
	i styleOID="" d
	. n atr,headOID
	. s headOID=$$getTagOID^%zewdCompiler("head",docName)
	. s attr("type")="text/css"
	. s styleOID=$$addElementToDOM^%zewdDOM("style",headOID,,.attr,"")
	s styleCodeOID=$$getFirstChild^%zewdDOM(styleOID)
	i styleCodeOID="" d
	. s styleText=""
	e  d
	. s styleText=$$getData^%zewdDOM(styleCodeOID)
	;
	; now add the new function and update the text node in the DOM
	;
	s no=2 i label="ajaxErrorClasses" s no=9
	s x="s line=$t("_label_"+i^%zewdCompiler"_no_")"
	f i=1:1 x x q:line["***END***"  d
	. s text=$p(line,";;",2,255)
	. i $e(text,1)="*",$e(text,2,4)'=technology q
	. s text=$$replaceAll^%zewdHTMLParser(text,("*"_technology_"*"),"     ")
	. s styleText=styleText_$c(13,10)_text
	i styleCodeOID'="" d  QUIT
	. s styleCodeOID=$$modifyTextData^%zewdDOM(styleText,styleCodeOID)
	s styleCodeOID=$$createTextNode^%zewdDOM(styleText,docOID)
	s styleCodeOID=$$appendChild^%zewdDOM(styleCodeOID,styleOID)
	QUIT
	;
addAjaxErrorDiv(docOID)
	;
	n attr,bodyOID,bOID,brOID,divOID,docName,errorOID
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s bodyOID=$$getTagOID^%zewdCompiler("body",docName)
	s attr("class")="ewdDispOff"
	s attr("id")="ewdAjaxError"
	s divOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"")
	s brOID=$$addElementToDOM^%zewdDOM("br",divOID,,,"")
	s bOID=$$addElementToDOM^%zewdDOM("b",divOID,,,"An error has occurred:")
	s brOID=$$addElementToDOM^%zewdDOM("br",divOID,,,"")
	s attr("id")="ajaxErrorText"
	s errorOID=$$addElementToDOM^%zewdDOM("div",divOID,,.attr,"Error text goes here")
	s brOID=$$addElementToDOM^%zewdDOM("br",divOID,,,"")
	s brOID=$$addElementToDOM^%zewdDOM("br",divOID,,,"")
	s attr("onClick")="EWD.ajax.errorOff()"
	s attr("type")="button"
	s attr("value")="&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;"
	s errorOID=$$addElementToDOM^%zewdDOM("input",divOID,,.attr,"")
	s brOID=$$addElementToDOM^%zewdDOM("br",divOID,,,"")
	;
	QUIT
	;
addAjaxErrorPage(inputPath,files)
	;
	n fileName,filePath,io,line,lineNo,x
	;
	q:'$d(files)
	s io=$io
	f fileName="ewdAjaxError","ewdErrorRedirect","ewdAjaxErrorRedirect" d
	. s filePath=inputPath_fileName_".ewd"
	. i '$$openNewFile^%zewdCompiler(filePath) QUIT
	. u filePath
	. f lineNo=1:1 s x="s line=$t("_fileName_"+lineNo^%zewdCompiler14)" x x q:line["***END***"  d
	. . w $p(line,";;",2,1000),!
	. c filePath
	. u io
	. s files(fileName_".ewd")=""
	QUIT
	;
ajaxOnload(nodeOID,attrValues,docOID,technology)
	;
	n attr,childOID,jsoID,obj,oldtext,text
	;
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	s oldtext=""
	i childOID'="" s oldtext=$$getData^%zewdDOM(childOID)
	s text=""
	s text=text_" var ewdtext='#($$jsEscape^%zewdGTMRuntime(Error))#' ;"
	s text=text_" if (ewdtext != '') {"
	s text=text_"    if (ewdtext.substring(0,11) == 'javascript:') {"
	s text=text_"       ewdtext=ewdtext.substring(11) ;"
	s text=text_"       eval(ewdtext) ;"
	s text=text_"    }"
	s text=text_"    else {"
	s text=text_"       EWD.ajax.alert('#($$htmlEscape^%zewdGTMRuntime($$jsEscape^%zewdGTMRuntime(Error)))#')"
	s text=text_"    }"
	s obj="^%zewdSession(""session"","
	s text=text_$c(13,10)_"<script language=""cache"" runat=""server"">"_$c(13,10)
	s text=text_" s id="""""_$c(13,10)
    s text=text_" f  s id=$o("_obj_"""ewd_idList"",id)) q:id=""""  d"_$c(13,10)
    s text=text_" . w ""idPointer = document.getElementById('""_id_""') ; """_$c(13,10)
    s text=text_" . w ""if (idPointer != null) idPointer.className='""_$g("_obj_"""ewd_idList""))_""' ; """_$c(13,10)
	s text=text_" s id="""""_$c(13,10)
    s text=text_" f  s id=$o("_obj_"""ewd_errorFields"",id)) q:id=""""  d"_$c(13,10)
    s text=text_" . w ""idPointer = document.getElementById('""_id_""') ; """_$c(13,10)
    s text=text_" . w ""if (idPointer != null) idPointer.className='""_$g("_obj_"""ewd_errorClass""))_""' ; """_$c(13,10)
    s text=text_" k "_obj_"""ewd_hasErrors"")"_$c(13,10)
    s text=text_" k "_obj_"""ewd_errorFields"")"_$c(13,10)
    s text=text_" k "_obj_"""ewd_idList"")"_$c(13,10)
	s text=text_"</script>"_$c(13,10)
	s text=text_" }"
	i $$stripSpaces^%zewdAPI(oldtext)'="" d
	. s text=text_" else {"
	. s text=text_oldtext
	. s text=text_" }"
	s attr("id")="ewdajaxonload"
	s jsOID=$$addElementToDOM^%zewdDOM("span",docOID,,.attr,text)
	;
	d removeIntermediateNodeeXtc^%zewdAPI(nodeOID,1)
	i childOID'="" d removeIntermediateNodeeXtc^%zewdAPI(childOID,1)
	;
	QUIT
	;
inputStar(docName,technology,config,idList) ;
	;
	; Find all <input> tags and substitute any occurrences of value="*"
	;
	n %c,class,dojoType,i,id,name,np,ntags,OIDArray,nodeOID,%p1,%p1r,%p2,%p3
	n p1,p2,p3,scriptOID,type,value
	; 
	s ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. s value=$$getAttributeValue^%zewdDOM("value",1,nodeOID)
	. s name=$$getAttributeValue^%zewdDOM("name",0,nodeOID)
	. s type=$$getAttributeValue^%zewdDOM("type",1,nodeOID)
	. s class=$$getAttributeValue^%zewdDOM("class",1,nodeOID)
	. s dojoType=$$getAttributeValue^%zewdDOM("dojotype",1,nodeOID)
	. i dojoType'="" d dojoType^%zewdCompiler17(dojoType,docOID)
	. i $$zcvt^%zewdAPI(type,"l")'="radio",$$zcvt^%zewdAPI(type,"l")'="checkbox" d
	. . s id=$$getAttributeValue^%zewdDOM("id",1,nodeOID)
	. . i id="",name="" s name="ewdUnnamed"_$p(nodeOID,"-",2)
	. . i id="" d
	. . . d setAttribute^%zewdDOM("id",name,nodeOID)
	. . . s id=name
	. . . i $$zcvt^%zewdAPI(type,"l")="button" q
	. . . s idList(name)=class
	. . e  d
	. . . i id'="",name="" d
	. . . . d setAttribute^%zewdDOM("name",id,nodeOID) 
	. . . . i $$zcvt^%zewdAPI(type,"l")="button" q
	. . . . s idList(id)=class
	. . i $g(config("pageType"))="ajax",(($$zcvt^%zewdAPI(type,"l")="text")!($$zcvt^%zewdAPI(type,"l")="password")) d
	. . . n docOID,scriptOID,text,textOID
	. . . s docOID=$$getDocumentNode^%zewdDOM(docName)
	. . . set scriptOID=$$createElement^%zewdDOM("script",docOID)
	. . . do setAttribute^%zewdDOM("language","cache",scriptOID)
	. . . do setAttribute^%zewdDOM("runat","server",scriptOID)
	. . . set scriptOID=$$insertBefore^%zewdDOM(scriptOID,nodeOID)
	. . . ;
 	. . . i id'["&php;" d
	. . . . s id=""""_id_""""
	. . . e  d
	. . . . f  q:id'["&php;"  d
	. . . . . s p1=$p(id,"&php;",1),p2=$p(id,"&php;",2),p3=$p(id,"&php;",3,2000)
	. . . . . s p2=$$stripSpaces^%zewdAPI(p2)
	. . . . . s p2=$g(phpVars(p2))
	. . . . . s p2=$$stripSpaces^%zewdAPI(p2)
	. . . . . i $e(p1,$l(p1)-2,$l(p1))="_" s p1=$e(p1,1,$l(p1)-3)
	. . . . . i $e(p1,1)'="$",$e(p1,1)'="""" s p1=""""_p1_""""
	. . . . . i $e(p2,1)'="$",$e(p2,1)'="""" s p2=""""_p2_""""
	. . . . . s id=p1_"_"_p2
	. . . . . i p1="""""" s id=p2
	. . . . . i p3'="" s id=id_"_"_p3
	. . . . s np=$l(id,"_")
	. . . . f i=1:1:np d
	. . . . . s p1=$p(id,"_",i)
	. . . . . i $e(p1,1)'="""",$e(p1,1)'="$" s $p(id,"_",i)=""""_p1_""""
	. . . s id=$$replaceAll^%zewdAPI(id,"_$","_")
	. . . ;
	. . . s text=" s idList("_id_")="""_class_""""_$c(13,10)
	. . . s text=text_" d mergeArrayToSession^%zewdAPI(.idList,""ewd_idList"",sessid)"_$c(13,10)
	. . . set textOID=$$createTextNode^%zewdDOM(text,docOID)
	. . . set textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
	. q:value'="*"
	. s type=$$zcvt^%zewdAPI(type,"l")
	. i type'="text",type'="hidden",type'="password",type'="tel",type'="number" q
	. i $g(config("escapeText"))="false" d
	. . s value="#($$getSessionValue^%zewdAPI("""_name_""",sessid))#"
	. . f  q:value'["&php;"  d
	. . . n p1,p2,p3
	. . . s p1=$p(value,"&php;",1)
	. . . s p2=$p(value,"&php;",2)
	. . . s p2=$$stripSpaces^%zewdAPI($g(phpVars(p2)))
	. . . s p2=$p(p2,"$",2)
	. . . s p3=$p(value,"&php;",3,200)
	. . . s value=p1_"""_"_p2_"_"""_p3
	. e  s value="#($$normaliseTextValue^%zewdAPI($$getSessionValue^%zewdAPI("""_name_""",sessid)))#"
	. d setAttribute^%zewdDOM("value",value,nodeOID)
	QUIT
	;
createPHPMenuOptionHeader(menuOptions,phpHeaderArray,technology,docName)
 ;
 ; menuOptions(groupName,n)=text~nextpage~defaultSelected~greyIfFunction~help~staticLink
 ;
 n bodyOID,gn,greyif,help,lineNo,nOptions,np,scriptOID,selectedNo,text
 ;
 set text="   k %ewdVar(""$ewd_menuOption"") d deleteFromSession^%zewdAPI(""ewd_menuOption"",sessid)"_$char(13,10)
 ;
 s gn=""
 f  s gn=$o(menuOptions(gn)) q:gn=""  d
 . s nOptions=0,np="",selectedNo=0
 . for  set np=$order(menuOptions(gn,np)) quit:np=""  do
 . . set nOptions=nOptions+1
 . . set text=text_"   s %ewdVar(""$ewd_menuOption"","""_gn_""","""_np_""",""text"") = """_$piece(menuOptions(gn,np),$char(1),1)_""""_$char(13,10)
 . . set text=text_"   s %ewdVar(""$ewd_menuOption"","""_gn_""","""_np_""",""nextPage"") = """_$piece(menuOptions(gn,np),$char(1),2)_""""_$char(13,10)
 . . set text=text_"   s %ewdVar(""$ewd_menuOption"","""_gn_""","""_np_""",""class"") = """_$piece(menuOptions(gn,np),$char(1),6)_""""_$char(13,10)
 . . if selectedNo=0,$piece(menuOptions(gn,np),$char(1),3)=1 set selectedNo=np
 . . set greyIf=$piece(menuOptions(gn,np),$char(1),4)
 . . if greyIf'="" do
 . . . if $extract(greyIf,$l(greyIf))'=")" set greyIf=greyIf_"()"
 . . . i $e(greyIf,1,2)'="$$",$e(greyIf,1,2)'="##" s greyIf="$$"_greyIf 
 . . . set text=text_"   s ^%zewdSession(""session"",""ewd_menuOption"","""_gn_""","""_np_""") = "_greyIf_$char(13,10)
 . . set text=text_"   s %ewdVar(""$ewd_menuOption"","""_gn_""","""_np_""",""help"") = """_$piece(menuOptions(gn,np),$char(1),5)_""""_$char(13,10)
 . set text=text_"   s %ewdVar(""$noOfOptions"","""_gn_""")="_nOptions_$char(13,10)
 . set text=text_"   i '$d(%ewdVar(""$ewd_menuOptionSelected"","""_gn_""")) s %ewdVar(""$ewd_menuOptionSelected"","""_gn_""")="_selectedNo_$char(13,10)
 . set bodyOID=$$getTagOID^%zewdCompiler("head",docName)
 . set scriptOID=$$addCSPServerScript^%zewdCompiler4(bodyOID,text)
 ;
 QUIT
 ;
addVBHeaderPreCache(string)
 ;
 n lineNo
 s lineNo=$o(phpHeaderArray(2,""),-1)+1
 s phpHeaderArray(2,lineNo)=string
 QUIT
 ;
addPHPHeaderPreCache(string)
 ;
 n lineNo
 s lineNo=$o(phpHeaderArray(4.1,""),-1)+1
 i lineNo=1 d
 . s phpHeaderArray(4.1,1)="   $ewdTabMenu = array() ;"
 . s lineNo=2
 s phpHeaderArray(4.1,lineNo)=string
 QUIT
 ;
addJSPHeaderPreCache(string)
 ;
 n lineNo
 s lineNo=$o(phpHeaderArray(4.1,""),-1)+1
 s phpHeaderArray(4.1,lineNo)=string
 QUIT
