%zewdMDWSMap ; openMDWS Method Registration details
 ;
 ; Product: Enterprise Web Developer (Build 945)
 ; Build Date: Sat, 24 Nov 2012 10:49:50
 ; 
 ; ----------------------------------------------------------------------------
 ; | Enterprise Web Developer for GT.M and m_apache                           |
 ; | Copyright (c) 2004-12 M/Gateway Developments Ltd,                        |
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
 ; do install^%zewdMDWS to register methods
 ;
mappings ;
 ;;{facade:"EmrSvc",operation:"connect",coreMethod:"connect^%zewdVistARPC",MDWSWrapper:"connect^%zewdMDWS"}
 ;;{facade:"EmrSvc",operation:"login",coreMethod:"login^%zewdVistARPC",MDWSWrapper:"login^%zewdMDWSSvc1"}
 ;;{facade:"EmrSvc",operation:"match",coreMethod:"match^schedulerRPC",MDWSWrapper:"match^schedulerSvc"}
 ;;{facade:"SchedulingSvc",operation:"connect",coreMethod:"connect^%zewdVistARPC",MDWSWrapper:"connect^%zewdMDWS"}
 ;;{facade:"SchedulingSvc",operation:"login",coreMethod:"login^%zewdVistARPC",MDWSWrapper:"login^%zewdMDWSSvc1"}
 ;;{facade:"SchedulingSvc",operation:"getClinics",coreMethod:"getClinics^%zewdVistARPC",MDWSWrapper:"getClinics^%zewdMDWSSvc1"}
 ;;{facade:"SchedulingSvc",operation:"getPatientsByClinic",coreMethod:"getPatientsByClinic^%zewdVistARPC",MDWSWrapper:"getPatientsByClinic^%zewdMDWSSvc1"}
 ;;***END***
 ;
