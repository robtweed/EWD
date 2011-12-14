%zewdCompiler5	; Enterprise Web Developer Compiler Functions (extension routine)
 ;
 ; Product: Enterprise Web Developer (Build 894)
 ; Build Date: Wed, 14 Dec 2011 08:43:21
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
addCompilerComment(docName)
	;
	n htmlOID,docOID,commentOID,data,fcOID
	;
	s htmlOID=$$getTagOID^%zewdCompiler("html",docName)
	s docOID=$$getDocumentNode^%zewdDOM(docName)
	s data=$c(13,10)_"     Page created using Enterprise Web Developer version "_$$getVersion^%zewdCompiler()_$c(13,10)
	s data=data_"     Compiled at "_$$inetDate^%zewdAPI($h)_$c(13,10)
	s commentOID=$$createComment^%zewdDOM(data,docOID)
	s fcOID=$$getFirstChild^%zewdDOM(htmlOID)
	s commentOID=$$insertBefore^%zewdDOM(commentOID,fcOID)
	;
	QUIT
	;
multiLingTemplate(docName,inputPath,technology,multilingual)
	;
	n tdocOID,appName,pageName,os,dlim,ok
	s appName=inputPath
	s os=$$os^%zewdHTMLParser()
	i os="windows" s dlim="\"
	e  s dlim="/"
	s appName=$p(appName,$$getApplicationRootPath^%zewdCompiler(),2)
	s appName=$p(appName,dlim,2)
	s ok=$$openDOM^%zewdAPI()
	i ok'="" QUIT
	s tdocOID=$$getDocumentNode^%zewdDOM(docName)
	;d getAllNodes^%zewdCompiler(tdocOID,.tallArray)
	d multiLingual(tdocOID,technology,appName,"template",multilingual)
	s ok=$$closeDOM^%zewdDOM()
	QUIT
	;
