%zewdCompiler	; Enterprise Web Developer Compiler
 ;
 ; Product: Enterprise Web Developer (Build 838)
 ; Build Date: Tue, 25 Jan 2011 16:34:09
 ; 
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
getVersion()
 ;
 n version
 ;
 s version=$t(version^%zewdCompiler2)
 QUIT $p(version,";; ",2)
 ;
openNewFile(filepath)
 o filepath:(noreadonly:variable:newversion:exception="g openNewFileNotExists") 
 QUIT 1
openNewFileNotExists
 QUIT 0
 ;
openFile(filepath)
 o filepath:(readonly:exception="g openFileNotExists")
 QUIT 1
openFileNotExists
 s $zt=""
 QUIT 0
 ;
getDate()
 ;
 n date
 ;
 s date=$t(date^%zewdCompiler2)
 QUIT $p(date,";; ",2)
 ;
validPath(path,includesFilename,deleteFile)
 ;
 n file,dlim,ok
 ;
 s includesFilename=+$g(includesFilename)
 s deleteFile=$g(deleteFile)
 i deleteFile="" s deleteFile=1
 s dlim=$$getDelim()
 i $e(path,$l(path))'=dlim s path=path_dlim
 i includesFilename s file=path
 e  s file=path_"ewdTestFile.php"
 i '$$openNewFile(file) QUIT 0
 ;o file:"nw":2 e  Q 0
 c file
 i deleteFile s ok=$$deleteFile^%zewdHTMLParser(file)
 QUIT 1
 ;
getDelim()
 ;
 n os
 ;
 s os=$$os^%zewdHTMLParser()
 i os="windows" QUIT "\"
 QUIT "/"
 ;
 ;
compileAll(app,mode,technology,outputPath,multilingual,templateFilename,maxLines)
 ;
 n appx,backend,dlim,error,ewd,files,ok,outputAs,path
 ;
 i '$d(^zewd) d install^%zewdGTM i '$d(^zewd) QUIT
 s ^%zewd("relink")=1 k ^%zewd("relink","process")
 s ok=$$getConfig^%zewdCompiler16(.ewd)
 k ^%zewdIndex($$zcvt^%zewdAPI(app,"l"))
 s multilingual=+$g(multilingual)
 i multilingual="" s multilingual=$$getDefaultMultiLingual()
 i $g(mode)="" s mode=$$getDefaultFormat()
 i mode="" s mode="pretty"
 s backend=""
 s technology="gtm"
 s backend="m"
 ;
 s path=$$getApplicationRootPath()
 s dlim=$$getDelim()
 i $e(path,$l(path))'=dlim s path=path_dlim
 s path=path_app
 i '$$validPath(path) w !,"The path "_path_" is invalid and/or does not exist.  Compilation aborted" QUIT
 ;
 s outputPath=$g(outputPath)
 i outputPath="" d
 . s appx=app
 . s outputPath=$$getOutputRootPath(technology)
 . ;d trace^%zewdAPI("fecthed outputPath as "_outputPath)
 . i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 . s outputPath=outputPath_app
 e  d
 . s appx=outputPath
 ;
 d getFilesInPath^%zewdHTMLParser(path,".ewd",.files)
 ;i '$d(files) w !,"No .ewd design pages exist in this path. Compilation aborted" QUIT
 ;
 s error=$$processApplication(path,outputPath,1,mode,,technology,,multilingual,$g(templateFilename),$g(maxLines))
 i error'="" w !,"An error occurred : "_error
 QUIT
 ;
