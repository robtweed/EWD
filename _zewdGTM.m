%zewdGTM	;Enterprise Web Developer GT.M/ Virtual Appliance Functions
 ;
 ; Product: Enterprise Web Developer (Build 850)
 ; Build Date: Sat, 12 Feb 2011 14:13:17
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
	; EWD Virtual Appliance Version/Build
version()	
	QUIT "6.0"
	;
buildDate()	
	QUIT "29 January 2009"
	;
config	;
	d setApplicationRootPath^%zewdAPI("/usr/ewd/apps")
	d setOutputRootPath^%zewdAPI("/usr/php","php")
	;s ^%eXtc("system","license")="2vxuxs3qzqxuyuvtynezvm8yy5Wrz4i7wwwrzmsvqwwtr"
	QUIT
	;
getMGWSIPid()	
	;
	n io,ok,line,stop,temp
	s io=$io
	s temp="temp"_$p($h,",",2)_".txt"
	zsystem "ps -A|grep mgwsi > "_temp
	o temp:(readonly:exception="g nsFileNotExists") 
	u temp
	r line
	c temp
	u io
	s ok=$$deleteFile^%zewdAPI(temp)
	s line=$$stripSpaces^%zewdAPI(line)
	QUIT +line
startMGWSI	;
	k ^%zewd("mgwsis")
	d START^%ZMGWSI(0)
	;s ^%zewd("mgwsi","job")=$zjob
	QUIT
	;
stopMGWSI	;
	n pid
	;s pid=$g(^%zewd("mgwsi","job"))
	;s pid=$$getMGWSIPid()
	;i pid'="" d
	;. k ^%zewd("mgwsi","job")
	;. i $$pidExists(pid) zsystem "kill -TERM "_pid
	s pid=""
	f  s pid=$o(^%zewd("mgwsis",pid)) q:pid=""  d
	. k ^%zewd("mgwsis",pid)
	. i $$pidExists(pid) zsystem "kill -TERM "_pid
	QUIT
	;
restartMGWSI	
	d stopMGWSI
	d startMGWSI
	QUIT
	;
closeMGWSI(server)
	; eg server=the MGWSI "server" to be closed, eg ewd, LOCAL, etc
	n ok,html,url
	s url="http://127.0.0.1:7040/cgi-bin/nph-mgwsic?mgwsidef=Default_CloseDown_Server&mgwsiSYS=2&mgwsiCDN="_server_"&mgwsiSYSbOK=Close+Connections(s)"
	s ok=$$httpGET(url,.html)
	QUIT
	;
closeMGWSIConnections	
	n pid
	s pid=""
	f  s pid=$o(^%zewd("mgwsis",pid)) q:pid=""  d
	. k ^%zewd("mgwsis",pid)
	. i $$pidExists(pid) zsystem "kill -TERM "_pid
	QUIT
	;
shutdown	
	zsystem "shutdown -h now"
	QUIT
	;
restart	
	zsystem "shutdown -r now"
	QUIT
	;
pidExists(pid)	;
	n io,line,ok,temp
	s io=$io
	s temp="temp"_$p($h,",",2)_".txt"
	zsystem "ps --no-heading "_pid_" > "_temp
	c temp
	o temp:(readonly:exception="g pidFileNotExists")
	u temp r line
	c temp
	u io
	s ok=$$deleteFile^%zewdAPI(temp)
	i line'[pid QUIT 0
	QUIT 1
pidFileNotExists	
	c temp
	s ok=$$deleteFile^%zewdAPI(temp)
	u io
	i $p($zs,",",1)=2 QUIT 0
	QUIT 0
	;
