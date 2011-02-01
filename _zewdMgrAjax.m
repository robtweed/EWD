%zewdMgrAjax	; Enterprise Web Developer Manager Functions
 ;
 ; Product: Enterprise Web Developer (Build 841)
 ; Build Date: Tue, 01 Feb 2011 13:50:15
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
 n fet,opp,rurl,version
 ;
 s version=$p($t(version^%zewdCompiler2),";;",2)
 d copyRequestValueToSession^%zewdAPI("sso",sessid)
 i $g(^%zewd("version"))'=version d
 . d updateTagDefinitions^%zewdCompiler
 . s ^%zewd("version")=version
 i $g(^%zewd("disabled"))=1 d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","invalidAccess",sessid)
 d setSessionValue^%zewdAPI("initialPage","mainMenu",sessid)
 i '$$validSubnet(sessid) d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","invalidAccess",sessid)
 i $$applicationRootPath^%zewdAPI()="" d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","configOnlyMenu",sessid)
 s fet="gtm"
 d setSessionValue^%zewdAPI("ewd_isVirtualAppliance",0,sessid)
 i fet="" d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","configOnlyMenu",sessid)
 i fet="wl"!(fet="gtm") d
 . s opp=$g(^zewd("config","jsScriptPath",fet,"outputPath"))
 e  d
 . s opp=$g(^zewd("config","outputRootPath",fet))
 i opp="" d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","configOnlyMenu",sessid) 
 s rurl=$g(^zewd("config","RootURL",fet))
 i rurl="" d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","configOnlyMenu",sessid)
 i $$passwordProtected() d  QUIT ""
 . d setSessionValue^%zewdAPI("initialPage","login",sessid)
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
 i browserIP=cacheIP QUIT 1
 i browserIP="127.0.0.1" QUIT 1
 s subnet="",%stop=0
 i '$d(^%zewd("config","security","validSubnet")) s ^%zewd("config","security","validSubnet",browserIP)=""
 f  s subnet=$o(^%zewd("config","security","validSubnet",subnet)) Q:subnet=""  do  Q:%stop
 . n len
 . s len=$l(subnet,".")
 . i $p(browserIP,".",1,len)=subnet s %stop=1
 QUIT %stop
 ;
passwordProtected() ;
 ;
 Q $d(^%zewd("config","security","username"))
 ;
vaRedirect(sessid)
 ;
 ; Main Page Redirector
 ;
 n error,name,page,password,sso,username,xsessid
 ;
 s page=$$getSessionValue^%zewdAPI("initialPage",sessid)
 i page="login" d setRedirect^%zewdAPI(page,sessid) QUIT ""
 d setRedirect^%zewdAPI("gtmMenu",sessid)
 QUIT ""
 ;
redirect(sessid)
 ;
 ; Main Page Redirector
 ;
 n error,name,page,password,sso,username,xsessid
 ;
 s page=$$getSessionValue^%zewdAPI("initialPage",sessid)
 s sso=$$getSessionValue^%zewdAPI("sso",sessid)
 i sso="",page="login"!(page="mainMenu")!(page="configOnlyMenu") d setRedirect^%zewdAPI(page,sessid) QUIT ""
 d setRedirect^%zewdAPI("invalidAccess",sessid)
 i sso="" QUIT ""
 ;
 i $$isSSOValid^%zewdAPI(sso,"username","password",sessid) d setRedirect^%zewdAPI("mainMenu",sessid)
 QUIT ""
 ;
login(sessid)
 ;
 n context,username,password,mess,%d,userPassword,userStatus,userType,loginErrors,Error
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
 s context=1
 i $d(^zewd("config","MGWSI")) s context=0
 i $$SHA1^%ZMGWSIS(password,1,context)'=userPassword D  QUIT Error
 . n maxLoginErrors
 . S Error=mess
 . s loginErrors=$G(loginErrors)+1
 . s $p(^%zewd("config","security","username",username),$c(1),4)=loginErrors
 . s maxLoginErrors=$G(^%zewd("config","security","maxLoginErrors"))
 . i maxLoginErrors="" S maxLoginErrors=5
 . i loginErrors'<maxLoginErrors s $p(^%zewd("config","security","username",username),$c(1),3)="disabled"
 s $p(^%zewd("config","security","username",username),$c(1),4)=0
 d deleteFromSession^%zewdAPI("login",sessid)
 i $$applicationRootPath^%zewdAPI()="" d setRedirect^%zewdAPI("configOnlyMenu",sessid) QUIT ""
 i $$getSessionValue^%zewdAPI("ewd_isVirtualAppliance",sessid)=1 d setRedirect^%zewdAPI("gtmMenu",sessid)
 QUIT ""  ; successful login
 ;
about(sessid)
 ;
 d setSessionValue^%zewdAPI("ewd_version",$$version^%zewdAPI(),sessid)
 d setSessionValue^%zewdAPI("ewd_date",$$date^%zewdAPI(),sessid)
 d setSessionValue^%zewdAPI("ewdVersion",$$version^%zewdAPI(),sessid)
 QUIT ""
 ;
saveCacheConfig(sessid)
 QUIT $$saveDatabaseConfig("cache",sessid)
 ;
