%zewdiWDMgr	;Enterprise Web Developer - iPhone Inspector scripts
 ;
 ; Product: Enterprise Web Developer (Build 906)
 ; Build Date: Wed, 28 Mar 2012 12:52:00
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-12 M/Gateway Developments Ltd,                        |
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
isPasswordProtected(sessid)
 ;
 n pwProtected
 ;
 s pwProtected=$$passwordProtected^%zewdMgrAjax()
 d setSessionValue^%zewdAPI("isPasswordProtected",pwProtected,sessid)
 QUIT ""
 ;
about(sessid)
 ;
 d setSessionValue^%zewdAPI("ewdOS",$zv,sessid)
 d setSessionValue^%zewdAPI("ewdVersion",$$version^%zewdAPI(),sessid)
 d setSessionValue^%zewdAPI("ewdDate",$$date^%zewdAPI(),sessid)
 QUIT ""
 ;
getSessionList(sessid)
 ;
 n currSessid,n,no,sessionList,text
 ;
 s currSessid=$$getSessionValue^%zewdAPI("ewd_sessid",sessid)
 i $$isCSP^%zewdAPI(sessid) d
 . s no=0,n=""
 . f  s no=$o(^%cspSession(no)) q:no=""  d
 . . s n=n+1
 . . i ("csp:"_no)=currSessid s sessionList(n,"text")="* "_currSessid
 . . e  s sessionList(n,"text")=currSessid
 e  d
 . s no="",n=0
 . f  s no=$o(^%zewdSession("session",no)) q:no=""  d
 . . s n=n+1
 . . s text=no
 . . i no=currSessid s text=text_" (You)"
 . . s sessionList(n,"text")=text
 ;
 d deleteFromSession^%zewdAPI("sessionList",sessid)
 d mergeToSession^%zewdAPI("sessionList",sessid)
 ;
 QUIT ""
 ;
getSessionInfo(sessid)
 ;
 n appName,currTime,expired,expiry,no,pageName,session,sessNo,timeout
 ;
 s no=$$getRequestValue^%zewdAPI("menuItemNo",sessid)
 d mergeArrayFromSession^%zewdAPI(.session,"sessionList",sessid)
 s sessNo=session(no,"text")
 s sessNo=$p(sessNo," (",1)
 d setSessionValue^%zewdAPI("mgr.sessionNo",sessNo,sessid)
 s appName=$$getSessionValue^%zewdAPI("ewd.appName",sessNo)
 s expired=0
 i appName="" s expired=1
 d setSessionValue^%zewdAPI("mgr.expired",expired,sessid)
 i expired QUIT ""
 s pageName=$$getSessionValue^%zewdAPI("ewd.pageName",sessNo)
 s timeout=$$getSessionValue^%zewdAPI("ewd_sessid_timeout",sessNo)
 s expiry=$$getSessionValue^%zewdAPI("ewd_sessionExpiry",sessNo)
 s expiry=$$convertSecondsToDate^%zewdAPI(expiry)
 s expiry="<br/>"_$$inetDate^%zewdAPI(expiry)
 s currTime="<br/>"_$$inetDate^%zewdAPI($h)
 s db=$$getSessionValue^%zewdAPI("ewd_os",sessNo)
 i db="gtm" s db="GT.M"
 i db="cache" s db="Cach&eacute;"
 s tech=$$getSessionValue^%zewdAPI("ewd_technology",sessNo)
 i tech="wl" s tech="WebLink"
 i tech="csp" s tech="CSP"
 i tech="gtm" s tech="m_apache"
 i tech="ewd" s tech="Node.js"
 d setSessionValue^%zewdAPI("mgr.appName",appName,sessid)
 d setSessionValue^%zewdAPI("mgr.timeout",timeout,sessid)
 d setSessionValue^%zewdAPI("mgr.expiry",expiry,sessid)
 d setSessionValue^%zewdAPI("mgr.page",pageName,sessid)
 d setSessionValue^%zewdAPI("mgr.now",currTime,sessid)
 d setSessionValue^%zewdAPI("mgr.db",db,sessid)
 d setSessionValue^%zewdAPI("mgr.gw",tech,sessid)
 QUIT ""
 ;
