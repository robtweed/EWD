%ZMGWSIS ; Service Integration - Child Process
 ;
 ; ----------------------------------------------------------------------------
 ; | m_apache                                                                 |
 ; | m_python                                                                 |
 ; | Copyright (c) 2004-2009 M/Gateway Developments Ltd,                      |
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
A0 D VERS Q
 ;f i=1:1:10000 s x=$$esize(.y,i,62),z=$$dsize(y,$l(y),62) w !,i,?10,y,?20,z
 q
 ;
 ; v2.0.6: 17 February 2009
 ; v2.0.7:  1 July     2009
 ; v2.0.8: 15 July     2009
 ; 
V() ; Version and date
 N V,R,D
 S V="2.0"
 S R=8
 S D="15 July 2009"
 Q V_"."_R_"."_D
 ;
VERS ; Version information
 N V
 S V=$$V()
 W !,"M/Gateway Developments Ltd - Service Integration Gateway"
 W !,"Version: "_$P(V,".",1,2)_"; Revision "_$P(V,".",3)_" ("_$P(V,".",4)_")"
 W !
 Q
 ;
VARS ; Public  system variables
 ;
 ; The following variables can be modified in accordance with the documentation
 s extra=$c(1) ; Key marker for oversize data strings
 s abyref=0 ; Set to 1 to treat all arrays as if they were passed by reference
 s mqinfo=0 ; Set to 1 to place all MQ error/information messages in %mgwmq("info")
 ;            Otherwise, error messages will be placed in %mgwmq("error")
 ;            and 'information only' messages in %mgwmq("info")
 ;
 ; The following variables must not be modified
 i '($d(global)#10) s global=0
 i '($d(oversize)#10) s oversize=0
 i '($d(offset)#10) s offset=0
 i '($d(version)#10) s version=+$$V()
 ; #define MGW_TX_DATA     0
 ; #define MGW_TX_AKEY     1
 ; #define MGW_TX_AREC     2
 ; #define MGW_TX_EOD      3
 s ddata=0,dakey=1,darec=2,deod=3
 q
 ;
esize(esize,size,base)
 n i,x
 i base'=10 g esize1
 s esize=size
 q $l(esize)
