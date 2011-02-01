%zewdTranslate	; Auto translation Utility using BabelFish
 ;
 ; Product: Enterprise Web Developer (Build 841)
 ; Build Date: Tue, 01 Feb 2011 13:50:16
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
	QUIT
	;
google(phrase,from,to)
	;
	n amp,httprequest,len,location,n,name,nvp,payload,server,str,stream,translation,url
	;
	i $g(from)="" s from="en"
	i $g(to)="" s to="es"
	s url="http://translate.google.com/translate_a/t"
	s nvp("client")="t"
	s nvp("text")=phrase
	s nvp("sl")=from
	s nvp("tl")=to
	s nvp("swap")=1
	s str="",n="",amp=""
	f  s n=$o(nvp(n)) q:n=""  d
	. s str=str_amp_n_"="_nvp(n),amp="&"
	s payload(1)=str
	s ok=$$httpPOST^%zewdGTM(url,.%html,.payload)
	i ok="" d
	QUIT ""
	;
formatText(text)
	n a,c,n,str
	s str=""
	f n=1:1:$l(text) d
	. s c=$e(translation,n)
	. s a=$a(c)
	. i a<32 q
	. i a>128 s c="&#"_a_";"
	. s str=str_c
	QUIT str
	;
translate(phrase,conv)
	;
	n amp,FailureReason,%html,n,nvp,ok,payload,str,translation,url
	;
	i $g(conv)="" s conv="en_es"
	s url="http://uk.babelfish.yahoo.com/translate_txt"
	s nvp("ei")="UTF-8"
	s nvp("doit")="done"
	s nvp("fr")="bf-home"
	s nvp("intl")=1
	s nvp("tt")="urltext"
	s nvp("trtext")=phrase
	s nvp("lp")=conv
	s nvp("btnTrTxt")="Translate"
	;
	s str="",n="",amp=""
	f  s n=$o(nvp(n)) q:n=""  d
	. s str=str_amp_n_"="_nvp(n),amp="&"
	s payload(1)=str
	s translation=""
	;s ok=$$POST^%wldhttp(url,,.payload,20,.cookie,userAgent,,,,,,,1)
	s ok=$$httpPOST^%zewdGTM(url,.%html,.payload)
	i ok="" d
	. n a,c,i,line,stop
	. s i="",stop=0
	. f  s i=$o(%html(i)) q:i=""  d  q:stop
	. . s line=$g(%html(i))
	. . i line["<div id=""result""" d
	. . . s stop=1
	. . . s translation=$p(line,">",3)
	. . . s translation=$p(translation,"</div",1)
	. . . s str=""
	. . . f n=1:1:$l(translation) d
	. . . . s c=$e(translation,n)
	. . . . s a=$a(c)
	. . . . i a<32 q
	. . . . i a>128 s c="&#"_a_";"
	. . . . s str=str_c
	. . . s translation=str
	;
	QUIT translation
	;
autoTranslateApp(appName,from,to)
	;
	n conv,defLanguage,ignore,indexType,page,text,textid,translation
	;
	s conv=from_"_"_to
	s appName=$$zcvt^%zewdAPI(appName,"l")
	s defLanguage=$$getDefaultLanguage^%zewdCompiler5(appName)
	s page=""
	f indexType="pageIndex","otherIndex" d
	. f  s page=$o(^ewdTranslation(indexType,appName,page)) q:page=""  d
	. . s textid=""
	. . f  s textid=$o(^ewdTranslation(indexType,appName,page,textid)) q:textid=""  d
	. . . w "."
	. . . q:$d(^ewdTranslation("textid",textid,to))
	. . . s text=$g(^ewdTranslation("textid",textid,defLanguage))
	. . . i text="" q
	. . . s texts=$e(text,1,200)
	. . . w texts
	. . . i $d(ignore(texts)) q
	. . . w "+" 
	. . . s translation=$$google(text,from,to)
	. . . ;s translation=$$translate(text,conv)
	. . . q:translation=""
	. . . i translation=text s ignore(texts)="" q
	. . . s ^ewdTranslation("textid",textid,to)=translation
	. . . d translateAllInstances(text,appName,to,translation)
	. . . w page_": "_text_" : "_translation,! ;h $r(30)
	QUIT
	;
autoTranslatePage(appName,page,from,to)
	;
	n conv,defLanguage,ignore,text,textid,translation
	;
	s conv=from_"_"_to
	s appName=$$zcvt^%zewdAPI($g(appName),"l")
	QUIT:appName=""
	s page=$$zcvt^%zewdAPI($g(page),"l")
	QUIT:page=""
	QUIT:'$d(^ewdTranslation("pageIndex",appName,page))
	s defLanguage=$$getDefaultLanguage^%zewdCompiler5(appName)
	s textid=""
	f  s textid=$o(^ewdTranslation("pageIndex",appName,page,textid)) q:textid=""  d
	. s text=$g(^ewdTranslation("textid",textid,defLanguage))
	. i text="" q
	. q:$d(^ewdTranslation("textid",textid,to))
	. s translation=$$translate(text,conv)
	. i translation'="" d
	. . s ^ewdTranslation("textid",textid,to)=translation
	. . d translateAllInstances(text,appName,to,translation)
	. w text_" : "_translation,! h $r(30)
	QUIT
	;
translateAllInstances(phrase,appName,toLanguage,translation)
	;
	n defLanguage,textid,textidList
	;
	s defLanguage=$$getDefaultLanguage^%zewdCompiler5(appName)
	d getMatchingText^%zewdCompiler5(phrase,defLanguage,.textidList)
	k ^rltList m ^rltList=textidList
	s textid=""
	f  s textid=$o(textidList(textid)) q:textid=""  d
	. q:$d(^ewdTranslation("textid",textid,toLanguage))
	. s ^ewdTranslation("textid",textid,toLanguage)=translation
	. d trace^%zewdAPI("updated "_textid_" in "_toLanguage_" to "_translation)
	QUIT
	;
convertText(lang)
	n a,c,n,str,text,textid
	s textid=""
	f  s textid=$o(^ewdTranslation("textid",textid)) q:textid=""  d
	. s text=$g(^ewdTranslation("textid",textid,lang))
	. i text="" q
	. s str=""
	. f n=1:1:$l(text) d
	. . s c=$e(text,n)
	. . s a=$a(c)
	. . i a<32 q
	. . i a>128 s c="&#"_a_";"
	. . s str=str_c
	. i str["&#"
	. s ^ewdTranslation("textid",textid,lang)=str
	QUIT