multiLingual(docOID,technology,appName,pageName,multiLingualMode,textidList)
	;
	;  Convert all text to variables, and build phrase file
	;
	n allArray,nodeOID,textid,reviewMode,fragments,outputText,containsVars
	;
	d getAllNodes^%zewdCompiler(docOID,.allArray)
	s appName=$$zcvt^%zewdAPI(appName,"l")
	s pageName=$$zcvt^%zewdAPI(pageName,"l")
	s multiLingualMode=$g(multiLingualMode) i multiLingualMode="" s multiLingualMode=2
	s reviewMode=0 i multiLingualMode=1 s reviewMode=1
	s nodeOID=""
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. n nodeType
	. ; 
	. ; type 3=text, 2=attribute, 1=element
	. ; 
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. i nodeType=3 d  q
	. . ;
	. . ; Text node processing
	. . ;
	. . n divOID,parentOID,parentTagName,path,rawValue,text,value
	. . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	. . s parentTagName=$$getTagName^%zewdDOM(parentOID)
	. . i parentTagName="script" q
	. . i parentTagName="style" q
	. . s id=$$getAttribute^%zewdDOM("id",parentOID)
	. . i parentTagName="span",id="ewdajaxonload" q
	. . i parentTagName="div",id="ewdscript" q
	. . s value=$$getData^%zewdDOM(nodeOID)
	. . q:value="" 
	. . s textid=$$encodeValue(value,nodeOID,appName,pageName,.text,.textidList,technology,.containsVars,.outputText)
	. . i textid="" q  ; text
	. . i 'containsVars d  q
	. . . i $$modifyTextData^%zewdDOM(text,nodeOID)
	. . . i parentTagName="csp:text" d
	. . . . d removeIntermediateNode^%zewdCompiler4(parentOID)
	. . . . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	. . . . s parentTagName=$$getTagName^%zewdDOM(parentOID)
	. . . i parentTagName="title",reviewMode d
	. . . . d setAttribute^%zewdDOM("title","textid="_textid_" : "_value,parentOID)
 	. . . i parentTagName'="title",reviewMode d
	. . . . s divOID=$$insertNewParent^%zewdCompiler4(nodeOID,"span",docOID)
	. . . . i reviewMode d setAttribute^%zewdDOM("title","textid="_textid_" : "_value,divOID)
	. . . i parentTagName="title",reviewMode d setAttribute^%zewdDOM("title","textid="_textid_" : "_value,parentOID)
	. . ;
	. . ; contains variable(s)
	. . ;
	. . i $$modifyTextData^%zewdDOM(text,nodeOID)
	. . i parentTagName'="title",reviewMode d  ; text contains variables
	. . . n divOID
	. . . s divOID=$$insertNewParent^%zewdCompiler4(nodeOID,"span",docOID)
	. . . d setAttribute^%zewdDOM("title","textid="_textid_" : "_outputText,divOID)
	. ;
	. i nodeType=1 d  q
	. . ;
	. . ;  Attribute processing
	. . ;
	. . n type,value,attrType,attrOID,xvalue,path,textid,rawValue,titleValue
	. . ;
	. . s titleValue=""
	. . f attrType="alt","title" d
	. . . n fragments
	. . . set value=$$getAttributeValue^%zewdDOM(attrType,0,nodeOID)
	. . . q:value=""
	. . . i $e(value,1,7)="textid=" q
	. . . i attrType="title" s titleValue=value
	. . . s textid=$$encodeValue(value,nodeOID,appName,pageName,.text,.textidList,technology,.containsVars,.outputText)
	. . . i textid="" q  ; alt or title
	. . . i 'containsVars d  q
	. . . . s xvalue="#($$displayText^%zewdAPI("""_textid_""",0,sessid))#"
	. . . . i reviewMode s xvalue="#($$displayText^%zewdAPI("""_textid_""",1,sessid))#"
	. . . . d setAttribute^%zewdDOM(attrType,xvalue,nodeOID) ; alt or title without variables
	. . . ;
	. . . ; contains variables
	. . . ;
	. . . d setAttribute^%zewdDOM(attrType,text,nodeOID) ; alt or title with variables
	. . ;
	. . s type=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("type",1,nodeOID),"L")
	. . i type="" s type="unknown"
	. . i type="hidden"!(type="checkbox")!(type="text")!(type="radio")!(type="file")!(type="password")!(type="image") Q
	. . i $$getTagName^%zewdDOM(nodeOID)="option" QUIT
	. . s value=$$getAttributeValue^%zewdDOM("value",0,nodeOID)
	. . ;
	. . ; tags with value= attributes
	. . ;
	. . s textid=$$encodeValue(value,nodeOID,appName,pageName,.text,.textidList,technology,.containsVars,.outputText)
	. . i textid="" q
	. . i 'containsVars d  q
	. . . n xvalue
	. . . s xvalue="#($$displayText^%zewdAPI("""_textid_""",0,sessid))#"
	. . . d setAttribute^%zewdDOM("value",xvalue,nodeOID)
	. . . i reviewMode d
	. . . . i titleValue["textid=" q  ; already set due to text
	. . . . d setAttribute^%zewdDOM("title","textid="_textid_" : "_value,nodeOID) ; value attribute
	. . ;
	. . d setAttribute^%zewdDOM("value",text,nodeOID) ; value attribute
	. . i reviewMode d
	. . . i titleValue["textid=" q  ; already set due to text
	. . . d setAttribute^%zewdDOM("title","textid="_textids_" : "_outputText,nodeOID) ; value attribute
	;
	k ^ewdTranslation("pageIndex",appName,pageName)
	s textid=""
	f  s textid=$o(textidList(textid)) q:textid=""  d
	. s ^ewdTranslation("pageIndex",appName,pageName,textid)=""
	;
	QUIT
	;
	;
encodeValue(value,nodeOID,appName,pageName,text,textidList,technology,containsVars,outputText)
	;
	; returns textidList, textid outputText by reference, and textid as returnValue
	;
	n code,divOID,fragmentNo,fragments,ok,rawValue,path,ptextid,textid,textids
	n textidx,textx
	;
	s text=""
	k outputText
	s rawValue=value
	s containsVars=0
	i $e(value,1,25)="#($$displayText^%zewdAPI(" QUIT ""
	s value=$$tidyValue(value)
	i value="" QUIT ""
	;
	s path=$$getPathFromNode(nodeOID)
	s found=$$isTextPreviouslyFound(rawValue,appName,pageName,path,.textid,.fragments,.outputText)
	i '$$isTextPreviouslyFound(rawValue,appName,pageName,path,.textid,.fragments,.outputText) d
	. s textid=$$addTextToIndex(rawValue,appName,pageName,path,.fragments,.outputText)
	;b:rawValue["&cspVar"
	q:textid=""
	;
	s textidList(textid)=""
	;
	s containsVars=1
	i '$d(fragments) d  QUIT textid
	. s text="#($$displayText^%zewdAPI("""_textid_""",0,sessid))#"
	. s containsVars=0
	;
	; fragments found
	;
	s fragmentNo="",text="",ptextid=textid,textids=""
	f  s fragmentNo=$o(fragments("text",fragmentNo)) q:fragmentNo=""  d
	. s textx=fragments("text",fragmentNo)
	. i $$tidyValue(textx)="" d
	. . s code=textx
	. e  d
	. . n sub,textid
	. . s code=""
	. . i '$$isTextPreviouslyFound(textx,appName,pageName,path,.textid) d
	. . . s textid=$$addTextToIndex(textx,appName,pageName,path)
	. . s textidList(textid)=""
	. . s textids=textids_textid_","
	. . s textidx(textid)=""
	. . s sub="#($$displayText^%zewdAPI("""_textid_""",0,sessid))#"
	. . s code=code_sub
	. i $g(fragments("var",fragmentNo))'="" d
	. . i $g(fragments("type",fragmentNo))="php" s code=code_" &php;"_fragments("var",fragmentNo)_"&php; "
	. . i $g(fragments("type",fragmentNo))="csp" s code=code_" &cspVar;"_fragments("var",fragmentNo)_"&cspVar; "
	. s text=text_code
	m ^ewdTranslation("varXRef",ptextid)=textidx
	QUIT textids
	i $$modifyTextData^%zewdDOM(text,nodeOID)
	m ^ewdTranslation("varXRef",ptextid)=textidx
	s textids=$e(textids,1,$l(textids)-1)
	i parentTagName'="title",reviewMode d
	. n divOID
	. s divOID=$$insertNewParent^%zewdCompiler4(nodeOID,"span",docOID)
	. ;d $$$setAttribute("id",ptextid,divOID)
	. d setAttribute^%zewdDOM("title","textid="_textids_" : "_outputText,divOID)
	;
deleteTranslationsForApp(app)
	;
	n page,textid,%d,source
	;
	i app="" QUIT 0
	s page=""
	f  s page=$o(^ewdTranslation("pageIndex",app,page)) q:page=""  d
	. i $$deleteTranslationsForPage(app,page)
	f  s page=$o(^ewdTranslation("otherIndex",app,page)) q:page=""  d
	. s textid=""
	. f  s textid=$o(^ewdTranslation("otherIndex",app,page,textid)) q:textid=""  d
	. . i $$deleteTextid(textid)
	. . k ^ewdTranslation("otherIndex",app,page,textid)
	s textid=""
	f  s textid=$o(^ewdTranslation("source",textid)) q:textid=""  d
	. s %d=^ewdTranslation("source",textid)
	. s source=$p(%d,$c(1),1)
	. i source=$$zcvt^%zewdAPI(app,"l") d deleteTextid(textid)
	QUIT 1 
	;
deleteTranslationsForPage(app,page)
	;
	n textid
	;
	i app="" QUIT 0
	i page="" QUIT 0
	s textid=""
	s app=$$zcvt^%zewdAPI(app,"l")
	s page=$$zcvt^%zewdAPI(page,"l")
	f  s textid=$o(^ewdTranslation("pageIndex",app,page,textid)) q:textid=""  d
	. i $$deleteTextid(textid)
	QUIT 1
	;
deleteTextid(textid)
	;
	n app,page,language,textValue,phrase,ptextid
	;
	i textid="" QUIT 0
	s app=$$getTextAppName(textid)
	s page=$$getTextPage(textid)
	s language="" i app'="" s language=$$getDefaultLanguage(app)
	s textValue=""
	i language'="" s textValue=$$getTextTranslation(textid,language)
	s phrase=$$getPhraseIndex(textValue)
	;
	k ^ewdTranslation("textid",textid)
	k ^ewdTranslation("source",textid)
	i app'="",page'="" k ^ewdTranslation("pageIndex",app,page,textid),^ewdTranslation("otherIndex",app,page,textid)
	i phrase'="" k ^ewdTranslation("textIndex",phrase,textid)
	k ^ewdTranslation("varXRef",textid)
	s ptextid=""
	f  s ptextid=$o(^ewdTranslation("varXRef",ptextid)) q:ptextid=""  d
	. i $d(^ewdTranslation("varXRef",ptextid,textid)) k ^ewdTranslation("varXRef",ptextid,textid)
	QUIT 1
	;
addTextToIndex(textValue,appName,pageName,path,fragments,outputText,phraseType)
	n textid,language,inPage
	;i $g(phraseType)'="" d TRACE^%wld("phraseType="_phraseType)
	s textValue=$$replaceAll^%zewdHTMLParser(textValue,$c(9)," ")
	s textValue=$$replaceAll^%zewdHTMLParser(textValue,"   ","  ")
	;s textValue=$ZSTRIP(textValue,"<>W")
	s outputText=$$getTextFragments(textValue,.fragments)
	s language=$$getDefaultLanguage(appName)
	s phraseType=$g(phraseType)
	s inPage=1 i pageName="",phraseType'="" s inPage=0
	s textid=$o(^ewdTranslation("textid",""),-1)+1
	;d TRACE^%wld("in addTextToIndex")
	;d TRACE^%wld("textValue="_textValue_" ; phraseType="_phraseType)
	;d TRACE^%wld("textid="_textid)
	;d TRACE^%wld("inPage="_inPage)
	s ^ewdTranslation("textid",textid,language)=outputText
	s ^ewdTranslation("source",textid)=appName_$c(1)_pageName_$c(1)_path_$c(1)_phraseType
	i inPage s ^ewdTranslation("pageIndex",$$zcvt^%zewdAPI(appName,"l"),$$zcvt^%zewdAPI(pageName,"l"),textid)=""
	i 'inPage s ^ewdTranslation("otherIndex",$$zcvt^%zewdAPI(appName,"l"),phraseType,textid)=""
	s ^ewdTranslation("textIndex",$$getPhraseIndex(outputText),textid)=""
	QUIT textid
	;
getTextFragments(textValue,fragments)
	;
	n i,vars,nfragments,fragment,outputValue,sig,type
	k fragments,nfragments2,type
	f sig="&php;","&cspVar;" d
	. s type="php" i sig="&cspVar;" s type="csp"
	. i textValue[sig d
	. . f i=1:1 q:textValue'[sig  d
	. . . n %p1,%p2,%p3
	. . . s %p1=$p(textValue,sig,1)
	. . . s %p2=$p(textValue,sig,2)
	. . . s vars(type,i)=%p2
	. . . s %p3=$p(textValue,sig,3,1000)
	. . . i sig="&php;" s textValue=%p1_"{variable}"_%p3
	. . . i sig="&cspVar;" s textValue=%p1_"{variable }"_%p3
	s outputValue=textValue
	s nfragments=$l(textValue,"{variable}")
	i nfragments>1 d
	. f i=1:1:nfragments s fragment=$p(textValue,"{variable}",i) i fragment'="" d
	. . n type
	. . s type="php"
	. . s fragments("text",i)=fragment
	. . s fragments("var",i)=$g(vars(type,i))
	. . s fragments("type",i)=type
	s nfragments2=$l(textValue,"{variable }")
	i nfragments=1 s nfragments=0
	i nfragments2>1 d
	. f i=1:1:nfragments2 s fragment=$p(textValue,"{variable }",i) d  ;i fragment'="" d
	. . n type,j
	. . s j=nfragments+i
	. . s type="csp"
	. . s fragments("text",j)=fragment
	. . s fragments("var",j)=$g(vars(type,j))
	. . s fragments("type",j)=type
	QUIT outputValue
	;
clearDownTranslations ;
	n i
	f i="pageIndex","source","textIndex","textid","varXRef","otherIndex" k ^ewdTranslation(i)
	QUIT
	;
isTextPreviouslyFound(textValue,appName,pageName,path,textid,fragments,outputText,phraseType)
	;
	n phraseIndex,language,%stop,inPage
	;
	s outputText=$$getTextFragments(textValue,.fragments)
	s language=$$getDefaultLanguage(appName)
	s phraseIndex=$$getPhraseIndex(outputText)
	i phraseIndex="" QUIT 0
	s appName=$$zcvt^%zewdAPI(appName,"l")
	s pageName=$$zcvt^%zewdAPI(pageName,"l")
	s phraseType=$g(phraseType)
	s inPage=1 i pageName="",phraseType'="" s inPage=0
	;d TRACE^%wld("inPage="_inPage)
	s textid="",%stop=0
	f  s textid=$o(^ewdTranslation("textIndex",phraseIndex,textid)) q:textid=""  d  q:%stop
	. i inPage,'$d(^ewdTranslation("pageIndex",appName,pageName,textid)) q  ; not found in page
	. i 'inPage,'$d(^ewdTranslation("otherIndex",appName,phraseType,textid)) q  ; not found in page
	. n text,prevPath
	. s text=$g(^ewdTranslation("textid",textid,language))
	. ;q:text'=outputText ; not exact text match
	. q:$$tidyValue(text)'=$$tidyValue(textValue) ; not exact text match
	. s prevPath=$$getTextPath(textid)
	. q:path'=prevPath
	. s %stop=1
	;
	QUIT %stop
	;
getTextTranslation(textid,language)
	i textid="" QUIT ""
	i language="" QUIT ""
	QUIT $g(^ewdTranslation("textid",textid,language))
	;
getTextAppName(textid)
	;
	n appName
	;
	i textid="" QUIT ""
	s appName=$$zcvt^%zewdAPI($p($g(^ewdTranslation("source",textid)),$c(1),1),"l")
	i appName="" s appName="unknown"
	QUIT appName
	;
getTextPage(textid)
	;
	i textid="" QUIT ""
	QUIT $$zcvt^%zewdAPI($p($g(^ewdTranslation("source",textid)),$c(1),2),"l")
	;
getTextPath(textid)
	;
	i textid="" QUIT ""
	QUIT $p($g(^ewdTranslation("source",textid)),$c(1),3)
	;
getTextPhraseType(textid)
	;
	i textid="" QUIT ""
	QUIT $p($g(^ewdTranslation("source",textid)),$c(1),4)
	;
getDefaultLanguage(appName)
	;
	n language
	s language=""
	i $g(appName)'="" s language=$g(^ewdTranslation("defaultLanguage",$$zcvt^%zewdAPI(appName,"l")))
	i language="" s language="en"
	QUIT language
	;
setDefaultLanguage(appName,language)
	;
	i appName="" QUIT
	i language="" QUIT
	s ^ewdTranslation("defaultLanguage",$$zcvt^%zewdAPI(appName,"l"))=language
	QUIT
	;
getDefaultLanguageText(textid,appName)
	;
	n language
	;
	s language=$$getDefaultLanguage(appName)
	QUIT $$getTextByTextid(textid,language)
	;
getLanguageName(appName,languageCode)
	;
	i appName="" QUIT ""
	i languageCode="" QUIT ""
	QUIT $g(^ewdTranslation("language",$$zcvt^%zewdAPI(appName,"l"),languageCode))
	;
setLanguageName(appName,languageCode,languageName)
	;
	i appName="" QUIT
	i languageCode="" QUIT
	s ^ewdTranslation("language",$$zcvt^%zewdAPI(appName,"l"),languageCode)=languageName
	QUIT
	;
setTranslatedValue(textid,langTo,text)
	i textid="" QUIT
	i langTo="" QUIT
	i text="" k ^ewdTranslation("textid",textid,langTo)
	e  s ^ewdTranslation("textid",textid,langTo)=text
	QUIT
	;
countPhraseTranslations(text,langTo)
	;
	n count,textid
	s text=$$getPhraseIndex(text)
	s count=0
	s textid=""
	f  s textid=$o(^ewdTranslation("textIndex",text,textid)) q:textid=""  d
	. i $d(^ewdTranslation("textid",textid,langTo)) s count=count+1
	QUIT count
	;
countOtherPhraseTranslations(textid,langTo,appName,transFound)
	;
	n count,xtextid,stop,text,transText
	k transFound
	s text=$$getDefaultLanguageText(textid,appName)
	s transText=$g(^ewdTranslation("textid",textid,langTo))
	s text=$$getPhraseIndex(text)
	s count=0,stop=0
	s xtextid=""
	f  s xtextid=$o(^ewdTranslation("textIndex",text,xtextid)) q:xtextid=""  d
	. ; xtextid
	. q:textid=xtextid
	. i $d(^ewdTranslation("textid",xtextid,langTo)) d
	. . n sxtext,xid
	. . s sxtext=^ewdTranslation("textid",xtextid,langTo)
	. . q:sxtext=""
	. . i $l(sxtext)=1,$a(sxtext)=160 q
	. . q:sxtext=transText
	. . s xid=""
	. . i '$d(transFound) s count=1,transFound(xtextid)=sxtext q
	. . f  s xid=$o(transFound(xid)) q:xid=""  d
	. . . i sxtext'=transFound(xid) s count=count+1,transFound(xtextid)=sxtext q
	;
	QUIT count
	;
getPhraseTranslations(text,langTo,transList)
	n count,textid
	s text=$$getPhraseIndex(text)
	s textid=""
	f  s textid=$o(^ewdTranslation("textIndex",text,textid)) q:textid=""  d
	. n trans
	. s trans=$g(^ewdTranslation("textid",textid,langTo))
	. q:trans=""
	. i $l(trans)=1,$a(trans)=160 q
	. i $$isUniqueTranslation(trans,.transList,textid) s transList(textid)=trans
	QUIT
	;
isUniqueTranslation(trans,transList,thisTextid)
	;
	n textid,unique
	;
	s textid=""
	s unique=1
	f  s textid=$o(transList(textid)) q:textid=""  d  q:'unique
	q:textid=$g(thisTextid)
	. i transList(textid)=trans s unique=0
	QUIT unique
	;
tidyValue(value)
	;
	n tempValue,i
	;
	s value=$$replaceAll^%zewdHTMLParser(value,"&nbsp;"," ")
	s value=$$replaceAll^%zewdHTMLParser(value,$c(9)," ")
	s value=$$replaceAll^%zewdHTMLParser(value,"  "," ")
	s value=$$stripSpaces^%zewdAPI(value)
	;s value=$ZSTRIP(value,">W")
	i value?1NP.NP s value=""
	i $e(value,1,2)="#(",$e($re(value),1,2)="#)" QUIT ""
	s value=$$replaceAll^%zewdHTMLParser(value,"""","&#34;")
	s value=$$replaceAll^%zewdHTMLParser(value,"'","&#39;")
	s tempValue=$$replaceAll^%zewdHTMLParser(value,"&cspVar;","")
	i tempValue?1NP.NP QUIT ""
	s tempValue=$$replaceAll^%zewdHTMLParser(value,"&php;","")
	i tempValue?1NP.NP QUIT ""
	s tempValue=""
	f i=1:1:$l(value) d
	. n c
	. s c=$e(value,i)
	. i c'?1NP s tempValue=tempValue_c q
	. i c=" " s tempValue=tempValue_c
	s value=tempValue
	s value=$$stripSpaces^%zewdAPI(value)
	QUIT value
	;
