%zewdMgr2	; Enterprise Web Developer Manager Functions (Virtual Appliance)  
 ;
 ; Product: Enterprise Web Developer (Build 827)
 ; Build Date: Tue, 05 Oct 2010 12:28:52
 ;
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-10 M/Gateway Developments Ltd,                        |
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
gtmInitialise(sessid)	
	;
	d setSessionValue^%zewdAPI("ewd_isVirtualAppliance",1,sessid)
	i $g(^%zewd("disabled"))=1 d setRedirect^%zewdAPI("invalidvaaccess",sessid) QUIT ""
	i '$d(^%zewd("config","security","validSubnet")) d setRedirect^%zewdAPI("gtmSecurity",sessid) QUIT ""
	i '$$validSubnet^%zewdMgr(sessid) d setJump^%zewdAPI("invalidvaaccess",sessid) QUIT ""  ; default is only accessible from localhost
	i $$passwordProtected^%zewdMgr() d setSessionValue^%zewdAPI("initialPage","login",sessid) QUIT ""  ; default is not password protected
	;
	QUIT ""
	;
gtmAbout(sessid)	
	;
	d setSessionValue^%zewdAPI("ewdva_version",$$version^%zewdGTM(),sessid)
	d setSessionValue^%zewdAPI("ewdva_date",$$buildDate^%zewdGTM(),sessid)
	d setSessionValue^%zewdAPI("gtm_version",$zv,sessid)
	d setSessionValue^%zewdAPI("mgwsi_version","2.0.44",sessid)
	d setSessionValue^%zewdAPI("gtm_dateTime",$$inetDate^%zewdAPI($h),sessid)
	d setSessionValue^%zewdAPI("ewdVersion",$$version^%zewdAPI(),sessid)
	d setSessionValue^%zewdAPI("ewd_ip",$$getIP^%zewdGTM(),sessid)
	;
	QUIT ""
	;
setSecurity(sessid)	
	;
	n ip
	;
	s ip=$$getServerValue^%zewdAPI("REMOTE_ADDR",sessid)
	s ^%zewd("config","security","validSubnet",ip)=""
	;
	d setSessionValue^%zewdAPI("ipAddress",ip,sessid)
	;
	QUIT ""
	;
restartMGWSI(sessid)	
	j restart^%zewdMgr2
	QUIT ""
	;
restart	;
	h 2
	d restartMGWSI^%zewdGTM
	QUIT
	;
decodeTime(sec)	
	;
	n hh,mm
	s hh=sec\3600 i hh<10 s hh="0"_hh
	s sec=sec#3600
	s mm=sec\60 i mm<10 s mm="0"_mm
	s sec=sec#60 i sec<10 s sec="0"_sec
	QUIT hh_":"_mm_":"_sec
	;
shutdown(sessid)	
	d shutdown^%zewdGTM
	QUIT ""
	;
reboot(sessid)	
	d restart^%zewdGTM
	QUIT ""
	;
setClock(sessid)	
	d setClock^%zewdGTM
	QUIT ""
	;
currentTime()
	;
	n time	
	s time=$$inetDate^%zewdAPI($h)
	QUIT "document.getElementById('dateTime').value='"_time_"' ;"
	;	
controlPanel(sessid)	
	n time	
	s time=$$inetDate^%zewdAPI($h)
	d setSessionValue^%zewdAPI("dateTime",time,sessid)
	QUIT ""
	;
