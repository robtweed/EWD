%zewdMDWSClient ; MDWS Client Interface
 ;
 ; Product: Enterprise Web Developer (Build 965)
 ; Build Date: Thu, 15 Aug 2013 17:14:16
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
 ;
 QUIT
 ;
getPath(method,nvps,sessid,params)
 ;
 n facade,path,version
 ;
 ;s version=$$getSessionValue^%zewdAPI("mdws.version",sessid)
 s version=$$getParam("mdws.version",sessid,.params)
 i version="" s version="openMDWS"
 ;s facade=$$getSessionValue^%zewdAPI("mdws.facade",sessid)
 s facade=$$getParam("mdws.facade",sessid,.params)
 i facade="" s facade="EmrSvc"
 ;s path=$$getSessionValue^%zewdAPI("mdws.path",sessid)
 s path=$$getParam("mdws.path",sessid,.params)
 i version="openMDWS" d  QUIT path
 . i path="" s path="/vista/"
 . i $e(path,$l(path))'="/" s path=path_"/"
 . s nvps("facade")=facade
 . s nvps("method")=method
 . s path=path_"openMDWS/get.ewd"
 ;
 ;. s path=path_"openMDWS/get.ewd?facade="_facade_"&method="_method
 ;. i $d(nvps) d
 ;. . n delim,name
 ;. . s delim="&"
 ;. . s name=""
 ;. . f  s name=$o(nvps(name)) q:name=""  d
 ;. . . s path=path_delim_name_"="_$$urlEscape^%zewdSmart(nvps(name))
 ;
 ;
 ;QUIT ""
 i path="" s path="/mdws2/"
 s path=path_facade_".asmx/"_method
 i $d(nvps) d
 . ; nvps(name)=value
 . n delim,name
 . s delim="?"
 . s name=""
 . f  s name=$o(nvps(name)) q:name=""  d
 . . s path=path_delim_name_"="_nvps(name)
 . . s delim="&"
 QUIT path
 ;
getValue(string)
 QUIT $p(string,$c(1),1)
 ;
isConnected(resultsArray)
 ;
 n value
 s value=$g(resultsArray("DataSourceArray","items","DataSourceTO","status"))
 QUIT $$getValue(value)="active"
 ;
 ;
isLoggedIn(resultsArray)
 ;
 n value
 s value=$g(resultsArray("UserTO","DUZ"))
 QUIT $$getValue(value)'=""
 ;
isFault(resultsArray)
 ;
 n fault,sub1
 ;
 s sub1=$o(resultsArray(""))
 i sub1="" QUIT 1
 m fault=resultsArray(sub1,"fault")
 QUIT $d(fault)
 ;
getFaultMessage(resultsArray)
 n fault,sub1,value
 s sub1=$o(resultsArray(""))
 i sub1="" QUIT "getFaultMessage^%zewdMDWSClient: failed to find resultsArray content"
 m fault=resultsArray(sub1,"fault")
 QUIT $$getValue($g(fault("message")))
 ;
convertVistAAtDate(di) ; convert Jan 23, 2012@0800 to 20120123.080000
 ;
 n d,date,do,m,months,time,y
 ;
 i $g(di)="" QUIT ""
 ;
 s months("Jan")="01"
 s months("Feb")="02"
 s months("Mar")="03"
 s months("Apr")="04"
 s months("May")="05"
 s months("Jun")="06"
 s months("Jul")="07"
 s months("Aug")="08"
 s months("Sep")="09"
 s months("Oct")="10"
 s months("Nov")="11"
 s months("Dec")="12"
 s date=$p(di,"@",1)
 s time=$p(di,"@",2)
 s m=$p(date," ",1)
 s m=months(m)
 s date=$p(date," ",2,10)
 ;s d=+date
 s d=$p(date,",",1) ;cpc 29/11/2012
 s y=$p(date,", ",2)
 s do=y_m_d_"."_$tr(time,":","")_"00"
 QUIT do
 ;