isVariable(%text) ;
 i $e(%text,1,2)="#(",$e($re(%text),1,2)="#)" QUIT 1
 QUIT 0
 ;
getPhraseIndex(phrase)
	;
	n phraseIndex
	s phraseIndex=$$tidyValue(phrase)
	s phraseIndex=$e(phraseIndex,1,200)
	s phraseIndex=$$zcvt^%zewdAPI(phraseIndex,"l")
	QUIT phraseIndex	
	;
getTextByTextid(textid,language)
	i $g(textid)="" QUIT ""
	i $g(language)="" s language="en"
	QUIT $g(^ewdTranslation("textid",textid,language))
	;
autoTranslate(app,language)
 ;
 n appName,defLang,phraseIndex,text,textid,transList
 ;
 s defLang=$$getDefaultLanguage^%zewdCompiler5(app)
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s appName=$$getTextAppName^%zewdCompiler5(textid)
 . i appName'=app q
 . ;
 . s text=$g(^ewdTranslation("textid",textid,defLang))
 . i text="" q
 . d getTranslationsByPhrase^%zewdCompiler5(text,language,.transList)
 ;
 QUIT
	;
getTranslationsByTextid(textid,language,translationList)
	;
	n phrase
	;
	QUIT:$g(textid)=""
	s phrase=$$getTextByTextid(textid,"en")
	d getTranslationsByPhrase(phrase,language,.translationList)
	QUIT
	;