validDomain(domain)	
	;
	n exists,io,ok,line,stop,temp
	s io=$io
	s temp="temp"_$p($h,",",2)_".txt"
	zsystem "nslookup "_domain_" >"_temp
	o temp:(readonly:exception="g nsFileNotExists") 
	u temp
	s stop=0,exists=0
	f  r line d  q:stop 
	. i line["authoritative answer" s stop=1,exists=1 q
	. i line["server can't find" s stop=1,exists=0 q
	c temp
	u io
	s ok=$$deleteFile^%zewdAPI(temp)
	QUIT exists
nsFileNotExists	
	u io
	i $p($zs,",",1)=2 QUIT -1
	QUIT -1
	;
getIP(info)	
	;
	n exists,io,ip,ok,line,stop,temp,value
	s io=$io
	s temp="temp"_$p($h,",",2)_".txt"
	zsystem "ifconfig eth0 >"_temp
	o temp:(readonly:exception="g ipFileNotExists") 
	u temp
	s stop=0,ok=0,ip=""
	f  r line d  q:stop
	. i line["HWaddr" d
	. . s value=$p(line,"HWaddr ",2)
	. . s info("mac")=$$stripSpaces^%zewdAPI(value)
	. i line["inet addr:" d
	. . s value=$p(line,"inet addr:",2)
	. . s ip=$p(value," ",1)
	. . s info("ip")=ip
	. . i ip="127.0.0.1" s stop=1
	. i line["Bcast:" d
	. . s value=$p(line,"Bcast:",2)
	. . s value=$p(value," ",1)
	. . s info("broadcast")=value
	. i line["Mask:" d
	. . s value=$p(line,"Mask:",2)
	. . s value=$p(value," ",1)
	. . s info("mask")=value
	. i line["inet6 addr" s stop=1 q
	. i line["Local Lookback" s stop=1 q
	c temp
	u io
	s ok=$$deleteFile^%zewdAPI(temp)
	QUIT ip
ipFileNotExists	
	s $zt=""
	u io
	i $p($zs,",",1)=2 QUIT -1
	QUIT ""
	;
openTCP(host,port,timeout)	
	n delim,dev
	i host'?1N.N1"."1N.N1"."1N.N1"."1N.N,'$$validDomain(host) QUIT 0
	i $g(host)="" QUIT 0
	i $g(port)="" QUIT 0
	i $g(timeout)="" s timeout=20
	s delim=$c(13)
	s dev="client$"_$p($h,",",2)
	;o dev:(connect=host_":"_port_":TCP":attach="client":exception="g tcperr"):timeout:"SOCKET"
	o dev:(connect=host_":"_port_":TCP":attach="client":exception="g tcperr":nowrap):timeout:"SOCKET" 
	QUIT dev
	;
tcperr	;
	QUIT 0
	;
resetSecurity	
	;
	k ^%zewd("config","security","validSubnet")
	QUIT
	;
resetVM	
	n files
	d resetSecurity
	k ^%zewdSession
	s ^%zewd("nextSessid")=1
	k ^%zewd("mgwsi")
	k ^%zewd("mgwsis")
	k ^%zewd("emailQueue")
	k ^%zewd("daemon","email")
	k ^%zewd("relink")
	k ^%eXtc
	k ^%zewdLog
	k ^%zewdError
	k ^CacheTempUserNode
	k ^CacheTempEWD
	k ^%zewdTrace
	k ^zewd("trace")
	k ^%MGW,^%MGWSI
	k ^rob,^robdata,^robcgi
	k ^CacheTempWLD
	k ^ewdDemo
	d removeDOMsByPrefix^%zewdAPI()
	;d getFilesInPath^%zewdHTMLParser("/usr/local/gtm/ewd",".m",.files)
	;f lineNo=1:1 s line=$t(leaveAsM+lineNo) q:line["***END***"  d
	;. s leaveFiles($p(line,";;",2))=""
	; s file=""
	;f  s file=$o(files(file)) q:file=""  d
	;. i $d(leaveFiles(file)) q
	;. i file'["_zewd" q
	;. s path="/usr/local/gtm/ewd/"_file
	;   . s ok=$$deleteFile^%zewdAPI(path)
	;   s ok=$$deleteFile^%zewdAPI("/usr/local/gtm/ewd/MDB.m")
	;   s ok=$$deleteFile^%zewdAPI("/usr/local/gtm/ewd/MDBMgr.m")
       ;s ok=$$deleteFile^%zewdAPI("/usr/local/gtm/ewd/MDBConfig.m")
       s ok=$$deleteFile^%zewdAPI("/usr/MDB/MDB.conf")
	k ^MDB,^MDBUAF
	zsystem "rm -f ~/.bash_history"
	zsystem "history -c"
	;echo " "> /var/log/apache2/access.log
	;echo " "> /var/log/apache2/error.log
	;echo " "> /var/log/apache2/access.log.1"
	;echo " "> /var/log/apache2/error.log.1"
	;zsystem "rm /usr/php/tutorial/*.*"
	; Now clear down history for root
	; Shutdown Apache and clear down Apache Log files - use above commented commands
	; Delete all ewdapps directories and files
	; Delete all PHP directories and files
	; zero-space all empty content: cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill
	; Compress the virtual drives: 
	; G:\virtual_machines\mdb_1_0_master>"C:\Program Files\VMware\VMware Server\vmware-vdiskmanager.exe" -k Ubuntu-cl1.vmdk
	QUIT
	;
setClock	
	zsystem "ntpdate ntp.ubuntu.com"
	QUIT
	;
startVM	
	;
	n cr,ip
    s cr=$c(13)
	;d startMGWSI
	w cr,!
	d setClock
	s ip=$$getIP()
	w cr,!
	w "======================================================="_cr,!
	w "  Welcome to the EWD Virtual Appliance       "_cr,!
	w "      -- Version "_$$version()_": "_$$buildDate()_" --"_cr,!
	;
	i ip=""!(ip="127.0.0.1") g startVMFail
	w !
	w "   System clock set to "_$$inetDate^%zewdAPI($h)_cr,!!
	w "   The EWD Virtual Appliance is now ready for use!"_cr,!
	w " To run the EWD Management Portal, point your browser at http://"_ip_cr,!!
	g startVMFin
startVMFail	
	w "Unfortunately the Virtual Appliance was unable to acquire an IP"_cr,!
	w "address.  Please consult the readme file for what to do next"_cr,!
startVMFin	
	w "======================================================="_cr,!
	QUIT
	;
startMDBVM	
	;
	n cr,ip
	s cr=$c(13)
	;d startMGWSI
	w cr,!
	d setClock
	s ip=$$getIP()
	w cr,!
	w "======================================================="_cr,!
	w "  Welcome to the M/DB Virtual Appliance       "_cr,!
	w "      -- Version "_$$version^MDB()_": "_$$buildDate^MDB()_" --"_cr,!
	;
	i ip=""!(ip="127.0.0.1") g startVMFail
	w !
	w "   System clock set to "_$$inetDate^%zewdAPI($h)_cr,!!
	w "   The M/DB Virtual Appliance is now ready for use!"_cr,!
	w " To run the M/DB Management Portal, point your browser at http://"_ip_cr,!!
	g startVMFin
	;
httpGET(url,html,headerArray,timeout,test,rawResponse,respHeaders,sslHost,sslPort)	
	;
	n dev,host,HTTPVersion,io,port,rawURL,ssl,urllc
	;
    k rawResponse
    i $g(html)'="global" k html
	s HTTPVersion="1.0"
	s rawURL=url
	s ssl=0
	s port=80
	s urllc=$$zcvt^%zewdAPI(url,"l")
	i $e(urllc,1,7)="http://" d
	. s url=$e(url,8,$l(url))
	. s sslHost=$p(url,"/",1)
	. s sslPort=80
	. i sslHost[":" d
	. . s sslPort=$p(sslHost,":",2)
	. . s sslHost=$p(sslHost,":",1)
	e  i $e(urllc,1,8)="https://" d
	. s url=$e(url,9,$l(url))
	. s ssl=1
	. s sslHost=$g(sslHost)
	. i sslHost="" s sslHost="127.0.0.1"
	. s sslPort=$g(sslPort)
	. i sslPort="" s sslPort=89
	e  QUIT "Invalid URL"
	s host=$p(url,"/",1)
	i host[":" d
	. s port=$p(host,":",2)
	. s host=$p(host,":",1)
	s url="/"_$p(url,"/",2,5000)
	i $g(timeout)="" s timeout=20
	;
	s io=$io
	i $g(test)'=1 d
	. s dev=$$openTCP(sslHost,sslPort,timeout)
	. u dev
	i ssl d
	. w "GET "_rawURL_" HTTP/"_HTTPVersion_$c(13,10)
	e  d
	. w "GET "_url_" HTTP/"_HTTPVersion_$c(13,10)
	w "Host: "_host
	i port'=80 w ":"_port
	w $c(13,10)
	w "Accept: */*"_$c(13,10)
	;
	i $d(headerArray) d
	. n n
	. s n=""
	. f  s n=$o(headerArray(n)) q:n=""  d
	. . w headerArray(n)_$c(13,10)
	; 
	w $c(13,10),!
	;
	; That's the request sent !
	;
httpResponse	;
	;
	i $g(test)=1 QUIT ""
	n c,dlim,header,i,lineNo,n,no,offset,pos,rlen,stop,str,toGlobal
	;
	k respHeaders
	s stop=0,no=1
	f i=1:1 d  q:stop
	. i i=1
	. r c#1
	. i c=$c(13) q 
	. i c'=$c(10) s respHeaders(no)=$g(respHeaders(no))_c
	. i c=$c(10),$g(respHeaders(no))="" s stop=1 q
	. i c=$c(10) s no=no+1
	;
	s rlen=9999
	f i=1:1:(no-1) d
	. s header=$$zcvt^%zewdAPI(respHeaders(i),"l")
	. i header["content-length" d
	. . s rlen=$p(header,":",2)
	. . s rlen=$$stripSpaces^%zewdAPI(rlen)
	;
	i rlen<9999 d
	. r str#rlen
	e  d 
	. s str=""
	. f pos=1:1 u dev r str#10000:timeout g:'$t httpTimeout  q:str=""  s str(pos)=str q:($l(str)<10000)
	i $g(test)'=1 c dev
	s rawResponse=""
	s dlim=$c(10)
	f i=1:1:(no-1) s rawResponse=rawResponse_respHeaders(i)_dlim
	i $d(str)=1 s rawResponse=rawResponse_dlim_str
	i $d(str)=1 s str(1)=str
	s lineNo="",offset=0,n=0,toGlobal=0
	i $g(html)="global" k ^CacheTempEWD($j) s toGlobal=1
	f  s lineNo=$o(str(lineNo)) q:lineNo=""  d
	. s dlim=$c(10)
	. s str=str(lineNo)
	. i str[$c(13,10) s dlim=$c(13,10)
	. s rlen=$l(str,dlim)
	. i toGlobal d
	. . f i=1:1:rlen s n=n+1,^CacheTempEWD($j,n)=$p(str,dlim,i)
	. e  d
	. . f i=1:1:rlen s n=n+1,html(n)=$p(str,dlim,i)
	;
	u io
	QUIT ""
	;
httpTimeout	
	QUIT "Timed out waiting for response"
	;
httpPOST(url,payload,mimeType,html,headerArray,timeout,test,rawResponse,respHeaders,sslHost,sslPort)	
	;
	n contentLength,dev,host,HTTPVersion,io,port,rawURL,ssl,urllc
	;
	k rawResponse,html
	s HTTPVersion="1.0"
	s rawURL=url
	s ssl=0
	s port=80
	s urllc=$$zcvt^%zewdAPI(url,"l")
	i $e(urllc,1,7)="http://" d
	. s url=$e(url,8,$l(url))
	. s sslHost=$p(url,"/",1)
	. s sslPort=80
	e  i $e(urllc,1,8)="https://" d
	. s url=$e(url,9,$l(url))
	. s ssl=1
	. s sslHost=$g(sslHost)
	. i sslHost="" s sslHost="127.0.0.1"
	. s sslPort=$g(sslPort)
	. i sslPort="" s sslPort=89
	e  QUIT "Invalid URL"
	s host=$p(url,"/",1)
	i host[":" d
	. s port=$p(host,":",2)
	. s host=$p(host,":",1)
	s url="/"_$p(url,"/",2,5000)
	i $g(timeout)="" s timeout=20
	;
	s io=$io
	i $g(test)'=1 d
	. s dev=$$openTCP(sslHost,sslPort,timeout)
	. u dev
	i ssl d
	. w "POST "_rawURL_" HTTP/"_HTTPVersion_$c(13,10)
	e  d
	. w "POST "_url_" HTTP/"_HTTPVersion_$c(13,10)
	w "Host: "_host
	i port'=80 w ":"_port
	w $c(13,10)
	w "Accept: */*"_$c(13,10)
	;
	i $d(headerArray) d
	. n n
	. s n=""
	. f  s n=$o(headerArray(n)) q:n=""  d
	. . w headerArray(n)_$c(13,10)
	;
	s mimeType=$g(mimeType)
	i mimeType="" s mimeType="application/x-www-form-urlencoded"
	s contentLength=0
	i $d(payload) d
	. n no
	. s no=""
	. f  s no=$O(payload(no)) q:no=""  D
	. . s contentLength=contentLength+$l(payload(no))
	. s contentLength=contentLength
	. w "Content-Type: ",mimeType
	. i $g(charset)'="" w "; charset=""",charset,""""
	. w $c(13,10)
	. w "Content-Length: ",contentLength,$c(13,10)
	;
	w $c(13,10)
	i $D(payload) d
	. n no
	. s no=""
	. f  s no=$O(payload(no)) q:no=""  d
	. . w payload(no)
	; 
	w $c(13,10),!
	;
	; That's the request sent !
	;
	g httpResponse
	;
parseURL(url,docName)	
	;
	n getPath,ok,server
	;
	i url["http://" s url=$p(url,"http://",2)
	s server=$p(url,"/",1)
	s getPath=$p(url,"/",2,1000)
	s ok=$$parseURL^%zewdHTMLParser(server,getPath,docName)
	QUIT ok
	;
smtpSend(domain,from,displayFrom,to,displayTo,ccList,subject,message,dialog,authType,username,password,timeout,gmtOffset,port)	
	;
	n attach,boundary,crlf,date,dev,error,io,mess,rcpt,resp,sent,toList
	;
	s timeout=$g(timeout) i timeout="" s timeout=10
	s domain=$g(domain)
	s port=$g(port) i port="" s port=25
	s from=$g(from)
	s to=$g(to)
	s subject=$g(subject)
	s gmtOffset=$g(gmtOffset) i gmtOffset="" s gmtOffset="GMT"
	;
	s error=""
	i domain="" QUIT "No SMTP Domain specified"
	i from="" QUIT "No sender's email address specified"
	i to="" QUIT "No recipient's email address specified"
	i '$d(message) QUIT "No Email content specified"
	;
	s date=$$inetDate^%zewdAPI($h)_" "_gmtOffset
	s mess($increment(mess))="Date: "_date
	i $g(displayFrom)'="" d
	. s mess($increment(mess))="From: """_displayFrom_"""<"_from_">"
	e  d
	. s mess($increment(mess))="From: "_from
	i $g(displayTo)'="" d
	. s mess($increment(mess))="To: """_displayTo_"""<"_to_">"
	e  d
	. s mess($increment(mess))="To: "_to
	s toList(to)=""
	i $d(ccList) d
	. n name
	. s mess($increment(mess))="Cc: "
	. i $g(ccList)'="" d
	. . s toList(ccList)=""
	. . s mess(mess)=mess(mess)_ccList
	. s name=""
	. f  s name=$o(ccList(name)) q:name=""  d
	. . i mess(mess)'="Cc: " s mess(mess)=mess(mess)_", "
	. . s mess(mess)=mess(mess)_name
	. . s toList(name)=""
	s mess($increment(mess))="Subject: "_subject
	s mess($increment(mess))="X-Priority: 3 (Normal)"
	s mess($increment(mess))="X-MSMail-Priority: Normal"
	s mess($increment(mess))="X-Mailer: "_$$version^%zewdAPI()
	s mess($increment(mess))="MIME-Version: 1.0"
	s mess($increment(mess))="Content-Type: text/plain; charset=""us-ascii"""
	s mess($increment(mess))="Content-Transfer-Encoding: 7bit"
	s mess($increment(mess))=""
	;
	s message=$g(message)
	i message'="" d
	. s mess($increment(mess))=message
	e  d
	. n mlno
	. s mlno=""
	. f  s mlno=$o(message(mlno)) q:mlno=""  d
	. . s mess($increment(mess))=message(mlno)
	;
	k dialog
	s io=$io
	s crlf=$c(13,10)
	s dev=$$openTCP(server,port,timeout)
	i dev=0 QUIT "Unable to connect to SMTP server: "_server
	u dev
	r resp:timeout e  d close QUIT "Unable to initiate connection with SMTP server"
	s resp=$p(resp,crlf,1)
	s dialog($increment(dialog))=resp
	s error=""
	s authType=$g(authType)
	i authType="LOGIN PLAIN"!(authType="LOGIN") d  i error'="" d close QUIT error
	. n context,decode,passB64,str,userB64
	. s context=1
	. i $d(^zewd("config","MGWSI")) s context=0
	. u dev w "EHLO "_domain_crlf,! s resp=$$read(.dialog)
	. i resp'["250",resp'["AUTH",resp'["LOGIN" s error="Authentication type LOGIN/LOGIN PLAIN not supported on this server" q
	. u dev w "AUTH LOGIN"_crlf,! s resp=$$read(.dialog)
	. i resp'["334" s error="No username authentication challenge from server" q
	. s str=$p(resp," ",2,1000)
	. s decode=$$DB64^%ZMGWSIS(str,context)
	. s resp="(decoded as : "_decode_")"
	. s dialog($increment(dialog))=resp
	. s userB64=$$B64^%ZMGWSIS(username,context)
	. u dev w userB64_crlf,! s resp=$$read(.dialog)
	. i resp'["334" s error="No password authentication challenge from server" q
	. s str=$p(resp," ",2,1000)
	. s decode=$$DB64^%ZMGWSIS(str,context)
	. s resp="(decoded as : "_decode_")"
	. s dialog($increment(dialog))=resp
	. s passB64=$$B64^%ZMGWSIS(password,context)
	. u dev w passB64_crlf,! s resp=$$read(.dialog)
	. i resp'["235 " s error=resp q
	e  d  i error'="" d close QUIT error
	. u dev w "HELO "_domain_crlf,! s resp=$$read(.dialog)
	. i resp'["250" s error=resp
	;
	u dev w "MAIL FROM: "_from_crlf,! s resp=$$read(.dialog)
	i resp'["250" d close QUIT resp
	;
	s rcpt=""
	f  s rcpt=$o(toList(rcpt)) q:rcpt=""  d  i resp'[250 q
	. u dev w "RCPT TO: <"_rcpt_">"_$c(13,10),! 
	. s resp=$$read(.dialog)
	i resp'[250 d close QUIT resp
	;
	u dev w "DATA",crlf,! s resp=$$read(.dialog)
	i resp'["250",resp'["354" d close QUIT resp
	;
	s message=$g(message)
	i message'="" d message(message,dev)
	e  d
	. n line,lineNo
	. s lineNo=""
	. f  s lineNo=$o(mess(lineNo)) q:lineNo=""  d
	. . s line=mess(lineNo)
	. . d message(line,dev)
	u dev w crlf,".",crlf,! s resp=$$read(.dialog)
	i resp'["250" d close QUIT resp
	u dev w "QUIT",crlf,! s resp=$$read(.dialog)
	d close
	QUIT ""
	;
read(dialog)	
	n resp
	r resp
	s resp=$p(resp,$c(13,10),1)
	s dialog($increment(dialog))=resp
	QUIT resp
close	;
	c dev
	u io
	QUIT
	;
message(line,dev)	
	n buf,p1
	s buf=$g(line)
	i buf="" u dev w $c(13,10),! QUIT
	f  q:buf=""  d
	. s p1=$e(buf,1,254),buf=$e(buf,255,$l(buf))
	. i $e(p1)="." s p1="."_p1
	. i $l(p1) u dev w p1,!
	u dev w $c(13,10),!
	QUIT
	;
smtpTest	
	s server="relay.xxxx.net"
	s from="rtweed@xxxxx.com"
	s displayFrom="Rob Tweed"
	s displayTo=displayFrom
	s to="rtweed@xxxx.co.uk"
	s ccList("rtweed@yyyy.co.uk")=""
	s ccList("rtweed@zzzz.com")=""
	s message(1)="Test Message"
	s message(2)="This is line 2"
	s message(3)="And here is line 3"
	s authType="LOGIN PLAIN"
	s user="xxxxxxxxx"
	s pass="yyyyyyyyy"
	s subject="Test email 2"
	s ok=$$smtpSend(server,from,displayFrom,to,displayTo,.ccList,subject,.message,.dialog,authType,user,pass)
	QUIT
	;
getFileInfo(path,ext,info)	; Get list of files with specified extension
	;
	n date,dlim,%file,%io,lineNo,ok,os,%p1,result,time,%x,%y
	;
	k info
	s dlim="/"
	i $e(ext,1)'="." s ext="."_ext
	i $e(path,$l(path))=dlim s path=$e(path,1,$l(path)-1)
	;
	d shellCommand("ls -l """_path_"""",.result)
	;
	; we now have directory listing in result array
	s lineNo=""
	f  s lineNo=$o(result(lineNo)) q:lineNo=""  d
	. s %file=result(lineNo)
	. s %p1=$P(%file," ",1)
	. i $e(%p1,1)'="d" d
	. . n %e1,%e2,%rfile,%p9,%len,%name,size
	. . s %rfile=$re(%file)
	. . s %rfile=$$replaceAll^%zewdAPI(%rfile,"  "," ")
	. . s %p9=$p(%rfile," ",1)
	. . s time=$p(%rfile," ",2)
	. . s date=$p(%rfile," ",3,4)
	. . s size=$p(%rfile," ",5)
	. . s %p9=$re(%p9)
	. . s time=$re(time)
	. . s date=$re(date)
	. . ;i $$zcvt^%zewdAPI(%p9,"l")=$$zcvt^%zewdAPI(%tofile,"l") q  ; ignore temp file
	. . i ext=".*" s info(%p9)=date_$c(1)_time_$c(1)_size q
	. . s %e1="."_$$getFileExtension^%zewdHTMLParser(%p9)
	. . i %e1'=ext q
	. . s info(%p9)=date_$c(1)_time_$c(1)_size
	QUIT
	;
shellPipe	; Pipe output from shell commands to scratch global
	;
	n i,x
	;
	k ^%mgwPipe
	;f i=1:1:200 r x q:((i>20)&(x=""))  s ^%mgwPipe(i)=x
	f i=1:1 r x q:$zeof  s ^%mgwPipe(i)=x
	QUIT
	;
deletePipe	
	k ^%mgwPipe
	QUIT
	;
lockPipe	
	l +^%mgwPipe
	QUIT
	;
unlockPipe	
	l -^%mgwPipe
	QUIT
	;
shellCommand(command,result)	;
	n lineNo
	s lineNo=$$shell(command,.result) QUIT
	k result
	d lockPipe
	zsystem command_" |mumps -run shellPipe^%zewdGTM"
	m result=^%mgwPipe
	d deletePipe
	d unlockPipe
	s lineNo=""
	f  s lineNo=$o(result(lineNo),-1) q:lineNo=""  q:result(lineNo)'=""  k result(lineNo)
	QUIT
	;
fileInfo(path,info)	
	n line,temp
	k info
	s temp="temp"_$p($h,",",2)_".txt"
	i '$$fileExists^%zewdAPI(path) QUIT
	zsystem "ls -l "_path_">"_temp
	o temp:(readonly:exception="g fileDateNotExists") 
	u temp
	r line
	s info("date")=$p(line," ",6,8)
	s info("size")=$p(line," ",5)
	c temp
	s ok=$$deleteFile^%zewdAPI(temp)
	QUIT
fileDateNotExists	
	s $zt=""
	i $p($zs,",",1)=2 QUIT
	QUIT
shell(command,result)	
	n i,io,temp
	k result
	s io=$io
	s temp="temp"_$p($h,",",2)_".txt"
	zsystem command_">"_temp
	o temp:(readonly) 
	u temp:exception="g eoshell"
	f i=1:1 r result(i)
eoshell	;
	c temp
	u io
	s ok=$$deleteFile^%zewdAPI(temp)
	QUIT i-1
	;
testGlobal()	
	s start=$h
	f i=1:1:1000 d fileInfo^%zewdAPI("/usr/php/ewdMgr/user.php",.info)
	s end=$h
	s dur=$p(end,",",2)-$p(start,",",2)
	QUIT dur
	;
testFile()	
	s start=$h
	f i=1:1:1000 d fileInfo^%zewdGTM("/usr/php/ewdMgr/user.php",.info)
	s end=$h
	s dur=$p(end,",",2)-$p(start,",",2)
	QUIT dur
	;
mySQL(sql,resultArray,username,password,database)
	n nlines,str
	;
	i $g(username)="" s username="root"
	i $g(password)="" s password="1234567"
	i $g(database)="" s database="test"
	s str="mysql --xml -u "_username_" -p"_password_" "_database_" -e """_sql_""""
	s nlines=$$shell(str,.resultArray)
	QUIT nlines
	;
encodeDate(dateString)
	n %DN,%DS
	s %DS=dateString
	d INT^%DATE
	QUIT $g(%DN)
	;
relink ;
 s ^%zewd("relink")=1 k ^%zewd("relink","process")
 QUIT
 ;
pwd() ;
 n line,temp
 k info
 s temp="temp"_$p($h,",",2)_".txt"
 zsystem "pwd>"_temp
 o temp:(readonly:exception="g filepwdNotExists")
 u temp
 r line
 c temp
 s ok=$$deleteFile^%zewdAPI(temp)
 QUIT line
filepwdNotExists
 s $zt=""
 QUIT ""
 ;
goq(global,file)
 ;
 n stop,q,v,x
 s global=$g(global)
 i $e(global,1)'="^" s global="^"_global
 s file=$g(file)
 s q="s x=$q("_global_"(""""))"
 x q
 i x="" QUIT
 s v=@x
 w x,!,v,!
 s stop=0
 f  d  q:stop
 . s q="s x=$q(@x)"
 . x q i x="" s stop=1 q
 . s v=@x
 . w x,!,v,!
 QUIT
 ;
uuid()
 n c,chars,chars2,i,uuid
 s uuid=""
 s chars="0123456789abcdef"
 s chars2="89ab"
 f i=1:1:36 d
 . i i=15 s uuid=uuid_4 q
 . i (i=9)!(i=14)!(i=19)!(i=24) s uuid=uuid_"-" q
 . i i=20 s c=$r(4)+1,uuid=uuid_$e(chars2,c) q
 . s c=$r(16)+1,uuid=uuid_$e(chars,c) q
 QUIT uuid
 ;
tar(infile,outfile)
 zsystem "tar -cf "_outfile_" "_infile
 QUIT
 ;
gzip(file)
 zsystem "gzip "_file
 QUIT
 ;
createTarGz(infile,outfileRootName)
 ;
 n gzname,ok,tarname
 ;
 s tarname=outfileRootName_".tar"
 s gzname=tarname_".gz"
 i $$fileExists^%zewdAPI(tarname) s ok=$$deleteFile^%zewdAPI(tarname)
 i $$fileExists^%zewdAPI(gzname) s ok=$$deleteFile^%zewdAPI(gzname)
 d tar(infile,tarname)
 d gzip(tarname)
 QUIT
 ;
getLinuxBuild()
 n build,i,io,line,p,resp
 s io=$io
 s p="lsb"
 o p:(COMMAND="lsb_release -d":READONLY)::"PIPE"
 u p
 f i=1:1 r line q:$ZEOF  s resp(i)=line
 c p
 u io
 s build=$g(resp(1))
 s build=$p(build,":",2,100)
 s build=$tr(build,$c(9),"")
 s build=$$stripSpaces^%zewdAPI(build)
 QUIT build
 ;
install
 n default,x
 ;
 w !,"Installing/Configuring "_$$version^%zewdAPI(),!!
 w "Note: hit Esc to go back at any point",!!
install1 ;
 s default=$g(^zewd("config","applicationRootPath"))
 i default="" s default="/usr/ewdapps"
 w !,"Application Root Path ("_default_"): " r x
 i $zb=$c(27) w !," Installation aborted",!! QUIT
 i x="" s x=default w x
 s ^zewd("config","applicationRootPath")=x
 ;
install2 ;
 s default=$g(^zewd("config","routinePath","gtm"))
 i default="" s default="/usr/local/gtm/ewd/"
 w !,"Routine Path ("_default_"): " r x
 i $zb=$c(27) w ! g install1
 i x="" s x=default w x
 s ^zewd("config","routinePath","gtm")=x
 ;
install3 ; 
 s default=$g(^zewd("config","jsScriptPath","gtm","outputPath"))
 i default="" s default="/var/www/resources/"
 w !,"Javascript and CSS File Output Path ("_default_"): " r x
 i $zb=$c(27) w ! g install2
 i x="" s x=default w x
 i $e(x,$l(x))'="/" s x=x_"/"
 s ^zewd("config","jsScriptPath","gtm","outputPath")=x
 ;
install4 ; 
 s default=$g(^zewd("config","jsScriptPath","gtm","path"))
 i default="" s default="/resources/"
 w !,"Javascript and CSS File URL Path ("_default_"): " r x
 i $zb=$c(27) w ! g install3
 i x="" s x=default w x
 i $e(x,$l(x))'="/" s x=x_"/"
 s ^zewd("config","jsScriptPath","gtm","path")=x
 ;
 s ^zewd("config","backEndTechnology")="m"
 i '$d(^zewd("config","defaultFormat"))  s ^zewd("config","defaultFormat")="pretty"
 s ^zewd("config","defaultTechnology")="gtm"
 s ^zewd("config","frontEndTechnology")="gtm"
 i '$d(^zewd("config","jsScriptPath","gtm","mode")) s ^zewd("config","jsScriptPath","gtm","mode")="fixed"
 s ^zewd("config","sessionDatabase")="gtm"
 w !!,$$version^%zewdAPI()_" is configured and ready for use",!!
 QUIT
 ;
leaveAsM	;
 ;;_zewdCompiler11.m
 ;;_zewdCompiler12.m
 ;;_zewdCompiler14.m
 ;;_zewdCompiler15.m
 ;;_zewdCompiler17.m
 ;;_zewdCompiler18.m
 ;;_zewdCompiler21.m
 ;;_zewdCompiler2.m
 ;;_zewdCompiler9.m
 ;;_zewdDemo.m
 ;;_zewdDocumentation1.m
 ;;_zewdDocumentation2.m
 ;;_zewdDocumentation3.m
 ;;_zewdDocumentation4.m
 ;;_zewdEJSCData.m
 ;;_zewdExtJSCode.m
 ;;_zewdExtJSData.m
 ;;_zewdExtJSDat2.m
 ;;_zewdExtJSData3.m
 ;;_zewdGTM.m
 ;;_zewdGTMRuntime.m
 ;;_zewdHTTP.m
 ;;_zewdLAMP1.m
 ;;_zewdMgr.m
 ;;_zewdMgr2.m
 ;;_zewdMgr3.m
 ;;_zewdMgrAjax.m
 ;;_zewdMgrAjax2.m
 ;;_zewdSlideshow.m
 ;;_zewdYUI1.m
 ;;_zewdYUI2.m
 ;;_zewdvaMgr.m
 ;;***END***