convertVistADate(di,t) ;convert internal VistA date format to output
 ;
 n date,y,m,mn,d,h,s
 ;
 i $g(di)="" QUIT ""
 ;t=1 returns time
 ;t=2 returns $h
 ;t=3 returns reformatted date and time
 ;t=4 returns reformatted date
 s date=$g(di),t=$g(t)
 s y=$e(date,1,4)
 s mn=$e(date,5,6)
 s d=$e(date,7,8)
 s h=$e(date,10,11)
 s m=$e(date,12,13)
 s s=$e(date,14,15)
 i t=1 QUIT ((h*3600)+(m*60)+s)
 ;i t=2 QUIT $$encodeDate^%zewdGTM(mn_"/"_d_"/"_y)
 i t=2 QUIT $$encodeDate^%zewdGTM(mn_"/"_d_"/"_y)
 i t=3 QUIT mn_"/"_d_"/"_y_" "_h_":"_m_":"_s
 i t=4 QUIT mn_"/"_d_"/"_y
 QUIT ""
 ;
getLoginData(resultsArray,data)
 n value
 ;
 k data
 s data("DUZ")=$$getValue($g(resultsArray("UserTO","DUZ")))
 s data("name")=$$getValue($g(resultsArray("UserTO","name")))
 s data("SSN")=$$getValue($g(resultsArray("UserTO","SSN")))
 QUIT ""
 ;
getClinicData(results,data)
 n count,i,id,name
 ;
 k data
 s count=$$getValue($g(results("TaggedHospitalLocationArray","count")))
 f i=1:1:count d
 . s id=$$getValue($g(results("TaggedHospitalLocationArray","locations","HospitalLocationTO",i,"id")))
 . s name=$$getValue($g(results("TaggedHospitalLocationArray","locations","HospitalLocationTO",i,"name")))
 . s data(i,"nvp")="clinicNo="_i
 . s data(i,"text")=name
 . s data(i,"clinicId")=id
 QUIT ""
 ;
getClinicAppts(results,data)
 ;
 ;n CITime,COTime,count,d,date,h,i,id,m,mn,name,pid,s,y,length,status,ztime ;cpc 3/12/2012
 n apptId,CITime,clinicId,COTime,count,d,dateH,dob,h,i,id,m,mn,name,pid,s,site,ssn,y,length,status,time,ztime ;cpc 3/12/2012; cpc 4/2/2013 ;cpc 18/2/2013
 ;
 k data
 s site=$$getTextValue("/PatientArray/tag",.results) ;cpc 18/2/2013
 s count=$$getValue($g(results("PatientArray","count")))
 s count=$$getTextValue("/PatientArray/count",.results)
 f i=1:1:count d
 . s name=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/name",.results)
 . s pid=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/patientId",.results) ;cpc 3/12/2012
 . s dob=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/patientDOB",.results) ;cpc 4/2/2013
 . s ssn=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/patientSSN",.results) ;cpc 4/2/2013
 . s date=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/appointmentTimestamp",.results)
 . ;"20121009.080000"
 . s length=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/appointmentLength",.results)
 . s status=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/status",.results)
 . s CItime=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/checkInTimestamp",.results) ;cpc
 . s COtime=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/checkOutTimestamp",.results) ;cpc
 . s clinicId=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/id",.results) ;cpc 18/2/2013
 . ;10/08/2012 11:00:00
 . ;"Nov 20, 2012@07:29"
 . s dateH=$$convertVistADate(date,2) ;cpc 18/2/2013
 . s dob=$$convertVistADate(dob,2) ;cpc 18/2/2013
 . s time=$$convertVistADate(date,1) ;cpc 18/2/2013
 . ;s apptId=$$makeApptID^schedulerV(clinicId,pid,dateH_","_time,site) ;cpc 18/2/2012
 . s apptId=$$makeApptID^JJOHSCC0(clinicId,pid,dateH_","_time,site) ;cpc 18/2/2012 & 16/4/2013
 . s data(apptId,"patientId")=pid ;cpc 3/12/2012
 . s data(apptId,"name")=name
 . s data(apptId,"date")=dateH
 . s data(apptId,"DOB")=dob ;cpc 18/2/2013
 . s data(apptId,"SSN")=ssn ; cpc 4/2/2013
 . s data(apptId,"time")=time ;cpc 18/2/2013
 . s ztime=$$decodeTime^%zewdMgr2((time+(length*60))) ;cpc as above but vendor agnostic ;cpc 18/2/2013
 . s data(apptId,"from")=$$convertVistADate(date,3)
 . s data(apptId,"to")=$$convertVistADate(date,4)_" "_ztime ;cpc
 . s data(apptId,"length")=length ;cpc 
 . s data(apptId,"status")=status ; cpc
 . s data(apptId,"CItime")=$$convertVistADate(CItime,3) ;cpc
 . s data(apptId,"COtime")=$$convertVistADate(COtime,4) ;cpc
 QUIT ""
 ;
