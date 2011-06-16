%zewdPHP	; Enterprise Web Developer PHP run-time functions and processing
 ;
 ; Product: Enterprise Web Developer (Build 867)
 ; Build Date: Thu, 16 Jun 2011 18:10:22
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
startSession(page,requestArray,serverArray,sessionArray,filesArray) ;
 ;
 n browserType,error,inError,isFirstPage,newToken,nextPageToken,ok,os
 n prePagePass,sessid,standardError,token,zewdSession
 ;
 s $zt="g errorTrap^%zewdPHP"
 i $g(^zewd("trace"))=1 d
 . n x
 . s x=$increment(^%zewdTrace("request")) m ^%zewdTrace("request",x)=requestArray
 . m ^%zewdTrace("session",x)=sessionArray
 . d trace^%zewdAPI("Request "_x_": running startSession for "_page_" in the "_$$namespace^%zewdAPI()_" namespace; Process: "_$j)
 d normaliseRequestArray(.requestArray,.sessionArray)
 i $g(^zewd("trace"))=1 d
 . k ^%zewdTrace("server") m ^%zewdTrace("server")=serverArray,^%zewdTrace("files")=filesArray
 s standardError="Enterprise Web Developer Error : Invalid token or session timed out"
 s error=""
 s isFirstPage=$g(sessionArray("ewd_isFirstPage"))
 i isFirstPage="" d  QUIT error
 . s error="Enterprise Web Developer Error : Missing declaration to determine whether this is the application's first page"
 ;
 s token=$g(requestArray("ewd_token"))
 s inError=$g(requestArray("error"))
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("token="_token_"; inError="_inError)
 i token="",inError="" d  QUIT error
 . i isFirstPage,$g(sessionArray("ewd_startFromWLDOnly"))'=1 d  q
 . . ; new session - initialise and run prepage script
 . . i $g(^zewd("trace"))=1 d trace^%zewdAPI("About to create new session")
 . . s error=$$createNewSession(page,.requestArray,.sessionArray)
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("Checking for ewd.startFromWLDOnly")
 . s error="Enterprise Web Developer Error : Illegal attempt to access a page"
 . i $g(sessionArray("ewd_startFromWLDOnly"))=1 s error=error_" (must be started via WLD)"
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("..error="_error)
 ;
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Existing session")
 s sessid=$$getSessid(token)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("getSessid returned "_sessid)
 ;
 s error=$$checkWLDOnlyStart()
 i error'="" QUIT error
 ;
 i inError'="" s sessid=$g(requestArray("sessid"))
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("token="_token_" ; sessid="_sessid)
 ; sessid will be null if token was either invalid or timed out
 i inError="",sessid="" d  QUIT standardError
 . s error=standardError
 i inError'="",sessid="" QUIT ""
 ;
 ; session has been recognised. 
 ; If we're navigating here, is the page token valid - ie is the user allowed to bring up this page?
 ;
 d setSessionValue("ewd_os",$$os(),sessid)
 d deleteFromSession^%zewdAPI("ewd_header",sessid)
 i inError="",$$getSessionValue("ewd_action",sessid)="" d  i error'="" QUIT $$escapeError(error,sessid)
 . ;d trace^%zewdAPI("no action")
 . s nextPageToken=$g(requestArray("n"))
 . i $g(serverArray("REQUEST_METHOD"))="GET",page'["ewdAjaxError",nextPageToken="" d
 . . s error="Enterprise Web Developer Error : Missing nextpage token : "_$g(serverArray("METHOD"))
 . i nextPageToken'="",'$$isNextPageTokenValid(nextPageToken,sessid,page) d
 . . ;d trace^%zewdAPI("** nextPageToken="_nextPageToken_" ; sessid="_sessid_" ; page="_page)
 . . s error="Enterprise Web Developer Error : Invalid nextpage token"
 . . s sessionArray("ewd_sessid")=sessid
 ;
 ; ok, must be a valid, existing session. Set the session lock to force serialisation if multiple frames/pages
 ;
 d setLock(sessid,page)
 ;
 ; merge incoming session, request and server array contents into existing session global
 d deleteFromSession^%zewdAPI("ewd_menuOption",sessid)
 d putSession(sessid,.sessionArray)
 d setSessionValue("ewd_date",$$decDate^%zewdAPI($h),sessid)
 d setSessionValue("ewd_time",$$inetTime^%zewdAPI($h),sessid)
 s browserType=$$getBrowser(.serverArray,.os)
 d setSessionValue("ewd.browserType",browserType,sessid)
 i browserType="iphone" d 
 . d setSessionValue("ewd.touchEvent","ontouchstart",sessid)
 e  d
 . d setSessionValue("ewd.touchEvent","onclick",sessid)
 d setSessionValue("ewd.browserOS",os,sessid) 
 ;k ^rlt("sessionArray") m ^rlt("sessionArray")=sessionArray
 i $$getSessionValue("ewd_persistRequest",sessid)="true" d  d updateSessionFromRequest(.requestArray,sessid)
 . ;d trace^%zewdAPI("updating session from request")
 . ;k ^rlt("requestArray") m ^rlt("requestArray")=requestArray
 ; create new page token and add to session global
 s newToken=$$createNewToken(sessid,$$getSessionValue("ewd_pageName",sessid))
 d deleteJump(sessid) ; clear down
 d processMenuOptions(sessid) 
 ; now run action script, if relevant
 ; 
 d saveNextPageTokens(sessid,page)
 ;
 ;
 s prePagePass=0
 i inError'=""!($$getSessionValue("ewd_action",sessid)="") d
 . s prePagePass=1
 . i $g(^zewd("trace")) d trace^%zewdAPI("running prepage script")
 . s error=$$prePageScript(sessid) ; *** pre-page script
 . ;d trace^%zewdAPI("finished prepage script")
 . d decodeDataTypes(sessid)
 . i $$getSessionValue("ewd_jump",sessid)="" d setSessionValue("ewd_nextPage","",sessid) ; reset to prevent looping
 . ;d trace^%zewdAPI("error="_error)
 ;
 i 'prePagePass,error="",$$getSessionValue("ewd_jump",sessid)="" d 
 . i $g(^zewd("trace")) d trace^%zewdAPI("about to run action script : sessid="_sessid_" ; page="_page)
 . d encodeDataTypes(sessid)
 . s error=$$actionScript(sessid)
 . d setSessionValue("error",error,sessid)
 . i error'="" d resetDataTypes(sessid)
 . d deleteFromSession^%zewdAPI("ewd_DataTypeError",sessid)
 . d deleteFromSession^%zewdAPI("ewd_DataType",sessid)
 . ;d trace^%zewdAPI("error="_error)
 ; 
 ; all finished - transfer session global to array, for transfer back to PHP page
 i $g(^zewd("trace")) d trace^%zewdAPI("finishing back-end processing")
 d savePageToken(sessid)
 d getSession(sessid,.sessionArray)
 ;
 d releaseLock(sessid)
 ;d trace^%zewdAPI("final line: error="_error)
 s error=$$escapeError(error,sessid)
 ;m ^rltx($zts,"session")=sessionArray
 ;k ^rltSession m ^rltSession=sessionArray
 ;i $$getSessionValue^%zewdAPI("ewd_pageType",sessid)="ajax" d setSessionValue^%zewdAPI("ewd_ajaxError",error,sessid)
 i $$getSessionValue("ewd_technology",sessid)="jsp" QUIT error
 ;
 i $g(^zewd("trace")) d trace^%zewdAPI("completed. error="_$g(error))
 QUIT $$zcvt(error,"o","JS")
 ;
