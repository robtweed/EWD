%zewdMgr	; Enterprise Web Developer Manager Functions
 ;
 ; Product: Enterprise Web Developer (Build 837)
 ; Build Date: Tue, 25 Jan 2011 09:19:26
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
indexPrepage(sessid)
 ;
 i '$$validSubnet(sessid) d  QUIT ""
 . d setSessionValue^%zewdAPI("invalidAccess",1,sessid)
 . d setJump^%zewdAPI("ewdvaMgr",sessid)
 i $$passwordProtected() d  QUIT ""
 . d setSessionValue^%zewdAPI("login",1,sessid)
 . d setJump^%zewdAPI("login",sessid)
 ;
 d setJump^%zewdAPI("ewdvaMgr",sessid)
 QUIT ""
 ;
validSubnet(sessid)
 ;
 n cacheIP,browserIP,subnet,%stop
 ;
 ; only allow access from browser running on Cache server or
 ; an authorised subnet. By default no authorised subnets are
 ; configured, so access is only possible from the Cache server.
 ;
 s cacheIP=$$getIP^%zewdAPI()
 s browserIP=$$getServerValue^%zewdAPI("REMOTE_ADDR",sessid)
 ;d trace^%zewdAPI("cache ip = "_cacheIP_" ; browser ip="_browserIP)
 i browserIP=cacheIP QUIT 1
 i browserIP="127.0.0.1" QUIT 1
 s subnet="",%stop=0
 f  s subnet=$o(^%zewd("config","security","validSubnet",subnet)) Q:subnet=""  do  Q:%stop
 . ;d TRACE^%wld("subnet="_subnet)
 . n len
 . s len=$l(subnet,".")
 . i $p(browserIP,".",1,len)=subnet s %stop=1
 QUIT %stop
 ;
passwordProtected() ;
 ;
 Q $d(^%zewd("config","security","username"))
 ;
 ;
 ;
redirect(sessid)
 ;
 ; Page Redirector
 ;
 n error,name,page
 ;
 i $$getSessionValue^%zewdAPI("invalidAccess",sessid)=1 d  QUIT ""
 . d setRedirect^%zewdAPI("invalidAccess",sessid)
 ;
 i $$getSessionValue^%zewdAPI("login",sessid)=1 d  QUIT ""
 . d setRedirect^%zewdAPI("loginForm",sessid)
 ;
 s page=$$getRequestValue^%zewdAPI("page",sessid)
 i page="" s page="compiler"
 f name="about","cacheConfig","compiler","config","cspConfig","customTags","getPHPInfo","gtmConfig","mgwsi","mysqlConfig","phpConfig","sessions","xrefPageToPage","xrefPageFromPage","xrefPageToScript","xrefPageFromScript","xrefPageToTag","xrefPageFromTag" d
 . s allowed(name)=""
 s error=""
 i $d(allowed(page)) d
 . d setRedirect^%zewdAPI(page,sessid)
 e  d
 . s error="Illegal attempt to access a page"
 QUIT error
 ;
login(sessid)
 ;
 n username,password,mess,%d,userPassword,userStatus,userType,loginErrors,Error
 ;
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 s password=$$getSessionValue^%zewdAPI("password",sessid)
 ;
 s mess="Invalid login attempt"
 i username="" QUIT "You must enter a username"
 i password="" QUIT "You must enter a password"
 i '$d(^%zewd("config","security","username",username)) QUIT mess
 s %d=^%zewd("config","security","username",username)
 s userPassword=$p(%d,$C(1),1)
 s userType=$p(%d,$c(1),2)
 s userStatus=$p(%d,$c(1),3)
 s loginErrors=$p(%d,$c(1),4)
 i userStatus'="active" QUIT mess
 s Error=""
 i $$enc^%zewdEnc(password)'=userPassword D  QUIT Error
 . n maxLoginErrors
 . S Error=mess
 . s loginErrors=$G(loginErrors)+1
 . s $p(^%zewd("config","security","username",username),$c(1),4)=loginErrors
 . s maxLoginErrors=$G(^%zewd("config","security","maxLoginErrors"))
 . i maxLoginErrors="" S maxLoginErrors=5
 . i loginErrors'<maxLoginErrors s $p(^%zewd("config","security","username",username),$c(1),3)="disabled"
 s $p(^%zewd("config","security","username",username),$c(1),4)=0
 d deleteFromSession^%zewdAPI("login",sessid)
 QUIT ""  ; successful login
 ;
 ;
