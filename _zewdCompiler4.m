%zewdCompiler4	; Enterprise Web Developer Compiler : Tag Processing Logic
 ;
 ; Product: Enterprise Web Developer (Build 876)
 ; Build Date: Tue, 26 Jul 2011 15:46:32
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
 ;
 QUIT
 ;
 ;
getAttrValue(attrName,attrValues,technology)
 ;
 n attrValue
 ;
 i $g(attrName)="" d  QUIT attrValue
 . s attrValue=""""""
 s attrName=$$zcvt^%zewdAPI(attrName,"l")
 s attrValue=$g(attrValues(attrName))
 i attrValue="" s attrValue=""""""
 QUIT attrValue
 ;
comment(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:comment>A comment that will be removed at compile time</ewd:comment>
	;
	i $$removeChild^%zewdAPI(nodeOID)
	;
	QUIT
 ;
initialiseArray(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:initialiseArray arrayName="myArray">
	;
	n arrayName,serverOID,text
	;
	set arrayName=$$getAttrValue("arrayname",.attrValues,technology)
	;
	i $e(arrayName,1)="""" s arrayName=$e(arrayName,2,$l(arrayName)-1)
	s text=" k "_arrayName
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
setArrayValue(nodeOID,attrValues,docOID,technology)
	;
	;  <ewd:setArrayValue arrayName="myArray" index="$no" value="$type">
	;  <ewd:setArrayValue arrayName="myArray" param1="1" param2="$no" value="$type">
	;
	n arrayName,index,nparams,param,parentOID,serverOID,subs,pval,text,value
	;
	set arrayName=$$getAttrValue("arrayname",.attrValues,technology)
	set value=$$getAttrValue("value",.attrValues,technology)
	set index=$$getAttrValue("index",.attrValues,technology)
	s param="param",subs="",nparams=0
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. s nparams=nparams+1
	. i $e(pval,1,5)="""&php" s pval=$$substitute^%zewdCompiler7(pval,.phpVars,technology)
	. s subs=subs_","_pval
	i $e(arrayName,1)="""" s arrayName=$e(arrayName,2,$l(arrayName)-1)
	i index'="""""" d
	. s text=" s "_arrayName_"("_index_")="_value
	. s text=" s %ewdVar("""_arrayName_""","""_index_""")="_value
	e  d
	. s text=" s %ewdVar("""_arrayName_""""_subs_")="_value
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	d removeIntermediateNode(nodeOID)
	i $$getTagName^%zewdDOM(parentOID)="ewd:tabmenuarray" d
	. i '$$hasChildCustomTags(parentOID) d removeIntermediateNode(parentOID)
	;
	QUIT
	;
hasChildCustomTags(nodeOID)
 ;
 n childOID,hasChildElements,nodeType,tagName
 ;
 s childOID="",hasChildElements=0
 f  s childOID=$$getNextChild^%zewdSchemaForm(nodeOID,childOID) q:childOID=""  d  q:hasChildElements
 . s nodeType=$$getNodeType^%zewdDOM(childOID)
 . i nodeType'=1 q
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName["ewd:" s hasChildElements=1
 QUIT hasChildElements
instantiate(nodeOID,attrValues,docOID,technology)
	;
	;  <ewd:instantiate name="myArray" type="array" size="64">
	;  <ewd:instantiate name="myString" type="String">
	;  <ewd:instantiate name="myInt" type="int">
	;  <ewd:instantiate name="myInt" type="int" initialvalue="1">
	;
	n name,data,initialValue,newOID,procInsOID,text,textOID,type,value
	set name=$$getAttrValue("name",.attrValues,technology)
	set size=$$getAttrValue("size",.attrValues,technology)
	set type=$$getAttrValue("type",.attrValues,technology)
	set initialValue=$$getAttrValue("initialvalue",.attrValues,technology)
	i $e(name,1)="'" s name=$e(name,2,$l(name)-1)
	i $e(type,1)="'" s type=$e(type,2,$l(type)-1)
	;
	s newOID=$$getParentNode^%zewdDOM(nodeOID)
	s textOID=$$getText(newOID,.text)
	i text'="" s text=text_$c(13,10),hasText=1
	s text=text_data
	i textOID'="" s textOID=$$modifyTextData^%zewdDOM(text,textOID)
	e  d
	. n fcOID
	. s textOID=$$createTextNode^%zewdDOM(text,docOID)
	. ;s textOID=$$$appendChild(textOID,newOID)
	. s fcOID=$$getFirstChild^%zewdDOM(newOID)
	. s textOID=$$insertBefore^%zewdDOM(textOID,fcOID)
	;
	d removeIntermediateNode(nodeOID)
	i '$$hasChildElements^%zewdSchemaForm(newOID) d
	. s procInsOID=$$createJSPCommand(text,docOID)
	. s procInsOID=$$appendChild^%zewdDOM(procInsOID,newOID)
	. s textOID=$$removeChild^%zewdAPI(textOID)
	. d removeIntermediateNode(newOID)
	. 
	QUIT
	;
getArrayValue(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:getArrayValue arrayName="myArray" index="$no" return="$type">
	;
	n arrayName,index,return,serverOID,text,value
	;
	set arrayName=$$getAttrValue("arrayname",.attrValues,technology)
	i $e(arrayName,1)="""" s arrayName=$e(arrayName,2,$l(arrayName)-1)
	set return=$$getAttrValue("return",.attrValues,technology)
	set index=$$getAttrValue("index",.attrValues,technology)
	;
	s text=" s "_return_"="_arrayName_"("_index_")"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
getPiece(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:getPiece return="$value" data="$input" asciiDelimiter="1" pieceNumber=2>
	; <ewd:getPiece return="$value" data="$input" delimiter="^" pieceNumber=2>
	;
	n asciiDelim,data,delim,name,pieceNo,serverOID,text
	;
	s name=$$getAttrValue("return",.attrValues,technology)
	s data=$$getAttrValue("data",.attrValues,technology)
	s asciiDelim=$$getAttrValue("asciidelimiter",.attrValues,technology)
	s delim=$$getAttrValue("delimiter",.attrValues,technology)
	s pieceNo=$$getAttrValue("piecenumber",.attrValues,technology)
	;
	i asciiDelim'="""""",asciiDelim'="",asciiDelim'="''" d
	. s delim="$c("_asciiDelim_")"
	e  d
	. s delim=""""_delim_""""
	s text=" s "_name_"=$p("_data_","_$$removeQuotes^%zewdAPI(delim)_","_pieceNo_")"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
getSessionValue(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:getSessionValue sessionName="fileAttrs" return="$attrs">
	;
	n return,serverOID,sessionName,text
	;
	set sessionName=$$getAttrValue("sessionname",.attrValues,technology)
	set return=$$getAttrValue("return",.attrValues,technology)
	;
	s text=" s "_return_"=$$getSessionValue^%zewdAPI("_sessionName_",sessid)"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
getSessionArrayValue(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:getSessionArrayValue sessionName="fileAttrs" index=$page return="$attrs">
	; <ewd:getSessionArrayValue sessionName="fileAttrs" param1=$page param2="column" param3="$colNo" return="$attrs">
	;
	n index,nparams,param,pval,return,serverOID,sessionName,subs,text,useSessGlo
	;
	set sessionName=$$getAttrValue("sessionname",.attrValues,technology)
	set index=$$getAttrValue("index",.attrValues,technology)
	set return=$$getAttrValue("return",.attrValues,technology)
	s param="param",subs="",nparams=0
	;
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. s nparams=nparams+1
	. i $e(pval,1,5)="""&php" s pval=$$substitute^%zewdCompiler7(pval,.phpVars,technology)
	. s subs=subs_","_pval
	;
	s useSessGlo=1
	i index'="" d
	. i $e(return,1,5)="""&php" s return=$$substitute^%zewdCompiler7(return,.phpVars,technology)
	. i $e(sessionName,1,5)="""&php" s sessionName=$$substitute^%zewdCompiler7(sessionName,.phpVars,technology)
	. i $e(index,1,5)="""&php" s index=$$substitute^%zewdCompiler7(index,.phpVars,technology)
	. s text=" s "_return_"=$g(^%zewdSession(""session"",sessid,"_sessionName_","_index_"))"
	i index=""""""!(index="") s text=" s "_return_"=$g(^%zewdSession(""session"",sessid,"_sessionName_subs_"))"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
replace(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:replace input="$data" fromString="\" toString="\\" return="$escdata">
	;
	n fromString,input,output,serverOID,text,toString
	;
	s input=$$getAttrValue("input",.attrValues,technology)
	s return=$$getAttrValue("return",.attrValues,technology)
	s fromString=$$getAttrValue("fromstring",.attrValues,technology)
	s toString=$$getAttrValue("tostring",.attrValues,technology)
	;
	s text=" s "_return_"=$$replaceAll^%zewdHTMLParser("_input_","_fromString_","_toString_")"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
	;
else(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:else>
	;
	n data,cspOID
	;
	; <csp:else>
	;
	s cspOID=$$createElement^%zewdDOM("csp:else",docOID)
	s cspOID=$$appendChild^%zewdDOM(cspOID,nodeOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
for(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:for from=1 to=10 increment=1 counter=$i>
	;
	n attr,counter,cwOID,from,inc,to
	;
	s counter=$$getAttrValue("counter",.attrValues,technology)
	s from=$$getAttrValue("from",.attrValues,technology)
	s to=$$getAttrValue("to",.attrValues,technology)
	s inc=$$getAttrValue("increment",.attrValues,technology)
	i inc="" s inc=1
	;
	s cwOID=$$addIntermediateNode("csp:loop",nodeOID)
	i $e(from,1)'="""" s from="#("_from_")#"
	i $e(to,1)'="""" s to="#("_to_")#"
	i $e(inc,1)'="""" s inc="#("_inc_")#"
	d setAttribute^%zewdDOM("counter",counter,cwOID)
	d setAttribute^%zewdDOM("from",$$removeQuotes^%zewdAPI(from),cwOID)
	d setAttribute^%zewdDOM("to",$$removeQuotes^%zewdAPI(to),cwOID)
	d setAttribute^%zewdDOM("step",$$removeQuotes^%zewdAPI(inc),cwOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
if(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:if firstValue=$no secondValue=$sessid operation="!=">
	;
	n attr,cwOID,oper,value1,value2
	;
	s value1=$$getAttrValue("firstvalue",.attrValues,technology)
	i $e(value1,1,6)="""&php;" s value1=$e(value1,2,$l(value1)-1)
	s value2=$$getAttrValue("secondvalue",.attrValues,technology)
	i $e(value2,1,6)="""&php;" s value2=$e(value2,2,$l(value2)-1)
	s oper=$$getAttrValue("operation",.attrValues,technology)
	;
	i $e(oper,1)="""" s oper=$e(oper,2,$l(oper)-1)
	s oper=$tr(oper,"!","'")
	s cwOID=$$addIntermediateNode("csp:if",nodeOID)
	;
	; <csp:if condition="no!=sessid">
	; 
	i $e(value1,1)'="""",$e(value1,1,2)'="$$" s value1="$g("_value1_")"
	i $e(value2,1)'="""",$e(value2,1,2)'="$$" s value2="$g("_value2_")"
	s attr=value1_oper_value2
	s attr=$$replaceAll^%zewdHTMLParser(attr,"""","&quot;")
	d setAttribute^%zewdDOM("condition",attr,cwOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
elseif(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:elseif firstValue=$no secondValue=$sessid operation="!=">
	;
	n attr,cspOID,oper,value1,value2
	;
	s value1=$$getAttrValue("firstvalue",.attrValues,technology)
	s value2=$$getAttrValue("secondvalue",.attrValues,technology)
	s oper=$$getAttrValue("operation",.attrValues,technology)
	;
	i $e(oper,1)="""" s oper=$e(oper,2,$l(oper)-1)
	s oper=$tr(oper,"!","'")
	s cspOID=$$createElement^%zewdDOM("csp:elseif",docOID)
	s cspOID=$$appendChild^%zewdDOM(cspOID,nodeOID)
	;
	; <csp:elseif condition="no!=sessid">
	; 
	i $e(value1,1)'="""",$e(value1,1,2)'="$$" s value1="$g("_value1_")"
	i $e(value2,1)'="""",$e(value2,1,2)'="$$" s value2="$g("_value2_")"
	s attr=value1_oper_value2
	s attr=$$replaceAll^%zewdHTMLParser(attr,"""","&quot;")
	d setAttribute^%zewdDOM("condition",attr,cspOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
ifContains(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:ifContains input="$data" substring=".ewd">
	;
	n attr,cwOID,substring,variable
	;
	s input=$$getAttrValue("input",.attrValues,technology)
	i $e(input,1,6)="""&php;" s input=$e(input,2,$l(input)-1)
	s substring=$$getAttrValue("substring",.attrValues,technology)
	;
	s cwOID=$$addIntermediateNode("csp:if",nodeOID)
	;
	; <csp:if condition='data[".ewd"]'>
	;
	i $e(substring,1)="""" s substring="&quot;"_$e(substring,2,$l(substring)-1)_"&quot;" 
	s attr=input_"["_substring
	d setAttribute^%zewdDOM("condition",attr,cwOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
ifSessionNameExists(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:ifSessionNameExists sessionName="compilerListing">
	;
	n attr,cwOID,sessionName
	;
	s sessionName=$$getAttrValue("sessionname",.attrValues,technology)
	;
	s cwOID=$$addIntermediateNode("csp:if",nodeOID)
	;
	; <csp:if condition="$d(%session.Data(&quot;compilerListing&quot;))">
	; 
	i $e(sessionName,1)="""" s sessionName="&quot;"_$e(sessionName,2,$l(sessionName)-1)_"&quot;" 
	s attr="$$existsInSession^%zewdAPI("_sessionName_",sessid)"
	d setAttribute^%zewdDOM("condition",attr,cwOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
ifSessionArrayExists(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:ifSessionArrayExists sessionName="compilerListing" param1="xxx" param2="$yyy" param3="#zzz">
	;
	n attr,cwOID,param,pval,sessionName,subs
	;
	set sessionName=$$getAttrValue("sessionname",.attrValues,technology)
	s param="param",subs=""
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. s pval=$$replaceAll^%zewdHTMLParser(pval,"""","&quot;")
	. s subs=subs_","_pval
	;
	s cwOID=$$addIntermediateNode("csp:if",nodeOID)
	;
	; <csp:if condition="$d(%session.Data(&quot;compilerListing&quot;))">
	; 
	i $e(sessionName,1)="""" s sessionName="&quot;"_$e(sessionName,2,$l(sessionName)-1)_"&quot;" 
	s attr="$$existsInSessionArray^%zewdAPI("_sessionName_subs_",sessid)"
	d setAttribute^%zewdDOM("condition",attr,cwOID)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
set(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:set return="$attrs" value="xxx">  ie set return=value
	; <ewd:set return="$attrs" firstValue="$var" operand="+" secondValue="3">  ie set return=var+3
	;
	n firstValue,operand,return,secondValue,serverOID,text,value
	;
	s value=$$getAttrValue("value",.attrValues,technology)
	s return=$$getAttrValue("return",.attrValues,technology)
	s firstValue=$$getAttrValue("firstvalue",.attrValues,technology)
	s secondValue=$$getAttrValue("secondvalue",.attrValues,technology)
	s operand=$$getAttrValue("operand",.attrValues,technology)
	;
	i $$removeQuotes^%zewdAPI(operand)="" d
	. s text=" s "_return_"="_value
	e  d
	. s text=" s "_return_"="_firstValue_$$removeQuotes^%zewdAPI(operand)_secondValue
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
javaScript(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:javascript>
	;
	s config("responseHeader","Content-type")="application/x-javaScript"
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
responseHeader(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:responseHeader name="Content-type" value="image/svg+xml">
	; <ewd:responseHeader name="Expires" suppress="true">
	;
	n name,no,suppress,value
	;
	s name=$$getAttrValue("name",.attrValues,technology)
	s value=$$getAttrValue("value",.attrValues,technology)
	s suppress=$$getAttrValue("suppress",.attrValues,technology)
	;
	s suppress=$$removeQuotes^%zewdAPI(suppress)
	s suppress=$$zcvt^%zewdAPI(suppress,"l")
	i suppress="true" s value=-1
	s config("responseHeader",name)=value
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
svg(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:svg height="300" width="500" page="mySVGPage">
	;
	; <ewd:if firstValue="#ewd_browserType" operation="=" secondValue="ie6">
    ;   <embed type="image/svg-xml" src="svgMessageTrace.ewd" height="<?= #svg_height ?>" width="<?= #svg_width ?>" />
 	; <ewd:else>
    ;   <object type="image/svg+xml" data="svgMessageTrace.ewd" height="<?= #svg_height ?>" width="<?= #svg_width ?>">
    ;     <param name="src" value="svgMessageTrace.ewd" />
    ;   </object>
 	; </ewd:if> 
	;
	n attr,height,ifOID,jsOID,mainAttrs,oOID,page,phpVar,text,width,xOID
	;
	do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
	s height=$g(mainAttrs("height")) i height="" s height="300"
	s width=$g(mainAttrs("width")) i width="" s width="500"
	s page=$g(mainAttrs("src"))
	i page="" s page=$g(mainAttrs("page"))
	i page="" s page="undefined.ewd"
	i page'[".ewd" s page=page_".ewd"
	;
	s phpVar=$$addPhpVar^%zewdCustomTags("#ewd_browserType")
	;
	;s attr("firstvalue")=phpVar
	;s attr("secondvalue")="ie6"
	;s attr("operation")="="
	s attr("input")=phpVar
	s attr("substring")="ie"
	s ifOID=$$addElementToDOM^%zewdDOM("ewd:ifcontains",nodeOID,,.attr,"")
	;
	s attr("height")=height
	s attr("width")=width
	s attr("src")=page
	s attr("type")="image/svg-xml"
	s xOID=$$addElementToDOM^%zewdDOM("embed",ifOID,,.attr)
	;
	s xOID=$$addElementToDOM^%zewdDOM("ewd:else",ifOID)
	;
	s attr("height")=height
	s attr("width")=width
	s attr("data")=page
	s attr("type")="image/svg+xml"
	s oOID=$$addElementToDOM^%zewdDOM("object",ifOID,,.attr)
	s attr("name")="src"
	s attr("value")=page
	s xOID=$$addElementToDOM^%zewdDOM("param",oOID,,.attr)
	;
	s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
	i jsOID="" d
	. n nsOID
	. s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
	. s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
	. s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
	s text="function registerSVGDoc(svgDoc){"
	s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
	s text="EWD.svg = {};"
	s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
	s text="EWD.svg.doc = svgDoc;"
	s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
	s text="}"
	s lineOID=$$addElementToDOM^%zewdDOM("ewd:jsline",jsOID,,,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
svgPage(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:svgPage method="drawTeamGraph^ybcResults" param1="#ewd_sessid">
	;
	n payloadOID,attr,param,respOID,method
	;
	s attr("name")="Content-type"
	s attr("value")="image/svg+xml"
	s respOID=$$addElementToDOM^%zewdDOM("ewd:zresponseheader",nodeOID,,.attr,"")
	s attr("name")="Expires"
	s attr("suppress")="true"
	s respOID=$$addElementToDOM^%zewdDOM("ewd:zresponseheader",nodeOID,,.attr,"")
	;
	s payloadOID=$$addElementToDOM^%zewdDOM("ewd:responsepayload",nodeOID,,,"")
	s method=$$getAttrValue("method",.attrValues,technology)
	s attr("method")=$$removeQuotes^%zewdAPI(method)
	s param="param"
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s attr(param)=$$removeQuotes^%zewdAPI(attrValues(param))
	s attr("type")="procedure"
	s executeOID=$$addElementToDOM^%zewdDOM("ewd:zexecute",payloadOID,,.attr,"")
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
textarea(nodeOID,attrValues,docOID,technology)
	;
	; Find all <textarea> tags and add <?php ?> tag to write out text
	;
	n childOID,class,id,name,name1,scriptOID,text
	;
	set name=$$getAttrValue("name",.attrValues,technology)
	i name["[]" s name=$p(name,"[]",1)
	set id=$$getAttrValue("id",.attrValues,technology)
	i $$removeQuotes^%zewdAPI(name)="",$$removeQuotes^%zewdAPI(id)'="" d
	. s name=id
	. d setAttribute^%zewdDOM("name",$$removeQuotes^%zewdAPI(name),nodeOID)
	s class=$$getAttributeValue^%zewdDOM("class",1,nodeOID)
	s name1=name i $e(name1,1)="'"!($e(name1,1)="""") s name1=$e(name,2,$l(name)-1)
	i $$removeQuotes^%zewdAPI(id)="" d
	. i name1="" s name1="missingName"_$p(nodeOID,"-",2),name=""""_name1_""""
	. d setAttribute^%zewdDOM("id",name1,nodeOID)
	q:name=""
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	s text=$$getData^%zewdDOM(childOID)
	i text'="*" q
	s childOID=$$removeChild^%zewdAPI(childOID)
	;
	i technology="php" d
	. n target,data,procInsOID
	. s target="php"
	. s data="displayTextArea("_$tr(name,".","_")_", $ewd_session)"
	. s procInsOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
	. s procInsOID=$$appendChild^%zewdDOM(procInsOID,nodeOID)
	;
 	s text=" d displayTextArea^%zewdAPI("_name_")"_$c(13,10)
 	s scriptOID=$$addCSPServerScript(nodeOID,text)
	;
	QUIT
	;
execute(nodeOID,attrValues,docOID,technology)
	;
	; <ewd:execute method="xyz^myRoutine" param1="abc" param2="$x" param3="#y" type="function" return="$status">
	;
	n method,param,pval,return,serverOID,subs,text,type
	;
	s method=$$getAttribute^%zewdDOM("method",nodeOID)
	i $e(method,1,2)'="##",$e(method,1,2)'="$$" d
	. s method=$$getAttrValue("method",.attrValues,technology)
	. set method=$$removeQuotes^%zewdAPI(method)
	s type=$$getAttrValue("type",.attrValues,technology)
	s type=$$zcvt^%zewdAPI($$removeQuotes^%zewdAPI(type),"l")
	s return=$$getAttrValue("return",.attrValues,technology)
	s param="param",subs=""
	f  s param=$o(attrValues(param)) q:param=""  q:param'["param"  d
	. s pval=attrValues(param)
	. i $e(pval,1,15)="""%session.Data(" s pval=$$removeQuotes^%zewdAPI(pval)
	. i $e(pval,1,4)="""<?=" d
	. . s pval=$p(pval,"<?=",2)
	. . s pval=$p(pval,"?>",1)
	. . s pval=$$stripSpaces^%zewdAPI(pval)
	. s subs=subs_","_pval
	s subs=$e(subs,2,$l(subs)) ; remove leading comma
	;
	; d xyz^abc(param1,param2,param3)
	;
	i type="procedure" d
	. s text=" d "_method
	. i subs'="" s text=text_"("_subs_")"
	e  d
	. s text=" s "_return_"=$$"_method_"("_subs_")"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
select(docName,technology,config,idList) ;
	;
	; Find all <select> tags and add <?php ?> tag to write out options
	;
	n attr,brckt,checkUsing,class,data,escape,id,listName,multiple,name,nodeOID,ntags
	n OIDArray,procInsOID,scriptOID,target,text
	; 
	s escape=0 i $g(config("escapeText"))="true" s escape=1
	; 
	s ntags=$$getTagsByName^%zewdCompiler("select",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. s name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. s id=$$getAttributeValue^%zewdDOM("id",1,nodeOID)
	. s class=$$getAttributeValue^%zewdDOM("class",1,nodeOID)
	. i id="",name="" s name="unknown"_nodeOID
	. i id="" d setAttribute^%zewdDOM("id",name,nodeOID) ;s idList(name)=class
	. i id'="",name="" d setAttribute^%zewdDOM("name",id,nodeOID) ;s idList(id)=class
	. s listName=$$getAttributeValue^%zewdDOM("uselist",1,nodeOID)
	. d removeAttribute^%zewdAPI("uselist",nodeOID)
	. set checkUsing=$$getAttributeValue^%zewdDOM("checkusing",1,nodeOID)
	. do removeAttribute^%zewdAPI("checkusing",nodeOID)
	. q:name=""
	. s brckt=""
	. i $$hasAttribute^%zewdDOM("multiple",nodeOID)="true" d setAttribute^%zewdDOM("name",name_brckt,nodeOID)
 	. s attr("language")="cache"
 	. s attr("runat")="server"
 	. i listName="" s listName=name
	. i name["&php;" d
	. . n p1,p2
	. . s p1=$p(name,"&php;",1)
	. . s p2=$p(name,"&php;",3,200)
	. . s name=+$p(name,"&php;",2)
	. . s name=$g(phpVars(name))
	. . s name=$$stripSpaces^%zewdAPI(name)
	. . s name=$p(name,"$",2,200)
	. . s name=""""_p1_"""_"_name
	. . i p2'="" s name=name_"_"""_p2_""""
	. e  d
	. . i $e(name,1)'="$" s name=""""_name_""""
	. . e  s name=$e(name,2,$l(name))
	. i checkUsing'="" d
	. . s name=""""_checkUsing_""""
	. i listName["&php" d
	. . s text=" d displayOptions^%zewdAPI("_name_","_name_","_escape_")"_$c(13,10)
 	. e  d
	. . i $e(listName,1)="$" s listName=$e(listName,2,$l(listName))
	. . e  s listName=""""_listName_""""
 	. . s text=" d displayOptions^%zewdAPI("_name_","_listName_","_escape_")"_$c(13,10)
 	. s scriptOID=$$addElementToDOM^%zewdDOM("script",nodeOID,,.attr,text)
 	;
	QUIT
	;
trace(nodeOID,attrValues,docOID,technology)
	;
	;    <ewd:trace text="got here">
	; 
	n serverOID,text
	;   
	set text=$$getAttrValue("text",.attrValues,technology)
	;
	. ; d trace^%zewdAPI(text)
	. ; 
	s text=" d trace^%zewdAPI("_text_")"
	s serverOID=$$addCSPServerScript(nodeOID,text)
	;
	d removeIntermediateNode(nodeOID)
	;
	QUIT
	;
	;
	;==============================================
	;
	;  Support Functions
	;  
	;==============================================
	;
insertNewParent(nodeOID,parentTagName,docOID)
 ;
 n newParentOID,mOID
 ;
 s newParentOID=$$createElement^%zewdDOM(parentTagName,docOID)
 s newParentOID=$$insertBefore^%zewdDOM(newParentOID,nodeOID)
 s nodeOID=$$removeChild^%zewdAPI(nodeOID)
 s mOID=$$appendChild^%zewdDOM(nodeOID,newParentOID)
 ;
 QUIT newParentOID
	;
addIntermediateNode(tagName,parentOID) ; add a new element between a node and its children
 ;
 n newNodeOID,childArray,childNo
 ;
 d getChildrenInOrder(parentOID,.childArray)
 s newNodeOID=$$addElementToDOM^%zewdDOM(tagName,parentOID,,,"")
 s childNo=""
 f  s childNo=$o(childArray(childNo)) q:childNo=""  d
 . n nOID,nodeOID,mOID
 . s nodeOID=childArray(childNo)
 . s nOID=$$removeChild^%zewdAPI(nodeOID)
 . s mOID=$$appendChild^%zewdDOM(nOID,newNodeOID)
 QUIT newNodeOID
 ;
removeIntermediateNode(inOID) ; remove an intermediate node, moving any of its children up to its parent
 ;
 n childArray,childNo,nOID,nodeOID
 ;
 d getChildrenInOrder(inOID,.childArray)
 s childNo=""
 f  s childNo=$o(childArray(childNo)) q:childNo=""  d
 . s nodeOID=childArray(childNo)
 . s nOID=$$removeChild^%zewdAPI(nodeOID)
 . s nOID=$$insertBefore^%zewdDOM(nOID,inOID)
 s inOID=$$removeChild^%zewdAPI(inOID)
 QUIT
 ;
addNewFirstChild(tagName,docOID,parentOID)
 ;
 n tagOID,fcOID,newOID
 ;
 s tagOID=$$createElement^%zewdDOM(tagName,docOID)
 s fcOID=$$getFirstChild^%zewdDOM(parentOID)
 i fcOID'="" s newOID=$$insertBefore^%zewdDOM(tagOID,fcOID)
 e  s newOID=$$appendChild^%zewdDOM(tagOID,parentOID)
 QUIT newOID
 ;
getChildrenInOrder(parentOID,childArray)
 ;
 n nodeOID,childNo,siblingOID
 ;
 k childArray
 s childNo=0
 s nodeOID=$$getFirstChild^%zewdDOM(parentOID)
 q:nodeOID=""
 s childNo=childNo+1
 s childArray(childNo)=nodeOID
 s siblingOID=nodeOID
 f  s siblingOID=$$getNextSibling^%zewdDOM(siblingOID) q:siblingOID=""  d
 . s childNo=childNo+1
 . s childArray(childNo)=siblingOID
 QUIT
 ;
removeAllChildren(parentOID)
 ;
 n childArray,childOID,childNo,ok,prevChildOID
 ;
 d getChildrenInOrder(parentOID,.childArray)
 s childNo="",prevChildOID=""
 f  s childNo=$o(childArray(childNo)) q:childNo=""  d
 . s childOID=childArray(childNo)
 . i $$removeChild^%zewdAPI(childOID)
 . ;i prevChildOID'="" d
 . ;. s ok=$$setPreviousSibling^%zewdDOM(childOID,prevChildOID)
 . ;. s ok=$$setNextSibling^%zewdDOM(prevChildOID,childOID)
 . s prevChildOID=childOID
 QUIT
 ;
createPHPCommand(data,docOID)
	;
	n target,procInsOID
	;
	s target="php"
	s procInsOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
	QUIT procInsOID
	;
createJSPCommand(data,docOID)
	;
	n target,procInsOID
	;
	s target="jsp"
	s data="<%"_$c(13,10)_data_$c(13,10)_"%>"
	s procInsOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
	QUIT procInsOID
	;
addCSPServerScript(parentOID,text,atTop)
	n attr,scriptOID
 	s attr("language")="cache"
 	s attr("runat")="server"
 	s scriptOID=$$addElementToDOM^%zewdDOM("ewd:cspscript",parentOID,,.attr,text,$g(atTop))
 	QUIT scriptOID
	;
normaliseJSPVar(var,type)
	i $e(var,1)="$" QUIT $e(var,2,$l(var))
	i $e(var,1)="#" QUIT "getSessionValue("""_$e(var,2,$l(var))_""", ewd_Session, m_jsp)" q
	i type="String" QUIT """"_var_""""
	i $e(var,1)="""" QUIT $e(var,2,$l(var)-1)
	QUIT var
	;
instantiateJSPVar(var,type,docOID,arraySize,initialValue)
	;
	n attr,decOID,docName,headOID,nvOID,newed,newOID,nodeOID,ntags,OIDArray
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s newOID=$$getFirstElementByTagName^%zewdDOM("ewd:new",docName,"")
	i $$getParentNode^%zewdDOM(newOID)="" s newOID=""
	i newOID="" d
	. n parentOID
	. s parentOID=$$getFirstElementByTagName^%zewdDOM("head",docName,"")
	. s newOID=$$addNewFirstChild("ewd:new",docOID,parentOID)
	s newed=0
	set ntags=$$getTagsByName^%zewdCompiler("ewd:instantiate",docName,.OIDArray)
	set nodeOID=""
	for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
	. i var=$$getAttributeValue^%zewdDOM("name",1,nodeOID) s newed=1
	;
	i 'newed d
	. s attr("name")=var
	. i type="array" s attr("size")=arraySize
	. s attr("type")=type
	. i $g(initialValue)'="" s attr("initialvalue")=initialValue
	. s decOID=$$addElementToDOM^%zewdDOM("ewd:instantiate",newOID,,.attr,"")
	QUIT
	;
getText(nodeOID,text)
	;
	n childOID,stop
	;
	s childOID="",stop=0,text=""
	f  s childOID=$$getNextChild^%zewdSchemaForm(nodeOID,childOID) q:childOID=""  d  q:stop
	. i $$getNodeType^%zewdDOM(childOID)=3 s stop=1
	i childOID'="" s text=$$getData^%zewdDOM(childOID) QUIT childOID
	QUIT ""
	;
