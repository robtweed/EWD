%zewdCompiler3	; Enterprise Web Developer Compiler Functions (extension routine)
 ;
 ; Product: Enterprise Web Developer (Build 842)
 ; Build Date: Wed, 02 Feb 2011 09:31:08
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
extractMCode(docName)
	;
	new codeType,dlim,language,mCode,nodeOID,ntags,OIDArray
	n routineName,%stop,textOID
	;
	set routineName=""
	set ntags=$$getTagsByName^%zewdCompiler("script",docName,.OIDArray)
	set nodeOID="",%stop=0
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do  quit:%stop
	. set language=$$getAttributeValue^%zewdDOM("language",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(language,"L")'="ewd"
	. set routineName=$$getAttributeValue^%zewdDOM("routinename",1,nodeOID)
	. quit:routineName=""
	. ;
	. set textOID=$$getFirstChild^%zewdDOM(nodeOID)
	. set mCode=$$getData^%zewdDOM(textOID)
	. s dlim=$c(13,10) i mCode'[$c(13,10),mCode[$c(10) s dlim=$c(10)
	. set mCode=routineName_" ; Compiled from Enterprise Web Developer page "_filename_" on "_$$inetDate^%zewdAPI($h)_$char(13,10)_" ; "_$char(13,10)_mCode
	. set codeType=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("codeType",1,nodeOID),"U")
	. if codeType="" set codeType="INT"
	. if codeType="INT" do
	. . new nLines,x,i
	. . set nLines=$length(mCode,dlim)
	. . set x="zr  f i=1:1:nLines zi $p(mCode,"_dlim_",i) i i=nLines zs "_routineName
	. . xecute x
	. set %stop=1
	. set nodeOID=$$removeChild^%zewdAPI(nodeOID,1)
	;
	QUIT routineName
	;
createPHPFormHeader(formDeclarations,phpHeaderArray,technology,dataTypeList,config,pageName)
 ;
 ; formDeclaration(n)=fieldName~actionScript~nextPage~nameList
 ;
 n action,app,%d,dataType,field,fieldName,fields,hasDTs,i,n,name,nextpage,nextPage
 n noOfFields,nvpList,type,upload
 ;
 s n=""
 s app=subPath
 for  set n=$order(formDeclarations(n)) quit:n=""  do
 . set %d=formDeclarations(n)
 . set action=$piece(%d,"~",2)
 . set nextPage=$piece(%d,"~",3)
 . i nextPage'="" d
 . . q:nextPage="*"
 . . q:$e(nextPage,1)="#"
 . . q:pageName="*"
 . . q:$e(pageName,1)="#"
 . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalls",$$zcvt^%zewdAPI(pageName,"l"),$$zcvt^%zewdAPI(nextPage,"l"))=""
 . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalledBy",$$zcvt^%zewdAPI(nextPage,"l"),$$zcvt^%zewdAPI(pageName,"l"))=""
 . i action'="" d
 . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalls",$$zcvt^%zewdAPI(pageName,"l"),action)="action"
 . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalledBy",action,$$zcvt^%zewdAPI(pageName,"l"))="action"
 ;
 d pre2^%zewdGTMRuntime QUIT
 ;
createPHPConfigHeader(config,phpHeaderArray,technology,docName,dataTypeList,inputPath,filename,multilingual,pageName)
 ;
 new appName,dlim,npieces,os,pageType,rhText
 ;
 set appName=inputPath
 set os=$$os^%zewdHTMLParser()
 if os="windows" set dlim="\"
 else  set dlim="/"
 if $extract(appName,$length(appName))=dlim set appName=$extract(appName,1,$length(appName)-1)
 set npieces=$length(appName,dlim)
 set appName=$piece(appName,dlim,npieces)
 set pageName=$piece(filename,".ewd",1)
 ;
 d pre1^%zewdGTMRuntime QUIT
 ;
template(docName,templateDocName,inputPath,phpVars,technology)
	;
	new error,nodeOID,applyTemplate,templateDocOID,altTemplateName,tDocName
	;
	; Should a template be applied to this page? (default is yes)
	; 
	set altTemplateName=""
	set nodeOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	if nodeOID="" set applyTemplate=1
	else  do
	. set applyTemplate=$$getAttributeValue^%zewdDOM("applytemplate",1,nodeOID)
	. if applyTemplate="" do
	. . set applyTemplate=1
	. else  do
	. . if $$zcvt^%zewdAPI(applyTemplate,"L")="false" set applyTemplate=0 quit
	. . set applyTemplate=1
	. ;
	. set altTemplateName=$$getAttributeValue^%zewdDOM("templatename",1,nodeOID)
	. quit:altTemplateName=""
	;
	set tDocName=templateDocName
	if altTemplateName'="" do
	. new templateFilename
	. set templateFilename=altTemplateName
	. if $$zcvt^%zewdAPI(templateFilename,"l")'[".ewd" set templateFilename=altTemplateName_".ewd"
	. set tDocName="ewdTemplate1"
	. set error=$$processTemplate^%zewdCompiler(templateFilename,inputPath,.tDocName,.phpVars,technology)
	. ;
	set templateDocOID=$$getDocumentNode^%zewdDOM(tDocName)
	i templateDocOID="" QUIT ""
	;
	if 'applyTemplate,tDocName'="" do  QUIT ""
	. ; apply system-global config params if present in the template document
	. new attr,tAttr,tErrorPage,tOID,pAttr,pErrorPage,pOID,tML,pML
	. set tOID=$$getTagOID^%zewdCompiler("ewd:config",tDocName)
	. quit:tOID=""
	. set pOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	. f attr="cachepage","maxlines","mgwsiserver","mphpserver","multilingual","errorpage","escapetext","pagetimeout","timeout","defaulttimeout","sessionserver","sessionserverhost","sessionserverusername","sessionserverpassword","servernamelist","actioniftimedout" d
	. . set tAttr=$$getAttributeValue^%zewdDOM(attr,1,tOID)
	. . set pAttr=$$getAttributeValue^%zewdDOM(attr,1,pOID)
	. . i pAttr="",tAttr'="" d setAttribute^%zewdDOM(attr,tAttr,pOID) 
	;
	; Now apply template blocks
	;
	i tDocName="" QUIT ""
	do config(tDocName,docName)
	s error=$$addTemplateBackdrop(tDocName,docName)
	i error'="" QUIT error
	do addTemplateBlock("ewd:header","body","start",tDocName,docName)
	do addTemplateBlock("ewd:footer","body","end",tDocName,docName)
	do addTemplateBlock("ewd:head","head","start",tDocName,docName)
	do templateBodyTag(docName,tDocName)
	do includeBlocks(docName,tDocName)
	;
	if altTemplateName'="" if $$removeDocument^%zewdDOM(tDocName,0,0)
	;
	QUIT ""
	;