esize1 ; Up to base 62
 s esize=$$ebase62(size#base)
 f i=1:1 s x=(size\(base**i)) q:'x  s esize=$$ebase62(x#base)_esize
 q $l(esize)
 ;
dsize(esize,len,base)
 n i,x
 i base'=10 g dsize1
 s size=+$e(esize,1,len)
 q size
dsize1 ; Up to base 62
 s size=0
 f i=len:-1:1 s x=$e(esize,i) s size=size+($$dbase62(x)*(base**(len-i)))
 q size
 ;
ebase62(n10) ; Encode to single digit (up to) base-62 number
 i n10'<0,n10<10 q $c(48+n10)
 i n10'<10,n10<36 q $c(65+(n10-10))
 i n10'<36,n10<62 q $c(97+(n10-36))
 q ""
 ;
dbase62(nxx) ; Decode single digit (up to) base-62 number
 n x
 s x=$a(nxx)
 i x'<48,x<58 q (x-48)
 i x'<65,x<91 q ((x-65)+10)
 i x'<97,x<123 q ((x-97)+36)
 q ""
 ;
ehead(head,size,byref,type)
 n slen,hlen
 s slen=$$esize(.esize,size,10)
 s code=slen+(type*8)+(byref*64)
 s head=$c(code)_esize
 s hlen=slen+1
 q hlen
 ;
dhead(head,size,byref,type)
 n slen,hlen,code
 s code=$a(head,1)
 s byref=code\64
 s type=(code#64)\8
 s slen=code#8
 s hlen=slen+1
 s size=0 i $l(head)'<hlen s size=$$dsize($e(head,2,slen+1),slen,10)
 q hlen
 ;
rdxx(len) ; Read 'len' Bytes from MGWSI
 n x,nmax,n,ncnt
 i 'len q ""
 s x="",nmax=len,n=0,ncnt=0 f  r y#nmax d  q:'nmax  i ncnt>100 q
 . i y="" s ncnt=ncnt+1 q
 . s ncnt=0,x=x_y,n=n+$l(y),nmax=len-n
 . q
 i ncnt s x="" d HALT ; Client disconnect
 q x
 ;
rdx(len,clen,rlen) ; Read from MGWSI - Initialize: (rdxsize,rdxptr,rdxrlen)=0,rdxbuf="",maxlen=$$getslen()
 n result,get,avail
 ;
 i $d(%ZCS("IFC")) s result=$e(REQUEST,%ZCS("IFC"),%ZCS("IFC")+(len-1)),%ZCS("IFC")=%ZCS("IFC")+len,rlen=rlen+len q result
 ;
 ;s result="" f get=1:1:len r *x s result=result_$c(x)
 ;s rlen=rlen+len q result
 ;
 s get=len,result=""
 i 'len q result
 f  d  i 'get q
 . s avail=rdxsize-rdxptr
 . ;d EVENT("i="_i_";len="_len_";avail="_avail_";get="_get_"=("_rdxbuf_") "_CLEN_" "_RLEN)
 . i get'>avail s result=result_$e(rdxbuf,rdxptr+1,rdxptr+get),rdxptr=rdxptr+get,get=0 q
 . s result=rdxbuf,rdxptr=0,get=get-avail
 . s avail=clen-rdxrlen i 'avail q
 . i avail>maxlen s avail=maxlen 
 . s rdxbuf=$$rdxx(avail),rdxsize=avail,rdxptr=0,rdxrlen=rdxrlen+avail
 . ;d EVENT("rdxbuf="_i_"="_rdxbuf)
 . q
 s rlen=rlen+len
 q result
 ;
INETD ; Entry point from [x]inetd
XINETD ; Someone is sure to use this label
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":INETDE"
 D CHILD(0,0,1,"")
 Q
INETDE ; Error
 W $ZE
 Q
 ;
IFC(CTX,REQUEST,null1,null2,null3,null4,null5) ; Entry point from fixed binding
 ;N (CTX,REQUEST)
 N %ZCS,CLEN,HLEN,RESULT,RLEN,abyref,anybyref,argc,array,buf,byref,cmnd,dakey,darec,ddata,deod,eod,esize,extra,fun,global,hlen,maxlen,mqinfo,nato,offset,ok,oversize,pcmnd,rdxbuf,rdxptr,rdxrlen,rdxsize,ref,refn,mreq1,req,req1,req2,req3,res,size,sl,slen,sn,sysp,type,uci,var,version,x
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":IFCE"
 D VARS
 S %ZCS("IFC")=1
 S argc=1,array=0,nato=0
 K ^%MGW("MPC",$J),^MGWSI($J)
 s maxlen=$$getslen()
 s (rdxsize,rdxptr,rdxrlen)=0,rdxbuf=""
 s sn=0,sl=0,ok=1,type=0,offset=0,var="req"_argc,req(argc)=var,(cmnd,pcmnd,buf)=""
 s buf=$p(REQUEST,$c(10),1),%ZCS("IFC")=%ZCS("IFC")+$l(buf)+1
 s type=0,byref=0 d REQ1 s @var=buf
 s cmnd=$p(buf,"^",2)
 S HLEN=$L(buf),CLEN=0
 I cmnd="P" S CLEN=$$dsize($E(buf,HLEN-(5-1),HLEN),5,62)
 s %ZCS("client")=$E(buf,4)
 ;d EVENT("request cmnd="_cmnd_"; size="_CLEN_" ("_$E(buf,HLEN-(5-1),HLEN)_"); client="_%ZCS("client")_" ;header = "_buf)
 s RLEN=0
 I CLEN D REQ
 s req=$g(@req(1)) i req="" Q ""
 s cmnd=$p(req,"^",2)
 k res s res="" s res(1)="00000cv"_$C(10)
 i cmnd="A" D AYT
 i cmnd="S" D DINT
 i cmnd="P" D MPHP
 i cmnd="H" D INFO
 i cmnd="X" D HALT
 D END s RESULT=$g(res)
 k res s res=""
 Q RESULT
IFCE ; Error
 Q "00000ce"_$C(10)_"M Server Error : ["_$g(req(2))_"]"_$tr($ze,"<>%","[]^")
 ;
IFCT ; IFC Test
 K
 S REQ=$$IFCT1()
 S RES=$$IFC(0,REQ,"","","","","")
 Q
 ;
IFCT1() ; Test data
 n
 d VARS
 s server="localhost",uci="",vers="1.1.1",smeth=0,cmnd="G"
 s req="PHPp^P^"_server_"#"_uci_"#0###"_vers_"#"_smeth_"^"_cmnd_"^00000"_$c(10)
 s hlen=$l(req)
 ;
 s data="^cm",size=$l(data),byref=0,type=ddata
 s x=$$ehead(.head,size,byref,type)
 s req=req_head_data
 ;
 s data="1",size=$l(data),byref=0,type=ddata
 s x=$$ehead(.head,size,byref,type)
 s req=req_head_data
 ;
 s x=$$esize(.esize,$l(req)-hlen,62)
 s esize=$e("00000",1,(5-x))_esize
 s req=$p(req,"00000",1)_esize_$p(req,"00000",2,9999)
 k (req)
 q req
 ;
CHILD(pport,port,conc,uci) ; Child
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":CHILDE"
 i uci'="" D UCI(uci)
 i 'conc d
 . s ^%MGWSI("TCP_PORT",pport,port)=$j
 . Set dev="server$"_$j,timeout=30
 . ; Open TCP server device
 . Open dev:(ZLISTEN=port_":TCP":attach="server"):timeout:"SOCKET"
 . Use dev
 . Write /listen(1)
 . set %ZNSock="",%ZNFrom=""
 . S OK=1 F  D  Q:OK  I $D(^%MGWSI("STOP")) S OK=0 Q
 . . Write /wait(timeout)
 . . I $KEY'="" S OK=1 Q
 . . d EVENT^%ZMGWSIS("Write /wait(timeout) expires")
 . . S OK=0
 . . Q
 . I 'OK C dev H
 . set %ZNSock=$piece($KEY,"|",2),%ZNFrom=$piece($KEY,"|",3)
 . ;d EVENT^%ZMGWSIS("Incoming child connection from "_%ZNFrom_" ("_%ZNSock_")")
 . q
 ;
 s nato=0
CHILD2 ; Child request loop
 d VARS
 k ^%MGW("MPC",$J),^MGWSI($J)
 f i=1:1:37 k @("req"_i)
 k req s argc=1,array=0
 i '($d(nato)#10) s nato=0
CHILD3 ; Read Request
 ; d EVENT("******* GET NEXT REQUEST *******")
 s maxlen=$$getslen()
 s (rdxsize,rdxptr,rdxrlen)=0,rdxbuf=""
 s sn=0,sl=0,ok=1,type=0,offset=0,var="req"_argc,req(argc)=var,(cmnd,pcmnd,buf)=""
 i 'nato r *x
 i nato r *x:nato i '$T D HALT ; No-activity timeout
 i x=0 D HALT ; Client disconnect
 s buf=$c(x) f  r *x q:x=10!(x=0)  s buf=buf_$c(x)
 i x=0 D HALT ; Client disconnect
 s type=0,byref=0 d REQ1 s @var=buf
 s cmnd=$p(buf,"^",2)
 S HLEN=$L(buf),CLEN=0
 I cmnd="P" S CLEN=$$dsize($E(buf,HLEN-(5-1),HLEN),5,62)
 s %ZCS("client")=$E(buf,4)
 ; d EVENT("request size="_CLEN_" ("_$E(buf,HLEN-(5-1),HLEN)_"); client="_%ZCS("client")_" ;header = "_buf)
 s RLEN=0
 I CLEN D REQ
 ;
 ;f i=1:1:argc d EVENT("arg "_i_" = "_$g(@req(i)))
 ; 
 s req=$g(@req(1)) i req="" G CHILD2
 s cmnd=$p(req,"^",2)
 k res s res="" s res(1)="00000cv"_$C(10)
 i cmnd="A" D AYT
 i cmnd="S" D DINT
 i cmnd="P" D MPHP
 i cmnd="H" D INFO
 i cmnd="X" D HALT
 D END
 k res s res=""
 G CHILD2
 ;
CHILDE ; Error
 d EVENT($ZS)
 i $ZS["READ" g HALT
 G CHILD2
 ;
HALT ; Halt
 i 'conc d
 . ; Close TCP server device
 . i $l($g(dev)) c dev
 . s x="" f  s x=$o(^%MGWSI("TCP_PORT",x)) q:x=""  k ^%MGWSI("TCP_PORT",x,port)
 . q
 h
 ;
REQ ; Read request data
 n dev,get,got
REQ0 ; Get next argument
 s x=$$rdx(1,CLEN,.RLEN),hlen=$$dhead(x,.size,.byref,.type)
 ;d EVENT("(1) CLEN="_CLEN_";RLEN="_RLEN_";hlen="_hlen_";argc="_argc_";size="_size_";byref="_byref_";type="_type)
 s slen=hlen-1
 s esize=$$rdx(slen,CLEN,.RLEN)
 s size=$$dsize(esize,slen,10)
 ;d EVENT("(2) CLEN="_CLEN_";RLEN="_RLEN_";hlen="_hlen_";slen="_slen_";argc="_argc_";size="_size_";byref="_byref_";type="_type)
 s argc=argc+1
 d REQ1
 i type=darec d ARRAY G REQZ
 s got=0 f sn=0:1 s get=size-got s:get>maxlen get=maxlen s buf=$$rdx(get,CLEN,.RLEN) d  i got=size q
 . s got=got+get
 . ;d EVENT("(3) Data: CLEN="_CLEN_";RLEN="_RLEN_";size="_size_";get="_get_";sn="_sn_";pcmnd="_pcmnd_";buf="_buf)
 . i argc=3,pcmnd="h" s @var=buf d MPC q
 . i 'sn s @var=buf q
 . i sn s @(var_"(extra,sn)")=buf q
 . q
REQZ ; Argument read
 i RLEN<CLEN G REQ0
 s eod=1
 q
 ;
REQ1 ; Initialize next argument
 i argc=1 d
 . s cmnd=$p(buf,"^",2)
 . s sysp=$p(buf,"^",3)
 . s uci=$p(sysp,"#",2) i uci'="" d
 . . s ucic=$$getuci()
 . . i ucic'="",uci=ucic q
 . . ; D UCI(uci) D EVENT("Correct NameSpace from '"_ucic_"' to '"_uci_"'")
 . . q
 . s offset=$p(sysp,"#",3)+0
 . s global=$p(sysp,"#",7)+0
 . s pcmnd=$p(buf,"^",4)
 . q
 s sn=0,sl=0
 s var="req"_argc
 s req(argc)=var
 s req(argc,0)=type i type=darec s req(argc,0)=1
 s req(argc,1)=byref
 i type=1,abyref=1 s req(argc,1)=1
 q
 ;
MPC ; Raw content for HTTP POST: save section of data
 s sn=sn+1,^%MGW("MPC",$J,"CONTENT",sn)=buf,buf="",sl=0
 q
 ;
ARRAY ; Read array
 n x,kn,val,sn,ext,get,got
 ;d EVENT("*** array ***")
 k x,ext s kn=0
ARRAY0 ; Read next element (key or data)
 s sn=0,sl=0
 s x=$$rdx(1,CLEN,.RLEN),hlen=$$dhead(x,.size,.byref,.type)
 ;d EVENT("(1) Array CLEN="_CLEN_";RLEN="_RLEN_";hlen="_hlen_";argc="_argc_";size="_size_";byref="_byref_";type="_type)
 s slen=hlen-1
 s esize=$$rdx(slen,CLEN,.RLEN)
 s size=$$dsize(esize,slen,10)
 ;d EVENT("(2) Array CLEN="_CLEN_";RLEN="_RLEN_";hlen="_hlen_";slen="_slen_";argc="_argc_";size="_size_";byref="_byref_";type="_type)
 i type=deod q
 s got=0 f sn=0:1 s get=size-got s:get>maxlen get=maxlen s buf=$$rdx(get,CLEN,.RLEN) d  i got=size q
 . s got=got+get
 . ;d EVENT("(3) Array Data CLEN="_CLEN_";RLEN="_RLEN_";size="_size_";get="_get_";sn="_sn_";pcmnd="_pcmnd_";buf="_buf)
 . i argc=3,pcmnd="h" s @var=buf d MPC q
 . i type=dakey s kn=kn+1,x(kn)=buf 
 . i type=ddata s val=buf D ARRAY1 k x,ext s kn=0
 . q
 g ARRAY0
 ;
ARRAY1 ; Read array - Set a single node
 n n,i,ref,com,key
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":ARRAY1E"
 s (key,com)="" f i=1:1:kn q:i=kn&($g(x(i))=" ")  s key=key_com_"x("_i_")",com=","
 i global d
 . i $l(key) s ref="^MGWSI($j,argc-2,"_key_")",eref="^MGWSI($j,argc-2,"_key_",extra,sn)"
 . i '$l(key) s ref="^MGWSI($j,argc-2)",eref="^MGWSI($j,argc-2,extra,sn)"
 . q
 i 'global d
 . i $l(key) s ref=req(argc)_"("_key_")",eref=req(argc)_"("_key_",extra,sn)"
 . i '$l(key) s ref=req(argc),eref=req(argc)_"(extra,sn)"
 . q
 i $l(ref) x "s "_ref_"=val"
 f sn=1:1 q:'$d(ext(sn))  x "s "_eref_"=ext(sn)"
 Q
ARRAY1E ;
 d EVENT("Array: "_$ZS)
 Q
 ;
END ; Terminate Response
 n len,len62,i,head,x
 i '$d(%ZCS("IFC")),$e($g(res(1)),6,7)="sc" w $p(res(1),"0",1) D FLUSH q  ; Streamed response
 s len=0
 f i=1:1 q:'$d(res(i))  s len=len+$l(res(i))
 s len=len-8
 s head=$e($g(res(1)),1,8)
 s x=$$esize(.len62,len,62)
 f  q:$l(len62)'<5  s len62="0"_len62
 s head=len62_$e(head,6,8) i $l(head)'=8 s head=len62_"cv"_$c(10)
 s res(1)=head_$e($g(res(1)),9,99999)
 ; Flush the lot out
 i $d(%ZCS("IFC")) g END1
 f i=1:1 q:'$d(res(i))  w res(i)
 D FLUSH
 Q
END1 ; Interface
 s res="" f i=1:1 q:'$d(res(i))  s res=res_res(i)
 Q
 ;
FLUSH ; Flush output buffer
 ;w *-3
 ;w *1
 q
 ;
AYT ; Are you there?
 S req=$g(@req(1))
 s txt=$p($h,",",2)
 f  q:$l(txt)'<5  s txt="0"_txt
 s txt="m"_txt
 f  q:$l(txt)'<12  s txt=txt_"0"
 d send(txt)
 q
 ;
DINT ; Initialise the service link
 N port,dev,conc,%uci
 S req=$p($g(@req(1)),"^S^",2,9999)
 ;"^S^version=%s&timeout=%d&nls=%s&uci=%s"
 S version=$p($p(req,"version=",2),"&",1)
 S nato=+$p($p(req,"timeout=",2),"&",1)
 S %ZCS("NLS_TRANS")=$p($p(req,"nls=",2),"&",1)
 S %UCI=$p($p(req,"uci=",2),"&",1)
 I $L(%UCI) D UCI(%UCI)
 S x=$$setio(%ZCS("NLS_TRANS"))
 S %UCI=$$getuci()
 s systype=$$getsys()
 s txt="pid="_$J_"&uci="_%UCI_"&server_type="_systype_"&version="_$p($$V(),".",1,3)_"&child_port=0"
 d send(txt)
 q
 ;
UCI(UCI) ; Change NameSpace/UCI
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":UCIE"
 i UCI="" Q
 s $ZG=UCI
 Q
UCIE ; Error
 d EVENT("UCI Error: "_UCI_" : "_$ZS)
 q
 ;
INFO ; Connection Info
 n port,dev,conc,nato
 d send("HTTP/1.1 200 OK"_$Char(13,10)_"Connection: close"_$Char(13,10)_"Content-type: text/html"_$Char(13,10,13,10))
 d send("<html><head><title>MGWSI - Connection Test</title></head><body bgcolor=#ffffcc>")
 d send("<h2>MGWSI - Connection Test Successful</h2>")
 d send("<table border=1>")
 d send("<tr><td>"_$$getsys()_" Version:</td><td><b>"_$ZV_"<b><tr>")
 d send("<tr><td>UCI:</td><td><b>"_$$getuci()_"<b><tr>")
 d send("</table>")
 d send("</body></html>")
 q
 ;
EVENT(TEXT) ; Log M-Side Event
 N port,dev,conc,N,EMAX
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":EVENTE"
 F I=1:1 S X=$E(TEXT,I) Q:X=""  S Y=$S(X=$C(13):"\r",X=$C(10):"\n",1:"") I Y'="" S $E(TEXT,I)=Y
 S EMAX=100 ; Maximum log size (No. messages)
 L +^%MGWSI("LOG")
 S N=$G(^%MGWSI("LOG")) I N="" S N=0
 S N=N+1,^%MGWSI("LOG")=N
 L -^%MGWSI("LOG")
 S ^%MGWSI("LOG",N,0)=$$HEAD(),^%MGWSI("LOG",N,1)=$E(TEXT,1,230)
 F N=N-EMAX:-1 Q:'$D(^%MGWSI("LOG",N))  K ^(N)
 Q
EVENTE ; Error
 Q
 ;
DDATE(DATE) ; Decode M date
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":DATEE"
 Q $ZD(DATE,2)
DDATEE ; No $ZD Function
 Q DATE
 ;
DTIME(TIME) ; Decode M Time
 Q (TIME\3600)_":"_(TIME#3600\60)
 ;
HEAD() ; Format Header record
 N %UCI
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":HEADE"
 s %UCI=$$getuci()
HEADE ; Error
 Q $$DDATE(+$H)_" at "_$$DTIME($P($H,",",2))_"~"_$G(%ZCS("PORT"))_"~"_%UCI
 ;
HMACSHA256(string,key,b64,context) ; HMAC-SHA256
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"HMAC-SHA256",string,key,b64,context)
 ;
HMACSHA1(string,key,b64,context) ; HMAC-SHA1
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"HMAC-SHA1",string,key,b64,context)
 ;
HMACSHA(string,key,b64,context) ; HMAC-SHA
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"HMAC-SHA",string,key,b64,context)
 ;
HMACMD5(string,key,b64,context) ; HMAC-MD5
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"HMAC-MD5",string,key,b64,context)
 ;
