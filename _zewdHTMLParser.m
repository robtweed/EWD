%zewdHTMLParser	; Enterprise Web Developer HTML to XHTML Converter
 ;
 ; Product: Enterprise Web Developer (Build 843)
 ; Build Date: Thu, 03 Feb 2011 14:01:46
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
parseFilesInPath(path,extension,deep,docName,errorList,outputFile,outputPath)
	;
	n files,dirs,dir,error,ok
	;
	s extension=$g(extension) i extension="" s extension="*"
	s docName=$g(docName) i docName'="" s docName="mgwTemp"
	s outputPath=$g(outputPath)
	i outputPath'="" s ok=$$makeDirectory(outputPath)
	;
	d getFilesInPath(path,extension,.files)
	d processFiles(.files,path,.errorList,docName,$g(outputFile),$g(outputPath))
	i '$g(deep) QUIT
	;
	d getDirectoriesInPath(path,.dirs)
	s dir=""
	f  s dir=$o(dirs(dir)) q:dir=""  d
	. n dirPath
	. s dirPath=path_"\"_dir
	. d parseFilesInPath(dirPath,extension,deep,docName,.errorList)
	Q
	;
processFiles(files,path,errorList,docName,outputFile,outputPath)
	;
	n filename,filepath,error
	;
	s filename="",error=""
	f  s filename=$o(files(filename)) q:filename=""  d
	. s filepath=path_"\"_filename
	. s error=$$processFile(filepath,docName,$g(outputFile),$g(outputPath))
	. i error'="" s errorList(filepath)=error
	QUIT
	;