getParam(name,sessid,params)
 ;
 n remoteId,value
 ;
 s remoteId=$g(params("remoteId"))
 s value=""
 i remoteId'="",'$d(params(name)) d  QUIT value
 . i $g(name)="mdws.cookie" d  q
 . . n cookies
 . . d mergeArrayFromSession^%zewdAPI(.cookies,"mdws_cookies",sessid)
 . . s value=$g(cookies(remoteId))
 . i $g(name)="mdws.host" s value=$g(^zewd("openMDWS","control","remote",remoteId,"host")) q
 . i $g(name)="vista.host" s value=$g(^zewd("openMDWS","control","local","host")) q
 . i $g(name)="mdws.version" s value=$g(^zewd("openMDWS","control","remote",remoteId,"version")) q
 . i $g(name)="mdws.port" s value=$g(^zewd("openMDWS","control","remote",remoteId,"port")) q
 . i $g(name)="mdws.path" s value=$g(^zewd("openMDWS","control","remote",remoteId,"path")) q
 . i $g(name)="vista.sslProxyPort" s value=$g(^zewd("openMDWS","control","local","sslProxyPort")) q
 . i $g(name)="vista.sslProxyHost" s value=$g(^zewd("openMDWS","control","local","sslProxyHost")) q
 ;
 s value=$$getSessionValue^%zewdAPI(name,sessid)
 i $g(params(name))'="" s value=params(name)
 QUIT value
 ;
