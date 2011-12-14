%zewdMgr	; Enterprise Web Developer Manager Functions
 ;
 ; Product: Enterprise Web Developer (Build 894)
 ; Build Date: Wed, 14 Dec 2011 08:43:22
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
about(sessid)
 ;
 d clearSession(sessid)
 d setSessionValue^%zewdAPI("ewd_version",$$version^%zewdAPI(),sessid)
 d setSessionValue^%zewdAPI("ewd_date",$$date^%zewdAPI(),sessid)
 QUIT ""
 ;
grey()
 n username,userType
 ;
 i $g(sessid)="" QUIT 1
 ;
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 i $d(^%zewd("config","security","username")) D  QUIT userType'="admin"
 . ; username should be set, because he/she will have been forced to log in
 . i $g(username)="" s userType="admin" q  ; first time a user has been defined this is needed!
 . n %d
 . s %d=$g(^%zewd("config","security","username",username))
 . s userType=$P(%d,$C(1),2)
 ;
 ; if no usernames have been set up, then everyone has access to admin functions, 
 ; because access must be restricted to local host or nominated subnets/IP addresses
 ; 
 QUIT 0
 ;
fdGrey()
 ;
 i $g(^%zewd("special","formDesigner"))=1 QUIT 0
 QUIT 1
 ;
clearSession(sessid)
 ;
 d deleteFromSession^%zewdAPI("task",sessid)
 d deleteFromSession^%zewdAPI("appList",sessid)
 d deleteFromSession^%zewdAPI("fileList",sessid)
 d deleteFromSession^%zewdAPI("fileAttrs",sessid)
 d deleteFromSession^%zewdAPI("customTagList",sessid)
 d deleteFromSession^%zewdAPI("dataTypeList",sessid)
 d deleteFromSession^%zewdAPI("sessionList",sessid)
 d deleteFromSession^%zewdAPI("errorList",sessid)
 d clearList^%zewdAPI("interval",sessid)
 d clearList^%zewdAPI("tasknamespace",sessid)
 d clearList^%zewdAPI("appName",sessid)
 d clearList^%zewdAPI("user",sessid)
 d clearList^%zewdAPI("subnet",sessid)
 d clearList^%zewdAPI("days",sessid)
 d clearList^%zewdAPI("daysOfMonth",sessid)
 d clearList^%zewdAPI("daysOfWeek",sessid)
 d clearList^%zewdAPI("hour",sessid)
 d clearList^%zewdAPI("min",sessid)
 d clearList^%zewdAPI("months",sessid)
 d clearList^%zewdAPI("weeks",sessid)
 d clearTextArea^%zewdAPI("sessionListing",sessid)
 d clearSessionByPrefix^%zewdAPI("task",sessid)
 ;
 QUIT
 ;
resetSecurity(mode)
 ;
 i $g(mode)="" s mode="all"
 s mode=$$zcvt^%zewdAPI(mode,"l")
 i mode="users"!(mode="all") k ^%zewd("config","security","username")
 i mode="ip"!(mode="all") k ^%zewd("config","security","validSubnet")
 QUIT
 ;
login(sessid)
 ;
 n username,password,mess,%d,userPassword,userStatus,userType,loginErrors,Error
 ;
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 s password=$$getSessionValue^%zewdAPI("password",sessid)
 ;
 S mess="Invalid login attempt"
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
 I $$enc^%zewdEnc(password)'=userPassword D  QUIT Error
 . n maxLoginErrors
 . S Error=mess
 . s loginErrors=$G(loginErrors)+1
 . s $p(^%zewd("config","security","username",username),$c(1),4)=loginErrors
 . s maxLoginErrors=$G(^%zewd("config","security","maxLoginErrors"))
 . i maxLoginErrors="" S maxLoginErrors=5
 . i loginErrors'<maxLoginErrors s $p(^%zewd("config","security","username",username),$c(1),3)="disabled"
 . QUIT
 s $p(^%zewd("config","security","username",username),$c(1),4)=0
 QUIT ""  ; successful login
 ;
 ;
firstPrepage(sessid)
 ;
 i $g(^%zewd("disabled"))=1 d setJump^%zewdAPI("invalidaccess",sessid) QUIT ""
 i '$$validSubnet(sessid) d setJump^%zewdAPI("invalidaccess",sessid) QUIT ""  ; default is only accessible from localhost
 i $$passwordProtected() d setJump^%zewdAPI("login",sessid) QUIT ""  ; default is not password protected
 ;
 ;d setJump^%zewdAPI("compileSelect",sessid)
 d setJump^%zewdAPI("schemaselector",sessid)
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
adminPermission(username) ;
 ;
 n userType
 ;
 ; returns true if user has admin access rights. 
 ; 
 i $d(^%zewd("config","security","username")) D  QUIT "admin"
 . ; username should be set, because he/she will have been forced to log in
 . i $g(username)="" s userType="admin" q  ; first time a user has been defined this is needed!
 . n %d
 . s %d=^%zewd("config","security","username",username)
 . s userType=$P(%d,$c(1),2)
 ;
 ; if no usernames have been set up, then everyone has access to admin functions, 
 ; because access must be restricted to local host or nominated subnets/IP addresses
 ; 
 QUIT userType
 ;
securityPrepage(sessid)
 ;
 n sn,user
 ;
 d clearSession(sessid)
 d clearList^%zewdAPI("subnet",sessid)
 s sn=""
 f  s sn=$O(^%zewd("config","security","validSubnet",sn)) Q:sn=""  d
 . d appendToList^%zewdAPI("subnet",sn,sn,sessid)
 ;
 d clearList^%zewdAPI("user",sessid)
 s user=""
 f  s user=$o(^%zewd("config","security","username",user)) q:user=""  d
 . d appendToList^%zewdAPI("user",user,user,sessid)
 QUIT ""
deleteIPAddress(sessid) ;
 ;
 n subnet
 ;
 i '$$isListDefined^%zewdAPI("subnet",sessid) QUIT "No IP Addresses defined"
 s subnet=$$getSessionValue^%zewdAPI("subnet",sessid)
 k ^%zewd("config","security","validSubnet",subnet)
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
 . i num>0,num<255 q
 . S Error=mess,%stop=1 q
 i %stop QUIT Error
 s ^%zewd("config","security","validSubnet",newSubnet)=""
 s ^%eXtc("system","security","validSubnet",newSubnet)=""
 ;
 QUIT ""
 ;
addValidIPAddress(ipAddress)
 ;
 QUIT:$g(ipAddress)=""
 s ^%zewd("config","security","validSubnet",ipAddress)=""
 s ^%eXtc("system","security","validSubnet",ipAddress)=""
 QUIT
 ;
 ;
selectUser(sessid)
 i '$$isListDefined^%zewdAPI("user",sessid) QUIT "No users defined"
 QUIT ""
 ;
addUser(sessid)
 ;
 n user
 ;
 s user=$$getSessionValue^%zewdAPI("newUser",sessid)
 i user="" QUIT "You must enter a user name"
 d addToSession^%zewdAPI("user",sessid)
 QUIT ""
 ;
userPrepage(sessid)
 ;
 n userType,userStatus,user,addUser,newUser,%d
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
 s userType=$p(%d,$C(1),2)
 s userStatus=$p(%d,$C(1),3)
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
 n Error,user,newPass1,newPass2,userType,userStatus,%d,pass
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
 s %d=$G(^%zewd("config","security","username",user))
 s pass=$P(%d,$c(1),1)
 i pass="",newPass1="" QUIT "You must specify a password"
 i newPass1'="" s pass=$$enc^%zewdEnc(newPass1)
 s %d=pass_$C(1)_userType_$C(1)_userStatus
 s ^%zewd("config","security","username",user)=%d
 QUIT ""
 ;
addAdministrator(username,password)
 ;
 QUIT:username=""
 QUIT:password=""
 s password=$$enc^%zewdEnc(password)
 s ^%zewd("config","security","username",username)=password_$c(1)_"admin"_$c(1)_"active"
 QUIT
 ;
deleteUser(sessid)
 ;
 n user
 ;
 i '$$isListDefined^%zewdAPI("user",sessid) QUIT "No users defined"
 s user=$$getSessionValue^%zewdAPI("user",sessid)
 k ^%zewd("config","security","username",user)
 QUIT ""
 ;
