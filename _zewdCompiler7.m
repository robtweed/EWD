%zewdCompiler7	; Enterprise Web Developer Compiler Functions
 ;
 ; Product: Enterprise Web Developer (Build 835)
 ; Build Date: Wed, 05 Jan 2011 11:13:34
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
eventBroker(allArray,docOID,jsOID,phpHeaderArray,filename,docName,routineName,nextPageList,formDeclaration,technology,mgwsiServer,backend) ;
	;
	; Find all ewd:func() calls
	; 
	; First in onXXX attributes
	; 
	n attr,attrName,attrOID,attrValue,%changed,dlim,docName,eventName,eventNo
	n headOID,i,%id,initialEventNo,jsText,jsTextArray,jsTextOID,language,length,line,method,newText
	n nnmOID,nodeOID,nodeType,%np,ntags,%nvp,OIDArray,olOID,%p1,%p2,%p2a,%p2b,%p3,%p4,%p5
	n page,paramList,tagName,%trace,src,%url,value
	;
	s nodeOID="",eventNo=$o(formDeclaration(""),-1),initialEventNo=eventNo
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. i nodeType'=1 q
	. q:$$hasAttributes^%zewdDOM(nodeOID)="false"
	. s tagName=$$getTagName^%zewdDOM(nodeOID)
	. s nnmOID=$$getAttributes^%zewdCompiler(nodeOID,.attr)
	. s attrName=""
	. f  s attrName=$o(attr(attrName)) q:attrName=""  d
	. . q:$e(attrName,1,2)'="on"
	. . s attrOID=attr(attrName)
	. . s attrValue=$$getValue^%zewdDOM(attrOID)
	. . i $e(attrValue,1,13)="EWD.page.goNextPage" d goNextPage^%zewdCompiler(attrName,attrValue,nodeOID) q
	. . i $$zcvt^%zewdAPI(attrValue,"L")["ewdjump" d  q
	. . . s attrValue=$$convertSubstringCase^%zewdHTMLParser(attrValue,"ewdjump","L")
	. . . s %p1=$p(attrValue,"ewdjump",1)
	. . . s %p2=$p(attrValue,"ewdjump",2)
	. . . s page=$$getAttributeValue^%zewdDOM("page",1,nodeOID)
	. . . s value="EWD.page.goNextPage('"_page_"',<?= $tokens("""_page_""") ?>','<?= sessionArray(""ewd_token"") ?>')"
	. . . s attrValue=%p1_value_%p2
	. . . d setAttribute^%zewdDOM(attrName,attrValue,nodeOID)
	. . . d removeAttribute^%zewdAPI("page",nodeOID)
	. . . s nextPageList(page)=""
	. . q:$e(attrValue,1,4)'="ewd:"
    . . d parseEventBrokerCall(attrValue)
	;
	;  Now look in all JavaScript functions
	;  
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s ntags=$$getTagsByName^%zewdCompiler("script",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. s language=$$getAttributeValue^%zewdDOM("language",1,nodeOID)
	. i language="" s language="javascript"
	. q:$$zcvt^%zewdAPI(language,"L")'["javascript"
	. s src=$$getAttributeValue^%zewdDOM("src",1,nodeOID)
	. q:src'=""
	. s jsTextOID=""
	. f  s jsTextOID=$$getNextChild^%zewdAPI(nodeOID,jsTextOID) q:jsTextOID=""  d
	. . s jsText=$$getData^%zewdDOM(jsTextOID)
	. . ;
	. . ; remove any ewd:comment text from within the JavaScript
	. . ;
	. . s %changed=0
	. . i jsText["*/ewd:comment" d
	. . . s %p1=$p(jsText,"*/ewd:comment",1)
	. . . i %p1'["/*ewd:comment" s jsText=$p(jsText,"*/ewd:comment",2,2000)
	. . f  q:jsText'["/*ewd:comment"  d
	. . . s %p1=$p(jsText,"/*ewd:comment",1)
	. . . s %p2=$p(jsText,"*/ewd:comment",2,2000)
	. . . i %p1=$c(13,10) s %p1=""
	. . . i %p1=$c(10) s %p1=""
	. . . i $e(%p2,1,2)=$c(13,10) s %p2=$e(%p2,3,$l(%p2))
	. . . i $e(%p2,1)=$c(10) s %p2=$e(%p2,2,$l(%p2))
	. . . s jsText=%p1_%p2
	. . . s %changed=1
	. . i %changed s jsTextOID=$$modifyTextData^%zewdDOM(jsText,jsTextOID)
	. . ;
	. . i $l(jsText)>2000 d
	. . . n dlim,jsText1,jsText2,np,p1,textOID
	. . . s jsText1=$e(jsText,1,2000)
	. . . s jsText2=$e(jsText,(2000+1),$l(jsText))
	. . . i $$os^%zewdHTMLParser()="windows" s dlim=$c(13,10)
	. . . e  s dlim=$c(10)
	. . . s np=$l(jsText2,dlim)
	. . . s p1=$p(jsText2,dlim,1)
	. . . s jsText2=$p(jsText2,dlim,2,np)
	. . . s jsText1=jsText1_p1_dlim
	. . . s jsTextOID=$$modifyTextData^%zewdDOM(jsText1,jsTextOID)
	. . . s textOID=$$createTextNode^%zewdDOM(jsText2,docOID)
	. . . i $$getNextChild^%zewdAPI(nodeOID,jsTextOID)="" d
	. . . . s textOID=$$appendChild^%zewdDOM(textOID,nodeOID)
	. . . e  d
	. . . . n nextChildOID
	. . . . s nextChildOID=$$getNextChild^%zewdAPI(nodeOID,jsTextOID)
	. . . . i $$insertBefore^%zewdDOM(textOID,nextChildOID)
	. . . s jsText=jsText1
	. . ;
	. . f  q:jsText'["ewd:"  d
	. . . k %p1,%p2,%p2a,%p2b,%p3
	. . . s %p1=$p(jsText,"ewd:",1)
	. . . s %p2=$p(jsText,"ewd:",2,2000)
	. . . s %p2a=$p(%p2,"(",1)
	. . . i %p2'["class(" d  ; extrinsic
	. . . . s method=%p2a
	. . . . s %p2b=$p(%p2,"(",2,2000)
	. . . . s paramList=$p(%p2b,")",1)
	. . . . s %p2=$p(%p2b,")",2,2000)
	. . . e  d  ; class method
	. . . . s method=$p(%p2,"(",1,2)
	. . . . i $e(method,1,2)'="##" s method="##"_method
	. . . . s %p2a=$p(%p2,"(",3,2000)
	. . . . s paramList=$p(%p2a,")",1)
	. . . . s %p2=$p(%p2a,")",2,2000)
	. . . s dlim=") ;" i paramList'[") ;",paramList[");" s dlim=");"
	. . . s eventNo=eventNo+1
	. . . s eventName="eventU"_$$zcvt^%zewdAPI($p(filename,".",1),"L")_"U"_eventNo
	. . . d
	. . . . n ebCall,nline,nparams,paramString,pval
	. . . . s nline=$o(phpHeaderArray(2,""),-1)+1
	. . . . s phpHeaderArray(2,nline)=" s ebToken("""_method_""")=$$createEBToken^%zewdGTMRuntime("""_method_""",.sessionArray)"
	. . . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalls",$$zcvt^%zewdAPI(pageName,"l"),method)="eventBroker"
	. . . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalledBy",method,$$zcvt^%zewdAPI(pageName,"l"))="eventBroker"
	. . . . ;
	. . . . s nparams=$length(paramList,",")
	. . . . s paramString=""
	. . . . i paramList'="" d
	. . . . . i nparams>0 for i=1:1:nparams do
	. . . . . . s pval=$p(paramList,",",i)
	. . . . . . i $e(pval,1)="""" d
	. . . . . . . set paramString=paramString_"&px"_i_"="_$$zcvt^%zewdAPI($p(paramList,",",i),"O","URL")
	. . . . . . e  d
	. . . . . . . s paramString=paramString_"&px"_i_"=' + "_pval_" + '"
	. . . . s ebCall="EWD.ajax.makeRequest('#($$getRootURL^%zewdCompiler(""gtm""))#ewdeb/eb.mgwsi?ewd_token=#($$getSessionValue^%zewdAPI(""ewd_token"",sessid))#&eb=#(ebToken("""_method_"""))#"_paramString_"','','synch','','')"
	. . . . s jsText=%p1_ebCall_%p2
	. . . . s jsTextOID=$$modifyTextData^%zewdDOM(jsText,jsTextOID)
	. . ;
	. . ; Now expand any ewd.ajaxRequest functions
	. . ;
	. . k %changed,%id,%np,%nvp,%p1,%p2,%p3,%p4,%trace,%url
	. . ;
	. . s %changed=0
	. . s jsText=$$getData^%zewdDOM(jsTextOID)
	. . f  q:jsText'["ewd.ajaxRequest("  d
	. . . s %p1=$p(jsText,"ewd.ajaxRequest(",1)
	. . . s %p2=$p(jsText,"ewd.ajaxRequest(",2,2000)
	. . . s %p3=$p(%p2,")",1),%p4=$p(%p2,")",2,2000)
	. . . s %np=$p(%p3,",",1)
	. . . s %id=$p(%p3,",",2) i %id="" s %id=""""""
	. . . s %nvp=$p(%p3,",",3)
	. . . s %trace=$p(%p3,",",4)
	. . . s %trace=$$removeQuotes^%zewdAPI(%trace)
	. . . s %trace=$$zcvt^%zewdAPI(%trace,"l")
	. . . i %trace'="",%trace'="alert",%trace'="window" s %trace=""
	. . . i %trace="window" d createTraceDiv^%zewdCompiler16(docName)
	. . . s %np=$$removeQuotes^%zewdAPI(%np)
	. . . s %url=$$expandPageName^%zewdCompiler8(%np,.nextPageList,.urlNameList,technology,.jsParams)
	. . . i %nvp="" d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'get','','"_%trace_"')"
	. . . e  i $e(%nvp,1)="""" d
	. . . . s %url=%url_"&"_$$removeQuotes^%zewdAPI(%nvp)
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'get','','"_%trace_"')"
	. . . e  d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"&' + "_%nvp_","_%id_",'get','','"_%trace_"')"
	. . . s jsText=%p1_%p5_%p4
	. . . s %changed=1
	. . f  q:jsText'["ewd.ajaxSynchRequest("  d
	. . . s %p1=$p(jsText,"ewd.ajaxSynchRequest(",1)
	. . . s %p2=$p(jsText,"ewd.ajaxSynchRequest(",2,2000)
	. . . s %p3=$p(%p2,")",1),%p4=$p(%p2,")",2,2000)
	. . . s %np=$p(%p3,",",1)
	. . . s %id=$p(%p3,",",2) i %id="" s %id=""""""
	. . . s %nvp=$p(%p3,",",3)
	. . . s %trace=$p(%p3,",",4)
	. . . s %trace=$$removeQuotes^%zewdAPI(%trace)
	. . . s %trace=$$zcvt^%zewdAPI(%trace,"l")
	. . . i %trace'="",%trace'="alert",%trace'="window" s %trace=""
	. . . i %trace="window" d createTraceDiv^%zewdCompiler16(docName)
	. . . s %np=$$removeQuotes^%zewdAPI(%np)
	. . . ;s %id=$$removeQuotes^%zewdAPI(%id)
	. . . s %url=$$expandPageName^%zewdCompiler8(%np,.nextPageList,.urlNameList,technology,.jsParams)
	. . . i %nvp="" d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'synch','','"_%trace_"')"
	. . . e  i $e(%nvp,1)="""" d
	. . . . s %url=%url_"&"_$$removeQuotes^%zewdAPI(%nvp)
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'synch','','"_%trace_"')"
	. . . e  d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"&' + "_%nvp_","_%id_",'synch','','"_%trace_"')"
	. . . s jsText=%p1_%p5_%p4
	. . . s %changed=1
	. . i %changed set jsTextOID=$$modifyTextData^%zewdDOM(jsText,jsTextOID)
	s olOID=$$getTagByNameAndAttr^%zewdCompiler3("span","id","ewdajaxonload",0,docName)
	i olOID'="" d
	. n %changed,%id,lineNo,%np,%nvp,%p1,%p2,%p3,%p4,%p5,textArray,%trace,%url
	. s jsText=$$getElementValueByOID^%zewdDOM(olOID,"jsTextArray",1)
	. i jsText'="***Array***" s jsTextArray(1)=jsText
	. s lineNo=""
	. f  s lineNo=$o(jsTextArray(lineNo)) q:lineNo=""  d
	. . s jsText=jsTextArray(lineNo)
	. . i jsText'["ewd.ajaxRequest",jsText'["ewd.ajaxSynchRequest" q
	. . d removeChildTextNodes^%zewdDOM(olOID)
	. . f  q:jsText'["ewd.ajaxRequest"  d
	. . . s %p1=$p(jsText,"ewd.ajaxRequest(",1)
	. . . s %p2=$p(jsText,"ewd.ajaxRequest(",2,2000)
	. . . s %p3=$p(%p2,")",1),%p4=$p(%p2,")",2,2000)
	. . . s %np=$p(%p3,",",1)
	. . . s %id=$p(%p3,",",2) i %id="" s %id=""""""
	. . . s %nvp=$p(%p3,",",3)
	. . . s %trace=$p(%p3,",",4)
	. . . s %trace=$$zcvt^%zewdAPI(%trace,"l")
	. . . s %trace=$$removeQuotes^%zewdAPI(%trace)
	. . . i %trace'="",%trace'="alert",%trace'="window" s %trace=""
	. . . s %np=$$removeQuotes^%zewdAPI(%np)
	. . . s %url=$$expandPageName^%zewdCompiler8(%np,.nextPageList,.urlNameList,technology,.jsParams)
	. . . i %nvp="" d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'get','','"_%trace_"')"
	. . . e  i $e(%nvp,1)="""" d
	. . . . s %url=%url_"&"_$$removeQuotes^%zewdAPI(%nvp)
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'get','','"_%trace_"')"
	. . . e  d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"&' + "_%nvp_","_%id_",'get','','"_%trace_"')"
	. . . s jsText=%p1_%p5_%p4
	. . . s %changed=1
	. . f  q:jsText'["ewd.ajaxSynchRequest"  d
	. . . s %p1=$p(jsText,"ewd.ajaxSynchRequest(",1)
	. . . s %p2=$p(jsText,"ewd.ajaxSynchRequest(",2,2000)
	. . . s %p3=$p(%p2,")",1),%p4=$p(%p2,")",2,2000)
	. . . s %np=$p(%p3,",",1)
	. . . s %id=$p(%p3,",",2) i %id="" s %id=""""""
	. . . s %nvp=$p(%p3,",",3)
	. . . s %trace=$p(%p3,",",4)
	. . . s %trace=$$zcvt^%zewdAPI(%trace,"l")
	. . . s %trace=$$removeQuotes^%zewdAPI(%trace)
	. . . i %trace'="",%trace'="alert",%trace'="window" s %trace=""
	. . . s %np=$$removeQuotes^%zewdAPI(%np)
	. . . s %url=$$expandPageName^%zewdCompiler8(%np,.nextPageList,.urlNameList,technology,.jsParams)
	. . . i %nvp="" d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'synch','','"_%trace_"')"
	. . . e  i $e(%nvp,1)="""" d
	. . . . s %url=%url_"&"_$$removeQuotes^%zewdAPI(%nvp)
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"',"_%id_",'synch','','"_%trace_"')"
	. . . e  d
	. . . . s %p5="EWD.ajax.makeRequest('"_%url_"&' + "_%nvp_","_%id_",'synch','','"_%trace_"')"
	. . . s jsText=%p1_%p5_%p4
	. . . s %changed=1
	. . i %changed s jsTextOID=$$addTextToElement^%zewdDOM(olOID,jsText)
	;
	q:eventNo=initialEventNo
	QUIT
	;
	; now add the <applet> call to the page
	;
	new attr,appletOID,divOID
	;<div style="visibility:hidden">
	set nodeOID=$$getTagOID^%zewdCompiler("body",docName)
	;
	set attr("style")="visibility:hidden"
	set divOID=$$addElementToDOM^%zewdDOM("div",nodeOID,,.attr,"")
	;
	set attr("name")="m_php"
	set attr("codebase")="/"
	set attr("code")="m_php.class"
	set attr("width")=2
	set attr("height")=2
	set appletOID=$$addElementToDOM^%zewdDOM("applet",divOID,,.attr,"")
	;
	QUIT
	;
getJSText(label,technology)
 	;
 	n i,jsText,line,text,x
 	;
 	s jsText=""
	s x="s line=$T("_label_"+i^%zewdCompiler2)"
	f i=1:1 x x q:line["***END***"  d
	. s text=$p(line,";;",2,255)
	. i $e(text,1)="*",$e(text,2,4)'=technology q
	. s text=$$replaceAll^%zewdHTMLParser(text,("*"_technology_"*"),"     ")
	. s jsText=jsText_$c(13,10)_text
	QUIT jsText
	;
parseEventBrokerCall(ebCall)
 ;
 n char,method,p1,p2,p3,p4,paramList,paramName,params,pos,quit,quoteSingle
 n quoteDouble,x1,x2,x3,xtra
 ;
 s p1=$p(ebCall,"ewd:",1)
 s p2=$p(ebCall,"ewd:",2,300)
 f  q:p2'["&php;"  d
 . s x1=$p(p2,"&php;",1)
 . s x2=$p(p2,"&php;",2)
 . s x3=$p(p2,"&php;",3,500)
 . s x2=$g(phpVars(x2))
 . s p2=x1_"<?="_x2_" ?>"_x3
 s p3=$p(p2,";",1)
 s p4=$p(p2,";",2,255)
 s method=$$stripSpaces^%zewdAPI(p3)
 s xtra=$$stripSpaces^%zewdAPI(p4)
 i method["class(" d
 . s paramList=$p(method,"(",3,999)
 . s method=$p(method,"(",1,2)
 . i $e(method,1,2)'="##" s method="##"_method
 e  d
 . s paramList=$p(method,"(",2,999)
 . s method=$p(method,"(",1)
 s (params,quoteSingle,quoteDouble,quit)=0,paramName=""
 f pos=1:1 s char=$e(paramList,pos) q:char=""  d  q:quit
 . i char="'" d
 . . if quoteSingle,'quoteDouble s quoteSingle=0 w:'$f("|,|)|","|"_$e(paramList,pos+1)) !!,"Error parsing EWD page: ",filename,!?3,"Event broker call: ",ebCall
 . . e  s quoteSingle=1
 . e  i char="""" d
 . . i quoteDouble,'quoteSingle s quoteDouble=0 s quoteSingle=0 w:'$f("|,|)|","|"_$e(paramList,pos+1)) !!,"Error parsing page: ",filename,!?3,"Event broker call: ",ebCall
 . . e  s quoteDouble=1
 . e  i char=",",'quoteSingle,'quoteDouble s char="",quit=1
 . e  i char=")",'quoteSingle,'quoteDouble s char="",quit=2
 . i quit s:paramName'="" params($increment(params))=paramName_char,paramName="",(quoteSingle,quoteDouble)=0,quit=quit-1 q
 . s paramName=paramName_char
 s paramList=""
 f pos=1:1:params s paramList=paramList_$s(pos>1:",",1:"")_params(pos)
 s eventNo=eventNo+1
 s eventName="eventU"_$$zcvt^%zewdAPI($p(filename,".",1),"L")_"U"_eventNo
 d
 . n nline,nparams,paramString,pval
 . s nline=$o(phpHeaderArray(2,""),-1)+1
 . s phpHeaderArray(2,nline)=" s ebToken("""_method_""")=$$createEBToken^%zewdWLD("""_method_""",.sessionArray)"
 . ;
 . s nparams=$l(paramList,",")
 . s paramString=""
 . i paramList'="" d
 .. i nparams>0 f i=1:1:nparams d
 ... s pval=$p(paramList,",",i)
 ... i $e(pval,1)="""" d
 .... s paramString=paramString_"&px"_i_"="_$$zcvt^%zewdAPI($p(paramList,",",i),"O","URL")
 ... e  d
 .... s paramString=paramString_"&px"_i_"=' + "_pval_" + '"
 . s ebCall="EWD.ajax.makeRequest('#($$getRootURL^%zewdCompiler(""gtm""))#ewdeb/eb.mgwsi?ewd_token=#($$getSessionValue^%zewdAPI(""ewd_token"",sessid))#&eb=#(ebToken("""_method_"""))#"_paramString_"','','get','','')"
 . d setAttribute^%zewdDOM(attrName,ebCall,nodeOID)
  QUIT
 ;
spanTags(docName,technology,multilingual,inputPath,textidList) ;
	; 
	n appendOnclick,appName,attr,bodyOID,childOID,confirm,confirmText
	n divOID,dlim,docOID,event,formOID,headOID,hiddenForms
	n inputOID,jsArray,jsCount,jsNodeOID,jsOID,language,n,name
	n nextpage,nodeOID,ntags,nvp,nvpCount,nvpStr,OIDArray,onclick
	n pageName,popup,pos,spanCounter,%stop,styleOID,submitOID,text
	n textOID,v,value
	;
	s spanCounter=0
	s appName=inputPath
	s dlim=$$getDelim^%zewdCompiler()
	s appName=$p(appName,$$getApplicationRootPath^%zewdCompiler(),2)
	s appName=$p(appName,dlim,2)
	; 
	s docOID=$$getDocumentNode^%zewdDOM(docName)
	s ntags=$$getTagsByName^%zewdCompiler("span",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. k nvp
	. s popup=$$getAttributeValue^%zewdDOM("popup",1,nodeOID)
	. q:popup'=""
	. s nextpage=$$getAttributeValue^%zewdDOM("nextpage",1,nodeOID)
	. q:nextpage=""
	. i $e(nextpage,1)="$" d  q
	. . s event=$$getAttributeValue^%zewdDOM("event",1,nodeOID)
	. . s:event="" event="onclick"
	. . s onclick=$$getAttributeValue^%zewdDOM(event,1,nodeOID)
	. . i onclick'="" s onclick=onclick_" ; "
	. . d
	. . . n parentOID,scriptOID
	. . . s scriptOID=$$createElement^%zewdDOM("script",docOID)
	. . . d setAttribute^%zewdDOM("language","cache",scriptOID)
	. . . d setAttribute^%zewdDOM("runat","server",scriptOID)
	. . . s scriptOID=$$insertBefore^%zewdDOM(scriptOID,nodeOID)
	. . . s text=" s url=..Link("_$extract(nextpage,2,$length(nextpage))_"_"".csp"")"_$char(13,10)
	. . . s text=text_" s click=""document.location='""_url_""'"""
	. . . s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. . . s textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
	. . . s onclick=onclick_"#(click)#"
	. . d setAttribute^%zewdDOM("onclick",onclick,nodeOID)
	. . d removeAttribute^%zewdAPI("nextpage",nodeOID)
	. ;
	. s name="span"_$increment(spanCounter)
	. s pageName=$p(nextpage,"?",1)
	. s pageName=$p(pageName,".ewd",1)
	. s nvp=$p(nextpage,"?",2,255)
	. i nvp'=""  d
	. . s nvp=$$replaceAll^%zewdHTMLParser(nvp,"&php;",$c(1))
	. . s nvpCount=$l(nvp,"&")
	. . f pos=1:1:nvpCount d
	. . . s nvpStr=$p(nvp,"&",pos)
	. . . s n=$p(nvpStr,"=",1)
	. . . s v=$p(nvpStr,"=",2)
	. . . s v=$$replaceAll^%zewdHTMLParser(v,$c(1),"&php;")
	. . . s v=$$replaceVars^%zewdHTMLParser(v,.cspVars,.phpVars,technology)
	. . . s nvp(n)=v
	. ;
	. i '$d(hiddenForms("form",name)) d
	. . k attr ; Attribute Array!
	. . s attr("type")="text/css"
	. . s text="#hiddenForm {visibility: hidden ;}"
	. . s headOID=$$getTagOID^%zewdCompiler("head",docName)
	. . s styleOID=$$addElementToDOM^%zewdDOM("style",headOID,,.attr,text)
	. . k jsArray
	. . s jsCount=$$getTagsByName^%zewdCompiler("script",docName,.jsArray)
	. . s jsNodeOID="",%stop=0
	. . f  s jsNodeOID=$o(jsArray(jsNodeOID)) q:jsNodeOID=""  d  q:%stop
	. . . s language=$$getAttributeValue^%zewdDOM("language",1,jsNodeOID)
	. . . q:$$zcvt^%zewdAPI(language,"L")'["javascript"
	. . . q:$$getFirstChild^%zewdDOM(jsNodeOID)=""
	. . . s %stop=1
	. . ;
	. . s jsOID=jsNodeOID
	. . i jsOID="" d
	. . . k attr
	. . . s attr("language")="javascript"
	. . . s jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,"")
	. . s childOID=$$getFirstChild^%zewdDOM(jsOID)
	. . s text=$$getData^%zewdDOM(childOID)
	. . ;
	. . s text=text_$c(13,10)_"function ewdNP"_name_"("
	. . i $o(nvp(""))="" s text=text_" "
	. . s n=""
	. . f  s n=$o(nvp(n)) q:n=""  s text=text_n_","
	. . s text=$e(text,1,$l(text)-1)_$s($o(nvp(""))="":"",1:",")_"confirmText) {"_$c(13,10)
	. . s n=""
	. . f  s n=$o(nvp(n)) q:n=""  s text=text_"  document.ewdNP"_name_"Form."_n_".value = "_n_" ;"_$c(13,10)
	. . s text=text_"  document.ewdNP"_name_"Form.ewd_action.value='"_name_"submit' ;"_$c(13,10) 
	. . s text=text_"  document.ewdNP"_name_"Form.ewd_pressed.value='"_name_"submit' ;"_$c(13,10)
    . . s text=text_"  if ((confirmText != null) && (confirmText != ''))"_$c(13,10)
    . . s text=text_"     {"_$c(13,10)
	. . s text=text_"        confirmText = EWD.utils.replace(confirmText,""&#39;"",""'"") ;"_$c(13,10)
	. . s text=text_"        confirmText = EWD.utils.replace(confirmText,'&#34;','""') ;"_$c(13,10)
	. . s text=text_"        ok=confirm(confirmText) ;"_$c(13,10)
	. . s text=text_"        if (ok) document.ewdNP"_name_"Form.submit() ;"_$c(13,10)
    . . s text=text_"     }"_$c(13,10)
    . . s text=text_"  else"_$c(13,10)
	. . s text=text_"     document.ewdNP"_name_"Form.submit() ;"_$c(13,10)
	. . s text=text_"}"
	. . s textOID=$$modifyTextData^%zewdDOM(text,childOID)
	. s confirm=$$getAttributeValue^%zewdDOM("confirm",1,nodeOID)
	. s confirmText=$$getAttributeValue^%zewdDOM("confirmtext",1,nodeOID)
	. i confirmText'="",multilingual d
	. . n attrOID,containsVars,event,outputText,text,textid
	. . s event=$$getAttributeValue^%zewdDOM("event",1,nodeOID)
	. . s attrOID=$$getAttributeNode^%zewdDOM(event,nodeOID)
	. . i attrOID="" d setAttribute^%zewdDOM(event,"",nodeOID) s attrOID=$$getAttributeNode^%zewdDOM(event,nodeOID)
	. . s textid=$$encodeValue^%zewdCompiler5(confirmText,attrOID,appName,pageName,.text,.textidList,technology,.containsVars,.outputText)
	. . i textid="" q
	. . i 'containsVars d  q
	. . . s confirmText="#($$displayText^%zewdAPI("""_textid_""",0,"""_technology_"""))#"
	. . . i multilingual=1 s confirmText="#($$displayText^%zewdAPI("""_textid_""",1,"""_technology_"""))#"
	. . ;
	. . ; contains variables
	. . ;
	. . s confirmText=text
	. e  d
	. . s:confirmText["'" confirmText=$$replaceAll^%zewdHTMLParser(confirmText,"'","\&#39;")
	. . s:confirmText["""" confirmText=$$replaceAll^%zewdHTMLParser(confirmText,"""","\&#34;")
	. ;
	. s event=$$getAttributeValue^%zewdDOM("event",1,nodeOID)
	. s:event="" event="onClick"
	. s onclick=$$getAttributeValue^%zewdDOM(event,1,nodeOID)
	. i onclick'="" s onclick=onclick_" ; "
	. s onclick=onclick_"ewdNP"_name_"("
	. i $o(nvp(""))="" s onclick=onclick_" "
	. s n=""
	. f  s n=$o(nvp(n)) q:n=""  d
	. . s v=nvp(n)
	. . i v["document." d  q
	. . . s onclick=onclick_v_","
	. . i $$zcvt^%zewdAPI($e(v,1,11),"l")="javascript." d  q
	. . . s v=$e(v,12,$l(v))
	. . . s onclick=onclick_v_","
	. . if $e(v,1)="$"!($e(v,1)="#") d
	. . . i $e(v,1)="$" d
	. . . . s v=$e(v,2,$l(v))
	. . . e  d
	. . . . i $e(v,1)="#" s v="$$getSessionValue^%zewdAPI("""_$e(v,2,$l(v))_""",sessid)"
	. . . s onclick=onclick_"'#("_v_")#',"
	. . e  d
	. . . s onclick=onclick_"'"_v_"',"
    . s onclick=$e(onclick,1,$l(onclick)-1)
	. s onclick=onclick_$s($o(nvp(""))="":"",1:",")_"'"_confirmText_"')"
	. s appendOnclick=$$getAttributeValue^%zewdDOM("appendonclick",1,nodeOID)
	. i appendOnclick'="" d
	. . s onclick=onclick_" ; "_appendOnclick
	. . d removeAttribute^%zewdAPI("appendonclick",nodeOID)
	. d setAttribute^%zewdDOM(event,onclick,nodeOID)
	. d removeAttribute^%zewdAPI("nextpage",nodeOID)
	. d removeAttribute^%zewdAPI("event",nodeOID)
	. ;
	. i '$d(hiddenForms("form",name)) d
	. . k attr ; Attribute Array!
	. . s bodyOID=$$getTagOID^%zewdCompiler("body",docName)
	. . s attr("id")="hiddenForm"
	. . s divOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"")
	. . s attr("method")="post"
	. . s attr("action")="ewd"
	. . s attr("name")="ewdNP"_name_"Form"
	. . s formOID=$$addElementToDOM^%zewdDOM("form",divOID,,.attr,"")
	. . s n=""
	. . f  s n=$o(nvp(n)) quit:n=""  d
	. . . s attr("type")="hidden"
	. . . s attr("name")=n
	. . . s attr("value")=""
	. . . s inputOID=$$addElementToDOM^%zewdDOM("input",formOID,,.attr,"")
	. . k attr
	. . s attr("type")="submit"
	. . s attr("name")=name_"submit"
	. . s attr("value")="submit"
	. . s attr("nextpage")=pageName
	. . s submitOID=$$addElementToDOM^%zewdDOM("input",formOID,,.attr,"")
	. . s hiddenForms("form",name)=formOID
	. . s hiddenForms("form",name,"submitOID")=submitOID
	. ;
	. f attr="confirm","confirmtext","action" d
	. . s value=$$getAttributeValue^%zewdDOM(attr,1,nodeOID)
	. . i value'="" d
	. . . i attr="action" do setAttribute^%zewdDOM(attr,value,hiddenForms("form",name,"submitOID"))
	. . . d removeAttribute^%zewdAPI(attr,nodeOID)
	QUIT
	;
XSLFO(docName)	;
	;
	n appName,attr,dlim,headOID,nodeOID,npieces,os,prePageScript,scriptOID,text
	;
	s nodeOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	s prePageScript=$$getAttributeValue^%zewdDOM("prepagescript",1,nodeOID)
	set headOID=$$getTagOID^%zewdCompiler("body",docName)
	if headOID="" set headOID=$$getDocumentNode^%zewdDOM(docName)
	set attr("language")="cache"
	set attr("method")="OnPreHTTP"
	set attr("arguments")=""
	set attr("returntype")="%Library.Boolean"
	set text=" i $$"_prePageScript_"(0)"_$char(13,10)
	s text=text_" s xslfoFilename=""xslfo.txt"""_$c(13,10)
	s text=text_" o xslfoFilename:""NW"""_$c(13,10)
	s text=text_" u xslfoFilename"_$c(13,10)
	s text=text_" s quitStatus=1"_$c(13,10)
	set scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
	;
	set attr("language")="cache"
	set attr("method")="OnPostHTTP"
	set attr("arguments")=""
	set attr("returntype")="%Library.Boolean"
	s text=" c xslfoFilename"_$c(13,10)
	s text=text_" QUIT 1"_$c(13,10)
	set scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
	;
	s nodeOID=$$removeChild^%zewdAPI(nodeOID)
	set appName=inputPath
	set os=$$os^%zewdHTMLParser()
	if os="windows" set dlim="\"
	else  set dlim="/"
	if $extract(appName,$length(appName))=dlim set appName=$extract(appName,1,$length(appName)-1)
	set npieces=$length(appName,dlim)
	set appName=$piece(appName,dlim,npieces)
	set pageName=$piece(filename,".ewd",1)
	QUIT pageName
	;
