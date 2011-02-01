%zewdMgr3	; Enterprise Web Developer Manager Functions
 ;
 ; Product: Enterprise Web Developer (Build 841)
 ; Build Date: Tue, 01 Feb 2011 13:50:15
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
configPrepage(sessid)
 ;
 n configTechnology,defaultFormat,defaultTech,homePage,multiLingual
 n path,traceMode,useRootURL
 ;
 s path=$$getApplicationRootPath^%zewdCompiler()
 s defaultTech=$$getDefaultTechnology^%zewdCompiler()
 s multiLingual=$$getDefaultMultiLingual^%zewdCompiler()
 s useRootURL=$$getUseRootURL^%zewdCompiler()
 s defaultFormat=$$getDefaultFormat^%zewdCompiler()
 s homePage=$$getHomePage^%zewdCompiler()
 i homePage="" s homePage=$$getSessionValue^%zewdAPI("ewd_homePage",sessid)
 s traceMode=$$getTraceMode^%zewdAPI()
 d addToSession^%zewdAPI("traceMode",sessid)
 d addToSession^%zewdAPI("path",sessid)
 d addToSession^%zewdAPI("defaultTech",sessid)
 d addToSession^%zewdAPI("defaultFormat",sessid)
 d addToSession^%zewdAPI("useRootURL",sessid)
 d addToSession^%zewdAPI("multiLingual",sessid)
 d addToSession^%zewdAPI("homePage",sessid)
 d clearList^%zewdAPI("configTechnology",sessid)
 d appendToList^%zewdAPI("configTechnology","CSP","csp",sessid)
 d appendToList^%zewdAPI("configTechnology","PHP","php",sessid)
 d appendToList^%zewdAPI("configTechnology","Java Server Pages","jsp",sessid)
 ;d appendToList^%zewdAPI("configTechnology","VB.Net","vb.net",sessid)
 s configTechnology=$$getSessionValue^%zewdAPI("configTechnology",sessid)
 i configTechnology="" d setSessionValue^%zewdAPI("configTechnology","csp",sessid)
 QUIT ""
 ;
clearTrace(dummy) ;
 k ^%zewdTrace
 QUIT "alert('The trace global is now empty')"
 ;
displaySessionDetails(sessid)
 ;
 n session,sessionNo,lineNo,ref,data,%p1,line
 ;
 s sessionNo=$$getSessionValue^%zewdAPI("sessionNo",sessid)
 ;
 k ^%work($j)
 i $$isCSP^%zewdAPI(sessid) d
 . i $e(sessionNo,1,3)="csp" s sessionNo=$e(sessionNo,5,$l(sessionNo))
 . m ^%work($j)=^%cspSession(sessionNo,0)
 . ;d TRACE^%wld("$j="_$j)
 e  d
 . m ^%work($j)=^%zewdSession("session",sessionNo)
 ;
 s ref="^%work($j,"""")"
 s lineNo=0
 f  s ref=$q(@ref) q:ref'[("^%work("_$j)  d
 . s data=@ref
 . s %p1=$p(ref,"^%work("_$j_",",2)
 . s %p1=$e(%p1,1,$l(%p1)-1)
 . s data=$tr(data,$c(1),"|")
 . i data="" s data="&nbsp;"
 . w "<tr>"
 . w "<td>"_%p1_"</td>"
 . w "<td>"_data_"</td>"
 . w "</tr>"_$c(13,10)
 ;
 k ^%work($j)
 QUIT
 ;
fetchFile(sessid)
 ;
 n app,delim,file,i,io,method,nlines,os,path,root,text
 ;
 s io=$io
 s file=$$getRequestValue^%zewdAPI("file",sessid)
 s method=$$getRequestValue^%zewdAPI("method",sessid)
 i file="",method="" QUIT "Invalid request"
 i file="" s file="ewdTest.xml"
 s app=$$getRequestValue^%zewdAPI("fromApp",sessid)
 i app="" s app="tutorial"
 d copyRequestValueToSession^%zewdAPI("file",sessid)
 s root=$$getApplicationRootPath^%zewdAPI()
 s os=$$os^%zewdHTMLParser()
 s delim="/" i os="windows" s delim="\"
 i $e(root,$l(root))'=delim s root=root_delim
 s path=root_app_delim_file
 i method'="" g fetchClass
 s nlines=$$importFile^%zewdHTMLParser(path)
 i nlines=0 QUIT ""
 d clearTextArea^%zewdAPI("pageContent",sessid)
 f i=1:1:nlines d
 . s text=$g(^CacheTempEWD($j,i))
 . i os="windows" s text=$$replaceAll^%zewdAPI(text,"<","&lt;")
 . s text(i)=text
 d createTextArea^%zewdAPI("pageContent",.text,sessid)
 u io
 k ^CacheTempEWD($j)
 QUIT ""
 ;
fetchClass
 ;
 n cOID,docName,impOID,name,nOID,nodeOID,ok,text
 ;
 s docName="ewdClass"
 s ok=$$openDOM^%eDOMAPI()
 s ok=$$parseXMLFile^%eXMLAPI(path,0,1,docName)
 s nOID=$$getElementsArrayByTagName^%eDOMAPI("Method",docName,,.tags)
 s nodeOID="",stop=0
 f  s nodeOID=$o(tags(nodeOID)) q:nodeOID=""  d  q:stop
 . s name=$$getAttribute^%eDOMAPI("name",nodeOID)
 . i method=name s stop=1
 s impOID=$$getFirstElementByTagName^%eDOMAPI("Implementation",,nodeOID)
 s cOID=$$getFirstChild^%eDOMAPI(impOID)
 s text(1)="ClassMethod "_method_"(sessid As %String) As %String"
 s text(2)="{" 
 s text(3)=$$getData^%eDOMAPI(cOID)
 s text(4)="}"
 d clearTextArea^%zewdAPI("pageContent",sessid)
 d createTextArea^%zewdAPI("pageContent",.text,sessid)
 d setSessionValue^%zewdAPI("file","method "_method,sessid)
 s ok=$$removeDocument^%eDOMAPI(docName)
 s ok=$$closeDOM^%eDOMAPI()
 QUIT ""
