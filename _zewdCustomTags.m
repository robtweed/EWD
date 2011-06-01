%zewdCustomTags	; Enterprise Web Developer Custom Tag Library Functions
 ;
 ; Product: Enterprise Web Developer (Build 865)
 ; Build Date: Wed, 01 Jun 2011 11:03:43
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
export(tagNames,tagProcessorRouNames,exportFilePath)
 ;
 n applyTo,attr,cdOID,className,ctOID,ctsOID,docName,docName2,docOID,empty
 n ewdOID,file,i,line,lineNo,list,max,md,method,methodName,n,no,ok,p1,prefix
 n rn,rouName,rousOID,rouOID,stop,tagName,tbOID,text,text64,textOID,tn,tpOID,x,xOID
 ;
 s docName="customTagExport"_$tr($h,",","")
 s exportFilePath=$g(exportFilePath)
 i exportFilePath="" QUIT "You must specify a file path for the export file"
 i exportFilePath[".",$e(exportFilePath,$l(exportFilePath)-3,$l(exportFilePath))'="xml" QUIT "If you specify a file extension, it must be .xml"
 i exportFilePath'[".xml" s exportFilePath=exportFilePath_".xml"
 i '$$openNewFile(exportFilePath) QUIT "Unable to create the file you specified"
 c exportFilePath
 s docOID=$$newXMLDocument^%zewdDOM(docName,"ewdCustomTagExport",1)
 s ewdOID=$$getDocumentElement^%zewdDOM(docOID)
 s ctsOID=$$addElementToDOM^%zewdDOM("customTags",ewdOID)
 s tagName=""
 f  s tagName=$o(tagNames(tagName)) q:tagName=""  d
 . i $e(tagName,$l(tagName)-1,$l(tagName))=":*" d
 . . s tn=$p(tagName,":",1)_":"
 . . s prefix=tn
 . . f  s tn=$o(^%zewd("customTag",tn)) q:tn=""  q:tn'[prefix  d
 . . . s tagNames(tn)=""
 . . k tagNames(tagName)
 ;
 s tagName=""
 f  s tagName=$o(tagNames(tagName)) q:tagName=""  d
 . s attr("name")=tagName
 . s ctOID=$$addElementToDOM^%zewdDOM("customTag",ctsOID,,.attr)
 . s method=$$getCustomTagMethod^%zewdCompiler(tagName)
 . s xOID=$$addElementToDOM^%zewdDOM("method",ctOID,,,method)
 . s empty=+$$isImpliedCloseTag^%zewdCompiler(tagName)
 . s xOID=$$addElementToDOM^%zewdDOM("empty",ctOID,,,empty)
 . s applyTo=$$getCustomTagApply^%zewdCompiler(tagName)
 . s xOID=$$addElementToDOM^%zewdDOM("applyTo",ctOID,,,applyTo)
 . s text=""
 . s lineNo=0
 . f  s lineNo=$o(^%zewd("customTag",tagName,"tagNotes",lineNo)) q:lineNo=""  d
 . . s text=text_^%zewd("customTag",tagName,"tagNotes",lineNo)_$c(13,10)
 . s text=$$encodeBase64(text)
 . s xOID=$$addElementToDOM^%zewdDOM("documentation",ctOID,,,text)
 ;
 s rousOID=$$addElementToDOM^%zewdDOM("routines",ewdOID)
 s rouName=""
 f  s rouName=$o(tagProcessorRouNames(rouName)) q:rouName=""  d
 . i $e(rouName,$l(rouName))="*" d
 . . n currPath,files,rname
 . . s rn=$p(rouName,"*",1)
 . . s currPath=$$pwd^%zewdGTM()
 . . d getFilesInPath^%zewdHTMLParser(currPath,".m",.files)
 . . s prefix=rn
 . . i $e(prefix,1)="%" s prefix="_"_$e(prefix,2,$l(prefix))
 . . f  s rn=$o(files(rn)) q:rn=""  q:rn'[prefix  d
 . . . s rname=$e(rn,1,$l(rn)-2)
 . . . i $e(rname,1)="_" s rname="%"_$e(rname,2,$l(rname))
 . . . s tagProcessorRouNames(rname)=""
 . . k tagProcessorRouNames(rouName)
 s rouName=""
 f  s rouName=$o(tagProcessorRouNames(rouName)) q:rouName=""  d
 . s attr("name")=rouName
 . s rouOID=$$addElementToDOM^%zewdDOM("routine",rousOID,,.attr)
 . s stop=0
 . f i=1:1 d  q:stop
 . . s x="s line=$t(+0+i^"_rouName_")" x x
 . . s line(i)=line
 . . i line(i)="",line(i-1)="",line(i-2)="" s stop=1 q
 . s max=i-3
 . f i=i:-1:max+1 k line(i)
 . s text="",no=0
 . f i=1:1:max d
 . . s text=text_line(i)_$c(13,10)
 . . i i=max!($l(text)>2000) d
 . . . s no=no+1
 . . . s text64=$$encodeBase64(text)
 . . . s text=""
 . . . s attr("no")=no
 . . . s tbOID=$$addElementToDOM^%zewdDOM("textBlock",rouOID,,.attr)
 . . . s textOID=$$createTextNode^%zewdDOM(text64,docOID)
 . . . s textOID=$$appendChild^%zewdDOM(textOID,tbOID)
 s ok=$$openNewFile(exportFilePath)
 u exportFilePath
 s ok=$$outputDOM^%zewdDOM(docOID,1,0)
 c exportFilePath
 i $$removeDocument^%zewdDOM(docName)
 d createTarGz^%zewdGTM(exportFilePath,$p(exportFilePath,".xml",1))
 s ok=$$deleteFile^%zewdAPI(exportFilePath)
 ;
 QUIT ""
 ;
import(filePath)
 ;
 n childNo,childOID,ctOID,docName,error,i,j,n,name,no,nodes,np,offset
 n ok,OIDArray,prop,rou,rouFile,tagName,text,textarr
 ;
 s docName="customTagImport"_$tr($h,",","")
 s error=$$parseFile^%zewdHTMLParser(filePath,docName,,,0)
 i error'="" QUIT error
 s n=$$select^%zewdXPath("/ewdCustomTagExport/customTags/customTag",docName,.nodes)
 f i=1:1:n d
 . s ctOID=nodes(i)
 . s name=$$getAttribute^%zewdDOM("name",ctOID)
 . d getChildrenInOrder^%zewdDOM(ctOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . s text=$$getElementText^%zewdDOM(childOID,.textarr)
 . . s prop(tagName)=text
 . s ok=$$setCustomTag^%zewdCompiler(name,prop("method"),prop("empty"),,prop("applyTo"))
 . s text=$$decodeBase64(prop("documentation"))
 . s np=$l(text,$c(13,10))-1
 . f j=1:1:np s ^%zewd("customTag",name,"tagNotes",j)=$p(text,$c(13,10),j)
 . s ^%zewd("customTag",name,"tagNotes",0)=j
 . w !,"Custom tag "_name_" imported",!
 ;
 s n=$$select^%zewdXPath("/ewdCustomTagExport/routines/routine",docName,.nodes)
 s error=""
 f i=1:1:n d  q:error'=""
 . s ctOID=nodes(i)
 . s name=$$getAttribute^%zewdDOM("name",ctOID)
 . d getChildrenInOrder^%zewdDOM(ctOID,.OIDArray)
 . s childNo="" k rou
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s no=$$getAttribute^%zewdDOM("no",ctOID)
 . . s text=$$getElementText^%zewdDOM(childOID,.textarr)
 . . i text="***Array***" d
 . . . s j="",text=""
 . . . f  s j=$o(textarr(j)) q:j=""  d
 . . . . s text=text_textarr(j)
 . . s text=$$decodeBase64(text)
 . . s np=$l(text,$c(13,10))-1
 . . s offset=+$o(rou(""),-1)
 . . f j=1:1:np s rou(j+offset)=$p(text,$c(13,10),j)
 . s rouFile=name_".m"
 . i $$openFile^%zewdAPI(rouFile) d
 . . w !,"Importing routine file "_rouFile_" but you already have a copy",!
 . . w "Do you want the new version to overwrite your existing version? (Y/N): "
 . . r ok#1
 . . i ok="y"!(ok="Y") d
 . . . s ok=1
 . . e  d
 . . . s ok=0
 . e  d
 . . w !,"Creating routine file "_rouFile,!
 . . s ok=1
 . i ok d
 . . s ok=$$deleteFile^%zewdAPI(rouFile)
 . . i '$$openNewFile^%zewdAPI(rouFile) s error="Unable to create the routine file" q
 . . u rouFile
 . . s j=""
 . . f  s j=$o(rou(j)) q:j=""  w rou(j),!
 . . c rouFile
 . e  d
 . . w !,rouFile_" was skipped and not imported",!
 QUIT ""
 ;
openNewFile(filepath)
 o filepath:(noreadonly:variable:newversion:exception="g openNewFileNotExists1") 
 QUIT 1
openNewFileNotExists1 ;
 QUIT 0
 ;
decodeBase64(string)
 n context
 s context=1
 i $d(^zewd("config","MGWSI")) s context=0
 QUIT $$DB64^%ZMGWSIS(string,context)
	;
encodeBase64(string)
 n context
 s context=1
 i $d(^zewd("config","MGWSI")) s context=0
 QUIT $$B64^%ZMGWSIS(string,context)
 ;
 ; for use in third party custom tags (eg as used in ExtJS.m)
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
loadFiles(appName,type,sessid)
 ;
 n defer,deferAttr,file,path,src,technology,value
 ;
 ; type = css|js
 ;
 s technology=$$getSessionValue^%zewdAPI("ewd.technology",sessid)
 i technology="",$zv["Cache" s technology="wl"
 i technology="" s technology="gtm"
 s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 i $e(path,$l(path))'="/" s path=path_"/"
 i type="js",$d(^zewd("loader",appName,type,"ewdSTJS.js")) d
 . s src=path_"ewdSTJS.js"
 . w "<script src='"_src_"' type='text/javascript'></script>"_$c(13,10)
 s file=""
 f  s file=$o(^zewd("loader",appName,type,file)) q:file=""  d
 . i file="ewdSTJS.js" q
 . i $e(file,1,3)'="ewd" q
 . s value=^zewd("loader",appName,type,file)
 . s defer=$p(value,$c(1),2)
 . s deferAttr=""
 . i defer s deferAttr=" defer='defer'"
 . s src=file
 . i $e(file,1)'="/" s src=path_file 
 . i type="js" w "<script src='"_src_"' type='text/javascript'"_deferAttr_"></script>"_$c(13,10)
 . i type="css" w "<link href='"_src_"' rel='stylesheet' type='text/css' />"_$c(13,10)
 ;
 s file=""
 f  s file=$o(^zewd("loader",appName,type,file)) q:file=""  d
 . i $e(file,1,3)="ewd" q
 . s value=^zewd("loader",appName,type,file)
 . s defer=$p(value,$c(1),2)
 . s deferAttr=""
 . i defer s deferAttr=" defer='defer'"
 . s src=file
 . i $e(file,1)'="/" s src=path_file 
 . i type="js" w "<script src='"_src_"' type='text/javascript'"_deferAttr_"></script>"_$c(13,10)
 . i type="css" w "<link href='"_src_"' rel='stylesheet' type='text/css' />"_$c(13,10)
 ;
 QUIT
 ;
registerResource(type,fileName,source,app,defer)
 ;
 i fileName'[("."_type) s fileName=fileName_"."_type
 s defer=$g(defer)
 s ^zewd("loader",$$zcvt^%zewdAPI(app,"l"),type,fileName)=source_$c(1)_defer
 ;
 QUIT
 ;
createCustomResources(app)
 ;
 n fileName,source,type
 ;
 s app=$$zcvt^%zewdAPI(app,"l")
 f type="css","js" d
 . s fileName=""
 . f  s fileName=$o(^zewd("loader",app,type,fileName)) q:fileName=""  d
 . . s source=$p(^zewd("loader",app,type,fileName),$c(1),1)
 . . i source="" q
 . . d createResource(fileName,source)
 QUIT
 ;
createResource(fileName,source)
 ;
 n delim,io,label,line,lineNo,filePath,outputPath,routine,x
 ;
 s label=$p(source,"^",1)
 s routine="^"_$p(source,"^",2)
 s outputPath=$g(^zewd("config","jsScriptPath",technology,"outputPath"))
 s delim=$$getDelim^%zewdAPI()
 i $e(outputPath,$l(outputPath))'=delim s outputPath=outputPath_delim
 s filePath=outputPath_fileName
 s io=$io
 i '$$openNewFile^%zewdCompiler(filePath) q
 u filePath
 s x="f lineNo=1:1 s line=$t("_label_"+lineNo"_routine_") q:line[""***END***""  w $p(line,"";;"",2,200)_$c(10)"
 x x
 c filePath u io
 ;
 QUIT
 ;
getComboMatches(sessid)
 ;
 n app,id,json,list,no,options,prefix,x
 ;
 s prefix=$$getRequestValue^%zewdAPI("seed",sessid)
 s id=$$getRequestValue^%zewdAPI("id",sessid)
 s app=$$getSessionValue^%zewdAPI("ewd.appName",sessid)
 s x=$g(^zewd("comboMethod",app,id))
 i x="" d  QUIT ""
 . ;d setSessionValue^%zewdAPI("ewdComboMatches","[]",sessid)
 s x="d "_x_"(prefix,.options)"
 x x
 s no=""
 f  s no=$o(options(no)) q:no=""  d
 . s list(no,"text")=options(no)
 d saveListToSession^%zewdSTAPI(.list,"ewdComboMatches",sessid)
 ;s json=$$arrayToJSON^%zewdJSON("list")
 ;d setSessionValue^%zewdAPI("ewdComboMatches",json,sessid)
 QUIT ""
 ;
startupImage(phoneImg,tabletImg,sessid)
 ;
 n img,type
 ;
 s img=$g(tabletImg)
 s type=$$getSessionValue^%zewdAPI("ewd.browserType",sessid)
 i type="iphone"!(type="androidphone") s img=$g(phoneImg)
 d setSessionValue^%zewdAPI("ewd.startupImage",img,sessid)
 QUIT
 ;
