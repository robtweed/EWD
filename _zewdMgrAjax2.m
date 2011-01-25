%zewdMgrAjax	; Enterprise Web Developer Manager Functions
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
getSessionTreeData(sessid)
 ;
 n i,no,sessionList
 ;
 s i=0
 i $$isCSP^%zewdAPI(sessid) d
 . n currSessid
 . d setSessionValue^%zewdAPI("technology","csp",sessid)
 . s currSessid=$$getSessionValue^%zewdAPI("ewd_sessid",sessid)
 . s no=0
 . f  s no=$o(^%cspSession(no)) q:no=""  d
 . . s i=1+1
 . . i ("csp:"_no)=currSessid s sessionList(i)="Session "_currSessid_$c(1)_"listSession"
 . . e  s sessionList(i)="Session "_no_$c(1)_"listSession"
 e  d
 . d setSessionValue^%zewdAPI("technology","php",sessid)
 . s no=""
 . f  s no=$o(^%zewdSession("session",no)) q:no=""  d
 . . s i=i+1
 . . s sessionList(i)="Session "_no_$c(1)_"listSession"
 d createTreeDatastore^%zewdExtJS(.sessionList,"sessionTreeData",sessid) 
 ;
 QUIT ""
 ;
getSessionDetails(sessid)
 ;
 n sessioNo
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("ext.treeValue",sessid)
 s sessionNo=$p(sessionNo,"Session ",2)
 d setSessionValue^%zewdAPI("sessionNo",sessionNo,sessid)
 ;
 QUIT ""
 ;
getAppTreeData(sessid)
 ;
 n appPath,dir,dirTree,dlim,no,ok,os,sdir
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
 d getDirectoriesInPath^%zewdHTMLParser(appPath,.dirs)
 s dir=""
 f  s dir=$o(dirs(dir)) q:dir=""  d
 . s sortedDir($$zcvt^%zewdAPI(dir,"l"))=dir
 s sdir="",no=0
 f  s sdir=$o(sortedDir(sdir)) q:sdir=""  d
 . s dir=sortedDir(sdir)
 . s no=no+1
 . s dirTree(no)=dir_$c(1)_"appPageTree"
 ;
 d createTreeDatastore^%zewdExtJS(.dirTree,"appTreeData",sessid)
 QUIT ""
 ;
getAppPageTreeData(sessid)
 ;
 n app,delim,file,fileList,no,pageTree,path
 ;
 s app=$$getSessionValue^%zewdAPI("ext.treeValue",sessid)
 d setSessionValue^%zewdAPI("application",app,sessid)
 s delim="/"
 i $$os^%zewdHTMLParser()="windows" s delim="\"
 s path=$$getApplicationRootPath^%zewdAPI()_delim_app
 d getFilesInPath^%zewdHTMLParser(path,"ewd",.fileList)
 k fileList("ewdTemplate.ewd")
 s file="",no=0
 f  s file=$o(fileList(file)) q:file=""  d 
 . s no=no+1
 . s pageTree(no)=file_$c(1)_"pageDetails"
 d createTreeDatastore^%zewdExtJS(.pageTree,"appPageTreeData",sessid) 
 ;
 QUIT ""
 ;
isSSOValid(sso,username,password,sessid)
 ;
 n pw,status,un
 ;
 s status=0
 s xsessid=$$getSessid^%zewdPHP(sso)
 i $$getSessionValue^%zewdAPI("ewd.sso",xsessid)=sso d
 . s status=1
 . s un=$$getSessionValue^%zewdAPI("username",xsessid)
 . s pw=$$getSessionValue^%zewdAPI("password",xsessid)
 . d setSessionValue^%zewdAPI("username",un,sessid)
 . d setSessionValue^%zewdAPI("password",pw,sessid)
 QUIT status
 ;
setDefaultLang(value)
 n appName 
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 d setDefaultLanguage^%zewdCompiler5(appName,value)
 QUIT ""
 ;
removeLang(sessid)
 ;
 n appName,langCode
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s langCode=$$getSessionValue^%zewdAPI("delLangCode",sessid)
 k ^ewdTranslation("language",$$zcvt^%zewdAPI(appName,"l"),langCode)
 QUIT ""
 ;
