%zewdVistARPC	; EWD Open Source / Stateless VistA RPC core functions
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
connect(inputs,results)
 ;
 n no,sessid,token
 ;
 s no=0
 f  s no=$o(^XTV(8989.3,1,"INTRO",no)) q:no=""  d
 . s results("message",no)=$g(^XTV(8989.3,1,"INTRO",no,0))
 ;
 ; ASP.NET_SessionId=cszrlmofjvpktoksqx13x1nd; path=/; HttpOnly
 ;
 s sessid=$g(inputs("sessid"))
 s token=$$createToken^%zewdPHP(sessid)
 s results("token")=token
 QUIT ""
 ;
login(inputs,results)
 ;
 n %,accessCode,accver,DILOCKTM,displayPersonName,DISYS,%DT,DT,DTIME,DUZ,%H
 n %I,I,IO,IOF,IOM,ION,IOS,IOSL,IOST,IOT,J,personDuz,personName
 n POP,termReason,U,user,V4WVCC,V4WCVMSG
 n X,XOPT,XPARSYS,XQVOL,XQXFLG,XUCI,XUDEV,XUENV,XUEOFF,XUEON
 n XUF,XUFAC,XUIOP,XUVOL,XWBSTATE,XWBTIME,Y,verifyCode
 ;
 s accessCode=$g(inputs("accessCode"))
 i accessCode="" s accessCode=$g(inputs("username"))
 i accessCode="" QUIT "Missing account ID"
 ;
 s verifyCode=$g(inputs("verifyCode"))
 i verifyCode="" s verifyCode=$g(inputs("pwd"))
 i verifyCode="" QUIT "Missing account password"
 ;
 ; special for testing on non-VistA system
 ;
 i $g(inputs("bypass"))=1 s X="" d  QUIT X
 . i accessCode'="rob" s X="Invalid access code" q
 . i verifyCode'="rob" s X="Invalid verify code" q
 . s results("DT")=1
 . s results("DUZ")=1
 . s results("username")="rob"
 . s results("displayName")="Rob Tweed"
 . s results("greeting")="Hi Rob! You are now logged in as a test user"
 ;
 k results
 s U="^"
 d NOW^%DTC
 s DT=X
 s (IO,IO(0),IOF,IOM,ION,IOS,IOSL,IOST,IOT)=""
 s POP=0
 ;
 s accver=accessCode_";"_verifyCode
 s accver=$$ENCRYP^XUSRB1(accver)
 d SETUP^XUSRB()
 d VALIDAV^XUSRB(.user,accver)
 s personDuz=user(0)
 ;
 ;KBAZ/ZAG - add logic to check if verify code needs to be changed.
 ;0 = VC does not need to be changed
 ;1 = VC needs to be changed
 s V4WVCC=$g(user(2))
 s V4WCVMSG=$g(user(3)) ;sign in message
 ;
 s termReason=""
 i 'personDuz,$G(DUZ) s termReason=": "_$$GET1^DIQ(200,DUZ_",",9.4) ;Termination reason
 i 'personDuz QUIT user(3)_termReason
 ;
 s personName=$p(^VA(200,personDuz,0),"^")
 s displayPersonName=$p(personName,",",2)_" "_$p(personName,",")
 ;
 s results("DT")=DT
 s results("DUZ")=personDuz
 s results("username")=personName
 s results("displayName")=displayPersonName
 s results("greeting")=$g(user(7))
 QUIT ""
 ;
getClinics(inputs,results)
 ;
 n clinics,no,DT,U 
 ;
 s U="^"
 s DT=$g(inputs("DT"))
 k results
 d CLINLOC^ORWU(.clinics,$g(inputs("seed")),1)
 ;f i=1:1:10 s clinics(i)=i_U_"Clinic "_i
 s no=""
 f  s no=$o(clinics(no)) q:no=""  d
 . s results("clinics",no,"ien")=$p(clinics(no),U,1)
 . s results("clinics",no,"name")=$p(clinics(no),U,2)
 . s results("count")=no
 ;
 QUIT ""
 ;
getPatientsByClinic(inputs,results)
 ;
 ; date format: yyyymmdd
 ;
 n apptNode,apptStatus,apptTime,apptTimeFM,clinicId,date,endDateFM,months,no
 n patientDfn,patientName,startDateFM,scheduledList,totalCount,U,apptLength,CIts,COts
 ;
 s U="^"
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
 i $g(inputs("startDate"))="" d
 . s date=$$decDate^%zewdAPI($h-60)
 . s inputs("startDate")=$p(date," ",3)_months($p(date," ",2))_$p(date," ",1)
 i $g(inputs("stopDate"))="" d
 . s date=$$decDate^%zewdAPI($h+12)
 . s inputs("stopDate")=$p(date," ",3)_months($p(date," ",2))_$p(date," ",1)
 ;
 s clinicId=$g(inputs("clinicId"))
 s startDateFM=$$HL7TFM^XLFDT($g(inputs("startDate")))
 s endDateFM=$$HL7TFM^XLFDT($g(inputs("stopDate")))
 s scheduledList(1)=""_startDateFM_";"_endDateFM_"" 
 s scheduledList(2)=clinicId
 s scheduledList("FLDS")="3;4;5;6;9;11" ;cpc
 ;3 = appointment status
 ;4 = patient name and dfn
 ;6 = comments
 ;9 = check-in date/time
 ;5 = appointment length ;;cpc
 ;11 = check-out date/time ;cpc
 ;
 k results
 s totalCount=$$SDAPI^SDAMA301(.scheduledList)
 s results("totalCount")=totalCount
 s results("clinicId")=clinicId
 ;
 s patientDfn="",no=0
 f  s patientDfn=$o(^TMP($J,"SDAMA301",clinicId,patientDfn)) q:patientDfn=""  d
 . s apptTimeFM=""
 . f  s apptTimeFM=$o(^TMP($J,"SDAMA301",clinicId,patientDfn,apptTimeFM)) q:apptTimeFM=""  d
 . . s apptTime=$$FMTE^XLFDT(apptTimeFM)
 . . s apptNode=$g(^TMP($J,"SDAMA301",clinicId,patientDfn,apptTimeFM))
 . . s apptStatus=$p(apptNode,U,3)
 . . s apptStatus=$p(apptStatus,";",2)
 . . s apptLength=$p(apptNode,U,5) ;cpc
 . . s CIts=$p(apptNode,U,9) ;cpc
 . . i CIts'="" s CIts=$$FMTE^XLFDT(CIts) ;cpc
 . . s COts=$p(apptNode,U,11) ;cpc
 . . i COts'="" s COts=$$FMTE^XLFDT(COts) ;cpc
 . . s patientName=$p(^DPT(patientDfn,0),U)
 . . s no=no+1
 . . s results("schedule",no,"patientName")=patientName
 . . s results("schedule",no,"apptStatus")=apptStatus
 . . s results("schedule",no,"apptTime")=apptTime
 . . s results("schedule",no,"apptLength")=apptLength ;cpc
 . . s results("schedule",no,"checkInTimestamp")=CIts
 . . s results("schedule",no,"checkOutTimestamp")=COts
 ;
 ;clean up TMP array for this job
 i totalCount'=0 K ^TMP($J,"SDAMA301")
 ;
 QUIT ""
 ;
