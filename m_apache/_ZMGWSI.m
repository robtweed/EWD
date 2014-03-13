%ZMGWSI ; Service Integration - Core Server
 ;
 ; ----------------------------------------------------------------------------
 ; | m_apache                                                                 |
 ; | m_python                                                                 |
 ; | Copyright (c) 2004-2014 M/Gateway Developments Ltd,                      |
 ; | Surrey UK.                                                               |
 ; | All rights reserved.                                                     |
 ; |                                                                          |
 ; | http://www.mgateway.com                                                  |
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
A0 D VERS^%ZMGWSIS
 q
 ;
START(port) ; Start daemon
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":STARTE"
 k ^%MGWSI("STOP")
 j M($g(port))
 q
STARTE ; Error
 q
 ;
EeeStart ; Start
 d START(0)
 Q
 ;
STOP ; Stop
 ;s ^%MGWSI("STOP")=1
 w !,"Stopping MGWSI ... "
 d STOP1(0,1)
 ;f  q:'$d(^%MGWSI("STOP"))  h 3 w "."
 w !!,"MGWSI stopped",!
 Q
 ;
STOP1(port,context) ; Stop daemon
 ; context==0: stop child processes
 ; context==1: stop master and child processes
 s pport=+$g(port)
 i pport D STOP2(pport,context) q
 s pport="" f  s pport=$o(^%MGWSI("TCP_PORT",pport)) q:pport=""  D STOP2(pport,context)
 q
 ;
STOP2(pport,context) ; Stop series
 s cport="" f  s cport=$o(^%MGWSI("TCP_PORT",pport,cport)) q:cport=""  D
 . s pid=$g(^%MGWSI("TCP_PORT",pport,cport))
 . D STOP3(cport,pid)
 . k ^%MGWSI("TCP_PORT",pport,cport)
 . q
 i context=1 s pid=$g(^%MGWSI("TCP_PORT",pport)) D STOP3(pport,pid) k ^%MGWSI("TCP_PORT",pport)
 q
 ;
STOP3(port,pid) ; Stop this listener
 i '$l(pid) q
 w !,"stop: "_pid
 zsy "kill -TERM "_pid
 q
 ;
M(port)  ; Non-Concurrent TCP service (Old MUMPS systems)
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":MH"
 s $ZS="",dev=""
 s port=+$g(port)
 i 'port s port=7041
 ; Initialize list of 'used' TCP server ports
 k ^%MGWSI("TCP_PORT",port)
 s ^%MGWSI("TCP_PORT",port)=$j
 ;
MA ; Set TCP server device
 Set dev="server$"_$j,timeout=30 
 ;
 ; Open TCP server device
 Open dev:(ZLISTEN=port_":TCP":attach="server"):timeout:"SOCKET"
 ;
 ; Use TCP server device
 Use dev 
 Write /listen(1) 
 ;
M0 set %ZNSock="",%ZNFrom=""
 S OK=1 F  D  Q:OK  I $D(^%MGWSI("STOP")) S OK=0 k ^%MGWSI("STOP") Q
 . Write /wait(timeout)
 . I $KEY'="" S OK=1 Q
 . S OK=0
 . Q
 I 'OK G MX
 set %ZNSock=$piece($KEY,"|",2),%ZNFrom=$piece($KEY,"|",3)
 d EVENT^%ZMGWSIS("Incoming connection from "_%ZNFrom_", starting child server process ("_%ZNSock_")")
 ;
 ; d CHILD^%ZMGWSIS(port,port,1,"")
 ;
 s errors=0
 D VARS^%ZMGWSIS
M1 ; Read the next command from the MGWSI gateway
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":ME"
 s $ZS=""
 s req="" f i=1:1 r *x q:x=10!(x=0)  i i<300 s req=req_$c(x)
 ;D EVENT^%ZMGWSIS("command::"_(req[$c(10))_":"_req)
 i x=0 C dev G MA
 s errors=0
 s cmnd=$p(req,"^",2)
 ;
 ; Only interested in the request to start a new service job
 ; and the close-down command - discard everything else
 k res
 i cmnd="S" D DINT ; start a new service job
 i cmnd="X" G MX ; close-down this service
 ;
 ; Flush output buffer
 d END^%ZMGWSIS
 C dev G MA
 ;
ME ; Error - probably client disconnect (which is normal)
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":MX"
 s errors=errors+1 i errors<37 C dev G MA
 ; Too many errors
 d EVENT^%ZMGWSIS("Accept Loop - Too many errors - Closing Down ("_$ZS_")")
MX ; Exit
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":MH"
 d EVENT^%ZMGWSIS("Closing Server")
 ;
 ; Close TCP server device
 c dev
 h
 ;
MH ; Start-up error - Halt
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":MH1"
 d EVENT^%ZMGWSIS("Service start-up error: "_$ZS) Q
 ;
 ; Close TCP server device
 i $l($g(dev)) c dev
 h
MH1 ; Halt
 h
 ;
DINT ; Start-up and initialise a new service job
 N %uci,%touci,systype,cport,dev,i,txt,timeout,x
 S %touci=$p($p(req,"uci=",2),"&",1) ; UCI for service job
 s %uci=$$getuci^%ZMGWSIS() ; This UCI (should be manager)
 s systype=$$getsys^%ZMGWSIS() ; System type
 ;
 ; Get the next available TCP port for server child process
 f cport=port+1:1 i '$d(^%MGWSI("TCP_PORT",port,cport)),'$d(^%MGWSI("TCP_PORT_EXCLUDED",cport)) q
 ; Mark the port as in-use
 s ^%MGWSI("TCP_PORT",port,cport)=""
 ;
 ; Start server child process
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":DINTE"
 s ok=1,timeout=10
 j CHILD^%ZMGWSIS(port,cport,0,%touci)
 s ^%zewd("mgwsis",$zjob)=""
 i 'ok g DINTE
 ; Send confirmation of a successful child start-up to the MGWSI gateway
 s txt="pid="_$J_"&uci="_%UCI_"&server_type="_systype_"&version="_$p($$V^%ZMGWSIS(),".",1,3)_"&child_port="_cport
 k res s res="" s res(1)="00000cv"_$C(10),maxlen=$$getslen^%ZMGWSIS() d send^%ZMGWSIS(txt)
 q
DINTE ; Probably a NameSpace/UCI error
 s x="" f  s x=$o(^%MGWSI("TCP_PORT",x)) q:x=""  k ^%MGWSI("TCP_PORT",x,cport)
 d EVENT^%ZMGWSIS("Unable to start a child process: "_$ZS)
 s txt="Error# "_$ZS
 k res s res="" s res(1)="00000ce"_$C(10),maxlen=$$getslen^%ZMGWSIS() d send^%ZMGWSIS(txt)
 q
 ;