saveDatabaseConfig(database,sessid)
 ;
 n mgwsiServer,nodeOID,docName,ok
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
 s mgwsiServer=$$getSessionValue^%zewdAPI(database_"MgwsiServer",sessid)
 i mgwsiServer="" QUIT "You must enter a value for the MGWSI Server connection"
 s ^zewd("config","database",database,"mgwsiServer")=$$getSessionValue^%zewdAPI(database_"MgwsiServer",sessid)
 ;s ok=$$saveConfigFile^%zewdCompiler16(docName)
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
 d getFilesInPath^%zewdHTMLParser(path,"ewd",.fileList)
 k fileList("ewdTemplate.ewd")
 d deleteFromSession^%zewdAPI("fileList",sessid)
 d addToSession^%zewdAPI("fileList",sessid)
 ;
 d deleteFromSession^%zewdAPI("file",sessid)
 s file=""
 f  s file=$o(fileList(file)) q:file=""  d
 . s fpath=$p(file,".ewd",1)
 . s fpath=outputPath_delim_app_delim_fpath
 . s fpath=fpath_"."_technology
 . d fileInfo^%zewdAPI(fpath,.info)
 . s size=$g(info("size"))
 . s dmod=$g(info("date"))
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
 s page=$$getRequestValue^%zewdAPI("pageName",sessid)
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
 s multilingual=0
 s error=$$processOneFile^%zewdCompiler(filepath,outputPath,2,outputStyle,technology,multilingual)
 i error'="" QUIT error
 d deleteFromSession^%zewdAPI("compilerListing",sessid)
 u io
 ;
 s outputFile=outputPath_dlim_$p(page,".ewd",1)_"."_technology
 i technology="gtm" d
 . s page=$p(page,".ewd",1)
 . s outputFile=$g(^zewd("config","routinePath","gtm"))_"ewdWL"_$$zcvt^%zewdAPI(app,"l")_$$zcvt^%zewdAPI(page,"l")_".m"
 . s technology="m"
 d getFileInfo^%zewdGTM(outputFile,technology,.compInfo)
 s size=$p(compInfo(outputFile),$c(1),3)
 s dmod=$p(compInfo(outputFile),$c(1),1)_" "_$p(compInfo(outputFile),$c(1),2)
 i size<0!(size="") d
 . s size="n/a"
 . s dmod="n/a"
 d setSessionValue^%zewdAPI("fileSize",size,sessid)
 d setSessionValue^%zewdAPI("fileModified",dmod,sessid)
 ;
 QUIT error
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
 d setSessionValue^%zewdAPI("noOfApps",nApps,sessid)
 d clearList^%zewdAPI("appName",sessid)
 s sdir=""
 f  s sdir=$o(sortedDir(sdir)) q:sdir=""  d
 . s dir=sortedDir(sdir)
 . d appendToList^%zewdAPI("appName",dir,dir,sessid)
 d setSessionValue^%zewdAPI("noOfApps",nApps,sessid)
 ;
 d clearList^%zewdAPI("frontEndTechnology",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","GT.M / m_apache","gtm",sessid)
 d setSessionValue^%zewdAPI("frontEndTechnology","gtm",sessid)
 ;
 d clearList^%zewdAPI("backEndTechnology",sessid)
 d appendToList^%zewdAPI("backEndTechnology","MUMPS","m",sessid)
 d setSessionValue^%zewdAPI("backEndTechnology","m",sessid)
 ;
 d clearList^%zewdAPI("persistenceDB",sessid)
 d appendToList^%zewdAPI("persistenceDB","GT.M","gtm",sessid)
 d setSessionValue^%zewdAPI("persistenceDB","gtm",sessid)
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
 n app,appPath,db,dlim,docName,error,ewd,fileName,io,multilingual
 n n,ok,os,outputPath,outputStyle,path,results,rpath,technology
 ;
 k ^ewdResults($j)
 s io=$io
 s app=$$getSessionValue^%zewdAPI("appName",sessid)
 s outputStyle=$$getSessionValue^%zewdAPI("format",sessid)
 s ewd("frontEndTechnology")=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 s technology=ewd("frontEndTechnology")
 s ewd("backEndTechnology")=$$getSessionValue^%zewdAPI("backEndTechnology",sessid)
 s ewd("sessionDatabase","type")=$$getSessionValue^%zewdAPI("persistenceDB",sessid)
 s db=ewd("sessionDatabase","type")
 ;
 ;s outputPath="/usr/ewd/apps"
 ;;
 ;s docName=$$parseConfigFile^%zewdCompiler16()
 ;i docName'="" d
 ;. s ok=$$select^%zewdXPath("/ewdConfiguration/compilerSettings[@technology="_ewd("frontEndTechnology")_"]",docName,.nodes)
 ;. s outputPath=$$getAttribute^%zewdDOM("outputPath",nodes(1))
 ;. ;
 ;. s ok=$$select^%zewdXPath("/ewdConfiguration/sessionDatabase[@database="_ewd("sessionDatabase","type")_"]/access",docName,.nodes)
 ;. i ewd("sessionDatabase","type")="mysql" d
 ;. . s ewd("sessionDatabase","host")=$$getAttribute^%zewdDOM("host",nodes(1))
 ;. . s ewd("sessionDatabase","username")=$$getAttribute^%zewdDOM("username",nodes(1))
 ;. . s ewd("sessionDatabase","password")=$$getAttribute^%zewdDOM("password",nodes(1))
 ;. i ewd("sessionDatabase","type")="gtm"!(ewd("sessionDatabase","type")="cache") d
 ;. . s ewd("sessionDatabase","mgwsiServer")=$$getAttribute^%zewdDOM("mgwsiServer",nodes(1))
 ;
 s outputPath=$g(^zewd("config","outputRootPath",technology))
 m ewd("sessionDatabase")=^zewd("config","database",db)
 ;
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
 s error=$$processApplication^%zewdCompiler(path,outputPath,2,outputStyle,.results,technology,,multilingual)
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
saveMainConfig(sessid)
 ;
 n cspError,error,fet,phpError,wlError
 ;
 i $$getSessionValue^%zewdAPI("appRootPath",sessid)="" QUIT "You must define the Application Root Path"
 i $$getSessionValue^%zewdAPI("frontEndTechnology",sessid)="csp"!($$getSessionValue^%zewdAPI("frontEndTechnology",sessid)="wl") d
 . d setSessionValue^%zewdAPI("backEndTechnology","cache",sessid)
 . d setSessionValue^%zewdAPI("persistenceDB","cache",sessid)
 i $$getSessionValue^%zewdAPI("frontEndTechnology",sessid)="gtm"  d
 . d setSessionValue^%zewdAPI("backEndTechnology","m",sessid)
 . d setSessionValue^%zewdAPI("persistenceDB","gtm",sessid)
 s ^zewd("config","frontEndTechnology")=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 s ^zewd("config","backEndTechnology")=$$getSessionValue^%zewdAPI("backEndTechnology",sessid)
 s ^zewd("config","sessionDatabase")=$$getSessionValue^%zewdAPI("persistenceDB",sessid)
 s ^zewd("config","defaultFormat")=$$getSessionValue^%zewdAPI("format",sessid)
 d setApplicationRootPath^%zewdAPI($$getSessionValue^%zewdAPI("appRootPath",sessid))
 ;
 i $$getSessionValue^%zewdAPI("ewd.pageName",sessid)="configMain" QUIT ""
 ;
 s fet=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 s error=""
 i fet="php" d  QUIT error
 . s phpError="You must complete the PHP Web Technology configuration before you can compile to PHP!"
 . i '$d(^zewd("config","outputRootPath","php")) s error=phpError q
 . i '$d(^zewd("config","RootURL","php")) s error=phpError q
 . i '$d(^zewd("config","jsScriptPath","php")) s error=phpError q
 i fet="csp" d  QUIT error
 . s cspError="You must complete the CSP Web Technology configuration before you can compile to CSP!"
 . i '$d(^zewd("config","outputRootPath","csp")) s error=cspError q
 . i '$d(^zewd("config","RootURL","csp")) s error=cspError q
 . i '$d(^zewd("config","jsScriptPath","csp")) s error=cspError q
 i fet="wl" d  QUIT error
 . s wlError="You must complete the WebLink Web Technology configuration before you can compile to WebLink!"
 . i '$d(^zewd("config","jsScriptPath","wl","outputPath")) s error=wlError q
 . i '$d(^zewd("config","RootURL","wl")) s error=wlError q
 . i '$d(^zewd("config","jsScriptPath","wl")) s error=wlError q
 i fet="gtm" d  QUIT error
 . s wlError="You must complete the GT.M Web Technology configuration before you can compile to GT.M!"
 . i '$d(^zewd("config","jsScriptPath","gtm","outputPath")) s error=wlError q
 . i '$d(^zewd("config","RootURL","gtm")) s error=wlError q
 . i '$d(^zewd("config","jsScriptPath","gtm")) s error=wlError q
 QUIT ""
 ;
configMainPrepage(sessid) ;
 ;
 n config
 ;
 d clearList^%zewdAPI("frontEndTechnology",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","PHP","php",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","Cache Server Pages","csp",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","WebLink","wl",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","GT.M/MGWSI","gtm",sessid)
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
 i config("main","frontEndTechnology")="" s config("main","frontEndTechnology")="gtm"
 d setSessionValue^%zewdAPI("frontEndTechnology",$g(config("main","frontEndTechnology")),sessid)
 i config("main","backEndTechnology")="" s config("main","backEndTechnology")="m"
 d setSessionValue^%zewdAPI("backEndTechnology",$g(config("main","backEndTechnology")),sessid)
 i config("main","sessionDatabase")="" s config("main","sessionDatabase")="gtm"
 d setSessionValue^%zewdAPI("persistenceDB",$g(config("main","sessionDatabase")),sessid)
 d setSessionValue^%zewdAPI("format",$g(config("main","markupFormat")),sessid)
 d setSessionValue^%zewdAPI("appRootPath",$g(config("main","applicationRootPath")),sessid)
 ;
 QUIT ""
 ;
configWebTechPrepage(sessid)
 ;
 n rootURL,technology
 ;
 s technology=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 d setSessionValue^%zewdAPI("frontEndTechnologyText",$$getTextFromList^%zewdAPI("frontEndTechnology",technology,sessid),sessid)
 d setSessionValue^%zewdAPI(technology_"OutputPath",$g(^zewd("config","outputRootPath",technology)),sessid)
 s rootURL=$g(^zewd("config","RootURL",technology))
 i technology'="wl",technology'="gtm",rootURL="" s rootURL="/"_technology
 d setSessionValue^%zewdAPI(technology_"RootURL",rootURL,sessid)
 d clearList^%zewdAPI(technology_"JsURLType",sessid)
 d appendToList^%zewdAPI(technology_"JsURLType","Absolute","fixed",sessid)
 d appendToList^%zewdAPI(technology_"JsURLType","Relative","relative",sessid)
 d setSessionValue^%zewdAPI(technology_"JsURLType",$g(^zewd("config","jsScriptPath",technology,"mode")),sessid)
 d setSessionValue^%zewdAPI(technology_"JsURLRoot",$g(^zewd("config","jsScriptPath",technology,"path")),sessid)
 QUIT ""
 ;
saveWebTechConfig(sessid)
 ;
 n error,technology
 ;
 s technology=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 i $$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)="" QUIT "You must enter the Output Root Path"
 i $$getSessionValue^%zewdAPI(technology_"RootURL",sessid)="" QUIT "You must enter the Root URL"
 s ^zewd("config","jsScriptPath",technology,"mode")=$$getSessionValue^%zewdAPI(technology_"JsURLType",sessid)
 s ^zewd("config","jsScriptPath",technology,"path")=$$getSessionValue^%zewdAPI(technology_"JsURLRoot",sessid)
 i technology="wl"!(technology="gtm") d
 . s ^zewd("config","jsScriptPath","gtm","outputPath")=$$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)
 e  d
 . s ^zewd("config","outputRootPath",technology)=$$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)
 s ^zewd("config","RootURL",technology)=$$getSessionValue^%zewdAPI(technology_"RootURL",sessid)
 ;
 i technology="wl" d
 . s ^MGWAPP("ewdwl")="runPage^%zewdWLD"
 . d activateWebLink^%zewdAPI ; only here if someone uses the old interface!
 ;
 QUIT ""
 ;