getTranslationsByPhrase(phrase,language,translationList)
	;
	n transNo,textidList,textid
	;
	k translationList
	s transNo=0
	QUIT:$g(phrase)=""
	i $g(language)="" s language="en"
	;
	d getMatchingText(phrase,"en",.textidList)
	;
	s textid=""
	f  s textid=$o(textidList(textid)) q:textid=""  d
	. n translation
	. s translation=$g(^ewdTranslation("textid",textid,language))
	. i translation="" q
	. s transNo=transNo+1
	. s translationList(transNo)=translation
	QUIT
	;
getMatchingText(phrase,language,matchingTextidList)
	;
	n indexPhrase,textid
	;
	k matchingTextids
	;
	QUIT:$g(phrase)=""
	i $g(language)="" s language="en"
	s indexPhrase=$$getPhraseIndex(phrase)
	s textid=""
	;f  s textid=$o(^ewdTranslation("textIndex",language,indexPhrase,textid)) q:textid=""  d
	f  s textid=$o(^ewdTranslation("textIndex",indexPhrase,textid)) q:textid=""  d
	. s matchingTextidList(textid)=""
	QUIT
	;
	;
getPathFromNode(nodeOID)
	;
	n nodeType
	;
	s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	i nodeType=3 QUIT $$getPath(nodeOID)
	i nodeType=2 QUIT $$getPath(nodeOID)
	QUIT ""
	;