compilePage(app,page,mode,technology,outputPath,multilingual,maxLines)
 ;
 n appx,backend,dlim,error,ewd,exists,filepath,ok,path
 ;
 i '$d(^zewd) d install^%zewdGTM i '$d(^zewd) QUIT
 s ^%zewd("relink")=1 k ^%zewd("relink","process")
 s ok=$$getConfig^%zewdCompiler16(.ewd)
 ;
 s multilingual=+$g(multilingual)
 i multilingual="" s multilingual=$$getDefaultMultiLingual()
 i $g(mode)="" s mode=$$getDefaultFormat()
 i $g(mode)="" s mode="pretty"
 s technology="gtm"
 s backend="m"
 i $g(app)="" w !,"No application specified" QUIT
 i $g(page)="" w !,"No page specified" QUIT
 i page'[".ewd" s page=page_".ewd"
 ;
 s path=$$getApplicationRootPath()
 s dlim=$$getDelim()
 i page[dlim d
 . i $e(page,1)=dlim s page=$e(page,2,$l(page))
 i $e(path,$l(path))'=dlim s path=path_dlim
 i '$$validPath(path_app_dlim) w !,"The path "_path_" is invalid.  Compilation aborted" QUIT
 s filepath=path_app_dlim_page
 ;s exists=$zu(140,4,filepath)
 s exists=$$fileExists^%zewdAPI(filepath)
 i exists<0 w !,"The file "_filepath_" could not be found. Compilation aborted" QUIT
 ;
 s outputPath=$g(outputPath) 
 i outputPath="" d
 . s appx=app
 . s outputPath=$$getOutputRootPath(technology)
 . i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 . s outputPath=outputPath_app
 . i page[dlim d
 . . n len
 . . s len=$l(page,dlim)
 . . s outputPath=outputPath_dlim_$p(page,dlim,1,len-1)
 e  d
 . s appx=outputPath
 s error=$$processOneFile(filepath,outputPath,1,mode,technology,multilingual,$g(maxLines))
 i error'="" w !,"An error occurred : "_error
 QUIT
 ;
setApplicationRootPath(path)
 ;
 i $g(path)="" QUIT
 s ^zewd("config","applicationRootPath")=path
 QUIT
 ;
getHomePage()
 ;
 QUIT $g(^zewd("config","homePage"))
 ;
setHomePage(homePageURL)
 s ^zewd("config","homePage")=homePageURL
 QUIT
 ;
getDefaultTechnology()
 ;
 n tech
 s tech="gtm"
 QUIT tech
 ;
setDefaultTechnology(technology)
 s ^zewd("config","defaultTechnology")="gtm"
 QUIT
 ;
setDefaultMultiLingual(multiLingual)
 i $g(multiLingual)="" s multiLingual="0"
 s ^zewd("config","defaultMultiLingual")=multiLingual
 QUIT
 ;
getDefaultMultiLingual()
 ;
 n multiLingual
 s multiLingual=+$g(^zewd("config","defaultMultiLingual"))
 QUIT multiLingual
 ;
getDefaultFormat()
 ;
 n format
 s format=$g(^zewd("config","defaultFormat"))
 i format="" s format="pretty"
 QUIT format
 ;
setDefaultFormat(format)
 i $g(format)="" s format="pretty"
 s ^zewd("config","defaultFormat")=format
 QUIT
 ;
getApplicationRootPath()
 ;
 n path
 ;
 s path=$g(^zewd("config","applicationRootPath"))
 i path="" s path="/usr/ewdapps"
 QUIT path
 ;
applicationRootPath()
 ;
 QUIT $g(^zewd("config","applicationRootPath"))
 ;
setOutputRootPath(path,technology)
 ;
 i $g(path)="" QUIT
 i $g(technology)="" QUIT
 s ^zewd("config","outputRootPath",technology)=path
 QUIT
 ;
getOutputRootPath(technology)
 ;
 QUIT ""
 ;
getUseRootURL()
 ;
 QUIT +$g(^zewd("config","useRootURL"))
 ;
setUseRootURL(value)
 ;
 s ^zewd("config","useRootURL")=value
 QUIT
 ;
getRootURL(technology)
 n url
 ;
 s technology="gtm"
 s url=$g(^zewd("config","RootURL",technology))
 i technology="gtm",url="" s url="/ewd/"
 i url="" s url="/"_technology
 QUIT url
 ;
setRootURL(url,technology)
 ;
 i $g(url)="" QUIT
 i $g(technology)="" QUIT
 i $e(url,$l(url))="/" s url=$e(url,1,$l(url)-1)
 s ^zewd("config","RootURL",technology)=url
 QUIT
 ;
addToReport(text,results)
 ;
 n lineNo
 s lineNo=$o(results(""),-1)+1
 s results(lineNo)=text
 i $$os^%zewdHTMLParser()="gtm" d
 . s lineNo=$o(^ewdResults($j,""),-1)+1
 . s ^ewdResults($j,lineNo)=text
 QUIT
 ;
processApplication(inputPath,outputPath,verbose,outputStyle,results,technology,clearResults,multilingual,templateFilename,maxLines)
	;
	n checkboxNo,files,dirs,dir,delim,error,isDojo,isIwd,mgwsiServer,mode
	;
	; outputStyle = "collapse" | "pretty"
	;
	s multilingual=+$g(multilingual)
	s clearResults=$g(clearResults) i clearResults="" s clearResults=1
	i clearResults k results
	s outputStyle=$g(outputStyle)
	i outputStyle="" s outputStyle="collapse"
	s mode=outputStyle
	;
	i $g(inputPath)="" d  q
	. i $g(verbose)=1 w !,"Error : No input path specified"
	. i $g(verbose)=2 d addToReport("Error : No input path specified",.results)
	;
	s delim=$$getDelim()
	s outputPath=$g(outputPath)
	i outputPath="" s outputPath=inputPath
	i $e(inputPath,$l(inputPath))'=delim s inputPath=inputPath_delim
	i $e(outputPath,$l(outputPath))'=delim s outputPath=outputPath_delim
	;
	d getDirectoriesInPath^%zewdHTMLParser(inputPath,.dirs)
	d getFilesInPath^%zewdHTMLParser(inputPath,"ewd",.files)
	s error=$$processFiles(.files,inputPath,outputPath,+$g(verbose),outputStyle,technology,multilingual,.mgwsiServer,$g(templateFilename),$g(maxLines))
	i error'="" QUIT error
	;
	s dir=""
	f  s dir=$o(dirs(dir)) q:dir=""  d  i error'="" q
	. n newInputPath,newOutputPath
	. s newInputPath=inputPath_dir
	. s newOutputPath=outputPath_dir
	. d createDirectory(newOutputPath)
	. s error=$$processApplication(newInputPath,newOutputPath,+$g(verbose),outputStyle,.results,technology,0,multilingual,$g(templateFilename),$g(maxLines))
	i error'="" QUIT error
	i '$d(files) QUIT ""
	;	
	i outputPath'[$$getOutputRootPath^%zewdCompiler(technology) d
	. n delim,rootPath
	. s rootPath=$$getOutputRootPath^%zewdCompiler(technology)
	. s delim="/"
	. i rootPath["\" s delim="\"
	. s outputPath=rootPath_delim_outputPath
	;
	d createJSFile^%zewdCompiler19(outputPath,+$g(verbose),technology)
	d createCSSFile^%zewdCompiler13(outputPath,$g(outputStyle),+$g(verbose),technology)
	d createEwdError^%zewdGTMRuntime($g(maxLines))
	QUIT ""
	;
processOneFile(filepath,outputPath,verbose,mode,technology,multilingual,maxLines)
	;
	n app,checkboxNo,delim,dir,isDojo,isIwd,error,file,files,inputPath,np,npieces,page
	n $etrap
	;
	k results
	s multilingual=$g(multilingual)
	i multilingual="" s multilingual=$$getDefaultMultiLingual()
	s delim=$$getDelim()
	s npieces=$l(filepath,delim)
	s file=$p(filepath,delim,npieces)
	s files(file)=""
	s inputPath=$p(filepath,delim,1,npieces-1)
	i outputPath="" s outputPath=inputPath
	i $e(outputPath,$l(outputPath))'=delim s outputPath=outputPath_delim
	;
	s app=$$zcvt^%zewdAPI($p(filepath,delim,npieces-1),"l")
	s page=$$zcvt^%zewdAPI($p(file,".ewd",1),"l")
	s np=""
	f  s np=$o(^%zewdIndex(app,"pageCalls",page,np)) q:np=""  d
	. k ^%zewdIndex(app,"pageCalls",page,np)
	. k ^%zewdIndex(app,"pageCalledBy",np,page)
	s np=""
	f  s np=$o(^%zewdIndex(app,"scriptCalls",page,np)) q:np=""  d
	. k ^%zewdIndex(app,"scriptCalls",page,np)
	. k ^%zewdIndex(app,"scriptCalledBy",np,page)
	;
	s np=""
	f  s np=$o(^%zewdIndex(app,"tagCalls",page,np)) q:np=""  d
	. k ^%zewdIndex(app,"tagCalls",page,np)
	. k ^%zewdIndex(app,"tagCalledBy",np,page)
	;
	d getFilesInPath^%zewdHTMLParser(inputPath,"ewd",.dir)
	i $d(dir("ewdTemplate.ewd")) s files("ewdTemplate.ewd")=""
	s error=$$processFiles(.files,inputPath,$g(outputPath),+$g(verbose),$g(mode),technology,multilingual,,,$g(maxLines))
	i error'="" QUIT error
	d createJSFile^%zewdCompiler19(outputPath,+$g(verbose),technology)
	d createCSSFile^%zewdCompiler13(outputPath,$g(mode),+$g(verbose),technology)
	QUIT ""
	;
getmgwsiServer(templateDocName)
	;
	n defaultServer,nodeOID,mgwsiServer,ok
	;
	s defaultServer="LOCAL" i $$os^%zewdHTMLParser()="gtm" s defaultServer="gtm"
	s ok=$$openDOM^%zewdAPI()
	i ok'="" QUIT defaultServer
	s nodeOID=$$getTagOID("ewd:config",templateDocName)
	s mgwsiServer=$$getAttributeValue^%zewdDOM("mgwsiserver",1,nodeOID)
	i mgwsiServer="" s mgwsiServer=$$getAttributeValue^%zewdDOM("mphpserver",1,nodeOID)
	s ok=$$closeDOM^%zewdDOM()
	i mgwsiServer="" s mgwsiServer=defaultServer
	QUIT mgwsiServer
	;
processFiles(files,inputPath,outputPath,verbose,mode,technology,multilingual,mgwsiServer,templateFilename,maxLines)
	;
	n cspVars,dlim,error,filename,hasSubDirectories,i,ok,phpVars,templateDocName,version
	;
	s version=$p($t(version^%zewdCompiler2),";;",2)
	i $g(^%zewd("version"))'=version d
	. d updateTagDefinitions
	. s ^%zewd("version")=version
	;
	s multilingual=+$g(multilingual)
	s hasSubDirectories=+$g(hasSubDirectories)
	;l +^%zewd("Compiling")
	s verbose=+$g(verbose)
	;s templateFilename="ewdTemplate.ewd"
	i $g(templateFilename)="" s templateFilename="ewdTemplate.ewd"
	s dlim=$$getDelim()
	i $e(inputPath,$l(inputPath))'=dlim s inputPath=inputPath_dlim
	s filename="",templateDocName="",mgwsiServer="LOCAL"
	i $d(files(templateFilename)) d  i error'="" QUIT error
	. s error=$$processTemplate(templateFilename,inputPath,.templateDocName,.phpVars,technology,.cspVars)
	. i $$zcvt^%zewdAPI(error,"l")["licensing violation" q
	. s mgwsiServer=$$getmgwsiServer(templateDocName)
	. i multilingual d multiLingTemplate^%zewdCompiler5(templateDocName,inputPath,technology,multilingual)
	. k files(templateFilename)
	d addAjaxErrorPage^%zewdCompiler8(inputPath,.files)
	f  s filename=$o(files(filename)) q:filename=""  d
	. n error
	. i verbose=1 w inputPath_filename
	. i verbose=2 d addToReport(inputPath_filename,.results)
	. s error=$$processFile(filename,inputPath,outputPath,templateDocName,mode,.phpVars,technology,multilingual,.cspVars,$g(maxLines))
	. i verbose=1 d
	. . i error'="" w " : ",error
	. . w !
	. i verbose=2 d
	. . i error'="" d addToReport("Error : "_error,.results)
	. i error'="" d addToLog(error)
	;
	s ok=$$openDOM^%zewdAPI()
	i ok'="" QUIT ok
	s ok=$$removeDocument^%zewdDOM(templateDocName,0,0)
	s ok=$$closeDOM^%zewdDOM()
	s filename=""
	f  s filename=$o(files(filename)) q:filename=""  d
	. i $e(filename,1,4)="zext" s ok=$$deleteFile^%zewdHTMLParser(inputPath_filename)
	f filename="ewdAjaxError","ewdAjaxErrorRedirect","ewdErrorRedirect","zewdFormRedirect" d
	. s ok=$$deleteFile^%zewdHTMLParser(inputPath_filename_".ewd")
	QUIT ""
	;
processTemplate(filename,inputPath,docName,phpVars,technology,cspVars)
	;
	n filepath,%error,docOID,ok,dlim
	;
	s dlim=$$getDelim()
	i $e(inputPath,$l(inputPath))'=dlim s inputPath=inputPath_dlim
	s filepath=inputPath_filename
	;
	i filepath'[".ewd" QUIT filepath_" is not an ewd file"
	;i '$zu(140,1,filepath) q filepath_" is empty"
	i $$fileSize^%zewdAPI(filepath)=0 q filepath_" is empty"
	;
	; Parse the ewd file into an XHTML eXtc DOM
	;
	i $g(docName)="" s docName="ewdTemplate"
	s ok=$$openDOM^%zewdAPI()
	i ok'="" d  QUIT ok
	. d addToLog(ok_" ; when processing template")
	s ok=$$removeDocument^%zewdDOM(docName,0,0)
	s ok=$$closeDOM^%zewdDOM()
	s %error=$$parseFile^%zewdHTMLParser(filepath,docName,.cspVars,.phpVars,1)
	i $g(%error)'="" d  QUIT %error
	. d addToLog("Parsing error in "_filepath_" : "_%error)
	; 
	QUIT ""
	;
processFile(filename,inputPath,outputPath,templateDocName,mode,phpVars,technology,multiLingual,cspVars,maxLines)
	;
	n allArray,app,config,dataTypeList,dlim,docName,docOID,dojoTypes,error,%error,ext,filepath
	n formDeclarations,hasSubDirectories,idList,isAjax,isXSLFO,jsOID,jspHeaderArray
	n multiLingualPage,nextPageList,ok,outputFilepath,pageName,phpHeaderArray
	n rootPath,routineName,stop,subPath,textidList,traceSet
	n uploadText,urlNameList
	;
	; initial install and upgrade bootstrap :
	;
	s multiLingual=+$g(multiLingual)
	d
	. n delim,np,op
	. s delim="/" i outputPath["\" s delim="\"
	. s op=outputPath
	. i $e(op,$l(op))=delim s op=$e(op,1,$l(op)-1)
	. s op=$re(op)
	. s op=$p(op,delim,1)
	. s app=$re(op)
	. s hasSubDirectories=0
	. s subPath=$p(outputPath,app,1)
	. i outputPath=(app_delim) s subPath=app
	;
	;  path normalisation
	;
	s dlim=$$getDelim()
	i $e(inputPath,$l(inputPath))'=dlim s inputPath=inputPath_dlim
	i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
	s filepath=inputPath_filename
	s ext=technology
	s outputFilepath=outputPath_$p(filename,".ewd",1)_"."_ext
	;
	i filepath'[".ewd" QUIT filepath_" is not an ewd file"
	i '$$fileExists^%zewdAPI(filepath) QUIT filepath_" does not exist"
	i $$fileSize^%zewdAPI(filepath)=0 QUIT filepath_" is empty"
	;
	; Parse the ewd file into an XHTML eXtc DOM
	;
	s ok=$$openDOM^%zewdAPI()
	i ok'="" d  QUIT ok
	. d addToLog(ok_" ; while attempting to compile "_filename)
	;
	s docName="ewd"
	s stop=0
	f i=1:1:10 d  q:stop
	. i '$$isLockSet s stop=1 q
	. h 1
	d setLock
	s ok=$$removeDocument^%zewdDOM(docName,0,0)
	s ok=$$closeDOM^%zewdDOM()
	s %error=$$parseFile^%zewdHTMLParser(filepath,docName,.cspVars,.phpVars,1)
	i $g(%error)'="" d  QUIT %error
	. d addToLog("Parsing error in "_filepath_" : "_%error)
	s ok=$$openDOM^%zewdAPI()
	i ok'="" d  QUIT ok
	. d addToLog(ok_" ; while attempting to compile "_filename)
	. d clearLock
	s docOID=$$getDocumentNode^%zewdDOM(docName)
	;
	; Start processing the ewd page DOM
	;
	; moved earlier to prevent processing of template when no <ewd:config> tag
	;
	d
	. n nodeOID,pageType
	. s nodeOID=$$getTagOID^%zewdDOM("ewd:config",docName)
	. s pageType=$$getAttribute^%zewdDOM("pagetype",nodeOID)
	. i $$zcvt^%zewdAPI(pageType,"l")="extformhandler" d extFormHandler^ExtJS
	;
	i $$isTemplate(docName) d  QUIT ""
	. s ok=$$removeDocument^%zewdDOM(docName,0,0)
	. s ok=$$closeDOM^%zewdDOM()
	i $$bypassMode(docName) d  g multilingual
	. s multiLingual=multilingual
	. s error=$$customTags(docName,technology) ; allows custom processing of tags in existing pages
	. q:error'=""
	. d getAllNodes^%zewdCompiler(docOID,.allArray)
	;
	s error=$$template^%zewdCompiler3(docName,templateDocName,inputPath,.phpVars,technology)
	i error'="" QUIT error
	;
	s isXSLFO=0
	s routineName=""
	s jsOID=$$errorHandler(docName,technology) ; add Error processing JavaScript function and amend <body> onload event handler
	i $g(^zewd("break")) break
	d ajax^%zewdCompiler8(docName,technology)
	s error=$$customTags(docName,technology) ; process users' custom tags and ewd:* tags
	s isDojo=0
	i $d(dojoTypes) s isDojo=1
	i error'="" d clearLock QUIT error
	d iframe^%zewdCompiler16(docOID) ; check for null src attribute
	d dataTypes(.allArray,docOID,technology,.dataTypeList) ; process data types
	d inputFile^%zewdCompiler19(docName,technology,.phpHeaderArray) ; <input type=file> processing
	s multiLingualPage=$$ewdConfig^%zewdCompiler7(docName,.phpHeaderArray,routineName,technology,.dataTypeList,inputPath,filename,multiLingual,.config,.pageName) ; process <ewd:config> tag + add header/csp pps code
	i multiLingualPage=0 s multiLingual=0 ; if page explicitly turns multilingual off, turn it off
	d apply(docName,technology)
	d button^%zewdCompiler3(docName,technology,multilingual,inputPath,.textidList) ; process nextpage mechanisms for buttons
	d spanTags^%zewdCompiler7(docName,technology,multilingual,inputPath,.textidList) ; Process nextpage mechanisms for <span> tags
	d ajaxFileUpload^%zewdCompiler16(docOID)
	d eventBroker^%zewdCompiler7(.allArray,docOID,jsOID,.phpHeaderArray,filename,docName,routineName,.nextPageList,.formDeclarations,technology,$g(config("mgwsiServer")),$g(config("backend"))) ; process any event broker calls
	s traceSet=$$submitActionNextpage^%zewdCompiler8(docName,.phpHeaderArray,routineName,technology,.dataTypeList,.formDeclarations,.config,pageName,multilingual,inputPath,filename,.textidList) ; process <input type=submit> tags and build prepage script logic
	d dynamicMenu^%zewdCompiler3(docName,.phpHeaderArray,.nextPageList,technology) ; process <ewd:dynamicMenu> tags
	d popups^%zewdCompiler13(.allArray,docOID,jsOID,.nextPageList,.urlNameList,technology) ; process popup= attributes in input tags
	s traceSet=$$ajaxPage^%zewdCompiler8(.allArray,docOID,jsOID,.nextPageList,.urlNameList,technology)
	d nextPages(docOID,.allArray,.nextPageList,.urlNameList,.config,technology) ; process all src= and href= tags that refer to .ewd pages
	d inputStar^%zewdCompiler8(docName,technology,.config,.idList) ; process value=* in <input type=text> tags
	d form^%zewdCompiler3(docName,technology,filename,outputPath,hasSubDirectories) ; process <form action=ewd> tags and add hidden fields
	d focus(docName) ; process focus=true in <input> tag
	d sessionVars(.allArray,docOID,technology) ; create proper session array variable references
	d select^%zewdCompiler4(docName,technology,.config,.idList) ; add the code that writes out <select> options
	d radio^%zewdCompiler3(docName,technology) ; add the code to select the correct radio buttons
	d checkbox^%zewdCompiler3(docName,technology) ; add the code to select the correct checkboxes
	d metaRefresh^%zewdCompiler20(docName,.nextPageList,technology) ; process <meta> tags that refresh to a .ewd page
	s mode=$$payload^%zewdCompiler8(docName,mode,technology) ; remove payload outer tag
	d ajaxJS^%zewdCompiler8(docName,.config,.idList,traceSet,technology) ;
	d scriptsTag^%zewdCompiler16(app,docName,technology) 
	;
	d pageIndex^%zewdCompiler7(subPath,filename,.nextPageList)
	; 
	d createGTMNextPageHeader^%zewdGTMRuntime(.nextPageList,.urlNameList,.phpHeaderArray)
	;
multilingual ;
	i $g(error)'="" d  QUIT error
	. s ok=$$removeDocument^%zewdDOM(docName,0,0)
	. s ok=$$closeDOM^%zewdDOM()
	. d clearLock
	s error=""
	i multiLingual d
	. n appName,pageName,dlim,npieces
	. s appName=inputPath
	. s dlim=$$getDelim()
	. s appName=$p(appName,$$getApplicationRootPath(),2)
	. i $e(appName,1)=dlim s appName=$p(appName,dlim,2)
	. s appName=$p(appName,dlim,1)
	. s pageName=$p(filename,".ewd",1)
	. d multiLingual^%zewdCompiler5(docOID,technology,appName,pageName,multiLingual,.textidList)
	;
	s maxLines=5000
	d outputDOM^%zewdGTMRuntime(docName,mode,0,.cspVars,.phpVars,0,technology,$g(maxLines))
	s ok=$$removeDocument^%zewdDOM(docName,0,0)
	s ok=$$closeDOM^%zewdDOM()
	d clearLock
	QUIT ""
	;
setLock
	s ^zewd("compiling")=$j
	QUIT
	;
clearLock
	k ^zewd("compiling")
	QUIT
	;
isLockSet()
	i $g(^zewd("compiling"))=$j QUIT 0
	QUIT $d(^zewd("compiling"))
	;
bypassMode(docName)
	;
	n nodeOID,bypassMode
	;
	; If a page does not have an <ewd:config> tag, it is deemed to be a page
	; to be parsed but not processed.  If multi-lingual processing is enabled, then
	; it will be processed for multi-lingual capability.  This allows existing CSP
	; pages to be processed - they just need renaming as ".ewd" pages
	; 
	; Bypass mode can be controlled explicitly from within the <ewd:config> tag
	;
	s nodeOID=$$getTagOID("ewd:config",docName)
	i nodeOID="" QUIT 1
	s bypassMode=$$getAttributeValue^%zewdDOM("bypassmode",0,nodeOID)
	QUIT $$zcvt^%zewdAPI(bypassMode,"l")="true"
	;
isTemplate(docName)
	;
	n nodeOID,isTemplate
	;
	s nodeOID=$$getTagOID("ewd:config",docName)
	i nodeOID="" QUIT 0
	s isTemplate=$$getAttributeValue^%zewdDOM("istemplate",0,nodeOID)
	QUIT $$zcvt^%zewdAPI(isTemplate,"l")="true"
	;
isXSLFO(docName)
	;
	n nodeOID,type
	;
	s nodeOID=$$getTagOID("ewd:config",docName)
	i nodeOID="" QUIT 1
	s type=$$getAttributeValue^%zewdDOM("type",0,nodeOID)
	QUIT $$zcvt^%zewdAPI(type,"l")="xsl-fo"
	;
getNormalisedAttributeValue(attrName,nodeOID,technology)
	QUIT $$getNormalAttributeValue($g(attrName),$g(nodeOID),$g(technology))
	;
getNormalAttributeValue(attrName,nodeOID,technology)
	;
	n attrValue
	;
	s attrValue=$$getAttributeValue^%zewdDOM($$zcvt^%zewdAPI(attrName,"l"),1,nodeOID)
	i attrValue="$space" s attrValue=" "
	i attrValue="$nul" s attrValue=""
	;
	d
	. i $e(attrValue,1)'="$",$e(attrValue,1)'="#" s attrValue=""""_attrValue_""""
	. i $e(attrValue,1)="$",$e(attrValue,2)'="$" s attrValue=$e(attrValue,2,$l(attrValue))
	. ;i $e(attrValue,1)="#" s attrValue="%session.Data("""_$e(attrValue,2,$l(attrValue))_""")"
	. i $e(attrValue,1)="#",$e(attrValue,1,2)'="##" d 
	. . i attrValue["." d
	. . . n np,object,property
	. . . s attrValue=$e(attrValue,2,$l(attrValue))
	. . . i attrValue["_" s attrValue=$p(attrValue,"_",1)_"."_$p(attrValue,"_",2,200)
	. . . s np=$l(attrValue,".")
	. . . s object=$p(attrValue,".",1,np-1)
	. . . s property=$p(attrValue,".",np)
	. . . i object["[" d
	. . . . n index
	. . . . s index=$p(object,"[",2)
	. . . . s index=$p(index,"]",1)
	. . . . s object=$p(object,"[",1)
	. . . . i $e(index,1)="$" s index=$e(index,2,$l(index))
	. . . . s attrValue="$$getResultSetValue^%zewdAPI("""_object_""","_index_","""_property_""",sessid)"
	. . . e  d
	. . . . i object["tmp" d
	. . . . . s attrValue="$$getTmpSessionObject^%zewdAPI2("""_object_""","""_property_""",sessid)"
	. . . . e  d
	. . . . . s attrValue="$$getSessionObject^%zewdAPI("""_object_""","""_property_""",sessid)"
	. . e  d
	. . . s attrValue="$$getSessionValue^%zewdAPI("""_$e(attrValue,2,$l(attrValue))_""",sessid)"
	;
	;
	QUIT attrValue
 ;
phpGet(varName)
 ;
 QUIT "(isset("_varName_") && "_varName_") ? "_varName_" : ''"
 ;
	;
getAttributes(nodeOID,attr)
	;
	n attrArray,attrName,attrOID,nnmOID,length,i
	;
	k attr
	s nnmOID=$$getAttributes^%zewdDOM(nodeOID)
	i 'nnmOID QUIT ""
	i '$d(attr) d  QUIT ""
	. s length=$$getNamedNodeMapAttribute^%zewdDOM(nnmOID,"length")
	. i length>0 f i=1:1:length d
	. . s attrOID=$$item^%eDOMNodeList(i-1,nnmOID,"")
	. . s attrName=$$getName^%zewdDOM(attrOID)
	. . s attr(attrName)=attrOID
	m attrArray=attr k attr
	s attrOID=""
	f  s attrOID=$o(attrArray(attrOID)) q:attrOID=""  d
	. s attrName=$p(attrArray(attrOID),$c(1),1)
	. s attr(attrName)=attrOID
	QUIT ""
	;
	;
zcvt(text)
	;
	QUIT $$replaceAll^%zewdHTMLParser(text,"'","\&#39;")
	;
nextPages(docOID,allArray,nextPageList,urlNameList,config,technology)
	;
	; Find all src=, data= and href= tags that refer to .ewd pages
	; Also any manually declared ones from the nextPageList in <ewd:config>
	; 	 
	n attr,docName,i,nodeOID,nodeType,np,npl,nvp,pageName,%srcvalue,%tagname
	;
	s docName=$$getDocumentName^%zewdDOM(docOID)
	s nodeOID=""
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. i nodeType'=1 q
	. s %tagname=$$getTagName^%zewdDOM(nodeOID)
	. s %srcvalue=$$getAttributeValue^%zewdDOM("src",1,nodeOID)
	. i %srcvalue["&php;" s %srcvalue=$$getAttributeValue^%zewdDOM("src",0,nodeOID)
	. i %srcvalue'="" s attr="src"
	. i %srcvalue="" d
	. . s %srcvalue=$$getAttributeValue^%zewdDOM("href",1,nodeOID)
	. . i %srcvalue["&php;" s %srcvalue=$$getAttributeValue^%zewdDOM("href",0,nodeOID) 
	. . i %srcvalue'="" s attr="href"
	. i %srcvalue="" d
	. . s %srcvalue=$$getAttributeValue^%zewdDOM("data",1,nodeOID) 
	. . i %srcvalue["&php;" s %srcvalue=$$getAttributeValue^%zewdDOM("data",0,nodeOID) 
	. . i %srcvalue'="" s attr="data"
	. i %srcvalue="" d
	. . s %srcvalue=$$getAttributeValue^%zewdDOM("manifest",1,nodeOID) 
	. . i %srcvalue["&php;" s %srcvalue=$$getAttributeValue^%zewdDOM("manifest",0,nodeOID) 
	. . i %srcvalue'="" s attr="manifest"
	. q:%srcvalue=""
	. i $e(%srcvalue,1)'="$",%srcvalue'[".ewd",%srcvalue'[".asp" q
	. i $e(%srcvalue,1)'="$" d
	. . i %srcvalue[".asp" d  q
	. . . n app,mode,nextpage,nvp,thispage,toklen
	. . . s app=$$zcvt^%zewdAPI($p(%srcvalue,"/",1),"u")
	. . . i $g(page)="" s page=$p(filename,".ewd",1)
	. . . s thispage=$$zcvt^%zewdAPI(page,"u")
	. . . s nextpage=$$zcvt^%zewdAPI($p(%srcvalue,"/",2),"u")
	. . . s nextpage=$p(nextpage,".ASP",1)
	. . . s nvp=$p(%srcvalue,"?",2)
	. . . s %srcvalue="#($$url^%zewdWLD("""_thispage_""","""_nextpage_""","""_app_""","""_nvp_"""))#"
	. . s %srcvalue=$$expandPageName^%zewdCompiler8(%srcvalue,.nextPageList,.urlNameList,technology)
	. e  d
	. . s %srcvalue="#url(#("_$e(%srcvalue,2,$l(%srcvalue))_")#)#"
	. d setAttribute^%zewdDOM(attr,%srcvalue,nodeOID)
	d location^%zewdCompiler16(docOID,.allArray,.nextPageList,technology)
	;
	s npl=$g(config("nextPageList"))
	i npl'="" d
	. s np=$l(npl,",")
	. f i=1:1:np d
	. . s pageName=$p(npl,",",i)
	. . s pageName=$p(pageName,".ewd",1)
	. . s pageName=$$stripSpaces^%zewdAPI(pageName)
	. . i pageName'="" s nextPageList(pageName)=""
	;
	QUIT
	;
noEWD(url)
 ;
 n nEwd,nEwdUs
 ;
 s nEwd=$l(url,".ewd")
 s nEwdUs=$l(url,".ewd_")
 ;
 i nEwd=0 QUIT 1
 i nEwd=nEwdUs QUIT 1
 QUIT 0
 ;
expandPageURL(url,nextPageList,technology)
	;
	n addapos,apos,c,dlim,ewdPos,i,nvp,%p1,%p1r,%p2,%p3
	n page,pageName,stop,strt,xtra
	;
	s url=$$convertSubstringCase^%zewdHTMLParser(url,".ewd","L")
	s url=$$replace^%zewdAPI(url,"?static","")
	s url=$$convertSubstringCase^%zewdHTMLParser(url,"document.location","L")
	s url=$$convertSubstringCase^%zewdHTMLParser(url,"document.location.href","L")
	s url=$$replaceAll^%zewdHTMLParser(url,"&php;",$c(1))
	f  q:$$noEWD(url)  d
	. s ewdPos=$f(url,".ewd")-1
	. s %p1=$e(url,1,ewdPos)
	. s %p2=$e(url,ewdPos+1,$l(url))
	. s %p1=$p(%p1,".ewd",1)
	. s %p1r=$re(%p1)
	. s stop=0,page=""
	. f i=1:1 d  q:stop
	. . s c=$e(%p1r,i)
	. . i c?1P s stop=1 q
	. . s page=page_c
	. s %p1r=$p(%p1r,page,2,2000)
	. s %p1=$re(%p1r)
	. s pageName=$re(page)
	. i pageName'="",$g(app)'="" d
	. . q:pageName="*"
	. . q:$e(pageName,1)="#"
	. . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalls",$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"),$$zcvt^%zewdAPI(pageName,"l"))=""
	. . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"pageCalledBy",$$zcvt^%zewdAPI(pageName,"l"),$$zcvt^%zewdAPI($p(filename,".ewd",1),"l"))=""
	. d
	. . s url=$$getRootURL^%zewdCompiler("gtm")_app_"/"_pageName_".mgwsi?"
	. . s url=url_"ewd_token=#($g(^%zewdSession(""session"",sessid,""ewd_token"")))#&n=#(tokens("""_pageName_"""))#"
	. s url=%p1_url_%p2
	. i pageName'="" s nextPageList(pageName)=""
	s url=$$replaceAll^%zewdHTMLParser(url,$c(1),"&php;")
	QUIT url
	;
apply(docName,technology)
	;
	n ntags,OIDArray,nodeOID
	; 
	s ntags=$$getTagsByName("ewd:apply",docName,.OIDArray)
	s nodeOID=""
	f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. n value,name,type,oid
	. s value=$$getAttributeValue^%zewdDOM("technology",1,nodeOID)
	. i value'=technology s oid=$$removeChild^%zewdAPI(nodeOID,1) q
	. d removeIntermediateNodeeXtc^%zewdAPI(nodeOID,1)
	;
	QUIT
	;
parseJSText(line,scriptText)
	i $$os^%zewdHTMLParser()="gtm" s line=$$replaceAll^%zewdAPI(line,"LOCAL","gtm")
	i line[";;*php*",technology'="php" QUIT
	i line[";;*csp*",technology'="csp",technology'="wl" QUIT
	i line[";;*jsp*",technology'="jsp" QUIT
	i line[";;*vb.net*",technology'="vb.net" QUIT
	i line[";;*gtm*",technology'="gtm" QUIT
	s line=$$replace^%zewdHTMLParser(line,"*php*","     ")
	s line=$$replace^%zewdHTMLParser(line,"*csp*","     ")
	s line=$$replace^%zewdHTMLParser(line,"*jsp*","     ")
	s line=$$replace^%zewdHTMLParser(line,"*gtm*","     ")
	s line=$$replace^%zewdHTMLParser(line,"*vb.net*","       ")
	s scriptText=scriptText_$p(line,";;",2,200)_$c(13,10)
	QUIT
	;
errorHandler(docName,technology)
	;
	; add Error processing JavaScript and Body Onload Event Handler
	; 
	n scriptText,jsOID,nodeOID,attr,onload,bodyOID,hidOID,lineNo,line
	;
	s scriptText=""
	f lineNo=1:1 s line=$t(jsInPageBlock+lineNo^%zewdCompiler2) q:line["***END***"  d
	. d parseJSText(line,.scriptText)
	;
	f lineNo=1:1 s line=$t(jsErrorClass+lineNo^%zewdCompiler9) q:line["***END***"  d
	. d parseJSText(line,.scriptText) 
    ;
	s nodeOID=$$getTagOID("head",docName)
	i nodeOID="" s nodeOID=$$getTagOID("iwd:main",docName)
    s attr("language")="javascript"
	s jsOID=$$addElementToDOM^%zewdDOM("script",nodeOID,,.attr,scriptText)
    ;
	s bodyOID=$$getTagOID("body",docName)
	s onload=$$getAttributeValue^%zewdDOM("onload",1,bodyOID)
	i onload'="" s onload=onload_" ; "
	s onload=onload_"EWD.page.setErrorClass() ; EWD.page.errorMessage('#($$htmlEscape^%zewdGTMRuntime($$jsEscape^%zewdGTMRuntime(Error)))#')"
	d setAttribute^%zewdDOM("onload",onload,bodyOID)
	QUIT ""
	QUIT jsOID
	;
focus(docName) ;
    ;
	; Process focus=true attribute
	; 
	; Find all <input> tags and find the first that sets focus
	; 
	; 
	n bodyOID,focus,formOID,formOIDArray,name,nform,nforms,nodeOID
	n OIDArray,onload
	;
	s focus=""
	s bodyOID=$$getTagOID("body",docName)
	s nforms=$$getTagsByName("form",docName,.formOIDArray)
	s formOID="",nform=0
	f  s formOID=$o(formOIDArray(formOID)) q:formOID=""  d  q:focus'=""
	. n nlOID,length,i,formName
	. s nform=nform+1
	. s formName=$$getAttributeValue^%zewdDOM("name",1,formOID)
	. i formName="" d
	. . s formName="ewdForm"_nform
	. . d setAttribute^%zewdDOM("name",formName,formOID)
	. s length=$$getDescendentsByName("input",formOID,.OIDArray)
	. s nodeOID=""
	. f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
	. . s focus=$$getAttributeValue^%zewdDOM("focus",1,nodeOID)
	. . q:focus'="true"
	. . s name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. . s onload=$$getAttributeValue^%zewdDOM("onload",1,bodyOID)
	. . i onload'="" s onload=onload_" ; "
	. . s onload=onload_"document."_formName_"."_name_".focus()"
	. . d setAttribute^%zewdDOM("onload",onload,bodyOID)
	. . d removeAttribute^%zewdAPI("focus",nodeOID)
	QUIT
	;
dataTypes(allArray,docOID,technology,dataTypeList)
	;
	;
	n nodeOID
	;
	d getAllNodes^%zewdCompiler(docOID,.allArray)
	;
	s nodeOID=""
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. n nodeType,dataType,name
	. ;
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. i nodeType'=1 q
	. s name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. q:name=""
	. s dataType=$$getAttributeValue^%zewdDOM("datatype",1,nodeOID)
	. q:dataType=""
	. s dataTypeList(name)=dataType
	. d removeAttribute^%zewdAPI("datatype",nodeOID)
	QUIT
	;
sessionVars(allArray,docOID,technology)
	;
	; Process the session variable references
	;
	n nodeOID
	;
	s nodeOID=""
	f  s nodeOID=$o(allArray(0,nodeOID)) q:nodeOID=""  d
	. n nodeType,%tagname,target,data,procInsOID,name
	. ;
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. i nodeType'=1 q
	. s %tagname=$$getTagName^%zewdDOM(nodeOID)
	. q:%tagname'="ewdSessionVariable"
	. s name=$$getAttributeValue^%zewdDOM("name",1,nodeOID)
	. d  Q
	. . n data,textOID
	. . s data="#($$getSessionValue^%zewdAPI("""_name_""",sessid))#"
	. . s textOID=$$createTextNode^%zewdDOM(data,docOID)
	. . s textOID=$$insertBefore^%zewdDOM(textOID,nodeOID)
	. . s nodeOID=$$removeChild^%zewdAPI(nodeOID,1)
	QUIT
	;
goNextPage(attrName,attrValue,nodeOID)
	;
	; ewdGoNextPage($optionNo) transformed into
	; ewdGoNextPage('<?= $ewd_menuOption[$optionNo]['nextPage'] ?>','<?= $tokens[$ewd_menuOption[$optionNo]['nextPage']] ?>')"
	;
	n param,value
	;
	s param=$p(attrValue,"(",2)
	s param=$p(param,")",1)
	s value="EWD.page.goNextPage('<?= $ewd_menuOption["_param_"]['nextPage'] ?>','<?= $tokens[$ewd_menuOption["_param_"]['nextPage']] ?>','<?= $ewd_session[""ewd_token""] ?>')"
	d setAttribute^%zewdDOM(attrName,value,nodeOID)
	;
	QUIT
	;
createEwdFuncs(outputPath,verbose) ;
 ;
 n line,i,filePath,funcsFile
 ;
 s funcsFile="ewdFuncs.php"
 d  QUIT
 . n x
 . i $e(outputPath,$l(outputPath))'="/" s outputPath=outputPath_"/"
 . s x="cp /usr/php/"_funcsFile_" "_outputPath_funcsFile
 . zsystem x
 ;
createEwdError(outputPath,verbose,technology) ;
 ;
 n ext,filePath,i,line
 ;
 s ext=".mgwsi"
 s filePath=outputPath_"ewdError."_ext
 i '$$openNewFile(filePath) QUIT
 u filePath
 f i=1:1 s line=$t(ewdError+i^%zewdCompiler2) q:line["***END**"  d
 . i line["ewd_Version" s line=$$replace^%zewdAPI(line,"ewd_Version",$$version^%zewdAPI())
 . i line["*wl*",technology'="wl" q
 . i line["*gtm*",technology'="gtm" q
 . i line["*php*",technology'="php" q
 . i line["*jsp*",technology'="jsp" q
 . i line["*vb.net*",technology'="vb.net" q
 . i line["*php" s line=";;"_$p(line,"*php*",2)
 . i line["*wl" s line=";;"_$p(line,"*wl*",2)
 . i line["*jsp" s line=";;"_$p(line,"*jsp*",2)
 . i line["*vb.net" s line=";;"_$p(line,"*vb.net*",2)
 . w $p(line,";;",2,250),!
 c filePath
 i verbose=1 w filePath,!
 i verbose=2 d addToReport(filePath,.results)
 QUIT
 ;
createEwdLogout(mgwsiServer,outputPath,verbose)
 ;
 n line,i,filePath
 ;
 s filePath=outputPath_"ewdLogout.php"
 i '$$openNewFile(filePath) QUIT
 ;o filePath:"nw":2 e  QUIT
 u filePath
 f i=1:1 s line=$t(ewdLogout+i^%zewdCompiler2) q:line["***END**"  d
 . i line["m_proc" d
 . . w "  $mgwsiServer = """_mgwsiServer_""" ;",!
 . ;. w "  if (isset($ewd_session[""mgwsi_server""])) $mgwsiServer = $ewd_session[""mgwsi_server""] ;",!
 . w $p(line,";;",2,250),!
 c filePath
 i verbose=1 w filePath,!
 i verbose=2 d addToReport(filePath,.results)
 QUIT
 ;
 ;
createAjaxTrace(outputPath,verbose)
 ;
 n line,i,filePath
 ;
 s filePath=outputPath_"ewdTraceWindow.htm"
 i '$$openNewFile(filePath) QUIT
 ;o filePath:"nw":2 e  QUIT
 u filePath
 f i=1:1 s line=$t(ajaxTraceWindow+i^%zewdCompiler9) q:line["***END**"  d
 . w $p(line,";;",2,250),!
 c filePath
 i verbose=1 w filePath,!
 i verbose=2 d addToReport(filePath,.results)
 QUIT
 ;
addToLog(text)
 ;
 n i
 ;
 s i=$I(^%zewdLog("node"))
 s ^%zewdLog(i)=$zts_" : "_text
 QUIT
 ;
clearLog ;
 k ^%zewdLog
 QUIT
 ;
 ;
getOnPreHTTPOID(docName)
 ;
 n language,method,ntags,OIDArray,nodeOID,%stop
 ;
 s ntags=$$getTagsByName("script",docName,.OIDArray)
 s nodeOID="",%stop=0
 f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  q:%stop
 . s language=$$getAttributeValue^%zewdDOM("language",1,nodeOID)
 . i language'="cache" q
 . s method=$$getAttributeValue^%zewdDOM("method",1,nodeOID)
 . i method'="OnPreHTTP" q
 . s %stop=1
 i '%stop QUIT ""
 QUIT nodeOID
 ;
 ;
getTagOID(tagName,docName,lowerCase) ;
	;
	n ntags,OIDArray
	;
	s ntags=$$getTagsByName(tagName,docName,.OIDArray,$g(lowerCase))
	QUIT $o(OIDArray(""))
	;
getTagsByName(tagName,docName,OIDArray,lowerCase)
	;
	n nlOID,docOID,length,i
	;
	s lowerCase=$g(lowerCase) i lowerCase="" s lowerCase=1
	k OIDArray
	i lowerCase s tagName=$$zcvt^%zewdAPI(tagName,"L")
	s docOID=$$getDocumentNode^%zewdDOM(docName)
	s nlOID=$$getElementsByTagName^%zewdDOM(tagName,docOID)
	s length=$$getNodeListAttribute^%zewdDOM(nlOID,"length")
	i nlOID'="1~OIDArray",length>0 f i=1:1:length s OIDArray($$item^%eDOMNodeList(i-1,nlOID,""))=""
	i nlOID="1~OIDArray" d
	. n oid
	. s oid=""
	. f length=0:1 s oid=$o(OIDArray(oid)) q:oid=""
	QUIT length
	;
getDescendentsByName(tagName,parentOID,OIDArray)
	;
	n nlOID,docOID,length,i
	;
	k OIDArray
	s tagName=$$zcvt^%zewdAPI(tagName,"L")
	s nlOID=$$getElementsByTagName^%zewdDOM(tagName,parentOID)
	s length=$$getNodeListAttribute^%zewdDOM(nlOID,"length")
	i length>0 f i=1:1:length s OIDArray($$item^%eDOMNodeList(i-1,nlOID,""))=""
	QUIT length
	;
getChildrenByTagName(nodeOID,tagName,childArray)
	;
	n nlOID,length,i,tot
	;
	k childArray
	s tot=0
	s nlOID=$$getChildNodes^%zewdDOM(nodeOID)
	S length=$$getNodeListAttribute^%zewdDOM(nlOID,"length")
	i length>0 f i=1:1:length d
	. n nodeOID,tag
	. s nodeOID=$$item^%eDOMNodeList(i-1,nlOID,"")
	. s tag=$$getTagName^%zewdDOM(nodeOID)
	. i tag=tagName d
	. . s childArray(nodeOID)=""
	. . s tot=tot+1
	QUIT tot
	;
addJSFunction(label,jsOID,technology)
	;
	n jsCodeOID,jsText,i,line,text,x
	; 
	s jsCodeOID=$$getFirstChild^%zewdDOM(jsOID)
	s jsText=$$getData^%zewdDOM(jsCodeOID)
	;
	; now add the new function and update the text node in the DOM
	;
	s x="s line=$T("_label_"+i^%zewdCompiler2)"
	f i=1:1 x x q:line["***END***"  d
	. s text=$p(line,";;",2,255)
	. i $e(text,1)="*",$e(text,2,4)'=technology q
	. s text=$$replaceAll^%zewdHTMLParser(text,("*"_technology_"*"),"     ")
	. s jsText=jsText_$c(13,10)_text
	s jsCodeOID=$$modifyTextData^%zewdDOM(jsText,jsCodeOID)
	QUIT
	;
getAllNodes(docOID,nodeArray)
	;
	n docNo
	;
	s docNo=$$getDocNo^%zewdDOM(docOID)
	i $d(^zewdDOM("dom",docNo)) d  QUIT
	. n OIDArray
	. k nodeArray
	. d getDescendantNodes^%zewdDOM(docOID,.OIDArray)
	. m nodeArray(0)=OIDArray
	d getDescendantNodes^%eXPath(docOID,.nodeArray,1)
	QUIT
	;
replacePHPVars(string,phpVars)
	;
	f  q:string'["&php;"  d
	. n %p1,%p2,%p3
	. s %p1=$p(string,"&php;",1)
	. s %p2=$p(string,"&php;",2)
	. s %p3=$p(string,"&php;",3,500)
	. s %p2=$g(phpVars(%p2))
	. s string=%p1_"<?= "_%p2_" ?>"_%p3
	QUIT string
	;
clearDown
	s ok=$$openDOM^%zewdAPI() i ok'="" QUIT
	s name="ewd"
	f  s name=$o(^eDOM("document","documentName",name)) q:name=""  d
	. i name'["ewd" q
	. w name,!
	. i $$removeDocument^%zewdDOM(name,0,0)
	i $$closeDOM^%zewdDOM()
	QUIT
	;
	; User Defined Tag APIs
	; 
setDataType(dataType,inputMethod,outputMethod)
	;
	i $g(dataType)="" QUIT 0
	i $g(inputMethod)="",$g(outputMethod)="" QUIT 0
	s dataType=$$zcvt^%zewdAPI(dataType,"l")
	;
	s ^%zewd("dataType",dataType)=inputMethod_$c(1)_outputMethod
	;
	QUIT 1
	; 
deleteDataType(dtName)
	; 
	s dtName=$$zcvt^%zewdAPI(dtName,"l")
	k ^%zewd("dataType",dtName)
	QUIT
	; 
getInputMethod(dtName)
	;
	i $g(dtName)="" QUIT ""
	s dtName=$$zcvt^%zewdAPI(dtName,"l")
	QUIT $p($g(^%zewd("dataType",dtName)),$c(1),1)
	; 
getOutputMethod(dtName)
	;
	i $g(dtName)="" QUIT ""
	s dtName=$$zcvt^%zewdAPI(dtName,"l")
	QUIT $p($g(^%zewd("dataType",dtName)),$c(1),2)
	;
setCustomTag(tagName,dispatchCall,impliedTagClosure,attrList,applyTo,includeFile,macroFile)
	;
	i $g(tagName)="" QUIT 0
	i $g(dispatchCall)="",$g(includeFile)="",$g(macroFile)="" QUIT 0
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	s impliedTagClosure=$g(impliedTagClosure) ; note value=csp means this applies to CSP processing only, so returns 0
	s attrList=$g(attrList)
	;
	d deleteCustomTag(tagName)
	s ^%zewd("customTag",tagName)=dispatchCall_$c(1)_impliedTagClosure_$c(1)_$c(1)_attrList_$c(1)_$g(applyTo)_$c(1)_$g(includeFile)_$c(1)_$g(macroFile)
	;
	QUIT 1
	;
deleteCustomTag(tagName)
	;
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	k ^%zewd("customTag",tagName)
	QUIT
	;
getCustomTagMethod(tagName)
	;
	i $g(tagName)="" QUIT ""
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	QUIT $p($g(^%zewd("customTag",tagName)),$c(1),1)
	;
getCustomTagInclude(tagName)
	;
	i $g(tagName)="" QUIT ""
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	QUIT $p($g(^%zewd("customTag",tagName)),$c(1),6)
	;
getCustomTagMacro(tagName)
	;
	i $g(tagName)="" QUIT ""
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	QUIT $p($g(^%zewd("customTag",tagName)),$c(1),7)
	;
getCustomTagDefFile(tagName)
	;
	i $g(tagName)="" QUIT ""
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	QUIT $p($g(^%zewd("customTag",tagName)),$c(1),7)
	;
getCustomTagApply(tagName)
	;
	n applyTo
	;
	i $g(tagName)="" QUIT ""
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	s applyTo=$p($g(^%zewd("customTag",tagName)),$c(1),5)
	i applyTo="" s applyTo="all"
	QUIT applyTo
	;
getCustomTagAttributeList(tagName)
	;
	i $g(tagName)="" QUIT ""
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	QUIT $p($g(^%zewd("customTag",tagName)),$c(1),4)
	;
isImpliedCloseTag(tagName)
	;
	n closed
	;
	i $g(tagName)="" QUIT 0
	s tagName=$$zcvt^%zewdAPI(tagName,"l")
	s closed=$p($g(^%zewd("customTag",tagName)),$c(1),2)
	i closed="" s closed=0
	QUIT closed
	;
getCustomTagList(tagList)
	;
	n tagName
	;
	k tagList
	s tagName=""
	f  s tagName=$o(^%zewd("customTag",tagName)) q:tagName=""  d
	. s tagList(tagName)=$p(^%zewd("customTag",tagName),$c(1),5)
	QUIT
	;
customTags(docName,technology)
	;
	n bypassMode,error,%stop,tagList,tagName,tagNameX,includeFound
	n nodeOID
	;
	d initialiseProcessedFlags^%zewdCompiler7
	s error=""
	f  s nodeOID=$$findFirstCustomTag^%zewdCompiler7(docName) q:nodeOID=""  d  q:error'=""
	. s tagName=$$getTagName^%zewdDOM(nodeOID)
	. i tagName="ewd:instantiate" q
	. i tagName["ewd:js" q  ; leave these till last
	. i tagName="ewd:cspscript" q  ; leave this till last
	. s tagNameX=tagName
	. i tagName["ewd:" s tagNameX=$p(^%zewd("customTag",tagName),$c(1),5)
	. s bypassMode=$$bypassMode(docName)
	. i bypassMode,$$getCustomTagApply(tagName)="ewd" q  ; in bypass mode, but custom tag only applies to EWD pages
	. i 'bypassMode,$$getCustomTagApply(tagName)="csp" q  ; in EWD mode, but custom tag only applies to CSP pages
	. s error=$$customTagProc(tagName,tagNameX,docName,technology)
    ; now pick up the <ewd:instantiate> tags
	d initialiseProcessedFlags^%zewdCompiler7
	i error'="" QUIT error
	f  s nodeOID=$$findFirstCustomTag^%zewdCompiler7(docName) q:nodeOID=""  d  q:error'=""
	. s tagName=$$getTagName^%zewdDOM(nodeOID)
	. i tagName'="ewd:instantiate",tagName'["ewd:js",tagName'="ewd:cspscript" q  ; shouldnt actually be necessary by this point
	. s tagNameX=tagName
	. i tagName["ewd:" s tagNameX=$p(^%zewd("customTag",tagName),$c(1),5)
	. s bypassMode=$$bypassMode(docName)
	. i bypassMode,$$getCustomTagApply(tagName)="ewd" q  ; in bypass mode, but custom tag only applies to EWD pages
	. i 'bypassMode,$$getCustomTagApply(tagName)="csp" q  ; in EWD mode, but custom tag only applies to CSP pages
	. s error=$$customTagProc(tagName,tagNameX,docName,technology)
	;
	d initialiseProcessedFlags^%zewdCompiler7
	QUIT error
	;
customTagProc(tagName,tagNameX,docName,technology)
	;
	n defFile,include,method,attrList,x,error,%zt
	; 
	s error=""
	s method=$$getCustomTagMethod(tagName)
	s attrList=$$getCustomTagAttributeList(tagName)
	s include=$$getCustomTagInclude(tagName)
	s defFile=$$getCustomTagDefFile(tagName)
	i method="",include="",defFile="" QUIT "No method, include or definition file for tag "_tagName
	d processTag^%zewdCompiler7(tagNameX,attrList,method,include,defFile,docName,technology,.error)
	QUIT error
	;
customTagProcError ;
	s $zt=%zt
	s error="Error in custom tag processing for the "_tagName_" tag : method "_method_" cannot be found in the "_$$namespace^%zewdAPI()_" namespace"
	QUIT error
	;
normaliseVar(var,technology)
	;
	i $e(var,1)="$" QUIT $e(var,2,$l(var))
	QUIT var
	;
createDirectory(path)
	i path'[$$getOutputRootPath^%zewdCompiler(technology) d
	. n delim,rootPath
	. s rootPath=$$getOutputRootPath^%zewdCompiler(technology)
	. s delim="/"
	. i rootPath["\" s delim="\"
	. s path=rootPath_delim_path
	;
	i '$$directoryExists^%zewdAPI(path) d
	. n len,pos,ok,dlim
	. s dlim=$$getDelim()
	. i $e(path,$l(path))=dlim s path=$e(path,1,$l(path)-1)
	. s len=$l(path,dlim)
	. f pos=2:1:len d
	. . n subpath,ok
	. . s subpath=$p(path,dlim,1,pos)
	. . ; create intermediate paths if not yet present
	. . ;s ok=$zu(140,9,subpath)
	. . s ok=$$createDirectory^%zewdAPI(subpath)
	QUIT
	;
updateTagDefinitions
	;
	n i,tagDefs,tagDef,tagName,tagNameX
	;
	s tagName=""
	f  s tagName=$o(^%zewd("customTag",tagName)) q:tagName=""  d
	. n tagType
	. s tagDef=^%zewd("customTag",tagName)
	. s tagType=$p(tagDef,$c(1),3)
	. i tagType="system" k ^%zewd("customTag",tagName)
	;
	f i=1:1 s tagDef=$t(tagDefinitions+i^%zewdCompiler15) q:tagDef["***END***"  d
	. n tagName,attrList,impliedClosure,procName
	. s tagDef=$p(tagDef,";;",2)
	. s tagName=$p(tagDef,"~",1)
	. s tagName=$$zcvt^%zewdAPI(tagName,"l")
	. s attrList=$p(tagDef,"~",2)
	. s impliedClosure=$p(tagDef,"~",3)
	. s procName=$p(tagDef,"~",4)
	. s tagNameX=tagName
	. i $p(tagDef,"~",5)'="" s tagNameX=$p(tagName,":",1)_":"_$p(tagDef,"~",5)_$p(tagName,":",2)
	. s ^%zewd("customTag",tagNameX)=procName_$c(1)_impliedClosure_$c(1)_"system"_$c(1)_attrList_$c(1)_tagName
	;
	d install^%zewdDOMDocumentation
	d install^%zewdYUIConf
	; 
	QUIT
	;