escapeError(error,sessid)
 ;
 ;d trace^%zewdAPI("error="_error)
 QUIT error
 ;
checkWLDOnlyStart()
 n error
 s error=""
 i $g(sessionArray("ewd_startFromWLDOnly"))=1 d  i error'="" QUIT error
 . q:'$g(sessionArray("ewd_isFirstPage"))
 . q:$$getSessionValue("wld.sessid",sessid)'=""
 . s error="Enterprise Web Developer Error : Illegal attempt to access a page (must be started via WLD)"
 ;
 i $$getSessionValue("wld.sessid",sessid)="" QUIT ""
 ; must be a WLD-started EWD application
 i $$getSessionValue("ewd_pageName",sessid)'="wld" QUIT ""
 ; and has just been started, so the page being called must be a first page!
 i $g(sessionArray("ewd_isFirstPage"))=1 QUIT ""
 s error="Enterprise Web Developer Error : Illegal attempt to access a page (WLD bridge has called a non-first page)"
 ;
 QUIT error
 ;
createNewSession(page,requestArray,sessionArray)
 ;
 n apage,browserType,ewdToken,error,os,sessid
 ;
 ;
 i $g(^%zewd("daemon","use"))="true" d
 . l +^%zewd("daemon","lock"):0 e  QUIT  ; already running
 . l -^%zewd("daemon","lock")
 . j go^%zewdDaemon ; start Daemon
 i $g(^%zewd("daemon","use"))'="true" d deleteExpiredSessions ; delete expired sessions if not using the daemon
 ;
 s error=""
 ;
 ; New session
 ; 
 s sessid=$$createSessid()
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("new session - "_sessid)
 d setLock(sessid,page)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Lock set")
 d initialiseSession^%zewdAPI(sessid)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("session initialised")
 ; merge incoming session and request array contents into session global
 d putSession(sessid,.sessionArray)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("putSession complete")
 ;i $$getSessionValue("ewd_persistRequest",sessid)="true" d putSession(sessid,.requestArray)
 i $$getSessionValue("ewd_persistRequest",sessid)="true" d updateSessionFromRequest(.requestArray,sessid)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Session updated from request")
 ; create new page token and add to session global
 s ewdToken=$$createNewToken(sessid,page)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("ewdToken="_ewdToken)
 ; add session id to session global, and set flags to null to prevent PHP page redirection
 d setSessionValue("ewd_sessid",sessid,sessid)
 d setSessionValue("ewd_action","",sessid)
 d setSessionValue("ewd_nextPage","",sessid)
 d setSessionValue("ewd_date",$$decDate^%zewdAPI($h),sessid)
 d setSessionValue("ewd_time",$$inetTime^%zewdAPI($h),sessid)
 s browserType=$$getBrowser(.serverArray,.os)
 d setSessionValue("ewd.browserType",browserType,sessid)
 d setSessionValue("ewd.browserOS",os,sessid)
 i browserType="iphone" d 
 . d setSessionValue("ewd.touchEvent","ontouchstart",sessid)
 e  d
 . d setSessionValue("ewd.touchEvent","onclick",sessid)
 d autoLoad(sessid) 
  ; run prePage script, if any
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("session "_sessid_" : about to run prepage script")
 s error=$$prePageScript(sessid)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Prepage script completed")
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("synchronisation with WLD completed OK")
 d decodeDataTypes(sessid)
 d setSessionValue("error",error,sessid)
 i $$getSessionValue("ewd_jump",sessid)="" d
 . d saveNextPageTokens(sessid,page)
 ; transfer session global to array, for transfer back to PHP page
 d getSession(sessid,.sessionArray)
 d releaseLock(sessid)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("session "_sessid_" : finished creating new session")
 s error=$$escapeError(error,sessid)
 ;
 QUIT error
 ;
autoLoad(sessid)
 ;
 n appName,method,name,sessidx,value
 ;
 f appName="*",$$getSessionValue("ewd_appName",sessid) d
 . s method=$g(^zewd("autoload",appName,"method"))
 . i method'="" d
 . . s sessidx=sessid
 . . s x="d "_method_"(sessidx)"
 . . d
 . . . n (sessidx,x)
 . . . x x
 f appName="*",$$getSessionValue("ewd_appName",sessid) d
 . s name=""
 . f  s name=$o(^zewd("autoload",appName,"sessionValue",name)) q:name=""  d
 . . s value=^zewd("autoload",appName,"sessionValue",name)
 . . d setSessionValue(name,value,sessid)
 d setSessionValue^%zewdAPI("ewd_autoloaded",1,sessid)
 QUIT
 ;
setLock(sessid,page)
 ;
 n i,stop
 ; set lock to prevent other processes for this sessid sitting in the polling loop
 l +^%zewdSession("lock",sessid)
 ;f i=1:1 q:'$$isLocked(sessid,page)  h .1 q:i>300
 s stop=0
 f i=1:1 d  q:stop  h .1 q:i>300
 . i '$d(^%zewdSession("lock",sessid)) s stop=1 q
 . i ^%zewdSession("lock",sessid)'=page q
 . s stop=1
 s ^%zewdSession("lock",sessid)=page
 l -^%zewdSession("lock",sessid)
 QUIT
 ;
releaseLock(sessid)
 k ^%zewdSession("lock",sessid)
 QUIT
 ;
endOfPage(sessionArray)
 ;
 n sessid
 ;
 s sessid=$g(sessionArray("ewd_sessid"))
 d saveSession(.sessionArray)
 ;d trace^%zewdAPI("in endofpage - sessid="_sessid_" : page="_$$getSessionValue("ewd_latestPage",sessid))
 i sessid'="" d releaseLock(sessid)
 QUIT
 ;
saveSession(sessionArray) ;
 ;
 n sessid
 ;
 s sessid=$g(sessionArray("ewd_sessid"))
 QUIT:sessid=""
 d initialiseSession^%zewdAPI(sessid)
 d putSession(sessid,.sessionArray)
 d saveNextPageTokens(sessid)
 ;
 QUIT
 ;
putSession(sessid,sessionArray)
 ; merges the contents of the PHP session array into the persistent version in Cache
 ;
 n nextPage,submitName
 ;
 m ^%zewdSession("session",sessid)=sessionArray
 ;
 i $g(sessionArray("ewd_translationMode")) d
 . n appName,defLanguage,language,pageName,text,textArray,textid
 . d deleteFromSession^%zewdAPI("ewd_text",sessid)
 . s appName=$$zcvt^%zewdAPI($g(sessionArray("ewd_appName")),"l")
 . s pageName=$$zcvt^%zewdAPI($g(sessionArray("ewd_pageName")),"l")
 . s language=$$getSessionValue^%zewdAPI("ewd_Language",sessid)
 . i language="" s language=$g(requestArray("ewd_Language"))
 . s defLanguage=$$getDefaultLanguage^%zewdCompiler5(appName)
 . i $g(language)="" s language=defLanguage i language="" s language="en"
 . s textid=""
 . f  s textid=$o(^ewdTranslation("pageIndex",appName,pageName,textid)) q:textid=""  d
 . . s text=$g(^ewdTranslation("textid",textid,language))
 . . i text="" s text=$g(^ewdTranslation("textid",textid,defLanguage))
 . . s textArray(textid)=text
 . d mergeArrayToSession^%zewdAPI(.textArray,"ewd_text",sessid)
 . ;d trace^%zewdAPI("completed ewd_text processing")
 ;
 ;k ^rltSession m ^rltSession=sessionArray
 s submitName=""
 f  s submitName=$o(sessionArray("ewd_Action",submitName)) q:submitName=""  d
 . s nextPage=$g(sessionArray("ewd_Action",submitName,"nextpage"))
 . i $e(nextPage,1)="#" s sessionArray("ewd_Action",submitName,"nextpage")=$$getSessionValue($e(nextPage,2,$l(nextPage)),sessid)
 ;
 m ^%zewdSession("action",sessid)=sessionArray("ewd_Action")
 k ^%zewdSession("session",sessid,"ewd_Action")
 ;
 QUIT 
 ;
