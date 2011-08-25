%zewdYUIConf ; YUI Custom Tag configuration functions
 ;
 ; Product: Enterprise Web Developer (Build 881)
 ; Build Date: Thu, 25 Aug 2011 12:47:46
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
 n path
 ;
 i $g(technology)'="" d
 . s path=$g(^zewd("config","jsScriptPath",technology,"path"))
 . i $e(path,$l(path))'="/" s path=path_"/"
 e  d
 . s path="/"
 ;
 s ^%zewd("customTag","yui:datefield")="DateField^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:datefield","tagNotes",0)=0
 s ^%zewd("customTag","yui:datatablebasic")="DataTable^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:datatablebasic","tagNotes",0)=0
 s ^%zewd("customTag","yui:datatable")="DataTable^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:datatable","tagNotes",0)=0
 s ^%zewd("customTag","yui:dialog")="Dialog^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:dialog","tagNotes",0)=0
 s ^%zewd("customTag","yui:panel")="Dialog^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:panel","tagNotes",0)=0
 s ^%zewd("customTag","yui:menubar")="MenuBar^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:menubar","tagNotes",0)=0
 s ^%zewd("customTag","yui:tabview")="TabView^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:tabview","tagNotes",0)=0
 s ^%zewd("customTag","yui:treeview")="TreeView^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:treeview","tagNotes",0)=0
 s ^%zewd("customTag","yui:submit")="Submit^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:submit","tagNotes",0)=0
 s ^%zewd("customTag","yui:displaytable")="DisplayTable^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:displaytable","tagNotes",0)=0
 s ^%zewd("customTag","yui:button")="Button^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:button","tagNotes",0)=0
 s ^%zewd("customTag","yui:menu")="Menu^%zewdYUI"_$c(1)_"0"_$c(1,1,1)_"ewd"
 s ^%zewd("customTag","yui:menu","tagNotes",0)=0
 ;
 i '$d(^zewd("autoload","*","sessionValue","yui.resourceLoader")) d
 . s ^zewd("autoload","*","sessionValue","yui.resourceLoader")="ewdYUIResources.js"
 . s ^zewd("autoload","*","sessionValue","yui.resourceLoaderPath")=path
 . s ^zewd("autoload","*","sessionValue","yui.resourcePath")="/yui-2.6.0/"
 ;
 zsystem "sudo mkdir /var/www/assets"
 zsystem "sudo mkdir /var/www/assets/skins"
 zsystem "sudo mkdir /var/www/assets/skins/sam"
 zsystem "sudo cp /var/www/yui-2.6.0/build/assets/skins/sam/sprite.png /var/www/assets/skins/sam/sprite.png"
 QUIT
 ;
setYUIVersion(version)
 s ^zewd("autoload","*","sessionValue","yui.resourcePath")="/yui-"_version_"/"
 QUIT
 ;
installApplication(appName)
 n file,lcAppName
 ;
 zsystem "sudo mkdir /var/www/ewd"
 s lcAppName=$$zcvt^%zewdAPI(appName,"l")
 zsystem "sudo mkdir /var/www/ewd/"_lcAppName
 f file="menubaritem_submenuindicator","menubaritem_submenuindicator_disabled","menuitem_checkbox","menuitem_checkbox_disabled","menuitem_submenuindicator","menuitem_submenuindicator_disabled" d
 . zsystem "sudo cp /var/www/yui-2.6.0/build/menu/assets/skins/sam/"_file_".png /var/www/ewd/"_lcAppName_"/"_file_".png"
 f file="dt-arrow-dn","dt-arrow-up" d
 . zsystem "sudo cp /var/www/yui-2.6.0/build/datatable/assets/skins/sam/"_file_".png /var/www/ewd/"_lcAppName_"/"_file_".png"
 f file="treeview-sprite.gif" d
 . zsystem "sudo cp /var/www/yui-2.6.0/build/treeview/assets/skins/sam/"_file_" /var/www/ewd/"_lcAppName_"/"_file
 ;
 s ^zewd("config","YUI","app",appName)=""
 ;
 QUIT
 ;
reset
 k ^zewd("config","YUI")
 k ^zewd("autoload","*","sessionValue","yui.resourceLoader")
 k ^zewd("autoload","*","sessionValue","yui.resourceLoaderPath")
 k ^zewd("autoload","*","sessionValue","yui.resourcePath")
 k ^%zewd("version")
 QUIT
 ;