SHA256(string,b64,context) ; SHA256
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"SHA256",string,"",b64,context)
 ;
SHA1(string,b64,context) ; SHA1
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"SHA1",string,"",b64,context)
 ;
SHA(string,b64,context) ; SHA
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"SHA",string,"",b64,context)
 ;
MD5(string,b64,context) ; MD5
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"MD5",string,"",b64,context)
 ;
B64(string,context) ; BASE64
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"B64",string,"",0,context)
 ;
DB64(string,context) ; DECODE BASE64
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"D-B64",string,"",0,context)
 ;
TIME(context) ; TIME
 Q $$CRYPT("127.0.0.1",$s(context:80,1:7040),"TIME","","",0,context)
 ;
ZTS(context) ; ZTS
 S TIME=$$TIME(context)
 S ZTS=$P($H,",",1)_","_(($P(TIME,":",1)*60*60)+($P(TIME,":",2)*60)+$P(TIME,":",3))
 Q ZTS
 ;
CRYPT(IP,PORT,METHOD,string,key,b64,context)
 n %mgwmq,response,method
 s method=METHOD i b64 s method=method_"-B64"
 s %mgwmq("send")=string
 s %mgwmq("key")=key
 i context=0 s response=$$WSMQ(IP,PORT,method,.%mgwmq)
 i context=1 s response=$$WSX(IP,PORT,method,.%mgwmq)
 Q $G(%mgwmq("recv"))
 ;