pageIndex(app,filename,nextPageList) ;
 ;
 n nextPage,np
 ;
 s nextPage=""
 f  s nextPage=$o(nextPageList(nextPage)) q:nextPage=""  d
 . s np=$p(nextPage,"?",1)
 . q:np="*"
 . q:$e(np,1)="#"
 . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalls",$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"),$$zcvt^%zewdAPI(np,"l"))=""
 . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalledBy",$$zcvt^%zewdAPI(np,"l"),$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"))=""
 QUIT
 ;
getIndices(sessid)
 ;
 n app,dlim,os,pageCalledBy,pageCalls,path,scriptCalledBy,scriptCalls,tagCalls,tagCalledBy,xref
 ;
 s xref=$$getSessionValue^%zewdAPI("xref",sessid)
 i xref="" d
 . s xref="pageCalls"
 . d setSessionValue^%zewdAPI("xref",xref,sessid)
 ;
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 i dlim="\" s path=$tr(path,"/",dlim)
 s app=$p($re(path),dlim,1)
 i app="" s app=$p($re(path),dlim,2)
 s app=$re(app)
 d setSessionValue^%zewdAPI("app",app,sessid)
 s app=$$zcvt^%zewdAPI(app,"l")
 ;
 i $$getSessionValue^%zewdAPI("clearXRef",sessid)'=0 d
 . d clearSessionArray^%zewdAPI("pageCalls",sessid)
 . d clearSessionArray^%zewdAPI("pageCalledBy",sessid)
 . d clearSessionArray^%zewdAPI("scriptCalls",sessid)
 . d clearSessionArray^%zewdAPI("scriptCalledBy",sessid)
 . d clearSessionArray^%zewdAPI("tagCalls",sessid)
 . d clearSessionArray^%zewdAPI("tagCalledBy",sessid)
 ;
 i xref="pageCalls" d  QUIT ""
 . m pageCalls=^%zewdIndex(app,"pageCalls")
 . d mergeArrayToSession^%zewdAPI(.pageCalls,"pageCalls",sessid)
 ;
 i xref="pageCalledBy" d  QUIT ""
 . m pageCalledBy=^%zewdIndex(app,"pageCalledBy")
 . d mergeArrayToSession^%zewdAPI(.pageCalledBy,"pageCalledBy",sessid)
 ;
 i xref="scriptCalls" d  QUIT ""
 . m scriptCalls=^%zewdIndex(app,"scriptCalls")
 . d mergeArrayToSession^%zewdAPI(.scriptCalls,"scriptCalls",sessid)
 ;
 i xref="scriptCalledBy" d  QUIT ""
 . m scriptCalledBy=^%zewdIndex(app,"scriptCalledBy")
 . d mergeArrayToSession^%zewdAPI(.scriptCalledBy,"scriptCalledBy",sessid)
 ;
 i xref="tagCalls" d  QUIT ""
 . m tagCalls=^%zewdIndex(app,"tagCalls")
 . d mergeArrayToSession^%zewdAPI(.tagCalls,"tagCalls",sessid)
 ;
 i xref="tagCalledBy" d  QUIT ""
 . m tagCalledBy=^%zewdIndex(app,"tagCalledBy")
 . d mergeArrayToSession^%zewdAPI(.tagCalledBy,"tagCalledBy",sessid)
 ;
 QUIT ""
	;
	;