addTemplateBackdrop(templateDocName,docName)
	;
	new blockOID,blockOIDArray,bodyOID,divOID,docOID,found,id,nBlocks,newChildOID,nodeOID,nScripts,OIDArray,tOID
	;
	set docOID=$$getDocumentNode^%zewdDOM(docName)
	set tOID=$$getTagOID^%zewdCompiler("ewd:backdrop",templateDocName)
	i tOID="" QUIT ""
	set blockOID=$$importNode^%zewdDOM(tOID,"true",docOID)
	set bodyOID=$$getTagOID^%zewdCompiler("body",docName)
	i bodyOID="" s bodyOID=docOID
	set divOID=$$addIntermediateNode^%zewdCompiler4("div",bodyOID)
	set newChildOID=$$appendChild^%zewdDOM(blockOID,bodyOID)
	do removeIntermediateNodeeXtc^%zewdAPI(newChildOID,1)
	;	
rpt1 ;
	s nScripts=$$getTagsByName^%zewdCompiler("ewd:insertPage",docName,.OIDArray)
	i $d(OIDArray) d
	. set tOID=$o(OIDArray(""))
	. set divOID=$$removeChild^%zewdAPI(divOID)
	. set divOID=$$appendChild^%zewdDOM(divOID,tOID)
	. do removeIntermediateNodeeXtc^%zewdAPI(tOID,1)
	. do removeIntermediateNodeeXtc^%zewdAPI(divOID,1)
	k OIDArray
	s nScripts=$$getTagsByName^%zewdCompiler("ewd:insertBlock",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. s id=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("id",0,nodeOID),"l")
	. s blockOID=$$getTagByNameAndAttr("ewd:block","id",id,1,docName)
	. i blockOID'="" d
	. . set blockOID=$$removeChild^%zewdAPI(blockOID)
	. . set blockOID=$$appendChild^%zewdDOM(blockOID,nodeOID)
	. . do removeIntermediateNodeeXtc^%zewdAPI(blockOID,1)
	. do removeIntermediateNodeeXtc^%zewdAPI(nodeOID,1)
	;
	s found=$$includeFiles(docName,.phpVars)
	i found'=0,found'=1 QUIT found
	i found g rpt1 ; check to see if the include brought in any inserts (page or blocks)
	;
	QUIT ""
	;
getTagByNameAndAttr(tagName,attrName,attrValue,matchCase,docName)
	;
	n aValue,found,nodeOID,nOID,OIDArray
	;
	s nOID=$$getTagsByName^%zewdCompiler(tagName,docName,.OIDArray)
	s nodeOID="",found=0
	s matchCase=+$g(matchCase)
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  q:found
	. s aValue=$$getAttributeValue^%zewdDOM(attrName,0,nodeOID)
	. q:aValue=""
	. i 'matchCase s aValue=$$zcvt^%zewdAPI(aValue,"l"),attrValue=$$zcvt^%zewdAPI(attrValue,"l")
	. i aValue=attrValue s found=1 q
	i found QUIT nodeOID
	QUIT ""
	;
config(templateDocName,docName)
	;
	new attr,ok,override,overrideOID,pAttr,pOID,tAttr,tOID
	;
	set tOID=$$getTagOID^%zewdCompiler("ewd:config",templateDocName)
	QUIT:tOID=""
	set pOID=$$getTagOID^%zewdCompiler("ewd:config",docName)
	s ok=$$getAttributes^%zewdCompiler(tOID,.tAttr)
	s ok=$$getAttributes^%zewdCompiler(pOID,.pAttr)
	set overrideOID=$get(pAttr("overridetemplate"))
	if overrideOID="" set override="false"
	else  set override=$$getAttributeValue^%zewdDOM("overridetemplate",1,pOID)
	set attr=""
	for  set attr=$order(tAttr(attr)) quit:attr=""  do
	. if '$data(pAttr(attr)) do  quit
	. . new attrValue
	. . set attrValue=$$getAttributeValue^%zewdDOM(attr,1,tOID)
	. . do setAttribute^%zewdDOM(attr,attrValue,pOID)
	. if override="false" do  quit
	. . new attrValue
	. . set attrValue=$$getAttributeValue^%zewdDOM(attr,1,tOID)
	. . do setAttribute^%zewdDOM(attr,attrValue,pOID)
	. ; otherwise leave the current page attribute value
	;
	QUIT
	;
includeBlocks(docName,templateDocName)
	;
	new blockOID,filename,newChildOID,nodeOID,ntags,OIDArray,%stop,tid
	;
	set ntags=$$getTagsByName^%zewdCompiler("ewd:include",docName,.OIDArray)
	set nodeOID="",%stop=0
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do  quit:%stop
	. new id,nTemplateTags,templateOIDArray,templateNodeOID,%tstop
	. set id=$$getAttributeValue^%zewdDOM("id",1,nodeOID)
	. if id'="" do
	. . set nTemplateTags=$$getTagsByName^%zewdCompiler("ewd:include",templateDocName,.templateOIDArray)
	. . set templateNodeOID="",%tstop=0
	. . for  set templateNodeOID=$order(templateOIDArray(templateNodeOID)) quit:templateNodeOID=""  do  quit:%tstop
	. . . set tid=$$getAttributeValue^%zewdDOM("id",1,templateNodeOID)
	. . . set filename=$$getAttributeValue^%zewdDOM("file",1,templateNodeOID)
	. . . quit:tid'=id
    . . . if filename'="",$$hasChildNodes^%zewdDOM(templateNodeOID)="false" QUIT
	. . . set %tstop=1
	. . . set blockOID=$$importNode^%zewdDOM(templateNodeOID,"true",docOID)
	. . . set newChildOID=$$appendChild^%zewdDOM(blockOID,nodeOID)
	. . . do removeIntermediateNodeeXtc^%zewdAPI(newChildOID,1)
	. . . do removeIntermediateNodeeXtc^%zewdAPI(nodeOID,1)
	QUIT
	;