getPath(nodeOID)	;
	;
	n path,parent,nodeType,tagName,childNo,%stop,terminator
	;
	s path=""
	s %stop=0
	s parent=nodeOID
	s terminator=""
	;
	i $$getNodeType^%zewdDOM(nodeOID)=2 d
	. s parent=$$getOwnerElement^%zewdDOM(nodeOID)
	. s terminator="/@"_$$getNodeName^%zewdDOM(nodeOID)
	;
	i $$getNodeType^%zewdDOM(nodeOID)=3 d
	. n childOID,incomingText,%stop,nodeType
	. s %stop=0
	. s incomingText=$$getData^%zewdDOM(nodeOID)
	. s parent=$$getParentNode^%zewdDOM(nodeOID)
	. s childOID=$$getFirstChild^%zewdDOM(parent)
	. s nodeType=$$getNodeType^%zewdDOM(childOID)
	. i nodeType=3 s childNo=$g(childNo)+1
	. i nodeOID=childOID s terminator="/text()[1]" q
	. ;
	. f  s childOID=$$getNextSibling^%zewdDOM(childOID) q:childOID=""  d  q:%stop
	. . s nodeType=$$getNodeType^%zewdDOM(childOID)
	. . i nodeType=3 s childNo=$g(childNo)+1
	. . i nodeOID=childOID s terminator="/text()["_childNo_"]",%stop=1
	;
	f  q:%stop  d
	. s nodeType=$$getNodeType^%zewdDOM(parent) i nodeType'=1 s %stop=1 q
	. s tagName=$$getTagName^%zewdDOM(parent)
	. s childNo=$$getChildNo^%zewdCompiler3(parent)
	. s path="/"_tagName_childNo_path
	. s nodeOID=parent
	. s parent=$$getParentNode^%zewdDOM(nodeOID)
	;
	QUIT path_terminator
	;
