ZMGWSIS ; Service Integration - GT.M call-in (doesn't like '%' routines)
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
A0 D VERS^%ZMGWSIS
 Q
 ;
IFC(CTX,REQUEST,null1,null2,null3,null4,null5)
 Q $$IFC^%ZMGWSIS(CTX,REQUEST,null1,null2,null3,null4,null5)
 ;
