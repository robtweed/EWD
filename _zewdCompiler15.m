%zewdCompiler15	; Enterprise Web Developer Compiler
 ;
 ; Product: Enterprise Web Developer (Build 857)
 ; Build Date: Sat, 05 Mar 2011 20:56:50
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
tagDefinitions ;
	;;ewd:ajaxOnload~~0~ajaxOnload^%zewdCompiler8
	;;ewd:cspscript~~0~cspscript^%zewdCompiler20
	;;ewd:comboPlus~~0~comboPlus^%zewdCompiler20
	;;ewd:comment~dummy~0~comment^%zewdCompiler4
	;;ewd:else~dummy~1~else^%zewdCompiler4
	;;ewd:elseif~firstValue,operation,secondValue~1~elseif^%zewdCompiler4
	;;ewd:eval~~0~eval^%zewdCompiler19
	;;ewd:evalStream~~0~evalStream^%zewdCompiler19
	;;ewd:execute~method,type,return~1~execute^%zewdCompiler4
	;;ewd:expandPage~page,return~1~expandPage^%zewdCompiler4
	;;ewd:for~from,to,increment,counter~0~for^%zewdCompiler4
	;;ewd:foreach~sessionName,index,return,subscriptList,startValue,endValue~0~forEach^%zewdCompiler19
	;;ewd:getArrayValue~arrayName,index,return~1~getArrayValue^%zewdCompiler4
	;;ewd:getPiece~return,data,asciiDelimiter,pieceNumber~1~getPiece^%zewdCompiler4
	;;ewd:getProperty~~1~getProperty^%zewdCompiler7
	;;ewd:getSessionArrayValue~sessionName,index,return~1~getSessionArrayValue^%zewdCompiler4
	;;ewd:getSessionValue~sessionName,return~1~getSessionValue^%zewdCompiler4
	;;ewd:help~~0~help^%zewdCompiler16
	;;ewd:helpPanel~~0~helpPanel^%zewdCompiler16
	;;ewd:if~firstValue,operation,secondValue~0~if^%zewdCompiler4
	;;ewd:ifArrayExists~arrayName~0~ifArrayExists^%zewdCompiler13
	;;ewd:ifBrowser~~0~ifBrowser^%zewdCompiler16
	;;ewd:ifContains~input,substring~0~ifContains^%zewdCompiler4
	;;ewd:ifSessionArrayExists~sessionName~0~ifSessionArrayExists^%zewdCompiler4
	;;ewd:ifSessionNameExists~sessionName~0~ifSessionNameExists^%zewdCompiler4
	;;ewd:image~~0~image^%zewdCompiler16
	;;ewd:include~~0~include^%zewdCompiler7
	;;ewd:javascript~dummy~0~javaScript^%zewdCompiler4
	;;ewd:js~~0~js^%zewdCompiler20
	;;ewd:jsConstructor~~0~jsConstructor^%zewdCompiler20
	;;ewd:jsPage~~0~jsPage^%zewdCompiler20
	;;ewd:jsFunction~~0~jsFunction^%zewdCompiler20
	;;ewd:jsSection~~0~jsSection^%zewdCompiler20
	;;ewd:jsSet~~0~jsSet^%zewdCompiler20
	;;ewd:jsLine~~0~jsSection^%zewdCompiler20
	;;ewd:jsMethod~~0~jsMethod^%zewdCompiler20
	;;ewd:incrementCounter~~1~incrementCounter^%zewdCompiler19
	;;ewd:initialiseArray~arrayName~1~initialiseArray^%zewdCompiler4
	;;ewd:instantiate~name,type,size~1~instantiate^%zewdCompiler4~
	;;ewd:main~~0~main^%zewdCompiler24
	;;ewd:mainTabMenu~~0~mainTabMenu^%zewdCompiler16
	;;ewd:mergeToJSObject~~1~mergeToJSObject^%zewdCompiler16
	;;ewd:modulo~return,data,modulus~1~modulo^%zewdCompiler16
	;;ewd:movetag~~0~movetag^%zewdCompiler7
	;;ewd:replace~input,fromString,toString,return~1~replace^%zewdCompiler4
	;;ewd:responseHeader~name,value,suppress~1~responseHeader^%zewdCompiler4
	;;ewd:schemaForm~schemaName,instanceName~0~schemaForm^%zewdCompiler4~
	;;ewd:schemaViewInstance~instanceName,suppressNull,suppressInvisible~0~schemaViewInstance^%zewdCompiler23~
	;;ewd:script~~0~script^%zewdCompiler19
	;;ewd:set~return,value,operand,firstValue,secondValue~1~set^%zewdCompiler4
	;;ewd:setArrayValue~arrayName,index,value~1~setArrayValue^%zewdCompiler4
	;;ewd:slideshow~~0~slideshow^%zewdSlideshow
	;;ewd:spinner~~1~spinner^%zewdCompiler13
	;;ewd:subTabMenu~~0~subTabMenu^%zewdCompiler16
	;;ewd:svg~height,width,page~1~svg^%zewdCompiler4
	;;ewd:svgDocument~~0~svgDocument^%zewdCompiler20
	;;ewd:svgPage~method~1~svgPage^%zewdCompiler4
	;;textarea~name~0~textarea^%zewdCompiler4
	;;ewd:tabMenuOption~~1~tabMenuOption^%zewdCompiler13
	;;ewd:text~~0~text^%zewdCompiler20
	;;ewd:trace~text~1~trace^%zewdCompiler4
	;;ewd:url~~1~url^%zewdCompiler13
	;;ewd:xhtml~~0~xhtml^%zewdCompiler13
	;;ewd:zexecute~method,type,return~1~execute^%zewdCompiler4
	;;ewd:zResponseHeader~name,value,suppress~1~responseHeader^%zewdCompiler4
	;;ewd:zzjs~~0~zzjs^%zewdCompiler20
	;;iwd:bottomtabbar~~0~bottomTabBar^%zewdiwd
	;;iwd:field~~0~field^%zewdiwd
	;;iwd:footer~~0~footer^%zewdiwd
	;;iwd:form~~0~form^%zewdiwd
	;;iwd:formfield~~0~formField^%zewdiwd
	;;iwd:formpanel~~0~formPanel^%zewdiwd
	;;iwd:graytitle~~0~graytitle^%zewdiwd
	;;iwd:header~~0~header^%zewdiwd
	;;iwd:main~~0~main^%zewdiwd
	;;iwd:menuitem~~0~menuItem^%zewdiwd
	;;iwd:menupanel~~0~menuPanel^%zewdiwd
	;;iwd:navbutton~~0~navButton^%zewdiwd
	;;iwd:pageitem~~0~pageItem^%zewdiwd
	;;iwd:redirect~~0~redirect^%zewdiwd
	;;iwd:tablepanel~~0~tablePanel^%zewdiwd
	;;iwd:tabpanel~~0~tabPanel^%zewdiwd
	;;iwd:textpanel~~0~pageItem^%zewdiwd
	;;iwd:title~~0~title^%zewdiwd
	;;iwd:toolbar~~0~toolbar^%zewdiwd
	;;iwd:toolbarbutton~~0~toolbarbutton^%zewdiwd
	;;st:card~~0~card^%zewdST
	;;st:carousel~~0~panel^%zewdST
	;;st:script~~0~script^%zewdST2
	;;st:class~~0~stclass^%zewdST
	;;st:container~~0~container^%zewdST2
	;;st:form~~0~form^%zewdST
	;;st:formpanel~~0~panel^%zewdST
	;;st:js~~0~js^%zewdST
	;;st:json~~0~json^%zewdST2
	;;st:list~~0~list^%zewdST2
	;;st:loggedinview~~0~loggedInView^%zewdST
	;;st:navigationmenu~~0~navigationMenu^%zewdST
	;;st:pageitem~~0~pageItem^%zewdST2
	;;st:panel~~0~panel^%zewdST
	;;st:qrcode~~0~qrCode^%zewdST2
	;;st:sessionlist~~0~sessionList^%zewdST2
	;;st:tabpanel~~0~panel^%zewdST
	;;st:touchgrid~~0~touchGrid^%zewdST2
	;;st:uuimenu~~0~uuiMenu^%zewdST
	;;st:universalui~~0~uui^%zewdST
	;;st:uui~~0~uui^%zewdST
	;;***END***
	;;
	;;yui:config~~0~config^%zewdYUI1
	;;yui:linechart~~0~lineChart^%zewdYUI1
	;;yui:slider~~0~slider^%zewdYUI1
	;;
impliedCloseTags ;
 ;;!--
 ;;br
 ;;hr
 ;;img
 ;;input
 ;;frame
 ;;link
 ;;meta
 ;;csp:else
 ;;csp:elseif
 ;;csp:class
 ;;csp:query
 ;;csp:include
 ;;wld:focus
 ;;ewd:config
 ;;ewd:refresh
 ;;ewd:dynamicmenu
 ;;***END***
 ;;
