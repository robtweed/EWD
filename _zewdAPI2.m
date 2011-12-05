%zewdAPI2 ; Enterprise Web Developer run-time functions and user APIs
 ;
 ; Product: Enterprise Web Developer (Build 892)
 ; Build Date: Mon, 05 Dec 2011 16:18:58
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
getTmpSessionValue(name,sessid)
 ;
 ; Note: this is WebLink-specific, called from <?= #tmp.xxx ?>
 ;
 n %zt,return,value
 ;
 s name=$$stripSpaces^%zewdAPI(name)
 i $g(name)="" QUIT ""
 i $g(sessid)="" QUIT ""
 i name["." d  QUIT value
 . n np,obj,prop
 . i name["_" s name=$p(name,"_",1)_"."_$p(name,"_",2,200)
 . s np=$l(name,".")
 . s obj=$p(name,".",1,np-1)
 . s prop=$p(name,".",np)
 . s value=$$getTmpSessionObject(obj,prop,sessid)
 s value=$g(sessionArray(name))
 QUIT value
 ;
getTmpSessionObject(objectName,propertyName,sessid)
    ;
    ; Note: this is WebLink-specific, called from <?= #tmp.xxx ?>
    ;
    n comma,i,np,p,value,x
    ;
    i $g(sessid)="" QUIT ""
    s value=""
    s np=$l(objectName,".")
    i objectName["." s objectName=$p(objectName,".",1)_"_"_$p(objectName,".",2,2000)
    i np=1 QUIT $g(sessionArray((objectName_"_"_propertyName)))
    ;
    f i=1:1:np-1 s p(i)=$p(objectName,".",i)
    s x="s value=$g(sessionArray(",comma=""
    f i=1:1:np-1 s x=x_comma_""""_p(i)_"""",comma=","
    s x=x_","""_propertyName_"""))"
    x x
    QUIT value
    ;
 ;
 ; Output encoding functions to prevent XSS attacks
 ;
jsOutputEncode(string,max)
 ;
 n stop,str
 ;
 s max=$g(max)
 i max="" s max=10
 s stop=0
 f i=1:1:max d  q:stop
 . s str=$$jsDecode(string)
 . i str=string s stop=1
 . s string=str
 ;
 QUIT $$jsEncode(string)
 ;
jsEncode(string)
 ;
 ; Output encode untrusted value for use within Javascript
 ;
 n a,buff,c,encode,i
 s buff=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . s a=$a(c)
 . s encode=1
 . i a=32 s encode=0 ; space
 . i a>47,a<58 s encode=0 ; number
 . i a>63,a<91 s encode=0 ; upper case
 . i a>96,a<123 s encode=0 ; lower case
 . i 'encode s buff=buff_c q
 . ;
 . s buff=buff_"\x"_$$hexEncode(a)
 s buff=$$replaceAll^%zewdAPI(buff,"\x5Cn","\n")
 s buff=$$replaceAll^%zewdAPI(buff,"\x5Cr","\r")
 QUIT buff
 ;
hexEncode(number)
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
hexDecode(hex)
 QUIT $$hexToDecimal^%zewdGTMRuntime(hex)
 ;
jsDecode(string)
 ;
 n a,c,c1,c12,c2,np,pos
 ;
 s pos=$f(string,"\x")
 f  q:pos=0  d
 . s pos=$f(string,"\x")
 . q:pos=0
 . s np=$l(string,"\x")+2
 . s c12=$e(string,pos,pos+1)
 . i $tr(c12,"0123456789ABCDEFabcdef","")'="" d
 . . ; \x wasn't followed by 2 hex chars: temporarily escape out \x
 . . s string=$p(string,"\x",1)_$c(1)_$p(string,"\x",2,np)
 . e  d
 . . s c1=$e(c12,1)
 . . s c2=$e(c12,2)
 . . s a=($$hexDecode(c1)*16)+$$hexDecode(c2)
 . . s c=$c(a)
 . . s string=$p(string,"\x",1)_c_$e(string,pos+2,$l(string))
 s string=$$REPLALL^%wlduta(string,$c(1),"\x")
 QUIT string
 ;
htmlOutputEncode(string,max)
 ;
 n stop,str
 ;
 s max=$g(max)
 i max="" s max=10
 s stop=0
 f i=1:1:max d  q:stop
 . s str=$$zcvt^%zewdAPI(string,"I","HTML")
 . i str=string s stop=1
 . s string=str
 ;
 QUIT $$zcvt^%zewdAPI(string,"O","HTML")
 ;
urlOutputEncode(string,max)
 ;
 n stop,str
 ;
 s max=$g(max)
 i max="" s max=10
 s stop=0
 f i=1:1:max d  q:stop
 . s str=$$urlEscape^%zewdGTMLRuntime(str)
 . i str=string s stop=1
 . s string=str
 ;
 QUIT $$urlUnescape^%zewdGTMLRuntime(string)
 ;
test()
 n ver
 s ver=$$version^%zewdAPI()
 s ver="<script>alert('"_ver_"')</script>"
 QUIT ver
 ;
getNextSessionName(name,sessid)
 ;
 QUIT $o(^%zewdSession("session",sessid,name))
 ;
getSessionNames(arrayOfNames,sessid)
 ;
 n name
 ;
 k arrayOfNames
 s name=""
 f  s name=$$getNextSessionName(name,sessid) q:name=""  d
 . s arrayOfNames(name)=""
 QUIT
 ;