setCookies
	;
	n cookieName,value,expires,data
	;
	s cookieName=""
	k ^%zewdSession("session","ewd_cookie")
	;d deleteWLDSymbol^%zewdWLD("ewd_cookie",sessid)
	QUIT
	;
setResponseHeaders
	;
	n header,value
	;
	s header=""
	QUIT
	;
	;
renameCSPToEWD(app)
 ;
 n path,dlim,files
 ;
 s path=$$getApplicationRootPath^%zewdCompiler()
 s dlim=$$getDelim^%zewdCompiler()
 i $e(path,$l(path))'=dlim s path=path_dlim
 s path=path_app
 i '$$validPath^%zewdCompiler(path) w !,"The path "_path_" is invalid and/or does not exist.  Renaming aborted" QUIT
 ;
 d renameCSPFiles(path)
 QUIT
 ;
renameCSPFiles(inputPath)
	;
	n dir,newInputPath,dlim,dirs,files
	;
	s dlim=$$getDelim^%zewdCompiler()
	d getFilesInPath^%zewdHTMLParser(inputPath,"csp",.files)
	d renameFiles(inputPath,.files)
	;
	d getDirectoriesInPath^%zewdHTMLParser(inputPath,.dirs)
	s dir=""
	f  s dir=$o(dirs(dir)) q:dir=""  d
	. s newInputPath=inputPath_dlim_dir
	. d renameCSPFiles(newInputPath)
    QUIT
    ;
