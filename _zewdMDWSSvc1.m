%zewdMDWSSvc1	; OpenMDWS service method wrappers
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
 ;QUIT
 ;
 ;
login(sessid,localCall)
 ;
 n array,attrs,facade,inputs,ok,originalSessid,outerTag,results,siteId
 ;
 s ok=$$invoke^%zewdMDWS("login",localCall,.results,.originalSessid,sessid)
 i 'ok QUIT ""
 ;
 s siteId=$$getSessionValue^%zewdAPI("vista.systemId",originalSessid)
 s outerTag="UserTO"
 d outerTag^%zewdMDWS(.array,outerTag,sessid)
 s array(outerTag,"name")=$g(results("username"))
 s array(outerTag,"SSN")=$g(results("SSN"))
 s array(outerTag,"DUZ")=$g(results("DUZ"))
 s array(outerTag,"siteId")=siteId
 s array(outerTag,"greeting")=$g(results("greeting"))
 d createOutput^%zewdMDWS(localCall,.array,sessid)
 ;
 d setSessionValue^%zewdAPI("DT",$g(results("DT")),originalSessid)
 d setSessionValue^%zewdAPI("DUZ",$g(results("DUZ")),originalSessid)
 d setSessionValue^%zewdAPI("username",$g(results("username")),originalSessid)
 ;
 QUIT ""
 ;
getClinics(sessid,localCall)
 ;
 n array,name,no,ok,originalSessid,outerTag,results,siteId
 ;
 s ok=$$invoke^%zewdMDWS("getClinics",localCall,.results,.originalSessid,sessid)
 i 'ok QUIT ""
 ;
 s siteId=$$getSessionValue^%zewdAPI("vista.systemId",originalSessid)
 ;
 s outerTag="TaggedHospitalLocationArray"
 d outerTag^%zewdMDWS(.array,outerTag,sessid)
 s array(outerTag,"count")=$g(results("count"))
 s array(outerTag,"tag")=siteId
 s no=""
 f  s no=$o(results("clinics",no)) q:no=""  d
 . s array(outerTag,"locations","HospitalLocationTO",no,"id")=$g(results("clinics",no,"ien"))
 . f name="name","department","service","specialty","physicalLocation","askForCheckIn" d
 . . s array(outerTag,"locations","HospitalLocationTO",no,name)=$g(results("clinics",no,name))
 ;
 d createOutput^%zewdMDWS(localCall,.array,sessid)
 QUIT ""
 ;
getPatientsByClinic(sessid,localCall)
 ;
 n aptDate,array,name,no,ok,originalSessid,outerTag,results,siteId
 ;
 s ok=$$invoke^%zewdMDWS("getPatientsByClinic",localCall,.results,.originalSessid,sessid)
 i 'ok QUIT ""
 ;
 s siteId=$$getSessionValue^%zewdAPI("siteId",originalSessid)
 ;
 s outerTag="PatientArray"
 d outerTag^%zewdMDWS(.array,outerTag,sessid)
 s array(outerTag,"count")=$g(results("totalCount"))
 s array(outerTag,"tag")=siteId
 s no=""
 f  s no=$o(results("schedule",no)) q:no=""  d
 . s array(outerTag,"patients","PatientTO",no,"name")=$g(results("schedule",no,"patientName"))
 . s array(outerTag,"patients","PatientTO",no,"patientName")=$g(results("schedule",no,"patientName"))
 . s array(outerTag,"patients","PatientTO",no,"location","id")=$g(results("clinicId"))
 . ;
 . s aptDate=$$convertVistAAtDate^%zewdMDWSClient($g(results("schedule",no,"apptTime"))) ;cpc
 . s array(outerTag,"patients","PatientTO",no,"location","appointmentTimestamp")=aptDate
 . s array(outerTag,"patients","PatientTO",no,"location","appointmentLength")=$g(results("schedule",no,"apptLength"))
 . s array(outerTag,"patients","PatientTO",no,"location","status")=$g(results("schedule",no,"apptStatus"))
 . s array(outerTag,"patients","PatientTO",no,"location","checkInTimestamp")=$$convertVistAAtDate^%zewdMDWSClient($g(results("schedule",no,"checkInTimestamp")))
 . s array(outerTag,"patients","PatientTO",no,"location","checkOutTimestamp")=$$convertVistAAtDate^%zewdMDWSClient($g(results("schedule",no,"checkOutTimestamp")))_$c(1)
 d createOutput^%zewdMDWS(localCall,.array,sessid)
 ;
 QUIT ""
 ;
