%zewdGTMRuntime ; EWD for GT.M.  Runtime interface  
 ;
 ; Product: Enterprise Web Developer (Build 835)
 ; Build Date: Wed, 05 Jan 2011 11:13:34
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
configure(rootURL,mode,alias,path,routinePath)
 ;
 s rootURL=$g(rootURL) i rootURL="" s rootURL="/ewd/"
 s mode=$g(mode) i mode="" s mode="fixed"
 s alias=$g(alias) i alias="" s alias="/resources/"
 s routinePath=$g(routinePath) i routinePath="" s routinePath="/usr/local/gtm/ewd/"
 i $e(routinePath,$l(routinePath))'="/" s routinePath=routinePath_"/"
 s ^zewd("config","RootURL","gtm")=rootURL
 s ^zewd("config","jsScriptPath","gtm","mode")=mode
 s ^zewd("config","jsScriptPath","gtm","path")=alias
 i $g(path)="" s path="/var/www/resources" 
 s ^zewd("config","jsScriptPath","gtm","outputPath")=path
 s ^zewd("config","routinePath","gtm")=routinePath
 QUIT "" 
 ;
runPage(cgi,data)
 ; MGWSI HTTP access: normalise to WebLink interface
 n app,%CGIEVAR,%KEY,ewdAppName,ewdPageName,name,ok,pageName,path,rouName,script,x
 ;
 i '$d(^zewd("config","RootURL","gtm")) s ok=$$configure()
 i $g(^%zewd("relink"))=1,'$d(^%zewd("relink","process",$j)) s ok=$$relink()
 s name=""
 f  s name=$o(data(name)) q:name=""  d
 . i name="$CONTENT" q
 . s %KEY(name)=$$urlUnescape($g(data(name,1)))
 . i $d(data(name,2)) d
 . . n no
 . . k %KEY(name)
 . . s no=""
 . . f  s no=$o(data(name,no)) q:no=""  s %KEY(name,no)=$$urlUnescape($g(data(name,no)))
 m %CGIEVAR=cgi
 s script=$g(cgi("SCRIPT_NAME"))
 s app=$p(script,"/",3)
 s pageName=$p(script,"/",4)
 i pageName[".mgwsi" s pageName=$p(pageName,".mgwsi",1)
 i pageName[".ewd" s pageName=$p(pageName,".ewd",1)
 s %KEY("app")=app
 s %KEY("page")=pageName
 i $g(^zewd("trace"))=1 d
 . s ok=$increment(^%zewdTrace("data"))
 . m ^%zewdTrace("data",ok)=data
 . m ^%zewdTrace("key",ok)=%KEY
 ;
 i app="ewdeb" d  QUIT
 . n doll,ebToken,method,plist,pn,pv,response,sessid,stop,token,x
 . s token=$g(%KEY("ewd_token"))
 . s sessid=$$getSessid^%zewdAPI(token)
 . i sessid="" QUIT
 . s ebToken=$g(%KEY("eb"))
 . i ebToken="" QUIT
 . s method=$g(^%zewdSession("session",sessid,"ewd_EB",ebToken))
 . i method="" QUIT
 . s stop=0
 . s plist=""
 . f i=1:1 d  q:stop
 . . s pn="px"_i
 . . i '$d(%KEY(pn)) s stop=1 q
 . . s pv=$g(%KEY(pn))
 . . s pv=$$doubleQuotes^%zewdAPI(pv)
 . . i plist'="" s plist=plist_","
 . . i $e(pv,1)'="""" s pv=""""_pv_""""
 . . s plist=plist_pv
 . ;s method=method_"("_plist_")"
 . s method=method_"("_plist
 . s doll="$$"
 . i $e(method,1,2)="##" d
 . . s doll=""
 . . i plist'="" s method=method_","
 . . s method=method_"sessid"
 . s x="s response="_doll_method_")"
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("Event Broker: x="_x_" ; namespace="_$$namespace^%zewdAPI())
 . x x
 . w "HTTP/1.1 200 OK"_$c(13,10)
 . ;w "Connection: close"_$c(13,10)
 . w "Content-type: text/html"_$c(13,10,13,10)
 . w "<div id=""ewdEBResponse"">"_response_"</div>"_$c(13,10)
 ;
 ; Standard EWD Page:
 ;
 i pageName="ewdLogout" d writeHTTPHeader(app,pageName) QUIT
 s ewdAppName=$$zcvt^%zewdAPI(app,"l")
 s ewdPageName=$$zcvt^%zewdAPI(pageName,"l")
 s rouName=""
 i ewdAppName'="",ewdPageName'="" s rouName=$g(^zewd("routineMap",ewdAppName,ewdPageName))
 i rouName="" d
 . s rouName="ewdWL"_$$zcvt^%zewdAPI(app,"l")_$$zcvt^%zewdAPI(pageName,"l")
 . s rouName=$$replaceAll^%zewdAPI(rouName,"_","95")
 . s rouName=$$replaceAll^%zewdAPI(rouName,"-","45")
 . s rouName=$$replaceAll^%zewdAPI(rouName," ","")
 i rouName="" s rouName="_not_specified_"
 s path=$g(^zewd("config","routinePath","gtm"))
 i $e(path,$l(path))'="/" s path=path_"/"
 i '$$fileExists^%zewdAPI(path_rouName_".m") d  QUIT
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("Unable to find routine "_rouName_".m")
 . n i,line,missing,rn1,rn2
 . i $g(^zewd("config","errorPage"))'="" d  q
 . . w "HTTP/1.1 301 moved permanently"_$c(13,10)
 . . w "Content-length: 0"_$c(13,10)
 . . w "Location: "_^zewd("config","errorPage")_$c(13,10,13,10)
 . s rn1="ewdWL"_$$zcvt^%zewdAPI(app,"l")
 . s missing="application ("_app_") or page ("_pageName_")"
 . w "HTTP/1.1 200 OK"_$c(13,10)
 . ;w "Connection: close"_$c(13,10)
 . w "Content-type: text/html"_$c(13,10,13,10)
 . f i=1:1 s line=$t(errorPage+i) q:line["***END***"  d
 . . s line=$$replace^%zewdAPI(line,"ewd_Version",$$version^%zewdAPI())
 . . s line=$$replace^%zewdAPI(line,"ewd_missing",missing)
 . . w $p(line,";;",2,100)_$c(13,10)
 . w !
 s x="d run^"_rouName
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Invoking GT.M/MGWSI page: x="_x_" ; namespace="_$$namespace^%zewdAPI())
 s $zt="g wlRunErr"
 x x
 w !
 QUIT
 ;
wlRunErr ;
 ;
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Error occurred: "_$ze)
 n err,ewdAppName,ewdPageName,ze
 s ewdAppName=$$zcvt^%zewdAPI(app,"l")
 s ewdPageName="ewderror"
 s errName=$g(^zewd("routineMap",ewdAppName,ewdPageName))
 i errName="" d
 . s app=$$zcvt^%zewdAPI(app,"l")
 . s app=$$replaceAll^%zewdAPI(app,"_","95")
 . s app=$$replaceAll^%zewdAPI(app,"-","45")
 . s app=$$replaceAll^%zewdAPI(app," ","")
 . s errName="ewdWL"_app_"ewderror"
 s x="d run^"_errName ;d trace^%zewdAPI("x="_x)
 s ze=$$replaceAll^%zewdAPI($ze,"<","&lt;")
 s ze=$$replaceAll^%zewdAPI(ze,">","&gt;")
 s %KEY("error")="Enterprise Web Developer Error: There was a problem with page <i>"_pageName_"</i>:<br>"_ze_"<br><br>  Check that it exists in the <i>"_app_"</i> application and that it has been compiled"
 x x
 ;
 QUIT
 ;
writeHTTPHeader(app,nextpage,token,pageToken,sessid,Error)
 ;
 n amp,url
 ;
 i nextpage="ewdLogout" d
 . s sessid=$$getSessid^%zewdAPI($g(%KEY("ewd_token")))
 . s url=""
 . i sessid'="" s url=$$getSessionValue^%zewdAPI("ewd_homePage",sessid)
 . i url="" s url="/default.htm"
 . i sessid'="" d deleteSession^%zewdAPI(sessid)
 e  d
 . s url=$$getRootURL^%zewdCompiler("gtm")_app_"/"_nextpage_".mgwsi?"
 . s token=$g(token)
 . s pageToken=$g(pageToken)
 . s amp=""
 . i token'="" s url=url_"ewd_token="_token_"&n="_pageToken,amp="&"
 . i $g(sessid)'="" s url=url_amp_"sessid="_sessid,amp="&"
 . i $g(Error)'="" s url=url_amp_"error="_$$urlEscape(Error),amp="&"
 ;
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Sending HTTP 301 to URL "_url)
 w "HTTP/1.1 301 moved permanently",$c(13,10)
 w "Location: "_url,$c(13,10,13,10)
 w !
 QUIT
 ;
urlEscape(string)
 i string?1AN.AN QUIT string
 n a,c,esc,i,pass
 f i=33,36,39,40,41,42,45,46,47,95,96 s pass(i)=""
 s esc=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . i c?1AN s esc=esc_c q
 . s a=$a(c)
 . i $d(pass(a)) s esc=esc_c q
 . s a=$$hex(a)
 . s esc=esc_"%"_a
 QUIT esc
 ;
hex(number)
 n hex,no,str
 s hex=""
 s str="123456789ABCDEF"
 f  d  q:number=0
 . s no=number#16
 . s number=number\16
 . i no s no=$e(str,no)
 . s hex=no_hex
 QUIT hex
 ;
hexDecode(hex)
 QUIT $f("0123456789ABCDEF",hex)-2
hexToDecimal(hex)
 ;
 n i,num
 s num=0
 f i=1:1:$l(hex) d
 . s num=num*16+$$hexDecode($e(hex,i))
 QUIT num
 ;
urlUnescape(esc)
 s esc=$tr(esc,"+"," ")
 i esc'["%" QUIT esc
 n a,c,string,i
 s string=""
 f i=1:1:$l(esc) d
 . s c=$e(esc,i)
 . i c'="%" s string=string_c q
 . s hex=$e(esc,i+1,i+2)
 . s a=$$hexToDecimal(hex)
 . s string=string_$c(a)
 . s i=i+2
 QUIT string
 ;
jsEscape(string)
 s string=$$replaceAll^%zewdAPI(string,"'","\'")
 QUIT string
 ;
htmlEscape(string)
 QUIT string
 ;
createSessionArray(sessionName,configName,text)
 QUIT text_" s sessionArray(""ewd_"_sessionName_""")="""_$g(config(configName))_""""_$c(13,10)
 ;
createGTMNextPageHeader(nextPageList,urlNameList,phpHeaderArray)
 ;
 n attr,fieldName,headOID,lineNo,np,redirection,scriptOID,text,timeout,urlNo,var,var1
 ;
 s headOID=$$getTagOID^%zewdCompiler("body",docName)
 i headOID="" s headOID=$$getDocumentNode^%zewdDOM(docName)
 s attr("language")="cache"
 s attr("section")="pre2"
 ;
 s text=""
 s np="",lineNo=1
 s phpHeaderArray(4,1)="   $tokens = array() ;"
 f  s np=$o(nextPageList(np)) q:np=""  d
 . s lineNo=lineNo+1
 . i np="*" s text=text_" s tokens("""_np_""")="""""_$c(13,10) q
 . s text=text_" s tokens("""_np_""")=$$setNextPageToken^%zewdGTMRuntime("""_np_""")"_$c(13,10)
 ;
 s np=""
 f  s np=$o(phpHeaderArray(2,np)) q:np=""  d
 . s lineNo=lineNo+1
 . s text=text_phpHeaderArray(2,np)_$c(13,10)
 ;
 s urlNo=""
 f  s urlNo=$o(urlNameList(urlNo)) q:urlNo=""  d
 . n nameList
 . s nameList=urlNameList(urlNo)
 . s lineNo=lineNo+1
 . s text=text_" s sessionArray(""ewd_urlNameList"","""_urlNo_""")="""_nameList_""""_$c(13,10)
 ;
 set scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
 ; 
 QUIT
 ;
outputDOM(docName,mode,cspFlag,cspVars,phpVars,isXHTML,technology,maxLines)
 ;
 ; special version of outputDOM
 ; 
 n docOID,i,line,lineNo,ok,returnValue
 ;
 k ^CacheTempWLD($j)
 ;
 s cspFlag=1
 s isXHTML=+$g(isXHTML)
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 s maxLines=$g(maxLines)
 i maxLines="" s maxLines=2000
 ;
 s mode=$g(mode) i mode="" s mode="pretty"
 i isXHTML d
 . w "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">",!
 s returnValue=$$outputNode(docOID,mode,"",0,1,cspFlag,.cspVars,.phpVars,isXHTML,technology)
 ;s ok=$$$closeDOM
 d buildRoutine(pageName,maxLines)
 k ^CacheTempWLD($j)
 QUIT
 ;
createEwdError(maxLines)
 ;
 n i,line,maxLines
 ;
 s maxLines=$g(maxLines)
 i maxLines="" s maxLines=2000
 k ^CacheTempWLD($j)
 f i=1:1 s line=$t(ewdError+i^%zewdCompiler2) q:line["***END**"  d
 . i line["ewd_Version" s line=$$replace^%zewdAPI(line,"ewd_Version",$$version^%zewdAPI())
 . i line["*php*" q
 . i line["*jsp*" q
 . i line["*vb.net*" q
 . i line["*wl" s line=";;"_$p(line,"*wl*",2)
 . d writeLine($p(line,";;",2,200),"body")
 s ^CacheTempWLD($j,"pre1",1)=" w ""HTTP/1.1 200 OK""_$c(13,10)"
 s ^CacheTempWLD($j,"pre1",2)=" w ""Content-type: text/html""_$c(13,10,13,10)"
 s ^CacheTempWLD($j,"pre1",3)=" QUIT 1"
 d buildRoutine("ewdError",maxLines)
 k ^CacheTempWLD($j)
 ;
 Q
 ;
buildRoutine(pageName,maxLines)
 ;
 n i,ifCond,io,ix,level,line,linex,lineNo,outputFilepath,rn,rouName,rouNo,x
 ;
 s rouName="ewdWL"_$$zcvt^%zewdAPI(app,"l")_$$zcvt^%zewdAPI(pageName,"l")
 s rouName=$$replaceAll^%zewdAPI(rouName,"_","95")
 s rouName=$$replaceAll^%zewdAPI(rouName,"-","45")
 s rouName=$$replaceAll^%zewdAPI(rouName," ","")
 i rouName["copyof" QUIT
 i rouName["copy(" QUIT
 ;
 s line(1)=rouName_" ;"
 s line(2)=" ;GT.M version of page "_pageName_" ("_app_" application)"
 s line(3)=" ;Compiled on "_$$inetDate^%zewdAPI($h)
 s line(4)=" ;using "_$$version^%zewdAPI()
 s line(5)=" QUIT"
 s line(6)=" ;"
 s line(7)="run ;"
 s line(8)=" n confirmText,ebToken,Error,formInfo,ok,sessid,sessionArray,tokens"
 s line(9)=" s ok=$$pre()"
 s line(10)=" i ok d body"
 s line(11)=" QUIT"
 s line(12)=" ;"
 s line(13)="pre() ;"
 s line(14)=" ;"
 s line(15)=" n ctype,ewdAction,headers,jump,quitStatus,pageTitle,stop,urlNo"
 s line(16)=" ;"
 f lineNo=1:1 q:'$d(line(lineNo))  s ^CacheTempWLD($j,"rou",lineNo)=line(lineNo)
 s i=""
 f  s i=$o(^CacheTempWLD($j,"pre1",i)) q:i=""  d
 . s line=^CacheTempWLD($j,"pre1",i)
 . s ^CacheTempWLD($j,"rou",lineNo)=line
 . s lineNo=lineNo+1
 s i=""
 f  s i=$o(^CacheTempWLD($j,"pre2",i)) q:i=""  d
 . s line=^CacheTempWLD($j,"pre2",i)
 . s ^CacheTempWLD($j,"rou",lineNo)=line
 . s lineNo=lineNo+1
 s i=""
 f  s i=$o(^CacheTempWLD($j,"pre3",i)) q:i=""  d
 . s line=^CacheTempWLD($j,"pre3",i)
 . s ^CacheTempWLD($j,"rou",lineNo)=line
 . s lineNo=lineNo+1
 s ^CacheTempWLD($j,"rou",lineNo)=" ;"
 s lineNo=lineNo+1
 s ^CacheTempWLD($j,"rou",lineNo)="body ;"
 s lineNo=lineNo+1
 s i=""
 f  s i=$o(^CacheTempWLD($j,"body",i)) q:i=""  d
 . s line=^CacheTempWLD($j,"body",i)
 . s ^CacheTempWLD($j,"rou",lineNo)=line
 . s lineNo=lineNo+1
 s ^CacheTempWLD($j,"rou",lineNo)=" QUIT"
 ;
 k lineNo
 s lineNo="",i=0,level=0,rouNo=1,ifCond=""
 s ^CacheTempWLD($j,"routine",rouNo)=rouName
 f  s lineNo=$o(^CacheTempWLD($j,"rou",lineNo)) q:lineNo=""  d
 . s line=^CacheTempWLD($j,"rou",lineNo),linex=line
 . i level>0,line'="" f ix=1:1:level s linex=$e(linex,1)_"."_$e(linex,2,$l(linex))
 . i $e(line,1,3)=" if",line["{" d
 . . s linex=$tr(linex,"{","d")
 . . s level=level+1
 . . i level=1 s ifCond=line
 . i $e(line,1,6)=" while",line["{" d
 . . s level=level+1,linex=$$replace^%zewdAPI(linex,"{"," d")
 . . s linex=$$replace^%zewdAPI(linex,"while ","f  q:'")
 . i $e(line,1,5)=" else",line["{" s level=level+1,linex=$$replace^%zewdAPI(linex,"{"," d")
 . i $e(line,1,4)=" for",line["{" s level=level+1,linex=$tr(linex,"{","d")
 . i $e(line,$l(line))="}" d
 . . s linex=$tr(linex,"}","")
 . . i level>0 s level=level-1
 . . i level=0 s ifCond=""
 . i line'="" s ^CacheTempWLD($j,"routine",rouNo,i)=linex,i=i+1
 . ;i $e(line,1,3)=" w ",level=0,i'<maxLines d splitRoutine(.rouNo,.lineNo,.i,0) q
 . ;i level=1,ifCond'="",i'<maxLines,'$$isElseNext(lineNo) d splitRoutine(.rouNo,.lineNo,.i,1,ifCond)
 s lineNo(rouNo)=i-1
 ;
 s outputFilepath=$g(^zewd("config","routinePath","gtm"))_rouName_".m"
 s io=$io
 i '$$openNewFile^%zewdAPI(outputFilepath) s error="Unable to open the output file "_outputFilepath
 i $g(error)'="" u io w !,error QUIT
 u outputFilepath
 s rouNo=""
 f  s rouNo=$o(^CacheTempWLD($j,"routine",rouNo)) q:rouNo=""  d
 . s rouName=^CacheTempWLD($j,"routine",rouNo)
 . s lineNo=lineNo(rouNo)
 . f i=1:1:lineNo d
 . . s line=^CacheTempWLD($j,"routine",rouNo,i)
 . . s line=$$replace^%zewdAPI(line,$c(13),"")
 . . w line,!
 c outputFilepath
 u io
 ; 
 QUIT
 ;
isElseNext(lineNo)
 n line
 s line=$g(^CacheTempWLD($j,"rou",lineNo+1))
 i $e(line,1,7)=" else {" QUIT 1
 QUIT 0
 ;
splitRoutine(rouNo,lineNo,i,addIf,ifCond)
 ; split the routine
 i addIf s ^CacheTempWLD($j,"routine",rouNo,i)=" }",i=i+1
 s ^CacheTempWLD($j,"routine",rouNo,i)=" g ^"_rouName_"."_(rouNo+1)
 s lineNo(rouNo)=i
 s rouNo=rouNo+1
 s ^CacheTempWLD($j,"routine",rouNo)=rouName_"."_rouNo
 s i=1
 s ^CacheTempWLD($j,"routine",rouNo,i)=rouName_" ; extension "_rouNo
 s i=i+1
 i addIf s ^CacheTempWLD($j,"routine",rouNo,i)=ifCond,i=i+1
 QUIT
 ;
outputNode(nodeOID,mode,indent,suppressIndent,endWithCR,cspFlag,cspVars,phpVars,isXHTML,technology)
 ;
 n data,displayIndent,i,language,lastTag,method,nextIndent,nodeType,np,returnValue,runat
 n section
 ;
 s returnValue=""
 i mode="collapse" s suppressIndent=1,endWithCR=0
 s displayIndent=indent i suppressIndent s displayIndent=""
 s nodeType=$$getNodeType^%zewdDOM(nodeOID)
 i nodeType=1 d  Q returnValue
 . n tagName,firstChildOID,firstChildTagName,line
 . s tagName=$$getTagName^%zewdDOM(nodeOID)
 . i tagName="csp:method" q
 . s language=$$getAttribute^%zewdDOM("language",nodeOID)
 . s section=$$getAttribute^%zewdDOM("section",nodeOID)
 . s runat=$$getAttribute^%zewdDOM("runat",nodeOID)
 . s method=$$zcvt^%zewdAPI($$getAttribute^%zewdDOM("method",nodeOID),"l")
 . i tagName="script",language="cache",runat="server" d
 . . n childOID
 . . s childOID=""
 . . f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
 . . . s data=$$replaceVars($$getData^%zewdDOM(childOID),.cspVars,.phpVars,technology)
 . . . s np=$l(data,$c(13,10))
 . . . f i=1:1:np d addCommand($p(data,$c(13,10),i),"body")
 . e  i tagName="script",language="cache",method="onprehttp" d
 . . n childOID
 . . s childOID=""
 . . f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
 . . . s data=$$replaceVars($$getData^%zewdDOM(childOID),.cspVars,.phpVars,technology)
 . . . s np=$l(data,$c(13,10))
 . . . f i=1:1:np d addCommand($p(data,$c(13,10),i),"pre")
 . e  i tagName="script",language="cache",section="pre1" d
 . . n childOID
 . . s childOID=""
 . . f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
 . . . s data=$$replaceVars($$getData^%zewdDOM(childOID),.cspVars,.phpVars,technology)
 . . . s np=$l(data,$c(13,10))
 . . . f i=1:1:np d addCommand($p(data,$c(13,10),i),"pre1")
 . e  i tagName="script",language="cache",section="pre2" d
 . . n childOID
 . . s childOID=""
 . . f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
 . . . s data=$$replaceVars($$getData^%zewdDOM(childOID),.cspVars,.phpVars,technology)
 . . . s np=$l(data,$c(13,10))
 . . . f i=1:1:np d addCommand($p(data,$c(13,10),i),"pre2")
 . e  i tagName="script",language="cache",section="pre3" d
 . . n childOID
 . . s childOID=""
 . . f  s childOID=$$getNextChild^%zewdAPI(nodeOID,childOID) q:childOID=""  d
 . . . s data=$$replaceVars($$getData^%zewdDOM(childOID),.cspVars,.phpVars,technology)
 . . . s np=$l(data,$c(13,10))
 . . . f i=1:1:np d addCommand($p(data,$c(13,10),i),"pre3")
 . e  d
 . . s line=""
 . . i tagName'="ewd:rawcontent" d
 . . . s line=displayIndent_"<"_$$replaceVars(tagName,.cspVars,.phpVars,technology)
 . . . i $$hasAttributes^%zewdDOM(nodeOID)="true" s line=line_$$outputAttr(nodeOID,.cspVars,.phpVars,technology)
 . . i tagName="csp:loop" d
 . . . ;<csp:loop counter="diagnosis" from="1" step="2" to="10">
 . . . n cmnd,counter,from,step,to
 . . . s counter=$$getAttribute^%zewdDOM("counter",nodeOID)
 . . . s counter=$$replaceAll^%zewdAPI(counter,"&quot;","""")
 . . . s from=$$getAttribute^%zewdDOM("from",nodeOID)
 . . . s from=$$replaceAll^%zewdAPI(from,"&quot;","""")
 . . . s step=$$getAttribute^%zewdDOM("step",nodeOID)
 . . . s step=$$replaceAll^%zewdAPI(step,"&quot;","""")
 . . . s to=$$getAttribute^%zewdDOM("to",nodeOID)
 . . . s to=$$replaceAll^%zewdAPI(to,"&quot;","""")
 . . . s cmnd=" for "_counter_"="_from_":"_step_":"_to_" {"
 . . . s cmnd=$$cspToMVar(cmnd)
 . . . s line="" d addCommand(cmnd,"body")
 . . i tagName="csp:if" d
 . . . n condition
 . . . s condition=$$getAttribute^%zewdDOM("condition",nodeOID)
 . . . s line="" d addCommand(" if ("_$$replaceAll^%zewdAPI(condition,"&quot;","""")_") {","body")
 . . i tagName="csp:while" d
 . . . n condition
 . . . s condition=$$getAttribute^%zewdDOM("condition",nodeOID)
 . . . s line="" d addCommand(" while ("_$$replaceAll^%zewdAPI(condition,"&quot;","""")_") {","body")
 . . i tagName="csp:else" d
 . . . s line="" d addCommand(" }","body"),addCommand(" else {","body")
 . . i tagName="csp:elseif" d
 . . . n condition
 . . . s condition=$$getAttribute^%zewdDOM("condition",nodeOID)
 . . . s line="" d addCommand(" }","body"),addCommand(" else  if ("_$$replaceAll^%zewdAPI(condition,"&quot;","""")_") {","body")
 . . i tagName="html",$g(isXHTML) d
 . . . s line=line_" xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""en"" lang=""en"""
 . . i $$hasChildNodes^%zewdDOM(nodeOID)="false" d
 . . . i tagName["csp:"!(tagName="script")!(tagName="td")!(tagName="div")!(tagName="textarea")!(tagName="object")!(tagName="iframe")!(tagName="select") q
 . . . s line=line_" /"
 . . i line'="",tagName'="ewd:rawcontent" s line=line_">" d writeLine(line,"body")
 . . i $$hasChildNodes^%zewdDOM(nodeOID)="false" d  Q
 . . . i tagName="script" d  q
 . . . . d writeLine("</script>","body")
 . . . i tagName="td" d  q
 . . . . d writeLine("</td>","body")
 . . . i tagName="textarea" d  q
 . . . . d writeLine("</textarea>","body")
 . . . i tagName="object" d  q
 . . . . d writeLine("</object>","body")
 . . . i tagName="div" d  q
 . . . . d writeLine("</div>","body")
 . . . i tagName="iframe" d  q
 . . . . d writeLine("</iframe>","body")
 . . . i tagName="select" d  q
 . . . . d writeLine("</select>","body")
 . . . i tagName="applet" d  q
 . . . . d writeLine("</applet>","body")
 . . . i tagName="csp:if" d addCommand(" }","body") q
 . . . i tagName="csp:while" d addCommand(" }","body") q
 . . . i tagName="csp:loop" d addCommand(" }","body") q
 . . . i tagName="csp:else" q
 . . s firstChildOID=$$getFirstChild^%zewdDOM(nodeOID)
 . . s firstChildTagName=$$getTagName^%zewdDOM(firstChildOID)
 . . s nextIndent=indent_"   "
 . . i tagName="textarea",$$getNodeType^%zewdDOM(firstChildOID)=7 s endWithCR=0,suppressIndent=1
 . . i tagName="textarea",$$getNodeType^%zewdDOM(firstChildOID)=3 s endWithCR=0,suppressIndent=1
 . . i tagName="textarea",firstChildTagName="script" s endWithCR=0,suppressIndent=1
 . . i mode="html" d
 . . . i tagName="td",firstChildTagName="img" s endWithCR=0,suppressIndent=1
 . . . i tagName="td",firstChildTagName="a" s endWithCR=0,suppressIndent=1
 . . . i tagName="a",firstChildTagName'="img" s endWithCR=1,suppressIndent=0
 . . . i tagName="img",firstChildTagName'="" s endWithCR=1,suppressIndent=0
 . . . i tagName="span",$$getNodeType^%zewdDOM(firstChildOID)=3 s endWithCR=0,suppressIndent=1
 . . s lastTag=$$outputChildren(nodeOID,mode,nextIndent,suppressIndent,endWithCR,cspFlag,.cspVars,.phpVars,isXHTML,technology)
 . . i mode="html",tagName="td",$$countChildren^%zewdHTMLParser(nodeOID)>1 s suppressIndent=0
 . . i suppressIndent s displayIndent=""
 . . i tagName'="ewd:rawcontent" s line=displayIndent_"</"_$$replaceVars(tagName,.cspVars,.phpVars,technology)_">"
 . . i tagName="csp:if"!(tagName="csp:while")!(tagName="csp:loop") d
 . . . d addCommand(" }","body")
 . . e  d
 . . . d writeLine(line,"body")
 . . i mode="html",tagName="td" s endWithCR=1
 . . i mode="html",tagName="span" d
 . . . n siblingOID
 . . . s endWithCR=1,suppressIndent=0
 . . . s siblingOID=$$getNextSibling^%zewdDOM(nodeOID)
 . . . i $$getNodeType^%zewdDOM(siblingOID)=3 s endWithCR=0,suppressIndent=1
 ;
 i nodeType=9 s lastTag=$$outputChildren(nodeOID,mode,"",suppressIndent,1,cspFlag,.cspVars,.phpVars,isXHTML,technology) Q returnValue  ;
 ;
 i nodeType=8 d  Q returnValue
 . n data,i,line,np
 . s line=""
 . i 'suppressIndent s line=line_indent
 . s line=line_"<!--" d writeLine(line,"body")
 . s data=$$replaceVars($$getData^%zewdDOM(nodeOID),.cspVars,.phpVars,technology)
 . s np=$l(data,$c(13,10))
 . f i=1:1:np d writeLine($p(data,$c(13,10),i),"body")
 . s line="-->" d writeLine(line,"body")
 . ;i endWithCR w ! q
 . ;i mode="collapse" w !
 ;
 i nodeType=3 d  Q returnValue
 . n i,isCommand,np,text,textArray,nsOID,nsType,txt
 . s text=$$getData^%zewdDOM(nodeOID)
 . s np=$l(text,$c(10))
 . s isCommand=0
 . f i=1:1:np d
 . . s txt=$p(text,$c(10),i)
 . . i txt["<script language=""cache""" s isCommand=1 q
 . . i isCommand,txt["</script>" s isCommand=0 q
 . . i txt["zewd.mcode" d
 . . . s txt=$p(txt,"zewd.mcode",2,1000)
 . . . s isCommand=1
 . . i isCommand d
 . . . d addCommand(txt,"body")
 . . e  d
 . . . n xbuf,nocrlf
 . . . s nocrlf=0
 . . . i i=np s nocrlf=1
 . . . s xbuf=txt
 . . . f  d  q:xbuf=""
 . . . . s txt=$e(xbuf,1,1500),xbuf=$e(xbuf,1501,$l(xbuf))
 . . . . d writeLine($$replaceVars(txt,.cspVars,.phpVars,technology),"body",nocrlf)
 . ;i text="***Array***" b  Q
 . ;i mode="html",text?."&nbsp;" d writeLine(text) s endWithCR=0,suppressIndent=1 q
 . ;i 'suppressIndent d writeLine(indent)
 . ;d writeLine($$replaceVars(text,.cspVars,.phpVars,technology))
 . ;i endWithCR w !
 . s nsOID=$$getNextSibling^%zewdDOM(nodeOID)
 . s nsType=$$getNodeType^%zewdDOM(nsOID)
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
 . n line
 . s line=""
 . i 'suppressIndent s line=line_indent
 . s line="<!DOCTYPE "_$$getName^%zewdDOM(nodeOID)
 . i $$getPublicId^%zewdDOM(nodeOID)'="" s line=line_" PUBLIC """_$$getPublicId^%zewdDOM(nodeOID)_""""
 . i $$getSystemId^%zewdDOM(nodeOID)'="" s line=line_" """_$$getSystemId^%zewdDOM(nodeOID)_""""
 . s line=line_">"
 . d writeLine(line,"body")
 . ;i endWithCR w !
 Q returnValue
 ;
addCommand(text,section)
 n lineNo
 s section=$g(section) i section="" s section="body"
 s lineNo=$o(^CacheTempWLD($j,section,""),-1)+1
 s ^CacheTempWLD($j,section,lineNo)=text
 QUIT 
 ;
writeLine(line,section,noCRLF)
 n crlf,lineNo,p1,p2,p3,p4,text
 s crlf="$c(13,10)"
 i mode="collapse",$g(tagName)'="script" s crlf=""""""
 i $g(tagName)="script",mode="collapse" s line=$$stripSpaces^%zewdAPI(line) i line="" QUIT
 i $g(noCRLF)=1 s crlf=""""""
 s section=$g(section) i section="" s section="body"
 s lineNo=$o(^CacheTempWLD($j,section,""),-1)+1
 s text=""
 i line["#(" d  QUIT
 . s text=text_" w "
 . f  q:line'["#("  d
 . . s p1=$p(line,"#(",1)
 . . i p1'="" s text=text_""""_$$dblQuote(p1)_"""_" 
 . . s p2=$p(line,"#(",2,1000)
 . . s p3=$p(p2,")#",1)
 . . s text=text_p3
 . . s line=$p(p2,")#",2,1000)
 . . i line'="" s text=text_"_"
 . ;i line'="" s text=text_""""_$$dblQuote(line)_"""_$c(13,10)"
 . i line'="" s text=text_""""_$$dblQuote(line)_"""_"_crlf
 . s ^CacheTempWLD($j,section,lineNo)=text
 s line=$$dblQuote(line)
 s ^CacheTempWLD($j,section,lineNo)=" w """_line_"""_"_crlf
 QUIT
 ;
cspToMVar(line)
 n p1,p2,p3,text
 s text=""
 f  q:line'["#("  d
 . s p1=$p(line,"#(",1)
 . i p1'="" s text=text_p1
 . s p2=$p(line,"#(",2,1000)
 . s p3=$p(p2,")#",1)
 . s text=text_p3
 . s line=$p(p2,")#",2,1000)
 . ;i line'="" s text=text_"_"
 i line'="" s text=text_line
 QUIT text
 ;
dblQuote(string)
 s string=$$replaceAll^%zewdAPI(string,"""",$c(0))
 s string=$$replaceAll^%zewdAPI(string,$c(0),"""""")
 QUIT string
 ;
outputChildren(parentOID,mode,indent,suppressIndent,endWithCR,cspFlag,cspVars,phpVars,isXHTML,technology)
 ;
 n childOID,siblingOID,indent1,returnValue,cr
 ;
 i $g(mode)="collapse" s suppressIndent=1,endWithCR=0
 s childOID=$$getFirstChild^%zewdDOM(parentOID)
 ;i nodeType'=9,endWithCR w !
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
 n attrArray,attrName,attrOID,attrValue,nlOID,len,i,line
 ;
 s technology=$g(technology) i technology="" s technology="php"
 ;s nlOID=$$$getAttributes(nodeOID)
 s nlOID=$$getAttributes^%zewdCompiler(nodeOID,.attrArray)
 ; s len=$$$getNamedNodeMapAttribute(nlOID,"length")
 s line=""
 ;f i=1:1:len s attrOID=$$$item(i-1,nlOID,"") d
 s attrName=""
 f  s attrName=$o(attrArray(attrName)) q:attrName=""  d
 . ;n attrName,attrValue
 . ;s attrName=$$$getName(attrOID)
 . s attrOID=attrArray(attrName)
 . s attrValue=$$getValue^%zewdDOM(attrOID)
 . i attrValue["&cspVar" s attrValue=$$getAttributeValue^%zewdDOM(attrName,0,nodeOID)
 . ;i $e(attrValue,1)="#" s attrValue=$$replaceAll(attrValue,"&quot;","""")
 . i attrName["mgwVarXX" d  q
 . . s attrValue=$$getAttributeValue^%zewdDOM(attrName,1,nodeOID)
 . . i attrValue["&cspVar"!(attrValue["&php") s attrValue=$$getAttributeValue^%zewdDOM(attrName,0,nodeOID)
 . . s line=line_" "_$$replaceVars(attrValue,.cspVars,.phpVars,technology)
 . i attrValue["""",attrValue["'" d  q
 . . n spos,dpos
 . . s spos=$f(attrValue,"'")
 . . s dpos=$f(attrValue,"""")
 . . i spos<dpos s line=line_" "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"="""_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_"""" q
 . . s line=line_" "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"='"_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_"'" 
 . i attrValue["""" d  q
 . . s line=line_" "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"='"_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_"'" 
 . s line=line_" "_$$replaceVars(attrName,.cspVars,.phpVars,technology)_"="""_$$replaceVars(attrValue,.cspVars,.phpVars,technology)_""""
 QUIT line
 ;
replaceVars(string,cspVars,phpVars,technology)
 ;
 n c1,entity,npieces,npos,%p1,%p2,%p3,var
 ;
 s (%p1,%p2,%p3,npieces)=""
 s (var,c1)=""
 f entity="&cspVar;","&php;" d
 . f  q:string'[entity  d
 . . s npieces=$l(string,entity)
 . . s %p1=$p(string,entity,1)
 . . s %p2=$p(string,entity,2)
 . . s %p3=$p(string,entity,3,npieces)
 . . i entity="&cspVar;" s string=%p1_"#("_$g(cspVars(%p2))_")#"_%p3
 . . i $g(technology)="gtm",entity="&php;" d  q
 . . . s var=$$stripSpaces^%zewdAPI($g(phpVars(%p2)))
 . . . i $e(var,1)="$" s var=$e(var,2,$l(var))
 . . . i $e(var,1)="#" d
 . . . . n esc
 . . . . s esc=0
 . . . . i $e(var,2)="\" d
 . . . . . s esc=1
 . . . . . s var="#"_$e(var,3,1000)
 . . . . i var["." d
 . . . . . n object,property
 . . . . . s var=$e(var,2,$l(var))
 . . . . . s object=$p(var,".",1)
 . . . . . s property=$p(var,".",2)
 . . . . . i object["[" d
 . . . . . . n index
 . . . . . . s index=$p(object,"[",2)
 . . . . . . s index=$p(index,"]",1)
 . . . . . . s object=$p(object,"[",1)
 . . . . . . i $e(index,1)="$" s index=$e(index,2,$l(index))
 . . . . . . s var="$$getResultSetValue^%zewdAPI("""_object_""","_index_","""_property_""",sessid)"
 . . . . . e  d
 . . . . . . i $e(var,1,3)="tmp" s var="$$getTmpSessionValue^%zewdAPI2("""_var_""",sessid)" q
 . . . . . . s var="$$getSessionValue^%zewdAPI("""_var_""",sessid)"
 . . . . e  d
 . . . . . i $e(var,2,4)="tmp" s var="$$getTmpSessionValue^%zewdAPI2("""_$e(var,2,$l(var))_""",sessid)" q
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
 QUIT string
 ;
createEBToken(method,sessionArray)
 ;
 n token
 s token=$$createToken()
 s sessionArray("ewd_EB",token)=method
 ;
 QUIT token
 ;
setMethodAndNextPage(name,method,nextpage,nameList,sessionArray)
 n token
 i $g(name)="" QUIT
 s token=$$createToken()
 s sessionArray("ewd_Action",name,"method")=method
 s sessionArray("ewd_Action",name,"nextpage")=nextpage
 s sessionArray("ewd_Action",name,"token")=token
 s sessionArray("ewd_Action",name,"nameList")=nameList
 ;s sessionArray("ewd_NextPage",token)=nextpage
 i nextpage'="" s sessionArray("ewd_NextPage",token,nextpage)=""
 QUIT
 ;
createToken()
 n i,string,token
 s string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
 s token=""
 f  d  q:'$d(^%zewdSession("tokens",token))
 . f i=1:1:30 s token=token_$e(string,($r($l(string))+1))
 QUIT token
 ;
setNextPageToken(nextpage)
 n i,string,token
 ;
 ;s token=$$createToken()
 ;
 s string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
 s token=""
 f  d  q:'$d(^%zewdSession("tokens",token))  s token=""
 . f i=1:1:30 s token=token_$e(string,($r(62)+1))
 ;s sessionArray("ewd_NextPage",token)=nextpage
 s sessionArray("ewd_NextPage",token,nextpage)=""
 QUIT token 
 ;
relink(sessid)
 n list,rou,xrou
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Process "_$j_": Relinking...")
 i $g(sessid)'="" d deleteFromSession^%zewdAPI("ewd_relinkList",sessid)
 s rou=""
 f  s rou=$view("RTNNEXT",rou) q:rou=""  d
 . i rou="%zewdGTMRuntime" q
 . i rou="%zewdPHP" q
 . i rou="MDB" q
 . i rou="ewdWLewdmgrrelink" q
 . i rou="%ZMGWSI" q
 . i rou="%ZMGWSIS" q
 . i rou="GTM$DMOD" q
 . s xrou=rou
 . i $e(xrou,1)="%" s xrou="_"_$e(xrou,2,$l(xrou))
 . zl xrou
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("relinked "_rou)
 . s list(rou)=""
 i $g(sessid)'="" d mergeArrayToSession^%zewdAPI(.list,"ewd_relinkList",sessid)
 s ^%zewd("relink","process",$j)=""
 i $g(^zewd("trace"))=1 d trace^%zewdAPI("Process "_$j_": Relinking complete")
 QUIT ""
 ;
pre1 ;
 n scriptOID,headOID,attr,lineNo,text,timeout,fieldName,redirection
 n var,var1
 s headOID=$$getTagOID^%zewdCompiler("body",docName)
 i headOID="" s headOID=$$getDocumentNode^%zewdDOM(docName)
 s attr("language")="cache"
 s attr("section")="pre1"
 ;
 ;s text=" n stop"_$c(13,10)
 s text=""
 s text=text_" s confirmText="""_$get(config("confirmText"))_""""_$c(13,10)
 s text=$$createSessionArray("isFirstPage","isFirstPage",text)
 s text=$$createSessionArray("sessid_timeout","pageTimeout",text)
 s text=$$createSessionArray("prePageScript","prePageScript",text)
 s text=$$createSessionArray("default_timeout","defaultTimeout",text)
 if $g(config("homePage"))'="" s text=$$createSessionArray("homePage","homePage",text)
 s text=$$createSessionArray("persistRequest","persistRequest",text)
 s text=$$createSessionArray("pageTitle","pageTitle",text)
 s text=$$createSessionArray("errorPage","errorPage",text)
 s text=$$createSessionArray("templatePrePageScript","templatePrePageScript",text)
 s text=$$createSessionArray("onErrorScript","onErrorScript",text)
 ;s text=text_" s sessionArray(""ewd_appName"")="""_appName_""""_$c(13,10)
 s text=text_" s sessionArray(""ewd_appName"")="""_app_""""_$c(13,10)
 s text=text_" s sessionArray(""ewd_pageName"")="""_pageName_""""_$c(13,10)
 s text=text_" s sessionArray(""ewd_translationMode"")="""_multilingual_""""_$c(13,10)
 s text=text_" s sessionArray(""ewd_technology"")=""gtm"""_$c(13,10)
 if $g(config("errorClass"))'="" s text=$$createSessionArray("errorClass","errorClass",text)
 i $g(config("cachePage"))="false" d
 . s text=text_" s sessionArray(""ewd_header"",""Expires"")=0"_$c(13,10)
 . s text=text_" s sessionArray(""ewd_header"",""Cache-Control"")=""no-cache"""_$c(13,10)
 . s text=text_" s sessionArray(""ewd_header"",""Pragma"")=""no-cache"""_$c(13,10)
 s pageType="ajax"
 i $g(config("pageType"))'="ajax" s pageType=""
 s text=text_" s sessionArray(""ewd_pageType"")="""_pageType_""""_$c(13,10)
 ; 
 s lineNo=""
 f  s lineNo=$o(phpHeaderArray(1,lineNo)) q:lineNo=""  d
 . s line=phpHeaderArray(1,lineNo)
 . i line'="" s text=text_line_$c(13,10)
 set scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
 ; 
 QUIT
 ;
pre2 ;
 n attr,%d,dataType,field,fieldName,fields,fname,hasDTs,headOID,hname,line,max
 n n,name,nameList,nextPage,noOfFields,recNo,redirection,scriptOID,stop,text,timeout,type,var,var1
 ;
 s headOID=$$getTagOID^%zewdCompiler("body",docName)
 i headOID="" s headOID=$$getDocumentNode^%zewdDOM(docName)
 s attr("language")="cache"
 s attr("section")="pre3"
 ;
 s text=""
 s n=""
 s max=3500
 for  set n=$order(formDeclarations(n)) quit:n=""  do
 . set %d=formDeclarations(n)
 . set name=$piece(%d,"~",1)
 . ;if name'["$" set name="'"_name_"'"
 . set fields=$piece(%d,"~",4)
 . set noOfFields=$length(fields,"`")
 . s hasDTs=0
 . for i=1:1:noOfFields do
 . . set field=$piece(fields,"`",i)
 . . quit:field=""
 . . set type=$p(field,"|",2)
 . . s field=$p(field,"|",1)
 . . if type="file" set upload=field
 . . set dataType=$get(dataTypeList(field))
 . . i dataType'="" s text=text_" s sessionArray(""ewd_DataType"","""_pageName_""","""_field_""")="""_dataType_""""_$c(13,10)
 . s nameList=$p(%d,"~",4)
 . i $l(nameList)<max d
 . . s text=text_" s formInfo="""_nameList_""""_$c(13,10)
 . e  d
 . . n buf
 . . s max=3500
 . . s buf=nameList
 . . s text=text_" s formInfo="""""_$c(13,10)
 . . f  d  q:buf=""
 . . . s nameList=$e(buf,1,max)
 . . . s buf=$e(buf,(max+1),$l(buf))
 . . . s extra=$p(buf,"`",1)
 . . . s buf=$p(buf,"`",2,3000)
 . . . s nameList=nameList_extra
 . . . i buf'="" s nameList=nameList_"`"
 . . . s text=text_" s formInfo=formInfo_"""_nameList_""""_$c(13,10)
 . set text=text_" d setMethodAndNextPage^%zewdCompiler20("""_name_""","""_$piece(%d,"~",2)_""","""_$piece(%d,"~",3)_""",formInfo,.sessionArray)"_$c(13,10)
 . i $p(%d,"~",2)'="" d
 . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalls",$$zcvt^%zewdAPI(pageName,"l"),$piece(%d,"~",2))="action"
 . . s ^%zewdIndex($$zcvt^%zewdAPI(app,"l"),"scriptCalledBy",$piece(%d,"~",2),$$zcvt^%zewdAPI(pageName,"l"))="action"
 s fname=""
 f  s fname=$o(uploadText(fname)) q:fname=""  d
 . s text=text_uploadText(fname)_$c(13,10)
 s text=text_" s Error=$$startSession^%zewdPHP("""_pageName_""",.%KEY,.%CGIEVAR,.sessionArray,.filesArray)"_$c(13,10)
 s stop=0
 s text=text_" s sessid=$g(sessionArray(""ewd_sessid""))"_$c(13,10)
 i $d(config("responseHeader")) d
 . s text=text_" d mergeArrayFromSession^%zewdAPI(.headers,""ewd.header"",sessid)"_$c(13,10)
 . s hname=""
 . f  s hname=$o(config("responseHeader",hname)) q:hname=""  d
 . . i hname="""Expires""",config("responseHeader",hname)="-1" q
 . . s text=text_" s headers("_hname_")="_config("responseHeader",hname)_$c(13,10)
 . s text=text_" d mergeArrayToSession^%zewdAPI(.headers,""ewd.header"",sessid)"_$c(13,10)
 . s text=text_" k headers"_$c(13,10)
 s text=text_" i Error[""Enterprise Web Developer Error :"",$g(sessionArray(""ewd_pageType""))=""ajax"" d"_$c(13,10)
 i $g(config("actionIfTimedOut"))'="" d
 . s text=text_" . s Error=""javascript:"_config("actionIfTimedOut")_" ;"""_$c(13,10)
 e  d
 . s text=text_" . s Error=$p(Error,"":"",2,200)"_$c(13,10)
 . s text=text_" . s Error=$$replaceAll^%zewdAPI(Error,""<br>"","": "")"_$c(13,10)
 . s text=text_" . s Error=""EWD runtime error: ""_Error"_$c(13,10)
 f i=1:1 d  q:stop
 . s line=$t(pre3Text+i)
 . i line["***END***" s stop=1 q
 . s line=$p(line,";;",2,200)
 . i $e(line,1,2)="**",'$d(uploadText) q  ; only add this if file upload required in this page
 . i $e(line,1,2)="**" s line=$e(line,3,$l(line))
 . s text=text_" "_line_$c(13,10)
 ; 
 set scriptOID=$$addElementToDOM^%zewdDOM("script",headOID,,.attr,text)
 ; 
 QUIT
 ;
pre3Text
 ;;i $e(Error,1,32)="Enterprise Web Developer Error :" d  QUIT 0
 ;;. n errorPage
 ;;. s errorPage=$g(sessionArray("ewd_errorPage"))
 ;;. i errorPage="" s errorPage="ewdError"
 ;;. i $g(sessionArray("ewd_pageType"))="ajax" s errorPage="ewdAjaxErrorRedirect"
 ;;. d writeHTTPHeader^%zewdGTMRuntime(sessionArray("ewd_appName"),errorPage,,,sessid,Error)
 ;;s stop=0
 ;;**i Error="" d saveUploadedFile^%zewdGTMRuntime(sessid)
 ;;i Error="" d  i stop QUIT 0
 ;;. n nextpage
 ;;. s nextpage=$$getSessionValue^%zewdAPI("ewd_nextPage",sessid)
 ;;. i nextpage'="" d
 ;;. . n x
 ;;. . d writeHTTPHeader^%zewdGTMRuntime(sessionArray("ewd_appName"),nextpage,$$getSessionValue^%zewdAPI("ewd_token",sessid),$$getSessionValue^%zewdAPI("ewd_pageToken",sessid))
 ;;. . s stop=1
 ;;i $$getSessionValue^%zewdAPI("ewd_warning",sessid)'="" d
 ;;. s Error=$$getSessionValue^%zewdAPI("ewd_warning",sessid)
 ;;. d deleteFromSession^%zewdAPI("ewd_warning",sessid)
 ;;w "HTTP/1.1 200 OK"_$c(13,10)
 ;;s ctype="text/html"
 ;;d mergeArrayFromSession^%zewdAPI(.headers,"ewd.header",sessid)
 ;;i $d(headers) d
 ;;. n lcname,name
 ;;. s name=""
 ;;. f  s name=$o(headers(name)) q:name=""  d
 ;;. . s lcname=$$zcvt^%zewdAPI(name,"l")
 ;;. . i lcname="content-type" s ctype=headers(name) q
 ;;. . w name_": "_headers(name)_$c(13,10)
 ;;w "Content-type: "_ctype_$c(13,10)
 ;;w $c(13,10)
 ;;QUIT 1
 ;;***END***
 ;;
errorPage ;;
 ;;<html>
 ;;<head>
 ;;<title>Enterprise Web Developer : An error has occurred</title>
 ;;<style type="text/css">
 ;;   body {background: #FEFBD2 ;}
 ;;   .headerBlock {width: 100% ; background : #111111 ; horizontal-align : center ; }
 ;;   .headerBlock[class] {width: 100% ; background : #111111 ; horizontal-align : center ; position: relative ; top : 30px ; border-right-style : solid ; border-right-width: 2px ; }
 ;;   #headerText {vertical-align: center ; font-family: Arial, sans-serif ; color: #dddddd ; font-size: 11pt ; margin-left: 10px}
 ;;   #headerSubject {vertical-align: center ; font-family: Arial, sans-serif ; color: #dddddd ; font-size: 11pt ; position: relative ; top: -30px ; text-align: center ;}
 ;;   .selectedTab {border-style: outset ; background: #eeeedd ; padding-left: 8px ; padding-right: 8px ;}
 ;;   .unselectedTab {border-style: groove ; padding-left: 8px ; padding-right: 8px ;}
 ;;   #tabs {cursor : pointer ; height: 20px ;  background : #cccccc ; text-align: center ; position: relative ; left: 25px ; font-family : Arial, Helvetica, sens-serif ; font-size: 11pt}
 ;;   #mainArea {background : #efefee ; padding: 0 ; horizontal-align: center ; width : 100% ; height: auto ; border-style: solid ; border-left-width: 1px ; border-right-width: 1px ; padding-top : 0px ; margin-top : 0px}
 ;;   #workArea {background : #EEEEDD ; horizontal-align: center ; position: relative ; top: -6px ; left: 25px ; width : 95% ; height: auto ; font-family : Arial, Helvetica, sens-serif ; font-size: 12pt ; border-style: outset}
 ;;   #pageTitle {width: 100% ; height: 50px ; text-align : center ; horizontal-align : center ; font-family: Arial, sans-serif ;}
 ;;   .footerBlock {width: 100% ; background : #111111 ; horizontal-align : center ;}
 ;;   .footerBlock[class] {width: 100% ; background : #111111 ; horizontal-align : center ; position: relative ; top : -15px ; border-right-style : solid ; border-right-width: 2px ; }
 ;;   #footerText {vertical-align: center ; font-family: Arial, sans-serif ; color: #dddddd ; font-size: 8pt ; margin-left : 10px}
 ;;   #tableblock {text-align: center ; margin-top: 40px}
 ;;   #hiddenForm {visibility: hidden ;}
 ;;</style>
 ;;</head>
 ;;<body>
 ;;     <div class="headerBlock">
 ;;        <p id="headerText">&nbsp;M/Gateway Developments</p>
 ;;     </div>
 ;;
 ;;      <div id="mainArea">
 ;;        <div id="pageTitle">
 ;;           <h1>ewd_Version</h1>
 ;;        </div>
 ;;
 ;;        <div id="workArea">
 ;;          <div id="tableblock">
 ;;           <h3>An Error has occurred</h3>
 ;;           <br>
 ;;           <h3>The specified ewd_missing does not exist</h3>
 ;;          </div>
 ;;        </div>
 ;;     </div>
 ;;
 ;;     <div class=footerBlock>
 ;;              <p id="footerText">&nbsp;&copy; 2004-2008 M/Gateway Developments Ltd All Rights Reserved</p>
 ;;     </div>
 ;;</body>
 ;;</html>
 ;;***END***