renameFiles(inputPath,files)
	;
	n dlim,fileName,name,newName,oldName,ok
	;
	s dlim=$$getDelim^%zewdCompiler()
	s fileName=""
	f  s fileName=$o(files(fileName)) q:fileName=""  d
	. s name=$p(fileName,".csp",1)
	. s newName=name_".ewd"
	. s oldName=inputPath_dlim_fileName
	. s newName=inputPath_dlim_newName
	. s ok=$$renameFile^%zewdHTMLParser(oldName,newName)
	. w !,newName
	QUIT
	;
	;===========================================
	;
systemMessage(text,type,appName,langCode)
 ;
 n fragments,outputText,textid,typex
 ;
 i $g(text)="" QUIT ""
 i $g(appName)="" QUIT text
 i $g(langCode)="" QUIT text
 s typex=$g(type) ; avoid Cache bug !
 i $$getPhraseIndex(text)="" QUIT ""
 i '$$isTextPreviouslyFound(text,appName,"","",.textid,,,type) d
 . s textid=$$addTextToIndex(text,appName,"","",.fragments,.outputText,typex)
 i $g(textid)="" QUIT ""
 i '$d(^ewdTranslation("textid",textid)) QUIT "textid "_textid_" : text missing!  Check dictionary"
 s outputText=$g(^ewdTranslation("textid",textid,langCode))
 i outputText="" s outputText=$g(^ewdTranslation("textid",textid,$$getDefaultLanguage($$getTextAppName(textid))))
 i langCode="xx" s outputText=textid_" ("_text_")"
 s outputText=$$replaceAll^%zewdHTMLParser(outputText,"'",$c(5))
 s outputText=$$replaceAll^%zewdHTMLParser(outputText,$c(5),"\'")
 QUIT outputText
 ;