compileSelectPrepage(sessid)
 ;
 n appPath,dirs,os,dlim,dir,appList,n,tech,multilingual,path,escPath,format,outputPath
 n technology
 ;
 d clearSession(sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 ;
 ;s appPath=$g(^%zewd("config","applicationRootPath"))
 s appPath=$$getApplicationRootPath^%zewdAPI()
 i os="windows",appPath="" s appPath="\inetpub\wwwroot\php"
 i os="unix",appPath="" s appPath="/usr/ewd"
 ;
 i $e(appPath,$l(appPath))=dlim s appPath=$e(appPath,1,$l(appPath)-1)
 ;
 d getDirectoriesInPath^%zewdHTMLParser(appPath,.dirs)
 s dir="",n=""
 f  s dir=$o(dirs(dir)) q:dir=""  d
 . s n=n+1
 . s path=appPath_dlim_dir
 . s escPath=$tr(path,"\","/")
 . ;s escPath=$tr(path,"\",$c(1))
 . ;s escPath=$$replaceAll^%mgwHTMLParser(escPath,$c(1),"\\")
 . s appList(n)=path_$c(1)_escPath_$c(1)_dir
 ;
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 i technology="vb.net" d setSessionValue^%zewdAPI("a",1,sessid)
 d deleteFromSession^%zewdAPI("appList",sessid)
 d addToSession^%zewdAPI("appList",sessid)
 ;
 s format=$$getDefaultFormat^%zewdCompiler()
 d setSessionValue^%zewdAPI("format",format,sessid)
 d setSessionValue^%zewdAPI("xformat",format,sessid)
 ;
 s tech=$$getDefaultTechnology^%zewdCompiler()
 d setSessionValue^%zewdAPI("tech",tech,sessid)
 d setSessionValue^%zewdAPI("technology",tech,sessid)
 ;
 ;s multilingual=+$$getSessionValue^%zewdAPI("multiling",sessid)
 s multilingual=$$getDefaultMultiLingual^%zewdCompiler()
 d setSessionValue^%zewdAPI("multiling",multilingual,sessid)
 d setSessionValue^%zewdAPI("multilingual",multilingual,sessid)
 ;
 s outputPath=$$getOutputRootPath^%zewdCompiler(tech)
 d setSessionValue^%zewdAPI("outputPath",outputPath,sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler("php")
 d setSessionValue^%zewdAPI("outputPathPHP",outputPath,sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler("csp")
 d setSessionValue^%zewdAPI("outputPathCSP",outputPath,sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler("jsp")
 d setSessionValue^%zewdAPI("outputPathJSP",outputPath,sessid)
 ;
 d setSessionValue^%zewdAPI("customTech","",sessid)
 d setSessionValue^%zewdAPI("customTechName","",sessid)
 d setSessionValue^%zewdAPI("customTechAbbr","",sessid)
 i $g(^%zewd("config","customTechnology"))'="" d
 . n custAbbr,custName,d
 . s d=^%zewd("config","customTechnology")
 . s custName=$p(d,"|",1)
 . s custAbbr=$p(d,"|",2)
 . d setSessionValue^%zewdAPI("customTechName",custName,sessid)
 . d setSessionValue^%zewdAPI("customTechAbbr",custAbbr,sessid)
 ;
 QUIT ""
 ;
compileAll(sessid)
 ;
 n path,compilerListing,outputPath,ok,results,outputStyle,os,dlim,technology,app
 n escResults,multilingual,n,rpath,io,error
 ;
 s io=$io
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 i dlim="\" s path=$tr(path,"/",dlim)
 s app=$p($re(path),dlim,1)
 i app="" s app=$p($re(path),dlim,2)
 s app=$re(app)
 k ^%zewdIndex($$zcvt^%zewdAPI(app,"l"))
 s outputStyle=$$getSessionValue^%zewdAPI("format",sessid)
 s technology=$$getSessionValue^%zewdAPI("technology",sessid)
 s outputPath=$$getSessionValue^%zewdAPI("outputPath",sessid)
 ;
 i outputPath[(dlim_dlim) d
 . s outputPath=$$replaceAll^%zewdAPI(outputPath,(dlim_dlim),dlim)
 . ;d TRACE^%wld("outputPath fixed as "_outputPath)
 ;
 i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s outputPath=outputPath_app
 s multilingual=$$getSessionValue^%zewdAPI("multilingual",sessid)
 i technology="wl"!(technology="gtm")!(technology="ewd") s outputPath=path
 s error=$$processApplication^%zewdCompiler(path,outputPath,2,outputStyle,.results,technology,,multilingual)
 i error'="" QUIT error
 s n=""
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
compileFilePath(sessid)
 ;
 n filepath,outputStyle,outputPath,results,mess,page,path,os,dlim,technology
 ;
 s filepath=$$getSessionValue^%zewdAPI("page",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 i dlim="\" s filepath=$tr(filepath,"/",dlim)
 ;
 s outputStyle=$$getSessionValue^%zewdAPI("format",sessid)
 s technology=$$getSessionValue^%zewdAPI("technology",sessid)
 s outputPath=$$getSessionValue^%zewdAPI("outputPath",sessid)
 ;
 d processOneFile^%zewdCompiler(filepath,outputPath,2,outputStyle,technology)
 d deleteFromSession^%zewdAPI("compilerListing",sessid)
 d mergeArrayToSession^%zewdAPI(.results,"compilerListing",sessid)
 s mess=$g(results(1))
 s mess=$tr(mess,"\","/")
 i mess'="" d setWarning^%zewdAPI(mess_" compiled",sessid)
 QUIT ""
 ;
runApp(sessid)
 ;
 n appName,dlim,fileList,fileName,pageList,pageName,path,technology,url
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s technology=$$getSessionValue^%zewdAPI("technology",sessid)
 d setSessionValue^%zewdAPI("technologyUC",$$zcvt^%zewdAPI(technology,"u"),sessid)
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s url=$$getRootURL^%zewdCompiler(technology)
 s dlim="/"
 s url=url_dlim_appName_dlim
 d setSessionValue^%zewdAPI("url",url,sessid)
 d getFilesInPath^%zewdHTMLParser(path,"ewd",.fileList)
 ;k ^rltList m ^rltList=fileList
 d clearList^%zewdAPI("pageList",sessid)
 s fileName=""
 f  s fileName=$o(fileList(fileName)) q:fileName=""  d
 . s pageName=$p(fileName,".ewd",1)
 . s pageList(pageName)=""
 . d appendToList^%zewdAPI("pageList",pageName,pageName,sessid)
 . 
 QUIT ""
 ;
compilePage(sessid) ;
 ;
 n filepath,line,lineNo,outputStyle,outputPath,results,mess,page,path,dlim
 n io,os,multilingual,technology,error
 ;
 s io=$io
 s page=$$getSessionValue^%zewdAPI("sourcePage",sessid)
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 i dlim="\" s path=$tr(path,"/",dlim)
 i $e(path,$l(path))'=dlim s path=path_dlim
 s filepath=path_page
 ;
 s outputStyle=$$getSessionValue^%zewdAPI("format",sessid)
 s technology=$$getSessionValue^%zewdAPI("technology",sessid)
 s outputPath=$$getSessionValue^%zewdAPI("outputPath",sessid)
 s multilingual=$$getSessionValue^%zewdAPI("multilingual",sessid)
 ;
 i technology="wl"!(technology="gtm")!(technology="ewd") s outputPath=path
 s error=$$processOneFile^%zewdCompiler(filepath,outputPath,2,outputStyle,technology,multilingual)
 i error'="" QUIT error
 d deleteFromSession^%zewdAPI("compilerListing",sessid)
 ;d mergeArrayToSession^%zewdAPI(.results,"compilerListing",sessid)
 u io
 s lineNo="",error=""
 f  s lineNo=$o(results(lineNo)) q:lineNo=""  d  q:error'=""
 . s line=results(lineNo)
 . i line["Error :" s error=line
 QUIT error
 ;
compileFileList(sessid)
 ;
 n filepath,outputStyle,outputPath,results,mess,page,path,dlim,os,multilingual,technology
 n pageList,error
 ;
 s outputStyle=$$getSessionValue^%zewdAPI("format",sessid)
 s technology=$$getSessionValue^%zewdAPI("technology",sessid)
 s outputPath=$$getSessionValue^%zewdAPI("outputPath",sessid)
 s multilingual=$$getSessionValue^%zewdAPI("multilingual",sessid)
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 i dlim="\" s path=$tr(path,"/",dlim)
 i $e(path,$l(path))'=dlim s path=path_dlim
 i technology="wl"!(technology="gtm")!(technology="ewd") s outputPath=path
 s page=""
 d mergeArrayFromSession^%zewdAPI(.pageList,"fileList",sessid)
 s page="",error=""
 f  s page=$o(pageList(page)) q:page=""  d  q:error'=""
 . s filepath=path_page
 . s error=$$processOneFile^%zewdCompiler(filepath,outputPath,2,outputStyle,technology,multilingual)
 QUIT error
 ;
getPageList(sessid)
 ;
 n app,compInfo,dcreate,dirList,dlim,dmod,escPath,file,fileAttrs
 n fileList,files,format,fpath,fromPage
 n info,io,multilingual,ok,os,outputPath,path
 n size,subDirPath,subpath,tech,upToParent,username
 ;
 s io=$io
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 d clearSelected^%zewdAPI("pageFilter",sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" d
 . s dlim="\"
 . s path=$tr(path,"/","\")
 ;
 s upToParent=$$getSessionValue^%zewdAPI("upToParent",sessid)
 s subpath=$$getSessionValue^%zewdAPI("subpath",sessid)
 s fromPage=$$getSessionValue^%zewdAPI("fromPage",sessid)
 ;s multilingual=+$$getSessionValue^%zewdAPI("multilingual",sessid)
 s multilingual=$$getDefaultMultiLingual^%zewdCompiler()
 d setSessionValue^%zewdAPI("multiling",multilingual,sessid)
 d setSessionValue^%zewdAPI("multilingual",multilingual,sessid)
 ;
 i fromPage="compileSelect",subpath="",upToParent="" d
 . n app
 . ; top level page entry
 . d setSessionValue^%zewdAPI("rootPath",path,sessid)
 . d deleteFromSession^%zewdAPI("subDirPath",sessid)
 . d deleteFromSession^%zewdAPI("parentExists",sessid)
 . s app=$p($re(path),dlim,1)
 . i app="" s app=$p($re(path),dlim,2)
 . s app=$re(app)
 . d addToSession^%zewdAPI("app",sessid)
 ;
 i upToParent=1 d
 . n np,rootPath
 . d deleteFromSession^%zewdAPI("upToParent",sessid)
 . s rootPath=$$getSessionValue^%zewdAPI("rootPath",sessid)
 . i $e(rootPath,$l(rootPath))=dlim s rootPath=$e(rootPath,1,$l(rootPath)-1)
 . i path'=rootPath d
 . . n subDirPath
 . . s subDirPath=$$getSessionValue^%zewdAPI("subDirPath",sessid)
 . . s np=$l(subDirPath,dlim)
 . . s subDirPath=$p(subDirPath,dlim,1,np-1)
 . . d addToSession^%zewdAPI("subDirPath",sessid)
 . . s path=rootPath_subDirPath
 . . d addToSession^%zewdAPI("path",sessid)
 . i path=rootPath d
 . . d deleteFromSession^%zewdAPI("subDirPath",sessid)
 . . d deleteFromSession^%zewdAPI("parentExists",sessid)
 ;
 i subpath'="" d
 . n rootPath,subDirPath
 . d deleteFromSession^%zewdAPI("subpath",sessid)
 . s rootPath=$$getSessionValue^%zewdAPI("rootPath",sessid)
 . i $e(rootPath,$l(rootPath))=dlim s rootPath=$e(rootPath,1,$l(rootPath)-1)
 . s subDirPath=$$getSessionValue^%zewdAPI("subDirPath",sessid)
 . s path=rootPath_subDirPath_dlim_subpath
 . s subDirPath=subDirPath_dlim_subpath
 . d addToSession^%zewdAPI("subDirPath",sessid)
 . d addToSession^%zewdAPI("path",sessid)
 . d setSessionValue^%zewdAPI("parentExists",1,sessid)
 ;
 s format=$$getDefaultFormat^%zewdCompiler()
 d setSessionValue^%zewdAPI("format",format,sessid)
 ;
 s tech=$$getDefaultTechnology^%zewdCompiler()
 d setSessionValue^%zewdAPI("tech",tech,sessid)
 d setSessionValue^%zewdAPI("technology",tech,sessid)
 ;
 s app=$$getSessionValue^%zewdAPI("app",sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler(tech)
 s subDirPath=$$getSessionValue^%zewdAPI("subDirPath",sessid)
 i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s outputPath=outputPath_app_subDirPath
 d setSessionValue^%zewdAPI("outputPath",outputPath,sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler("php")
 i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s outputPath=outputPath_app_subDirPath
 s outputPath("php")=outputPath
 d setSessionValue^%zewdAPI("outputPathPHP",outputPath,sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler("csp")
 i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s outputPath=outputPath_app_subDirPath
 s outputPath("csp")=outputPath
 d setSessionValue^%zewdAPI("outputPathCSP",outputPath,sessid)
 s outputPath=$$getOutputRootPath^%zewdCompiler("jsp")
 i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s outputPath=outputPath_app_subDirPath
 s outputPath("jsp")=outputPath
 d setSessionValue^%zewdAPI("outputPathJSP",outputPath,sessid)
 ;
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 i username="" s username="unknownUser"
 d getFileInfo^%zewdGTM(path,".ewd",.fileList)
 d getFileInfo^%zewdGTM(outputPath(tech),tech,.compInfo)
 k fileList("ewdTemplate.ewd")
 s fpath=$tr(path,"\","/")
 d setSessionValue^%zewdAPI("pageFiltering",0,sessid)
 i $d(^zewd("pageFilter",username,fpath)) d
 . d setSessionValue^%zewdAPI("pageFiltering",1,sessid)
 . s file=""
 . f  s file=$o(fileList(file)) q:file=""  d
 . . s lcfile=$$zcvt^%zewdAPI(file,"l")
 . . i '$d(^zewd("pageFilter",username,fpath,lcfile)) k fileList(file)
 d deleteFromSession^%zewdAPI("fileList",sessid)
 d addToSession^%zewdAPI("fileList",sessid)
 ;
 d deleteFromSession^%zewdAPI("file",sessid)
 s file=""
 ;s n=0
 f  s file=$o(fileList(file)) q:file=""  d
 . ;s n=n+1 i n>63 q
 . q:$$zcvt^%zewdAPI(file,"l")="ewdtemplate.ewd"
 . i $d(^zewd("pageFilter",username,fpath)),'$d(^zewd("pageFilter",username,fpath,$$zcvt^%zewdAPI(file,"l"))) q
 . s fpath=$p(file,".ewd",1)
 . s fpath=fpath_"."_tech
 . s size=$p(compInfo(fpath),$c(1),3)
 . s dmod=$p(compInfo(fpath),$c(1),1)_" "_$p(compInfo(fpath),$c(1),2)
 . i size<0!(size="") d
 . . s size="n/a"
 . . s dcreate="n/a"
 . . s dmod="n/a"
 . e  d
 . s fileAttrs("name")=file
 . s fileAttrs("size")=size
 . s fileAttrs("dateModified")=dmod
 . ;s fileAttrs(file)=size_$c(1)_dmod
 . d mergeRecordArrayToResultSet^%zewdAPI("file",.fileAttrs,sessid)
 . ;d addToSession^%zewdAPI("fileAttrs",sessid)
 ;
 d getDirectoriesInPath^%zewdHTMLParser(path,.dirList)
 d deleteFromSession^%zewdAPI("dirList",sessid)
 d addToSession^%zewdAPI("dirList",sessid)
 ;
 u io
 QUIT ""
 ;
getPageListing(sessid)
 ;
 n page,path,dlim,filepath,pageListing
 ;
 s page=$$getSessionValue^%zewdAPI("sourcePage",sessid)
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s dlim="\" i path["/" s dlim="/"
 i $e(path,$l(path))'=dlim s path=path_dlim
 s filepath=path_page
 d extractFileToArray^%zewdHTMLParser(filepath,.pageListing)
 d clearTextArea^%zewdAPI("pageListing",sessid)
 d mergeToTextArea^%zewdAPI("pageListing",.pageListing,sessid)
 ;
 QUIT ""
 ;
getSessionList(sessid)
 ;
 n no,sessionList
 ;
 d clearSession(sessid)
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
 QUIT ""
 ;
displaySessionDetails(sessid)
 d displaySessionDetails^%zewdMgr3($g(sessid))
 QUIT
 ;
deleteSession(sessid)
 ;
 n sessionNo
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("sessionNo",sessid)
 d deleteSession^%zewdAPI(sessionNo)
 d setWarning^%zewdAPI("session "_sessionNo_" has been deleted",sessid)
 ;
 QUIT ""
 ;
getErrorList(sessid)
 ;
 n no,errorList,error
 ;
 d clearSession(sessid)
 s no=""
 f  s no=$o(^%zewdError(no)) q:no=""  d
 . s error=$g(^%zewdError(no))
 . s errorList(no)=error
 ;
 d deleteFromSession^%zewdAPI("errorList",sessid)
 d mergeToSession^%zewdAPI("errorList",sessid)
 ;
 QUIT ""
 ;
displayError(sessid)
 ;
 n sessionNo
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("sessionNo",sessid)
 d recoverSymbolTable^%zewdAPI(sessionNo,0)
 QUIT
 ;
getErrorSessionDetails(sessid)
 ;
 n sessionNo,session,ref,data,%p1,line,errorText
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("sessionNo",sessid)
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
 ;
 QUIT ""
 ;
deleteError(sessid)
 ;
 n sessionNo
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("sessionNo",sessid)
 k ^%zewdError(sessionNo)
 d setWarning^%zewdAPI("The error log for session "_sessionNo_" has been deleted",sessid)
 ;
 QUIT "" 
 ;
deleteAllErrors(sessid)
 ;
 n sessionNo
 ;
 k ^%zewdError
 d setWarning^%zewdAPI("The error log has been cleared down",sessid)
 ;
 QUIT "" 
 ;
setHomePage(sessid)
 ;
 n homePage
 ;
 s homePage=$$getHomePage^%zewdCompiler()
 i homePage'="" d setSessionValue^%zewdAPI("ewd_homePage",homePage,sessid)
 QUIT ""
 ;
getConfigTechnology(sessid)
 ;
 n configTechnology
 ;
 s configTechnology=$$getSessionValue^%zewdAPI("configTechnology",sessid)
 i configTechnology="csp" d setRedirect^%zewdAPI("cspConfig",sessid)
 i configTechnology="php" d setRedirect^%zewdAPI("phpConfig",sessid)
 i configTechnology="jsp" d setRedirect^%zewdAPI("jspConfig",sessid)
 QUIT ""
 ;
getCSPConfig(sessid)
 n jsScriptsPathMode,jsScriptsRootPath,outputPathCSP,rootURLCSP
 ;
 s outputPathCSP=$$getOutputRootPath^%zewdCompiler("csp")
 s rootURLCSP=$$getRootURL^%zewdCompiler("csp")
 d addToSession^%zewdAPI("outputPathCSP",sessid)
 d addToSession^%zewdAPI("rootURLCSP",sessid)
 s jsScriptsPathMode=$$getJSScriptsPathMode^%zewdAPI("csp")
 i jsScriptsPathMode="" s jsScriptsPathMode="fixed"
 d addToSession^%zewdAPI("jsScriptsPathMode",sessid)
 s jsScriptsRootPath=$$getJSScriptsRootPath^%zewdAPI("csp")
 d addToSession^%zewdAPI("jsScriptsRootPath",sessid)
 QUIT ""
 ;
getPHPConfig(sessid)
 n jsScriptsPathMode,jsScriptsRootPath,outputPathPHP,rootURLPHP
 ;
 s outputPathPHP=$$getOutputRootPath^%zewdCompiler("php")
 d addToSession^%zewdAPI("outputPathPHP",sessid)
 s rootURLPHP=$$getRootURL^%zewdCompiler("php")
 d addToSession^%zewdAPI("rootURLPHP",sessid)
 s jsScriptsPathMode=$$getJSScriptsPathMode^%zewdAPI("php")
 i jsScriptsPathMode="" s jsScriptsPathMode="fixed"
 d addToSession^%zewdAPI("jsScriptsPathMode",sessid)
 s jsScriptsRootPath=$$getJSScriptsRootPath^%zewdAPI("php")
 d addToSession^%zewdAPI("jsScriptsRootPath",sessid)
 QUIT ""
 ;
getJSPConfig(sessid)
 n jsScriptsPathMode,jsScriptsRootPath,outputPathJSP,rootURLJSP
 ;
 s outputPathJSP=$$getOutputRootPath^%zewdCompiler("jsp")
 d addToSession^%zewdAPI("outputPathJSP",sessid)
 s rootURLJSP=$$getRootURL^%zewdCompiler("jsp")
 d addToSession^%zewdAPI("rootURLJSP",sessid)
 s jsScriptsPathMode=$$getJSScriptsPathMode^%zewdAPI("jsp")
 i jsScriptsPathMode="" s jsScriptsPathMode="fixed"
 d addToSession^%zewdAPI("jsScriptsPathMode",sessid)
 s jsScriptsRootPath=$$getJSScriptsRootPath^%zewdAPI("jsp")
 d addToSession^%zewdAPI("jsScriptsRootPath",sessid)
 QUIT ""
 ;
saveConfig(sessid)
 ;
 n configTechnology,cspURL,defFormat,defTech,error,homePage
 n jsScriptsPathMode,jsScriptsRootPath,jspURL
 n multiLingual,path,phpURL,rootPath,traceMode,useRootURL
 ;
 s traceMode=$$getSessionValue^%zewdAPI("traceMode",sessid)
 d traceModeOff^%zewdAPI
 i traceMode=1 d traceModeOn^%zewdAPI
 ;
 s defFormat=$$getSessionValue^%zewdAPI("defaultFormat",sessid)
 if defFormat="" QUIT "Default format must be set"
 ;
 s defTech=$$getSessionValue^%zewdAPI("defaultTech",sessid)
 if defTech="" QUIT "Default technology must be set"
 ;
 s multiLingual=$$getSessionValue^%zewdAPI("multiLingual",sessid)
 if multiLingual="" QUIT "Default multi-lingual setting must be defined"
 ;
 s rootPath=$$getSessionValue^%zewdAPI("path",sessid)
 i rootPath="" QUIT "You did not enter a value for the application root path"
 i rootPath'["\",rootPath'["/" QUIT "Invalid application root path"
 ;
 s configTechnology=$$getSessionValue^%zewdAPI("configTechnology",sessid)
 s error=""
 i configTechnology="csp" d  i error'="" QUIT error
 . s path=$$getRequestValue^%zewdAPI("outputPathCSP",sessid)
 . s cspURL=$$getRequestValue^%zewdAPI("rootURLCSP",sessid)
 . i path="",cspURL="" q
 . i path="" s error="You did not enter a value for the CSP output root path" q
 . i path'["\",path'["/" s error="Invalid CSP output root path" q
 . i cspURL="" s error="You did not enter a value for the CSP root URL" q
 . i cspURL'["/" s error="Invalid CSP root URL" q
 ;
 i configTechnology="php" d  i error'="" QUIT error
 . s path=$$getRequestValue^%zewdAPI("outputPathPHP",sessid)
 . s phpURL=$$getRequestValue^%zewdAPI("rootURLPHP",sessid)
 . i path="",phpURL="" q
 . i path="" s error="You did not enter a value for the PHP output root path" q
 . i path'["\",path'["/" s error="Invalid PHP output root path" q
 . i phpURL="" s error="You did not enter a value for the PHP root URL" q
 . i phpURL'["/" s error="Invalid PHP root URL" q
 ;
 i configTechnology="jsp" d  i error'="" QUIT error
 . s path=$$getRequestValue^%zewdAPI("outputPathJSP",sessid)
 . i path="" s error="You did not enter a value for the JSP output root path" q
 . i path'["\",path'["/" s error="Invalid JSP output root path" q
 . s jspURL=$$getRequestValue^%zewdAPI("rootURLJSP",sessid)
 . i jspURL="" s error="You did not enter a value for the JSP root URL" q
 . i jspURL'["/" s error="Invalid JSP root URL" q
 ;
 d setDefaultFormat^%zewdCompiler(defFormat)
 d deleteFromSession^%zewdAPI("xformat",sessid)
 ;
 d setDefaultTechnology^%zewdCompiler(defTech)
 d deleteFromSession^%zewdAPI("technology",sessid)
 ;
 d setDefaultMultiLingual^%zewdCompiler(multiLingual)
 d deleteFromSession^%zewdAPI("multiLingual",sessid)
 ;
 d setApplicationRootPath^%zewdCompiler(rootPath)
 ;
 i configTechnology="csp" d
 . s useRootURL=$$getRequestValue^%zewdAPI("useRootURL",sessid)
 . d setUseRootURL^%zewdCompiler(useRootURL)
 . d setOutputRootPath^%zewdCompiler(path,"csp")
 . d setRootURL^%zewdCompiler(cspURL,"csp")
 ;
 i configTechnology="php" d
 . d setOutputRootPath^%zewdCompiler(path,"php")
 . d setRootURL^%zewdCompiler(phpURL,"php")
 ;
 i configTechnology="jsp" d
 . d setOutputRootPath^%zewdCompiler(path,"jsp")
 . d setRootURL^%zewdCompiler(jspURL,"jsp")
 ;
 s jsScriptsPathMode=$$getRequestValue^%zewdAPI("jsScriptsPathMode",sessid)
 s jsScriptsRootPath=$$getRequestValue^%zewdAPI("jsScriptsRootPath",sessid)
 d setJSScriptsPathMode^%zewdAPI(configTechnology,jsScriptsPathMode)
 d setJSScriptsRootPath^%zewdAPI(configTechnology,jsScriptsRootPath)
 ;
 s homePage=$$getSessionValue^%zewdAPI("homePage",sessid)
 i homePage'="" d setHomePage^%zewdCompiler(homePage)
 ;
 d setWarning^%zewdAPI("Configuration settings have been updated",sessid)
 QUIT ""
 ;
getDataTypeList(sessid)
 ;
 n dataTypeList
 ;
 d clearSession(sessid)
 d deleteFromSession^%zewdAPI("dataTypeList",sessid)
 m dataTypeList=^%zewd("dataType")
 d addToSession^%zewdAPI("dataTypeList",sessid)
 ;
 QUIT ""
 ;
addNewDataType(sessid)
 ;
 n newDataType,newInputMethod,newOutputMethod
 ;
 s newDataType=$$getSessionValue^%zewdAPI("newDataType",sessid)
 s newInputMethod=$$getSessionValue^%zewdAPI("newInputMethod",sessid)
 s newOutputMethod=$$getSessionValue^%zewdAPI("newOutputMethod",sessid)
 ;
 i newDataType="" QUIT "You did not specify a data type name"
 i newInputMethod="" QUIT "You did not specify the input method for processing the "_newDataType_" data type"
 i newInputMethod'["^" QUIT "The input method name for processing the "_newDataType_" data type is invalid"
 i newOutputMethod="" QUIT "You did not specify the output method for processing the "_newDataType_" data type"
 i newOutputMethod'["^" QUIT "The output method name for processing the "_newDataType_" data type is invalid"
 ;
 i $$setDataType^%zewdCompiler(newDataType,newInputMethod,newOutputMethod)
 QUIT ""
 ;
deleteDataType(sessid)
 ;
 n dtName
 ;
 s dtName=$$getSessionValue^%zewdAPI("dtName",sessid)
 d deleteDataType^%zewdCompiler(dtName)
 QUIT ""
 ;
getDataTypeDetails(sessid)
 ;
 n dtName,inputMethod,outputMethod
 ;
 s dtName=$$getSessionValue^%zewdAPI("dtName",sessid)
 ;
 s inputMethod=$$getInputMethod^%zewdCompiler(dtName)
 d addToSession^%zewdAPI("inputMethod",sessid)
 s outputMethod=$$getOutputMethod^%zewdCompiler(dtName)
 d addToSession^%zewdAPI("outputMethod",sessid)
 QUIT ""
 ;
saveDataType(sessid)
 ;
 n dtName,inputMethod,outputMethod
 ;
 s dtName=$$getSessionValue^%zewdAPI("dtName",sessid)
 s inputMethod=$$getSessionValue^%zewdAPI("inputMethod",sessid)
 s outputMethod=$$getSessionValue^%zewdAPI("outputMethod",sessid)
 ;
 i inputMethod="" QUIT "You did not specify the input method for processing the "_dtName_" data type"
 i inputMethod'["^" QUIT "The input method name for processing the "_dtName_" data type is invalid"
 i outputMethod="" QUIT "You did not specify the output method for processing the "_dtName_" data type"
 i outputMethod'["^" QUIT "The output method name for processing the "_dtName_" data type is invalid"
 ;
 i $$setDataType^%zewdCompiler(dtName,inputMethod,outputMethod)
 QUIT ""
 ;
getCustomTagList(sessid)
 ;
 n customTagList,data,hasCustomTags,newTagImpliedClose,applyTo,tag,type
 ;
 d clearSession(sessid)
 d deleteFromSession^%zewdAPI("customTagList",sessid)
 m customTagList=^%zewd("customTag")
 d addToSession^%zewdAPI("customTagList",sessid)
 ;
 s tag="",hasCustomTags=0
 f  s tag=$o(^%zewd("customTag",tag)) q:tag=""  d
 . s data=^%zewd("customTag",tag)
 . s type=$p(data,$c(1),3)
 . i type'="system" s hasCustomTags=1
 d setSessionValue^%zewdAPI("hasCustomTags",hasCustomTags,sessid)
 ;
 s newTagImpliedClose=$$getSessionValue^%zewdAPI("newTagImpliedClose",sessid)
 d addToSession^%zewdAPI("newTagImpliedClose",sessid)
 s applyTo=$$getSessionValue^%zewdAPI("applyTo",sessid)
 d addToSession^%zewdAPI("applyTo",sessid)
 ;
 QUIT ""
 ;
addNewTag(sessid)
 ;
 n newTagInclude,newTagName,newTagMacro,newTagMethod,newTagImpliedClose,newAttrList,applyTo
 ;
 s newTagInclude=$$getSessionValue^%zewdAPI("newTagInclude",sessid)
 s newTagMacro=$$getSessionValue^%zewdAPI("newTagMacro",sessid)
 s newTagName=$$getSessionValue^%zewdAPI("newTagName",sessid)
 s newTagMethod=$$getSessionValue^%zewdAPI("newTagMethod",sessid)
 s newAttrList="" ;$$getSessionValue^%zewdAPI("newAttrList",sessid)
 s newTagImpliedClose=$$getSessionValue^%zewdAPI("newTagImpliedClose",sessid) 
 s applyTo=$$getSessionValue^%zewdAPI("applyTo",sessid) 
 ;
 i newTagName="" QUIT "You did not specify a tag name"
 i newTagMethod="",newTagInclude="",newTagMacro="" QUIT "You did not specify the include file, macro file or method for processing the "_newTagName_" tag"
 i newTagInclude="",newTagMacro="",newTagMethod'["^",newTagMethod'["##class" QUIT "The method name for processing the "_newTagName_" tag is invalid"
 i newTagMethod="",newTagMacro="",newTagInclude'["." QUIT "Invalid include file"
 i newTagMethod="",newTagInclude="",newTagMacro'["." QUIT "Invalid macro file"
 i newTagInclude'="",newTagMethod'="" QUIT "You must specify either an include file or a method, but not both"
 i newTagInclude'="",newTagMacro'="" QUIT "You must specify either an include file or a macro file, but not both"
 i newTagMethod'="",newTagMacro'="" QUIT "You must specify either a macro file or a method, but not both"
 ;
 i $$setCustomTag^%zewdCompiler(newTagName,newTagMethod,newTagImpliedClose,newAttrList,applyTo,newTagInclude,newTagMacro)
 QUIT ""
 ;
deleteCustomTag(sessid)
 ;
 n tagName
 ;
 s tagName=$$getSessionValue^%zewdAPI("tagName",sessid)
 d deleteCustomTag^%zewdCompiler(tagName)
 QUIT ""
 ;
getCustomTagDetails(sessid)
 ;
 n include,macro,tagName,tagMethod,tagImpliedClose,applyTo
 ;
 s tagName=$$getSessionValue^%zewdAPI("tagName",sessid)
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
 ;s tagAttrList=$$getCustomTagAttributeList^%zewdCompiler(tagName)
 ;d addToSession^%zewdAPI("tagAttrList",sessid)
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
 i $$setCustomTag^%zewdCompiler(tagName,tagMethod,tagImpliedClose,tagAttrList,applyTo,tagInclude,tagMacro)
 QUIT ""
 ;
getAppList(sessid)
 ;
 n appPath,dirs,os,dlim,dir,appList,n
 ;
 d clearSession(sessid)
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 ;
 ;s appPath=$g(^%zewd("config","applicationRootPath"))
 s appPath=$$getApplicationRootPath^%zewdAPI()
 i os="windows",appPath="" s appPath="\inetpub\wwwroot\php"
 i os="unix",appPath="" s appPath="/usr/ewd"
 ;
 i $e(appPath,$l(appPath))=dlim s appPath=$e(appPath,1,$l(appPath)-1)
 ;
 d getDirectoriesInPath^%zewdHTMLParser(appPath,.dirs)
 s dir="",n=""
 d clearList^%zewdAPI("appName",sessid)
 f  s dir=$o(dirs(dir)) q:dir=""  d
 . d appendToList^%zewdAPI("appName",dir,dir,sessid)
 ;
 QUIT ""
 ;
getIndices(sessid)
 QUIT $$getIndices^%zewdCompiler7(sessid)
 ;
getLangDetails(sessid)
 ;
 n appName,defLangCode,langList
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 d addToSession^%zewdAPI("defLangCode",sessid)
 ;
 d deleteFromSession^%zewdAPI("langList",sessid)
 m langList=^ewdTranslation("language",appName)
 i '$d(langList) s langList("en")="English"
 d addToSession^%zewdAPI("langList",sessid)
 ;
 QUIT ""
 ;
setLangDetails(sessid)
 ;
 n appName,error,defLangCode,langCode,langName
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s defLangCode=$$getSessionValue^%zewdAPI("defLangCode",sessid)
 s langCode=$$getSessionValue^%zewdAPI("langCode",sessid)
 i langCode="" QUIT "You must enter a language code"
 s langName=$$getSessionValue^%zewdAPI("langName",sessid)
 i langName="" QUIT "You must enter a language name"
 s appName=$$zcvt^%zewdAPI(appName,"l")
 i $d(^ewdTranslation("language",appName,langCode)) s error=langCode_" is already in use" q
 d setLanguageName^%zewdCompiler5(appName,langCode,langName)
 d setDefaultLanguage^%zewdCompiler5(appName,defLangCode)
 ;
 QUIT ""
 ;
removeLang(sessid)
 ;
 n appName,langCode
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s langCode=$$getSessionValue^%zewdAPI("langCode",sessid)
 k ^ewdTranslation("language",$$zcvt^%zewdAPI(appName,"l"),langCode)
 QUIT ""
 ;
getLanguages(sessid)
 ;
 n appName,defLangCode,langCode,langName,listCount,sourceLangOnly,untransOnly
 ;
 d deleteFromSession^%zewdAPI("matchesFound",sessid)
 d deleteFromSession^%zewdAPI("textid",sessid)
 d deleteFromSession^%zewdAPI("validTextid",sessid)
 d deleteFromSession^%zewdAPI("translation",sessid)
 d clearList^%zewdAPI("textidMatches",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 s untransOnly=$$getSessionValue^%zewdAPI("untransOnly",sessid)
 i untransOnly="" s untransOnly=1 d addToSession^%zewdAPI("untransOnly",sessid)
 s sourceLangOnly=$$getSessionValue^%zewdAPI("sourceLangOnly",sessid)
 i sourceLangOnly="" s sourceLangOnly=1 d setRadioOn^%zewdAPI("sourceLangOnly",sourceLangOnly,sessid)
 d clearList^%zewdAPI("languageTo",sessid)
 ;
 s langCode="",listCount=0
 f  s langCode=$o(^ewdTranslation("language",appName,langCode)) q:langCode=""  d
 . q:langCode=defLangCode
 . s listCount=listCount+1
 . s langName=$$getLanguageName^%zewdCompiler5(appName,langCode)
 . d appendToList^%zewdAPI("languageTo",langName,langCode,sessid)
 d addToSession^%zewdAPI("listCount",sessid)
 ;
 QUIT ""
 ;
getTranslations(sessid)
 ;
 n langTo,appName,defLangCode,textid,action,mcTextid,untransOnly,phraseType
 n app,textFrom,textTo,line,transList,page,ptextid,possTrans,firstTextid
 ;
 s langTo=$$getSessionValue^%zewdAPI("languageTo",sessid)
 i langTo="" QUIT "You must select a language"
 s action=$$getSessionValue^%zewdAPI("action",sessid)
 d deleteFromSession^%zewdAPI("translationListing",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 d addToSession^%zewdAPI("defLangCode",sessid)
 s untransOnly=$$getSessionValue^%zewdAPI("untransOnly",sessid)
 s textid="",firstTextid=""
 ;k ^rlt
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . k app,textFrom,textTo,line,transList,page,ptextid,possTrans
 . q:'$d(^ewdTranslation("textid",textid,defLangCode))
 . s app=$$getTextAppName^%zewdCompiler5(textid)
 . q:app'=appName
 . s page=$$getTextPage^%zewdCompiler5(textid)
 . s phraseType=$$getTextPhraseType^%zewdCompiler5(textid)
 . i page'="",'$d(^ewdTranslation("pageIndex",app,page,textid)) q  ; not active in page
 . i phraseType'="",'$d(^ewdTranslation("otherIndex",app,phraseType,textid)) q  ; not active in routine
 . s textFrom=$g(^ewdTranslation("textid",textid,defLangCode))
 . q:textFrom["{variable}"
 . s textTo=$g(^ewdTranslation("textid",textid,langTo))
 . i textTo'="",untransOnly quit
 . d getPhraseTranslations^%zewdCompiler5(textFrom,langTo,.transList)
 . s ptextid="",%stop=0,possTrans=""
 . f  s ptextid=$o(transList(ptextid)) q:ptextid=""  d  q:%stop
 . . i transList(ptextid)'=textTo s %stop=1,possTrans=transList(ptextid)
 . s possTrans=$$escapeQuotes^%zewdAPI(possTrans)
 . i page="",phraseType'="" s page=phraseType
 . s line=textFrom_$c(1)_textTo_$c(1)_$$countOtherPhraseTranslations^%zewdCompiler5(textid,langTo,appName)_$c(1)_page_$c(1)_possTrans
 . d setSessionArray^%zewdAPI("translationListing",textid,line,sessid)
 . i firstTextid="" s firstTextid=textid
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 i textid=""!(untransOnly) d setSessionValue^%zewdAPI("textid",firstTextid,sessid)
 QUIT ""
 ;
deletePhrase(sessid)
 ;
 n textid
 ;
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 d deleteTextid^%zewdCompiler5(textid)
 QUIT ""
 ;
getMultChoice(sessid)
 ;
 n appName,textid,app,defLangCode,langTo,text
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s langTo=$$getSessionValue^%zewdAPI("languageTo",sessid)
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 s text=$$getDefaultLanguageText^%zewdCompiler5(textid,appName)
 d setSessionValue^%zewdAPI("mtext",text,sessid)
 d clearList^%zewdAPI("multichoice",sessid)
 d deleteFromSession^%zewdAPI("multchoice",sessid)
 s app=$$getTextAppName^%zewdCompiler5(textid)
 i app=appName d
 . n page,textFrom,textTo,transList,ptextid,ptrans
 . s page=$$getTextPage^%zewdCompiler5(textid)
 . s textFrom=$g(^ewdTranslation("textid",textid,defLangCode))
 . s textTo=$g(^ewdTranslation("textid",textid,langTo))
 . i textTo="" s textTo="&nbsp;"
 . d getPhraseTranslations^%zewdCompiler5(textFrom,langTo,.transList)
 . s ptextid=""
 . f  s ptextid=$o(transList(ptextid)) q:ptextid=""  d
 . . s ptrans=transList(ptextid)
 . . d appendToList^%zewdAPI("multichoice",ptrans,ptextid,sessid)
 QUIT ""
 ;
exportTranslations(sessid)
 ;
 n app,appName,attr,defLangCode,dlim,docName,docOID,exportFormat,filePath,i,io
 n langTo,line,namp,ok,page,possTrans,ptextid,rootOID,sourceLangOnly,tagName,textFrom
 n textid,textOID,textSub,textTo,transList,untransOnly
 ;
 k ^CacheTempFound($j)
 s filePath=$$getSessionValue^%zewdAPI("filePath",sessid)
 i filePath="" QUIT "You did not enter a file path for the XML export"
 i '$$validPath^%zewdCompiler(filePath,1,1) QUIT "The file path you specificied is invalid"
 ;
 s langTo=$$getSessionValue^%zewdAPI("languageTo",sessid)
 i langTo="" QUIT "You must select a language"
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s exportFormat=$$getSessionValue^%zewdAPI("exportFormat",sessid)
 i exportFormat="" s exportFormat="xerox"
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 s untransOnly=$$getSessionValue^%zewdAPI("untransOnly",sessid)
 i untransOnly d autoTranslate(appName,langTo,0) ; force an autotranslate before export
 s sourceLangOnly=$$getRadioValue^%zewdAPI("sourceLangOnly",sessid)
 ;
 s docName="ewdTranslationExport"
 s ok=$$openDOM^%zewdAPI()
 s (namespaceURI,elementName,doctype)=""
 s ok=$$removeDocument^%zewdDOM(docName,1,1)
 s docOID=$$createDocument^%zewdDOM(namespaceURI,elementName,doctype,.docName,)
 ; --- Create ProcessingInstruction ---
 s target="xml",data="version='1.0' encoding='us-ascii'"
 i exportFormat="xerox" s data="version='1.0' encoding='windows-1252'"
 s procInsOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
 s procInsOID=$$appendChild^%zewdDOM(procInsOID,docOID)
 ;<translation>
 ;<configDetails application="translation" fromLanguage="en" toLanguage="de" documentType="export" />
 ;<text textid="1">
 ;  This is some English text requiring translation
 ;</text>
 ;
 s tagName="translationExport"
 i exportFormat="xerox" s tagName="translation"
 s rootOID=$$addElementToDOM^%zewdDOM(tagName,docOID,,,"")
 s attr("fromLanguage")=defLangCode
 s attr("toLanguage")=langTo
 s attr("application")=appName
 i exportFormat="xerox" s attr("documentType")="export"
 s textOID=$$addElementToDOM^%zewdDOM("configDetails",rootOID,,.attr,"")
 ;
 s tagName="sourceText"
 i exportFormat="xerox" s tagName="text"
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . k app,textFrom,textTo,line,transList,page,ptextid,possTrans
 . q:'$d(^ewdTranslation("textid",textid,defLangCode))
 . s app=$$getTextAppName^%zewdCompiler5(textid)
 . q:app'=appName
 . s page=$$getTextPage^%zewdCompiler5(textid)
 . i page'="",'$d(^ewdTranslation("pageIndex",app,page,textid)) q  ; not active in page
 . s textFrom=$g(^ewdTranslation("textid",textid,defLangCode))
 . q:textFrom["{variable}"
 . q:textFrom["{variable }"
 . s textTo=$g(^ewdTranslation("textid",textid,langTo))
 . i textTo'="",untransOnly quit
 . s textSub=$$getPhraseIndex^%zewdCompiler5(textFrom)
 . i $d(^CacheTempFound($j,textSub)) q  ; instance already exported - can be autotranslated after import
 . s attr("textid")=textid
 . ;i 'sourceLangOnly s attr("language")=$g(^ewdTranslation("language",app,defLangCode))
 . i (sourceLangOnly=0)!(sourceLangOnly=2) s attr("language")=$g(^ewdTranslation("language",app,defLangCode))
 . s textFrom=$$replaceAll^%zewdHTMLParser(textFrom,"<","&lt;")
 . s textFrom=$$replaceAll^%zewdHTMLParser(textFrom,">","&gt;")
 . s textFrom=$$replaceAll^%zewdHTMLParser(textFrom,"""","&quot;")
 . s textFrom=$$replaceAll^%zewdHTMLParser(textFrom,"'","&apos;")
 . s textFrom=$$replaceAll^%zewdHTMLParser(textFrom,"&nbsp;","<nbsp/>")
 . s textFrom=$$replaceAll^%zewdHTMLParser(textFrom,"&copy;","<copy/>")
 . s namp=0
 . i textFrom["&" s namp=$l(textFrom,"&")
 . s buff=textFrom,textFrom=""
 . i namp>0 f i=1:1:namp d
 . . s textFrom=textFrom_$p(buff,"&",1)
 . . s buff="&"_$p(buff,"&",2,2000)
 . . i $e(buff,1,4)="&lt;" q
 . . i $e(buff,1,4)="&gt;" q
 . . i $e(buff,1,6)="&quot;" q
 . . i $e(buff,1,6)="&apos;" q
 . . i $e(buff,1,5)="&amp;" q
 . . s buff=$e(buff,2,$l(buff))
 . . s buff="&amp;"_buff
 . s textFrom=textFrom_buff
 . ;s textOID=$$addElementToDOM^%eDOMAPI(tagName,rootOID,,.attr,textFrom)
 . i sourceLangOnly'=2 s textOID=$$addElementToDOM^%zewdDOM(tagName,rootOID,,.attr,textFrom)
 . s ^CacheTempFound($j,textSub)=""
 . ;
 . q:sourceLangOnly=1
 . ;
 . s attr("textid")=textid
 . s attr("language")=$g(^ewdTranslation("language",app,langTo))
 . s textTo=$$replaceAll^%zewdHTMLParser(textTo,"<","&lt;")
 . s textTo=$$replaceAll^%zewdHTMLParser(textTo,">","&gt;")
 . s textTo=$$replaceAll^%zewdHTMLParser(textTo,"""","&quot;")
 . s textTo=$$replaceAll^%zewdHTMLParser(textTo,"'","&apos;")
 . s textTo=$$replaceAll^%zewdHTMLParser(textTo,"&nbsp;","<nbsp/>")
 . s textTo=$$replaceAll^%zewdHTMLParser(textTo,"&copy;","<copy/>")
 . s namp=0
 . i textTo["&" s namp=$l(textFrom,"&")
 . s buff=textTo,textTo=""
 . i namp>0 f i=1:1:namp d
 . . s textTo=textTo_$p(buff,"&",1)
 . . s buff="&"_$p(buff,"&",2,2000)
 . . i $e(buff,1,4)="&lt;" q
 . . i $e(buff,1,4)="&gt;" q
 . . i $e(buff,1,6)="&quot;" q
 . . i $e(buff,1,6)="&apos;" q
 . . i $e(buff,1,5)="&amp;" q
 . . s buff=$e(buff,2,$l(buff))
 . . s buff="&amp;"_buff
 . s textTo=textTo_buff
 . q:textTo=""
 . s textOID=$$addElementToDOM^%zewdDOM(tagName,rootOID,,.attr,textTo)
 ;
 s io=$io
 i $$openNewFile^%zewdCompiler(filePath) e  QUIT "Unable to create export file"
 ;o filePath:"nw"
 u filePath
 d outputDOM^%zewdDOM(docName,0,1,,,,,"")
 c filePath
 u io
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 ;
 s ok=$$closeDOM^%zewdDOM()
 d setWarning^%zewdAPI("Export to "_filePath_" has been completed",sessid)
 ;
 k ^CacheTempFound($j)
 QUIT ""
 ;
testExport(appName,filePath,langTo,untransOnly)
 ;
 n app,attr,count,defLangCode,docName,docOID,io,line,ok,page,possTrans,ptextid
 n rootOID,textFrom,textid,textOID,textSub,textTo,transList
 ;
 k ^CacheTempFound($j)
 s filePath=$g(filePath)
 i filePath="" QUIT "You did not enter a file path for the XML export"
 i '$$validPath^%zewdCompiler(filePath,1,1) QUIT "The file path you specificied is invalid"
 ;
 s langTo=$g(langTo)
 i langTo="" QUIT "You must select a language"
 s appName=$g(appName)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 s untransOnly=$g(untransOnly)
 i untransOnly d autoTranslate(appName,langTo,0) ; force an autotranslate before export
 ;
 s docName="ewdTranslationExport"
 s ok=$$openDOM^%zewdAPI()
 s (namespaceURI,elementName,doctype)=""
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 s docOID=$$createDocument^%zewdDOM(namespaceURI,elementName,doctype,.docName,"")
 s rootOID=$$addElementToDOM^%zewdDOM("translationExport",docOID,,,"")
 s attr("fromLanguage")=defLangCode
 s attr("toLanguage")=langTo
 s attr("application")=appName
 s textOID=$$addElementToDOM^%zewdDOM("configDetails",rootOID,,.attr,"")
 ;
 s textid="",count=0
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . k app,textFrom,textTo,line,transList,page,ptextid,possTrans
 . q:'$d(^ewdTranslation("textid",textid,defLangCode))
 . s app=$$getTextAppName^%zewdCompiler5(textid)
 . q:app'=appName
 . s page=$$getTextPage^%zewdCompiler5(textid)
 . i page'="",'$d(^ewdTranslation("pageIndex",app,page,textid)) q  ; not active in page
 . s textFrom=$g(^ewdTranslation("textid",textid,defLangCode))
 . q:textFrom["{variable}"
 . s textTo=$g(^ewdTranslation("textid",textid,langTo))
 . i textTo'="",untransOnly quit
 . s textSub=$$getPhraseIndex^%zewdCompiler5(textFrom)
 . i $d(^CacheTempFound($j,textSub)) q  ; instance already exported - can be autotranslated after import
 . s attr("textid")=textid
 . s textOID=$$addElementToDOM^%zewdDOM("sourceText",rootOID,,.attr,textFrom)
 . s ^CacheTempFound($j,textSub)=""
 . s count=count+1
 ;
 s io=$io
 ;o filePath:"nw"
 i $$openNewFile^%zewdCompiler(filePath) e  QUIT "Unable to create export file"
 u filePath
 d outputDOM^%zewdDOM(docName,1,1,,,,,"")
 c filePath
 u io
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 ;
 s ok=$$closeDOM^%zewdDOM()
 w "Export to "_filePath_" has been completed"
 ;
 k ^CacheTempFound($j)
 QUIT count
 ;
deleteTranslation(app,language)
 ;
 n appName,defLang,textid
 ;
 i $g(app)="" w !,"app not specified" QUIT
 s app=$$zcvt^%zewdAPI(app,"l")
 s defLang=$$getDefaultLanguage^%zewdCompiler5(app)
 i defLang=language w !,"You cannot delete the "_defLang_" language"
 ;
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s appName=$$getTextAppName^%zewdCompiler5(textid)
 . i appName'=app q
 . k ^ewdTranslation("textid",textid,language)
 QUIT
 ;
importTranslations(sessid)
 ;
 n filePath,io,ok,docName,OIDArray,nodeOID,application,toLanguage,error,ntags,%stop
 n textid,childOID,text,app
 ;
 s filePath=$$getSessionValue^%zewdAPI("filePath",sessid)
 i filePath="" QUIT "You must enter a file path"
 ;o filePath:"r":2 e  QUIT "Unable to open the import file"
 s io=$io
 i $$openFile^%zewdCompiler(filePath) e  QUIT "Unable to open the import file"
 c filePath
 u io
 s ok=$$openDOM^%zewdAPI()
 s docName="ewdImport"
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 ;s ok=$$parseXMLFile^%eXMLAPI(filePath,0,1,docName,1)
 s ok=$$parseXMLFile^%zewdAPI(filePath,docName)
 i ok'="" s error="XML Parsing error : "_ok g importError
 s nodeOID=$$getTagOID^%zewdCompiler("configDetails",docName,0)
 s application=$$getAttributeValue^%zewdDOM("application",0,nodeOID)
 s application=$$zcvt^%zewdAPI(application,"l")
 s toLanguage=$$getAttributeValue^%zewdDOM("toLanguage",0,nodeOID)
 ;
 s error="",%stop=0
 i nodeOID="" s error="No configuration details found in XML document" g importError
 i application="" s error="Application name not specified in the XML import file configuration details" g importError
 i toLanguage="" s error="Translated language not specified in the XML import file configuration details" g importError
 ;
 ;s ntags=$$getTagsByName^%zewdCompiler("translatedText",docName,.OIDArray,0)
 f  s nodeOID=$$getNextSibling^%zewdDOM(nodeOID) q:nodeOID=""  d  q:%stop
 . ;s nodeOID="",%stop=0
 . ;f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  q:%stop
 . k textid,childOID,text
 . s textid=$$getAttributeValue^%zewdDOM("textid",0,nodeOID)
 . i textid="" d  q
 . . s %stop=1
 . . s error="translatedText node found without a textid attribute"
 . s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 . s text=$$getData^%zewdDOM(childOID)
 . i text="" q
 . s text=$$replaceAll^%zewdHTMLParser(text,"#nbsp#","&nbsp;")
 . s text=$$replaceAll^%zewdHTMLParser(text,"#copy#","&copy;")
 . s text=$$replaceAll^%zewdHTMLParser(text,"#deg#","&deg;")
 . s text=$$replaceAll^%zewdHTMLParser(text,"&apos;","&#39;")
 . s text=$$replaceAll^%zewdHTMLParser(text,"&quot;","'")
 . ;s text=$$replaceAll^%zewdHTMLParser(text,"&amp;","&")
 . s app=$$getTextAppName^%zewdCompiler5(textid)
 . i app'=application d  q
 . . s %stop=1
 . . s error="Application mismatch found. Textid "_textid_" belongs to the "_app_" application, but was included in the import file for the "_application_" application"
 . d setTranslatedValue^%zewdCompiler5(textid,toLanguage,text)
 ;
 i error'="" g importError
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 s ok=$$closeDOM^%zewdDOM()
 d autoTranslate(app,toLanguage,0)
 d setWarning^%zewdAPI("Translations were successfully imported : language = "_toLanguage_" ; application = "_application,sessid)
 ;
 QUIT ""
 ;
importTest(filePath)
 ;
 n io,ok,docName,OIDArray,nodeOID,application,toLanguage,error,ntags,%stop
 n textid,childOID,text,app
 ;
 ;o filePath:"r":2 e  QUIT "Unable to open the import file"
 s io=$io
 i $$openFile^%zewdCompiler(filePath) e  QUIT "Unable to open the import file"
 c filePath
 u io
 s ok=$$openDOM^%zewdAPI()
 s docName="ewdImport"
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 ;s ok=$$parseXMLFile^%eXMLAPI(filePath,0,1,docName,1)
 s ok=$$parseXMLFile^%zewdAPI(filePath,docName)
 i ok'="" s error="XML Parsing error : "_ok g importError
 s nodeOID=$$getTagOID^%zewdCompiler("configDetails",docName,0)
 s application=$$getAttributeValue^%zewdDOM("application",0,nodeOID)
 s toLanguage=$$getAttributeValue^%zewdDOM("toLanguage",0,nodeOID)
 ;
 s error=""
 i nodeOID="" QUIT "No configuration details found in XML document"
 i application="" QUIT "Application name not specified in the XML import file configuration details"
 i toLanguage="" QUIT "Translated language not specified in the XML import file configuration details"
 ;
 ;s ntags=$$getTagsByName^%zewdCompiler("translatedText",docName,.OIDArray,0)
 ;s ntags=$$getTagsByName^%zewdCompiler("sourceText",docName,.OIDArray,0)
 f  s nodeOID=$$getNextSibling^%zewdDOM(nodeOID) q:nodeOID=""  d
 . ;s nodeOID="",%stop=0
 . ;f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d  q:%stop
 . k textid,childOID,text
 . s textid=$$getAttributeValue^%zewdDOM("textid",0,nodeOID)
 . i textid="" d  q
 . . s %stop=1
 . . s error="translatedText node found without a textid attribute"
 . s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 . s text=$$getData^%zewdDOM(childOID)
 . i text="" q
 . s textx=text 
 . s text=$$replaceAll^%zewdHTMLParser(text,"#nbsp#","&nbsp;")
 . s text=$$replaceAll^%zewdHTMLParser(text,"#copy#","&copy;")
 . s text=$$replaceAll^%zewdHTMLParser(text,"#deg#","&deg;")
 . ;s app=$$getTextAppName^%zewdCompiler5(textid)
 . ;i app'=application d  q
 . ;. s %stop=1
 . ;. s error="Application mismatch found. Textid "_textid_" belongs to the "_app_" application, but was included in the import file for the "_application_" application"
 . w textid_" : "_toLanguage_" : "_text,!
 ;
 i error'="" QUIT error
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 s ok=$$closeDOM^%zewdDOM()
 w "Translations were successfully imported : language = "_toLanguage_" ; application = "_application
 ;
 QUIT ""
 ;
importError ;  jumps to here from above
 ;
 s ok=$$removeDocument^%zewdDOM(docName,,"")
 s ok=$$closeDOM^%zewdDOM()
 QUIT error_" : import aborted"
 ;
removeUnusedTextIDs(appName)
 ;
 n app,count,defLang,page,textid
 ;
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLang=$$getDefaultLanguage^%zewdCompiler5(appName)
 s textid="",count=0
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . q:'$d(^ewdTranslation("textid",textid,defLang))
 . s app=$$getTextAppName^%zewdCompiler5(textid)
 . q:app'=appName
 . s page=$$getTextPage^%zewdCompiler5(textid)
 . i page'="",'$d(^ewdTranslation("pageIndex",app,page,textid)) d
 . . w textid,!
 . . s count=count+1
 . . ; delete textid at this point - remove indices etc too
 QUIT count
 ;
updateTranslationAll(sessid)
 ;
 n textid,text,langTo,phraseIndex,appName,textAppName,defText,trans
 ;
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s text=$$getSessionValue^%zewdAPI("text",sessid)
 s langTo=$$getSessionValue^%zewdAPI("languageTo",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defText=$$getDefaultLanguageText^%zewdCompiler5(textid,appName)
 s phraseIndex=$$getPhraseIndex^%zewdCompiler5(defText)
 s textid=""
 f  s textid=$o(^ewdTranslation("textIndex",phraseIndex,textid)) q:textid=""  d
 . s textAppName=$$getTextAppName^%zewdCompiler5(textid)
 . q:appName'=textAppName
 . s trans=$$getTextTranslation^%zewdCompiler5(textid,langTo)
 . q:trans'=""
 . d setTranslatedValue^%zewdCompiler5(textid,langTo,text)
 ;
 QUIT ""
 ;
updateTranslation(sessid)
 ;
 n textid,text,langTo,defText,appName
 ;
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s text=$$getSessionValue^%zewdAPI("text",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defText=$$getDefaultLanguageText^%zewdCompiler5(textid,appName)
 s langTo=$$getSessionValue^%zewdAPI("languageTo",sessid)
 ;d trace^%zewdAPI("textid="_textid_" ; text="_text_" ; appname="_appName)
 d setTranslatedValue^%zewdCompiler5(textid,langTo,text)
 i $l(text)>$l(defText) d setWarning^%zewdAPI("The translated text is longer than the original text and may not fit into the web page",sessid)
 ;
 QUIT ""
 ;
autoTranslate(app,language,verbose)
 ;
 n appName,defLang,i,matches,ok,phraseIndex,text,textid,trans,version,xtextid
 ;
 ; Save last 5 versions of translation global
 ;
 s app=$$zcvt^%zewdAPI(app,"l")
 s version=$increment(^ewdTransBackup)
 f i=1:1:(version-5) i $d(^ewdTransBackup(i)) k ^ewdTransBackup(i)
 k ^ewdTransBackup(version)
 m ^ewdTransBackup(version)=^ewdTranslation
 ;
 s verbose=$g(verbose)
 s defLang=$$getDefaultLanguage^%zewdCompiler5(app)
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s appName=$$getTextAppName^%zewdCompiler5(textid)
 . i appName'=app q
 . ;
 . i $d(^ewdTranslation("textid",textid,language)) q  ; already translated
 . s text=$g(^ewdTranslation("textid",textid,defLang))
 . i text="" q
 . d getMatchingText(text,.matches)
 . i '$d(matches) q
 . s xtextid="",found=0
 . f  s xtextid=$o(matches(xtextid),-1) q:xtextid=""  d  q:found
 . . i $d(^ewdTranslation("textid",xtextid,language)) d
 . . . s trans=^ewdTranslation("textid",xtextid,language)
 . . . s found=1
 . . . i verbose w !!,textid_" : "_text,!,xtextid," : ",trans,!!
 . . . s ^ewdTranslation("textid",textid,language)=trans
 . i 'found,verbose w !!,textid_" : "_text,!,"No translation found"
 . ;
 QUIT
 ;
countMissing(app,language)
 ;
 n appName,count,defLang,textid,text,found
 ;
 s app=$$zcvt^%zewdAPI(app,"l")
 s defLang=$$getDefaultLanguage^%zewdCompiler5(app)
 s textid="",count=0
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s appName=$$getTextAppName^%zewdCompiler5(textid)
 . i appName'=app q
 . ;
 . i $d(^ewdTranslation("textid",textid,language)) q  ; already translated
 . s text=^ewdTranslation("textid",textid,"en")
 . i text["{variable }" q
 . s textx=$e(text,1,255)
 . i $d(found(textx)) q
 . s count=count+1
 . w textid," : ",text,!
 . s found(textx)=""
 . ;
 QUIT count
 ;
cleanText
 ;
 n textid
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . s lang=""
 . f  s lang=$o(^ewdTranslation("textid",textid,lang)) q:lang=""  d
 . . i lang="en" q
 . . s text=^ewdTranslation("textid",textid,lang)
 . . i text["#nbsp#"!(text["#copy#")!(text["#deg#") d
 . . . s text=$$replaceAll^%zewdHTMLParser(text,"#nbsp#","&nbsp;")
 . . . s text=$$replaceAll^%zewdHTMLParser(text,"#copy#","&copy;")
 . . . s text=$$replaceAll^%zewdHTMLParser(text,"#deg#","&deg;")
 . . . s ^ewdTranslation("textid",textid,lang)=text
 . . . w textid," ",text,!
 QUIT
 ;
 ;
getMatchingText(phrase,matchingTextidList)
	;
	n indexPhrase,textid
	;
	k matchingTextidList
	;
	QUIT:$g(phrase)=""
	s indexPhrase=$$getPhraseIndex^%zewdCompiler5(phrase)
	s textid=""
	f  s textid=$o(^ewdTranslation("textIndex",indexPhrase,textid)) q:textid=""  d
	. s matchingTextidList(textid)=""
	QUIT
 ;
setFilter(sessid)
 ;
 n path,username,file,selected,lcselected
 ;
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 i username="" s username="unknownUser"
 d mergeFromSelected^%zewdAPI("pageFilter",.selected,sessid)
 s file=""
 f  s file=$o(selected(file)) q:file=""  d
 . s lcselected($$zcvt^%zewdAPI(file,"l"))=selected(file)
 k ^zewd("pageFilter",username,path)
 m ^zewd("pageFilter",username,path)=lcselected
 ;
 QUIT ""
 ;
resetFilter(sessid)
 ;
 n path,username
 ;
 s path=$$getSessionValue^%zewdAPI("path",sessid)
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 i username="" s username="unknownUser"
 k ^zewd("pageFilter",username,path)
 ;
 QUIT ""
 ;
getStatusDetails(sessid)
 ;
 n system,title,index,%d,NSYS,NJOB,JOB,pid1,pid2,maxpid,io,x
 n nsys,nusr,gglo,nrou,nlic,max
 ;
 d deleteFromSession^%zewdAPI("ss",sessid)
 s system=$ZV,index=0
 s title="Cache System Status: "_$$ZT^%SS($p($h,",",2))_" "_$zdate($h,2)
 d setSessionValue^%zewdAPI("ssSystem",system,sessid)
 d setSessionValue^%zewdAPI("ssTitle",title,sessid)
 s (NSYS,NJOB)=0 ;# of SYSTEM jobs and # of jobs                  
 d BUILD^%SS ; build JOB(i,j)=pid
 s pid1=""
 f  s pid1=$o(JOB(pid1)) q:pid1=""  d
 . s pid2=""
 . f  s pid2=$o(JOB(pid1,pid2)) q:pid2=""  d
 . . n J,job,pm,pdev,odev,par,dir,pro,glo,pri,uic,loc,dev,nam,shutdown
 . . s index=index+1
 . . s job=JOB(pid1,pid2)
 . . d BldJob^%SS(job,.J) q:'$d(J(job,2))
 . . s pm=J(job,2) I pm="" S pm="&nbsp;"
 . . s pdev=J(job,"P")
 . . s odev=J(job,"D")
 . . s par=J(job,4) I par="" S par="&nbsp;"
 . . s dir=J(job,5) I dir="" S dir="&nbsp;"
 . . s pro=J(job,6) I pro="" S pro="&nbsp;"
 . . s glo=J(job,7) I glo="" S glo="&nbsp;"
 . . s pri=J(job,8) I pri="" S pri="&nbsp;"
 . . s uic=J(job,9) I uic="" S uic="&nbsp;"
 . . s loc=J(job,10) I loc="" S loc="&nbsp;"
 . . s dev=pdev_" ; "_odev I dev=" ; " S dev="&nbsp;"
 . . s nam=job
 . . s job=job_pm
 . . s shutdown=1
 . . i "CONTROL~WRTDMN~GARCOL~JRNDMN"[loc s shutdown=0
 . . i loc["SLAVWD" s shutdown=0
 . . i loc["EXPDMN" s shutdown=0
 . . s %d=job_$c(1)_dev_$c(1)_par_$c(1)_dir_$c(1)_pro_$c(1)_glo_$c(1)_pri_$c(1)_uic_$c(1)_loc_$c(1)_shutdown_$c(1)_nam
 . . d setSessionArray^%zewdAPI("ss",index,%d,sessid)
 ;
 s io=$i
 s x=$$INT^%SS()
 u io
 s nsys=$P(x,"^",2)
 s nusr=$P(x,"^",3)
 s nglo=$P(x,"^",4)
 s nrou=$P(x,"^",5)
 s nlic=$P(x,"^",6)
 s max=$G(maxpid)-nsys
 s x=nusr_" user/"_nsys_" system/"_max_" max/"_nlic_" licensed, "_nglo_" global/"_nrou_" routine buffers"
 d setSessionValue^%zewdAPI("ssTotal",x,sessid)
 ;
 QUIT ""
 ;
sd(sessid) ; shutdown a process
 n job,ok,status,sys,ns
 s job=$$getSessionValue^%zewdAPI("job",sessid)
 s ns=$$namespace^%zewdAPI()
 s ok=$$setNamespace^%zewdAPI("%SYS")
 s status=$$INT^RESJOB(job)
 s ok=$$setNamespace^%zewdAPI(ns)
 i status d setWarning^%zewdAPI("Session "_job_" terminated",sessid) QUIT ""
 d setWarning^%zewdAPI("Session "_job_" could not be terminated",sessid)
 QUIT ""
 ;
getTextidInfo(sessid)
 ;
 n appName,defLang,found,lang,matches,num,page,text,textid,translation,xtextid
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLang=$$getDefaultLanguage^%zewdCompiler5(appName)
 d setSessionValue^%zewdAPI("mainLangName",^ewdTranslation("language",appName,defLang),sessid)
 d deleteFromSession^%zewdAPI("translation",sessid)
 d deleteFromSession^%zewdAPI("textidMatches",sessid)
 d appendToList^%zewdAPI("languageTo","English","en",sessid)
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s page=$$getTextPage^%zewdCompiler5(textid)
 s status=""
 i textid'="",page'="",'$d(^ewdTranslation("pageIndex",appName,page,textid)) s status="(No longer used)"
 d setSessionValue^%zewdAPI("status",status,sessid)
 d setSessionValue^%zewdAPI("pageName",page,sessid)
 i textid'="" d
 . s lang=""
 . f num=1:1  s lang=$o(^ewdTranslation("language",appName,lang)) q:lang=""  d
 . . s text=$g(^ewdTranslation("textid",textid,lang))
 . . i lang=defLang d setSessionValue^%zewdAPI("english",text,sessid) q
 . . s translation(num)=^ewdTranslation("language",appName,lang)_$c(1)_text_$c(1)_lang
 . d mergeArrayToSession^%zewdAPI(.translation,"translation",sessid)
 ;
 i textid'="",defLang'="" d
 . s text=$g(^ewdTranslation("textid",textid,defLang))
 . i text'="" d getMatchingText(text,.matches)
 ;
 d deleteFromSession^%zewdAPI("matchingTextids",sessid)
 d clearList^%zewdAPI("matchingTextids",sessid)
 s xtextid="",found=0
 f  s xtextid=$o(matches(xtextid)) q:xtextid=""  d
 . i xtextid=textid q
 . s page=$$getTextPage^%zewdCompiler5(xtextid)
 . i page'="",'$d(^ewdTranslation("pageIndex",appName,page,xtextid)) q  ; not active
 . s text=xtextid_" : "_page
 . s found=1
 . d appendToList^%zewdAPI("matchingTextids",text,xtextid,sessid)
 ;
 i found d setSessionValue^%zewdAPI("matchingTextids",1,sessid)
 ;
 QUIT ""
 ;
setMatchingTextid(sessid)
 ;
 n textid
 ;
 s textid=$$getSessionValue^%zewdAPI("matchingTextids",sessid)
 d setSessionValue^%zewdAPI("textid",textid,sessid)
 QUIT ""
 ;
setTextidInfo(sessid)
 ;
 n appName,defLang,lang,textid,pressed,translation,updateAll
 ;
 s num=$$getSessionValue^%zewdAPI("num",sessid)
 s updateAll=$$getSessionValue^%zewdAPI("updateAll",sessid)
 d mergeArrayFromSession^%zewdAPI(.translation,"translation",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s lang=$p(translation(num),$c(1),3)
 s translation=$$getRequestValue^%zewdAPI("trans"_num,sessid)
 i translation="" QUIT "You didn't enter a translation"
 s ^ewdTranslation("textid",textid,lang)=translation
 i updateAll d updateMatchingTextids(textid,appName,lang)
 ;
 QUIT ""
 ;
 ;
updateMatchingTextids(textid,app,language)
 ;
 n appName,defLang,matches,text,xtextid
 ;
 s app=$$zcvt^%zewdAPI(app,"l")
 s defLang=$$getDefaultLanguage^%zewdCompiler5(app)
 s appName=$$getTextAppName^%zewdCompiler5(textid)
 i appName'=app q
 ;
 s text=$g(^ewdTranslation("textid",textid,defLang))
 i text="" q
 s transText=$g(^ewdTranslation("textid",textid,language))
 i transText="" q
 d getMatchingText(text,.matches)
 i '$d(matches) q
 s xtextid=""
 f  s xtextid=$o(matches(xtextid),-1) q:xtextid=""  d
 . s ^ewdTranslation("textid",xtextid,language)=transText
 QUIT
 ;
setTextid(sessid)
 ;
 n textAppName,textid
 ;
 d deleteFromSession^%zewdAPI("validTextid",sessid)
 i $$getSessionValue^%zewdAPI("formID",sessid)="matches" d
 . s textid=$$getSelectValue^%zewdAPI("textidMatches",sessid)
 e  d
 . s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 i textid="" QUIT "You must enter a textid"
 i '$D(^ewdTranslation("textid",textid)) QUIT "textid "_textid_" does not exist"
 d setSessionValue^%zewdAPI("textid",textid,sessid)
 s textAppName=$$getTextAppName^%zewdCompiler5(textid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 i textAppName'=appName QUIT "textid "_textid_" does not belong to the "_appName_" application"
 d deleteFromSession^%zewdAPI("inactiveTextid",sessid)
 i '$$isActive^%zewdCompiler5(textid) d setSessionValue^%zewdAPI("inactiveTextid","( unused/obsolete)",sessid) 
 d setSessionValue^%zewdAPI("validTextid",1,sessid)
 ;
 QUIT ""
 ;
 ;
 ;================================================
 ;
encodeDate(textDate,error,sessid)
 n dh
 s error=""
 s $zt="encodeDateError"
 s dh=""
 ;s dh=$$inetDate^%zewdAPI(textDate)
 s dh=$p(dh,", ",2)
 i $g(dh)="" s error="Invalid date" QUIT textDate
 QUIT $g(dh)
 ;
encodeDateError ;
 s error="Invalid Date"
 s $zt=""
 QUIT textDate
 ;
decodeDate(rawDate,sessid)
 QUIT $zd(rawDate,2)
 ;
templateprePage(sessid)
 d setSessionValue^%zewdAPI("templateField","test value",sessid)
 QUIT ""
 ;
outputTranslations
 n file,io,textid
 s file="words.txt"
 c file
 ;o file:"nw" u file
 s io=$io
 i $$openNewFile^%zewdCompiler(file) e  QUIT
 u file
 s textid=""
 f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
 . w ^ewdTranslation("textid",textid,"en"),!
 c file
 u io
 QUIT
 ;
testOnError(sessid)
 ;
 d TRACE^%wld("OnError processing executed for session "_sessid)
 QUIT 1
 ;