configPrepage(sessid) ;
 ;
 n config,routinePath
 ;
 d clearList^%zewdAPI("frontEndTechnology",sessid)
 d appendToList^%zewdAPI("frontEndTechnology","GT.M / m_apache","gtm",sessid)
 ;
 d clearList^%zewdAPI("backEndTechnology",sessid)
 d appendToList^%zewdAPI("backEndTechnology","MUMPS","m",sessid)
 ;
 d clearList^%zewdAPI("persistenceDB",sessid)
 d appendToList^%zewdAPI("persistenceDB","GT.M","gtm",sessid)
 ;
 d clearList^%zewdAPI("format",sessid)
 d appendToList^%zewdAPI("format","Indented","pretty",sessid)
 d appendToList^%zewdAPI("format","Collapsed","collapse",sessid)
 ;
 d getConfigDetails^%zewdCompiler16(.config)
 d setSessionValue^%zewdAPI("frontEndTechnology","gtm",sessid)
 d setSessionValue^%zewdAPI("backEndTechnology","m",sessid)
 d setSessionValue^%zewdAPI("persistenceDB","gtm",sessid)
 d setSessionValue^%zewdAPI("format",$g(config("main","markupFormat")),sessid)
 d setSessionValue^%zewdAPI("appRootPath",$g(config("main","applicationRootPath")),sessid)
 ;
 s technology="gtm" d
 . d setSessionValue^%zewdAPI(technology_"OutputPath",$g(config("technology",technology,"outputRootPath")),sessid)
 . d setSessionValue^%zewdAPI(technology_"RootURL",$g(config("technology",technology,"RootURL")),sessid)
 . i technology'="wl",technology'="gtm",$g(config("technology",technology,"RootURL"))="" d
 . . d setSessionValue^%zewdAPI(technology_"RootURL","/"_technology,sessid)
 . d clearList^%zewdAPI(technology_"JsURLType",sessid)
 . d appendToList^%zewdAPI(technology_"JsURLType","Absolute","fixed",sessid)
 . d appendToList^%zewdAPI(technology_"JsURLType","Relative","relative",sessid)
 . d setSessionValue^%zewdAPI(technology_"JsURLType",$g(config("technology",technology,"jsScriptPath","mode")),sessid)
 . d setSessionValue^%zewdAPI(technology_"JsURLRoot",$g(config("technology",technology,"jsScriptPath","path")),sessid)
 ;
 ;
 s routinePath=$g(^zewd("config","routinePath","gtm"))
 i routinePath'="" d setSessionValue^%zewdAPI("gtmRoutinePath",routinePath,sessid)
 ;
 QUIT ""
 ;