examine(language,substring)
 ;
 n text,textid
 ;
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s text=$g(^ewdTranslation("textid",textid,language))
 . i text="" q
 . i text[substring w textid," : ",text,!
 QUIT
 ;
findText(sessid)
 ;
 n appName,language,substr,text,textDisp,textid,textidArray,textx
 ;
 d clearList^%zewdAPI("textidMatches",sessid)
 d deleteFromSession^%zewdAPI("matchesFound",sessid)
 s appName=$$getTextValue^%zewdAPI("appName",sessid)
 s language=$$getSelectValue^%zewdAPI("languageTo",sessid)
 s substr=$$getTextValue^%zewdAPI("substr",sessid)
 s substr=$$getPhraseIndex(substr)
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s text=$g(^ewdTranslation("textid",textid,language))
 . i text="" q
 . i $$getTextAppName^%zewdCompiler5(textid)'=appName q
 . s textx=$$getPhraseIndex(text)
 . i textx[substr d
 . . s textDisp=textid_" : "_$e(text,1,20)
 . . d appendToList^%zewdAPI("textidMatches",textDisp,textid,sessid)
 . . d setSessionValue^%zewdAPI("matchesFound",1,sessid)
 QUIT ""
 ;
deleteUnusedTextids(sessid)
 ;
 n appName,defLang,page,src,text,textid
 ;
 s appName=$$getTextValue^%zewdAPI("appName",sessid)
 s defLang=$$getDefaultLanguage(appName)
 ;
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . i $$getTextAppName(textid)'=appName q
 . s src=$g(^ewdTranslation("source",textid)) i src="" q
 . i $$isActive(textid) q
 . k ^ewdTranslation("source",textid)
 . k ^ewdTranslation("pageIndex",appName,page,textid)
 . s text=$g(^ewdTranslation("textid",textid,defLang))
 . s text=$$getPhraseIndex(text)
 . k ^ewdTranslation("textIndex",text,textid)
 . k ^ewdTranslation("varXRef",textid)
 d setWarning^%zewdAPI("Unused textids have now been removed from the translation global",sessid)
 QUIT ""
 ;
isActive(textid)
 ;
 n appName,pageName
 ;
 s appName=$$getTextAppName(textid)
 i appName="" QUIT 0
 s page=$$getTextPage(textid)
 i page="" QUIT 1  ; probably a systemMessage-defined textid so leave intact
 i $d(^ewdTranslation("pageIndex",appName,page,textid)) QUIT 1
 QUIT 0
 ;