WSMQ(IP,PORT,REQUEST,%mgwmq) ; Message for WebSphere MQ (Parameters passed by reference)
 Q $$WSMQ1(IP,PORT,REQUEST)
 ;
WSMQ1(IP,PORT,REQUEST)	; Message for WebSphere MQ (Parameters passed by global array - %mgwmq())
 N (IP,PORT,REQUEST,%mgwmq)
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":WSMQE"
 ;
 ; Close connection to Gateway
 i REQUEST="CLOSE" d  S result=1 G WSMQ1X
 . i $d(%mgwmq("keepalive","dev")) s DEV=%mgwmq("keepalive","dev") k %mgwmq("keepalive") C DEV
 . q
 ;
 D VARS
 S CRLF=$C(13,10)
 S REQUEST=$$ucase(REQUEST)
 I REQUEST="GET" k %mgwsi("send")
 S res=""
 S %mgwmq("error")=""
 s global=+$g(%mgwmq("global"))
 ;
 ; Create TCP connection to Gateway
 s OK=1
 i $d(%mgwmq("keepalive","dev")) s DEV=%mgwmq("keepalive","dev")
 i '$d(%mgwmq("keepalive","dev")) d
 . S DEV="client$"_$j,timeout=10
 . O DEV:(connect=IP_":"_PORT_":TCP":attach="client"):timeout:"SOCKET" E  S %mgwmq("error")="Cannot connect to MGWSI" s OK=0
 . q
 i 'OK S result=0 G WSMQ1X
 ;
 S maxlen=$$getslen()
 S BUFFER="",BSIZE=0,EOF=0
 S DEV(0)=$IO
 U DEV
 S REQ="WSMQ "_REQUEST_" v1.1"_CRLF D WSMQS
 S X="" F  S X=$O(%mgwmq(X)) Q:X=""  I X'="recv",X'="send" S Y=$G(%mgwmq(X)) I Y'="" S REQ=X_": "_Y_CRLF D WSMQS
 S REQ=CRLF D WSMQS
 i global d
 . S REQ=$G(^MGWSI($j,1,"send")) I REQ'="" D WSMQS
 . S X="" F  S X=$O(^MGWSI($j,1,"send",extra,X)) Q:X=""  S REQ=$G(^MGWSI($j,1,"send",extra,X)) I REQ'="" D WSMQS
 . S X="" F  S X=$O(^MGWSI($j,1,"send",X)) Q:X=""  I X'=extra S REQ=$G(^MGWSI($j,1,"send",X)) I REQ'="" D WSMQS
 . q
 i 'global d
 . S REQ=$G(%mgwmq("send")) I REQ'="" D WSMQS
 . S X="" F  S X=$O(%mgwmq("send",extra,X)) Q:X=""  S REQ=$G(%mgwmq("send",extra,X)) I REQ'="" D WSMQS
 . S X="" F  S X=$O(%mgwmq("send",X)) Q:X=""  I X'=extra S REQ=$G(%mgwmq("send",X)) I REQ'="" D WSMQS
 . q
 ;S REQ=$C(deod),EOF=1 D WSMQS
 S REQ=$C(7),EOF=1 D WSMQS
 U DEV
 s size=+$$rdxx(10)
 S res="",len=0,sn=0,got=0,pre="",plen=0,hdr=1 F  d  q:got=size
 . s get=size-got i get>maxlen s get=maxlen
 . s x=$$rdxx(get) s got=got+get
 . i got=size,$e(x,get)=$c(deod) s x=$e(x,1,get-1)
 . i hdr d  q
 . . s lx=$l(x,$c(13)) f i=1:1:lx d  q:'hdr
 . . . s r=$p(x,$c(13),i)
 . . . i i=lx s pre=r,plen=$l(pre) q
 . . . i plen s r=pre_r,pre="",plen=0
 . . . i r=$c(10) s hdr=0 s pre=$p(x,$c(13),i+1,99999) s:$e(pre)=$c(10) pre=$e(pre,2,99999) s plen=$l(pre) q
 . . . s nam=$p(r,": ",1),val=$p(r,": ",2,99999)
 . . . i $e(nam)=$c(10) s nam=$e(nam,2,99999)
 . . . i nam'="" s %mgwmq(nam)=val
 . . . q
 . . q
 . s to=maxlen-plen
 . s res=pre_$e(x,1,to),pre=$e(x,to+1,99999),plen=$l(pre)
 . i global d
 . . i 'sn s ^MGWSI($j,1,"recv")=res,res="",sn=sn+1 q
 . . i sn s ^MGWSI($j,1,"recv",extra,sn)=res,res="",sn=sn+1 q
 . . q
 . i 'global d
 . . i 'sn s %mgwmq("recv")=res,res="",sn=sn+1 q
 . . i sn s %mgwmq("recv",extra,sn)=res,res="",sn=sn+1 q
 . . q
 . q
 s result=1
 i global d
 . i plen,'sn s ^MGWSI($j,1,"recv")=pre,plen=0,sn=sn+1
 . i plen,sn s ^MGWSI($j,1,"recv",extra,sn)=pre,plen=0,sn=sn+1
 . i $g(^MGWSI($j,1,"r_code"))=2033 s result=0
 . i $l($g(^MGWSI($j,1,"error"))) s result=0
 . i $g(^MGWSI($j,1,"recv"))[":MGWSI:ERROR:" s result=0
 . q
 i 'global d
 . i plen,'sn s %mgwmq("recv")=pre,plen=0,sn=sn+1
 . i plen,sn s %mgwmq("recv",extra,sn)=pre,plen=0,sn=sn+1
 . i $g(%mgwmq("r_code"))=2033 s result=0
 . i $l($g(%mgwmq("error"))) s result=0
 . i $g(%mgwmq("recv"))[":MGWSI:ERROR:" s result=0
 . q
 U DEV(0)
 i $g(%mgwmq("keepalive"))=1 S %mgwmq("keepalive","dev")=DEV
 i $g(%mgwmq("keepalive"))'=1 C DEV
WSMQ1X ; Exit point
 I $G(mqinfo) M %mgwmq("info")=%mgwmq("error") S %mgwmq("error")=""
 Q result
 ;
WSMQE ; Error (EOF)
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":"
 i $D(DEV(0)) U DEV(0)
 i '$D(DEV(0)) U 0
 i $g(%mgwmq("keepalive"))=1 S %mgwmq("keepalive","dev")=DEV
 i $g(%mgwmq("keepalive"))'=1 C DEV
 I $l($G(%mgwmq("error"))) G WSMQEX
 S %mgwmq("error")=$ZS G WSMQEX
WSMQEX ; Exit point
 I $G(mqinfo) M %mgwmq("info")=%mgwmq("error") S %mgwmq("error")=""
 Q 0
 ;
WSMQS ; Send outgoing header
 N N,X,LEN
WSMQS1 S LEN=$L(REQ)
 I (BSIZE+LEN)<maxlen S BUFFER=BUFFER_REQ,BSIZE=BSIZE+LEN,REQ="",LEN=0 I 'EOF Q
 W BUFFER D FLUSH
 ; S N=1 F  S X=$E(BUFFER,N,N+255) Q:X=""  W X S N=N+255+1 D FLUSH
 S BUFFER=REQ,BSIZE=LEN
 I EOF S REQ="" I BSIZE G WSMQS1
 Q
 ;
WSMQSRV(%mgwmq) ; Server to WebSphere MQ
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":WSMQSRVE^%ZMGWSIS"
 i global d
 . n x
 . s x="" f  s x=$o(^MGWSI($j,1,x)) q:x=""  i x'="recv" s %mgwmq(x)=$g(^MGWSI($j,1,x))
 . q
 D @$g(%mgwmq("routine"))
 k %mgwmq("qm_name")
 k %mgwmq("q_name")
 k %mgwmq("recv")
 i global d
 . k ^MGWSI($j,1,"qm_name")
 . k ^MGWSI($j,1,"q_name")
 . k ^MGWSI($j,1,"recv")
 . m ^MGWSI($j,1)=%mgwmq
 . q
 Q 1
WSMQSRVE ; Error
 k %mgwmq("qm_name")
 k %mgwmq("q_name")
 k %mgwmq("recv")
 S %mgwmq("send")="ERROR: "_$ZS
 S %mgwmq("error")="ERROR: "_$ZS
 Q 0
 ;
WSX(IP,PORT,REQUEST,%mgwmq) ; Message for Web Server (Parameters passed by reference)
 Q $$WSX1(IP,PORT,REQUEST)
 ;
WSX1(IP,PORT,REQUEST) ; Message for Web Server (Parameters passed by global array - %mgwmq())
 N (IP,PORT,REQUEST,%mgwmq)
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":WSXE"
 D VARS
 S CRLF=$C(13,10)
 ;
 ; Create TCP connection to server
 s OK=1
 S DEV="client$"_$j,timeout=10
 O DEV:(connect=IP_":"_PORT_":TCP":attach="client"):timeout:"SOCKET" E  S %mgwmq("error")="Cannot connect to Web Server" s OK=0
 i 'OK S result=0 G WSXEX
 ;
 S maxlen=$$getslen()
 S DEV(0)=$IO
 U DEV
 S REQ=""
 S REQ=REQ_"POST /mgwsi/sys/system_functions.mgwsi?FUN="_REQUEST_"&KEY="_$$WSXESC($g(%mgwmq("key")))_" HTTP/1.1"_CRLF
 S REQ=REQ_"Host: "_IP_$s(PORT'=80:":"_PORT,1:"")_CRLF
 S REQ=REQ_"Content-Type: text/plain"_CRLF
 S REQ=REQ_"User-Agent: zmgwsi v"_$g(version)_CRLF
 S REQ=REQ_"Content-Length: "_$L($G(%mgwmq("send")))_CRLF
 S REQ=REQ_"Connection: close"_CRLF
 S REQ=REQ_CRLF
 S REQ=REQ_$G(%mgwmq("send"))
 ;
 W REQ D FLUSH
 ;
 s res=$$rdxx(60) f  q:res[$c(13,10,13,10)  s res=res_$$rdxx(1)
 s head=$p(res,$c(13,10,13,10),1),res=$p(res,$c(13,10,13,10),2,9999)
 s headn=$$lcase(head)
 s clen=+$p(headn,"content-length: ",2)
 s rlen=clen-$l(res)
 s res=res_$$rdxx(rlen)
WSXE ; Error (EOF)
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":"
 i $D(DEV(0)) U DEV(0)
 i '$D(DEV(0)) U 0
 C DEV
WSXEX ; Exit point
 s %mgwmq("recv")=$g(res)
 Q 0
 ;
WSXESC(IN)
 N OUT,I,A,C,LEN,N16
 S OUT="",N16=0 F I=1:1:$L(IN) D
 . S C=$E(IN,I),A=$A(C)
 . I A=32 S C="+" S OUT=OUT_C Q
 . I A<32!(A>127)!(C?1P) S LEN=$$esize(.N16,A,16) S:LEN=1 N16="0"_N16 S C="%"_N16 S OUT=OUT_C Q
 . S OUT=OUT_C Q
 . Q
 Q OUT
 ;
MPHP ; Request from m_client
 n port,dev,conc,cmnd,nato
 s cmnd=$p(req,"^",4)
 d PHP
 q
 ;
PHP ; Serve request from m_client
 n argz,i,m
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":phpe^%ZMGWSIS"
 s res=""
 i cmnd="S" d set
 i cmnd="G" d get
 i cmnd="K" d kill
 i cmnd="D" d data
 i cmnd="O" d order
 i cmnd="P" d previous
 i cmnd="M" d mergedb
 i cmnd="m" d mergephp
 i cmnd="H" d html
 i cmnd="y" d htmlm
 i cmnd="h" d http
 i cmnd="X" d proc
 i cmnd="x" d meth
 i cmnd="W" d web
 q
phpe ; Error
 d EVENT($$client()_" Error : "_$ZS)
 k res s res="",res(2)="M Server Error : ["_$g(req(2))_"]"_$tr($ZS,"<>%","[]^")_$g(ref)
 s res(1)="00000ce"_$C(10)
 q
 ;
client() ; Get client name
 s name="m_client"
 i $g(%ZCS("client"))="z" s name="m_php"
 i $g(%ZCS("client"))="j" s name="m_jsp"
 i $g(%ZCS("client"))="a" s name="m_aspx"
 i $g(%ZCS("client"))="p" s name="m_python"
 i $g(%ZCS("client"))="r" s name="m_ruby"
 i $g(%ZCS("client"))="h" s name="m_apache"
 i $g(%ZCS("client"))="c" s name="m_cgi"
 i $g(%ZCS("client"))="w" s name="m_websphere_mq"
 q name
 ;
set ; Global set
 i argc<3 q
 s argz=argc-1
 s fun=0 d ref
 x "s "_ref_"="_"req"_argc
 d res
 Q
 ;
get ; Global get
 i argc<2 q
 s argz=argc
 s fun=0 d ref
 x "s res=$g("_ref_")"
 d res
 Q
 ;
kill ; Global kill
 i argc<1 q
 s argz=argc
 s fun=0 d ref
 x "k "_ref
 d res
 Q
 ;
data ; Global get
 i argc<2 q
 s argz=argc
 s fun=0 d ref
 x "s res=$d("_ref_")"
 d res
 Q
 ;
order ; Global order
 i argc<3 q
 s argz=argc
 s fun=0 d ref
 x "s res=$o("_ref_")"
 d res
 Q
 ;
previous ; Global reverse order
 i argc<3 q
 s argz=argc
 s fun=0 d ref
 x "s res=$o("_ref_",-1)"
 d res
 Q
 ;
mergedb ; Global Merge from PHP
 i argc<3 q
 s a="" f argz=1:1 q:'$d(req(argz))  i $g(req(argz,0))=1 s a=req(argz) q
 i a="" q
 s argz=argz-1
 s fun=0 d ref
 i ref["()" s ref=$p(ref,"()",1)
 i $g(@req(argz+2))["ks" x "k "_ref
 x "m "_ref_"="_a
 d res
 Q
 ;
mergephp ; Global Merge to PHP
 i argc<3 q
 s a="" f argz=1:1 q:'$d(req(argz))  i $g(req(argz,0))=1 s a=req(argz) q
 i a="" q
 s argz=argz-1
 s fun=0 d ref
 i ref["()" s ref=$p(ref,"()",1)
 x "m "_a_"="_ref
 s argz=argz+1
 s abyref=1
 d res
 Q
 ;
html ; HTML
 i '$d(%ZCS("IFC")) s res(1)=$c(1,2,1,10)_"0sc"_$C(10) w res(1)
 i argc<2 q
 s argz=argc
 s fun=0 d ref
 x "n ("_refn_") d "_ref
 Q
 ;
htmlm ; HTML (COS) Method
 i '$d(%ZCS("IFC")) s res(1)=$c(1,2,1,10)_"0sc"_$C(10) w res(1)
 i argc<1 q
 s argz=argc
 s fun=0 d oref
 s ref=$tr($p(ref,",",1,2),".","")_","_$p(ref,",",3,999)
 i argc=1 x "n ("_refn_") s req(-1)=$zobjclassmethod()"
 i argc>1 x "n ("_refn_") s req(-1)=$zobjclassmethod("_ref_")"
 s res=$g(req(-1))
 Q
 ;
web ; Web request
 N REQ,x,y,i
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":webe^%ZMGWSIS"
 s res(1)=$c(1,2,1,10)_"0sc"_$C(10) w res(1)
 i argc'=4 g webe
 s argz=argc
 s fun=1 d ref
 s x="" f  s x=$o(req4(x)) q:x=""  s y="" f i=1:1 s y=$o(req4(x,y)) q:y=""  i y'=i m req4(x,i)=req4(x,y) k req4(x,y)
 x "n ("_refn_") d "_ref
 q
webe ; error
 S REQ=""
 S REQ=REQ_"HTTP/1.1 200 OK"_$C(13,10)
 S REQ=REQ_"Content-type: text/plain"_$C(13,10)
 S REQ=REQ_"Connection: close"_$C(13,10)
 S REQ=REQ_$C(13,10)
 S REQ=REQ_"Error calling web function "_$g(ref)_$g(refn)_$C(13,10)
 S REQ=REQ_$ZS
 S REQ=REQ_"Web functions contain two arguments"_$C(13,10)
 W REQ
 Q
 ;
WEB(CGI,DATA)
 N REQ,X,Y
 S REQ=""
 S REQ=REQ_"HTTP/1.1 200 OK"_$C(13,10)
 S REQ=REQ_"Content-type: text/plain"_$C(13,10)
 S REQ=REQ_"Connection: close"_$C(13,10)
 S REQ=REQ_$C(13,10)
 W REQ
 W $G(CGI)
 S X="" F  S X=$O(CGI(X)) Q:X=""  W X_"="_$G(CGI(X))_$C(13,10)
 W $C(13,10)
 S X="" F  S X=$O(DATA(X)) Q:X=""  S Y="" F  S Y=$O(DATA(X,Y)) Q:Y=""  W X_":"_Y_"="_$G(DATA(X,Y))_$C(13,10)
 Q
 ;
http ; HTTP
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":httpe"
 i '$d(%ZCS("IFC")) s res(1)=$c(1,2,1,10)_"0sc"_$C(10) w res(1)
 i argc<2 q
 s x=$$http1(.req2,@req(3))
httpx ; exit
 k ^%MGW("MPC",$J,"CONTENT")
 Q
httpe ; Error
 w "<html><head><title>m_php/jsp: Error</title></head><h2>eXtc is not installed on this computer<h2></html>"
 q
 ;
http1(%CGIEVAR,content)	; HTTP
 n (%CGIEVAR,content)
 s test=0
 i test d  q 0
 . w "<br><b>CGI</b>"
 . s x="" f  s x=$o(%CGIEVAR(x)) q:x=""  w "<br>"_x_"="_$g(%CGIEVAR(x))
 . w "<br><b>CONTENT</b>"
 . s x="" f  s x=$o(^%MGW("MPC",$J,"CONTENT",x)) q:x=""  w "<br>"_x_"="_$g(^%MGW("MPC",$J,"CONTENT",x))
 . q
 i $G(%CGIEVAR("key_eXtcServer"))="true" d  QUIT 1
 . ; break out to eXtc Server here
 . s namespace=$G(%CGIEVAR("key_namespace"))
 . s:namespace'="" namespace=$G(^%eXtc("system","phpSettings","namespace",namespace))
 . s:namespace="" namespace=$G(^%eXtc("system","phpSettings","defaultNamespace"))
 . s:namespace="" namespace="%CACHELIB"
 . d PHPServer^%eXMLServer
 QUIT 0
 ; 
proc ; M extrinsic function
 i argc<2 q
 s argz=argc
 s fun=1 d ref
 i argc=2 x "n ("_refn_") s req(-1)=$$"_ref_"()"
 i argc>2 x "n ("_refn_") s req(-1)=$$"_ref
 s res=$g(req(-1))
 d res
 Q
 ;
meth ; M (COS) method
 ;
 ; Synopsis:
 ; s err=$zobjclassmethod(className,methodName,param1,...,paramN)
 ;
 ; s className="eXtc.DOMAPI"
 ; s methodName="openDOM"
 ; s err=$zobjclassmethod(className,methodName)
 ;
 ; ; This is equivalent to ...
 ; s err=##class(eXtc.DOMAPI).openDOM()
 ; 
 ; s methodName="getDocumentNode"
 ; s documentName="eXtcDOM2"
 ; s err=$zobjclassmethod(className,methodName,documentName)
 ; ; This is equivalent to ...
 ; s err=##class(eXtc.DOMAPI).getDocumentNode("eXtcDOM2")
 ;
 i argc<1 q
 s argz=argc
 s fun=1 d oref
 s ref=$tr($p(ref,",",1,2),".","")_","_$p(ref,",",3,999)
 i argc=1 x "n ("_refn_") s req(-1)=$zobjclassmethod()"
 i argc>1 x "n ("_refn_") s req(-1)=$zobjclassmethod("_ref_")"
 s res=$g(req(-1))
 d res
 Q
 ;
sort(a)	; Sort an array
 q 1
 ;
ref ; Global reference
 n com,i,strt,a1
 s array=0,refn="res,req,extra,global,oversize"
 i argc<2 q
 s a1=$g(@req(2))
 s strt=2 i a1?1"^"."^" s strt=strt+1
 s ref=@req(strt) i argc=strt q
 s ref=ref_"("
 s com="" f i=strt+1:1:argz s refn=refn_","_req(i),ref=ref_com_$s(fun:".",1:"")_req(i),com=","
 s ref=ref_")"
 q
 ;
oref ; Object reference
 n com,i,strt,a1
 s array=0,refn="req,extra,global,oversize"
 i argc<2 q
 s a1=$g(@req(2))
 s strt=2 i a1?1"^"."^" s strt=strt+1
 i '$d(req(strt)) q
 s ref=""
 s com="" f i=strt:1:argz s refn=refn_","_req(i),ref=ref_com_$s(fun:".",1:"")_req(i),com=","
 q
 ;
res ; Return result
 n i,a,sn,argc
 s maxlen=$$getslen()
 d VARS
 s anybyref=0 f argc=1:1:argz q:'$d(req(argc))  i $g(req(argc,1)) s anybyref=1 q
 i 'anybyref d  q
 . d send($g(res))
 . i oversize f sn=1:1 q:'$d(^MGWSI($j,0,extra,sn))  d send($g(^(sn)))
 . q
 s res(1)="00000cc"_$C(10)
 s size=$l($g(res)),byref=0
 i oversize f sn=1:1 q:'$d(^MGWSI($j,0,extra,sn))  s size=size+$l(^(sn))
 s x=$$ehead(.head,size,byref,ddata)
 d send(head)
 d send($g(res))
 i oversize f sn=1:1 q:'$d(^MGWSI($j,0,extra,sn))  d send($g(^(sn)))
 f argc=1:1:argz q:'$d(req(argc))  d
 . s byref=$g(req(argc,1))
 . s array=$g(req(argc,0))
 . i 'byref s size=0,x=$$ehead(.head,size,byref,ddata) d send(head) q
 . i 'array d  q
 . . s size=$l($g(@req(argc)))
 . . f sn=1:1 q:'$d(@(req(argc)_"(extra,sn)"))  s size=size+$l($g(@(req(argc)_"(extra,sn)")))
 . . s x=$$ehead(.head,size,byref,ddata)
 . . d send(head)
 . . d send($g(@req(argc)))
 . . f sn=1:1 q:'$d(@(req(argc)_"(extra,sn)"))  d send($g(@(req(argc)_"(extra,sn)")))
 . . q
 . s x=$$ehead(.head,0,0,darec)
 . d send(head)
 . d resa
 . s x=$$ehead(.head,0,0,deod)
 . d send(head)
 . q
 q
 ;
res1 ; Link to array parser
 d send($g(req(argc,0))_$g(req(argc,1)))
 i '$g(req(argc,1)) q
 i $g(req(argc,0))=0 d send($g(@req(argc))) q
 s a=req(argc),fkey="" i global s a="^MGWSI",fkey="$j,argc-2"
 d resa
 q
 ;
resa ; Return array
 n ref,kn,ok,def,data,txt
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":resae"
 s byref=0
 s a=req(argc),fkey="" i global s a="^MGWSI",fkey="$j,argc-2"
 i a="" q
 i global d
 . i ($d(@(a_"("_fkey_")"))#10) d
 . . s txt=" ",x=$$ehead(.head,$l(txt),byref,dakey) d send(head),send(txt)
 . . s size=0
 . . s size=size+$l($g(@req(argc)))
 . . f sn=1:1 q:'$d(@(a_"("_fkey_","_"extra,sn)"))  s size=size+$l($g(^(sn)))
 . . s x=$$ehead(.head,size,byref,ddata) d send(head)
 . . d send($g(@req(argc)))
 . . f sn=1:1 q:'$d(@(a_"("_fkey_","_"extra,sn)"))  d send($g(^(sn)))
 . . q
 . s fkey=fkey_","
 . q
 i 'global d
 . i ($d(@a)#10),$l($g(@a)) d
 . . s txt=" ",x=$$ehead(.head,$l(txt),byref,dakey) d send(head),send(txt)
 . . s size=0
 . . s size=size+$l($g(@a))
 . . f sn=1:1 q:'$d(@(a_"(extra,sn)"))  s size=size+$l($g(@(a_"(extra,sn)")))
 . . s x=$$ehead(.head,size,byref,ddata) d send(head)
 . . d send($g(@a))
 . . f sn=1:1 q:'$d(@(a_"(extra,sn)"))  d send($g(@(a_"(extra,sn)")))
 . . q
 . q
 s ok=0,kn=1,x(kn)="",ref="x("_kn_")"
 f  s x(kn)=$o(@(a_"("_fkey_ref_")")) d resa1 i ok q
 q
resae ; Error
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":"
 q
 ;
resa1 ; Array node
 i x(kn)=extra q
 i x(kn)="",kn=1 s ok=1 q
 i x(kn)="" s kn=kn-1,ref=$p(ref,",",1,$l(ref,",")-1) q
 s def=$d(@(a_"("_fkey_ref_")")) i (def\10) d resa3
 s data=$g(@(a_"("_fkey_ref_")"))
 i (def#10) d resa2
 i (def\10) s kn=kn+1,x(kn)="",ref=ref_","_"x("_kn_")"
 q
 ;
resa2 ; Array node data
 n i,spc
 f i=1:1:kn s x=$$ehead(.head,$l(x(i)),byref,dakey) d send(head),send(x(i))
 i $g(%ZCS("client"))="z",(def\10) s spc=" ",x=$$ehead(.head,$l(spc),byref,dakey) d send(head),send(spc)
 s size=$l(data)
 f sn=1:1 q:'$d(@(a_"("_fkey_ref_",extra,sn)"))  s size=size+$l($g(@(a_"("_fkey_ref_",extra,sn)")))
 s x=$$ehead(.head,size,byref,ddata) d send(head)
 d send(data)
 f sn=1:1 q:'$d(@(a_"("_fkey_ref_",extra,sn)"))  d send($g(@(a_"("_fkey_ref_",extra,sn)")))
 q
 ;
resa3 ; Array node data with descendants - test for non-extra data
 n y
 s y="" f  s y=$o(@(a_"("_ref_",y)")) q:y=""  i y'=extra q
 i y="" s def=1
 q
 ;
send(data) ; Send data
 n n
 ;D EVENT(data_$g(res(1)))
 s n=$o(res(""),-1)
 i n="" s n=1
 i $l($g(res(n)))+$l(data)>maxlen s n=n+1
 s res(n)=$g(res(n))_data
 q
 ;
getsys() ; Get system type
 s systype="GTM"
 q systype
 ;
getuci() ; Get NameSpace/UCI
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":getucie^%ZMGWSIS"
 s %UCI=$ZG
 q %UCI
getucie ; Error
 q ""
 ;
getslen() ; Get maximum string length
 s slen=32000
 q slen
 ;
lcase(string) ; Convert to lower case
 q $tr(string,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 ;
ucase(string) ; Convert to upper case
 q $tr(string,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
setio(tblname) ; Set I/O translation
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":setioe^%ZMGWSIS"
 Q ""
setioe ; Error - do nothing
 Q ""
 ;
zcvt(buffer,tblname) ; Translate buffer
 new $ZTRAP set $ZTRAP="ZGOTO "_$ZLEVEL_":zcvte^%ZMGWSIS"
 Q buffer
zcvte ; Error - do nothing
 Q buffer
 ;
WSMQTEST ; Test link to WebSphere MQ
 n %mgwmq,response
 w !,"Sending Test Message to MGWSI/WebSphere MQ interface..."
 S response=$$WSMQ("127.0.0.1",7040,"TEST",.%mgwmq)
 W !,"Response: ",response," ",$G(%mgwmq("recv"))
 Q
 ;
WSMQTSTX(IP,PORT) ; Test link to WebSphere MQ: IP address and Port specified
 n %mgwmq,response
 w !,"Sending Test Message to MGWSI/WebSphere MQ interface..."
 S response=$$WSMQ(IP,PORT,"TEST",.%mgwmq)
 W !,"Response: ",response," ",$G(%mgwmq("recv"))
 Q
 ;
HTEST ; Return HTML
 n systype
 s systype=$$getsys()
 w "<I>A line of HTML from "_systype_"</I>"
 Q
 ;
HTEST1(P1) ; Return HTML
 n x,systype
 s systype=$$getsys()
 ;W "HTTP/1.1 200 OK",$c(13,10)
 ;W "Content-Type: text/html",$c(13,10)
 ;W "Connection: close",$c(13,10)
 ;W $c(13,10)
 w "<I>HTML content returned from "_systype_"</I>"
 W "<br><I>The input parameter passed was: <B>"_$g(P1)_"</B></I>"
 s x="" f  s x=$o(P1(x)) q:x=""  W "<br><I>Array element passed: <B>"_x_" = "_$g(P1(x))_"</B></I>"
 Q
 ;
PTEST() ; Return result
 n systype
 s systype=$$getsys()
 q "Result from "_systype_" process: "_$J_"; UCI: "_$$getuci()
 Q
 ;
PTEST1(P1) ; Return result
 n systype
 s systype=$$getsys()
 q "Result from "_systype_" process: "_$J_"; UCI: "_$$getuci()_"; The input parameter passed was: "_P1
 ;
PTEST2(P1,P2) ; Manipulate an array
 n n,x,systype
 s systype=$$getsys()
 s n=0,x="" f  s x=$o(P1(x)) q:x=""  s n=n+1
 s P1("Key from M - 1")="Value 1"
 s P1("Key from M - 2")="Value 2"
 s P2="Stratford"
 q "Result from "_systype_" process: "_$J_"; UCI: "_$$getuci()_"; "_n_" elements were received in an array, 2 were added by this procedure"
 ;