configdbPrepage(sessid)
 ;
 n db
 ;
 i $$getSessionValue^%zewdAPI("frontEndTechnology",sessid)="csp" d setRedirect^%zewdAPI("goMainMenu",sessid) QUIT ""
 i $$getSessionValue^%zewdAPI("frontEndTechnology",sessid)="wl" d setRedirect^%zewdAPI("goMainMenu",sessid) QUIT ""
 i $$getSessionValue^%zewdAPI("frontEndTechnology",sessid)="gtm" d setRedirect^%zewdAPI("goMainMenu",sessid) QUIT ""
 s db=$$getSessionValue^%zewdAPI("persistenceDB",sessid)
 i db="cache" d setRedirect^%zewdAPI("cacheOnlyConfig",sessid)
 i db="gtm" d setRedirect^%zewdAPI("gtmOnlyConfig",sessid)
 i db="mysql" d setRedirect^%zewdAPI("mysqlOnlyConfig",sessid)
 ;
 QUIT ""
 ;
configgetDBData(sessid)
 ;
 n db
 ;
 s db=$g(^zewd("config","sessionDatabase"))
 i db="mysql" d  QUIT ""
 . d setSessionValue^%zewdAPI("mysqlHost",$g(^zewd("config","database",db,"host")),sessid)
 . d setSessionValue^%zewdAPI("mysqlUsername",$g(^zewd("config","database",db,"username")),sessid)
 . d setSessionValue^%zewdAPI("mysqlPassword",$g(^zewd("config","database",db,"password")),sessid)
 ;
 d setSessionValue^%zewdAPI(db_"MgwsiServer",$g(^zewd("config","database",db,"mgwsiServer")),sessid)
 ;
 d setSessionValue^%zewdAPI("databaseText",$$getTextFromList^%zewdAPI("persistenceDB",db,sessid),sessid)
 QUIT ""
 ;
savePHPConfig(sessid)
 QUIT $$saveTechnologyConfig("php",sessid)
 ;
saveCSPConfig(sessid)
 QUIT $$saveTechnologyConfig("csp",sessid)
 ;
saveWLConfig(sessid)
 QUIT $$saveTechnologyConfig("wl",sessid)
 ;
saveMapacheConfig(sessid)
 QUIT $$saveTechnologyConfig("gtm",sessid)
 ;
saveGtmConfig(sessid)
 QUIT $$saveDatabaseConfig("gtm",sessid)
 ;
saveTechnologyConfig(technology,sessid)
 ;
 n nodeOID,docName,error,ok
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
 ;
 i $$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)="" QUIT "You must enter the Output Root Path"
 i $$getSessionValue^%zewdAPI(technology_"RootURL",sessid)="" QUIT "You must enter the Root URL"
 ;
 s ^zewd("config","jsScriptPath",technology,"mode")=$$getSessionValue^%zewdAPI(technology_"JsURLType",sessid)
 s ^zewd("config","jsScriptPath",technology,"path")=$$getSessionValue^%zewdAPI(technology_"JsURLRoot",sessid)
 i technology="wl"!(technology="gtm") d
 . s ^zewd("config","jsScriptPath",technology,"outputPath")=$$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)
 e  d
 . s ^zewd("config","outputRootPath",technology)=$$getSessionValue^%zewdAPI(technology_"OutputPath",sessid)
 s ^zewd("config","RootURL",technology)=$$getSessionValue^%zewdAPI(technology_"RootURL",sessid)
 ;
 i technology="wl" d
 . s ^MGWAPP("ewdwl")="runPage^%zewdWLD"
 . d activateWebLink^%zewdAPI ; only here if someone uses the old interface!
 ;
 s error=""
 i technology="gtm" d
 . n routinePath
 . s routinePath=$$getSessionValue^%zewdAPI("gtmRoutinePath",sessid)
 . i routinePath="" s error="You must enter the Routine Path" q
 . s ^zewd("config","routinePath","gtm")=routinePath
 QUIT error
 ;
getDataTypeList(sessid)
 ;
 n dataTypeList,hasDataTypes,tag
 ;
 d deleteFromSession^%zewdAPI("dataTypeList",sessid)
 m dataTypeList=^%zewd("dataType")
 s hasDataTypes=0
 i $d(dataTypeList) s hasDataTypes=1
 ;
 d setSessionValue^%zewdAPI("hasDataTypes",hasDataTypes,sessid)
 d addToSession^%zewdAPI("dataTypeList",sessid)
 ;
 QUIT ""
 ;
getDataTypeDetails(sessid)
 ;
 n dtName,inputMethod,outputMethod,textArray
 ;
 s dtName=$$getRequestValue^%zewdAPI("dataType",sessid)
 d setSessionValue^%zewdAPI("dataType",dtName,sessid)
 ;
 s inputMethod=$$getInputMethod^%zewdCompiler(dtName)
 d addToSession^%zewdAPI("inputMethod",sessid)
 s outputMethod=$$getOutputMethod^%zewdCompiler(dtName)
 d addToSession^%zewdAPI("outputMethod",sessid)
 d clearTextArea^%zewdAPI("dataTypeNotes",sessid)
 m textArray=^%zewd("dataType",dtName,"dataTypeNotes")
 d mergeToTextArea^%zewdAPI("dataTypeNotes",.textArray,sessid)
 QUIT ""
 ;
saveDataType(sessid)
 ;
 n dtName,inputMethod,outputMethod,text
 ;
 s dtName=$$getSessionValue^%zewdAPI("dataType",sessid)
 s inputMethod=$$getSessionValue^%zewdAPI("inputMethod",sessid)
 s outputMethod=$$getSessionValue^%zewdAPI("outputMethod",sessid)
 s dtName=$$zcvt^%zewdAPI(dtName,"l")
 ;
 i inputMethod="" QUIT "You did not specify the input method for processing the "_dtName_" data type"
 i inputMethod'["^" QUIT "The input method name for processing the "_dtName_" data type is invalid"
 i outputMethod="" QUIT "You did not specify the output method for processing the "_dtName_" data type"
 i outputMethod'["^" QUIT "The output method name for processing the "_dtName_" data type is invalid"
 d mergeFromTextArea^%zewdAPI("dataTypeNotes",.text,sessid)
 s ^%zewd("dataType",dtName)=inputMethod_$c(1)_outputMethod
 m ^%zewd("dataType",dtName,"dataTypeNotes")=text
 QUIT ""
 ;
delDataType(sessid)
 ;
 n name
 ;
 s name=$$getRequestValue^%zewdAPI("dataType",sessid)
 k ^%zewd("dataType",name)
 QUIT ""
 ;