request(serviceName,nvps,results,sessid,params)
 ;
 n cookie,docName,headers,host,name,no,ok,path,port,remoteId,sslHost,sslPort,value,vistaHost
 ;
 ;d setSessionValue^%zewdAPI("vista.systemId","smart2",sessid)
 ;d setSessionValue^%zewdAPI("mdws.host","smart2.vistaewd.net",sessid)
 ;d setSessionValue^%zewdAPI("mdws.facade","SchedulingSvc",sessid)
 ;d setSessionValue^%zewdAPI("mdws.version","openMDWS",sessid)
 ;d setSessionValue^%zewdAPI("vista.host","smart2.vistaewd.net",sessid)
 ;
 s docName="openMDWSResponse"_$j
 i $g(params("outputFormat"))'="" d setSessionValue^%zewdAPI("mdws.outputFormat",params("outputFormat"),sessid)
 d setSessionValue^%zewdAPI("docName",docName,sessid)
 ;s host=$$getSessionValue^%zewdAPI("mdws.host",sessid)
 ;i $$getSessionValue^%zewdAPI("vista.host",sessid)=host d  QUIT ""
 ;s host=$$getSessionValue^%zewdAPI("mdws.host",sessid)
 s remoteId=$g(params("remoteId"))
 s host=$$getParam("mdws.host",sessid,.params)
 s vistaHost=$$getParam("vista.host",sessid,.params)
 ;i $$getSessionValue^%zewdAPI("vista.host",sessid)=host d  QUIT ""
 ; ****************
 i $g(^zewd("trace")) d
 . n ix
 . s ix=$increment(^robDump)
 . m ^robDump(ix,"params")=params
 . s ^robDump(ix,"vistaHost")=vistaHost
 . s ^robDump(ix,"host")=host
 ; ****************
 i vistaHost=host d  QUIT ""
 . ; local invocation, so bypass HTTP request
 . n facade,func,name,x
 . k results
 . d deleteFromSession^%zewdAPI("mdws_params",sessid)
 . d mergeArrayToSession^%zewdAPI(.nvps,"mdws_params",sessid)
 . i serviceName="connect" s nvps("sessid")=sessid
 . d setSessionValue^%zewdAPI("mdws.originalSessid",sessid,sessid)
 . ;s facade=$$getSessionValue^%zewdAPI("mdws.facade",sessid)
 . s facade=$$getParam("mdws.facade",sessid,.params)
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("*** facade="_facade_"; method="_serviceName)
 . d setSessionValue^%zewdAPI("mdws.useFacade",facade,sessid)
 . s func=$g(^%zewd("openMDWS","mappings",facade,serviceName,"MDWSWrapper"))
 . s x="s ok=$$"_func_"(sessid,1)"
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("** request^%zewdMDWSClient - about to execute x="_x)
 . x x
 . d mergeArrayFromSession^%zewdAPI(.results,docName,sessid)
 . i serviceName="connect",$g(results("cookie"))'="" d
 . . d setSessionValue^%zewdAPI("mdws.cookie",results("cookie"),sessid)
 . . i $g(params("remoteId"))'="" d
 . . . n cookies
 . . . s cookies(params("remoteId"))=results("cookie")
 . . . d mergeArrayToSession^%zewdAPI(.cookies,"mdws_cookies",sessid)
 . . k results("cookie")
 . ;k nvps
 ;
 ;s port=$$getSessionValue^%zewdAPI("mdws.port",sessid)
 s port=$$getParam("mdws.port",sessid,.params)
 ;s cookie=$$getSessionValue^%zewdAPI("mdws.cookie",sessid)
 s cookie=$$getParam("mdws.cookie",sessid,.params)
 s path=$$getPath(serviceName,.nvps,sessid,.params)
 s path=$$createSignedPath(host,path,.nvps,sessid)
 k nvps,results
 i $g(cookie)'="" s headers("Cookie")=cookie
 ;s ok=$$parseURL^%zewdHTMLParser(host,path,docName,port,0,,,,,.headers)
 ;s sslPort=$$getSessionValue^%zewdAPI("vista.sslProxyPort",sessid)
 ;s sslHost=$$getSessionValue^%zewdAPI("vista.sslProxyHost",sessid)
 s sslPort=$$getParam("vista.sslProxyPort",sessid,.params)
 s sslHost=$$getParam("vista.sslProxyHost",sessid,.params)
 d
 . i sslPort'="",sslHost="" s sslHost="127.0.0.1" q
 . i sslHost'="",sslPort="" s sslPort=89
 ; ****************************** 
 i $g(^zewd("trace")) d
 . s ^robDump(ix,"path")=path
 . s ^robDump(ix,"docName")=docName
 . s ^robDump(ix,"port")=port
 . s ^robDump(ix,"sslHost")=sslHost
 . s ^robDump(ix,"sslPort")=sslPort
 ; ********************************
 i $$getSessionValue^%zewdAPI("ewd_technology",sessid)="ewd" d
 . n header,ix,no,params,response
 . s params("host")=host
 . s params("port")=port
 . s params("path")=path
 . s params("post")=0 
 . s params("ssl")=1
 . s params("config")="vista"
 . s params("cookie")=cookie
 . s ix=$$sendHTTPRequest(.params)
 . m ^CacheTempEWD($j)=^CacheTempResponse(ix,"response")
 . s header=""
 . s no=0
 . f  s header=$o(^CacheTempResponse(ix,"headers",header)) q:header=""  d
 . . s no=no+1
 . . s headers(no)=header_":"_^CacheTempResponse(ix,"headers",header)
 . k ^CacheTempResponse(ix)
 . s ok=$$removeDocument^%zewdDOM(docName,0,0)
 . s ok=$$parseDocument^%zewdHTMLParser($g(docName),0)
 . k ^CacheTempEWD($j)
 e  d
 . s ok=$$parseURL^%zewdHTMLParser(host,path,docName,port,0,,,,,.headers,sslHost,sslPort)
 ; ******************************************
 i $g(^zewd("trace")) i $$cloneDocument^%zewdDOM(docName,"rob"_ix)
 ; ******************************************
 d XML2Array(docName,.results)
 ; ********************************
 i $g(^zewd("trace")) m ^robDump(ix,"results")=results
 ; ********************************
 i $$removeDocument^%zewdDOM(docName)
 i serviceName="connect" d
 . n header,stop
 . ; ***********************************
 . i $g(^zewd("trace")) m ^robDump(ix,"headers")=headers
 . ; ************************************
 . s no="",stop=0
 . f  s no=$o(headers(no)) q:no=""  d  q:stop
 . . s header=headers(no)
 . . s name=$$zcvt^%zewdAPI($p(header,":",1),"U")
 . . i name="SET-COOKIE" d
 . . . s value=$p(header,":",2,1000)
 . . . d setSessionValue^%zewdAPI("mdws.cookie",value,sessid)
 . . . i $g(remoteId)'="" d
 . . . . n cookies
 . . . . s cookies(remoteId)=value
 . . . . d mergeArrayToSession^%zewdAPI(.cookies,"mdws_cookies",sessid)
 . . . s stop=1
 QUIT ok
 ;
 ;