getSessionContent(sessid)
 ;
 n end,name,no,sessionContent,sessionNo,ref,data,%p1,text
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("mgr.sessionNo",sessid)
 ;
 s ref="^%zewdSession(""session"",sessionNo,"""")"
 s end="^%zewdSession(""session"","_sessionNo
 s no=0
 s len=26
 f  s ref=$q(@ref) q:ref'[end  d
 . s data=@ref
 . s %p1=$p(ref,end_",",2)
 . s %p1=$e(%p1,1,$l(%p1)-1)
 . i $e(%p1,1,15)="""sessionContent" q
 . s data=$tr(data,$c(1),"|")
 . i $l(data)>len d
 . . n p1,p2
 . . s p1=$e(data,1,len),p2=$e(data,(len+1),$l(data))
 . . s data=p1_"<br/>"_p2
 . i data="" s data="<span style='color:blue'>null</span>"
 . s name=%p1
 . i name["""," d
 . . s name="["_name_"]"
 . . s name=$tr(name,"""","'")
 . e  d
 . . s name=$e(name,2,$l(name)-1)
 . i $l(name)>len d
 . . n p1,p2
 . . s p1=$e(name,1,len),p2=$e(name,(len+1),$l(name))
 . . s name=p1_"<br/>"_p2
 . s text=""
 . s text=text_"<span style='color:red'>"_name_"</span><br />"
 . s text=text_"<span style='color:green'>"_data_"</span>"
 . s no=no+1
 . s sessionContent(no,"text")=text
 ;
 d deleteFromSession^%zewdAPI("sessionContent",sessid)
 d mergeToSession^%zewdAPI("sessionContent",sessid)
 QUIT ""
 ;
getConfigInfo(sessid)
 ;
 n jsPath,rouPath,tech,technology
 ;
 d setSessionValue^%zewdAPI("mgr.appRootPath",$$getApplicationRootPath^%zewdAPI(),sessid)
 d setSessionValue^%zewdAPI("mgr.database",$zv,sessid)
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 s tech="WebLink"
 i technology="csp" s tech="CSP"
 i technology="gtm" s tech="m_apache"
 d setSessionValue^%zewdAPI("mgr.technology",tech,sessid)
 s rouPath=$g(^zewd("config","routinePath",technology))
 d setSessionValue^%zewdAPI("mgr.rouPath",rouPath,sessid)
 s jsPath=$g(^zewd("config","jsScriptPath",technology,"outputPath"))
 d setSessionValue^%zewdAPI("mgr.jsPath",jsPath,sessid)
 d setSessionValue^%zewdAPI("mgr.rootURL",$$getRootURL^%zewdAPI(technology),sessid)
 s jsPath=$g(^zewd("config","jsScriptPath",technology,"path"))
 d setSessionValue^%zewdAPI("mgr.jsURL",jsPath,sessid)
 QUIT ""
 ;
getAppList(sessid)
 ;
 n applicationList,appPath,dir,dirs,dlim,no,os,sortedDir,text
 ;
 s os=$$os^%zewdHTMLParser()
 s dlim="/" i os="windows" s dlim="\"
 s appPath=$$getApplicationRootPath^%zewdAPI()
 i appPath="" QUIT ""
 i $e(appPath,$l(appPath))=dlim s appPath=$e(appPath,1,$l(appPath)-1)
 d setSessionValue^%zewdAPI("mgr.delim",dlim,sessid)
 d setSessionValue^%zewdAPI("mgr.appPath",appPath,sessid)
 d getDirectoriesInPath^%zewdHTMLParser(appPath,.dirs)
 s dir=""
 f  s dir=$o(dirs(dir)) q:dir=""  d
 . s sortedDir($$zcvt^%zewdAPI(dir,"l"))=dir
 s dir="",no=0
 f  s dir=$o(sortedDir(dir)) q:dir=""  d
 . s text=sortedDir(dir)
 . s no=no+1
 . s applicationList(no,"text")=text
 ;
 d deleteFromSession^%zewdAPI("applicationList",sessid)
 d mergeToSession^%zewdAPI("applicationList",sessid)
 ;
 QUIT ""
 ;
selectApp(sessid)
 ;
 n apps,no
 ;
 s no=$$getRequestValue^%zewdAPI("menuItemNo",sessid)
 d mergeArrayFromSession^%zewdAPI(.apps,"applicationList",sessid)
 s app=apps(no,"text")
 d setSessionValue^%zewdAPI("mgr.app",app,sessid)
 QUIT ""
 ;
getPageList(sessid)
 ;
 n app,appPath,delim,fileName,fileList,pageList,no,path,technology
 ;
 s no=$$getRequestValue^%zewdAPI("menuItemNo",sessid)
 d mergeArrayFromSession^%zewdAPI(.apps,"applicationList",sessid)
 s app=apps(no,"text")
 d setSessionValue^%zewdAPI("mgr.app",app,sessid)
 ;
 s delim=$$getSessionValue^%zewdAPI("mgr.delim",sessid)
 s appPath=$$getSessionValue^%zewdAPI("mgr.appPath",sessid)
 s technology=$$getSessionValue^%zewdAPI("ewd_technology",sessid)
 s path=appPath_delim_app
 d getFileInfo^%zewdGTM(path,".ewd",.fileList)
 ;
 s fileName="",no=0
 f  s fileName=$o(fileList(fileName)) q:fileName=""  d
 . s no=no+1
 . s pageList(no,"text")=fileName
 ;
 d deleteFromSession^%zewdAPI("pageList",sessid)
 d mergeToSession^%zewdAPI("pageList",sessid)
 ;
 QUIT ""
 ;
selectPage(sessid)
 ;
 n pages,page,no
 ;
 s no=$$getRequestValue^%zewdAPI("menuItemNo",sessid)
 d mergeArrayFromSession^%zewdAPI(.pages,"pageList",sessid)
 s page=pages(no,"text")
 d setSessionValue^%zewdAPI("mgr.page",page,sessid)
 QUIT ""
 ;