getDataTypeNotes(sessid)
 ;
 n tagName,textArray
 ;
 s tagName=$$getRequestValue^%zewdAPI("dataType",sessid)
 d setSessionValue^%zewdAPI("dataTypeName",tagName,sessid)
 ;
 d clearTextArea^%zewdAPI("dataTypeNotes",sessid)
 m textArray=^%zewd("dataType",tagName,"dataTypeNotes")
 i '$d(textArray) s textArray(1)="No documentation available"
 d mergeToTextArea^%zewdAPI("dataTypeNotes",.textArray,sessid)
 QUIT ""
 ;
initDataTypeDetails(sessid)
 d setSessionValue^%zewdAPI("newDataType",1,sessid)
 d deleteFromSession^%zewdAPI("dataType",sessid)
 d deleteFromSession^%zewdAPI("inputMethod",sessid)
 d deleteFromSession^%zewdAPI("outputMethod",sessid)
 d clearTextArea^%zewdAPI("dataTypeNotes",sessid)
 QUIT ""
 ;
getRestServiceList(sessid)
 ;
 n restServiceList,data,hasRestServices,newTagImpliedClose,applyTo,tag,type
 ;
 d deleteFromSession^%zewdAPI("restServiceList",sessid)
 m restServiceList=^%zewd("restMethod")
 ;
 s hasRestServices=0
 i $d(restServiceList) s hasRestServices=1
 d setSessionValue^%zewdAPI("hasRestServices",hasRestServices,sessid)
 d addToSession^%zewdAPI("restServiceList",sessid)
 ;
 QUIT ""
 ;
