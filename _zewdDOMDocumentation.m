%zewdDOMDocumentation ;
 ;
 ; Product: Enterprise Web Developer (Build 867)
 ; Build Date: Thu, 16 Jun 2011 18:10:22
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
install
 ;
 n childNo,childOID,children,docName,file,i,j,mandatory,methodName
 n name,no,nodeNo,nodeOID,nodes,ok,paramNo,paramOID,params,tagName,text
 ;
 f i=1:1 s text=$t(DOM1+i^%zewdDocumentation1) q:text["***END***"  d
 . s line(i)=$p(text,";;",2,200)
 s j=i-1
 f i=1:1 s text=$t(DOM2+i^%zewdDocumentation2) q:text["***END***"  d
 . s j=j+1
 . s line(j)=$p(text,";;",2,200)
 s file="zewdTemp"_$tr($h,",","")
 s ok=$$openNewFile^%zewdAPI(file)
 u file
 f i=1:1:j-1 w line(i),!
 c file
 s docName="zewdDocumentation"
 s ok=$$parseFile^%zewdHTMLParser(file,docName)
 s ok=$$deleteFile^%zewdAPI(file)
 k line
 k ^%zewd("documentation","DOM")
 s ok=$$select^%zewdXPath("//method",docName,.nodes)
 s nodeNo=""
 f  s nodeNo=$o(nodes(nodeNo)) q:nodeNo=""  d
 . s nodeOID=nodes(nodeNo)
 . s methodName=$$getAttribute^%zewdDOM("id",nodeOID)
 . d getChildrenInOrder^%zewdDOM(nodeOID,.children)
 . s childNo=""
 . f  s childNo=$o(children(childNo)) q:childNo=""  d
 . . s childOID=children(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . s text=$$getElementText^%zewdDOM(childOID,.textarr)
 . . i tagName'="parameters" d  q
 . . . s ^%zewd("documentation","DOM","method",methodName,tagName)=text
 . . d getChildrenInOrder^%zewdDOM(childOID,.params)
 . . s paramNo=""
 . . f  s paramNo=$o(params(paramNo)) q:paramNo=""  d
 . . . s paramOID=params(paramNo)
 . . . s no=$$getAttribute^%zewdDOM("no",paramOID)
 . . . s name=$$getAttribute^%zewdDOM("name",paramOID)
 . . . s mandatory=$$getAttribute^%zewdDOM("mandatory",paramOID)
 . . . s text=$$getElementText^%zewdDOM(paramOID,.textarr)
 . . . s ^%zewd("documentation","DOM","method",methodName,"params",no,"name")=name
 . . . i mandatory'="" s ^%zewd("documentation","DOM","method",methodName,"params",no,"mandatory")=1
 . . . s ^%zewd("documentation","DOM","method",methodName,"params",no,"desc")=text
 i $$removeDocument^%zewdDOM(docName)
 QUIT
 ;
 ; 
process ;
 s file="d:\cachesys\mgr\%zewdDOMDocumentation.txt"
 c file
 s ok=$$openFile^%zewdAPI(file)
 u file
 s $zt="fin"
 f i=1:1 r line(i)
fin ;
 c file
 s $zt=""
 s max=i-1
 f i=1:1:max d
 . s line=line(i)
 . s line=$$stripSpaces^%zewdAPI(line)
 . i i>1,$g(line(i-1))[" ;;</method>",line(i)="" k line(i) q
 . s line(i)=" ;;"_line
 s file2="d:\cachesys\mgr\%zewdDOMDocumentation2.txt"
 s ok=$$openNewFile^%zewdAPI(file2)
 u file2
 s i=""
 f  s i=$o(line(i)) q:i=""  d
 . w line(i),!
 c file2
 QUIT
 ;