XML2Array(nodeOID,array)
 ;
 n ok,responseLineNo
 ;
 s responseLineNo=1
 k array
 i nodeOID'?1N.N1"-"1N.N s nodeOID=$$getDocumentNode^%zewdDOM(nodeOID)
 i $g(nodeOID)="" QUIT
 i '$$nodeExists^%zewdDOM(nodeOID) QUIT
 d outputNodeAsArray(nodeOID,.array)
 QUIT
 ;
outputNodeAsArray(nodeOID,array)
 ;
 n nodeType
 ;
 s nodeType=$$getNodeType^%zewdDOM(nodeOID)
 i nodeType=9 d
 . n childOID
 . s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 . i childOID'="" d outputNodeAsArray(childOID,.array)
 i nodeType=7 d
 . n childOID
 . s childOID=$$getNextSibling^%zewdDOM(nodeOID)
 . i childOID'="" d outputNodeAsArray(childOID,.array)
 ;
 i nodeType=1 d
 . n attrName,attrs,childOID,childTagName,comma,count,no,noOfInstances,ok
 . n siblingOID,tagName,text,textArray
 . s tagName=$$getTagName^%zewdDOM(nodeOID)
 . s text=$$getElementText^%zewdDOM(nodeOID,.textArray)
 . i text'="***Array***" d
 . . s array(tagName)=text ;_$c(1)_"text"
 . e  d
 . . n lineNo
 . . s lineNo=""
 . . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . . s array(tagName,"#text",0)=lineNo
 . . . s array(tagName,"#text",lineNo)=textArray(lineNo)
 . d getAttributeValues^%zewdDOM(nodeOID,.attrs)
 . s attrName=""
 . f  s attrName=$o(attrs(attrName)) q:attrName=""  d
 . . s array(tagName,attrName)=attrs(attrName)_$c(1)_"attr"
 . ; see if any child nodes are repeating
 . s childOID=""
 . f  d  q:childOID=""
 . . s childOID=$$getNextChild^%zewdDOM(nodeOID,childOID)
 . . q:childOID=""
 . . q:$$getNodeType^%zewdDOM(childOID)'=1
 . . s childTagName=$$getTagName^%zewdDOM(childOID)
 . . s no=$increment(noOfInstances(childTagName))
 . ;
 . f  d  q:childOID=""
 . . s childOID=$$getNextChild^%zewdDOM(nodeOID,childOID)
 . . q:childOID=""
 . . q:$$getNodeType^%zewdDOM(childOID)'=1
 . . s childTagName=$$getTagName^%zewdDOM(childOID)
 . . i noOfInstances(childTagName)>1 d
 . . . n no,subArray
 . . . s no=$increment(count(childTagName))
 . . . d outputNodeAsArray(childOID,.subArray)
 . . . m array(tagName,no)=subArray
 . . e  d
 . . . n subArray
 . . . d outputNodeAsArray(childOID,.subArray)
 . . . m array(tagName)=subArray
 ;
 QUIT
 ;
getTextValue(path,array)
 ;
 n comma,d,i,np,prev,sub,subs,value,x
 ;
 s subs="",comma=""
 i $e(path,1)="/" s path=$e(path,2,$l(path))
 s np=$l(path,"/")
 f i=1:1:np d
 . s sub=$p(path,"/",i)
 . s prev=subs
 . i subs'="",sub'?1N.N d
 . . s x="s d=$d("_$name(array)_"("_subs_",1))"
 . . x x
 . . i d s subs=subs_",1"
 . s subs=subs_comma_""""_sub_""""
 . s comma=","
 . i sub=1 d
 . . s x="s d=$d("_$name(array)_"("_subs_"))"
 . . x x
 . . i d=0 s subs=prev
 ;
 s x="s value=$g("_$name(array)_"("_subs_"))"
 x x
 ;
 QUIT $p(value,$c(1),1)
 ;
 ;