processFile(filepath,docName,outputFile,outputPath)
	;
	n dn,error,cspVars,phpVars
	;
	s outputPath=$g(outputPath)
	i $$fileSize^%zewdAPI(filepath)=0 QUIT "empty file"
	;i '$zu(140,1,filepath) QUIT "empty file"
	i '$$fileExists^%zewdAPI(filepath) QUIT "missing file"
	;i $zu(140,1,filepath)=-2 QUIT "missing file"
	s error=$$parseFile(filepath,docName,.cspVars,.phpVars,1)
	i error'="" QUIT error
	i $g(outputFile)=1 d
	. s outputPath=$g(outputPath)
	. i outputPath'="" d  q:error'=""
	. . n rpath,fn
	. . i $e(outputPath,$l(outputPath))'="\" s outputPath=outputPath_"\"
	. . s rpath=$re(filepath)
	. . s fn=$re($p(rpath,"\",1))
	. . s outputPath=outputPath_fn
	. . i '$$openNewFile^%zewdAPI(outputPath) s error="Unable to open output file "_outputPath q 
	. . ;o outputPath:"nw":1 e  s error="Unable to open output file "_outputPath q 
	. . u outputPath
	. d outputDOM(docName,,.cspVars,.phpVars)
	. i $g(outputPath)'="" c outputPath
	QUIT error
	;
parseFile(filepath,docName,cspVars,phpVars,isHTML)
 ;
 n nlines,ok,%error
 ;
 ;
 k %error
 s %error=""
 i $e(filepath,1)="^" d
 . k ^CacheTempEWD($j)
 . m ^CacheTempEWD($j)=filepath
 e  d  i %error'="" QUIT %error
 . s nlines=$$importFile(filepath)
 . i nlines=-1 s %error="The file path "_filepath_" does not exist" q
 . i nlines=0 s %error=filepath_" is an empty file" q
 . i nlines=1,^CacheTempEWD($j,1)=$c(13,10) s %error=filepath_" is an empty file" q
 d tokeniseCSPVariables(.cspVars)
 d tokenisePHPVariables(.phpVars)
 d normaliseDivs
 i $g(isHTML)=2 d closeOptions s isHTML=1
 s ok=$$openDOM^%zewdDOM(0,,,,,,,,,,,,,,,,,)
 i ok'="" QUIT ok
 s ok=$$removeDocument^%zewdDOM(docName,0,0)
 s ok=$$closeDOM^%zewdDOM()
 s %error=$$parseDocument($g(docName),$g(isHTML))
 k ^CacheTempEWD($j)
 QUIT %error
 ;
parseStream(streamName,docName,isHTML)
 ;
 n error,file,filename,ok,x
 s error=""
 QUIT error
testHTTP ;
 ;
 n docName,http,ok,stream
 ;
 QUIT
 ;
parseURL(server,getPath,docName,port,isHTML,responseTime,browserType,post)
 ;
 n bsig,endTime,error,file,filename,http,ok,startTime
 ;
 s error=""
 n cspVars,%error,html,phpVars,url
 i $e(getPath,1)'="/" s getPath="/"_getPath
 s url="http://"_server_getPath
 s ok=$$httpGET^%zewdGTM(url,.html,10)
 k ^CacheTempEWD($j)
 m ^CacheTempEWD($j)=html
 d tokeniseCSPVariables(.cspVars)
 d tokenisePHPVariables(.phpVars)
 d normaliseDivs
 s ok=$$openDOM^%zewdDOM(0,,,,,,,,,,,,,,,,,)
 i ok'="" QUIT ok
 s ok=$$removeDocument^%zewdDOM(docName,0,0)
 s ok=$$closeDOM^%zewdDOM()
 s %error=$$parseDocument($g(docName),$g(isHTML))
 k ^CacheTempEWD($j)
 QUIT error
 ;
importFile(filepath)
 ;
 n dlim,i,x,zt
 ;
 k ^CacheTempEWD($j)
 ;i $zu(140,1,filepath)=-2 QUIT -1
 i '$$fileExists^%zewdAPI(filepath) QUIT -1
 c filepath
 s i=$$gtmImportFile(filepath)
 QUIT i-1
 ;
gtmImportFile(filepath)
 n buf,buflen,i,len,lineNo,maxlen,x1,x2,xlen
 o filepath:(readonly:stream:exception="g importNotExists")
 u filepath:exception="g eof"
 k ^CacheTempEWD($j)
 s lineNo=1,buf="",maxlen=2000
 f i=1:1 r x#maxlen d
 . s x=$tr(x,$c(13),"")
 . s x=$tr(x,$c(9)," ")
 . s buflen=$l(buf)
 . s xlen=$l(x)
 . i (buflen+xlen)<maxlen s buf=buf_$c(10)_x q
 . s len=maxlen-buflen
 . s buf=buf_$e(x,1,len)
 . s ^CacheTempEWD($j,lineNo)=$$replaceAll^%zewdAPI(buf,$c(10,10),$c(10))
 . s buf=$e(x,len+1,$l(x))
 . s lineNo=lineNo+1
eof ;
 s ^CacheTempEWD($j,lineNo)=$$replaceAll^%zewdAPI(buf,$c(10,10),$c(10))_$c(10)
 c filepath
 QUIT i
 ;
importNotExists
 s $zt=""
 s i=-1
 QUIT i
 ;
parseDocument(docName,isHTML)
 ;
 ; Extract each line from the document
 ;
 i $g(isHTML)="" s isHTML=0
 n buf,cspVars,dlim,docOID,doctype,elementName,%error,isSVG,%line,lineNo
 n namespaceURI,nextLine,nLines,nodeOID,np,ntags,OIDArray,ok,%p1,%p2,%p3,%p4
 n prevLine
 ;
 k %error
 ;i '$$licensed^%eXtc("XPath") QUIT "You need a valid Lite or Full eXtc License to run the XHTML Parser"
 s ok=$$openDOM^%zewdAPI()
 i ok'="" QUIT ok
 s (namespaceURI,elementName,doctype)=""
 i docName'="" s ok=$$removeDocument^%zewdDOM(docName,0,0)
 s docOID=$$createDocument^%zewdDOM(namespaceURI,elementName,doctype,.docName,)
 ;
 s buf="",nextLine=1,isSVG=0
 ;
 k ^CacheTempUserNode($j)
 s ^CacheTempUserNode($j)=10000
 ;
 ; tidy up record boundaries
 ;
 s nLines=$o(^CacheTempEWD($j,""),-1)
 s dlim=$c(13,10)
 i $$os^%zewdHTMLParser()="unix" s dlim=$c(10)
 i $$os^%zewdHTMLParser()="gtm" s dlim=$c(10)
 i ^CacheTempEWD($j,1)'[$c(13,10),^CacheTempEWD($j,1)[$c(10) s dlim=$c(10)
 i nLines>1 f lineNo=2:1:nLines d
 . s %line=^CacheTempEWD($j,lineNo)
 . s np=$l(%line,dlim)
 . s %p1=$p(%line,dlim,1)
 . s %p2=$p(%line,dlim,2,np)
 . s prevLine=^CacheTempEWD($j,lineNo-1)_%p1
 . s ^CacheTempEWD($j,lineNo-1)=prevLine
 . s ^CacheTempEWD($j,lineNo)=%p2
 ;
 . i $e(prevLine,$l(prevLine)-2,$l(prevLine))["<" d
 . . i $e(prevLine,$l(prevLine))=dlim s prevLine=$e(prevLine,1,$l(prevLine)-1)
 . . s nextLine=%p2
 . . i %p2="" s nextLine=$g(^CacheTempEWD($j,lineNo+1))
 . . s %p3=$p(nextLine,">",1)_">"
 . . s %p4=$p(nextLine,">",2,10000)
 . . s ^CacheTempEWD($j,lineNo-1)=prevLine_%p3
 . . i %p2="" d
 . . . s ^CacheTempEWD($j,lineNo+1)=%p4
 . . e  d
 . . . s ^CacheTempEWD($j,lineNo)=%p4
 ;
 s nextLine=1
 f  s %line=$$getLineFromBuffer(0,"",.buf,.nextLine) q:$$isOpenTag(%line)
 s %error=""
 d addChild(%line,docOID,docOID,.nextLine,.buf,.%error,.impliedClose,isHTML) ; finished !
 ;
 ; remove any ewdDummy nodes
 ;
 set ntags=$$getTagsByName^%zewdCompiler("ewddummy",docName,.OIDArray)
 set nodeOID=""
 for  set nodeOID=$order(OIDArray(nodeOID)) quit:nodeOID=""  do
 . do removeIntermediateNode^%zewdCompiler4(nodeOID)
 ;
 s ok=$$closeDOM^%zewdDOM()
 k ^CacheTempUserNode($j)
 Q $g(%error)
 ;
addChild(%line,parentOID,docOID,nextLine,%buf,%error,impliedClose,isHTML)
 ;
 n %attr,%text,%nextLine,%line2,childOID,i,%line3,tagName,%stop,isText,textArray,%xattr
 ;
 s %stop=0
 ;
 i $$os()="gtm" s $zt=""
 f i=1:1 d  q:%stop  s %line=$$getLineFromBuffer(0,"",.%buf,.nextLine) q:%buf=""  i i>16000 s %error="Unable to parse page just before "_$e(%buf,1,400)_$c(13,10)_"Hint : check for improperly matched <tr> and/or <td> tags" q
 . s %text="" 
 . i $$isText(%line) d  QUIT
 . . i $$getTagName^%zewdDOM(parentOID)'="script" s %text=$$tidyText(%line)
 . . i %text'="" d
 . . . n textOID,textx
 . . . i %text[$c(9) d  q:%text=""
 . . . . s %text=$$replaceAll^%zewdAPI(%text,$c(9)," ")
 . . . . s textx=$$replaceAll^%zewdAPI(%text,"  "," ")
 . . . . i textx=" " s %text=""
 . . . s textOID=$$createTextNode^%zewdDOM(%text,docOID)
 . . . s textOID=$$appendChild^%zewdDOM(textOID,parentOID)
 . . . s childOID=textOID
 . s tagName=$$parseElement(%line,.%attr,.%error,.isHTML) i $g(%error)'="" s %stop=1 QUIT
 . i tagName="select",$d(%attr("multiple")) s %attr("multiple")="multiple"
 . ;b:tagName="span"
 . i $$zcvt^%zewdAPI(tagName,"U")="!DOCTYPE" QUIT  ; ignore
 . i tagName="html" k %attr ; remove XHTML attributes
 . i $$isCloseTag(%line) d  q
 . . n parentTagName
 . . s parentTagName=$$getTagName^%zewdDOM(parentOID)
 . . i tagName="/form",parentTagName="tr" d
 . . . s tagName="/tr"
 . . . s %buf="</form>"_%buf
 . . i tagName="/table",parentTagName="tr" d
 . . . s tagName="/tr"
 . . . s %buf="</table>"_%buf
 . . i tagName="/tr",parentTagName="td" d
 . . . s tagName="/td"
 . . . s %buf="</tr>"_%buf
 . . ;i tagName["/div" break
 . . i tagName=("/"_parentTagName) s %stop=1
 . . i tagName=("/"_$$getTagName^%zewdDOM(childOID)),$$hasText(childOID) s %stop=0
 . i $$empty(.%attr) d  Q
 . . s childOID=$$addTag(tagName,parentOID,docOID,.%attr) ; add empty tag
 . i tagName="p" d pTagClosure(.%buf,nextLine,parentOID)
 . i tagName="li" d liTagClosure(.%buf,nextLine,parentOID)
 . i $$impliedClose(tagName,.%attr) d  QUIT
 . . s childOID=$$addTag(tagName,parentOID,docOID,.%attr) ; add tag but no children
 . i $$isOpenTag(%buf) d  Q
 . . ; does the current tag have an implied close, or does the next tag imply a forced closure of the current one?
 . . i $$impliedClose(tagName,.%attr)!($$forceClose(tagName,%buf)) d  QUIT  ; just add tag but dont add next as child
 . . . s childOID=$$addTag(tagName,parentOID,docOID,.%attr) ; add tag but no children
 . . ;
 . . s %line2=$$getLineFromBuffer(0,"",.%buf,.nextLine)
 . . s childOID=$$addTag(tagName,parentOID,docOID,.%attr) ; add tag and next add child
 . . d addChild(%line2,childOID,docOID,.nextLine,.%buf,.%error,,isHTML) s childOID="" i $g(%error)'="" s %stop=1
 . ;
 . s isText=0 i tagName="script"!(tagName="style")!(tagName="textarea")!(tagName="csp:method")!(tagName="server")!(tagName="ewd:javascript") s isText=1
 . s %line2=$$getLineFromBuffer(isText,tagName,.%buf,.nextLine,.textArray)
 . s %text="" i %line2'="**mgwArray***",$$isText(%line2) s %text=%line2 i 'isText s %text=$$tidyText(%line2) ; text found for tag
 . i tagName="!DOCTYPE" d  QUIT
 . . ; ignore for now
 . k %xattr m %xattr=%attr
 . s childOID=$$addTag(tagName,parentOID,docOID,.%attr,%text,.textArray) ;
 . i '$$isText(%line2) s %buf=%line2_%buf QUIT
 . ;
 . i $$isOpenTag(%buf) d  QUIT
 . . i $$impliedClose(tagName,.%xattr)!($$forceClose(tagName,%buf)) QUIT  ; just add tag but dont add next as child
 . . s %line3=$$getLineFromBuffer(0,"",.%buf,.nextLine)
 . . d addChild(%line3,childOID,docOID,.nextLine,.%buf,.%error,,$g(isHTML)) s childOID="" s:$g(%error)'="" %stop=1 QUIT
 QUIT
 ;
hasChildren(nodeOID)
 ;
 n childOID,hasChildElements,nodeType
 ;
 s childOID="",hasChildElements=0
 f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d  q:hasChildElements
 . s nodeType=$$getNodeType^%zewdDOM(childOID)
 . i nodeType=1 s hasChildElements=1 q
 . i nodeType=3 s hasChildElements=1
 QUIT hasChildElements
 ;
hasText(nodeOID)
 ;
 n childOID,hasText,nodeType
 ;
 s childOID="",hasText=0
 f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d  q:hasText
 . s nodeType=$$getNodeType^%zewdDOM(childOID)
 . i nodeType=3,$$getData^%zewdDOM(childOID)'="" s hasText=1
 QUIT hasText
 ;
tidyText(text)
 ;
 i 'isHTML d  QUIT text
 . n dlim,xtext
 . s dlim=""
 . i text[$c(13,10) s dlim=$c(13,10)
 . i dlim="",text[$c(10) s dlim=$c(10)
 . i dlim="" d
 . . n os
 . . s dlim=$c(10)
 . . s os=$$os^%zewdHTMLParser()
 . . i os="windows" s dlim=$c(13,10)
 . s xtext=$$replaceAll^%zewdAPI(text,dlim,"")
 . s xtext=$$replaceAll^%zewdAPI(xtext," ","")
 . i xtext="" s text="" q
 . i dlim'="" d
 . . n np,stop
 . . s np=$l(text,dlim)
 . . i np=3,$p(text,dlim,1)="" s text=$p(text,dlim,2) q
 . . i $p(text,dlim,1)="" s text=$p(text,dlim,2,2000)
 . . s stop=0
 . . f i=np:-1:1 d  q:stop
 . . . i $p(text,dlim,i)'="" s stop=1 q
 . . . s text=$p(text,dlim,1,i-1)
 i text[$c(13,10) s text=$tr(text,$c(13,10),"")
 i text[$c(10) s text=$tr(text,$c(10),"")
 s text=$$stripSpaces^%zewdAPI(text)
 ;s text=$ZSTRIP(text,"<W")
 ;s text=$ZSTRIP(text,">W")
 s text=$$replaceAll(text,"<","&lt;")
 s text=$$replaceAll(text,">","&gt;")
 Q text
 ;
replaceAll(InText,FromStr,ToStr) ; Replace all occurrences of a substring
 ;
 n %p
 ;
 s %p=InText
 f  q:%p'[FromStr  S %p=$$replace(%p,FromStr,ToStr)
 QUIT %p
 ;
replace(InText,FromStr,ToStr) ; replace old with new in string
 ;
 n %p1,%p2
 ;
 i InText'[FromStr q InText
 s %p1=$p(InText,FromStr,1),%p2=$p(InText,FromStr,2,255)
 QUIT %p1_ToStr_%p2
 ;
empty(%attr)
 QUIT $d(%attr("/"))
 ;
impliedClose(tagName,attr)
 ;
 n impliedClose,i,%line
 ;
 i $e(tagName,1)="?" QUIT 1
 ;
 s impliedClose=0
 f i=1:1 s %line=$t(impliedCloseTags+i^%zewdCompiler15) q:%line["***END***"  d  q:impliedClose
 . i tagName=$p(%line,";;",2) s impliedClose=1
 ;
 ; user defined implied closure tags
 ; 
 i impliedClose QUIT 1
 ; 
 QUIT $$isImpliedCloseTag^%zewdCompiler(tagName) 
 ;
 ;
forceClose(tagName,%buf)
 ;
 n %nextTag
 ;
 s %nextTag=$p(%buf,">",1)
 i tagName="tr",%nextTag="<tr" QUIT 1
 i tagName="td",%nextTag="<td" QUIT 1
 QUIT 0
 ;
addTag(tagName,parentOID,docOID,%attr,%text,textArray)
 ;
 n commentOID,childOID,dummyOID,procInsOID,attrName,attrValue,eOID,parentTagName
 ;
 s parentTagName=$$getTagName^%zewdDOM(parentOID)
 ;i tagName=parentTagName d
 ;. n count
 ;. s count=$increment(^CacheTempUserNode($j))
 ;. s tagName="ewdTag"_count_tagName break
 i $d(textArray) d  QUIT eOID
 . n lineNo
 . s eOID=$$createElement^%zewdDOM(tagName,docOID)
 . s attrName=""
 . f  s attrName=$o(%attr(attrName)) q:attrName=""  d
 . . s attrValue=%attr(attrName)
 . . d setAttribute^%zewdDOM(attrName,attrValue,eOID)
 . s eOID=$$appendChild^%zewdDOM(eOID,parentOID)
 . s lineNo=""
 . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . n textOID,tOID
 . . s textOID=$$createTextNode^%zewdDOM(textArray(lineNo),docOID)
 . . s tOID=$$appendChild^%zewdDOM(textOID,eOID)
 ;
 i $e(tagName,1)="?" d  QUIT procInsOID
 . n target,data
 . s target=$p(tagName,"?",2)
 . i target[$c(13,10) s target=$tr(target,$c(13,10),"")
 . i target[$c(10) s target=$tr(target,$c(10),"")
 . s data=$g(%attr("content"))
 . i target="=" d
 . . s target="php"
 . . s data="echo("_data_");"
 . s procInsOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
 . s procInsOID=$$appendChild^%zewdDOM(procInsOID,parentOID)
 ;
 i tagName["CDATA" d  QUIT commentOID
 . n data
 . s data=%attr("content")
 . i data="" s data=" "
 . s commentOID=$$createCDATASection^%zewdDOM(data,docOID)
 . s commentOID=$$appendChild^%zewdDOM(commentOID,parentOID)
 ;
 i tagName="!--" d  QUIT commentOID
 . n data
 . s data=%attr("content")
 . i data="" s data=" "
 . s commentOID=$$createComment^%zewdDOM(data,docOID)
 . s commentOID=$$appendChild^%zewdDOM(commentOID,parentOID)
 ;
 i $g(%text)[$c(9) d
 . n textx
 . s %text=$$replaceAll^%zewdAPI(%text,$c(9)," ")
 . s textx=$$replaceAll^%zewdAPI(%text,"  "," ")
 . i textx=" " s %text=""
 s childOID=$$addElementToDOM^%zewdDOM(tagName,parentOID,,.%attr,$g(%text))
 QUIT childOID
 ;
isOpenTag(%line)
 ;f  q:$e(%line,1)?1ANP  d
 ;. s %line=$e(%line,2,$l(%line))
 i $e(%line,1)'="<" QUIT 0
 i $e(%line,2)="/" QUIT 0
 QUIT 1
 ;
isCloseTag(%line)
 i $e(%line,1,2)="</" QUIT 1
 QUIT 0
 ;
isText(%line)
 i $e(%line,1,2)="<<" QUIT 1
 QUIT $e(%line,1)'="<"
 ;
displayTag(tagName,%attr)
 ;
 n %name,%empty
 ;
 w "<"_tagName
 i tagName="!--" w %attr("content")_">" q
 s %name="",%empty=0
 f  s %name=$o(%attr(%name)) q:%name=""  d
 . i %name="/" s %empty=1 q
 . w " "_%name_"='"_%attr(%name)_"'"
 i %empty w " /"
 w ">"
 w %line
 Q
 ;
tokeniseCSPVariables(cspVars)
 ;
 n line,lineNo,symbolNo
 ;
 s lineNo="",symbolNo=$o(cspVars(""),-1)+1
 ;f  s lineNo=$o(^%work($j,lineNo)) q:lineNo=""  d
 f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d
 . ;s line=^%work($j,lineNo)
 . s line=^CacheTempEWD($j,lineNo)
 . f  q:line'["#("  d
 . . n %p1,%p2,%p3,nVars,symbol
 . . s nVars=$l(line,"#(")
 . . s %p1=$p(line,"#(",1)
 . . s %p3=$p(line,"#(",2,nVars)
 . . i %p3'[")#" d
 . . . ;line buffer boundary - readjust
 . . . n lineNo2,line2,%p4,%p5,npieces
 . . . s lineNo2=lineNo+1
 . . . ;s line2=$g(^%work($j,lineNo2))
 . . . s line2=$g(^CacheTempEWD($j,lineNo2))
 . . . q:line2=""
 . . . s %p4=$p(line2,")#",1)_")#"
 . . . s npieces=$l(line2,")#")
 . . . s %p5=$p(line2,")#",2,npieces+2)
 . . . s line=line_%p4
 . . . s %p3=%p3_%p4
 . . . ;s ^%work($j,lineNo2)=%p5
 . . . s ^CacheTempEWD($j,lineNo2)=%p5
 . . s %p2=$p(%p3,")#",1)
 . . s %p3=$p(%p3,")#",2,1000)
 . . s symbolNo=symbolNo+1
 . . s symbol="&cspVar;"_symbolNo_"&cspVar;"
 . . s line=%p1_symbol_%p3
 . . s cspVars(symbolNo)=%p2
 . ;s ^%work($j,lineNo)=line
 . s ^CacheTempEWD($j,lineNo)=line
 ;
 QUIT
 ;
normaliseDivs
 ;
 n c,i,len,line,lineNo,nDiv,ndivClose,p1,p2,stop,tag
 ;
 s lineNo=""
 f tag="</div>","</span>","</table>","</ewd:foreach>","</ewd:if>" d
 . f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d
 . . s line=^CacheTempEWD($j,lineNo)
 . . s line=$$lcSubstring^%zewdCompiler20(line,tag)
 . . q:line'[tag
 . . s ndivClose=$l(line,tag)
 . . q:ndivClose<3
 . . s len=$l(tag)-1
 . . f nDiv=1:1:ndivClose d
 . . . s p1=$p(line,tag,1,nDiv)
 . . . s p2=$p(line,tag,(nDiv+1),2000)
 . . . s stop=0
 . . . f i=1:1 d  q:stop
 . . . . s c=$e(p2,i)
 . . . . i c=$c(13)!(c=$c(10))!(c=" ")!(c=$c(9)) q
 . . . . i c'="<" s stop=1 q
 . . . . s line=p1_"<ewddummy />"_tag_"<ewddummy />"_p2 s stop=1
 . . s ^CacheTempEWD($j,lineNo)=line
 QUIT
 ;
closeOptions
 ;
 n line,lineNo
 ;
 s lineNo="",skip=0
 f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d
 . s line=^CacheTempEWD($j,lineNo)
 . s line=$e(line,skip+1,$l(line))
 . i $d(^CacheTempEWD($j,lineNo+1)) d
 . . s line2=^CacheTempEWD($j,lineNo+1)
 . . s p1=$p(line2,"</",1)
 . . s p2=$p(line2,"</",2,3)
 . . s p2=$$zcvt^%zewdAPI(p2,"l")
 . . i $e(p2,1,6)'="option" d  q
 . . . s line=line_p1
 . . . s skip=$l(p1)
 . . s p1=$p(line2,"</",1,2)
 . . s p2=$p(line2,"</",3)
 . . s line=line_p1
 . . s skip=$l(p1)
 . i $$zcvt^%zewdAPI(line,"l")["<option" d
 . . s buf=line
 . . s line=""
 . . f  q:$$zcvt^%zewdAPI(buf,"l")'["<option"  d
 . . . s buf=$$convertSubstringCase(buf,"<option","l")
 . . . s p1=$p(buf,"<option",1)
 . . . s p2=$p(buf,"<option",2,10000)
 . . . s p3=$p(p2,"<",1)
 . . . i $e(p3,$l(p3)-1,$l(p3))=$c(13,10) s p3=$e(p3,1,$l(p3)-2)
 . . . s p1=p1_"<option"_p3
 . . . s len=$l(p1)
 . . . s p1=p1_"</option>"
 . . . s line=line_p1
 . . . s buf=$e(buf,len+1,$l(buf))
 . . s line=line_buf
 . ;
 . s ^CacheTempEWD($j,lineNo)=line
 QUIT
 ;
tokenisePHPVariables(phpVars)
 ;
 n lineNo,sig,varNo
 ;
 s lineNo="",varNo=$o(phpVars(""),-1)+1
 f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d
 . f sig="?","%" d tokenise(sig,.varNo,lineNo)
 QUIT
 ;
tokenise(sig,varNo,lineNo)
 ;
 ; sig is ? for PHP, % for JSP
 ;
 n line,%p1,%p2,%p3,%p4,str1,str2
 ;
 s str1="<"_sig_"=",str2=sig_">"
 s line=^CacheTempEWD($j,lineNo)
 f  q:line'[str1  d
 . s varNo=varNo+1
 . s %p1=$p(line,str1,1)
 . s %p2=$p(line,str1,2,500)
 . i %p2'[str2 d
 . . n line2
 . . s line2=$g(^CacheTempEWD($j,lineNo+1))
 . . i line2'="" d
 . . . n c1,c2,np
 . . . s np=$l(line2,">")
 . . . s c1=$p(line2,">",1)_">"
 . . . s c2=$p(line2,">",2,np+2)
 . . . s line=line_c1
 . . . s %p2=%p2_c1
 . . . s ^CacheTempEWD($j,lineNo+1)=c2
 . s %p3=$p(%p2,str2,1)
 . s %p4=$p(%p2,str2,2,500)
 . s phpVars(varNo)=%p3
 . s line=%p1_"&php;"_varNo_"&php;"_%p4
 . s ^CacheTempEWD($j,lineNo)=line
 QUIT
 ;
pTagClosure(buf,nextLine,parentOID)
 ;
 ; look ahead in buffer.  If we find an explicit </p> tag with no <p>
 ; tags before it, then we'll leave it alone.
 ; 
 ; If we can't find any </p> tags at all, and no other <p> tags, then leave it alone and let the parser close it off at the end
 ; 
 ; If we find another <p> tag before a </p> tag, then insert a </p> tag before the next <p> tag
 ;
 n buflc,openPPos1,openPPos2,buf2,lineNo,%stop,closePos,parentTag,closePos2,nextPFound,openPos
 ;
 s lineNo="",nextPFound=0
 s closePos=$f($$zcvt^%zewdAPI(buf,"L"),"</p>")
 s openPPos1=$f($$zcvt^%zewdAPI(buf,"L"),"<p>")
 s openPPos2=$f($$zcvt^%zewdAPI(buf,"L"),"<p ")
 i openPPos1>0,openPPos1<closePos s nextPFound=1
 i openPPos2>0,openPPos2<closePos s nextPFound=1
 s openPos=""
 i openPPos1>0 s openPos=openPPos1
 i openPPos2>0,openPPos2<openPos s openPos=openPPos2
 i closePos=0,openPos'="" s nextPFound=1
 s parentTag=$$getTagName^%zewdDOM(parentOID)
 s closePos2=$f($$zcvt^%zewdAPI(buf,"L"),"</"_parentTag)
 i closePos2>0,closePos>0,closePos2<closePos s closePos=closePos2 i closePos<openPos d closeP(parentTag,.buf) QUIT
 ;i closePos=0,closePos2>0 s closePos=closePos2 i closePos<openPos d closeP(parentTag,.buf) QUIT
 i closePos=0,closePos2>0 s closePos=closePos2 i closePos<openPos!(openPos="") d closeP(parentTag,.buf) QUIT
 ;
 i closePos>0,'nextPFound QUIT  ; matching </p> found for current <p>
 ;
 i nextPFound d
 . n str,strx,len
 . s str=$e(buf,1,openPos)
 . s strx=$re(str)
 . s strx=$$convertSubstringCase(strx,"p<")
 . s strx=$p(strx,"p<",2)
 . s str=$re(strx)
 . s len=$l(str)
 . s buf=str_"</p>"_$e(buf,len+1,$l(buf))
 . 
 ; check in the rest of the buffer lines
 s %stop=0
 i closePos=0 d
 . s lineNo=nextLine-1
 . ;f  s lineNo=$o(^%work($j,lineNo)) q:lineNo=""  d  q:%stop
 . f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d  q:%stop
 . . ;s buf2=^%work($j,lineNo)
 . . s buf2=^CacheTempEWD($j,lineNo)
 . . s closePos=$f($$zcvt^%zewdAPI(buf2,"L"),"</p>")
 . . s openPPos1=$f($$zcvt^%zewdAPI(buf2,"L"),"<p>")
 . . s openPPos2=$f($$zcvt^%zewdAPI(buf2,"L"),"<p ")
 . . i openPPos1>0,openPPos1<closePos s nextPFound=1
 . . i openPPos2>0,openPPos2<closePos s nextPFound=1
 . . s openPos=""
 . . i openPPos1>0 s openPos=openPPos1
 . . i openPPos2>0,openPPos2<openPos s openPos=openPPos2
 . . ;
 . . i closePos>0,'nextPFound s %stop=1 q
 . . i closePos>0,nextPFound d  q
 . . . n str,strx,len
 . . . s str=$e(buf2,1,openPos)
 . . . s strx=$re(str)
 . . . s strx=$$convertSubstringCase(strx,"p<")
 . . . s strx=$p(strx,"p<",2)
 . . . s str=$re(strx)
 . . . s len=$l(str)
 . . . s buf2=str_"</p>"_$e(buf2,len+1,$l(buf2))
 . . . ;s ^%work($j,lineNo)=buf2
 . . . s ^CacheTempEWD($j,lineNo)=buf2
 . . . s %stop=1
 ;
 QUIT
 ;
closeP(tagName,buf)
 n findStr,%p1,%p2
 s findStr="</"_tagName_">"
 s %p1=$p(buf,findStr,1)
 s %p2=$p(buf,findStr,2,5000)
 s buf=%p1_"</p>"_findStr_%p2
 QUIT
 ;
liTagClosure(buf,nextLine,parentOID)
 ;
 ; look ahead in buffer.  If we find an explicit </li> tag with no <li>
 ; tags before it, then we'll leave it alone.
 ; 
 ; If we can't find any </li> tags at all, and no other <li> tags, then leave it alone and let the parser close it off at the end
 ; 
 ; If we find another <li> tag before a </li> tag, then insert a </li> tag before the next <li> tag
 ; If we find a <ul> before the next <li> then leave the current one alone
 ;
 n buf2,buflc,closePos,closePos2,closeULPos,lineNo,nextPFound,openPos
 n openPPos1,openPPos2,openULPos,openULPos1,openULPos2,parentTag,%stop
 ;
 s lineNo="",nextPFound=0
 s closePos=$f($$zcvt^%zewdAPI(buf,"L"),"</li>")
 s openPPos1=$f($$zcvt^%zewdAPI(buf,"L"),"<li>")
 s openPPos2=$f($$zcvt^%zewdAPI(buf,"L"),"<li ")
 s openULPos1=$f($$zcvt^%zewdAPI(buf,"L"),"<ul>")
 s openULPos2=$f($$zcvt^%zewdAPI(buf,"L"),"<ul ")
 s closeULPos=$f($$zcvt^%zewdAPI(buf,"L"),"</ul>")
 s openULPos=0
 i openULPos1>0 s openULPos=openULPos1
 i openULPos=0,openULPos2>0 s openULPos=openULPos2
 i openULPos1>0,openULPos2>0,openULPos2<openULPos s openULPos=openULPos2
 ;
 i openPPos1>0,openPPos1<closePos s nextPFound=1
 i openPPos2>0,openPPos2<closePos s nextPFound=1
 s openPos=""
 i openPPos1>0 s openPos=openPPos1
 i openPPos2>0,openPPos2<openPos s openPos=openPPos2
 i closePos=0,openPos'="" s nextPFound=1
 ;
 i openULPos'=0,openPos'="",openULPos<openPos QUIT
 ;i closeULPos'=0,openPos'="",closeULPos<openPos QUIT
 ;
 s parentTag=$$getTagName^%zewdDOM(parentOID)
 s closePos2=$f($$zcvt^%zewdAPI(buf,"L"),"</"_parentTag)
 i closePos2>0,closePos>0,closePos2<closePos s closePos=closePos2 i closePos<openPos d closeLI(parentTag,.buf) QUIT
 i closePos=0,closePos2>0 s closePos=closePos2 i closePos<openPos!(openPos="") d closeLI(parentTag,.buf) QUIT
 ;
 i closePos>0,'nextPFound QUIT  ; matching </p> found for current <p>
 ;
 i nextPFound d
 . n str,strx,len
 . s str=$e(buf,1,openPos)
 . s strx=$re(str)
 . s strx=$$convertSubstringCase(strx,"il<")
 . s strx=$p(strx,"il<",2)
 . s str=$re(strx)
 . s len=$l(str)
 . s buf=str_"</li>"_$e(buf,len+1,$l(buf))
 . 
 ; check in the rest of the buffer lines
 s %stop=0
 i closePos=0 d
 . s lineNo=nextLine-1
 . ;f  s lineNo=$o(^%work($j,lineNo)) q:lineNo=""  d  q:%stop
 . f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d  q:%stop
 . . ;s buf2=^%work($j,lineNo)
 . . s buf2=^CacheTempEWD($j,lineNo)
 . . s closePos=$f($$zcvt^%zewdAPI(buf2,"L"),"</li>")
 . . s openPPos1=$f($$zcvt^%zewdAPI(buf2,"L"),"<li>")
 . . s openPPos2=$f($$zcvt^%zewdAPI(buf2,"L"),"<li ")
 . . s openULPos1=$f($$zcvt^%zewdAPI(buf,"L"),"<ul>")
 . . s openULPos2=$f($$zcvt^%zewdAPI(buf,"L"),"<ul ")
 . . s openULPos=0
 . . i openULPos1>0 s openULPos=openULPos1
 . . i openULPos=0,openULPos2>0 s openULPos=openULPos2
 . . i openULPos1>0,openULPos2>0,openULPos2<openULPos s openULPos=openULPos2
 . . i openPPos1>0,openPPos1<closePos s nextPFound=1
 . . i openPPos2>0,openPPos2<closePos s nextPFound=1
 . . s openPos=""
 . . i openPPos1>0 s openPos=openPPos1
 . . i openPPos2>0,openPPos2<openPos s openPos=openPPos2
 . . ;
 . . i closePos>0,'nextPFound s %stop=1 q
 . . ;
 . . i openULPos'=0,openPos'="",openULPos<openPos s %stop=1 q
 . . ;
 . . i closePos>0,nextPFound d  q
 . . . n str,strx,len
 . . . s str=$e(buf2,1,openPos)
 . . . s strx=$re(str)
 . . . s strx=$$convertSubstringCase(strx,"il<")
 . . . s strx=$p(strx,"il<",2)
 . . . s str=$re(strx)
 . . . s len=$l(str)
 . . . s buf2=str_"</li>"_$e(buf2,len+1,$l(buf2))
 . . . ;s ^%work($j,lineNo)=buf2
 . . . s ^CacheTempEWD($j,lineNo)=buf2
 . . . s %stop=1
 ;
 QUIT
 ;
closeLI(tagName,buf)
 n findStr,%p1,%p2
 s findStr="</"_tagName_">"
 s %p1=$p(buf,findStr,1)
 s %p2=$p(buf,findStr,2,5000)
 s buf=%p1_"</li>"_findStr_%p2
 QUIT
 ;
getLineFromBuffer(isText,tagName,buf,nextLine,textArray)
 ;
 n maxLine,stop
 k textArray
 s maxLine=$o(^CacheTempEWD($j,""),-1)
 s stop=0
 f  d  q:stop
 . i $g(^CacheTempEWD($j,nextLine))'="" s stop=1 q
 . s nextLine=nextLine+1
 . i nextLine>maxLine s stop=1 q
 i $l(buf)<2000,$d(^CacheTempEWD($j,nextLine)) d
 . s buf=buf_^CacheTempEWD($j,nextLine)
 . s nextLine=nextLine+1
 ;
 i isText d
 . n buf1
 . ;s buf1=$zstrip(buf,"<>W")
 . s buf1=$$stripSpaces^%zewdAPI(buf)
 . i $e(buf1,1,2)=$c(13,10) d
 . . s buf1=$e(buf1,3,$l(buf1))
 . . ;s buf1=$zstrip(buf1,"<>W")
 . . s buf1=$$stripSpaces^%zewdAPI(buf1)
 . e  d
 . . i $e(buf1,1)=$c(10) d
 . . . s buf1=$e(buf1,2,$l(buf1))
 . . . ;s buf1=$zstrip(buf1,"<>W")
 . . . s buf1=$$stripSpaces^%zewdAPI(buf1)
 . i $e(buf1,1,10)["<ewd:" s isText=0
 i isText QUIT $$getScriptText(.buf,tagName,.nextLine,.textArray)
 i $e(buf,1,4)="<!--" QUIT $$getCommentText(.buf)
 i $e(buf,1)="<" QUIT $$getTagFromBuffer(.buf)
 QUIT $$getTextFromBuffer(.buf,.nextLine,.textArray)
 ;
getCommentText(buf)
 ;
 n text
 ;
 s text=$p(buf,"-->",1)_"-->"
 s buf=$p(buf,"-->",2,1000)
 ;
 QUIT text
 ;
getCDATAText(buf)
 ;
 n text
 ;
 s text=$p(buf,"]]>",1)_"]]>"
 s buf=$p(buf,"]]>",2,1000)
 ;
 QUIT text
 ;
 ;
getScriptText(buf,tagname,nextLine,textArray)
 ;
 n %c,c8,%len,n,%stop,text
 ;
 s c8="",text="",%stop=0
 s %len=$l(tagname)+2
 ;i buf'[("</"_tagname) d
 i $$zcvt^%zewdAPI(buf,"l")'[("</"_$$zcvt^%zewdAPI(tagname,"l")) d
 . ;i $g(^%work($j,nextLine))'="" d
 . i $g(^CacheTempEWD($j,nextLine))'="" d
 . . n line,%p1,npieces
 . . ;s line=^%work($j,nextLine)
 . . s line=^CacheTempEWD($j,nextLine)
 . . i line'[("</"_tagname_">") d
 . . . s textArray(1)=buf,n=1,buf="",%stop=0
 . . . f nextLine=nextLine:1 d  q:%stop
 . . . . s line=$g(^CacheTempEWD($j,nextLine))
 . . . . i line="" s %stop=1 q
 . . . . i line[("</"_tagname_">") s %stop=1 q
 . . . . s n=n+1
 . . . . s textArray(n)=line
 . . s %p1=$p(line,("</"_tagname_">"),1)
 . . i ($l(buf)+$l(%p1))>4000  d
 . . . n %dlim,%no,%np,%p2,%p3
 . . . s %dlim=$c(13,10)
 . . . i %p1'[%dlim,%p1[$c(10) s %dlim=$c(10)
 . . . s %p2=$p(%p1,%dlim,1)
 . . . s %np=$l(%p1,%dlim)
 . . . s %p3=$p(%p1,%dlim,2,%np)
 . . . s buf=buf_%p2
 . . . s %no=$o(textArray(""),-1)+1
 . . . s textArray(%no)=buf
 . . . s buf=%p3
 . . . s %p1=""
 . . . i buf["*/ewd:comment" d
 . . . . n %p10,%p11
 . . . . s %p10=$p(buf,"*/ewd:comment",1)
 . . . . i %p10'["/*ewd:comment" d
 . . . . . s %p11=$p(buf,"*/ewd:comment",2,10000)
 . . . . . s buf=%p11
 . . s buf=buf_%p1_("</"_tagname_">")
 . . s npieces=$l(line,("</"_tagname_">"))
 . . s line=$p(line,("</"_tagname_">"),2,npieces+2)
 . . ;s ^%work($j,nextLine)=line
 . . s ^CacheTempEWD($j,nextLine)=line
 s %stop=0
 f  q:%stop  d
 . s %c=$e(buf,1)
 . s c8=c8_%c,c8=$re(c8),c8=$e(c8,1,%len),c8=$re(c8)
 . i $$zcvt^%zewdAPI(c8,"L")=("</"_tagname) d  q
 . . s %stop=1
 . . s buf="</"_$e(tagname,1,$l(tagname)-1)_buf
 . . s text=$e(text,1,$l(text)-(%len-1))
 . s text=text_%c
 . s buf=$e(buf,2,$l(buf))
 ;
 i $d(textArray) d
 . n lastLine
 . s lastLine=$o(textArray(""),-1)+1
 . s textArray(lastLine)=text
 . s text="**mgwArray***"
 QUIT text
 ;
getTagFromBuffer(buf)
 ;
 n %line,%c,%stop,%sapos,%dapos,%inSingleQuotedString,%inDoubleQuotedString,%inQuotedString,%inVar
 n %firstQuoteType
 ;
 s %stop=0
 s %line=""
 s %sapos="'"
 s %dapos=""""
 s %inSingleQuotedString=0
 s %inDoubleQuotedString=0
 s %firstQuoteType=""
 s %inVar=0
 ;
 f  s %c=$$extractChar(.buf) q:%c=""  d  q:%stop
 . n %c2
 . s %c2=$e(buf,1)
 . i %c="#",%c2="(" s %inVar=1
 . i %c=")",%c2="#" s %inVar=0
 . s %line=%line_%c
 . i %line="<?" d  q
 . . s %line=%line_$p(buf,"?>",1)_"?>"
 . . s buf=$p(buf,"?>",2,2000)
 . . s %stop=1
 . i %c=%sapos d
 . . s %inSingleQuotedString='%inSingleQuotedString
 . . i %inSingleQuotedString,%firstQuoteType="" s %firstQuoteType=%sapos
 . i %c=%dapos d
 . . s %inDoubleQuotedString='%inDoubleQuotedString
 . . i %inDoubleQuotedString,%firstQuoteType="" s %firstQuoteType=%dapos
 . i %c=">" d
 . . s %stop=1
 . . i %inSingleQuotedString,'%inDoubleQuotedString,%firstQuoteType=%dapos s %stop=1 q
 . . i %inDoubleQuotedString,'%inSingleQuotedString,%firstQuoteType=%sapos s %stop=1 q
 . . I %inSingleQuotedString s %stop=0
 . . i %inDoubleQuotedString s %stop=0
 . . i %inVar s %stop=0
 ;
 Q %line
 ;
getTextFromBuffer(buf,nextline,textArray)
 ;
 n text,pos,tag,%stop,i
 ;
 k textArray
 s text=""
 s %stop=0
 ;
 i buf'["<" d  QUIT text
 . s text="**mgwArray***"
 . s textArray(1)=buf
 . f i=2:1 d  q:%stop
 . . ;i '$d(^%work($j,nextLine)) s %stop=1,buf="" Q
 . . i '$d(^CacheTempEWD($j,nextLine)) s %stop=1,buf="" Q
 . . ;s buf=$g(^%work($j,nextLine))
 . . s buf=$g(^CacheTempEWD($j,nextLine))
 . . s nextLine=nextLine+1
 . . i buf'["<" d  q
 . . . s textArray(i)=buf
 . . s textArray(i)=$p(buf,"<",1)
 . . s pos=$f(buf,"<")
 . . s buf=$e(buf,pos-1,$l(buf))
 . . s %stop=1
 ;
 s text=text_$p(buf,"<",1)
 s pos=$f(buf,"<")
 s buf=$e(buf,pos-1,$l(buf))
 QUIT text
 ;
 ;
extractChar(buf)
 ;
 n %c
 s %c=$e(buf,1)
 s buf=$e(buf,2,$l(buf))
 QUIT %c
 ;
replacePHP(line,phpVars)
 ;
 n varNo
 ;
 s varNo=0
 k phpVars
 ;
 f  q:line'["<?="  d
 . n %p1,%p2,%p3,%p4
 . s varNo=varNo+1
 . s %p1=$p(line,"<?=",1)
 . s %p2=$p(line,"<?=",2,500)
 . s %p3=$p(%p2,"?>",1)
 . s %p4=$p(%p2,"?>",2,500)
 . s phpVars(varNo)=%p3
 . s line=%p1_"&php;"_varNo_"&php;"_%p4
 ;
 QUIT line
 ;
convPHPVars(%attr,phpVars)
 ;
 n name,value,yes
 ;
 s name=""
 f  s name=$o(%attr(name)) q:name=""  d
 . s value=%attr(name)
 . f  q:value'["&php;"  d
 . . n varNo
 . . s varNo=$p(value,"&php;",2)
 . . s value=$p(value,"&php;",1)_"<?="_$g(phpVars(varNo))_"?>"_$p(value,"&php;",3,500)
 . . s %attr(name)=value
 ;
 QUIT
 ;
parseElement(%line,%attr,%error,isHTML)
 ;
 n %pos,%c,%c2,%buf,eovalue,%tagStart,%this,tagName,attrName,%apos,%lvl,%stop,attrValue
 n %p1,%p2,%p3
 ;n replace,nreplace
 ;
 k %attr,%error
 s %line=$tr(%line,$c(9)," ")
 s %buf=%line
 s %tagStart=0
 s %this=""
 s tagName=""
 s attrName=""
 s %apos=""
 s %stop=0
 ;
 i $e(%line,1,2)="<?" d  i %stop QUIT tagName
 . n %line2,%revline
 . s %line2=$tr(%line," ","")
 . i $e(%line2,1,6)="<?ewd=" d
 . . s tagName="ewdSessionVariable"
 . . s %attr("name")=$p(%line2,"ewd=",2)
 . . s %attr("name")=$p(%attr("name"),"?",1)
 . . s %attr("/")=""
 . . s %stop=1
 . s %revline=$re(%line2)
 . i $e(%revline,1,3)=">?:" d
 . . s tagName="?php"
 . . s %attr("content")=$p(%line,"?",2)
 . . s %stop=1
 . i $e(%line,1,5)'="<?php",$e(%revline,1,3)=">?;" d
 . . s tagName="?php"
 . . s %attr("content")=$p(%line,"?",2)
 . . s %stop=1
 ;
 f %pos=1:1  d  q:%stop
 . k %c2
 . i %this="tagName",tagName="!--" d  q
 . . s %this="attrName",attrName="",%apos=""
 . s %c=$e(%buf,%pos)
 . s %c2=$e(%buf,%pos+1)
 . i '%tagStart,%c="<" s %tagStart=1 q
 . i %tagStart,%this="" s %this="tagName"
 . i %this="tagName",tagName["CDATA[",%c'=" " d  q
 . . s %attr("content")=$p($e(%buf,%pos,$l(%buf)),"]]>",1)
 . . s %stop=1
 . i %this="tagName",%c=">" s %stop=1 Q
 . i %this="tagName",tagName'="",%c="/" s %this="attrName",attrName="",%apos="",%pos=%pos-1 Q
 . i %this="tagName",%c'=" " s tagName=tagName_%c Q
 . i %this="tagName" s %this="attrName",attrName="",%apos="" Q
 . ;
 . i tagName="!--" d  q
 . . i $e(%buf,%pos-1)'=" " s %pos=%pos-1
 . . s %attr("content")=$p($e(%buf,%pos,$l(%buf)),"-->",1)
 . . s %stop=1
 . ;
 . i tagName["CDATA[" d  q
 . . s %attr("content")=$p($e(%buf,%pos-1,$l(%buf)),"]]>",1)
 . . s %stop=1
 . ;
 . i tagName="" d  q
 . . i $e(%buf,%pos-1)'=" " s %pos=%pos-1
 . . s %attr("content")=$p($e(%buf,%pos,$l(%buf)),"-->",1)
 . . s %stop=1
 . ;
 . i $e(tagName,1)="?"!($e(tagName,1)="=") d  q
 . . s %attr("content")=$p($e(%buf,%pos,$l(%buf)),"?>",1)
 . . s %attr("content")=$$stripSpaces^%zewdAPI(%attr("content"))
 . . ;s %attr("content")=$ZSTRIP(%attr("content"),"<W")
 . . ;s %attr("content")=$ZSTRIP(%attr("content"),">W")
 . . s %stop=1
 . i $e(tagName,1)="%" d  q
 . . s %attr("content")=$p($e(%buf,%pos,$l(%buf)),"%>",1)
 . . s %attr("content")=$$stripSpaces^%zewdAPI(%attr("content"))
 . . ;s %attr("content")=$ZSTRIP(%attr("content"),"<W")
 . . ;s %attr("content")=$ZSTRIP(%attr("content"),">W")
 . . s %stop=1
 . ;
 . i %this="attrName",attrName="",%c=">" s %stop=1 Q
 . i %this="attrName",attrName="",%c="""" d  Q
 . . s %apos=%c
 . . s attrName=attrName_%c
 . i %this="attrName",attrName'="",%c=%apos d  Q
 . . s attrName=attrName_%c
 . . s %attr(attrName)="" ;break:attrName["&csp"  ; 1111
 . . s attrName=""
 . . s %apos=""
 . i %this="attrName",%c="&",$e(%buf,%pos,%pos+7)="&cspVar;" d  Q
 . . n %stop
 . . s %stop=0
 . . s attrName="&"
 . . f %pos=%pos+1:1 d  q:%stop
 . . . s %c=$e(%buf,%pos)
 . . . s %c2=$e(%buf,%pos+1)
 . . . s attrName=attrName_%c
 . . . i %c="r",%c2=";",attrName["&cspVar;" d
 . . . . s %pos=%pos+1
 . . . . s attrName=attrName_";"
 . . . . ;s attrName=$$replaceAll(attrName,"""","&quot;")
 . . . . n num,nam
 . . . . f num=1:1 s nam="mgwVarXXX"_num q:'$d(%attr(nam))
 . . . . s %attr(nam)=attrName ;break:attrName["&csp"  ; 2222
 . . . . s %stop=1
 . i %this="attrName",%c="&",$e(%buf,%pos,%pos+4)="&php;" d  Q
 . . n %stop
 . . s %stop=0
 . . s attrName="&"
 . . f %pos=%pos+1:1 d  q:%stop
 . . . s %c=$e(%buf,%pos)
 . . . s %c2=$e(%buf,%pos+1)
 . . . s attrName=attrName_%c
 . . . i %c="p",%c2=";",attrName["&php;" d
 . . . . s %pos=%pos+1
 . . . . s attrName=attrName_";"
 . . . . ;s attrName=$$replaceAll(attrName,"""","&quot;")
 . . . . n num,nam
 . . . . f num=1:1 s nam="mgwVarXXX"_num q:'$d(%attr(nam))
 . . . . s %attr(nam)=attrName ;break:attrName["&csp"  ; 3333
 . . . . s %stop=1
 . i %this="attrName",attrName="",%c="/" d  Q
 . . s %attr("/")=""
 . i %this="attrName",%c=" ",%c2="=" s %c="=",%pos=%pos+1
 . i %this="attrName",attrName'="",%c=" ",%apos="" d  Q
 . . n found,mgwName
 . . s attrValue=""
 . . i attrName'["&cspVar;" s attrValue=attrName
 . . s mgwName="mgwVarXXX",found=0
 . . f  s mgwName=$o(%attr(mgwName)) q:mgwName=""  q:mgwName'["mgwVarXXX"  d  q:found
 . . . i %attr(mgwName)=attrName s found=1
 . . i 'found s %attr(attrName)=attrValue ;break:attrName["&csp"  ; 4444
 . . s attrName=""
 . . s %apos=""
 . i %this="attrName",attrName="",%c=" " Q
 . i %this="attrName",%c="=" s %this="attrValue",attrValue="",%apos="",%lvl=0 Q
 . i %this="attrName",((%c=">")!(%c=" ")) d  Q
 . . n attrName1,found,mgwName
 . . s attrName1=attrName
 . . i isHTML,attrName'["&cspVar" d
 . . . i isSVG,tagName'[":" q
 . . . s attrName1=$$zcvt^%zewdAPI(attrName,"L")
 . . s mgwName="mgwVarXXX",found=0
 . . f  s mgwName=$o(%attr(mgwName)) q:mgwName=""  q:mgwName'["mgwVarXXX"  d  q:found
 . . . i %attr(mgwName)=attrName s found=1
 . . i 'found s %attr(attrName1)="" ;break:attrName["&csp"  ; 5555
 . . s %this="attrName"
 . . s attrName=""
 . . s %apos=""
 . . i %c=">" s %stop=1
 . i %this="attrName" s attrName=attrName_%c Q
 . ;
 . ; must be processing a value.  Now deal with apostrophes
 . ;
 . i attrValue="",%c=" ",%c2=" " Q
 . i attrValue="",%c=" ",%c2'=" " s %c=%c2,%pos=%pos+1
 . i attrValue="",%apos="",%c="""" s %apos=%c Q
 . i attrValue="",%apos="",%c="'" s %apos=%c Q
 . i attrValue=""&(%apos="")&(%c'="""")&(%c'="'") s %apos=" "
 . ;
 . i %c=%apos d  Q
 . . n found,mgwName
 . . i %c2="&" s $e(%buf,%pos+1)=" "_%c2,%c2=" " ;s attrValue=attrValue_%c b  q ; value="List"&cspVar;9&cspVar;
 . . i %c2?1P,%c2'="/",%c2'=" ",%c2'=">",%c2'="#" s attrValue=attrValue_%c q  ; href="javascript:OpenWindow('#(..getLink("../../Help"))#',600,600,25,25)"
 . . ;                                                                                                           ^          ^
 . . ; need to cater for the following (in rs.Data("Id")) part
 . . ; <td class="listrowpadded" nowrap="nowrap"><a href="CpCatalogueView.csp?xCatalogueId=#(rs.Data("Id"))#&view=list">#(..EscapeHTML(rs.Data("Name")))#</a>&nbsp;</td>
 . . ;  in page \collpro\cpcatalogues.csp
 . . i %apos'=" ",%c2'=" ",%c2'=">",%c2'="/" d
 . . . i %c="""",%c2="""" s %c="&quot;" q
 . . . i %c="""" s $e(%buf,%pos+1)=" "_%c2,%c2=" "
 . . i attrName="" s %error="Invalid XML : "_%line,%stop=1 Q
 . . ;s attrValue=$$replaceAll(attrValue,"<","&lt;")
 . . ;s attrValue=$$replaceAll(attrValue,">","&gt;")
 . . i isHTML,attrName'["&cspVar" d
 . . . i isSVG,tagName'[":" q
 . . . s attrName=$$zcvt^%zewdAPI(attrName,"L")
 . . s mgwName="mgwVarXXX",found=0
 . . f  s mgwName=$o(%attr(mgwName)) q:mgwName=""  q:mgwName'["mgwVarXXX"  d  q:found
 . . . i %attr(mgwName)=attrName s found=1
 . . i 'found s %attr(attrName)=attrValue ;break:attrName["&csp"  ; 6666
 . . s %this="attrName"
 . . s attrName=""
 . . s %apos=""
 . ;i attrValue'="",%c=">" d  Q
 . s eovalue=0
 . i attrValue'="" d
 . . i %c="/",%c2=">" s eovalue=1 q
 . . i %c=">" s eovalue=1
 . i eovalue d  Q
 . . n attrName1
 . . i %pos=$l(%line) d
 . . . i %apos=" " s %c="" 
 . . . e  s attrValue=%apos_$e(attrValue,1,$l(attrValue)-1),%c=""
 . . i %c'="",%apos="""" s attrValue=attrValue_%c q
 . . i %c'="",%apos="'" s attrValue=attrValue_%c q
 . . s attrName1=attrName
 . . i isHTML d
 . . . i isSVG,tagName'[":" q
 . . . s attrName1=$$zcvt^%zewdAPI(attrName,"L")
 . . s %attr(attrName1)=attrValue ;break:attrName1["&csp"  ; 7777
 . . s %stop=1
 . s attrValue=attrValue_%c
 s attrName=""
 f  s attrName=$o(%attr(attrName)) q:attrName=""  d
 . k attrValue
 . s attrValue=%attr(attrName)
 . q:attrValue'[$c(1)
 . f  q:attrValue'[$c(1)  d
 . . k %p1,%p2,%p3
 . . s %p1=$p(attrValue,$c(1),1)
 . . s %p2=$p(attrValue,$c(1),2)
 . . s %p3=$p(attrValue,$c(1),3,1000)
 . . s attrValue=%p1_"#("_replace(%p2)_")#"_%p3
 . s %attr(attrName)=attrValue ;break:attrName["&csp"  ; 8888
 i tagName="!DOCTYPE" QUIT tagName
 i tagName="svg"!(tagName="ewd:svgdocument")!(tagName="ewd:svgDocument") s isSVG=1
 i isSVG,tagName'[":" QUIT tagName
 i isHTML QUIT $$zcvt^%zewdAPI(tagName,"L")
 QUIT tagName
 ;
 ;
outputDOM(docName,mode,cspFlag,cspVars,phpVars,isXHTML,technology)
 ;
 ; special version of outputDOM
 ; 
 n ok,docOID,returnValue
 ;
 s technology=$g(technology) i technology="" s technology="gtm"
 ;
 s cspFlag=+$g(cspFlag) i technology="csp" s cspFlag=1
 s isXHTML=+$g(isXHTML)
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 ;
 ; mode : "collapse" = collapse the output into a stream
 ;        "pretty"   = indented as per xml
 ;        "html"     = hybrid to keep HTML visualisation OK (may be imperfect!)
 ;
 s mode=$g(mode) i mode="" s mode="pretty"
 i isXHTML d
 . w "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">",!
 s returnValue=$$outputNode(docOID,mode,"",0,1,cspFlag,.cspVars,.phpVars,isXHTML,technology)
 ;s ok=$$$closeDOM
 Q
 ;
outputNode(nodeOID,mode,indent,suppressIndent,endWithCR,cspFlag,cspVars,phpVars,isXHTML,technology)
 ;
 n nodeType,returnValue,lastTag,nextIndent,displayIndent
 ;
 s technology=$g(technology) i technology="" s technology="gtm"
 s returnValue=""
 i mode="collapse" s suppressIndent=1,endWithCR=0
 s displayIndent=indent i suppressIndent s displayIndent=""
 s nodeType=$$getNodeType^%zewdDOM(nodeOID)
 i nodeType=1 d  Q returnValue
 . n tagName,firstChildOID,firstChildTagName,useCData
 . s tagName=$$getTagName^%zewdDOM(nodeOID)
 . s useCData=0
 . i tagName'="ewd:rawcontent" d
 . . i mode="collapse",tagName="script",technology'="csp" w !
 . . w displayIndent_"<"_$$replaceVars(tagName,.cspVars,.phpVars,technology)
 . . i tagName="style"!(tagName="script") d
 . . . i $$getAttribute^%zewdDOM("usecdata",nodeOID)="true" d
 . . . . s useCData=1
 . . . . d removeAttribute^%zewdDOM("usecdata",nodeOID)
 . . i $$hasAttributes^%zewdDOM(nodeOID)="true" d outputAttr(nodeOID,.cspVars,.phpVars,technology)
 . . i tagName="html",$g(isXHTML) d
 . . . w " xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""en"" lang=""en"""
 . . i $$hasChildNodes^%zewdDOM(nodeOID)="false" d
 . . . ;i tagName="script",cspFlag q
 . . . i tagName="script"!(tagName="td")!(tagName="div")!(tagName="textarea")!(tagName="object")!(tagName="iframe")!(tagName="select") q
 . . . w " /"
 . . w ">"
 . . i useCData w "<![CDATA["
 . i $$hasChildNodes^%zewdDOM(nodeOID)="false" d  Q
 . . ;i tagName="script",cspFlag d  q
 . . i tagName="script" d  q
 . . . ;i mode'="collapse" w displayIndent
 . . . w "</script>"
 . . . w ! 
 . . i tagName="td" d  q
 . . . ;i mode'="collapse" w displayIndent
 . . . w "</td>"
 . . . w !
 . . i tagName="textarea" d  q
 . . . w "</textarea>"
 . . i endWithCR w !
 . . i tagName="object" d  q
 . . . w "</object>",!
 . . i tagName="div" d  q
 . . . w "</div>",!
 . . i tagName="iframe" d  q
 . . . w "</iframe>",!
 . . i tagName="select" d  q
 . . . w "</select>",!
 . . i tagName="applet" d  q
 . . . w "</applet>",!
 . . i tagName="table" d  q
 . . . w "</table>",!
 . . i tagName="tr" d  q
 . . . w "</tr>",!
 . . i tagName="td" d  q
 . . . w "</td>",!
 . s firstChildOID=$$getFirstChild^%zewdDOM(nodeOID)
 . s firstChildTagName=$$getTagName^%zewdDOM(firstChildOID)
 . s nextIndent=indent_"   "
 . i tagName="textarea",$$getNodeType^%zewdDOM(firstChildOID)=7 s endWithCR=0,suppressIndent=1
 . i tagName="textarea",$$getNodeType^%zewdDOM(firstChildOID)=3 s endWithCR=0,suppressIndent=1
 . i tagName="div",$$getAttribute^%zewdDOM("dojoType",nodeOID)="dijit.form.Textarea" s endWithCR=0,suppressIndent=1
 . i tagName="textarea",firstChildTagName="script" s endWithCR=0,suppressIndent=1
 . i mode="html" d
 . . i tagName="td",firstChildTagName="img" s endWithCR=0,suppressIndent=1
 . . i tagName="td",firstChildTagName="a" s endWithCR=0,suppressIndent=1
 . . i tagName="a",firstChildTagName'="img" s endWithCR=1,suppressIndent=0
 . . i tagName="img",firstChildTagName'="" s endWithCR=1,suppressIndent=0
 . . i tagName="span",$$getNodeType^%zewdDOM(firstChildOID)=3 s endWithCR=0,suppressIndent=1
 . . ;i tagName="textarea",$$$getNodeType(firstChildOID)=7 s endWithCR=0,suppressIndent=1
 . s lastTag=$$outputChildren(nodeOID,mode,nextIndent,suppressIndent,endWithCR,cspFlag,.cspVars,.phpVars,isXHTML,technology)
 . i mode="html",tagName="td",$$countChildren(nodeOID)>1 s suppressIndent=0
 . i suppressIndent s displayIndent=""
 . i tagName'="ewd:rawcontent" d
 . . w displayIndent
 . . i useCData w "]]>"
 . . w "</"_$$replaceVars(tagName,.cspVars,.phpVars,technology)_">"
 . i mode="html",tagName="td" s endWithCR=1
 . i mode="html",tagName="span" d
 . . n siblingOID
 . . s endWithCR=1,suppressIndent=0
 . . s siblingOID=$$getNextSibling^%zewdDOM(nodeOID)
 . . i $$getNodeType^%zewdDOM(siblingOID)=3 s endWithCR=0,suppressIndent=1
 . i endWithCR w !
 ;
 i nodeType=9 s lastTag=$$outputChildren(nodeOID,mode,"",suppressIndent,1,cspFlag,.cspVars,.phpVars,isXHTML,technology) Q returnValue  ;
 ;
 i nodeType=8 d  Q returnValue
 . i 'suppressIndent w indent
 . i mode="collapse" w !
 . w "<!--"_$$replaceVars($$getData^%zewdDOM(nodeOID),.cspVars,.phpVars,technology)_"-->"
 . i endWithCR w ! q
 . i mode="collapse" w !
 ;
 i nodeType=3 d  Q returnValue
 . n delim,i,line,np,nsOID,nsType,os,text,textArray
 . s text=$$getData^%zewdDOM(nodeOID)
 . q:text="***Array***"
 . i mode="html",text?."&nbsp;" w text s endWithCR=0,suppressIndent=1 q
 . ;i 'suppressIndent w indent
 . s delim=$c(13,10)
 . i $$os()="unix"!($$os()="gtm") s delim=$c(10)
 . s np=$l(text,delim)
 . f i=1:1:np d
 . . s line=$p(text,delim,i)
 . . w $$replaceVars(line,.cspVars,.phpVars,technology)
 . . i i'=np w !
 . ;i endWithCR w !
 . ;s nsOID=$$$getNextSibling(nodeOID)
 . ;s nsType=$$$getNodeType(nsOID)
 . ;i nsType=3 w !
 ;
 i nodeType=7 d  Q returnValue
 . i 'suppressIndent w indent
 . i $$getTarget^%zewdDOM(nodeOID)="jsp" d
 . . w $$getData^%zewdDOM(nodeOID)
 . e  d
 . . w "<?"_$$replaceVars($$getTarget^%zewdDOM(nodeOID),.cspVars,.phpVars,technology)
 . . w " "_$$replaceVars($$getData^%zewdDOM(nodeOID),.cspVars,.phpVars,technology)
 . . w " ?>"
 . i endWithCR w !
 ;
 i nodeType=10 d  Q returnValue
 . i 'suppressIndent w indent
 . w "<!DOCTYPE "_$$getName^%zewdDOM(nodeOID)
 . i $$getPublicId^%zewdDOM(nodeOID)'="" w " PUBLIC """_$$getPublicId^%zewdDOM(nodeOID)_""""
 . i $$getSystemId^%zewdDOM(nodeOID)'="" w " """_$$getSystemId^%zewdDOM(nodeOID)_""""
 . w ">"
 . i endWithCR w !
 Q returnValue
 ;
outputChildren(parentOID,mode,indent,suppressIndent,endWithCR,cspFlag,cspVars,phpVars,isXHTML,technology)
 ;
 n childOID,siblingOID,indent1,returnValue,cr
 ;
 i $g(mode)="collapse" s suppressIndent=1,endWithCR=0
 s childOID=$$getFirstChild^%zewdDOM(parentOID)
 i nodeType'=9,endWithCR w !
 s returnValue=$$outputNode(childOID,mode,indent,suppressIndent,endWithCR,cspFlag,.cspVars,.phpVars,isXHTML,technology)
 s siblingOID=childOID
 i mode="html" s suppressIndent=0,endWithCR=1
 f  s siblingOID=$$getNextSibling^%zewdDOM(siblingOID) q:siblingOID=""  d
 . n nodeType,text
 . s nodeType=$$getNodeType^%zewdDOM(siblingOID)
 . s text=""
 . i mode="html",nodeType=3 d
 . . s text=$$getData^%zewdDOM(siblingOID)
 . . i text["&nbsp;" s endWithCR=0,suppressIndent=1
 . n returnValue1
 . ;i endWithCR w !   ****
 . s returnValue1=$$outputNode(siblingOID,mode,indent,suppressIndent,endWithCR,cspFlag,.cspVars,.phpVars,isXHTML,technology)
 . i mode="html" d
 . . s suppressIndent=0,endWithCR=1
 . . i nodeType=3,text["&nbsp;" s suppressIndent=1,endWithCR=0
 Q returnValue
 ;
outputAttr(nodeOID,cspVars,phpVars,technology)
 ;
 n attr,nlOID,len,i,attrName,attrOID,attrValue
 ;
 s technology=$g(technology) i technology="" s technology="gtm"
 s nlOID=$$getAttributes^%zewdCompiler(nodeOID,.attr)
 s attrName=""
 f  s attrName=$o(attr(attrName)) q:attrName=""  d
 . s attrOID=attr(attrName)
 . s attrValue=$$getValue^%zewdDOM(attrOID)
 . i attrValue["&cspVar" s attrValue=$$getAttributeValue^%zewdDOM(attrName,0,nodeOID)
 . ;i $e(attrValue,1)="#" s attrValue=$$replaceAll(attrValue,"&quot;","""")
 . i attrName["mgwVarXX" d  q
 . . s attrValue=$$getAttributeValue^%zewdDOM(attrName,1,nodeOID)
 . . i attrValue["&cspVar"!(attrValue["&php") s attrValue=$$getAttributeValue^%zewdDOM(attrName,0,nodeOID)
 . . w " "_$$replaceVars(attrValue,.cspVars,.phpVars,technology)
 . i attrValue["""",attrValue["'" d  q
 . . n spos,dpos
 . . s spos=$f(attrValue,"'")
 . . s dpos=$f(attrValue,"""")
 . . i spos<dpos w " "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"="""_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_"""" q
 . . w " "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"='"_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_"'" 
 . i attrValue["""" d  q
 . . w " "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"='"_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_"'" 
 . w " "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"="""_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_""""
 Q
 ;
replaceVars(string,cspVars,phpVars,technology)
 ;
 n c1,entity,npieces,npos,%p1,%p2,%p3,var
 ;
 s technology=$g(technology)
 s (%p1,%p2,%p3,npieces)=""
 s (var,c1)=""
 f entity="&cspVar;","&php;" d
 . f  q:string'[entity  d
 . . s npieces=$l(string,entity)
 . . s %p1=$p(string,entity,1)
 . . s %p2=$p(string,entity,2)
 . . s %p3=$p(string,entity,3,npieces)
 . . i entity="&cspVar;" s string=%p1_"#("_$g(cspVars(%p2))_")#"_%p3
 . . i entity="&php;" d  q
 . . . s var=$$stripSpaces^%zewdAPI($g(phpVars(%p2)))
 . . . i $e(var,1)="$" d
 . . . . s var=$e(var,2,$l(var))
 . . . . i $e(var,1)="\" s var="$$escapeQuotes^%zewdAPI("_$e(var,2,$l(var))_")"
 . . . i $e(var,1)="#" d
 . . . . n esc
 . . . . s esc=0
 . . . . i $e(var,2)="\" d
 . . . . . s esc=1
 . . . . . s var="#"_$e(var,3,$l(var))
 . . . . i var["." d
 . . . . . n np,object,property
 . . . . . s var=$e(var,2,$l(var))
 . . . . . s np=$l(var,".")
 . . . . . s object=$p(var,".",1,np-1)
 . . . . . s property=$p(var,".",np)
 . . . . . i object["[" d
 . . . . . . n index
 . . . . . . s index=$p(object,"[",2)
 . . . . . . s index=$p(index,"]",1)
 . . . . . . s object=$p(object,"[",1)
 . . . . . . i $e(index,1)="$" s index=$e(index,2,$l(index))
 . . . . . . s var="$$getResultSetValue^%zewdAPI("""_object_""","_index_","""_property_""",sessid)"
 . . . . . e  d
 . . . . . . i $e(object,1,3)="tmp" s var="$$getTmpSessionObject^%zewdAPI2("""_object_""","""_property_""",sessid)" q
 . . . . . . s var="$$getSessionObject^%zewdAPI("""_object_""","""_property_""",sessid)"
 . . . . e  d
 . . . . . i $e(var,2,4)="tmp" s var="$$getTmpSessionValue^%zewdAPI2("""_object_""","""_property_""",sessid)" q
 . . . . . s var="$$getSessionValue^%zewdAPI("""_$e(var,2,$l(var))_""",sessid)"
 . . . . i esc d
 . . . . . s var="$$escapeQuotes^%zewdAPI("_var_")"
 . . . i $e(var,1)="@" d
 . . . . n arrayValue
 . . . . s arrayValue=$g(attrValues($e(var,2,$l(var))))
 . . . . i $e(arrayValue,1)'="""",arrayValue'="" d
 . . . . . s arrayValue="<?= $"_arrayValue_" ?>"
 . . . . i $e(arrayValue,1)="""" s arrayValue=$$removeQuotes^%zewdAPI(arrayValue)
 . . . . i arrayValue["session.Data" d
 . . . . . s arrayValue=$p(arrayValue,"session.Data(""",2)
 . . . . . s arrayValue=$p(arrayValue,""")",1)
 . . . . . s arrayValue="<?= #"_arrayValue_" ?>"
 . . . . s string=%p1_arrayValue_%p3
 . . . e  s string=%p1_"#("_var_")#"_%p3
 . . i entity="&php;" d
 . . . n var,esc
 . . . ;s var=$zstrip($g(phpVars(%p2)),"<>W")
 . . . s var=$$stripSpaces^%zewdAPI($g(phpVars(%p2)))
 . . . i $e(var,1)="@" d  q
 . . . . n arrayValue
 . . . . s arrayValue=$g(attrValues($e(var,2,$l(var))))
 . . . . i $e(arrayValue,1)'="'",arrayValue'="" d
 . . . . . s arrayValue="<?= $"_arrayValue_" ?>"
 . . . . i $e(arrayValue,1)="'" s arrayValue=$$removeQuotes^%zewdAPI(arrayValue)
 . . . . s string=%p1_arrayValue_%p3
 . . . s esc=0
 . . . i $e(var,1,2)="#\" d
 . . . . s esc=1
 . . . . s var="#"_$e(var,3,$l(var))
 . . . i $e(var,1)="#" d
 . . . . n c,pos,stop
 . . . . i var["." d
 . . . . . n object,property
 . . . . . ;#resultSet[$recNo].Name
 . . . . . s var=$e(var,2,$l(var))
 . . . . . i var'["[" d
 . . . . . . n np
 . . . . . . i var'["_" s var=$$replace^%zewdAPI(var,".","_")
 . . . . . . s np=$l(var,".")
 . . . . . . i np=1 d
 . . . . . . . i esc s var=" isset($ewd_session['"_var_"']) ? escapeQuotes($ewd_session['"_var_"']) : ''"
 . . . . . . . e  s var=" isset($ewd_session['"_var_"']) ? $ewd_session['"_var_"'] : ''"
 . . . . . . e  d
 . . . . . . . n i,line,p
 . . . . . . . f i=1:1:np s p(i)=$p(var,".",i)
 . . . . . . . s line="']"
 . . . . . . . f i=2:1:np s line=line_"['"_p(i)_"']"
 . . . . . . . i esc s var=" isset($ewd_session['"_p(1)_line_") ? escapeQuotes($ewd_session['"_p(1)_line_") : ''"
 . . . . . . . e  s var=" isset($ewd_session['"_p(1)_line_") ? $ewd_session['"_p(1)_line_" : ''"
 . . . . . e  d
 . . . . . . n index
 . . . . . . s object=$p(var,".",1)
 . . . . . . s property=$p(var,".",2)
 . . . . . . s index=$p(object,"[",2)
 . . . . . . s index=$p(index,"]",1)
 . . . . . . s object=$p(object,"[",1)
 . . . . . . i esc s var=" isset($ewd_session['"_object_"']["_index_"]['"_property_"']) ? escapeQuotes($ewd_session['"_object_"']["_index_"]['"_property_"']) : ''"
 . . . . . . e  s var=" isset($ewd_session['"_object_"']["_index_"]['"_property_"']) ? $ewd_session['"_object_"']["_index_"]['"_property_"'] : ''"
 . . . . e  d
 . . . . . i esc s var=" isset($ewd_session['"_$e(var,2,$l(var))_"']) ? escapeQuotes($ewd_session['"_$e(var,2,$l(var))_"']) : ''"
 . . . . . e  s var=" isset($ewd_session['"_$e(var,2,$l(var))_"']) ? $ewd_session['"_$e(var,2,$l(var))_"'] : ''"
 . . . s string=%p1_"<?= "_var_" ?>"_%p3
 ;break:string["_tech"
 QUIT string
 ;
getOS() ;
 ;
 i $zv["GT.M" QUIT "gtm"
 I $ZV["Windows" Q "windows"
 I $$zcvt^%zewdAPI($ZV,"U")["UNIX" Q "unix"
 I $ZV["VMS" Q "vms"
 Q ""
 ;
getDirectoriesInPath(path,dirs)
 ;
 n f,file,np,%tofile,%x,%y,%io,%zt,%dir,ok,os,dlim,zt
 ;
 k dirs
 s os=$$os()
 ;
 s dlim="\" i os="unix"!(os="gtm") s dlim="/"
 i $e(path,$l(path))=dlim S path=$e(path,1,$l(path)-1)
 i $e(path,$l(path))=":" s path=path_dlim
 i path="" s path=dlim
 ;
 ;
 l +^%zewd("compiler")
 s %tofile="mgwTemp.txt" c %tofile
 ;
 i os="windows" s %x="dir/b/ad/on """_path_""">"_%tofile
 ;i os="unix"!(os="gtm")  S %x="ls -l """_path_""" > "_%tofile
 i os="unix"!(os="gtm")  S %x="ls -l """_path_"/"" > "_%tofile
 ;
 zsystem %x
 s %io=$io
 c %tofile
 d gtmDirFile(%tofile,.dirs)
 c %tofile u %io
 ;
 s ok=$$deleteFile(%tofile)
 l -^%zewd("compiler")
 ;
 i os="unix"!(os="gtm") d
 . n rawList,dir
 . m rawList=dirs
 . ;k ^rltDirs m ^rltDirs=dirs
 . k dirs
 . s dir=""
 . f  s dir=$o(rawList(dir)) q:dir=""  d
 . . n %p1
 . . s %p1=$p(dir," ",1)
 . . i $e(%p1,1)="d" d
 . . . n %rdir,%p9
 . . . s %rdir=$re(dir)
 . . . s %p9=$p(%rdir," ",1)
 . . . s %p9=$re(%p9)
 . . . s dirs(%p9)=""
 ;
 QUIT        
 ;
gtmDirFile(filepath,array)
 k array
 o filepath:(readonly)
 u filepath:exception="g eGDIP"
 f  r %dir s array(%dir)=""
eGDIP 
 QUIT
 ;
getFilesInPath(path,ext,files) ; Get list of files with specified extension
 ;
 ;
 n %io,f,f1,%tofile,%x,%y,%zt,%file,ok,os,p1,dlim
 ;
 k files
 s os=$$os()
 s dlim="\" i os="unix"!(os="gtm") s dlim="/"
 ;s %zt=$zt,%x="g eGFIP",$zt=%x
 s %tofile="mgwTemp.txt" c %tofile
 i $e(ext,1)'="." s ext="."_ext
 i os="windows" d
 . i $e(path,$l(path))'=dlim S path=path_dlim
 . s path=path_"*"_ext
 . S %x="dir/b/a-d/on """_path_""">"_%tofile
 i os="unix"!(os="gtm") d
 . i $e(path,$l(path))=dlim s path=$e(path,1,$l(path)-1)
 . S %x="ls -l """_path_""" > "_%tofile
 ;
 zsystem %x
 ;
 ; we now have directory listing in %tofile
 s %io=$i o %tofile u %tofile
 i os="windows" d
 . f  r %file q:$$zeof()  d
 . . n %e1,%e2
 . . i ext=".*" S files(%file)="" q
 . . s %e1="."_$$getFileExtension(%file),%e1=$$zcvt^%zewdAPI(%e1,"U")
 . . s %e2=$$zcvt^%zewdAPI(ext,"U")
 . . i %e1'=%e2 q
 . . s files(%file)=""
 ;
 i os="unix"!(os="gtm") d
 . n %total
 . r %total ; ignore 1st line
 . o %tofile:(readonly)
 . u %tofile:exception="g eGFIP"
 . f  r %file d
 . . n %p1
 . . s %p1=$P(%file," ",1)
 . . i $e(%p1,1)'="d" d
 . . . n %e1,%e2,%rfile,%p9,%len,%name
 . . . s %rfile=$re(%file)
 . . . s %p9=$p(%rfile," ",1)
 . . . s %p9=$re(%p9)
 . . . i $$zcvt^%zewdAPI(%p9,"l")=$$zcvt^%zewdAPI(%tofile,"l") q  ; ignore temp file
 . . . i ext=".*" s files(%p9)="" q
 . . . s %e1="."_$$getFileExtension(%p9)
 . . . i %e1'=ext q
 . . . s files(%p9)=$$getFileExtension(%p9)
 ; never reaches here
 ; 
eGFIP c %tofile u %io
 s ok=$$deleteFile(%tofile)
 QUIT
 ;
zeof() ; Test for end of file from Cache systems via $ZEOF
 I $zeof QUIT 1
 QUIT 0
 ;
 ;
getFileExtension(filename)
 ;
 n %len,%name
 s %len=$l(%file,".")
 s %name=$p(%file,".",%len)
 QUIT %name
 ;
makeDirectory(%path)
 N %x,Status
 ;
 S %x="md "_%path
 zsystem %x
 QUIT 1
 ;
os() ; Identify Operating System
 ;
 i $zv["GT.M" QUIT "gtm"
 I $ZV["Cache",$ZV["Windows" Q "windows"
 I $ZV["Open M",$ZV["Windows" Q "windows"
 I $ZV["Cache",(($ZV["Unix")!($ZV["UNIX")) Q "unix"
 I $ZV["Cache",$ZV["VMS" Q "vms"
 Q ""
 ;
countChildren(nodeOID)
 ;
 n nlOID
 ;
 set nlOID=$$getChildNodes^%zewdDOM(nodeOID)
 QUIT $$getNodeListAttribute^%zewdDOM(nlOID,"length")
 ;
convertSubstringCase(string,substring,case)
 ;
 n ucString,ucSubstring,pos1,pos2
 ;
 s case=$$zcvt^%zewdAPI($g(case),"U") i case="" s case="L"
 s ucString=$$zcvt^%zewdAPI(string,"U")
 s ucSubstring=$$zcvt^%zewdAPI(substring,"U")
 s pos2=$f(ucString,ucSubstring) i pos2=0 QUIT string
 s pos1=pos2-$l(substring)-1
 QUIT $e(string,1,pos1)_$$zcvt^%zewdAPI(substring,case)_$e(string,pos2,$l(string))
 ;
extractFileToArray(filename,array)
 ;
 n x,i,%io
 ;
 s x="g exf",$zt=x
 s %io=$io
 o filename
 u filename
 f i=1:1 r x q:$$zeof()  s array(i)=x
exf ;
 c filename 
 u %io 
 QUIT
 ;
getMacAddress()
 ;
 n result,macAddress,lineNo,line,%stop
 ;
 d ipconfigAll(.result)
 ;
 s lineNo="",%stop=0
 f  s lineNo=$o(result(lineNo)) q:lineNo=""  d  q:%stop
 . s line=result(lineNo)
 . i line'["Physical Address" q
 . s macAddress=$p(line,". : ",2)
 . s %stop=1
 ;
 QUIT macAddress
 ;
 ;
ipconfigAll(result)
 ;
	n file,x,y,i,line,time
	;
	k result
	s time=$P($h,",",2)
	s file="ipconfig"_time_".txt"
	s x="ipconfig /all >"_file
	zsystem x
	s x="g eop"
	s $zt=x
	c file
	o file
	u file
	f i=1:1 r line s result(i)=line
eop	c file
	i $$deleteFile(file)
	QUIT 1
 ;
deleteFile(filepath)
 ;QUIT $zu(140,5,filepath)
 QUIT $$deleteFile^%zewdAPI(filepath)
 ;
renameFile(filepath,newpath)
 ;QUIT $zu(140,6,filepath,newpath)
 QUIT $$renameFile^%zewdAPI(filepath,newpath)
 ;