includeFiles(docName,phpVars)
	;
	new blockOID,docOID,%error,fcOID,filename,found,incDocName,incDocOID,incOID
	n newChildOID,nodeOID,ntags,ok,OIDArray,%stop,tagName
	;
	s found=0,%error=""
	set ntags=$$getTagsByName^%zewdCompiler("ewd:include",docName,.OIDArray)
	set nodeOID="",%stop=0
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do  quit:%stop  q:%error'=""
	. set filename=$$getAttributeValue^%zewdDOM("file",1,nodeOID)
	. if filename'="" do
	. . set incDocName="ewdInclude"
	. . quit:$$zcvt^%zewdAPI(filename,"L")'[".inc"
	. . q:$$getParentNode^%zewdDOM(nodeOID)=""
	. . set filename=inputPath_filename
	. . set %error=$$parseFile^%zewdHTMLParser(filename,incDocName,,.phpVars,1)
	. . if %error'="" QUIT
	. . s found=1
	. . set incDocOID=$$getDocumentNode^%zewdDOM(incDocName)
	. . s fcOID=$$getFirstChild^%zewdDOM(incDocOID)
	. . s tagName=$$getTagName^%zewdDOM(fcOID)
	. . i tagName'="ewd:content" s fcOID=$$insertNewIntermediateElement^%zewdDOM(incDocOID,"ewd:content",incDocOID)
	. . set docOID=$$getDocumentNode^%zewdDOM(docName)
	. . set incOID=$$getTagOID^%zewdCompiler("ewd:content",incDocName)
	. . set blockOID=$$importNode^%zewdDOM(incOID,"true",docOID)
	. . set newChildOID=$$appendChild^%zewdDOM(blockOID,nodeOID)
	. . do removeIntermediateNode^%zewdCompiler4(newChildOID)
	. . do removeIntermediateNode^%zewdCompiler4(nodeOID)
	. . set ok=$$removeDocument^%zewdDOM(incDocName,0,0)
	;
	i %error'="" QUIT %error
	QUIT found
	;
templateBodyTag(docName,templateDocName)
	;
	new attrName,bodyAttrs,bodyOID,ok,templateAttrValue,templateBodyAttrs,templateBodyOID
	;
	set bodyOID=$$getTagOID^%zewdCompiler("body",docName)
	QUIT:bodyOID=""
	s ok=$$getAttributes^%zewdCompiler(bodyOID,.bodyAttrs)
	set templateBodyOID=$$getTagOID^%zewdCompiler("ewd_body",templateDocName)
	i templateBodyOID="" QUIT
	s ok=$$getAttributes^%zewdCompiler(templateBodyOID,.templateBodyAttrs)
	set attrName=""
	for  set attrName=$order(templateBodyAttrs(attrName)) quit:attrName=""  do
	. if '$data(bodyAttrs(attrName)) do  quit
	. . ; template attribute doesnt exist in the <body> tag so add it
	. . new attrValue
	. . set attrValue=$$getAttributeValue^%zewdDOM(attrName,1,templateBodyOID)
	. . do setAttribute^%zewdDOM(attrName,attrValue,bodyOID)
	. if $extract(attrName,1,2)="on" do  quit
	. . ; append onxxx event handler from template to start of that in <body> tag
	. . new bodyAttrValue,newAttrValue
	. . set templateAttrValue=$$getAttributeValue^%zewdDOM(attrName,1,templateBodyOID)
	. . set bodyAttrValue=$$getAttributeValue^%zewdDOM(attrName,1,bodyOID)
	. . set newAttrValue=templateAttrValue_" ; "_bodyAttrValue
	. . do setAttribute^%zewdDOM(attrName,newAttrValue,bodyOID)
	. ; otherwise the template tag attribute overrides the one in the <body>
	. set templateAttrValue=$$getAttributeValue^%zewdDOM(attrName,1,templateBodyOID)
	. do setAttribute^%zewdDOM(attrName,templateAttrValue,bodyOID)
	QUIT
	;
addTemplateBlock(templateBlockName,parentTagName,position,templateDocName,docName)
	;
	new thNodeOID,headerOID,bodyOID,docOID,firstChildOID,newChildOID
	;
	set docOID=$$getDocumentNode^%zewdDOM(docName)
	set thNodeOID=$$getTagOID^%zewdCompiler(templateBlockName,templateDocName)
	QUIT:thNodeOID="" 
	set headerOID=$$importNode^%zewdDOM(thNodeOID,"true",docOID)
	set bodyOID=$$getTagOID^%zewdCompiler(parentTagName,docName)
	i bodyOID="" QUIT
	if position="start" do
	. set firstChildOID=$$getFirstChild^%zewdDOM(bodyOID)
	. if firstChildOID="" do
	. . set newChildOID=$$appendChild^%zewdDOM(headerOID,bodyOID) 
	. else  do
	. . set newChildOID=$$insertBefore^%zewdDOM(headerOID,firstChildOID)
	. do removeIntermediateNode^%zewdCompiler4(newChildOID)
	if position="end" do
	. set newChildOID=$$appendChild^%zewdDOM(headerOID,bodyOID) 
	. do removeIntermediateNode^%zewdCompiler4(newChildOID)
	QUIT
	;