getRestServiceDetails(sessid)
 ;
 d setSessionValue^%zewdAPI("newRestService",0,sessid)
 s name=$$getRequestValue^%zewdAPI("restService",sessid)
 d setSessionValue^%zewdAPI("restService",name,sessid)
 s method=$g(^%zewd("restMethod",name))
 i method["(sessid)" s method=$p(method,"(sessid)",1)
 d setSessionValue^%zewdAPI("restServiceMethod",method,sessid)
 d clearTextArea^%zewdAPI("restServiceNotes",sessid)
 m textArray=^%zewd("restMethod",name,"notes")
 d mergeToTextArea^%zewdAPI("restServiceNotes",.textArray,sessid)
 ;
 QUIT ""
 ;
saveRestService(sessid)
 ;
 n isNew,tagName,tagMethod,tagImpliedClose,text,applyTo
 ;
 s isNew=$$getSessionValue^%zewdAPI("newRestService",sessid)
 s name=$$getSessionValue^%zewdAPI("restService",sessid)
 s restServiceMethod=$$getSessionValue^%zewdAPI("restServiceMethod",sessid)
 ;
 i isNew,name="" QUIT "You did not specify a REST Service name"
 i isNew,$d(^%zewd("restMethod",name)) QUIT "A REST Service with this name already exists"
 i restServiceMethod="" QUIT "You must specify a method"
 i restServiceMethod'="",restServiceMethod'["^",restServiceMethod'["##class" QUIT "The method name for processing the "_restService_" REST Service is invalid"
 i restServiceMethod["(sessid" s restServiceMethod=$p(restServiceMethod,"(sessid)",1)
 ;
 d mergeFromTextArea^%zewdAPI("restServiceNotes",.text,sessid)
 s ^%zewd("restMethod",name)=restServiceMethod
 m ^%zewd("restMethod",name,"notes")=text
 QUIT ""
 ;
getRestServiceNotes(sessid)
 ;
 n name,textArray
 ;
 s name=$$getRequestValue^%zewdAPI("restService",sessid)
 d setSessionValue^%zewdAPI("restService",name,sessid)
 ;
 d clearTextArea^%zewdAPI("notes",sessid)
 m textArray=^%zewd("restMethod",name,"notes")
 i '$d(textArray) s textArray(1)="No documentation available"
 d mergeToTextArea^%zewdAPI("notes",.textArray,sessid)
 QUIT ""
 ;
initNewRestServiceDetails(sessid)
 d setSessionValue^%zewdAPI("newRestService",1,sessid)
 d deleteFromSession^%zewdAPI("restService",sessid)
 d setSessionValue^%zewdAPI("restServiceMethod","##class(",sessid)
 d clearTextArea^%zewdAPI("restServiceNotes",sessid)
 QUIT ""
 ;
delRestService(sessid)
 ;
 n name
 ;
 s name=$$getRequestValue^%zewdAPI("restService",sessid)
 k ^%zewd("restMethod",name)
 QUIT ""
 ;
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
 n include,macro,tagName,tagMethod,tagImpliedClose,applyTo,text
 ;
 s tagName=$$getRequestValue^%zewdAPI("tagName",sessid)
 d setSessionValue^%zewdAPI("tagName",tagName,sessid)
 ;
 d setSessionValue^%zewdAPI("newCustomTag",0,sessid)
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
 d clearTextArea^%zewdAPI("tagNotes",sessid)
 m textArray=^%zewd("customTag",tagName,"tagNotes")
 d mergeToTextArea^%zewdAPI("tagNotes",.textArray,sessid)
 QUIT ""
 ;
getCustomTagNotes(sessid)
 ;
 n tagName,textArray
 ;
 s tagName=$$getRequestValue^%zewdAPI("tagName",sessid)
 d setSessionValue^%zewdAPI("tagName",tagName,sessid)
 ;
 d clearTextArea^%zewdAPI("tagNotes",sessid)
 m textArray=^%zewd("customTag",tagName,"tagNotes")
 i '$d(textArray) s textArray(1)="No documentation available"
 d mergeToTextArea^%zewdAPI("tagNotes",.textArray,sessid)
 QUIT ""
 ;
initNewCustomTagDetails(sessid)
 d setSessionValue^%zewdAPI("newCustomTag",1,sessid)
 d deleteFromSession^%zewdAPI("tagName",sessid)
 d setSessionValue^%zewdAPI("tagMethod","label^routine",sessid)
 d deleteFromSession^%zewdAPI("tagImpliedClose",sessid)
 d clearTextArea^%zewdAPI("tagNotes",sessid)
 d setSessionValue^%zewdAPI("tagImpliedClose",0,sessid)
 QUIT ""
 ;
saveCustomTag(sessid)
 ;
 n isNew,tagName,tagMethod,tagImpliedClose,text,applyTo
 ;
 s isNew=$$getSessionValue^%zewdAPI("newCustomTag",sessid)
 s tagName=$$getSessionValue^%zewdAPI("tagName",sessid)
 s tagMethod=$$getSessionValue^%zewdAPI("tagMethod",sessid)
 s tagImpliedClose=+$$getSessionValue^%zewdAPI("tagImpliedClose",sessid) 
 s tagAttrList="" ;
 s applyTo="ewd"
 s tagName=$$zcvt^%zewdAPI(tagName,"l")
 s tagName=$$stripSpaces^%zewdAPI(tagName)
 s tagMethod=$$stripSpaces^%zewdAPI(tagMethod)
 ;
 i isNew,tagName="" QUIT "You did not specify a tag name"
 i isNew,$d(^%zewd("customTag",tagName)) QUIT "A tag with this name already exists"
 i tagMethod="" QUIT "You must specify a method"
 i tagMethod="label^routine" QUIT "You must specify a method"
 i tagMethod'="",tagMethod'["^",tagMethod'["##class" QUIT "The method name for processing the "_tagName_" tag is invalid"
 ;
 d mergeFromTextArea^%zewdAPI("tagNotes",.text,sessid)
 s ^%zewd("customTag",tagName)=tagMethod_$c(1)_tagImpliedClose_$c(1,1,1)_$g(applyTo)
 m ^%zewd("customTag",tagName,"tagNotes")=text
 QUIT ""
 ;
delCustomTag(sessid)
 ;
 n tagName
 ;
 s tagName=$$getRequestValue^%zewdAPI("tagName",sessid)
 k ^%zewd("customTag",tagName)
 QUIT ""
 ;
getTagNotes(tagName)
 ;
 n line,text
 ;
 s text=""
 s line=0
 f  s line=$o(^%zewd("customTag",tagName,"tagNotes",line)) q:line=""  d
 . i text'="" s text=text_"<br>"
 . s text=text_^%zewd("customTag",tagName,"tagNotes",line)
 i text="" s text="text = 'Custom tag: "_tagName_"' ;" QUIT text
 s text="text = '"_text_"' ;"
 ;
 QUIT text
 ;
getCustomTagName(sessid)
 ;
 d copyRequestValueToSession^%zewdAPI("tagName",sessid)
 QUIT ""
 ;
 ;  Note: need GT.M equivalents of import and export custom tag!
 ;
 ;
getPageDetails(sessid)
 ;
 n appName,dlim,filepath,line,lineNo,pageListing,pageName,path
 ;
 s pageName=$$getRequestValue^%zewdAPI("pageName",sessid)
 i pageName="" d
 . s pageName=$$getSessionValue^%zewdAPI("pageName",sessid)
 e  d
 . d setSessionValue^%zewdAPI("pageName",pageName,sessid)
 s path=$$getSessionValue^%zewdAPI("appPath",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s dlim="\" i path["/" s dlim="/"
 i $e(path,$l(path))'=dlim s path=path_dlim_appName_dlim
 s filepath=path_pageName
 d extractFileToArray^%zewdHTMLParser(filepath,.pageListing)
 d clearTextArea^%zewdAPI("pageListing",sessid)
 s lineNo=""
 f  s lineNo=$o(pageListing(lineNo)) q:lineNo=""  d
 . s line=pageListing(lineNo)
 . s line=$$replaceAll^%zewdAPI(line,"<","&lt;")
 . s line=$$replaceAll^%zewdAPI(line,">","&gt;")
 . s pageListing(lineNo)=line
 d mergeToTextArea^%zewdAPI("pageListing",.pageListing,sessid)
 ;
 QUIT ""
 ;
getErrorList(sessid)
 ;
 n no,sessionList
 ;
 s no=""
 f  s no=$o(^%zewdError(no)) q:no=""  d
 . s sessionList(no)=""
 ;
 d deleteFromSession^%zewdAPI("sessionList",sessid)
 d mergeToSession^%zewdAPI("sessionList",sessid)
 ;
 QUIT ""
 ;
getErrorSessionDetails(sessid)
 ;
 n sessionNo,session,ref,data,%p1,line,errorText,system
 ;
 s sessionNo=$$getRequestValue^%zewdAPI("sessionNo",sessid)
 d setSessionValue^%zewdAPI("sessionNo",sessionNo,sessid)
 ;
 m session=^%zewdError(sessionNo,"session")
 d clearTextArea^%zewdAPI("sessionListing",sessid)
 s ref="session("""")"
 f  s ref=$q(@ref) q:ref=""  d
 . s data=@ref
 . s %p1=$p(ref,"session(",2)
 . s %p1=$e(%p1,1,$l(%p1)-1)
 . s line=%p1_" = "_data
 . d appendToTextArea^%zewdAPI("sessionListing",line,sessid)
 ;
 s errorText=$g(^%zewdError(sessionNo))
 d addToSession^%zewdAPI("errorText",sessid)
 s system="Cach&eacute;"
 i $zv["GT.M" s system="GT.M"
 d setSessionValue^%zewdAPI("systemType",system,sessid)
 ;
 QUIT ""
 ;
deleteError(sessionNo)
 k ^%zewdError(sessionNo)
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
 n end,j,session,sessionNo,lineNo,ref,data,%p1,line
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
 s end="^%work("
 s j=$j
 i $j'?1N.N s j=""""_$j_""""
 s end=end_j
 s lineNo=0
 f  s ref=$q(@ref) q:ref'[end  d
 . s data=@ref
 . s %p1=$p(ref,end_",",2)
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
  d deleteSession^%zewdAPI(sessionNo)
  QUIT ""
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
 i $$getSessionValue^%zewdAPI("mysqlHost",sessid)="" QUIT "You must enter the host name/IP address"
 i $$getSessionValue^%zewdAPI("mysqlUsername",sessid)="" QUIT "You must enter the mySQL username"
 i $$getSessionValue^%zewdAPI("mysqlPassword",sessid)="" QUIT "You must enter the mySQL password"
 s ^zewd("config","database","mysql","host")=$$getSessionValue^%zewdAPI("mysqlHost",sessid)
 s ^zewd("config","database","mysql","username")=$$getSessionValue^%zewdAPI("mysqlUsername",sessid)
 s ^zewd("config","database","mysql","password")=$$getSessionValue^%zewdAPI("mysqlPassword",sessid)
 ;
 QUIT ""
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
webTechRedirect(sessid)
 ;
 n fet
 ;
 s fet=$$getSessionValue^%zewdAPI("frontEndTechnology",sessid)
 i fet="php" d setRedirect^%zewdAPI("phpOnlyConfig",sessid)
 i fet="csp" d setRedirect^%zewdAPI("cspOnlyConfig",sessid)
 i fet="wl" d setRedirect^%zewdAPI("wlOnlyConfig",sessid)
 i fet="gtm" d setRedirect^%zewdAPI("gtmOnlyConfig",sessid)
 QUIT ""
 ;
restServerConfigPrepage(sessid)
 ;
 d clearList^%zewdAPI("subnet",sessid)
 s sn="",no=0
 f  s sn=$O(^%zewd("restAllowedIp",sn)) Q:sn=""  d
 . d appendToList^%zewdAPI("subnet",sn,sn,sessid)
 . s no=no+1
 d setSessionValue^%zewdAPI("noOfIPs",no,sessid)
 QUIT ""
 ;
addRestIP(sessid)
 ;
 n mess,newsubnet,len,%stop,i,Error,num
 ;
 s newSubnet=$$getSessionValue^%zewdAPI("newSubnet",sessid)
 s mess="Invalid domain name, IP address or address range"
 i newSubnet="" QUIT "You must enter an IP Address, domain name or address range"
 i $d(^%zewd("restAllowedIp",newSubnet)) QUIT "IP address or domain name already authorised"
 i newSubnet'["." QUIT mess
 ;s len=$l(newSubnet,"."),%stop=0
 ;i len>4 QUIT mess
 ;s Error=""
 ;f i=1:1:len d  q:%stop
 ;. s num=$p(newSubnet,".",i)
 ;. i num'?1N.N S Error=mess,%stop=1 q
 ;. i num=0 q
 ;. i num>0,num<255 q
 ;. S Error=mess,%stop=1 q
 s ^%zewd("restAllowedIp",newSubnet)=""
 ;
 QUIT ""
 ;
securityPrepage(sessid)
 n sn,user,no
 ;
 d clearList^%zewdAPI("subnet",sessid)
 s sn="",no=0
 f  s sn=$O(^%zewd("config","security","validSubnet",sn)) Q:sn=""  d
 . d appendToList^%zewdAPI("subnet",sn,sn,sessid)
 . s no=no+1
 d setSessionValue^%zewdAPI("noOfIPs",no,sessid)
 ;
 d clearList^%zewdAPI("user",sessid)
 s user="",no=0
 f  s user=$o(^%zewd("config","security","username",user)) q:user=""  d
 . d appendToList^%zewdAPI("user",user,user,sessid)
 . s no=no+1
 d setSessionValue^%zewdAPI("noOfUsers",no,sessid)
 QUIT ""
 ;
setApplication(appName)
 d setSessionValue^%zewdAPI("appName",appName,sessid)
 QUIT ""
 ;
addUser(sessid)
 ;
 n user
 ;
 s user=$$getSessionValue^%zewdAPI("newUser",sessid)
 i user="" QUIT "You did not enter a new username"
 i $g(^%zewd("config","security","username",user))'="" QUIT "There is already a user defined with that username"
 ;
 d setSessionValue^%zewdAPI("user",user,sessid)
 QUIT ""
 ;
userPrepage(sessid)
 ;
 n userType,userStatus,user,addUser,newUser,%d
 ;
 s user=$$getSessionValue^%zewdAPI("user",sessid)
 ;
 s userType(1)="Normal User~user"
 s userType(2)="Administrator~admin"
 d mergeToList^%zewdAPI("userType",.userType,sessid)
 k userType
 ;
 s userStatus(1)="Active User~active"
 s userStatus(2)="Disabled~disabled"
 d mergeToList^%zewdAPI("userStatus",.userStatus,sessid)
 k userStatus
 ;
 s %d=$g(^%zewd("config","security","username",user))
 s userType=$p(%d,$c(1),2)
 s userStatus=$p(%d,$c(1),3)
 ;
 i userType="" s userType="admin"
 i userStatus="" s userStatus="active"
 ;
 d addToSession^%zewdAPI("userType",sessid)
 d addToSession^%zewdAPI("userStatus",sessid)
 QUIT ""
 ;
userUpdate(sessid)
 ;
 n context,Error,user,newPass1,newPass2,userType,userStatus,%d,pass
 ;
 s user=$$getSessionValue^%zewdAPI("user",sessid)
 s newPass1=$$getSessionValue^%zewdAPI("newPass1",sessid) 
 s newPass2=$$getSessionValue^%zewdAPI("newPass2",sessid)
 s userType=$$getSessionValue^%zewdAPI("userType",sessid)
 s userStatus=$$getSessionValue^%zewdAPI("userStatus",sessid)
 i newPass1'="",newPass1'=newPass2 QUIT "Passwords do not match: please try again!"
 i '$d(^%zewd("config","security","username",user)),newPass1="" QUIT "You must specify a password for a new user"
 i '$d(^%zewd("config","security","username")),userType'="admin" QUIT "The first user you create must be an administrator"
 i '$d(^%zewd("config","security","username")),userStatus'="active" QUIT "The first user you create must be an active user"
 ;
 s %d=$g(^%zewd("config","security","username",user))
 s pass=$p(%d,$c(1),1)
 i pass="",newPass1="" QUIT "You must specify a password"
 s context=1
 i $d(^zewd("config","MGWSI")) s context=0
 i newPass1'="" s pass=$$SHA1^%ZMGWSIS(newPass1,1,context)
 s %d=pass_$c(1)_userType_$c(1)_userStatus
 s ^%zewd("config","security","username",user)=%d
 QUIT ""
 ;
deleteUser(sessid)
 ;
 n user
 ;
 s user=$$getSessionValue^%zewdAPI("user",sessid)
 k ^%zewd("config","security","username",user)
 QUIT ""
 ;
addIPAddress(sessid) ;
 ;
 n mess,newsubnet,len,%stop,i,Error,num
 ;
 s newSubnet=$$getSessionValue^%zewdAPI("newSubnet",sessid)
 s mess="Invalid subnet or IP address"
 i newSubnet="" QUIT "You must enter an IP Address or address range"
 i $d(^%zewd("config","security","validSubnet",newSubnet)) QUIT "IP address already authorised"
 i newSubnet'["." QUIT mess
 s len=$l(newSubnet,"."),%stop=0
 i len>4 QUIT mess
 s Error=""
 f i=1:1:len d  q:%stop
 . s num=$p(newSubnet,".",i)
 . i num'?1N.N S Error=mess,%stop=1 q
 . i num=0 q
 . i num>0,num<256 q
 . S Error=mess,%stop=1 q
 i %stop QUIT Error
 s ^%zewd("config","security","validSubnet",newSubnet)=""
 ;
 QUIT ""
 ;
deleteIPAddress(sessid) ;
 ;
 n subnet
 ;
 s subnet=$$getSessionValue^%zewdAPI("subnet",sessid)
 k ^%zewd("config","security","validSubnet",subnet)
 QUIT ""
 ;
getDOMMethods(sessid)
 ;
 n method
 ;
 d clearList^%zewdAPI("method",sessid)
 s method=""
 f  s method=$o(^%zewd("documentation","DOM","method",method)) q:method=""  d
 . d appendToList^%zewdAPI("method",method,method,sessid)
 ;
 QUIT ""
 ;
getDOMMethodDetails(sessid)
 ;
 n call,desc,mandatory,method,name,paramNo,params,purpose,returnValue
 ;
 s method=$$getSessionValue^%zewdAPI("method",sessid)
 s call=$g(^%zewd("documentation","DOM","method",method,"call"))
 s purpose=$g(^%zewd("documentation","DOM","method",method,"purpose"))
 s returnValue=$g(^%zewd("documentation","DOM","method",method,"returnValue"))
 i returnValue="" s returnValue="n/a"
 d setSessionValue^%zewdAPI("domCall",call,sessid)
 d setSessionValue^%zewdAPI("domPurpose",purpose,sessid)
 d setSessionValue^%zewdAPI("domReturn",returnValue,sessid)
 d deleteFromSession^%zewdAPI("domParams",sessid)
 s paramNo=""
 f  s paramNo=$o(^%zewd("documentation","DOM","method",method,"params",paramNo)) q:paramNo=""  d
 . s params("name")=$g(^%zewd("documentation","DOM","method",method,"params",paramNo,"name"))
 . s params("desc")=$g(^%zewd("documentation","DOM","method",method,"params",paramNo,"desc"))
 . s mandatory=$g(^%zewd("documentation","DOM","method",method,"params",paramNo,"mandatory"))
 . i mandatory s params("name")=params("name")_"*"
 . d mergeRecordArrayToResultSet^%zewdAPI("domParams",.params,sessid)
 d allowJSONAccess^%zewdAPI("domParams","r",sessid)
 ;
 QUIT ""
 ;
getParamNo(sessid)
 d copyRequestValueToSession^%zewdAPI("paramNo",sessid)
 QUIT ""
 ;
getDojoTags(sessid)
 ;
 n method
 ;
 d clearList^%zewdAPI("tag",sessid)
 s method=""
 f  s method=$o(^%zewd("documentation","dojo","tag",method)) q:method=""  d
 . d appendToList^%zewdAPI("tag",method,method,sessid)
 ;
 QUIT ""
 ;
getDojoTagDetails(sessid)
 ;
 n attr,attrs,call,desc,mandatory,method,name,purpose,widget
 ;
 ; attrs
 ; dojoWidget
 ; example
 ; notes
 ;
 s method=$$getSessionValue^%zewdAPI("tag",sessid)
 s call=$g(^%zewd("documentation","dojo","tag",method,"example"))
 s purpose=$g(^%zewd("documentation","dojo","tag",method,"notes"))
 s widget=$g(^%zewd("documentation","dojo","tag",method,"dojoWidget"))
 d setSessionValue^%zewdAPI("dojoExample",call,sessid)
 d setSessionValue^%zewdAPI("dojoNotes",purpose,sessid)
 d setSessionValue^%zewdAPI("dojoWidget",widget,sessid)
 d deleteFromSession^%zewdAPI("dojoAttrs",sessid)
 s attr=""
 f  s attr=$o(^%zewd("documentation","dojo","tag",method,"attrs",attr)) q:attr=""  d
 . s attrs("name")=attr
 . s attrs("desc")=^%zewd("documentation","dojo","tag",method,"attrs",attr)
 . d mergeRecordArrayToResultSet^%zewdAPI("dojoAttrs",.attrs,sessid)
 d allowJSONAccess^%zewdAPI("domParams","r",sessid)
 ;
 QUIT ""
 ;
getAPIMethods(sessid)
 ;
 QUIT ""
 ;
getTagList(sessid)
 ;
 QUIT ""
 ;
disableEwdMgr(sessid)
 d disableEwdMgr^%zewdAPI
 QUIT ""
 ;
getDaemonData(sessid)
 ;
 n activateDaemon,authType,count,hangTime,no,password,serverDomain,username
 ;
 s activateDaemon=$g(^%zewd("daemon","use"))
 i activateDaemon'="true" s activateDaemon="false"
 d setSessionValue^%zewdAPI("activateDaemon",activateDaemon,sessid)
 s hangTime=$g(^%zewd("daemon","hangTime"))
 i hangTime="" s hangTime=300
 d setSessionValue^%zewdAPI("hangTime",hangTime,sessid)
 d setSessionValue^%zewdAPI("daemonStatus",$$status^%zewdDaemon(),sessid)
 ;
 s serverDomain=$g(^%zewd("daemon","email","mailServer"))
 s authType=0
 i $g(^%zewd("daemon","email","authType"))="LOGIN PLAIN" s authType=1
 s username=$g(^%zewd("daemon","email","username"))
 s password=$g(^%zewd("daemon","email","password"))
 d setSessionValue^%zewdAPI("serverDomain",serverDomain,sessid)
 d setSessionValue^%zewdAPI("authType",authType,sessid)
 d setSessionValue^%zewdAPI("username",username,sessid)
 d setSessionValue^%zewdAPI("password",password,sessid)
 ;
 s no="",count=0
 f  s no=$o(^%zewd("emailQueue",no)) q:no=""  s count=count+1
 d setSessionValue^%zewdAPI("noOfEmails",count,sessid)
 QUIT ""
 ;
setDaemonData(sessid)
 n activateDaemon,hangTime
 s activateDaemon=$$getSessionValue^%zewdAPI("activateDaemon",sessid)
 s hangTime=$$getSessionValue^%zewdAPI("hangTime",sessid)
 i +hangTime="" s hangTime=300
 s ^%zewd("daemon","use")=activateDaemon
 s ^%zewd("daemon","hangTime")=hangTime
 QUIT ""
 ;
setEmailDaemonData(sessid)
 ;
 n authType,error,serverDomain,password,username
 ;
 s error=""
 s serverDomain=$$getSessionValue^%zewdAPI("serverDomain",sessid)
 i serverDomain="" QUIT "You must enter a server domain name or IP address"
 s authType=""
 i $$getSessionValue^%zewdAPI("authType",sessid)=1 s authType="LOGIN PLAIN"
 i authType="LOGIN PLAIN" d
 . s username=$$getSessionValue^%zewdAPI("username",sessid)
 . i username="" s error="You must enter a username" q
 . s password=$$getSessionValue^%zewdAPI("password",sessid)
 . i password="" s error="You must enter a password" q
 i error'="" QUIT error
 k ^%zewd("daemon","email")
 s ^%zewd("daemon","email","mailServer")=serverDomain
 s ^%zewd("daemon","email","authType")=authType
 i authType="LOGIN PLAIN" d
 . s ^%zewd("daemon","email","username")=username
 . s ^%zewd("daemon","email","password")=password
 QUIT ""