about(sessid)
 ;
 d setSessionValue^%zewdAPI("ewd_version",$$version^%zewdAPI(),sessid)
 d setSessionValue^%zewdAPI("ewd_date",$$date^%zewdAPI(),sessid)
 QUIT ""
 ;
 ;
compileSelectPrepage(sessid)
 ;
 n app,appPath,dir,ewd,nApps,ok,os,sdir,selected,sortedDir
 ;
 s ok=$$getConfig^%zewdCompiler16(.ewd)
 ;
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 s appPath=$$getApplicationRootPath^%zewdAPI()
 i os="windows",appPath="" s appPath="\inetpub\wwwroot\php"
 i os="unix",appPath="" s appPath="/usr/ewd/apps"
 i os="gtm",appPath="" s appPath="/usr/ewd/apps"
 i $e(appPath,$l(appPath))=dlim s appPath=$e(appPath,1,$l(appPath)-1)
 d setSessionValue^%zewdAPI("appPath",appPath,sessid)
 d deleteFromSession^%zewdAPI("appList",sessid)
 d getDirectoriesInPath^%zewdHTMLParser(appPath,.dirs)
 s dir="",nApps=0
 f  s dir=$o(dirs(dir)) q:dir=""  d
 . s sortedDir($$zcvt^%zewdAPI(dir,"l"))=dir
 . s nApps=nApps+1
 d clearList^%zewdAPI("appName",sessid)
 s sdir=""
 f  s sdir=$o(sortedDir(sdir)) q:sdir=""  d
 . s dir=sortedDir(sdir)
 . d appendToList^%zewdAPI("appName",dir,dir,sessid)
 d setSessionValue^%zewdAPI("noOfApps",nApps,sessid)
 ;
 d clearList^%zewdAPI("frontEndTechnology",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","PHP","php",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","Cache Server Pages","csp",sessid)
 ;d appendToList^%zewdAPI("frontEndTechnology","WebLink","wl",sessid)
 d setSessionValue^%zewdAPI("frontEndTechnology",$g(ewd("frontEndTechnology")),sessid)
 ;
 d clearList^%zewdAPI("backEndTechnology",sessid)
 d appendToList^%zewdAPI("backEndTechnology","PHP","php",sessid)
 d appendToList^%zewdAPI("backEndTechnology","Cache","cache",sessid)
 d appendToList^%zewdAPI("backEndTechnology","MUMPS","m",sessid)
 d setSessionValue^%zewdAPI("backEndTechnology",$g(ewd("backEndTechnology")),sessid)
 ;
 d clearList^%zewdAPI("persistenceDB",sessid)
 d appendToList^%zewdAPI("persistenceDB","mySQL","mysql",sessid)
 d appendToList^%zewdAPI("persistenceDB","Cache","cache",sessid)
 d appendToList^%zewdAPI("persistenceDB","GT.M","gtm",sessid)
 d setSessionValue^%zewdAPI("persistenceDB",$g(ewd("sessionDatabase","type")),sessid)
 ;
 d clearList^%zewdAPI("format",sessid)
 d appendToList^%zewdAPI("format","Indented","pretty",sessid)
 d appendToList^%zewdAPI("format","Collapsed","collapse",sessid)
 d setSessionValue^%zewdAPI("format",$g(ewd("defaultFormat")),sessid)
 ;
 QUIT ""
 ;
