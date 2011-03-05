%zewdAPI2 ; Enterprise Web Developer run-time functions and user APIs
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