getFormFields(submitOID)
 ;
 ; Find the parent <form> for the submit button, and return a list of
 ; form field names for this form <input>, <select> and <textarea>
 ;
 new nameList,parentOID,nFields,OIDArray,fieldName,fieldType,fieldNo
 ;
 set nameList="",fieldNo=0
 set parentOID=submitOID
 for  set parentOID=$$getParentNode^%zewdDOM(parentOID) quit:$$getNodeName^%zewdDOM(parentOID)="form"  quit:parentOID=""
 if parentOID="" QUIT ""
 for fieldName="input","select","textarea","div" do
 . new nodeOID,type
 . s type="text"
 . if fieldName="select" set type="select"
 . if fieldName="textarea" set type="textarea"
 . i fieldName="div" s type="dojotextarea"
 . set nFields=$$getDescendentsByName^%zewdCompiler(fieldName,parentOID,.OIDArray)
 . set nodeOID=""
 . for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
 . . new fieldName,typex
 . . set fieldName=$$getAttributeValue^%zewdDOM("name",0,nodeOID)
 . . i type="dojotextarea",$$getAttribute^%zewdDOM("dojoType",nodeOID)'="dijit.form.Textarea" q
 . . i type="dojotextarea" s type="textarea"
 . . i fieldName="" set fieldName=$$getAttributeValue^%zewdDOM("id",0,nodeOID)
 . . set fieldNo=fieldNo+1
 . . if fieldName="" do
 . . . set fieldName="unnamedField"_fieldNo
 . . . do setAttribute^%zewdDOM("name",fieldName,nodeOID)
 . . set typex=$$getAttributeValue^%zewdDOM("type",0,nodeOID)
 . . if typex'="" set type=$$zcvt^%zewdAPI(typex)
 . . if type="select",$$getAttributeValue^%zewdDOM("multiple",0,nodeOID)="multiple" set type="selectMultiple"
 . . if fieldName["&php;" set fieldName=$piece(fieldName,"&php;",1)_"$"
 . . set nameList(fieldName)=type
 s nameList("ewd_pressed")="hidden"
 set fieldName=""
 for  set fieldName=$order(nameList(fieldName)) quit:fieldName=""  do
 . new type
 . set type=nameList(fieldName)
 . set nameList=nameList_fieldName_"|"_type_"`"
 ;
 QUIT nameList
	;
getChildNo(nodeOID)
	;
	new childNo,%stop,incomingChildTagName,parentOID,childOID,childTagName
	;
	set childNo=0,%stop=0
	set incomingChildTagName=$$getTagName^%zewdDOM(nodeOID)
	set parentOID=$$getParentNode^%zewdDOM(nodeOID)
	;
	set childOID=$$getFirstChild^%zewdDOM(parentOID)
	set childTagName=$$getTagName^%zewdDOM(childOID)
	if childTagName=incomingChildTagName set childNo=childNo+1
	if nodeOID=childOID QUIT "[1]"
	;
	for  set childOID=$$getNextSibling^%zewdDOM(childOID) quit:childOID=""  do  quit:%stop
	. set childTagName=$$getTagName^%zewdDOM(childOID)
	. if childTagName=incomingChildTagName set childNo=childNo+1
	. if nodeOID=childOID set %stop=1
	QUIT "["_childNo_"]"
	;
getChildTagsByName(tagName,parentOID,OIDArray)
	;
	new nlOID,length,i
	;
	kill OIDArray
	set tagName=$$zcvt^%zewdAPI(tagName,"L")
	set nlOID=$$getElementsByTagName^%zewdDOM(tagName,parentOID)
	set length=$$getNodeListAttribute^%zewdDOM(nlOID,"length")
	i length>0 for i=1:1:length set OIDArray($$item^%eDOMNodeList(i-1,nlOID,""))=""
	QUIT length
	;
dynamicMenu(docName,phpHeaderArray,nextPageList,technology)
	;
	new class,greyIf,groupName,help,menuOptions,ntags,nodeOID,OIDArray,staticLink
	; 
	; <ewd:dynamicMenu groupName="main" text="Configuration" nextpage="config" defaultSelected="true" help="This is some help" class="tabClass">
	; 
	set ntags=$$getTagsByName^%zewdCompiler("ewd:dynamicmenu",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. new text,nextPage,defaultSelected,position
	. set text=$$getAttributeValue^%zewdDOM("text",1,nodeOID)
	. set nextPage=$$getAttributeValue^%zewdDOM("nextpage",1,nodeOID)
	. s staticLink=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("staticlink",1,nodeOID),"l")
	. i staticLink="true" s nextPage=nextPage_"?static"
	. if nextPage="" set nextPage="*"
	. set defaultSelected=$$getAttributeValue^%zewdDOM("defaultselected",1,nodeOID)
	. if defaultSelected="" do
	. . new pageName
	. . set pageName=$$zcvt^%zewdAPI($piece(filename,".ewd",1),"L")
	. . if pageName=$$zcvt^%zewdAPI($p(nextPage,"?",1),"L") set defaultSelected="true"
	. set defaultSelected=defaultSelected="true"
	. set position=$$getAttributeValue^%zewdDOM("position",1,nodeOID)
	. set greyIf=$$getAttributeValue^%zewdDOM("greyif",1,nodeOID)
	. set help=$$getAttributeValue^%zewdDOM("help",1,nodeOID)
	. s class=$$getAttributeValue^%zewdDOM("class",1,nodeOID)
	. s groupName=$$getAttributeValue^%zewdDOM("groupname",1,nodeOID)
	. i groupName="" s groupName="def"
	. set menuOptions(groupName,position)=text_$char(1)_nextPage_$char(1)_defaultSelected_$char(1)_greyIf_$char(1)_help_$c(1)_class
	. if nextPage'="" set nextPageList(nextPage)=""
	. i nextPage'="",staticLink'="true" set nextPageList(nextPage)=""
	. set nodeOID=$$removeChild^%zewdAPI(nodeOID,1)
	;
	do createPHPMenuOptionHeader^%zewdCompiler8(.menuOptions,.phpHeaderArray,technology,docName)
	QUIT
	;
checkbox(docName,technology) ;
	;
	; Find all <input type=checkbox> tags and code to preselect the right value
	;
	new id,ntags,OIDArray,nodeOID,cbName,autocheck,checkUsing,disabled
	; 
	set ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. new name,type,value,attrValue
	. set type=$$getAttributeValue^%zewdDOM("type",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(type,"l")'="checkbox"
	. set name=$$getAttributeValue^%zewdDOM("name",0,nodeOID)
	. s id=$$getAttributeValue^%zewdDOM("id",1,nodeOID)
	. i id="",name="" s name="ewdUnnamed"_$p(nodeOID,"-",2)
	. set cbName=name
	. i id="" d setAttribute^%zewdDOM("id",name,nodeOID)
	. i id'="",name="" s cbName=id,name=id
	. set value=$$getAttributeValue^%zewdDOM("value",1,nodeOID) 
	. set autocheck=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("autocheck",1,nodeOID),"L")
	. if autocheck="" set autocheck="yes"
	. if autocheck="off" set autocheck="no"
	. if autocheck="on" set autocheck="yes"
	. do removeAttribute^%zewdAPI("autocheck",nodeOID,1)
	. set checkUsing=$$getAttributeValue^%zewdDOM("checkusing",1,nodeOID)
	. do removeAttribute^%zewdAPI("checkusing",nodeOID,1)
	. set disabled=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("disabled",1,nodeOID),"L")
	. if value'="",autocheck="yes" do
	. . if checkUsing'="" do
	. . . do
	. . . . if $extract(checkUsing,1)="$" set checkUsing=$extract(checkUsing,2,$length(checkUsing))
	. . . . set attrValue="#($s($g("_checkUsing_")="""_value_""":""checked='checked'"",1:""""))#"
	. . else  do
	. . . n sname
	. . . s sname=$tr(name,".","_")
	. . . do
	. . . . n svalue
	. . . . i name["&php;" d  q
	. . . . . n varName
	. . . . . s varName=$$getPHPVarName(name,1)
	. . . . . s name=$p(name,"&php;",1)
	. . . . . s sname=$tr(name,".","_")
	. . . . . set attrValue="#($s($d(%session.Data(""ewd_selected"","""_sname_"""_"_varName_","""_value_""")):""checked='checked'"",$d(^%zewdSession(""session"",sessid,""ewd_selected"","""_sname_"""_"_varName_","""_value_""")):""checked='checked'"",1:""""))#"
	. . . . . i technology="wl"!(technology="gtm") set attrValue="#($s($d(^%zewdSession(""session"",sessid,""ewd_selected"","""_sname_"""_"_varName_","""_value_""")):""checked='checked'"",1:""""))#"
	. . . . s svalue=""""_value_""""
	. . . . i value["&php;" s svalue=$$getPHPVarName(value,1)
	. . . . set attrValue="#($s($d(%session.Data(""ewd_selected"","""_sname_""","_svalue_")):""checked='checked'"",$d(^%zewdSession(""session"",sessid,""ewd_selected"","""_sname_""","_svalue_")):""checked='checked'"",1:""""))#"
	. . . . set attrValue="#($s($d(^%zewdSession(""session"",sessid,""ewd_selected"","""_sname_""","_svalue_")):""checked='checked'"",1:""""))#"
	. . do setAttribute^%zewdDOM("mgwVarXXY",attrValue,nodeOID)
	. do setAttribute^%zewdDOM("name",cbName,nodeOID)
	QUIT
	;
getPHPVarName(phpName,removeDollar)
	n svalue,varNo
	i phpName'["&php;" QUIT phpName
	s varNo=$p(phpName,"&php;",2)
	s svalue=$g(phpVars(varNo))
	i $g(removeDollar),svalue["$" s svalue=$p(svalue,"$",2)
	s svalue=$$stripSpaces^%zewdAPI(svalue)
	i $e(svalue,1)="#" d
	. n esc
	. s esc=0
	. i $e(svalue,2)="\" d
	. . s esc=1
	. . s value="#"_$e(svalue,3,1000)
	. . i svalue["." d
	. . n object,property
	. . s svalue=$e(svalue,2,$l(value))
	. . s object=$p(svalue,".",1)
	. . s property=$p(svalue,".",2)
	. . i object["[" d
	. . . n index
	. . . s index=$p(object,"[",2)
	. . . s index=$p(index,"]",1)
	. . . s object=$p(object,"[",1)
	. . . i $e(index,1)="$" s index=$e(index,2,$l(index))
	. . . s svalue="$$getResultSetValue^%zewdAPI("""_object_""","_index_","""_property_""",sessid)"
	. . e  d
	. . . i $e(svalue,1,3)="tmp" s svalue="$$getTmpSessionValue^%zewdAPI2("""_svalue_""",sessid)" q
	. . . s svalue="$$getSessionValue^%zewdAPI("""_svalue_""",sessid)"
	. e  d
	. . i $e(svalue,2,4)="tmp" s svalue="$$getTmpSessionValue^%zewdAPI2("""_$e(svalue,2,$l(svalue))_""",sessid)" q
	. . s svalue="$$getSessionValue^%zewdAPI("""_$e(svalue,2,$l(svalue))_""",sessid)"
	. i esc d
	. . s svalue="$$escapeQuotes^%zewdAPI("_svalue_")"
	QUIT svalue
	;
radio(docName,technology) ;
	;
	; Find all <input type=radio> tags and code to preselect the right value
	;
	new attrValue,autocheck,checkUsing,id,name,nodeOID,ntags,type,OIDArray,value
	; 
	set ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. s attrValue=""
	. set type=$$getAttributeValue^%zewdDOM("type",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(type,"l")'="radio"
	. set name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. s id=$$getAttributeValue^%zewdDOM("id",1,nodeOID)
	. i id="",name="" s name="ewdUnnamed"_$p(nodeOID,"-",2)
	. quit:name=""
	. set value=$$getAttributeValue^%zewdDOM("value",1,nodeOID)
	. i id="",value'="" d setAttribute^%zewdDOM("id",name,nodeOID)
	. i id'="",name="" d setAttribute^%zewdDOM("name",id,nodeOID)
	. set autocheck=$$zcvt^%zewdAPI($$getAttributeValue^%zewdDOM("autocheck",1,nodeOID),"L")
	. if autocheck="" set autocheck="yes"
	. if autocheck="off" set autocheck="no"
	. if autocheck="on" set autocheck="yes"
	. do removeAttribute^%zewdAPI("autocheck",nodeOID,1)
	. set checkUsing=$$getAttributeValue^%zewdDOM("checkusing",1,nodeOID)
	. do removeAttribute^%zewdAPI("checkusing",nodeOID,1)
	. if value'="",autocheck="yes" do
	. . if checkUsing'="" do
	. . . do
	. . . . if $extract(checkUsing,1)="$" set checkUsing=$extract(checkUsing,2,$length(checkUsing))
	. . . . i $e(value,1,5)="&php;" d
	. . . . . s value=$$getPHPVarName(value,1)
	. . . . e  d
	. . . . . s value=""""_value_""""
	. . . . set attrValue="#($s($g("_checkUsing_")="_value_":""checked='checked'"",1:""""))#"
	. . do
	. . . do
	. . . . n svalue
	. . . . s svalue=""""_value_""""
	. . . . i value["&php;" s svalue=$$getPHPVarName(value,1)
	. . . . set attrValue="#($s($$getSessionValue^%zewdAPI("""_name_""",sessid)="_svalue_":""checked='checked'"",1:""""))#"
	. . do setAttribute^%zewdDOM("mgwVarXXY",attrValue,nodeOID)
	QUIT
	;
button(docName,technology,multilingual,inputPath,textidList) ;
	;
	; Process nextpage attribute for <input type=button>
	; 
	n appendOnclick,appName,attr,bodyOID,childOID,confirm,confirmText,dlim,docOID,divOID
	n event,formOID,headOID,hiddenForms,inputOID,jsOID,n,name,nextpage,nodeOID,nnvp
	n ntags,nvp,OIDArray,OIDArray2,onclick,pageName,styleOID,submitOID,text,textOID,type,v
	; 
	s appName=inputPath
	s dlim=$$getDelim^%zewdCompiler()
	s appName=$p(appName,$$getApplicationRootPath^%zewdCompiler(),2)
	s appName=$p(appName,dlim,2)
	; 
	set docOID=$$getDocumentNode^%zewdDOM(docName)
	set ntags=$$getTagsByName^%zewdCompiler("input",docName,.OIDArray)
	set ntags=$$getTagsByName^%zewdCompiler("select",docName,.OIDArray2)
	m OIDArray=OIDArray2
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. kill nvp
	. set type=$$getAttributeValue^%zewdDOM("type",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(type,"L")="submit"
	. quit:$$zcvt^%zewdAPI(type,"L")="image"
	. set nextpage=$$getAttributeValue^%zewdDOM("nextpage",1,nodeOID)
	. quit:nextpage=""
	. if $extract(nextpage,1)="$" do  quit
	. . new onclick,event
	. . set event=$$getAttributeValue^%zewdDOM("event",1,nodeOID)
	. . s event=$$zcvt^%zewdAPI(event,"l")
	. . if event="",$$zcvt^%zewdAPI(type,"L")'="button" set event="onclick"
	. . set onclick=$$getAttributeValue^%zewdDOM(event,1,nodeOID)
	. . if onclick'="" set onclick=onclick_" ; "
	. . do
	. . . new scriptOID,text,parentOID
	. . . set scriptOID=$$createElement^%zewdDOM("script",docOID)
	. . . do setAttribute^%zewdDOM("language","cache",scriptOID)
	. . . do setAttribute^%zewdDOM("runat","server",scriptOID)
	. . . set scriptOID=$$insertBefore^%zewdDOM(scriptOID,nodeOID)
	. . . set text=" s url=..Link("_$extract(nextpage,2,$length(nextpage))_"_"".csp"")"_$char(13,10)
	. . . set text=text_" s click=""document.location='""_url_""'"""
	. . . set textOID=$$createTextNode^%zewdDOM(text,docOID)
	. . . set textOID=$$appendChild^%zewdDOM(textOID,scriptOID)
	. . . set onclick=onclick_"#(click)#"
	. . do setAttribute^%zewdDOM("onclick",onclick,nodeOID)
	. . do removeAttribute^%zewdAPI("nextpage",nodeOID,1)
	. ;
	. s name=$$getAttributeValue^%zewdDOM("name",0,nodeOID)
	. i name="" s name=$$getAttributeValue^%zewdDOM("id",0,nodeOID)
	. i name="" s name="ewdUndefName"
	. set name=$$replaceAll^%zewdHTMLParser(name,"&php;","")
	. set pageName=$piece(nextpage,"?",1)
	. set pageName=$piece(pageName,".ewd",1)
	. set nvp=$piece(nextpage,"?",2,255)
	. if $$zcvt^%zewdAPI(nvp,"l")["ewdallfields" d
	. . n fn,ft,i,nameList,np,str
	. . s nameList=$$getFormFields(nodeOID)
	. . s np=$l(nameList,"`")
	. . f i=1:1:np d
	. . . s str=$p(nameList,"`",i)
	. . . s fn=$p(str,"|",1)
	. . . s ft=$p(str,"|",2)
	. . . q:fn=""
	. . . i (ft="text")!(ft="select")!(ft="radio")!(ft="hidden")!(ft="password")!(ft="textarea") d
	. . . . s nvp(fn)="javascript.this.form."_fn_".value"
	. if nvp="" do
	. . ;
	. else  do
	. . set nvp=$$replaceAll^%zewdHTMLParser(nvp,"&php;",$char(1))
	. . set nvp=$$replaceAll^%zewdHTMLParser(nvp,"&cspVar;",$char(2))
	. . set nnvp=$length(nvp,"&")
	. . for i=1:1:nnvp do
	. . . new %p,n,v
	. . . set %p=$piece(nvp,"&",i)
	. . . q:$$zcvt^%zewdAPI(%p,"l")="ewdallfields"
	. . . set n=$piece(%p,"=",1)
	. . . set v=$piece(%p,"=",2)
	. . . set v=$$replaceAll^%zewdHTMLParser(v,$char(1),"&php;")
	. . . set v=$$replaceAll^%zewdHTMLParser(v,$char(2),"&cspVar;")
	. . . set v=$$replaceVars^%zewdHTMLParser(v,.cspVars,.phpVars,technology)
	. . . set nvp(n)=v
	. ;
	. i '$d(hiddenForms("form",name)) d
	. . s headOID=$$getTagOID^%zewdCompiler("head",docName)
	. . n language,njs,jsArray,noid,%stop,textOID
	. . s njs=$$getTagsByName^%zewdCompiler("script",docName,.jsArray)
	. . s noid="",%stop=0
	. . f  s noid=$o(jsArray(noid)) q:noid=""  d  q:%stop
	. . . s language=$$getAttributeValue^%zewdDOM("language",1,noid)
	. . . q:$$zcvt^%zewdAPI(language,"L")'["javascript"
	. . . q:$$getFirstChild^%zewdDOM(noid)=""
	. . . s %stop=1
	. . ;
	. . set jsOID=noid
	. . if jsOID="" do
	. . . new %attr
	. . . set %attr("language")="javascript"
	. . . s %attr("id")="ewdButtonJS"
	. . . i headOID="",$g(config("pageType"))="ajax" d
	. . . . ; create javascript node as last child of outermost parent tag
	. . . . n fparentOID,parentOID
	. . . . s parentOID=nodeOID
	. . . . f  s fparentOID=$$getParentNode^%zewdDOM(parentOID) q:fparentOID=docOID  s parentOID=fparentOID
	. . . . s headOID=parentOID
	. . . set jsOID=$$addElementToDOM^%zewdDOM("script",headOID,,.%attr,";")
	. . set childOID=$$getLastChild^%zewdDOM(jsOID)
	. . set text=$$getData^%zewdDOM(childOID)
	. . i $l($g(text))>4000 d
	. . . new nextSiblingOID
	. . . set nextSiblingOID=$$getNextSibling^%zewdDOM(childOID)
	. . . if nextSiblingOID'="" d
	. . . . set childOID=nextSiblingOID
	. . . . set text=$$getData^%zewdDOM(childOID)
	. . . . set:text=" " text=""
	. . ;
	. . i $l(text)>3000 d
	. . . n dlim,np,nsOID,text1,text2
	. . . s text1=$e(text,1,3000)
	. . . s text2=$e(text,(3000+1),$l(text))
	. . . s dlim=$c(13,10)
	. . . i $$os^%zewdHTMLParser()="unix" s dlim=$c(10)
	. . . s text1=text1_$p(text2,dlim,1)_$c(13,10)
	. . . s np=$l(text2,dlim)
	. . . s text2=$p(text2,dlim,2,np)
	. . . set textOID=$$modifyTextData^%zewdDOM(text1,childOID)
	. . . set textOID=$$createTextNode^%zewdDOM(text2,docOID)
	. . . s nsOID=$$getNextSibling^%zewdDOM(childOID)
	. . . i nsOID="" d
	. . . . s textOID=$$appendChild^%zewdDOM(textOID,jsOID)
	. . . e  d
	. . . . s textOID=$$insertBefore^%zewdDOM(textOID,nsOID)
	. . . s text=text2
	. . . s childOID=textOID
	. . set text=text_$char(13,10)_"function ewdNP"_name_"("
	. . if $order(nvp(""))="" set text=text_" "
	. . set n=""
	. . for  set n=$order(nvp(n)) quit:n=""  do
	. . . set text=text_n_","
	. . set text=$extract(text,1,$length(text)-1)_$s($order(nvp(""))="":"",1:",")_"confirmText) {"_$char(13,10)
	. . set n=""
	. . for  set n=$order(nvp(n)) quit:n=""  set text=text_"  document.ewdNP"_name_"Form."_n_".value = "_n_" ;"_$char(13,10)
	. . set text=text_"  document.ewdNP"_name_"Form.ewd_action.value='"_name_"submit' ;"_$char(13,10) 
	. . set text=text_"  document.ewdNP"_name_"Form.ewd_pressed.value='"_name_"submit' ;"_$char(13,10)
    . . set text=text_"  if ((confirmText != null) && (confirmText != ''))"_$char(13,10)
    . . set text=text_"     {"_$char(13,10)
	. . set text=text_"        confirmText = EWD.utils.replace(confirmText,""&#39;"",""'"") ;"_$char(13,10)
	. . set text=text_"        confirmText = EWD.utils.replace(confirmText,'&#34;','""') ;"_$char(13,10)
	. . set text=text_"        ok=confirm(confirmText) ;"_$char(13,10)
	. . set text=text_"        if (ok) document.ewdNP"_name_"Form.submit() ;"_$char(13,10)
    . . set text=text_"     }"_$char(13,10)
    . . set text=text_"  else"_$char(13,10)
	. . set text=text_"     document.ewdNP"_name_"Form.submit() ;"_$char(13,10)
	. . set text=text_"}"
	. . set textOID=$$modifyTextData^%zewdDOM(text,childOID)
	. set confirm=$$getAttributeValue^%zewdDOM("confirm",1,nodeOID)
	. set confirmText=$$getAttributeValue^%zewdDOM("confirmtext",1,nodeOID)
	. d
	. . set:confirmText["'" confirmText=$$replaceAll^%zewdHTMLParser(confirmText,"'","\&#39;")
	. . set:confirmText["""" confirmText=$$replaceAll^%zewdHTMLParser(confirmText,"""","\&#34;")
	. ;
	. set event=$$getAttributeValue^%zewdDOM("event",1,nodeOID)
	. s event=$$zcvt^%zewdAPI(event,"l")
	. if event="",$$zcvt^%zewdAPI(type,"L")="button" set event="onclick"
	. set onclick=$$getAttributeValue^%zewdDOM(event,1,nodeOID)
	. if onclick'="" set onclick=onclick_" ; "
	. set onclick=onclick_"ewdNP"_name_"("
	. if $order(nvp(""))="" set onclick=onclick_" "
	. set n=""
	. for  set n=$order(nvp(n)) quit:n=""  do
	. . set v=nvp(n)
	. . if v["document." do  quit
	. . . set onclick=onclick_v_","
	. . if $$zcvt^%zewdAPI($extract(v,1,11),"l")="javascript." do  quit
	. . . set v=$extract(v,12,$length(v))
	. . . set onclick=onclick_v_","
	. . if $e(v,1)="$"!($e(v,1)="#") do
	. . . d
	. . . . if $extract(v,1)="$" do
	. . . . . set v=$extract(v,2,$length(v))
	. . . . else  do
	. . . . . if $extract(v,1)="#" set v="$$getSessionValue^%zewdAPI("""_$extract(v,2,$length(v))_""",sessid)"
	. . . . set onclick=onclick_"'#("_v_")#',"
	. . else  do
	. . . set onclick=onclick_"'"_v_"',"
    . set onclick=$extract(onclick,1,$length(onclick)-1)
	. set onclick=onclick_$s($order(nvp(""))="":"",1:",")_"'"_confirmText_"')"
	. set appendOnclick=$$getAttributeValue^%zewdDOM("appendonclick",1,nodeOID)
	. if appendOnclick'="" do
	. . set onclick=onclick_" ; "_appendOnclick
	. . do removeAttribute^%zewdAPI("appendonclick",nodeOID,1)
	. do setAttribute^%zewdDOM(event,onclick,nodeOID)
	. do removeAttribute^%zewdAPI("nextpage",nodeOID,1)
	. do removeAttribute^%zewdAPI("event",nodeOID,1)
	. ;
	. if '$d(hiddenForms("form",name)) d
	. . set bodyOID=$$getTagOID^%zewdCompiler("body",docName)
	. . i bodyOID="" s bodyOID=docOID
	. . ;set attr("id")="hiddenForm"
	. . s attr("style")="visibility:hidden; display:none"
	. . set divOID=$$addElementToDOM^%zewdDOM("div",bodyOID,,.attr,"")
	. . set attr("method")="post"
	. . set attr("action")="ewd"
	. . set attr("name")="ewdNP"_name_"Form"
	. . set formOID=$$addElementToDOM^%zewdDOM("form",divOID,,.attr,"")
	. . set n=""
	. . for  set n=$order(nvp(n)) quit:n=""  do
	. . . new inputOID
	. . . set attr("type")="hidden"
	. . . set attr("name")=n
	. . . set attr("value")=""
	. . . set inputOID=$$addElementToDOM^%zewdDOM("input",formOID,,.attr,"")
	. . k attr
	. . set attr("type")="submit"
	. . set attr("name")=name_"submit"
	. . set attr("value")="submit"
	. . set attr("nextpage")=pageName
	. . set submitOID=$$addElementToDOM^%zewdDOM("input",formOID,,.attr,"")
	. . set hiddenForms("form",name)=formOID
	. . set hiddenForms("form",name,"submitOID")=submitOID
	. for attr="confirm","confirmtext","action" do
	. . new value
	. . set value=$$getAttributeValue^%zewdDOM(attr,1,nodeOID)
	. . if value'="" do
	. . . i attr="action" do setAttribute^%zewdDOM(attr,value,hiddenForms("form",name,"submitOID"))
	. . . do removeAttribute^%zewdAPI(attr,nodeOID,1)
	. i $l($g(text))>4000 d
	.. new currTextOID,nextSiblingOID,parentOID
	.. set textOID=$$modifyTextData^%zewdDOM(text,childOID)
	.. set parentOID=$$getParentNode^%zewdDOM(textOID)
	.. set nextSiblingOID=$$getNextSibling^%zewdDOM(textOID)
	.. set text=" "
	.. set textOID=$$createTextNode^%zewdDOM(text,docOID)
	.. if nextSiblingOID'="" set (textOID,childOID)=$$insertBefore^%zewdDOM(textOID,nextSiblingOID) if 1
	.. else  set (textOID,childOID)=$$appendChild^%zewdDOM(textOID,parentOID)
	;
	QUIT
	;
form(docName,technology,filename,outputPath,hasSubDirectories) ;
	;
	; Find all <form action=ewd> tags, modify action and add hidden fields
	; 
	new action,attr,defSub,hidOID,method,nodeOID,ntags,OIDArray,rootPath,url,urlRoot,useRootURL
	;
	set ntags=$$getTagsByName^%zewdCompiler("form",docName,.OIDArray)
	s useRootURL=$$getUseRootURL^%zewdCompiler()
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. k action,attr,hidOID,rootPath,url,urlRoot
	. s defSub=$$getAttributeValue^%zewdDOM("defaultsubmit",1,nodeOID)
	. set action=$$getAttributeValue^%zewdDOM("action",1,nodeOID)
	. quit:action'="ewd"
	. d
	. . s action=$$getRootURL^%zewdCompiler("gtm")_app_"/"_$p(filename,".ewd",1)_".mgwsi?"
	. . s action=action_"ewd_token=#($$getSessionValue^%zewdAPI(""ewd_token"",sessid))#" ;&n=#(tokens("""_$tr(pageName,"'","")_"""))#"
	. if useRootURL,$get(hasSubDirectories) do
	. . set rootPath=$$getOutputRootPath^%zewdCompiler(technology)
	. . set url=$piece(outputPath,rootPath,2)
	. . set url=$translate(url,"\","/")
	. . if $extract(url,$length(url))'="/" set url=url_"/"
	. . set urlRoot=$$getRootURL^%zewdCompiler(technology)
	. . if $extract(urlRoot,$length(urlRoot))="/" set urlRoot=$extract(urlRoot,1,$length(urlRoot)-1)
	. . set action=urlRoot_url_action
	. do setAttribute^%zewdDOM("action",action,nodeOID)
	. ; <input type=hidden name="ewd_token" value="<?= $ewd_session["ewd_token"] ?>">
 	. ; <input type=hidden name="ewd_action" value="">
	. set attr("type")="hidden"
	. set attr("name")="ewd_action"
	. set attr("value")=defSub
	. set hidOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr,"")
	. set attr("type")="hidden"
	. set attr("name")="ewd_pressed"
	. set attr("value")=defSub
	. set hidOID=$$addElementToDOM^%zewdDOM("input",nodeOID,,.attr,"")
	. ;
	. set method=$$getAttributeValue^%zewdDOM("method",1,nodeOID)
	. quit:$$zcvt^%zewdAPI(method,"l")'="uploadfile"
	. ; method=post enctype="multipart/form-data" 
	. do setAttribute^%zewdDOM("method","post",nodeOID)
	. do setAttribute^%zewdDOM("enctype","multipart/form-data",nodeOID)
	QUIT
	;