addLang(sessid)
 ;
 n appName,error,defLangCode,langCode,langName
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s langCode=$$getSessionValue^%zewdAPI("langCode",sessid)
 i langCode="" QUIT "You must enter a language code"
 s langName=$$getSessionValue^%zewdAPI("langName",sessid)
 i langName="" QUIT "You must enter a language name"
 s appName=$$zcvt^%zewdAPI(appName,"l")
 i $d(^ewdTranslation("language",appName,langCode)) QUIT langCode_" is already in use"
 d setLanguageName^%zewdCompiler5(appName,langCode,langName)
 QUIT ""
 ;
checkTextID(sessid)
 n appName,d,textid
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 i textid="" QUIT "You must enter a textid"
 i textid'?1N.N QUIT "That is not a textid!"
 i '$d(^ewdTranslation("textid",textid)) QUIT "textid does not exist"
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s d=$g(^ewdTranslation("source",textid))
 i appName'=$p(d,$c(1),1) QUIT "textid "_textid_" is from the "_$p(d,$c(1),1)_" application"
 QUIT ""
 ;
getTranslations(sessid)
 n appName,d,defLangCode,lang,langcode,langs,page,textid
 ;
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 s d=$g(^ewdTranslation("source",textid))
 s page=$p(d,$c(1),2)
 d setSessionValue^%zewdAPI("sourcePage",page,sessid)
 s langcode=""
 f  s langcode=$o(^ewdTranslation("language",appName,langcode)) q:langcode=""  d
 . s lang=$g(^ewdTranslation("language",appName,langcode))
 . s disable="disabled='disabled'"
 . i langcode'=defLangCode s disable=""
 . s langs(langcode)=lang_$c(1)_$g(^ewdTranslation("textid",textid,langcode))_$c(1)_disable
 d deleteFromSession^%zewdAPI("translations",sessid)
 d mergeArrayToSession^%zewdAPI(.langs,"translations",sessid)
 QUIT ""
 ;
updateTranslation(sessid)
 n appName,lang,langCode,text,textfield,textid
 ;
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s langCode=$$getSessionValue^%zewdAPI("langCode",sessid)
 s lang=$g(^ewdTranslation("language",appName,langCode))
 s textfield="text"_langCode
 s text=$$getRequestValue^%zewdAPI(textfield,sessid)
 i text="" d setWarning^%zewdAPI("Warning: "_lang_" text deleted",sessid)
 s text=$$replaceAll^%zewdAPI(text,"\'","'")
 s text=$$encode(text)
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 i text'="" d
 . s ^ewdTranslation("textid",textid,langCode)=text
 e  d
 . k ^ewdTranslation("textid",textid,langCode)
 QUIT ""
 ;
updateMatchingTranslations(sessid)
 ;
 n appName,defLangCode,error,langCode,phrase,text,textfield,textid,to
 ;
 s error=$$updateTranslation(sessid) 
 i error'="" QUIT error
 s appName=$$getSessionValue^%zewdAPI("appName",sessid)
 s appName=$$zcvt^%zewdAPI(appName,"l")
 s defLangCode=$$getDefaultLanguage^%zewdCompiler5(appName)
 s textid=$$getSessionValue^%zewdAPI("textid",sessid)
 s phrase=$g(^ewdTranslation("textid",textid,defLangCode))
 s langCode=$$getSessionValue^%zewdAPI("langCode",sessid)
 s textfield="text"_langCode
 s text=$$getRequestValue^%zewdAPI(textfield,sessid)
 s text=$$replaceAll^%zewdAPI(text,"\'","'")
 s text=$$encode(text)
 s to=$$getSessionValue^%zewdAPI("langCode",sessid)
 d translateAllInstances(phrase,appName,to,text,1)
 QUIT ""
 ;
translateAllInstances(phrase,appName,toLanguage,translation,all)
	;
	n defLanguage,textid,textidList
	;
	s defLanguage=$$getDefaultLanguage^%zewdCompiler5(appName)
	d getMatchingText^%zewdCompiler5(phrase,defLanguage,.textidList)
	s textid=""
	f  s textid=$o(textidList(textid)) q:textid=""  d
	. i '$g(all),$d(^ewdTranslation("textid",textid,toLanguage)) q
	. s ^ewdTranslation("textid",textid,toLanguage)=translation
	QUIT
	;
encode(text)
 n a,c,i,len,str
 ;
 s str=""
 s len=$l(text)
 f i=1:1:len d
 . s c=$e(text,i)
 . s a=$a(c)
 . q:a<32
 . i a>127 s c="&#"_a_";"
 . s str=str_c
 QUIT str
