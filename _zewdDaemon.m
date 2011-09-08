%zewdDaemon	; Enterprise Web Developer Background Daemon
 ;
 ; Product: Enterprise Web Developer (Build 882)
 ; Build Date: Thu, 08 Sep 2011 17:35:10
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
go
 ;
 n hangTime,stop
 ;
 l +^%zewd("daemon","lock"):0 e  QUIT  ; already running
 k ^%zewd("daemon","stop")
 s ^%zewd("daemon","use")="true" ; set this to indicate it should be running, so it can be restarted automatically if needed
 s stop=0
 s $zt="releaseLock"
 f  d  q:stop
 . s hangTime=$g(^%zewd("daemon","hangTime")) i hangTime="" s hangTime=300
 . d email
 . d deleteExpiredSessions^%zewdPHP
 . h hangTime
 . i $g(^%zewd("daemon","stop"))'="" s stop=1
 QUIT
 ;
releaseLock
 lock
 QUIT
 ;
email
 ;
 n authType,cc,data,from,mailServer,no,ok,password,smtpPort
 n subject,text,to,username
 ;
 s mailServer=$g(^%zewd("daemon","email","mailServer")) 
 i mailServer="" QUIT
 s smtpPort=$g(^%zewd("daemon","email","smtpPort")) 
 i smtpPort="" s smtpPort=25
 s authType=$g(^%zewd("daemon","email","authType"))
 ; null or LOGIN PLAIN.  If the latter, need username and password
 s username=$g(^%zewd("daemon","email","username"))
 s password=$g(^%zewd("daemon","email","password"))
 ;
 s no=""
 f  s no=$o(^%zewd("emailQueue",no)) q:no=""  d
 . s data=^%zewd("emailQueue",no,"data")
 . s from=$p(data,$c(1),1)
 . s to=$p(data,$c(1),2)
 . s subject=$p(data,$c(1),3)
 . m cc=^%zewd("emailQueue",no,"cc")
 . m text=^%zewd("emailQueue",no,"text")
 . s ok=$$sendMail(from,to,.cc,subject,.text,mailServer,smtpPort,authType,username,password)
 . k ^%zewd("emailQueue",no)
 QUIT
 ;
sendMail(from,to,cc,subject,text,server,port,authType,username,password)
 ;
 n auth,i,mail,msg,name,status
 ;	
 s status=$$smtpSend^%zewdGTM(server,from,"",to,"",.cc,subject,.text,.dialog,authType,username,password,,,port)
 QUIT status
 ;
queueMail(from,to,cc,subject,text)
 ;
 n data,no
 ;
 s data=from_$c(1)_to_$c(1)_subject_$c(1)_$h
 s no=$increment(^%zewd("emailQueue"))
 s ^%zewd("emailQueue",no,"data")=data
 m ^%zewd("emailQueue",no,"cc")=cc
 m ^%zewd("emailQueue",no,"text")=text
 QUIT
 ;
start()
 i $g(^%zewd("daemon","use"))'="true" QUIT ""
 l +^%zewd("daemon","lock"):0 e  QUIT ""  ; already running
 l -^%zewd("daemon","lock")
 j go^%zewdDaemon
 QUIT ""
 ;
stop()
 s ^%zewd("daemon","stop")=1
 QUIT ""
 ;
status()
 n status
 s status="Running"
 l +^%zewd("daemon","lock"):0 e  d  QUIT status
 . i $g(^%zewd("daemon","stop"))=1 s status="Flagged to Stop"
 l -^%zewd("daemon","lock")
 i $g(^%zewd("daemon","use"))'="true" QUIT "Not activated"
 QUIT "Stopped"
 ;
setPrintEvent(url,clientId)
 ;
 QUIT
 ;
printListener
 QUIT
 ;
closePrintListener
 QUIT
 ;
setClient(sessid)
 QUIT ""