getProperty(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:getProperty sessionName="menuOption" param1="optionNo" propertyName="text" return="$text">
	; <ewd:getProperty localName="menuOption" param1="optionNo" propertyName="text" return="$text">
	; 
	n localName,param,propertyName,pval,return,sessionName,sname,subList,subListq,subs,subscripts
	;
	s param="param",subs=""
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. d
	. . i $e(pval,1)="""" s pval=$e(pval,2,$l(pval)-1) q
	. . i $e(pval,1)'="$" s pval="$"_pval
	. s subs=subs_pval_","
	s subscripts=$e(subs,1,$l(subs)-1)
	;
	s propertyName=$$getAttrValue^%zewdCompiler4("propertyName",.attrValues,technology)
	s sessionName=$$getAttrValue^%zewdCompiler4("sessionname",.attrValues,technology)
	s localName=$$getAttrValue^%zewdCompiler4("localname",.attrValues,technology)
	s localName=$$removeQuotes^%zewdAPI(localName)
	s return=$$getAttrValue^%zewdCompiler4("return",.attrValues,technology)
	s subList="",subListq=""
	i subscripts'="" d
	. n nsubs,i
	. s nsubs=$l(subscripts,",")
	. f i=1:1:nsubs d
	. . n sub
	. . s sub=$p(subscripts,",",i)
	. . i $e(sub,1)="$" d
	. . . s sub=$e(sub,2,$l(sub))
	. . . s subList=subList_","_sub
	. . . s subListq=subListq_","_sub
	. . e  d
	. . . s subList=subList_","""_sub_""""
	. . . s subListq=subListq_",&quot;"_sub_"&quot;"
	; 
	i $e(sessionName,1)="""" s sname="&quot;"_$e(sessionName,2,$l(sessionName)-1)_"&quot;"
	e  s sname=sessionName
	i sessionName'="""""" d
	. d
	. . n serverOID,text,useSessGlo
	. . s useSessGlo=+$g(^%zewd("config","csp","useSessionGlobal"))=1
	. . i technology="wl"!(technology="gtm") s useSessGlo=1
	. . i 'useSessGlo s text=" s "_return_"=%session.Data("_sname_subList_","_propertyName_")"
	. . i useSessGlo s text=" s "_return_"=^%zewdSession(""session"","_sname_subList_","_propertyName_")"
	. . s serverOID=$$addCSPServerScript^%zewdCompiler4(nodeOID,text)
	e  d
	. d
	. . n %p,serverOID,text
	. . s %p=localName_""""_subList
	. . i subList="" s %p=localName_"""" 
	. . s text=" s "_return_"=%ewdVar(""$"_%p_","_propertyName_")" 
	. . s serverOID=$$addCSPServerScript^%zewdCompiler4(nodeOID,text)
	;
	d removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
include(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:include file="myFile.inc">
	; 
	n filename
	;
	s filename=$$getAttrValue^%zewdCompiler4("file",.attrValues,technology)
	s filename=$$removeQuotes^%zewdAPI(filename)
	if filename'="" do
	. new %error,fcOID,incDocName,incDocOID,blockOID,newChildOID,ok,tagName,docOID,incOID
	. set incDocName="ewdInclude"
	. quit:$$zcvt^%zewdAPI(filename,"L")'[".inc"
	. set filename=inputPath_filename
	. set %error=$$parseFile^%zewdHTMLParser(filename,incDocName,,.phpVars,1)
	. if %error'="" QUIT
	. set incDocOID=$$getDocumentNode^%zewdDOM(incDocName)
	. set docOID=$$getDocumentNode^%zewdDOM(docName)
	. s fcOID=$$getFirstChild^%zewdDOM(incDocOID)
	. s tagName=$$getTagName^%zewdDOM(fcOID)
	. i tagName'="ewd:content" s fcOID=$$insertNewIntermediateElement^%zewdDOM(incDocOID,"ewd:content",incDocOID)
	. set incOID=$$getTagOID^%zewdCompiler("ewd:content",incDocName)
	. set blockOID=$$importNode^%zewdDOM(incOID,"true",docOID)
	. set newChildOID=$$appendChild^%zewdDOM(blockOID,nodeOID)
	. do removeIntermediateNode^%zewdCompiler4(newChildOID)
	. set ok=$$removeDocument^%zewdDOM(incDocName,0,0)
	;
	do removeIntermediateNode^%zewdCompiler4(nodeOID)
	;
	QUIT
	;
movetag(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:moveTag name="qm:tags" deleteOuterTag="true">
	; 
	n delete,docName,ntags,OIDArray,stop,tagName,tagOID
	;
	s tagName=$$getNormalAttributeValue^%zewdAPI("name",nodeOID,technology)
	s delete=$$getNormalAttributeValue^%zewdAPI("deleteoutertag",nodeOID,technology)
	s tagName=$$removeQuotes^%zewdAPI(tagName)
	s delete=$$removeQuotes^%zewdAPI(delete)
	i $$zcvt^%zewdAPI(delete,"l")="true" s delete=1
	e  s delete=0
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s ntags=$$getTagsByName^%zewdCompiler(tagName,docName,.OIDArray)
	s tagOID="",stop=0
	f  s tagOID=$o(OIDArray(tagOID)) q:tagOID=""  d  q:stop
	. i $$getParentNode^%zewdDOM(tagOID)'="" s stop=1
	s tagOID=$$removeChild^%zewdAPI(tagOID)
	s tagOID=$$appendChild^%zewdDOM(tagOID,nodeOID)
	i delete do removeIntermediateNode^%zewdCompiler4(tagOID)
	do removeIntermediateNode^%zewdCompiler4(nodeOID)
	QUIT
	;
testFindCustomTags
	;
	n docName,nodeOID
	s docName="ewd"
	s ok=$$openDOM^%eDOMAPI()
	d initialiseProcessedFlags
	f  s nodeOID=$$findFirstCustomTag(docName) q:nodeOID=""  d
	. w nodeOID," : ",$$getTagName^%eDOMAPI(nodeOID),!
	s ok=$$closeDOM^%eDOMAPI()
	QUIT
	;
initialiseProcessedFlags
	n j,n
	k ^CacheTempCTProcessed($j)
	; clear down any old records
	s j=""
	f  s j=$o(^CacheTempCTProcessed(j)) q:j=""  d
	. s n=""
	. f  s n=$o(^CacheTempCTProcessed(j,n)) q:n=""  d
	. . i ^CacheTempCTProcessed(j,n)<$h k ^CacheTempCTProcessed(j,n)
	QUIT
	;
setProcessedFlagOn(nodeOID)
 s ^CacheTempCTProcessed($j,nodeOID)=+$h
 QUIT
	;
setProcessedFlagOff(nodeOID)
 k ^CacheTempCTProcessed($j,nodeOID)
 QUIT
	;
findFirstCustomTag(docName)
 ;
 n docOID,nIncludes,nodeOID,OIDArray,stop
 ;
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 ;
 s nIncludes=$$getTagsByName^%zewdCompiler("ewd:include",docName,.OIDArray)
 s nodeOID="",stop=0
 f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  q:stop
 . i '$d(^CacheTempCTProcessed($j,nodeOID)) s stop=1
 i stop d setProcessedFlagOn(nodeOID) QUIT nodeOID
 ;
 s nodeOID=$$getFirstCustomTag(docOID,0)
 i nodeOID'="" d setProcessedFlagOn(nodeOID)
 QUIT nodeOID
 ;
getFirstCustomTag(parentOID,stop)
	;
	; recurses through all child node levels of parent node and 
	; returns them as a text string
	;
	n childOID,grandChildOID,tagName
	;
	s childOID=""
	for  set childOID=$$getNextChild^%zewdAPI(parentOID,childOID) quit:childOID=""  d  quit:stop
	. s tagName=$$getTagName^%zewdDOM(childOID)
	. q:tagName=""
	. i $d(^%zewd("customTag",tagName)),'$d(^CacheTempCTProcessed($j,childOID)) s stop=1 quit
	. s grandChildOID=$$getFirstCustomTag(childOID,.stop) i stop s childOID=grandChildOID quit
	QUIT childOID
 ;
processTag(tagName,attrList,procName,include,defFile,docName,technology,error)
	;processTag(tagName,procName,docName,technology,error)
	;
	n attr,attrName,attrValue,attrValues,docOID,func,i,lcAttrName
	n nAttr,nodeOID,ntags,OIDArray,ok,%p,page,x,%zt
	; 
	s error=""
	s docOID=$$getDocumentNode^%zewdDOM(docName)
	s ntags=$$getTagsByName^%zewdCompiler(tagName,docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  i error'="" QUIT
	. q:$$getParentNode^%zewdDOM(nodeOID)="" ; detached node
	. k attrValues
	. s nAttr=$l(attrList,",")
	. s ok=$$getAttributes^%zewdCompiler(nodeOID,.attr)
	. s attrName=""
	. f  s attrName=$o(attr(attrName)) q:attrName=""  d
	. . s attrValue=$$getNormalAttributeValue^%zewdAPI(attrName,nodeOID,technology)
	. . s attrValues($$zcvt^%zewdAPI(attrName,"l"))=attrValue
	. . s attrValues(attrName)=attrValue
	. ; the following is old mechanism compatibility code to prevent old custom tags breaking on null values
	. f i=1:1:nAttr d
	. . s attrName=$p(attrList,",",i)
	. . q:attrName=""
	. . s lcAttrName=$$zcvt^%zewdAPI(attrName,"l")
	. . s attrValue=$g(attrValues(lcAttrName))
	. . q:attrValue'=""
	. . s attrValue=""""""
	. . s attrValues($$zcvt^%zewdAPI(attrName,"l"))=attrValue
	. . s attrValues(attrName)=attrValue
	. i include'="" d
	. . n attr,incOID
	. . s attr("file")=include
	. . s incOID=$$addElementToDOM^%zewdDOM("ewd:include",nodeOID,,.attr,"")
	. . do removeIntermediateNode^%zewdCompiler4(nodeOID)
	. i defFile'="" d
	. . ; tag defined in definition file
	. . n blockOID,childOID,dlim,defDocName,dummyOID,eArray,eOID,%error
	. . n newChildOID,ntags,incOID,ipath,name,ok,opath,path,stop
	. . n cspVarsX,phpVarsX
	. . k cspVarsX,phpVarsX
	. . m cspVarsX=cspVars
	. . m phpVarsX=phpVars
	. . s path=$$getApplicationRootPath^%zewdAPI()
	. . s dlim=$$getDelim^%zewdCompiler()
	. . i $e(path,$l(path))'=dlim s path=path_dlim
	. . s ipath=path_defFile
	. . s defDocName="ewdDefFile"
	. . ;s ok=$$openDOM^%zewdAPI()
	. . s ok=$$removeDocument^%zewdDOM(defDocName,0,0)
	. . ;s ok=$$$closeDOM
	. . s %error=$$parseFile^%zewdHTMLParser(ipath,defDocName,.cspVarsX,.phpVarsX,1)
	. . s opath=path_"temp.txt"
	. . s ok=$$openNewFile^%zewdCompiler(opath) u opath
	. . ;o opath:"nw" u opath
	. . s tagNameX=tagName d outputDOM^%zewdHTMLParser(defDocName,"collapse",,.cspVarsX,.phpVarsX,1,technology)
	. . c opath
	. . ;s ok=$$openDOM^%zewdAPI()
	. . s ok=$$removeDocument^%zewdDOM(defDocName,0,0)
	. . s %error=$$parseFile^%zewdHTMLParser(opath,defDocName,.cspVars,.phpVars,1)
	. . s ok=$$deleteFile^%zewdHTMLParser(opath) ;break:tagName["vpitem"
	. . s dummyOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,"dummy",docOID)
	. . ;<ewd:tagdefinition name='qm:vpSection'>
	. . s ntags=$$getElementsArrayByTagName^%zewdDOM("ewd:tagdefinition",defDocName,,.eArray)
	. . s eOID="",stop=0
	. . f  s eOID=$o(eArray(eOID)) q:eOID=""  d  q:stop
	. . . s name=$$getAttribute^%zewdDOM("name",eOID)
	. . . s name=$$zcvt^%zewdAPI(name,"l")
	. . . i name=tagName s stop=1
	. . i 'stop q  ; definition not actually found!
	. . s incOID=$$getFirstElementByTagName^%zewdDOM("ewd:tagexpansion",,eOID)
	. . set blockOID=$$importNode^%zewdDOM(incOID,"true",docOID)
	. . set newChildOID=$$appendChild^%zewdDOM(blockOID,nodeOID)
	. . ;s childOID=$$getFirstElementByTagName^%eDOMAPI("ewd:children",docName) break
	. . k eArray
	. . s ntags=$$getElementsArrayByTagName^%zewdDOM("ewd:children",docName,,.eArray)
	. . s childOID="",stop=0
	. . f  s childOID=$o(eArray(childOID)) q:childOID=""  d  q:stop
	. . . i $$getParentNode^%zewdDOM(childOID)'="" s stop=1
	. . s dummyOID=$$removeChild^%zewdAPI(dummyOID)
	. . i $$hasChildNodes^%zewdDOM(dummyOID)="true" d
	. . . s dummyOID=$$appendChild^%zewdDOM(dummyOID,childOID)
	. . . do removeIntermediateNode^%zewdCompiler4(dummyOID)
	. . . do removeIntermediateNode^%zewdCompiler4(childOID)
	. . e  d
	. . . s ok=$$removeChild^%zewdAPI(childOID)
	. . do removeIntermediateNode^%zewdCompiler4(newChildOID)
	. . do removeIntermediateNode^%zewdCompiler4(nodeOID)
	. . set ok=$$removeDocument^%zewdDOM(defDocName,0,0)
	. . ;s ok=$$$closeDOM break
	. i include="",defFile="" d  i error'="" q
	. . i $$zcvt^%zewdAPI(procName,"l")["##class" d
	. . e  d
	. . . s x="d "_procName_"(nodeOID,.attrValues,docOID,technology)"
	. . . i $g(^zewd("trace"))=1,$e(tagName,1,4)'="ewd:",tagName'="textarea" d trace^%zewdAPI("Compiling custom tag "_tagName_": about to call "_x)
	. . . s %zt=$zt
	. . . ;s $zt="g processTagError"
	. . . x x
	. . . s $zt=%zt
	. s %p=$g(^%zewd("customTag",tagName))
	. s func=$p(%p,$c(1),1)
	. ;i func'="",func'["^%zewd" d
	. i func'["^%zewd" d
	. . n appName
	. . s appName=$$zcvt^%zewdAPI(subPath,"l")
	. . s appName=app
	. . s ^%zewdIndex(appName,"tagCalls",$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"),tagName)=""
	. . s ^%zewdIndex(appName,"tagCalledBy",tagName,$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"))=""
	. i tagName="ewd:include" s includeFound=1
	QUIT
	;
processTagError ;
	;
	i $g(%zt)'="" s $zt=%zt
	;s error="Error in custom tag processing of the <"_tagName_"> tag : "_procName_" not found in the "_$$namespace^%zewdAPI()_" namespace"
	s error="Error in custom tag processing of the <"_$g(tagName)_"> tag : "_$ze
	QUIT
	;
processTagErrorET ;
	;
	;s $etrap=""
	s $ecode=""
	s error="Error in custom tag processing of the <"_$g(tagName)_"> tag : "_$zerror
	QUIT error
	;
 ;
substitute(string,phpVars,technology)
 ;
 n p1,value
 s string=$$removeQuotes^%zewdAPI(string)
 s p1=$p(string,"&php;",2)
 s value=$$stripSpaces^%zewdAPI(p1)
 i $e(value,1)="$" s value=$e(value,2,$l(value))
 QUIT value
 ;
 ;===============================================================
 ;   Javascript functions
 ;===============================================================
 ;
javascriptFunctionExists(functionName,docName)
 ;
 QUIT $$getJavascriptFunction(functionName,docName)'=""
 ;
getJavascriptBlock(functionName,docName,textArr) ;
 ;
 n eArray,eOID,language,lineNo,ntags,OIDArray,refString,stop,text,textArray
 ;
 s text="",eOID="" k textArr
 s refString="function "_functionName
 s ntags=$$getElementsArrayByTagName^%zewdDOM("script",docName,,.eArray)
 s eOID="",stop=0
 f  s eOID=$o(eArray(eOID)) q:eOID=""  d  q:stop
 . s language=$$getAttribute^%zewdDOM("language",eOID)
 . q:language=""
 . q:$$zcvt^%zewdAPI(language,"l")'="javascript"
 . s text=$$getElementValueByOID^%zewdDOM(eOID,"textArr",1)
 . i '$d(textArr) s textArr(1)=text
 . s lineNo="",text=""
 . f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d  q:stop
 . . i textArr(lineNo)[refString s stop=1 q
 QUIT stop
 ;
removeJavascriptFunction(functionName,docName)
 QUIT $$replaceJavascriptFunction(functionName,"",docName)
 ;
replaceJavascriptFunction(functionName,newFunctionText,docName)
 ;
 n childOID,eOID,docOID,found,funcText,lineNo,stop,text,textArr,textOID
 ;
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 s found=$$getJavascriptBlock(functionName,docName,.textArr)
 i 'found QUIT 0
 ;
 s funcText=$$getJavascriptFunction(functionName,docName,.eOID)
 s lineNo="",stop=0
 f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d  q:stop
 . s text=textArr(lineNo)
 . i text[funcText s textArr(lineNo)=$$replace^%zewdAPI(text,funcText,newFunctionText),stop=1
 i 'stop QUIT 0
 f  q:$$hasChildNodes^%zewdDOM(eOID)="false"  d
 . s childOID=$$getFirstChild^%zewdDOM(eOID)
 . s childOID=$$removeChild^%zewdAPI(childOID)
 ;
 s lineNo=""
 f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d
 . s text=textArr(lineNo)
 . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,eOID)
 QUIT 1
 ;
getFirstJavascriptFunction(docName,textArr)
 ;
 n docOID,eArray,jsText,language,ntags,OIDArray,scriptOID,src,stop,textArray
 ;
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 s ntags=$$getElementsArrayByTagName^%zewdDOM("script",docName,,.eArray)
 s scriptOID="",stop=0
 f  s scriptOID=$o(eArray(scriptOID)) q:scriptOID=""  d  q:stop
 . s language=$$getAttribute^%zewdDOM("language",scriptOID)
 . q:language=""
 . q:$$zcvt^%zewdAPI(language,"l")'="javascript"
 . s src=$$getAttribute^%zewdDOM("src",scriptOID)
 . q:src'=""
 . s stop=1
 i scriptOID="" d
 . i 'isAjax d
 . . n attr,headOID
 . . s headOID=$$getFirstElementByTagName^%zewdDOM("head",docName,"")
 . . i headOID="" s headOID=$$addElementToDOM^%zewdDOM("head",docOID,,,,1)
 . . s attr("language")="javascript"
 . . s scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,"")
 . e  d
 . . s attr("language")="javascript"
 . . s scriptOID=$$addElementToDOM^%zewdDOM("script",docOID,,.attr,"")
 k textArr
 s jsText=$$getElementValueByOID^%zewdDOM(scriptOID,"textArr",1)
 i '$d(textArr) s textArr(1)=jsText
 QUIT scriptOID
 ;
addJavascriptFunction(docName,jsText)
 ;
 n childOID,lastLineNo,line,lineNo,OIDArray,scriptOID,text,textArr,textOID
 ;
 s scriptOID=$$getFirstJavascriptFunction(docName,.textArr)
 s lastLineNo=$o(textArr(""),-1)
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
 . s textArr(lastLineNo)=text
 . s text=jsText(lineNo)_$c(13,10)
 s lastLineNo=lastLineNo+1
 s textArr(lastLineNo)=text
 f  q:$$hasChildNodes^%zewdDOM(scriptOID)="false"  d
 . s childOID=$$getFirstChild^%zewdDOM(scriptOID)
 . s childOID=$$removeChild^%zewdAPI(childOID)
 ;
 s lineNo=""
 f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d
 . s text=textArr(lineNo)
 . q:text=""
 . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . s textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
 QUIT scriptOID 
 ;
getJavascriptFunction(functionName,docName,eOID) ;
 ;
 n c,comm,dqlvl,eArray,slcomm,language,lc,lineNo,lvl
 n mlcomm,ntags,OIDArray,%p1,%p2,pos,refString,sqlvl,stop,stop2
 n text,textArr,textArray
 ;
 s text="",eOID=""
 s refString="function "_functionName_"("
 s ntags=$$getElementsArrayByTagName^%zewdDOM("script",docName,,.eArray)
 s eOID="",stop=0
 f  s eOID=$o(eArray(eOID)) q:eOID=""  d  q:stop
 . s language=$$getAttribute^%zewdDOM("language",eOID)
 . q:language=""
 . q:$$zcvt^%zewdAPI(language,"l")'["javascript"
 . k textArr
 . s text=$$getElementValueByOID^%zewdDOM(eOID,"textArr",1)
 . i '$d(textArr) s textArr(1)=text
 . s lineNo="",text=""
 . f  s lineNo=$o(textArr(lineNo)) q:lineNo=""  d  q:stop
 . . s stop2=0
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
getJavascriptFunctionBody(functionName,docName)
 ;
 n body,crlf,eOID,jsText,nLines
 ;
 s jsText=$$getJavascriptFunction(functionName,docName,.eOID)
 s crlf=$c(13,10)
 s nLines=$l(jsText,crlf)
 s body=$p(jsText,crlf,2,nLines-1)
 QUIT body
 ;
replaceJavascriptFunctionBody(functionName,newBody,docName)
 ;
 n body,call,crlf,eOID,jsText
 ;
 s jsText=$$getJavascriptFunction(functionName,docName,.eOID)
 s crlf=$c(13,10)
 s call=$p(jsText,crlf,1)
 s body=call_crlf_newBody_crlf_"   }"
 s ok=$$replaceJavascriptFunction(functionName,body,docName)
 QUIT 1
 ;
 ;
ewdConfig(docName,phpHeaderArray,routineName,technology,dataTypeList,inputPath,filename,multilingual,config,pageName)
	;
	; Get the <ewd:config> tag and process it
	; Create the start of the CSP Pre-page script
	; 
	; attributes are:
	; 
	;   isFirstPage = true | false ; true is the default
	;   prePageScript = Cache function reference
	;   defaultTimeout = default session timeout in seconds (default = 1200)
	;   pageTimeout = page-specific session timeout in seconds (default = defaultTimeout)
	;   homePage = URL of homepage redirection if ewdlogout.php is invoked
	;   persistRequest = true | false ; saves the HTTP request name/value pairs to session array
	;   overrideTemplate = true | false ; (default=false) determines whether values in template or page take precedence
	;   
	; 
	; If missing, set page to be allowed to be used as a first page,
	; and no pre-page Script
	; 
	n nodeOID,secureRequest,prePageScript,multiLingual,onErrorScript,templatePrePageScript
	;
	i $$isXSLFO^%zewdCompiler(docName) d  QUIT 0
	. s pageName=$$XSLFO^%zewdCompiler7(docName)
	;
	s multiLingual=2
	s nodeOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	i nodeOID="" d
	. s config("isFirstPage")=1
	. s config("defaultTimeout")=1200
	. s config("pageTimeout")=config("defaultTimeout")
	. ;s config("homePage")="/default.htm"
	. s config("homePage")=$g(^zewd("config","homePage"))
	. s config("persistRequest")="true"
	. s config("errorPage")="ewdError"
	. s config("mgwsiServer")="LOCAL" i $$os^%zewdHTMLParser()="gtm" s config("mgwsiServer")="gtm"
	. s config("pageType")="html"
	. s config("errorClass")=""
	e  d
	. n serverList
	. i $g(backend)="" s backend="m"
	. s config("backend")=backend
	. s config("pageType")=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("pagetype",1,nodeOID),"l")
	. i config("pageType")="" s config("pageType")="html"
	. s config("isFirstPage")=$$getAttributeValue^%zewdDOM("isfirstpage",1,nodeOID)
	. i config("pageType")="ajax",config("isFirstPage")="" s config("isFirstPage")="false"
	. i config("isFirstPage")="" d
	. . n public
	. . s public=$$getAttributeValue^%zewdDOM("publicpage",1,nodeOID)
	. . s config("isFirstPage")="true"
	. . i $$zcvt^%zewdAPI(public,"l")="false" s config("isFirstPage")="false"
	. ;i config("isFirstPage")="" s config("isFirstPage")="true"
	. s config("isFirstPage")=$$zcvt^%zewdAPI(config("isFirstPage"),"l")="true"
	. s prePageScript=$$getAttributeValue^%zewdDOM("prepagescript",1,nodeOID)
	. i prePageScript="" s prePageScript=$$getAttributeValue^%zewdDOM("fetchmethod",1,nodeOID)
	. i prePageScript'="" d
	. . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalls",$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"),$$zcvt^%zewdAPI(prePageScript,"l"))="prePage"
	. . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalledBy",$$zcvt^%zewdAPI(prePageScript,"l"),$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"))="prePage"
	. d
	. . i prePageScript'["^",$e(prePageScript,1,7)'="##class",$e(prePageScript,1)'="$",$g(routineName)'="" s config("prePageScript")=config("prePageScript")_"^"_routineName q
	. . i $e(prePageScript,1)="$" s config("prePageScript")=prePageScript_"($ewd_session)" q
	. . s config("prePageScript")=prePageScript
	. s templatePrePageScript=$$getAttributeValue^%zewdDOM("templateprepagescript",1,nodeOID)
	. d
	. . i filename="ewdAjaxError.ewd" q
	. . i filename="ewdAjaxErrorRedirect.ewd" q
	. . i filename="ewdErrorRedirect.ewd" q
	. . i templatePrePageScript'["^",$e(templatePrePageScript,1,7)'="##class",$e(templatePrePageScript,1)'="$",$g(routineName)'="" s config("templatePrePageScript")=config("templatePrePageScript")_"^"_routineName q
	. . i $e(templatePrePageScript,1)="$" s config("templatePrePageScript")=templatePrePageScript_"($ewd_session)" q
	. . i templatePrePageScript["^" s config("templatePrePageScript")=templatePrePageScript
	. . s config("templatePrePageScript")=templatePrePageScript
	. s onErrorScript=$$getAttributeValue^%zewdDOM("onerrorscript",1,nodeOID)
	. d
	. . i onErrorScript'["^",$e(onErrorScript,1,7)'="##class",$e(onErrorScript,1)'="$",$g(routineName)'="" s config("onErrorScript")=config("onErrorScript")_"^"_routineName q
	. . i $e(onErrorScript,1)="$" s config("onErrorScript")=onErrorScript_"($ewd_session)" q
	. . s config("onErrorScript")=onErrorScript
	. s config("defaultTimeout")=$$getAttributeValue^%zewdDOM("defaulttimeout",1,nodeOID)
	. i config("defaultTimeout")="" s config("defaultTimeout")=1200
	. s config("pageTimeout")=$$getAttributeValue^%zewdDOM("pagetimeout",1,nodeOID)
	. i config("pageTimeout")="" s config("pageTimeout")=config("defaultTimeout")
	. i $$zcvt^%zewdAPI(config("pageTimeout"),"l")="system" d
	. . i technology="csp" s config("pageTimeout")="" q
	. . s config("pageTimeout")=config("defaultTimeout")
	. s config("homePage")=$g(^zewd("config","homePage"))
	. i $$getAttributeValue^%zewdDOM("homepage",1,nodeOID)'="" s config("homePage")=$$getAttributeValue^%zewdDOM("homepage",1,nodeOID)
	. s config("persistRequest")=$$getAttributeValue^%zewdDOM("persistrequest",1,nodeOID)
	. i config("persistRequest")="" s config("persistRequest")="true"
	. s config("pageTitle")=$$getAttributeValue^%zewdDOM("pagetitle",1,nodeOID)
	. i config("pageTitle")="" s config("pageTitle")=""
	. s config("confirmText")=$$getAttributeValue^%zewdDOM("confirmtext",1,nodeOID)
	. i config("confirmText")="" s config("confirmText")="Click OK if you're sure you want to delete this record"
	. s config("secureRequest")=$$getAttributeValue^%zewdDOM("securerequest",1,nodeOID)
	. i config("secureRequest")="" s config("secureRequest")="true"
	. s config("errorPage")=$$getAttributeValue^%zewdDOM("errorpage",1,nodeOID)
	. i config("errorPage")="" s config("errorPage")="ewdError"
	. s config("errorClass")=$$getAttributeValue^%zewdDOM("errorclass",1,nodeOID)
	. s config("mgwsiServer")=$$getAttributeValue^%zewdDOM("mgwsiserver",1,nodeOID)
	. i config("mgwsiServer")="" s config("mgwsiServer")=$$getAttributeValue^%zewdDOM("mphpserver",1,nodeOID)
	. i config("mgwsiServer")="" s config("mgwsiServer")=$g(ewd("sessionDatabase","mgwsiServer"))
	. i config("mgwsiServer")="" s config("mgwsiServer")="LOCAL"
	. i $$os^%zewdHTMLParser()="gtm" s config("mgwsiServer")="gtm"
	. s config("cachePage")=$$getAttributeValue^%zewdDOM("cachepage",1,nodeOID)
	. i config("cachePage")="" s config("cachePage")="true"
	. s config("escapeText")=$$getAttributeValue^%zewdDOM("escapetext",1,nodeOID)
	. i config("escapeText")="" s config("escapeText")="false"
	. s config("redirection")=$$getAttributeValue^%zewdDOM("redirection",1,nodeOID)
	. i config("redirection")="" s config("redirection")="server"
	. s config("arraySize")=$$getAttributeValue^%zewdDOM("arraysize",1,nodeOID)
	. i config("arraySize")="" s config("arraySize")="128"
	. s config("nextPageList")=$$getAttributeValue^%zewdDOM("nextpagelist",1,nodeOID)
	. s config("actionIfTimedOut")=$$getAttributeValue^%zewdDOM("actioniftimedout",1,nodeOID)
	. s config("maxLines")=$$getAttributeValue^%zewdDOM("maxlines",1,nodeOID)
	. s multiLingual=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("multilingual",1,nodeOID),"l")
	. i multiLingual="false" s multiLingual=0
	. e  s multiLingual=2
	. s config("ewd_sessionServer")=$$getAttributeValue^%zewdDOM("sessionserver",1,nodeOID)
	. i config("ewd_sessionServer")="" s config("ewd_sessionServer")=$g(ewd("sessionDatabase","type"))
	. i config("ewd_sessionServer")="cache" s config("ewd_sessionServer")="m"
	. i config("ewd_sessionServer")="" s config("ewd_sessionServer")="m"
	. i $g(persistenceDB)'="" s config("ewd_sessionServer")=persistenceDB
	. s config("ewd_sessionServerHostname")=$$getAttributeValue^%zewdDOM("sessionserverhost",1,nodeOID)
	. i config("ewd_sessionServerHostname")="" s config("ewd_sessionServerHostname")=$g(ewd("sessionDatabase","host"))
	. s config("ewd_sessionServerUsername")=$$getAttributeValue^%zewdDOM("sessionserverusername",1,nodeOID)
	. i config("ewd_sessionServerUsername")="" s config("ewd_sessionServerUsername")=$g(ewd("sessionDatabase","username"))
	. s config("ewd_sessionServerPassword")=$$getAttributeValue^%zewdDOM("sessionserverpassword",1,nodeOID)
	. i config("ewd_sessionServerPassword")="" s config("ewd_sessionServerPassword")=$g(ewd("sessionDatabase","password"))
	. s config("startFromWLDOnly")=$$getAttributeValue^%zewdDOM("startfromwldonly",1,nodeOID)
	. s config("startFromWLDOnly")=config("startFromWLDOnly")="true"
	. s serverList=$$getAttributeValue^%zewdDOM("servernamelist",1,nodeOID)
	. i serverList'="" d
	. . n i,np,p
	. . s serverList=$$stripSpaces^%zewdAPI(serverList)
	. . s np=$l(serverList,",")
	. . i np>0 d
	. . . f i=1:1:np d
	. . . . s p=$p(serverList,",",i)
	. . . . i p'="" s config("serverList",p)=""
	i multiLingual=0 s multilingual=multiLingual
	d createPHPConfigHeader^%zewdCompiler3(.config,.phpHeaderArray,technology,docName,.dataTypeList,inputPath,filename,multilingual,.pageName)
	s nodeOID=$$removeChild^%zewdAPI(nodeOID)
	QUIT multiLingual
	;
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
mergeToList(listName,listArray,sessid)
 ;
 n position,data,%d,text,value,pos
 ;
 s pos=""
 f  s pos=$o(listArray(pos)) q:pos=""  d
 . k data
 . s data=listArray(pos)
 . i data["~",data'[$c(1) d
 . . n p1,p2
 . . s p1=$p(data,"~",1)
 . . s p2=$p(data,"~",2)
 . . s listArray(pos)=p1_$c(1)_p2
 ;
 ;
 k ^%zewdSession("session",sessid,"ewd_list",listName)
 k ^%zewdSession("session",sessid,"ewd_listIndex",listName)
 m ^%zewdSession("session",sessid,"ewd_list",listName)=listArray
 s position=""
 f  s position=$o(^%zewdSession("session",sessid,"ewd_list",listName,position)) q:position=""  d
 . k %d,text,value
 . s %d=^%zewdSession("session",sessid,"ewd_list",listName,position)
 . s text=$p(%d,$c(1),1)
 . s value=$p(%d,$c(1),2)
 . i value="" s value=$e(text,1,200)
 . q:value=""
 . s ^%zewdSession("session",sessid,"ewd_listIndex",listName,value)=position
 d setWLDSymbol^%zewdAPI("ewd_list",sessid)
 d setWLDSymbol^%zewdAPI("ewd_listIndex",sessid)
 QUIT
 ;
copyList(fromListName,toListName,sessid)
 ;
 n ewdList,ewdListIndex
 ;
 i $g(fromListName)="" QUIT
 i $g(toListName)="" QUIT
 i $g(sessid)="" QUIT
 ;
 d mergeArrayFromSession^%zewdAPI(.ewdList,"ewd_list",sessid)
 d mergeArrayFromSession^%zewdAPI(.ewdListIndex,"ewd_listIndex",sessid)
 ;
 k ewdList(toListName)
 k ewdListIndex(toListName)
 m ewdList(toListName)=ewdList(fromListName)
 m ewdListIndex(toListName)=ewdListIndex(fromListName)
 ;
 d deleteFromSession^%zewdAPI("ewd_list",sessid)
 d deleteFromSession^%zewdAPI("ewd_listIndex",sessid)
 d mergeArrayToSession^%zewdAPI(.ewdList,"ewd_list",sessid)
 d mergeArrayToSession^%zewdAPI(.ewdListIndex,"ewd_listIndex",sessid) 
 ;
 QUIT
 ;
getTextFromList(listName,codeValue,sessid)
 ;
 n position,return
 ;
 i $g(listName)="" QUIT ""
 i $g(sessid)="" QUIT ""
 i $g(codeValue)="" QUIT ""
 set $zt="getTextFromListErr"
 ;
 s position=$g(^%zewdSession("session",sessid,"ewd_listIndex",listName,codeValue)) 
 i position="" QUIT ""
 QUIT $p(^%zewdSession("session",sessid,"ewd_list",listName,position),$c(1),1)
 ;
getTextFromListErr
 set $zt=""
 QUIT ""
 ;
replaceOptionsByFieldName(formName,fieldName,listName,sessid)
 ;
 n fieldRef,return,textValue,textValueEsc
 ;
 s fieldRef="document."_formName_"."_fieldName
 s return=fieldRef_".options.length = 0;"
 s return=return_$$returnOptions(fieldRef,listName,sessid)
 QUIT return
 ;
replaceOptionsByID(fieldID,listName,sessid)
 ;
 n fieldRef,return,textValue,textValueEsc
 ;
 s fieldRef="document.getElementById('"_fieldID_"')"
 s return=fieldRef_".options.length = 0;"
 s return=return_$$returnOptions(fieldRef,listName,sessid)
 QUIT return
 ;
returnOptions(fieldRef,listName,sessid)
 ;
 n codeValue,codeValueEsc,%d,ewdList,i,pos,return,textValue,textValueEsc
 ;
 d mergeArrayFromSession^%zewdAPI(.ewdList,"ewd_list",sessid)
 ;
 s pos="",i=-1,return=""
 f  s pos=$o(ewdList(listName,pos)) q:pos=""  d
 . k %d,textValue,codeValue,codeValueEsc,textValueEsc
 . s %d=ewdList(listName,pos)
 . s textValue=$p(%d,$c(1),1)
 . s textValueEsc=textValue
 . s textValueEsc=$$replaceAll^%zewdHTMLParser(textValueEsc,"&#39;","'")
 . s codeValue=$p(%d,$c(1),2)
 . i codeValue="" s codeValue=textValue
 . s codeValueEsc=codeValue
 . s codeValueEsc=$$replaceAll^%zewdHTMLParser(codeValueEsc,"&#39;","'")
 . s i=i+1
 . s return=return_fieldRef_".options["_i_"] = new Option("""_textValueEsc_""","""_codeValueEsc_""");"
 QUIT return
 ;
