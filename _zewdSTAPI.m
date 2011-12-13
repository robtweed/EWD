%zewdSTAPI ; Sencha Touch User APIs
 ;
 ; Product: Enterprise Web Developer (Build 893)
 ; Build Date: Tue, 13 Dec 2011 09:45:38
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
saveListToSession(list,sessionName,sessid)
 QUIT:$g(sessionName)=""
 d deleteFromSession^%zewdAPI(sessionName,sessid)
 d mergeArrayToSession^%zewdAPI(.list,sessionName,sessid)
 ;d setSessionValue^%zewdAPI(sessionName,$$arrayToJSON^%zewdJSON("list"),sessid)
 QUIT
 ;
setSessionValue(sessionName,value,sessid)
 d setSessionValue^%zewdAPI(sessionName,value,sessid)
 QUIT ""
 ;
setDateValue(sessionName,month,day,year,sessid)
 d setSessionValue^%zewdAPI(sessionName_".day",day,sessid)
 d setSessionValue^%zewdAPI(sessionName_".month",month,sessid)
 d setSessionValue^%zewdAPI(sessionName_".year",year,sessid)
 QUIT
 ;
