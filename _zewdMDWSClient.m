%zewdMDWSClient ; MDWS Client Interface
 ;
 ; Product: Enterprise Web Developer (Build 944)
 ; Build Date: Fri, 23 Nov 2012 17:15:07
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
getPath(method,nvps,sessid)
 ;
 n facade,path,version
 ;
 s version=$$getSessionValue^%zewdAPI("mdws.version",sessid)
 i version="" s version="openMDWS"
 s facade=$$getSessionValue^%zewdAPI("mdws.facade",sessid)
 i facade="" s facade="EmrSvc"
 s path=$$getSessionValue^%zewdAPI("mdws.path",sessid)
 i version="openMDWS" d  QUIT path
 . i path="" s path="/vista/"
 . i $e(path,$l(path))'="/" s path=path_"/"
 . s path=path_"openMDWS/get.ewd?facade="_facade_"&method="_method
 . i $d(nvps) d
 . . n delim,name
 . . s delim="&"
 . . s name=""
 . . f  s name=$o(nvps(name)) q:name=""  d
 . . . s path=path_delim_name_"="_$$urlEscape^%zewdSmart(nvps(name))
 ;
 ;
 QUIT ""
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
 s d=+date
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
 i t=2 QUIT $$encodeDate^%zewdGTM(mn_"/"_d_"/"_y)
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
 n CITime,COTime,count,d,date,h,i,id,m,mn,name,s,y,length,status,ztime
 ;
 k data
 s count=$$getValue($g(results("PatientArray","count")))
 s count=$$getTextValue("/PatientArray/count",.results)
 f i=1:1:count d
 . s name=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/name",.results)
 . s date=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/appointmentTimestamp",.results)
 . ;"20121009.080000"
 . s length=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/appointmentLength",.results)
 . s status=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/status",.results)
 . s CItime=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/checkInTimestamp",.results) ;cpc
 . s COtime=$$getTextValue("/PatientArray/patients/PatientTO/"_i_"/location/checkOutTimestamp",.results) ;cpc
 . ;10/08/2012 11:00:00
 . ;"Nov 20, 2012@07:29"
 . s data(i,"name")=name
 . s data(i,"date")=$$convertVistADate(date,2)
 . s data(i,"time")=$$convertVistADate(date,1)
 . ;s ztime=$ZDATE(","_(data(i,"time")+(length*60)),"24:60:SS") ;assuming length always in minutes ; Rob ?non version specific code;cpc
 . s ztime=$$decodeTime^%zewdMgr2((data(i,"time")+(length*60))) ;cpc as above but vendor agnostic
 . s data(i,"from")=$$convertVistADate(date,3)
 . s data(i,"to")=$$convertVistADate(date,4)_" "_ztime ;cpc
 . ;s data(i,"to")=mn_"/"_d_"/"_y_" "_(h+1)_":"_m_":"_s
 . s data(i,"length")=length ;cpc 
 . s data(i,"status")=status ; cpc
 . s data(i,"CItime")=$$convertVistADate(CItime,3) ;cpc
 . s data(i,"COtime")=$$convertVistADate(COtime,4) ;cpc
 QUIT ""
 ;
request(serviceName,nvps,results,sessid)
 ;
 n cookie,docName,headers,host,name,no,ok,path,port,value
 ;
 ;d setSessionValue^%zewdAPI("vista.systemId","smart2",sessid)
 ;d setSessionValue^%zewdAPI("mdws.host","smart2.vistaewd.net",sessid)
 ;d setSessionValue^%zewdAPI("mdws.facade","SchedulingSvc",sessid)
 ;d setSessionValue^%zewdAPI("mdws.version","openMDWS",sessid)
 ;d setSessionValue^%zewdAPI("vista.host","smart2.vistaewd.net",sessid)
 ;
 s docName="openMDWSResponse"_$j
 d setSessionValue^%zewdAPI("docName",docName,sessid)
 s host=$$getSessionValue^%zewdAPI("mdws.host",sessid)
 i $$getSessionValue^%zewdAPI("vista.host",sessid)=host d  QUIT ""
 . ; local invocation, so bypass HTTP request
 . n facade,func,name,x
 . d deleteFromSession^%zewdAPI("mdws_params",sessid)
 . d mergeArrayToSession^%zewdAPI(.nvps,"mdws_params",sessid)
 . i serviceName="connect" s nvps("sessid")=sessid
 . d setSessionValue^%zewdAPI("mdws.originalSessid",sessid,sessid)
 . s facade=$$getSessionValue^%zewdAPI("mdws.facade",sessid)
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("*** facade="_facade_"; method="_serviceName)
 . s func=$g(^%zewd("openMDWS","mappings",facade,serviceName,"MDWSWrapper"))
 . s x="s ok=$$"_func_"(sessid,1)"
 . i $g(^zewd("trace"))=1 d trace^%zewdAPI("** request^%zewdMDWSClient - about to execute x="_x)
 . x x
 . d mergeArrayFromSession^%zewdAPI(.results,docName,sessid)
 . i serviceName="connect" d
 . . d setSessionValue^%zewdAPI("mdws.cookie",$g(results("cookie")),sessid)
 . . k results("cookie")
 ;
 s port=$$getSessionValue^%zewdAPI("mdws.port",sessid)
 s cookie=$$getSessionValue^%zewdAPI("mdws.cookie",sessid)
 s path=$$getPath(serviceName,.nvps,sessid)
 k nvps,results
 i $g(cookie)'="" s headers("Cookie")=cookie
 s ok=$$parseURL^%zewdHTMLParser(host,path,docName,port,0,,,,,.headers)
 d XML2Array(docName,.results)
 i $$removeDocument^%zewdDOM(docName)
 i serviceName="connect" d
 . n stop
 . s no="",stop=0
 . f  s no=$o(headers(no)) q:no=""  d  q:stop
 . . s header=headers(no)
 . . s name=$$zcvt^%zewdAPI($p(header,":",1),"U")
 . . i name="SET-COOKIE" d
 . . . s value=$p(header,":",2,1000)
 . . . d setSessionValue^%zewdAPI("mdws.cookie",value,sessid)
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