updateSessionFromRequest(requestArray,sessid)
 ;
 ;d trace^%zewdAPI("in updateSessionFromRequest")
 ;k ^rltRequest m ^rltRequest=requestArray
 n ewdAction,i,invalid,name,nameList,npieces,nvp,rname,sessName,type
 ;
 s ewdAction=$g(requestArray("ewd_action"))
 i ewdAction["zewdSTForm" s requestArray("ewd_action")=""
 ;
 ; prevent attempts to inject malicious code via URLs
 s name=""
 f  s name=$o(requestArray(name)) q:name=""  d
 . q:$g(requestArray(name))=""
 . s nvp=$$zcvt(requestArray(name),"l")
 . i nvp["<script src=",nvp["</script>",((nvp["http://")!(nvp["https://")) d
 . . i $g(^zewd("trace"))=1 d trace^%zewdAPI("XSS attempt (1) detected: nvp="_nvp_"; all request values were deleted")
 . . k requestArray(name)
 . i nvp["<script>",nvp["</script>" d
 . . i $g(^zewd("trace"))=1 d trace^%zewdAPI("XSS attempt (2) detected: nvp="_nvp_"; all request values were deleted")
 . . k requestArray(name)
 ;
 s nameList=""
 i ewdAction'="" s nameList=$g(^%zewdSession("action",sessid,ewdAction,"nameList"))
 i nameList="" d
 . n actionName,nl
 . s actionName=""
 . f  s actionName=$o(^%zewdSession("action",sessid,actionName)) q:actionName=""  d
 . . s nl=$g(^%zewdSession("action",sessid,actionName,"nameList"))
 . . i nl[(actionName_"$") s ewdAction=actionName,nameList=nl
 i page="json" s nameList("ewd_JSONSource")=""
 i nameList'="" d
 . s npieces=$l(nameList,"`")-1
 . f i=1:1:npieces d
 . . k name
 . . s name=$p(nameList,"`",i)
 . . s type=$p(name,"|",2)
 . . s name=$p(name,"|",1)
 . . s sessName=$tr(name,".","_")
 . . s rname=name
 . . i type="textarea",'$d(^%zewdSession("session",sessid,"ewd_textarea",sessName)) s ^%zewdSession("session",sessid,"ewd_textarea",sessName)=""
 . . s nameList(rname)=type
 . . i type="checkbox",$o(requestArray(rname,""))="" d
 . . . n value
 . . . s value=$g(requestArray(rname))
 . . . s:value'="" requestArray(rname,value)=value
 . . i type="select",$g(requestArray(rname))="nul" s requestArray(rname)=""
 . . d clearSelected^%zewdAPI(name,sessid)
 . f name="ewd_action","ewd_token","ewd_pressed" s nameList(name)=""
 i $g(requestArray("ewd_urlNo"))'="" d
 . n urlNo
 . s urlNo=requestArray("ewd_urlNo")
 . s nameList=""
 . i urlNo'="" s nameList=$g(^%zewdSession("session",sessid,"ewd_urlNameList",urlNo))
 . s npieces=$l(nameList,"`")-1
 . i npieces>0 f i=1:1:npieces s nameList($p(nameList,"`",i))=""
 . f name="ewd_token","n" s nameList(name)=""
 ;
 ;m ^rltx($zts,"nameList")=nameList
 ;m ^rltx($zts,"requestArray")=requestArray
 s name=""
 f  s name=$o(requestArray(name)) q:name=""  d
 . ;d trace^%zewdAPI("checking "_name_" if allowed")
 . s invalid=0
 . i $g(requestArray(name))'="" d  q:invalid
 . . s nvp=$$zcvt(requestArray(name),"l")
 . . ; prevent attempts to inject malicious code via URLs
 . . i nvp["<script>",nvp["</script>",((nvp["http://")!(nvp["https://")) d
 . . . i $g(^zewd("trace"))=1 d trace^%zewdAPI("XSS attempt (3) detected: nvp="_nvp_"; all request values were deleted")
 . . . s invalid=1
 . i '$$allowed(name,.nameList,sessid) q
 . ;d trace^%zewdAPI("allowed name "_name)
 . ;  textareas
 . s sessName=$tr(name,".","_")
 . i $d(^%zewdSession("session",sessid,"ewd_textarea",sessName)) d  q
 . . n line,lineNo,lvl2,text,nlines,recNo,startNo,textarray,i,technology
 . . s technology=$$getSessionValue("ewd_technology",sessid)
 . . k ^%zewdSession("session",sessid,"ewd_textarea",sessName)
 . . s lvl2=$o(requestArray(name,""))
 . . i lvl2="" s lvl2=0
 . . i $g(requestArray(name))'="" s requestArray(name,lvl2,0)=requestArray(name)
 . . s recNo="",lineNo=0
 . . f  s recNo=$o(requestArray(name,lvl2,recNo)) q:recNo=""  d
 . . . s text=$g(requestArray(name,lvl2,recNo))
 . . . s text=$$replaceAll(text,$c(13,10),$c(13))
 . . . s text=$tr(text,$c(10),$c(13))
 . . . s nlines=$l(text,$c(13))
 . . . f i=1:1:nlines d
 . . . . s line=$p(text,$c(13),i)
 . . . . s lineNo=lineNo+1
 . . . . s textarray(lineNo)=line
 . . ;f i=nlines:-1:1 q:textarray(i)'=""  k textarray(i) s nlines=nlines-1
 . . f i=lineNo:-1:1 q:textarray(i)'=""  k textarray(i) s lineNo=lineNo-1
 . . m ^%zewdSession("session",sessid,"ewd_textarea",sessName)=textarray
 . . ;s ^%zewdSession("session",sessid,"ewd_textarea",sessName,0)=nlines
 . . s ^%zewdSession("session",sessid,"ewd_textarea",sessName,0)=lineNo
 . ; multi-valued fields
 . i $o(requestArray(name,""))'="" d  q
 . . n pos,fieldValue
 . . s pos=""
 . . f  s pos=$o(requestArray(name,pos)) q:pos=""  d
 . . . k fieldValue
 . . . i $d(requestArray(name,pos))'=10 d
 . . . . s fieldValue=$g(requestArray(name,pos))
 . . . . d addToSelected^%zewdAPI(name,fieldValue,sessid)
 . ;d trace^%zewdAPI("sessionValue name="_name_" ;value="_requestArray(name))
 . d setSessionValue(name,requestArray(name),sessid)
 . i $g(nameList(name))="stdate" d processDate^%zewdST2(name,requestArray(name),sessid)
 ;
 i $g(requestArray("ewdAjaxSubmit"))=1 d
 . f name="ewd_action","ewd_nextPage","ewd_pressed" d setSessionValue(name,requestArray(name),sessid)
 i $g(requestArray("ewd_Language"))'="" d setSessionValue("ewd_Language",requestArray("ewd_Language"),sessid)
 ;
 i $e(ewdAction,1,10)="ewdExtForm" d deleteFromSession^%zewdAPI("ewd_action",sessid)
 ;
 QUIT
 ;
allowed(fieldName,nameList,sessid)
 ;
 ;d trace^%zewdAPI("in allowed - fieldName="_fieldName_" ; $d(nameList(fieldName))="_$d(nameList(fieldName)))
 i $$getSessionValue("ewd_passAll",sessid)=1 QUIT 1
 QUIT $d(nameList(fieldName))
 ;
createNewToken(sessid,page)
 ;
 n ewdToken,prevPage
 ;
 s ewdToken=$$createToken(sessid,page)
 s prevPage=$$getSessionValue("ewd_latestPage",sessid)
 d setSessionValue("ewd_latestPage",page,sessid)
 i prevPage'="" d setSessionValue("ewd_previousPage",prevPage,sessid)
 QUIT ewdToken
 ;
createToken(sessid,page)
 ;
 n defaultTimeout,expires,i,length,now,parentSession,string,stringLength,timeout,token
 ;
 l +^%zewd("token") 
 ;
 s string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
 s page=$g(page)
 i page["/" d
 . n pager
 . s pager=$re(page)
 . s pager=$p(pager,"/",1)
 . s page=$re(pager)
 . s page=$p(page,".",1)
 s length=$$getSessionValue("ewd_sessid_length",sessid)
 i length="" s length=30
 s defaultTimeout=$$getSessionValue("ewd_default_timeout",sessid)
 i defaultTimeout="" s defaultTimeout=1200
 s timeout=$$getSessionValue("ewd_sessid_timeout",sessid)
 i timeout="" s timeout=defaultTimeout
 s token=""
 f  d  q:'$d(^%zewdSession("tokens",token))
 . f i=1:1:length s token=token_$e(string,($r($l(string))+1))
 s now=$$convertDateToSeconds($h)
 s expires=now+timeout
 s ^%zewdSession("tokens",token)=sessid_"~"_now_"~"_expires_"~"_$g(page)
 s ^%zewdSession("tokensBySession",sessid,token)=""
 d setSessionValue("ewd_sessionExpiry",expires,sessid)
 s parentSession=$$getSessionValue^%zewdAPI("ewd_parentSession",sessid)
 i parentSession'="" d setSessionValue("ewd_sessionExpiry",expires,parentSession)
 d setSessionValue("ewd_token",token,sessid)
 l -^%zewd("token")
 QUIT token
 ;
deleteJump(sessid)
 d deleteFromSession^%zewdAPI("ewd_jump",sessid)
 QUIT
 ;
processMenuOptions(sessid) ;
 ;
 n opt,func,grey
 ;
 s opt=""
 f  s opt=$o(^%zewdSession("session",sessid,"ewd_menuOption",opt)) q:opt=""  d
 . k func,grey
 . s func=^%zewdSession("session",sessid,"ewd_menuOption",opt)
 . i func="" QUIT
 . i $e(func,1,2)'="$$",$e(func,1,2)'="##" s func="$$"_func
 . s func="s grey="_func
 . x func
 . s ^%zewdSession("session",sessid,"ewd_menuOption",opt)=grey
 ;
 QUIT
 ;
saveNextPageTokens(sessid,page)
 ;
 n token,thePage
 s page=$g(page)
 i page["/" d
 . n pager
 . s pager=$re(page)
 . s pager=$p(pager,"/",1)
 . s page=$re(pager)
 . s page=$p(page,".",1)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("in saveNextPageTokens: sessid="_sessid)
 s token=""
 f  s token=$o(^%zewdSession("session",sessid,"ewd_NextPage",token)) q:token=""  d
 . s thePage=""
 . f  s thePage=$o(^%zewdSession("session",sessid,"ewd_NextPage",token,thePage)) q:thePage=""  d
 . . s thePage=$$zcvt(thePage,"L")
 . . i $g(^zewd("trace"))=1 d trace^%zewdAPI("nextpage token created: sessid="_sessid_"; token="_token_"thePage="_thePage)
 . . s ^%zewdSession("nextPageTokens",sessid,token,thePage)=""
 . . ;s ^%zewdSession("nextPageTokens",sessid,token)=^%zewdSession("session",sessid,"ewd_NextPage",token)_"~"_page
 k ^%zewdSession("session",sessid,"ewd_NextPage")
 QUIT
 ;
createNextPageToken(nextPage,sessid)
 ;
 n token
 s token=$$createToken(sessid)
 ;s ^%zewdSession("nextPageTokens",sessid,token)=nextPage
 s nextPage=$$zcvt(nextPage,"L")
 i nextPage="" QUIT token
 s ^%zewdSession("nextPageTokens",sessid,token,nextPage)=""
 QUIT token
 ;
prePageScript(sessid)
 ;
 n appName,x,error,io,method
 ;
 s io=$io
 ;d trace^%zewdAPI("running prepage script")
 s appName=$$getSessionValue^%zewdAPI("ewd_appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s error=""
 s method=$$getSessionValue("ewd_templatePrePageScript",sessid)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("templatePrePageScript method="_method)
 i method'="" d
 . s x="s error=$$"_method_"(sessid)"
 . ;s $zt="zg "_$zl_":prePageError^%zewdPHP"
 . ; note: don't drop a do level in the next 2 lines!
 . i $g(^zewd("config","customErrorTrap",appName))'="" s $zt="zg "_$zl_":"_^zewd("config","customErrorTrap",appName)
 . e  s $zt="zg "_$zl_":prePageError^%zewdPHP"
 . x x
 . u io
 ;
 s $zt="errorTrap^%zewdPHP"
 s method=$$getSessionValue("ewd_prePageScript",sessid)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("PrePageScript method="_method)
 i method="" QUIT ""
 i $e(method,1)="$" QUIT method  ; pre-page script is a PHP function, not a Cache one!
 i $e(method,1,3)="py:" QUIT $$runPythonScript^%zewdPython(method,sessid)
 s x="s error=$$"_method_"(sessid)"
 ;s $zt="zg "_$zl_":prePageError^%zewdPHP"
 i $g(^zewd("config","customErrorTrap",appName))'="" d
 . s $zt="zg "_$zl_":"_^zewd("config","customErrorTrap",appName)
 e  d
 . s $zt="zg "_$zl_":prePageError^%zewdPHP" 
 i $g(^zewd("trace")) d trace^%zewdAPI("About to execute prepage script: x="_x)
 x x
 u io
 s $zt="g errorTrap^%zewdPHP"
 i $g(^zewd("trace")) d trace^%zewdAPI("Prepage script completed. error="_$g(error))
 QUIT error
 ;
actionScript(sessid)
 ;
 n actionName,error,io,method,nextPage,token,x
 ;
 s $zt="g errorTrap^%zewdPHP"
 s io=$io
 d deleteFromSession^%zewdAPI("ewd_errorFields",sessid)
 d deleteFromSession^%zewdAPI("ewd_hasErrors",sessid)
 s actionName=$$getSessionValue("ewd_action",sessid)
 ;d trace^%zewdAPI("actionName="_actionName)
 s method="",nextPage="",token=""
 i actionName'="" d
 . s method=$g(^%zewdSession("action",sessid,actionName,"method"))
 . s nextPage=$g(^%zewdSession("action",sessid,actionName,"nextpage"))
 . i $e(nextPage,1)="#" d
 . . s nextPage=$e(nextPage,2,$l(nextPage))
 . . ;d trace^%zewdAPI("nextPage="_nextPage)
 . . s nextPage=$$getSessionValue(nextPage,sessid)
 . . ;d trace^%zewdAPI("session value of nextpage="_nextPage)
 . s token=$g(^%zewdSession("action",sessid,actionName,"token"))
 d setSessionValue("ewd_nextPage",nextPage,sessid)
 d setSessionValue("ewd_pageToken",token,sessid)
 i $e(method,1)="$" d  QUIT method  ; action script is a PHP function, not a Cache one!
 . d setSessionValue("ewd_action","",sessid)
 ;
 ;d trace^%zewdAPI("method="_method)
 ;d trace^%zewdAPI("nextpage="_nextPage)
 ;d trace^%zewdAPI("token="_token)
 s error=""
 i method="" d setSessionValue("ewd_action","",sessid) QUIT ""
 ;
 ;
 i $e(method,1,3)="py:" d  QUIT error
 . i $g(^zewd("trace")) d trace^%zewdAPI("about to run action script: method="_method)
 . s error=$$runPythonScript^%zewdPython(method,sessid)
 . d setSessionValue("ewd_action","",sessid)
 s x="s error=$$"_method_"(sessid)"
 s $zt="zg "_$zl_":actionError^%zewdPHP"
 i $g(^zewd("trace")) d trace^%zewdAPI("about to run action script: x="_x)
 x x
 u io
 s $zt="g errorTrap^%zewdPHP"
 i error="",$$getSessionValue^%zewdAPI("ewd.pageName",sessid)="zextDesktopLoginForm" d
 . n token
 . s token=$$createToken(sessid,"zextDesktopLoginForm")
 . d setSessionValue^%zewdAPI("ewd.sso",token,sessid)
 d setSessionValue("ewd_action","",sessid)
 i $g(^zewd("trace")) d trace^%zewdAPI("action script completed : error="_error)
 i error'="" d
 s $zt="g errorTrap^%zewdPHP"
 . s method=$$getSessionValue("ewd_onErrorScript",sessid)
 . i method'="" d
 . . s x="s ok=$$"_method_"(sessid)"
 . . s $zt="zg "_$zl_":actionError^%zewdPHP"
 . . x x
 . . u io
 ;
 QUIT error
 ;
savePageToken(sessid)
 ;
 n token,nextPage
 ;
 s token=$g(^%zewdSession("session",sessid,"ewd_pageToken"))
 q:token=""
 s nextPage=$g(^%zewdSession("session",sessid,"ewd_nextPage"))
 q:nextPage=""
 s nextPage=$$zcvt(nextPage,"L")
 s ^%zewdSession("nextPageTokens",sessid,token,nextPage)=""
 ;s $p(^%zewdSession("nextPageTokens",sessid,token),"~",1)=nextPage
 k ^%zewdSession("session",sessid,"ewd_NextPage")
 QUIT
 ;
getSession(sessid,sessionArray)
 ; sends a new, updated copy of the persistent session back into PHP
 k sessionArray
 m sessionArray=^%zewdSession("session",sessid)
 m sessionArray=zewdSession ; tmp_* names
 k sessionArray("ewd_listIndex") ; not needed on PHP-side
 k sessionArray("ewd_urlNameList") ; not needed on PHP-side
 k sessionArray("ewd_serverSide") ; don't send stuff that is Cache-side only persistent data
 QUIT 
 ;
deleteExpiredSessions
 ;
 n sessid,expiry,xsessid
 ;
 d deleteExpiredTokens
 s sessid=""
 f  s sessid=$o(^%zewdSession("session",sessid)) q:sessid=""  d
 . s expiry=$$getSessionValue("ewd_sessionExpiry",sessid)
 . i expiry<$$convertDateToSeconds($h) d deleteSession(sessid)
 s sessid=""
 f  s sessid=$o(^%zewdSession("lock",sessid)) q:sessid=""  d
 . i '$d(^%zewdSession("session",sessid)) k ^%zewdSession("lock",sessid)
 ;
 s sessid=""
 f  s sessid=$o(^%zewdSession("nextPageTokens",sessid)) q:sessid=""  d
 . q:$e(sessid,1,4)'="csp:"
 . s xsessid=$e(sessid,5,$l(sessid))
 . i '$d(^%cspSession(xsessid)) k ^%zewdSession("nextPageTokens",sessid)
 ;
 s sessid=""
 f  s sessid=$o(^%zewdSession("jsonAccess",sessid)) q:sessid=""  d
 . q:$e(sessid,1,4)'="csp:"
 . s xsessid=$e(sessid,5,$l(sessid))
 . i '$d(^%cspSession(xsessid)) k ^%zewdSession("jsonAccess",sessid)
 ;
 QUIT
 ;
createSessid()
 QUIT $increment(^%zewd("nextSessid"))
 ;
isLocked(sessid,page)
 ; is the lock set at all?
 i '$d(^%zewdSession("lock",sessid)) QUIT 0
 ; does another page have the lock set?
 i ^%zewdSession("lock",sessid)'=page QUIT 1
 ; current page has the lock so treat as if unlocked
 QUIT 0
 ;
deleteExpiredTokens
 ;
 n token
 ;
 s token=""
 f  s token=$o(^%zewdSession("tokens",token)) q:token=""  d
 . i $$isTokenExpired(token) d deleteToken(token)
 ;
 Q
 ;
deleteSession(sessid)
 ;
 n token
 ;
 s token=""
 f  s token=$o(^%zewdSession("tokensBySession",sessid,token)) q:token=""  d
 . d deleteToken(token)
 ;
 k ^%zewdSession("session",sessid)
 k ^%zewdSession("nextPageTokens",sessid)
 k ^%zewdSession("action",sessid)
 k ^%zewdSession("jsonAccess",sessid)
 QUIT
 ;
deleteToken(token)
 ;
 n sessid
 ;
 s sessid=+$g(^%zewdSession("tokens",token))
 QUIT:sessid=0
 k ^%zewdSession("tokens",token)
 k ^%zewdSession("tokensBySession",sessid,token)
 QUIT
 ;
decodeDataTypes(sessid)
 ;
 n dataTypeList,pageName,fieldName,dataType
 ;
 d mergeArrayFromSession^%zewdAPI(.dataTypeList,"ewd_DataType",sessid)
 s pageName=$$getSessionValue("ewd_pageName",sessid)
 q:pageName=""
 s fieldName=""
 f  s fieldName=$o(dataTypeList(pageName,fieldName)) q:fieldName=""  d
 . s dataType=dataTypeList(pageName,fieldName)
 . d decodeDataType^%zewdAPI(fieldName,dataType,sessid)
 ;
 QUIT
 ;
encodeDataTypes(sessid)
 ;
 n dataTypeList,pageName,fieldName,dataType,error
 ;
 d mergeArrayFromSession^%zewdAPI(.dataTypeList,"ewd_DataType",sessid)
 s pageName=$$getSessionValue("ewd_pageName",sessid)
 s fieldName=""
 f  s fieldName=$o(dataTypeList(pageName,fieldName)) q:fieldName=""  d
 . s dataType=dataTypeList(pageName,fieldName)
 . s error=$$encodeDataType^%zewdAPI(fieldName,dataType,sessid) i error'="" s error(fieldName)=error
 d deleteFromSession^%zewdAPI("ewd_DataTypeError",sessid)
 d mergeArrayToSession^%zewdAPI(.error,"ewd_DataTypeError",sessid)
 ;
 QUIT
 ;
resetDataTypes(sessid)
 ;
 n dataTypeList,pageName,fieldName,dataType,error
 ;
 d mergeArrayFromSession^%zewdAPI(.error,"ewd_DataTypeError",sessid)
 d mergeArrayFromSession^%zewdAPI(.dataTypeList,"ewd_DataType",sessid)
 s pageName=$$getSessionValue("ewd_pageName",sessid)
 s fieldName=""
 f  s fieldName=$o(dataTypeList(pageName,fieldName)) q:fieldName=""  d
 . s dataType=dataTypeList(pageName,fieldName)
 . i $g(error(fieldName))="" d decodeDataType^%zewdAPI(fieldName,dataType,sessid)
 ;
 QUIT
 ;
getStack
 ;
 n level,line
 ;
 k ^%zewdError(sessid,"stack")
 f level=1:1:$STACK(-1) d
 . s line(1)="Level "_level_" : "_$STACK(level)
 . s line(2)=$STACK(level,"PLACE")
 . s line(3)=$STACK(level,"MCODE")
 . f i=1:1:3 s ^%zewdError(sessid,"stack",level,i)=line(i)
 QUIT
 ;
prePageError ;
 s $zt=""
 n %loop,%place,%sessid,%stop,ze,%ze
 n error
 ;
 s sessid=+$g(sessid)
 k ^%zewdError(sessid)
 d saveSymbolTable^%zewdAPI(sessid)
 ;s ok=$zu(160,1,"^%zewdError("_sessid_",""symbolTable"")")
 m ^%zewdError(sessid,"session")=^%zewdSession("session",sessid)
 ;
 i sessid'=0 d releaseLock(sessid)
 s ze="Missing or invalid pre-page script call : "_$g(x)
 s error="Enterprise Web Developer Error : "
 i sessid>0 s error=error_"Session "_sessid
 e  s error=error_" Unknown Session ID"
 s %ze=$zstatus
 s %ze=$$replaceAll^%zewdHTMLParser(%ze,"<","&lt;")
 s %ze=$$replaceAll^%zewdHTMLParser(%ze,">","&gt;")
 s $p(^%zewdError(sessid)," : ",1)=%ze
 s error=error_"<br><br>"_ze_"<br>"_%ze
 i $ze["<COMMAND>" s error=error_"<br>Possibly because your pre-page script QUITs without a return string<br>"
 d setSessionValue("ewd_action","",sessid)
 d customError(sessid,.sessionArray)
 QUIT error
 ;
actionError ;
 s $zt=""
 ;n error,%loop,%place,%sessid,%stop,ze,%ze
 n %loop,%place,%sessid,%stop,ze,%ze
 n error
 s sessid=+$g(sessid)
 s sessidx=sessid_":"_$h
 k ^%zewdError(sessid)
 d saveSymbolTable^%zewdAPI(sessid)
 ;s ok=$zu(160,1,"^%zewdError("_sessid_",""symbolTable"")")
 m ^%zewdError(sessid,"session")=^%zewdSession("session",sessid)
 ;m ^%zewdError(sessidx,"session")=^%zewdSession("session",sessid)
 i sessid'=0 d releaseLock(sessid)
 s ze="Missing or invalid action script call : "_$g(x)
 s error="Enterprise Web Developer Error : "
 i sessid>0 s error=error_"Session "_sessid
 e  s error=error_" Unknown Session ID"
 s %ze=$zstatus
 s %ze=$$replaceAll^%zewdHTMLParser(%ze,"<","&lt;")
 s %ze=$$replaceAll^%zewdHTMLParser(%ze,">","&gt;")
 s error=error_"<br><br>"_ze_"<br>"_%ze_"<br>"
 i $ze["<COMMAND>" s error=error_"<br>Possibly because your action script QUITs without a return string<br>"
 d setSessionValue("ewd_action","",sessid)
 s ^%zewdError(sessid)=%ze
 ;s ^%zewdError(sessidx)=%ze
 d customError(sessid,.sessionArray)
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("finishing error trap - error="_$g(error))
 QUIT error
 ;
errorTrap ;
 s $zt=""
 n error,%loop,%place,%sessid,%stop,ze
 i $g(^zewd("trace")) d trace^%zewdAPI("In errorTrap: sessid="_$g(sessid)_"; ze="_$zstatus)
 s sessid=+$g(sessid)
 k ^%zewdError(sessid)
 d saveSymbolTable^%zewdAPI(sessid)
 ;s ok=$zu(160,1,"^%zewdError("_sessid_",""symbolTable"")")
 m ^%zewdError(sessid,"session")=^%zewdSession("session",sessid)
 i sessid'=0 d releaseLock(sessid)
 s ze=$zstatus
 s ze=$$replaceAll^%zewdHTMLParser(ze,"<","&lt;")
 s ze=$$replaceAll^%zewdHTMLParser(ze,">","&gt;")
 s error="Enterprise Web Developer Error : "
 i sessid>0 s error=error_"Session "_sessid
 e  s error=error_" Unknown Session ID"
 s error=error_"<br><br>"_ze
 d setSessionValue("ewd_action","",sessid)
 s ^%zewdError(sessid)=ze
 d customError(sessid,.sessionArray)
 QUIT error
 ;
eventErrorTrap ;
 s $zt=""
 n error,%loop,%place,%sessid,%stop,ze
 s sessid=+$g(sessid)
 k ^%zewdError(sessid)
 d saveSymbolTable^%zewdAPI(sessid)
 ;s ok=$zu(160,1,"^%zewdError("_sessid_",""symbolTable"")")
 m ^%zewdError(sessid,"session")=^%zewdSession("session",sessid)
 i sessid'=0 d releaseLock(sessid)
 s ze=$zstatus
 s ze=$$replaceAll^%zewdHTMLParser(ze,"<","&lt;")
 s ze=$$replaceAll^%zewdHTMLParser(ze,">","&gt;")
 s ze="alert('An error has occurred : "_ze_"') ;"
 s ^%zewdError(sessid)=ze
 d customError(sessid,.sessionArray)
 QUIT ze
 ;
customError(sessid,sessionArray)
 ;
 n appName,x
 ;
 d getSession(sessid,.sessionArray)
 ;k ^rltm m ^rltm=sessionArray
 s appName=$$getSessionValue("ewd_appName",sessid)
 QUIT:appName=""
 i $g(^zewd("errorProcessing",appName))'="" d
 . s x="d "_^zewd("errorProcessing",appName)
 . x x
 QUIT
 ;
closeSession(requestArray) ;
 ;
 n token,sessid,homePage
 ;
 s token=$g(requestArray("ewd_token"))
 i token="" QUIT "No token sent in request"
 s sessid=+$g(^%zewdSession("tokens",token)) ;$$getSessid(token)
 ;d trace^%zewdAPI("closing down session "_sessid)
 i sessid=0 QUIT "/default.htm"  ;Invalid token or session timed out"
 s homePage=$$getSessionValue("ewd_homePage",sessid)
 i homePage="" s homePage="/default.htm"
 i $e(homePage,2)="$$" s homePage=@homePage
 d deleteSession(sessid)
 ;d trace^%zewdAPI("homepage="_homePage)
 QUIT homePage
 ;
event(requestArray)
 ;
 n responseString,token,eventID,nvpList,sessid,sessString,method,x,paramNo
 ;
 s token=$g(requestArray("ewd_token"))
 s eventID=$g(requestArray("ewd_eventID"))
 s request=$g(requestArray("ewd_request"))
 ;
 ;k ^rlt m ^rlt=requestArray
 s sessid=$$getSessid(token)
 i sessid="" QUIT "alert('invalid token or session has timed out')"
 ;
 s method=$g(^%zewdSession("action",sessid,eventID,"method"))
 i method="" QUIT "alert('invalid method identifier')"
 ;
 s sessString=""
 i method["class(" d
 . i $e(method,1,2)'="##" s method="##"_method
 . s x="s responseString="_method_"("
 . s sessString="sessid"
 e  d
 . s x="s responseString=$$"_method_"("
 i '$d(requestArray("ewd_Param",1)) d
 . s x=x_sessString_")"
 e  d
 . s paramNo=""
 . i method["class(" s sessString=","_sessString
 . f  s paramNo=$o(requestArray("ewd_Param",paramNo)) q:paramNo=""  d
 . . s x=x_""""_$$doubleQuotes^%zewdAPI(requestArray("ewd_Param",paramNo))_""""_","
 . s x=$e(x,1,$l(x)-1)_sessString_")"
 s $zt="zg "_$zl_":eventErrorTrap^%zewdPHP"
 i $g(^zewd("trace")) d trace^%zewdAPI("Event broker call invocation: x="_x)
 x x
 ;
 QUIT responseString
 ;
jsEscape(%string) ; Simulate the JavaScript escape() function to convert escape sequences
 ;
 n %buf,%c,%a,%h,%outstring,%i
 ;
 s %buf=%string
 s %outstring=""
 f %i=1:1:$l(%buf) d
 . s %c=$e(%buf,%i)
 . s %a=$a(%c)
 . i (%a>47),(%a<58) s %outstring=%outstring_%c QUIT
 . i (%a>64),(%a<91) s %outstring=%outstring_%c QUIT
 . i (%a>96),(%a<123) s %outstring=%outstring_%c QUIT
 . i (%a>127) s %outstring=%outstring_"%u0"_$$FUNC^%DH(%a+1264,3) QUIT 
 . i %a=37 n %quit DO  QUIT:%quit=2  ; --- Check to bypass an encoded character for: %xx ---
 . . n codeup,%ii
 . . s %quit=0
 . . s codeup=$$zcvt($e(%buf,%i+1,%i+2),"u")
 . . QUIT:$l(codeup)'=2  ; No code follows...
 . . f %ii=1:1:2 i "0123456789ABCDEF"[$e(codeup,%ii) s %quit=%quit+1
 . . s:codeup=26 codeup="05"  ; Special character used as a placeholder for ampersand &
 . . s:codeup="3D" codeup="06"  ; Special character used as a placeholder for equal-sign =
 . . i %quit=2 s %outstring=%outstring_%c_codeup,%i=%i+2  ; Found Code so Skip It!!
 . S %h=$$FUNC^%DH(%a,2)
 . i $l(%h)=1 s %h="0"_%h
 . S %outstring=%outstring_"%"_%h
 QUIT %outstring
 ;
normaliseRequestArray(requestArray,sessionArray)
 ;
 ; fix PHP version 4.x problem
 ; and normalise VB.Net checkbox request values
 ;
 n ref,technology,value
 ;
 s ref="requestArray("""")"
 f  s ref=$q(@ref) q:ref=""  d
 . s value=$g(@ref)
 . i value["\\" d
 . s value=$$replaceAll(value,"\\",$c(3))
 . s value=$$replaceAll(value,$c(3),"\")
 . s @ref=value
 ;
 s technology=$g(sessionArray("ewd_technology"))
 ;
 QUIT
 ;
setidList(sessionArray)
 ;
 n idList,sessid
 ;
 s sessid=$g(sessionArray("ewd_sessid"))
 d deleteFromSession^%zewdAPI("ewd_idList",sessid)
 m idList=sessionArray("ewd_idList")
 d mergeArrayToSession^%zewdAPI(.idList,"ewd_idList",sessid)
 QUIT ""
 ;
setidList2(idList,sessid)
 ;
 d deleteFromSession^%zewdAPI("ewd_idList",sessid)
 d mergeArrayToSession^%zewdAPI(.idList,"ewd_idList",sessid)
 QUIT ""
 ;
getBrowser(serverArray,os)
 QUIT $$getBrowserType($g(serverArray("HTTP_USER_AGENT")),.os)
 ;
getBrowserOS(browserSignature)
 n bt,os
 s bt=$$getBrowserType(browserSignature,.os)
 QUIT os
 ;
getBrowserType(browserSignature,os)
 ;
 n dev,ie
 ;
 s os="other"
 s browserSignature=$$zcvt(browserSignature)
 i browserSignature["windows nt 5.0" s os="windows 2000"
 i browserSignature["windows nt 5.1" s os="windows xp"
 i browserSignature["windows nt 5.2" s os="windows 2003"
 i browserSignature["windows nt 6.0" s os="windows vista"
 i browserSignature["mac os x" s os="mac osx"
 i browserSignature["linux" s os="linux"
 ;
 i browserSignature["android" d  QUIT dev
 . s dev="androidphone"
 . i browserSignature["P1000" s dev="androidtablet"
 i browserSignature["iphone" QUIT "iphone"
 i browserSignature["ipod" QUIT "iphone"
 i browserSignature["ipad" QUIT "ipad"
 i browserSignature["opera" QUIT "opera"
 i browserSignature["safari" QUIT "safari"
 i browserSignature["firefox" QUIT "firefox"
 i browserSignature["msie" d  QUIT ie
 . s ie=$p(browserSignature,"msie",2)
 . s ie=$$stripLeadingSpaces(ie)
 . s ie="ie"_+ie
 QUIT "other"
 ;
 ;  -----------------------------------------------------------
 ;  Duplicate API methods - copied here for performance reasons
 ;  -----------------------------------------------------------
 ;
isCSP(sessid)
 QUIT $e(sessid,1,4)="csp:"
 ;
isTemp(name)
 QUIT $e(name,1,4)="tmp_"
 ;
setSessionValue(name,value,sessid)
 ;
 s name=$$stripSpaces(name)
 i $g(name)="" QUIT
 i $g(sessid)="" QUIT
 i name["." d  QUIT
 . n np,obj,prop
 . s np=$l(name,".")
 . s obj=$p(name,".",1,np-1)
 . s prop=$p(name,".",np)
 . d setSessionObject(obj,prop,value,sessid)
 s value=$g(value)
 i $e(name,1,4)="tmp_" s zewdSession(name)=value QUIT
 s ^%zewdSession("session",sessid,name)=value
 QUIT
 ;
stripSpaces(string)
 s string=$$stripLeadingSpaces(string)
 QUIT $$stripTrailingSpaces(string)
 ;
stripLeadingSpaces(string)
 n i
 ;
 f i=1:1:$l(string) QUIT:$e(string,i)'=" "
 QUIT $e(string,i,$l(string))
 ;
stripTrailingSpaces(string)
 n i,spaces,new
 ;
 s spaces=$$makeString(" ",100)
 s new=string_spaces
 QUIT $p(new,spaces,1)
 ;
makeString(%char,%len) ; create a string of len characters
 ;
 n %str
 ;
 s %str="",$p(%str,%char,%len+1)=""
 QUIT %str
 ;
useCSPSessionGlobal()
 QUIT 1
 ;
getSessionValue(name,sessid)
 ;
 n %zt,return,value
 ;
 s name=$$stripSpaces(name)
 s %zt=$zt
 i $g(name)="" QUIT ""
 i $g(sessid)="" QUIT ""
 i name["." d  QUIT value
 . n np,obj,prop
 . s np=$l(name,".")
 . s obj=$p(name,".",1,np-1)
 . s prop=$p(name,".",np)
 . s value=$$getSessionObject(obj,prop,sessid)
 ;s $zt="extcErr"
 ;i $r(100)<10 i '$$$licensed("DOM",,,,,,,,,,) d setWarning("You do not have a current eXtc License",sessid)
 ;i $$isTemp(name) d  QUIT value
 i $e(name,1,4)="tmp_" d  QUIT value
 . s value=$g(zewdSession(name))
 . i value="" d
 . . n ewdTech
 . . s ewdTech=$g(^%zewdSession("session",sessid,"ewd_technology"))
 . . i ewdTech="wl"!(ewdTech="gtm")!(ewdTech="ewd") s value=$g(sessionArray(name))
 QUIT $g(^%zewdSession("session",sessid,name))
 ;
getSessionObject(objectName,propertyName,sessid)
    ;
    n i,np,value,x
    ;
    i $g(sessid)="" QUIT ""
    s value=""
    s np=$l(objectName,".")
    i objectName["." s objectName=$p(objectName,".",1)_"_"_$p(objectName,".",2,2000)
    ;s objectName=$$replace(objectName,".","_")
    i np=1 QUIT $g(^%zewdSession("session",sessid,(objectName_"_"_propertyName)))
    ;
    f i=1:1:np-1 s p(i)=$p(objectName,".",i)
    s x="s value=$g(^%zewdSession(""session"","_sessid
    f i=1:1:np-1 s x=x_","""_p(i)_""""
    s x=x_","""_propertyName_"""))"
    x x
    QUIT value
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
valueErr ;
 s $zt=%zt
 QUIT ""
 ;
setSessionObject(objectName,propertyName,propertyValue,sessid)
	;
	n comma,i,np,p,sessionArray,x
	;
	i $g(objectName)="" QUIT
	i $g(propertyName)="" QUIT
	;i $g(propertyValue)="" QUIT
	i $g(sessid)="" QUIT
    s np=$l(objectName,".")
    s objectName=$$replace(objectName,".","_")
    i np=1 d  QUIT
	. i $e(objectName,1,3)="tmp" s zewdSession(objectName_"_"_propertyName)=propertyValue  q
	. s ^%zewdSession("session",sessid,(objectName_"_"_propertyName))=propertyValue
    ;
    f i=1:1:np-1 s p(i)=$p(objectName,".",i)
    s comma=","
    i $$isTemp(objectName) d
    . s x="s zewdSession(",comma=""
	e  d
    . s x="s ^%zewdSession(""session"","_sessid
    f i=1:1:np-1 s x=x_comma_""""_p(i)_"""",comma=","
    ; double-up any quotes that may be inside the value string
    i propertyValue["""" s propertyValue=$$replaceAll^%zewdAPI(propertyValue,"""","""""")
    s x=x_","""_propertyName_""")="""_propertyValue_""""
    x x
    QUIT
	;
convertSecondsToDate(secs)
 QUIT (secs\86400)_","_(secs#86400)
 ;
convertDateToSeconds(hdate)
 Q (hdate*86400)+$p(hdate,",",2)
 ;
getTokenExpiry(token)
 ;
 n sessid
 ;
 i $g(token)="" QUIT 0
 s sessid=$p($g(^%zewdSession("tokens",token)),"~",1)
 i sessid="" QUIT 0
 QUIT $$getSessionValue("ewd_sessionExpiry",sessid)
 ;
isTokenExpired(token)
 ;
 QUIT $$getTokenExpiry(token)'>$$convertDateToSeconds($h)
 ;
randChar()
 ;
 n string
 ;
 s string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
 QUIT $e(string,($R($l(string))+1))
 ;
setWLDSymbol(name,sessid)
 ;
 n wldAppName,wldName,wldSessid,%zzname
 ;
 QUIT:$zv["GT.M"
 QUIT
 ;
getSessid(token)
 ;
 i token="" QUIT ""
 i $$isTokenExpired(token) QUIT ""
 QUIT $p(^%zewdSession("tokens",token),"~",1)
 ;
os() ; Identify Operating System
 ;
 I $ZV["Cache",$ZV["Windows" Q "windows"
 I $ZV["Cache",(($ZV["Unix")!($ZV["UNIX")) Q "unix"
 I $ZV["Cache",$ZV["VMS" Q "vms"
 I $ZV["Open M",$ZV["Windows" Q "windows"
 i $zv["GT.M" QUIT "gtm"
 Q ""
 ;
isNextPageTokenValid(token,sessid,page)
 ;
 n allowedFrom,expectedPage,found,fromPage,i
 ;
 ;s expectedPage=$p($g(^%zewdSession("nextPageTokens",sessid,token)),"~",1)
 ;;s allowedFrom=$p($g(^%zewdSession("nextPageTokens",sessid,token)),"~",2)
 ;i expectedPage="" QUIT 0
 ;;d trace^%zewdAPI("token="_token_" ; allowedFrom="_allowedFrom_" ; actual from page="_fromPage)
 ;;i allowedFrom'=fromPage QUIT 0
 i page[".php" d
 . s page=$p(page,"/",$l(page,"/"))
 . s page=$p(page,".php",1)
 ;#IF $$$zv="cache"
 ;QUIT $zcvt(expectedPage,"L")=$zcvt(page,"L")
 ;#ELSE
 ;QUIT $$zcvt(expectedPage,"L")=$$zcvt(page,"L")
 ;#ENDIF
 s page=$$zcvt(page,"L")
 i '$d(^%zewdSession("nextPageTokens",sessid,token,page)),$g(^zewd("trace"))=1 d
 . d trace^%zewdAPI("nextPageToken error: sessid="_sessid_"; token="_token_"; page="_page)
 QUIT $d(^%zewdSession("nextPageTokens",sessid,token,page))
 ;
zcvt(string,param,param2)
 ;
 i $g(param)="" s param="l"
 i param="l"!(param="L") QUIT $tr(string,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 i param="u"!(param="U") QUIT $tr(string,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 QUIT string
 ;
