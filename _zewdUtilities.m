%zewdUtilities ; Enterprise Web Developer Utility Scripts
 ;
 ; Product: Enterprise Web Developer (Build 838)
 ; Build Date: Tue, 25 Jan 2011 16:34:10
 ;
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
 QUIT
 ;
 ;
getCalendarSettings(sessid) ;
 ;
 n returnRef,finish,dd,mm,yyyy,date
 ;
 s returnRef=$$getSessionValue^%zewdAPI("calendarJSReturn",sessid)
 s finish=$$getSessionValue^%zewdAPI("calendarFinish",sessid)
 i finish="" d
 . i returnRef="" d setSessionValue^%zewdAPI("calendarFinish","dummy=0",sessid)
 . i returnRef'="" d setSessionValue^%zewdAPI("calendarFinish","window.close()",sessid) ;
 i returnRef="" d setSessionValue^%zewdAPI("calendarJSReturn","document.dummyForm.dummy.value",sessid)
 ;
 s date=$$getSessionValue^%zewdAPI("calendarDate",sessid)
 s date=$zd(date,1)
 s mm=$p(date,"/",1)-1
 s dd=$p(date,"/",2)
 s yyyy=$p(date,"/",3)
 d setSessionValue^%zewdAPI("calendarDay",dd,sessid)
 d setSessionValue^%zewdAPI("calendarMonth",mm,sessid)
 d setSessionValue^%zewdAPI("calendarYear",yyyy,sessid)
 ;
 QUIT ""
 ;
setErrorClasses()
 ;
 n errorClass,errorFields,id,return
 ;
 s errorClass=$$getSessionValue^%zewdAPI("ewd_errorClass",sessid)
 d mergeArrayFromSession^%zewdAPI(.errorFields,"ewd_errorFields",sessid)
 s id=""
 s return=""
 f  s id=$o(errorFields(id)) q:id=""  d
 . s return=return_"document.getElementById('"_id_"').className='"_errorClass_"' ;"
 ;
 d deleteFromSession^%zewdAPI("ewd_errorFields",sessid)
 d deleteFromSession^%zewdAPI("ewd_hasErrors",sessid)
 ;
 QUIT return
 ;
findInDir(dir,string,filefound,ext)
 ;
 n filename,file,files,found
 k filefound
 i $g(string)="" QUIT 0
 i $g(ext)="" s ext="*"
 d getFilesInPath^%zewdHTMLParser(dir,ext,.files)
 s file=""
 f  s file=$o(files(file)) q:file=""  d
 . s filename=dir_"\"_file
 . w filename,!
 . s found=$$findInFile(filename,string,.found)
 . i found m filefound(file)=found
 QUIT
 ;
findInFile(filename,string,found)
 ;
 n line,lineNo
 ;
 i $g(string)="" QUIT 0
 k found
 s found=0
 s $zt="eof"
 i '$$openFile^%zewdAPI(filename) s error="Unable to open file "_filename QUIT -1
 ;o filename:"r":2 e  QUIT -1
 f lineNo=1:1 u filename r line q:$zeof  i line[string s found=1,found(lineNo)=line
eof ;
 c filename
 QUIT found
 ;
closeDownEWD
 ;
 n sessid
 ;
 s sessid=""
 f  s sessid=$o(^%zewdSession("session",sessid)) q:sessid=""  d
 . d deleteSession^%zewdPHP(sessid)
 i $$stop^%zewdDaemon()
 QUIT
 ;
closeDownWLD
 ;
 n sessid
 ;
 k ^%WLDTRACE
 k ^%WLDERR
 ;
 ; tell the shutdown daemon to stop if it's enabled and running
 ;
 i $g(^%WLDGASA("UseShutdownDemon"))="true" d
 . l +^%WLDGASA("ShutdownDemonLock"):0 i  d
 . . l -^%WLDGASA("ShutdownDemonLock")
 . e  d
 . . s ^%WLDGASA("StopShutdownDemon")=1
 ;
 ; tell the email daemon to stop if it's enabled and running
 ;
 i $g(^%WLDGASA("UseEMailDemon"))="true" d
 . l +^%WLDGASA("EMailDemonLock"):0 i  d
 . . l -^%WLDGASA("EMailDemonLock")
 . e  d
 . . s ^%WLDGASA("StopEMailDemon")=1
 ;
 ; now forceably expire all running sessions
 ;
 s sessid=""
 f  s sessid=$o(^%WLDGASA("Running",sessid)) q:sessid=""  d
 . s $p(^%WLDGASA("Running",sessid),"~",1)="0,0"
 ;
 ; remove flag for sessions that could not previously be stopped
 ;
 d FORCEALL^%wldfl
 ;
 ; now invoke the session clearup routine to clear out all sessions
 ;
 d ^%wldfl
 ;
 QUIT
 ;