testingS
 k nvpList
 s host="www.mgateway.com:58080"
 s path="/vista/openMDWS/get.ewd"
 s nvpList("facade")="SchedulingSvc"
 s nvpList("method")="getClinics"
 s nvpList("target")=""
 ;
 ; this stuff would normally be available automatically
 s systemId="Oroville_Hospital"
 s ^zewd("openMDWS","systemId")=systemId
 s ^zewd("openMDWS","systemKey",systemId)="th1s1sa5ecret"
 s sessid=0
 d setSessionValue^%zewdAPI("ewd_port",8081,sessid)
 ;
 s path=$$createSignedPath(host,path,.nvpList,sessid)
 QUIT
 ;
testingS2
 s params("remoteId")="VATest_California"
 s serviceName="connect"
 s nvps("sitelist")="VATest_California"
 s sessid=0
 d setSessionValue^%zewdAPI("ewd_port",8081,sessid)
 d setSessionValue^%zewdAPI("ewd_technology","ewd",sessid)
 s ok=$$request(serviceName,.nvps,.results,sessid,.params)
 QUIT
 ;
createSignedPath(host,path,nvpList,sessid)
 ;
 n amp,n,ok
 ;
 ; pre-escape incoming name/value pairs
 s n=""
 f  s n=$o(nvpList(n)) q:n=""  d
 . s nvpList(n)=$$urlEscape(nvpList(n))
 ;
 s amp=""
 s ok=$$createSignature(host,path,.nvpList,sessid)
 s path=path_"?"
 s n=""
 f  s n=$o(nvpList(n)) q:n=""  d
 . s path=path_amp_n_"="_nvpList(n)
 . s amp="&"
 ;
 QUIT path
 ;
createSignature(host,path,nvpList,sessid)
 ;
 n secretKey,signature,stringToSign,systemId
 ;
 s systemId=$g(^zewd("openMDWS","control","local","id"))
 i systemId="" QUIT 0
 s nvpList("systemId")=systemId
 s secretKey=$g(^zewd("openMDWS","control","local","systemKey"))
 i secretKey="" QUIT 0
 s stringToSign=$$createRequestStringToSign(host,path,.nvpList)
 d trace^%zewdAPI("stringToSign: "_stringToSign)
 s signature=$$getSignedString(stringToSign,secretKey,sessid)
 s nvpList("signature")=signature
 QUIT 1
 ;
createRequestStringToSign(host,path,nvpList)
 ;
 n stringToSign 
 ;
 s nvpList("timestamp")=$$convertDateToSeconds^%zewdAPI($h)
 s stringToSign=$$createStringToSign(.nvpList)
 s stringToSign="POST"_$c(10)_host_$c(10)_path_$c(10)_stringToSign
 QUIT stringToSign
 ;
createStringToSign(nvpList)
 ;
 n amp,n,name,nlc,nvpListlc,stringToSign,value
 ;
 s stringToSign=""
 s n="",amp=""
 f  s n=$o(nvpList(n)) q:n=""  d
 . s name=$$urlEscape(n)
 . s value=nvpList(n)
 . s stringToSign=stringToSign_amp_name_"="_value
 . s amp="%26"
 QUIT stringToSign
 ;
urlEscape(string)
 ;The unreserved characters are A-Z, a-z, 0-9, hyphen ( - ), underscore ( _ ), period ( . ), and tilde ( ~ ). 
 ;i string?1AN.AN QUIT string
 n a,c,esc,i,pass
 f i=45,46,95,126 s pass(i)=""
 s esc=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . i c?1AN,$a(c)<128 s esc=esc_c q
 . s a=$a(c)
 . i $d(pass(a)) s esc=esc_c q
 . s a=$$hex(a)
 . s esc=esc_"%"_$$zcvt^%zewdAPI(a,"u")
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
getSignedString(string,secretKey,sessid)
 ;
 n params
 ;
 s params("string")=string
 s params("key")=secretKey
 s params("mode")="request"
 QUIT $$createDigest^%zewdMDWS(.params,sessid)
 ;