compileAll(sessid)
 ;
 n app,appPath,dlim,docName,error,ewd,fileName,io,multilingual
 n n,ok,os,outputPath,outputStyle,path,results,rpath,technology
 ;
 k ^ewdResults($j)
 s io=$io
 s app=$$getSessionValue^%zewdAPI("appName",sessid)
 s outputStyle=$$getSessionValue^%zewdAPI("format",sessid)
 s ewd("frontEndTechnology")=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 s ewd("backEndTechnology")=$$getSessionValue^%zewdAPI("backEndTechnology",sessid)
 s ewd("sessionDatabase","type")=$$getSessionValue^%zewdAPI("persistenceDB",sessid)
 ;
 s outputPath="/usr/ewd/apps"
 ;
 s docName=$$parseConfigFile^%zewdCompiler16()
 i docName'="" d
 . s ok=$$select^%zewdXPath("/ewdConfiguration/compilerSettings[@technology="_ewd("frontEndTechnology")_"]",docName,.nodes)
 . s outputPath=$$getAttribute^%zewdDOM("outputPath",nodes(1))
 . ;
 . s ok=$$select^%zewdXPath("/ewdConfiguration/sessionDatabase[@database="_ewd("sessionDatabase","type")_"]/access",docName,.nodes)
 . i ewd("sessionDatabase","type")="mysql" d
 . . s ewd("sessionDatabase","host")=$$getAttribute^%zewdDOM("host",nodes(1))
 . . s ewd("sessionDatabase","username")=$$getAttribute^%zewdDOM("username",nodes(1))
 . . s ewd("sessionDatabase","password")=$$getAttribute^%zewdDOM("password",nodes(1))
 . i ewd("sessionDatabase","type")="gtm"!(ewd("sessionDatabase","type")="cache") d
 . . s ewd("sessionDatabase","mgwsiServer")=$$getAttribute^%zewdDOM("mgwsiServer",nodes(1))
 s appPath=$$getSessionValue^%zewdAPI("appPath",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 s path=appPath_dlim_app
 s outputPath=outputPath_dlim_app
 ;
 s multilingual=0
 s technology=ewd("frontEndTechnology")
 s backend=$g(ewd("backEndTechnology"))
 i backend="cache"!(backend="gtm") s backend="m"
 i backend="" s backend="m"
 ;
 ;d trace^%zewdAPI("in compileAll: path="_path_" ; outputPath="_outputPath)
 s error=$$processApplication^%zewdCompiler(path,outputPath,2,outputStyle,.results,technology,,multilingual)
 ;d trace^%zewdAPI("compileAll - run ok")
 i error'="" QUIT error
 s n=""
 i $$os^%zewdHTMLParser()="gtm" d
 . k results
 . m results=^ewdResults($j) k ^ewdResults($j)
 f  s n=$o(results(n)) q:n=""  d
 . s rpath=results(n)
 . s rpath=$tr(path,"\","/")
 . s $p(results(n),$c(1),2)=rpath
 ;
 d deleteFromSession^%zewdAPI("compilerListing",sessid)
 d mergeArrayToSession^%zewdAPI(.results,"compilerListing",sessid)
 ;
 u io
 QUIT ""
 ;
getPageList(sessid)
 ;
 n app,appPath,compInfo,delim,dmod,file,fileAttrs,fileList,fpath
 n info,io,outputPath,path,size,technology
 ;
 s io=$io
 s app=$$getSessionValue^%zewdAPI("appName",sessid)
 s delim="/"
 i $$os^%zewdHTMLParser()="windows" s delim="\"
 s appPath=$$getSessionValue^%zewdAPI("appPath",sessid)
 s path=appPath_delim_app
 s technology=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler(technology)
 ;
 d getFileInfo^%zewdGTM(path,".ewd",.fileList)
 d getFileInfo^%zewdGTM(outputPath,technology,.compInfo)
 k fileList("ewdTemplate.ewd")
 d deleteFromSession^%zewdAPI("fileList",sessid)
 d addToSession^%zewdAPI("fileList",sessid)
 ;
 d deleteFromSession^%zewdAPI("file",sessid)
 s file=""
 f  s file=$o(fileList(file)) q:file=""  d
 . s fpath=$p(file,".ewd",1)
 . s fpath=fpath_"."_technology
 . s size=$p($g(compInfo(fpath)),$c(1),3)
 . s dmod=$p($g(compInfo(fpath)),$c(1),1)_" "_$p($g(compInfo(fpath)),$c(1),2)
 . i size<0!(size="") d
 . . s size="n/a"
 . . s dmod="n/a"
 . e  d
 . s fileAttrs("name")=file
 . s fileAttrs("size")=size
 . s fileAttrs("dateModified")=dmod
 . d mergeRecordArrayToResultSet^%zewdAPI("file",.fileAttrs,sessid)
 ;
 u io
 QUIT ""
 ;
compilePage(sessid) ;
 ;
 n backend,dmod,filepath,line,lineNo,outputStyle,outputPath,results,mess,page,path,dlim
 n io,os,outputFile,multilingual,persistenceDB,size,technology,error
 ;
 s io=$io
 s page=$$getRequestValue^%zewdAPI("page",sessid)
 d setSessionValue^%zewdAPI("fileName",page,sessid)
 s app=$$getSessionValue^%zewdAPI("appName",sessid)
 s appPath=$$getSessionValue^%zewdAPI("appPath",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 s filepath=appPath_dlim_app_dlim_page
 ;
 s outputStyle=$$getRequestValue^%zewdAPI("format",sessid)
 s technology=$$getRequestValue^%zewdAPI("technology",sessid)
 s backend=$$getRequestValue^%zewdAPI("backend",sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler(technology)_dlim_app
 s persistenceDB=$$getRequestValue^%zewdAPI("pdb",sessid)
 ;
 ;d trace^%zewdAPI("filepath="_filepath)
 ;d trace^%zewdAPI("outputPath="_outputPath)
 s multilingual=0
 s error=$$processOneFile^%zewdCompiler(filepath,outputPath,2,outputStyle,technology,multilingual)
 i error'="" QUIT error
 d deleteFromSession^%zewdAPI("compilerListing",sessid)
 ;d mergeArrayToSession^%zewdAPI(.results,"compilerListing",sessid)
 u io
 ;
 s outputFile=outputPath_dlim_$p(page,".ewd",1)_"."_technology
 d getFileInfo^%zewdGTM(outputFile,technology,.compInfo)
 s size=$p(compInfo(fpath),$c(1),3)
 s dmod=$p(compInfo(fpath),$c(1),1)_" "_$p(compInfo(fpath),$c(1),2)
 i size<0!(size="") d
 . s size="n/a"
 . s dmod="n/a"
 d setSessionValue^%zewdAPI("fileSize",size,sessid)
 d setSessionValue^%zewdAPI("fileModified",dmod,sessid)
 ;
 QUIT error
 ;
 ;
configPrepage(sessid) ;
 ;
 n config
 ;
 d clearList^%zewdAPI("frontEndTechnology",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","PHP","php",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","Cache Server Pages","csp",sessid)
 ;d appendToList^%zewdAPI("frontEndTechnology","WebLink","wl",sessid)
 ;
 d clearList^%zewdAPI("backEndTechnology",sessid)
 d appendToList^%zewdAPI("backEndTechnology","PHP","php",sessid)
 d appendToList^%zewdAPI("backEndTechnology","Cache","cache",sessid)
 d appendToList^%zewdAPI("backEndTechnology","MUMPS","m",sessid)
 ;
 d clearList^%zewdAPI("persistenceDB",sessid)
 d appendToList^%zewdAPI("persistenceDB","mySQL","mysql",sessid)
 d appendToList^%zewdAPI("persistenceDB","Cache","cache",sessid)
 d appendToList^%zewdAPI("persistenceDB","GT.M","gtm",sessid)
 ;
 d clearList^%zewdAPI("format",sessid)
 d appendToList^%zewdAPI("format","Indented","pretty",sessid)
 d appendToList^%zewdAPI("format","Collapsed","collapse",sessid)
 ;
 d getConfigDetails^%zewdCompiler16(.config)
 d setSessionValue^%zewdAPI("frontEndTechnology",$g(config("main","frontEndTechnology")),sessid)
 d setSessionValue^%zewdAPI("backEndTechnology",$g(config("main","backEndTechnology")),sessid)
 d setSessionValue^%zewdAPI("persistenceDB",$g(config("main","sessionDatabase")),sessid)
 d setSessionValue^%zewdAPI("format",$g(config("main","markupFormat")),sessid)
 d setSessionValue^%zewdAPI("appRootPath",$g(config("main","applicationRootPath")),sessid)
 ;
 f technology="php","csp" d
 . d setSessionValue^%zewdAPI(technology_"OutputPath",$g(config("technology",technology,"outputRootPath")),sessid)
 . d setSessionValue^%zewdAPI(technology_"RootURL",$g(config("technology",technology,"rootURL")),sessid)
 . d clearList^%zewdAPI(technology_"JsURLType",sessid)
 . d appendToList^%zewdAPI(technology_"JsURLType","Absolute","fixed",sessid)
 . d appendToList^%zewdAPI(technology_"JsURLType","Relative","relative",sessid)
 . d setSessionValue^%zewdAPI(technology_"JsURLType",$g(config("technology",technology,"jsScriptPath","mode")),sessid)
 . d setSessionValue^%zewdAPI(technology_"JsURLRoot",$g(config("technology",technology,"jsScriptPath","path")),sessid)
 ;
 d setSessionValue^%zewdAPI("mysqlHost",$g(config("database","mysql","host")),sessid)
 d setSessionValue^%zewdAPI("mysqlUsername",$g(config("database","mysql","username")),sessid)
 d setSessionValue^%zewdAPI("mysqlPassword",$g(config("database","mysql","password")),sessid)
 ;
 f database="cache","gtm" d
 . d setSessionValue^%zewdAPI(database_"MgwsiServer",$g(config("database",database,"mgwsiServer")),sessid)
 ;
 QUIT ""
 ;
selectNode(path,docName)
 ;
 n ok,nodes
 ;
 s ok=$$select^%zewdXPath(path,docName,.nodes)
 QUIT $g(nodes(1))
 ;
saveMainConfig(sessid)
 ;
 n nodeOID,docName,ok
 ;
 ;s docName=$$parseConfigFile^%zewdCompiler16()
 ;i docName="" d
 ;. n docOID,nodeOID,xOID,yOID
 ;. s docName="ewdConfig"
 ;. s docOID=$$createDocument^%zewdDOM("",,"",docName)
 ;. s nodeOID=$$addElementToDOM^%zewdDOM("ewdConfiguration",docOID)
 ;. s xOID=$$addElementToDOM^%zewdDOM("system",nodeOID)
 ;. s yOID=$$addElementToDOM^%zewdDOM("target",xOID)
 ;. s yOID=$$addElementToDOM^%zewdDOM("sourceCode",xOID)
 ;. s yOID=$$addElementToDOM^%zewdDOM("sessionPersistence",xOID)
 ;. s yOID=$$addElementToDOM^%zewdDOM("compiledCode",xOID)
 ;;
 ;s nodeOID=$$selectNode("/ewdConfiguration/system/target",docName)
 ;d setAttribute^%zewdDOM("frontEndTechnology",$$getSessionValue^%zewdAPI("frontEndTechnology",sessid),nodeOID)
 s ^zewd("config","frontEndTechnology")=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 ;d setAttribute^%zewdDOM("backEndTechnology",$$getSessionValue^%zewdAPI("backEndTechnology",sessid),nodeOID)
 s ^zewd("config","backEndTechnology")=$$getSessionValue^%zewdAPI("backEndTechnology",sessid)
 ;s nodeOID=$$selectNode("/ewdConfiguration/system/sessionPersistence",docName)
 ;d setAttribute^%zewdDOM("database",$$getSessionValue^%zewdAPI("persistenceDB",sessid),nodeOID)
 s ^zewd("config","sessionDatabase")=$$getSessionValue^%zewdAPI("persistenceDB",sessid)
 ;s nodeOID=$$selectNode("/ewdConfiguration/system/compiledCode",docName)
 ;d setAttribute^%zewdDOM("defaultFormat",$$getSessionValue^%zewdAPI("format",sessid),nodeOID)
 s ^zewd("config","defaultFormat")=$$getSessionValue^%zewdAPI("format",sessid)
 ;;d setAttribute^%zewdDOM("defaultHomePage",$$getSessionValue^%zewdAPI("format",sessid),nodeOID)
 ;s nodeOID=$$selectNode("/ewdConfiguration/system/sourceCode",docName)
 ;d setAttribute^%zewdDOM("path",$$getSessionValue^%zewdAPI("appRootPath",sessid),nodeOID)
 d setApplicationRootPath^%zewdAPI($$getSessionValue^%zewdAPI("appRootPath",sessid))
 ;;
 ;s ok=$$saveConfigFile^%zewdCompiler16(docName)
 ;
 QUIT ok
 ;
savePHPConfig(sessid)
 QUIT $$saveTechnologyConfig("php",sessid)
 ;
saveCSPConfig(sessid)
 QUIT $$saveTechnologyConfig("csp",sessid)
 ;
saveTechnologyConfig(technology,sessid)
 ;
 n nodeOID,docName,ok
 ;
 ;s docName=$$parseConfigFile^%zewdCompiler16()
 ;i docName'="" d
 ;. s nodeOID=$$selectNode("/ewdConfiguration/compilerSettings[@technology="_technology_"]",docName)
 ;. i nodeOID="" d
 ;. . s nodeOID=$$selectNode("/ewdConfiguration",docName)
 ;. . s nodeOID=$$addElementToDOM^%zewdDOM("compilerSettings",nodeOID)
 ;. . d setAttribute^%zewdDOM("technology",technology,nodeOID)
 ;. d setAttribute^%zewdDOM("outputPath",$$getSessionValue^%zewdAPI(technology_"OutputPath",sessid),nodeOID)
 ;. d setAttribute^%zewdDOM("rootURL",$$getSessionValue^%zewdAPI(technology_"RootURL",sessid),nodeOID)
 ;. s nodeOID=$$selectNode("/ewdConfiguration/compilerSettings[@technology="_technology_"]/javascriptFiles",docName)
 ;. i nodeOID="" d
 ;. . s nodeOID=$$selectNode("/ewdConfiguration/compilerSettings[@technology="_technology_"]",docName)
 ;. . s nodeOID=$$addElementToDOM^%zewdDOM("javascriptFiles",nodeOID)
 ;. d setAttribute^%zewdDOM("path",$$getSessionValue^%zewdAPI(technology_"JsURLRoot",sessid),nodeOID)
 ;. d setAttribute^%zewdDOM("urlType",$$getSessionValue^%zewdAPI(technology_"JsURLType",sessid),nodeOID)
 ;
 ;s ok=$$saveConfigFile^%zewdCompiler16(docName)
 s ^zewd("config","jsScriptPath",technology,"mode")=$$getSessionValue^%zewdAPI(technology_"JsURLType",sessid)
 s ^zewd("config","jsScriptPath",technology,"path")=$$getSessionValue^%zewdAPI(technology_"JsURLRoot",sessid)
 s ^zewd("config","outputRootPath",technology)=$$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)
 s ^zewd("config","rootURL",technology)=$$getSessionValue^%zewdAPI(technology_"RootURL",sessid)
 ;
 QUIT ok
 ;
saveCacheConfig(sessid)
 QUIT $$saveDatabaseConfig("cache",sessid)
 ;
saveGtmConfig(sessid)
 QUIT $$saveDatabaseConfig("gtm",sessid)
 ;
saveDatabaseConfig(database,sessid)
 ;
 n nodeOID,docName,ok
 ;
 ;s docName=$$parseConfigFile^%zewdCompiler16()
 ;i docName'="" d
 ;. s nodeOID=$$selectNode("/ewdConfiguration/sessionDatabase[@database="_database_"]",docName)
 ;. i nodeOID="" d
 ;. . n xOID,yOID
 ;. . s nodeOID=$$selectNode("/ewdConfiguration",docName)
 ;. . s xOID=$$addElementToDOM^%zewdDOM("sessionDatabase",nodeOID)
 ;. . d setAttribute^%zewdDOM("database",database,xOID)
 ;. . s yOID=$$addElementToDOM^%zewdDOM("access",xOID)
 ;. ;
 ;. s nodeOID=$$selectNode("/ewdConfiguration/sessionDatabase[@database="_database_"]/access",docName)
 ;. d setAttribute^%zewdDOM("mgwsiServer",$$getSessionValue^%zewdAPI(database_"MgwsiServer",sessid),nodeOID)
 ;;
 s ^zewd("config","database",database,"mgwsiServer")=$$getSessionValue^%zewdAPI(database_"MgwsiServer",sessid)
 ;s ok=$$saveConfigFile^%zewdCompiler16(docName)
 ;
 QUIT ok
 ;
saveMysqlConfig(sessid)
 ;
 n nodeOID,docName,ok
 ;
 ;s docName=$$parseConfigFile^%zewdCompiler16()
 ;i docName'="" d
 ;. s nodeOID=$$selectNode("/ewdConfiguration/sessionDatabase[@database=mysql]",docName)
 ;. i nodeOID="" d
 ;. . n xOID,yOID
 ;. . s xOID=$$addElementToDOM^%zewdDOM("sessionDatabase",nodeOID)
 ;. . d setAttribute^%zewdDOM("database","mysql",xOID)
 ;. . s yOID=$$addElementToDOM^%zewdDOM("access",xOID)
 ;. ;
 ;. s nodeOID=$$selectNode("/ewdConfiguration/sessionDatabase[@database=mysql]/access",docName)
 ;. d setAttribute^%zewdDOM("host",$$getSessionValue^%zewdAPI("mysqlHost",sessid),nodeOID)
 ;. d setAttribute^%zewdDOM("username",$$getSessionValue^%zewdAPI("mysqlUsername",sessid),nodeOID)
 ;. d setAttribute^%zewdDOM("password",$$getSessionValue^%zewdAPI("mysqlPassword",sessid),nodeOID)
 ;;
 ;s ok=$$saveConfigFile^%zewdCompiler16(docName)
 s ^zewd("config","database",database,"host")=$$getSessionValue^%zewdAPI("mysqlHost",sessid)
 s ^zewd("config","database",database,"username")=$$getSessionValue^%zewdAPI("mysqlUsername",sessid)
 s ^zewd("config","database",database,"password")=$$getSessionValue^%zewdAPI("mysqlPassword",sessid)
 ;
 QUIT ok
 ;
getIndices(sessid)
 ;
 n appName,appPath,dlim,ok,os,path,xref
 ;
 d deleteFromSession^%zewdAPI("xref",sessid)
 d clearSessionArray^%zewdAPI("pageCalls",sessid)
 d clearSessionArray^%zewdAPI("pageCalledBy",sessid)
 d clearSessionArray^%zewdAPI("scriptCalls",sessid)
 d clearSessionArray^%zewdAPI("scriptCalledBy",sessid)
 d clearSessionArray^%zewdAPI("tagCalls",sessid)
 d clearSessionArray^%zewdAPI("tagCalledBy",sessid)
 ;
 s appPath=$$getSessionValue^%zewdAPI("appPath",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 s appPath=appPath_dlim_appName
 d setSessionValue^%zewdAPI("path",appPath,sessid)
 d setSessionValue^%zewdAPI("clearXRef",0,sessid)
 f xref="pageCalls","pageCalledBy","scriptCalls","scriptCalledBy","tagCalls","tagCalledBy" d
 . d setSessionValue^%zewdAPI("xref",xref,sessid)
 . s ok=$$getIndices^%zewdCompiler7(sessid)
 QUIT ""
 ;
getSessionList(sessid)
 ;
 n no,sessionList
 ;
 i $$isCSP^%zewdAPI(sessid) d
 . n currSessid
 . d setSessionValue^%zewdAPI("technology","csp",sessid)
 . s currSessid=$$getSessionValue^%zewdAPI("ewd_sessid",sessid)
 . s no=0
 . f  s no=$o(^%cspSession(no)) q:no=""  d
 . . i ("csp:"_no)=currSessid s sessionList(currSessid)=""
 . . e  s sessionList(no)=""
 e  d
 . d setSessionValue^%zewdAPI("technology","php",sessid)
 . s no=""
 . f  s no=$o(^%zewdSession("session",no)) q:no=""  d
 . . s sessionList(no)=""
 ;
 d deleteFromSession^%zewdAPI("sessionList",sessid)
 d mergeToSession^%zewdAPI("sessionList",sessid)
 ;
 QUIT ""
 ;
getSessionDetails(sessid)
 ;
 n sessioNo
 ;
 s sessionNo=$$getRequestValue^%zewdAPI("sessionNo",sessid)
 d setSessionValue^%zewdAPI("sessionNo",sessionNo,sessid)
 ;
 QUIT ""
 ;
displaySessionDetails(sessid)
 ;
 n session,sessionNo,lineNo,ref,data,%p1,line
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("sessionNo",sessid)
 ;
 k ^%work($j)
 i $$isCSP^%zewdAPI(sessid) d
 . i $e(sessionNo,1,3)="csp" s sessionNo=$e(sessionNo,5,$l(sessionNo))
 . m ^%work($j)=^%cspSession(sessionNo,0)
 e  d
 . m ^%work($j)=^%zewdSession("session",sessionNo)
 ;
 s ref="^%work($j,"""")"
 s lineNo=0
 f  s ref=$q(@ref) q:ref'[("^%work("_$j)  d
 . s data=@ref
 . s %p1=$p(ref,"^%work("_$j_",",2)
 . s %p1=$e(%p1,1,$l(%p1)-1)
 . s data=$tr(data,$c(1),"|")
 . i data="" s data="&nbsp;"
 . w "<tr>"
 . w "<td width='50%' class='configRow'>"_%p1_"</td>"
 . w "<td class='configRow'>"_data_"</td>"
 . w "</tr>"_$c(13,10)
 ;
 k ^%work($j)
 QUIT
 ;
deleteSession(sessionNo)
  ;d trace^%zewdAPI("about to delete session "_sessionNo)
  d deleteSession^%zewdAPI(sessionNo)
  QUIT ""
  ;
getCustomTagList(sessid)
 ;
 n customTagList,data,hasCustomTags,newTagImpliedClose,applyTo,tag,type
 ;
 d deleteFromSession^%zewdAPI("customTagList",sessid)
 m customTagList=^%zewd("customTag")
 ;
 s tag="",hasCustomTags=0
 f  s tag=$o(^%zewd("customTag",tag)) q:tag=""  d
 . s data=^%zewd("customTag",tag)
 . s type=$p(data,$c(1),3)
 . i type'="system" d
 . . s hasCustomTags=1
 . e  d
 . . k customTagList(tag)
 d setSessionValue^%zewdAPI("hasCustomTags",hasCustomTags,sessid)
 d addToSession^%zewdAPI("customTagList",sessid)
 ;
 QUIT ""
 ;
getCustomTagDetails(sessid)
 ;
 n include,macro,tagName,tagMethod,tagImpliedClose,applyTo
 ;
 s tagName=$$getRequestValue^%zewdAPI("tagName",sessid)
 d setSessionValue^%zewdAPI("tagName",tagName,sessid)
 ;
 s tagMethod=$$getCustomTagMethod^%zewdCompiler(tagName)
 d addToSession^%zewdAPI("tagMethod",sessid)
 s tagImpliedClose=+$$isImpliedCloseTag^%zewdCompiler(tagName)
 s applyTo=$$getCustomTagApply^%zewdCompiler(tagName)
 i applyTo="" s applyTo="all"
 s include=$$getCustomTagInclude^%zewdCompiler(tagName)
 s macro=$$getCustomTagMacro^%zewdCompiler(tagName)
 d addToSession^%zewdAPI("tagImpliedClose",sessid)
 d addToSession^%zewdAPI("applyTo",sessid)
 d setSessionValue^%zewdAPI("tagInclude",include,sessid)
 d setSessionValue^%zewdAPI("tagMacro",macro,sessid)
 QUIT ""
 ;
saveCustomTag(sessid)
 ;
 n tagInclude,tagName,tagMacro,tagMethod,tagImpliedClose,tagAttrList,applyTo
 ;
 s tagInclude=$$getSessionValue^%zewdAPI("tagInclude",sessid)
 s tagMacro=$$getSessionValue^%zewdAPI("tagMacro",sessid)
 s tagName=$$getSessionValue^%zewdAPI("tagName",sessid)
 s tagMethod=$$getSessionValue^%zewdAPI("tagMethod",sessid)
 s tagImpliedClose=+$$getSessionValue^%zewdAPI("tagImpliedClose",sessid) 
 s tagAttrList="" ;$$getSessionValue^%zewdAPI("tagAttrList",sessid)
 s applyTo=$$getSessionValue^%zewdAPI("applyTo",sessid) 
 ;
 i tagName="" QUIT "You did not specify a tag name"
 i tagMethod="",tagInclude="",tagMacro="" QUIT "You did not specify the include file, macro file or method for processing the "_tagName_" tag"
 i tagMethod'="",tagMethod'["^",tagMethod'["##class" QUIT "The method name for processing the "_tagName_" tag is invalid"
 i tagInclude'="",tagMethod'="" QUIT "You must specify either an include file or a method, but not both"
 i tagInclude'="",tagMacro'="" QUIT "You must specify either an include file or a macro file, but not both"
 i tagMethod'="",tagMacro'="" QUIT "You must specify either a macro file or a method, but not both"
 i tagMethod="",tagMacro="",tagInclude'["." QUIT "Invalid include file"
 i tagMethod="",tagInclude="",tagMacro'["." QUIT "Invalid macro file"
 ;
 s tagName=$$zcvt^%zewdAPI(tagName,"l")
 i $$setCustomTag^%zewdCompiler(tagName,tagMethod,tagImpliedClose,tagAttrList,applyTo,tagInclude,tagMacro)
 QUIT ""
 ;
getPageContent(sessid)
 ;
 QUIT ""
 ;
getPageDetails(sessid)
 ;
 n appName,dlim,filepath,pageListing,pageName,path
 ;
 s pageName=$$getRequestValue^%zewdAPI("pageName",sessid)
 d setSessionValue^%zewdAPI("pageName",pageName,sessid)
 s path=$$getSessionValue^%zewdAPI("appPath",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s dlim="\" i path["/" s dlim="/"
 i $e(path,$l(path))'=dlim s path=path_dlim_appName_dlim
 s filepath=path_pageName
 d extractFileToArray^%zewdHTMLParser(filepath,.pageListing)
 d clearTextArea^%zewdAPI("pageListing",sessid)
 d mergeToTextArea^%zewdAPI("pageListing",.pageListing,sessid)
 ;
 QUIT ""
