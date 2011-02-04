%zewdYUIJS ; YUI Runtime Javascript file
 ;
 ; Product: Enterprise Web Developer (Build 844)
 ; Build Date: Fri, 04 Feb 2011 14:54:35
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
createJS(build)
 ;
 n dlim,filePath,io,line,lineNo,outputPath
 ;
 ; Create/replace ewdYUIResources
 ;
 s outputPath=$g(^zewd("config","jsScriptPath",technology,"outputPath"))
 s dlim=$$getDelim^%zewdAPI()
 i $e(outputPath,$l(outputPath))'=dlim s outputPath=outputPath_dlim
 s filePath=outputPath_"ewdYUIResources.js"
 s io=$io
 i '$$openNewFile^%zewdCompiler(filePath) QUIT
 u filePath
 f lineNo=1:1 s line=$t(ewdYUIResources+lineNo^%zewdYUIJS) q:line["***END***"  d
 . s line=$p(line,";;",2,255)
 . i line["<?= buildNo ?>" s line=$$replace^%zewdAPI(line,"<?= buildNo ?>",build)
 . w $$stripLeadingSpaces^%zewdAPI(line),!
 c filePath
 u io
 s ^zewd("config","YUI","buildNo")=build
 ;
 QUIT
 ;
ewdYUIResources ;
 ;;/*
 ;; YUI Resource Loader functions
 ;; Note: EWD.page.yuiResourcePath is defined during widget compilation.  It's value will be picked up
 ;; from ^zewd("autoload","*","yui.resourcePath")
 ;;*/
 ;;
 ;;EWD.yui = {
 ;;  widget:{
 ;;		Calendar: {
 ;;			Opener:{}
 ;;		}
 ;;   },
 ;;   widgetIndex: {},
 ;;   method :{},
 ;;   selectTag: {},
 ;;   build: <?= buildNo ?>,
 ;;   defaultPath: "/yui-2.6.0",
 ;;   resourceLoaded: {},
 ;;   resourceLoader: {
 ;;      DataTable: function() {
 ;;         var widgetName = "DataTableBasic" ;
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/datatable/assets/skins/sam/datatable.css","css") ;
 ;;            EWD.page.loadResource(path + "build/paginator/assets/skins/sam/paginator.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/connection/connection-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/json/json-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/dragdrop/dragdrop-min.js","js") ;
 ;;            if (EWD.utils.contains(path,"2.6.0")) {
 ;;              EWD.page.loadResource(path + "build/element/element-beta-min.js","js") ;
 ;;            }
 ;;            else {
 ;;              EWD.page.loadResource(path + "build/element/element-min.js","js") ;
 ;;            }
 ;;	           EWD.page.loadResource(path + "build/datasource/datasource-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/datatable/datatable-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/paginator/paginator-min.js","js") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;	     },
 ;;      TabView: function() {
 ;;         var widgetName = "TabView" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/tabview/assets/skins/sam/tabview.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/connection/connection-min.js","js") ;
 ;;            if (EWD.utils.contains(path,"2.6.0")) {
 ;;               EWD.page.loadResource(path + "build/element/element-beta-min.js","js") ;
 ;;            }
 ;;            else {
 ;;               EWD.page.loadResource(path + "build/element/element-min.js","js") ;
 ;;            }
 ;;            EWD.page.loadResource(path + "build/tabview/tabview-min.js","js") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      Dialog: function() {
 ;;         var widgetName = "Dialog" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/container/assets/skins/sam/container.css","css") ;
 ;;            EWD.page.loadResource(path + "build/button/assets/skins/sam/button.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/animation/animation-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/connection/connection-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/dragdrop/dragdrop-min.js","js") ;
 ;;            if (EWD.utils.contains(path,"2.6.0")) {
 ;;               EWD.page.loadResource(path + "build/element/element-beta-min.js","js") ;
 ;;            }
 ;;            else {
 ;;               EWD.page.loadResource(path + "build/element/element-min.js","js") ;
 ;;            }
 ;;            EWD.page.loadResource(path + "build/button/button-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/container/container-min.js","js") ;
 ;;            EWD.page.addStyle(".yui-skin-sam .yui-panel .bd { background-color:#ffffff; }") ;
 ;;            EWD.page.addStyle(".yui-skin-sam .yui-dialog .ft { background-color:#ffffff; }") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      Menu: function() {
 ;;	        var widgetName = "Menu" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/menu/assets/skins/sam/menu.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/container/container_core-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/menu/menu-min.js","js") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      MenuBar: function() {
 ;;         var widgetName = "MenuBar" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/reset-fonts-grids/reset-fonts-grids.css","css") ;
 ;;            EWD.page.loadResource(path + "build/menu/assets/skins/sam/menu.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/container/container_core.js","js") ;
 ;;            EWD.page.loadResource(path + "build/menu/menu.js","js") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      TreeView: function() {
 ;;         var widgetName = "TreeView" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/treeview/assets/skins/sam/treeview.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/treeview/treeview-min.js","js") ;
 ;;            EWD.yui.treeViewOptions = {} ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      DisplayTable: function() {
 ;;         var widgetName = "DisplayTable" ;
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/datatable/assets/skins/sam/datatable.css","css") ;
 ;;            EWD.page.addStyle(".yui-displaytable-header {border-color:#cbcbcb;border-style:none solid none none;border-with:medium 1px medium medium;border-right:solid 1px #000;font-size:10pt;font-weight:bold;margin:0;padding:4px 10px;background:#d8d8da url(/yui-2.6.0/build/assets/skins/sam/sprite.png) repeat-x scroll 0 0;}");
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      Calendar: function() {
 ;;         var widgetName = "Calendar" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;;            if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/container/assets/skins/sam/container.css","css") ;
 ;;            EWD.page.loadResource(path + "build/button/assets/skins/sam/button.css","css") ;
 ;;            EWD.page.loadResource(path + "build/calendar/assets/skins/sam/calendar.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            EWD.page.loadResource(path + "build/dragdrop/dragdrop-min.js","js") ;
 ;;            if (EWD.utils.contains(path,"2.6.0")) {
 ;;               EWD.page.loadResource(path + "build/element/element-beta-min.js","js") ;
 ;;            }
 ;;            else {
 ;;               EWD.page.loadResource(path + "build/element/element-min.js","js") ;
 ;;            }
 ;;            EWD.page.loadResource(path + "build/button/button-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/container/container-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/calendar/calendar-min.js","js") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      },
 ;;      Button: function() {
 ;;         var widgetName = "Button" ; 
 ;;         if (typeof(EWD.yui.resourceLoaded[widgetName]) == "undefined") {
 ;;            var path = EWD.yui.defaultPath ;
 ;; 		    if (typeof(EWD.page.yuiResourcePath) != "undefined") path = EWD.page.yuiResourcePath ;
 ;;            EWD.page.loadResource(path + "build/fonts/fonts-min.css","css") ;
 ;;            EWD.page.loadResource(path + "build/button/assets/skins/sam/button.css","css") ;
 ;;            EWD.page.loadResource(path + "build/menu/assets/skins/sam/menu.css","css") ;
 ;;            EWD.page.loadResource(path + "build/yahoo-dom-event/yahoo-dom-event.js","js") ;
 ;;            if (EWD.utils.contains(path,"2.6.0")) {
 ;;               EWD.page.loadResource(path + "build/element/element-beta-min.js","js") ;
 ;;            }
 ;;            else {
 ;;               EWD.page.loadResource(path + "build/element/element-min.js","js") ;
 ;;            }
 ;;            EWD.page.loadResource(path + "build/container/container_core-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/menu/menu-min.js","js") ;
 ;;            EWD.page.loadResource(path + "build/button/button-min.js","js") ;
 ;;            EWD.yui.resourceLoaded[widgetName] = "" ;
 ;;         }
 ;;      }
 ;;   }	  
 ;;};
 ;;EWD.ajax.destroyDJWidgetsWithin = function(targetId) {
 ;;    var xnode = document.getElementById(targetId) ;
 ;;    checkChildNodes(xnode) ;
 ;;    function checkChildNodes(xnode) {
 ;;       var xid=xnode.id ;
 ;;       var childList = xnode.childNodes;
 ;;       if (childList.length > 0) {
 ;;          for (var i=0;i<childList.length;i++) {
 ;;             checkChildNodes(childList[i]) ;
 ;;          }
 ;;       }
 ;;       if (xid) {
 ;;          if (EWD.yui.widgetIndex[xid]) {
 ;;             if (EWD.yui.widgetIndex[xid].tagId) {
 ;;                var ynode = document.getElementById(EWD.yui.widgetIndex[xid].tagId) ;
 ;;                checkChildNodes(ynode) ;				
 ;;             }
 ;;             var objectName=EWD.yui.widgetIndex[xid].widgetName;
 ;;             if (typeof(console) != 'undefined') console.log('removing ' + objectName) ;
 ;;             if (EWD.yui.widget[objectName].destroy) EWD.yui.widget[objectName].destroy();
 ;;             delete EWD.yui.widget[objectName];
 ;;             delete EWD.yui.widgetIndex[xid];
 ;;             if (typeof(console) != 'undefined') console.log(xid + ' deleted');
 ;;          }
 ;;       }
 ;;    }
 ;;};
 ;;EWD.yui.hideSelectTag = function(id) {
 ;;   if (document.getElementById(id)) {
 ;;      document.getElementById(id).style.visibility = 'hidden' ;
 ;;      EWD.yui.selectTag[id] = '' ;
 ;;   }
 ;;};
 ;;EWD.yui.resetSelectTag = function(id) {
 ;;   if (document.getElementById(id)) {
 ;;      document.getElementById(id).style.visibility = 'visible' ;
 ;;      delete EWD.yui.selectTag[id] ;
 ;;   }
 ;;};
 ;;EWD.yui.resetAllSelectTags = function() {
 ;;   if (EWD.yui.selectTag) {
 ;;      for (var id in EWD.yui.selectTag) {
 ;;         document.getElementById(id).style.visibility = "visible" ;
 ;;         delete EWD.yui.selectTag[id] ;
 ;;      }
 ;;   }
 ;;};
 ;;EWD.yui.calendarEventHandler = function(obj,inputFieldId) {
 ;;   var id = obj.id;
 ;;   EWD.yui.widget.Calendar.inputField = inputFieldId ;
 ;;   if (!document.getElementById('EWDYUICalendar')) {
 ;;      var divEl = document.createElement("div") ;
 ;;      var bodyEl = document.getElementsByTagName('body')[0];
 ;;      bodyEl.appendChild(divEl) ;
 ;;      divEl.id = "EWDYUICalendar" ;
 ;;   }
 ;;   if (!EWD.yui.widget.Calendar.Widget) {
 ;;      EWD.yui.widget.Calendar.Widget = new YAHOO.widget.Calendar("EWDYUICalendarContent","EWDYUICalendar",{title:'Select Date...',iframe:true,close:true,hide_blank_weeks:true});
 ;;      EWD.yui.widget.Calendar.Widget.zindex = EWD.utils.getHighestZIndex() + 1;
 ;;	     EWD.yui.widget.Calendar.Widget.render();
 ;;      EWD.yui.widget.Calendar.Widget.selectEvent.subscribe(function() {
 ;;         var inputFieldId = EWD.yui.widget.Calendar.inputField ;
 ;;         if (EWD.yui.widget.Calendar.Widget.getSelectedDates().length > 0) {
 ;;            var selDate = EWD.yui.widget.Calendar.Widget.getSelectedDates()[0];
 ;;            YAHOO.util.Dom.get(inputFieldId).value = (selDate.getMonth() + 1) + "/" + selDate.getDate() + "/" + selDate.getFullYear();
 ;;         }
 ;;         else {
 ;;            YAHOO.util.Dom.get(inputFieldId).value = "";
 ;;         }
 ;;         EWD.yui.widget.Calendar.Widget.hide();
 ;;      });
 ;;      YAHOO.util.Event.on(document, "click", function(e) {
 ;;         var el = YAHOO.util.Event.getTarget(e);
 ;;         if (typeof(EWD.yui.widget.Calendar.Opener[el.id]) != 'undefined') return ;
 ;;         var dialogEl = YAHOO.util.Dom.get('EWDYUICalendarContent');
 ;;         if (el != dialogEl && !YAHOO.util.Dom.isAncestor(dialogEl, el) && el != obj && !YAHOO.util.Dom.isAncestor(obj, el)) {
 ;;            EWD.yui.widget.Calendar.Widget.hide();
 ;;         }
 ;;      });
 ;;   }
 ;;   var seldate = YAHOO.util.Dom.get(inputFieldId).value ;
 ;;   if (seldate != '') {
 ;;      var m = EWD.utils.getPiece(seldate,"/",1);
 ;;      var d = EWD.utils.getPiece(seldate,"/",2);
 ;;      var y = EWD.utils.getPiece(seldate,"/",3);
 ;;   }
 ;;   else {
 ;;      var now = new Date() ;
 ;;      var d = now.getDate() ;
 ;;      var m = now.getMonth() + 1;
 ;;      var y = now.getFullYear();
 ;;   }
 ;;   var my = m + '/' + y;
 ;;   EWD.yui.widget.Calendar.Widget.cfg.setProperty ('pagedate', my, false);
 ;;   EWD.yui.widget.Calendar.Widget.cfg.setProperty ('selected', seldate, false);
 ;;   EWD.yui.widget.Calendar.Widget.render();
 ;;   var xy = YAHOO.util.Dom.getXY(obj);
 ;;   xy[0] += 20;
 ;;   xy[1] += 10;
 ;;   EWD.yui.widget.Calendar.Widget.show();
 ;;   YAHOO.util.Dom.setXY('EWDYUICalendar', xy, false);
 ;;   YAHOO.util.Dom.get('EWDYUICalendar').style.zIndex =  EWD.yui.widget.Calendar.Widget.zindex ;
 ;;};
 ;;EWD.yui.moveDialogToBody = function(dialogDivId) {
 ;;   var dialogEl = document.getElementById(dialogDivId);
 ;;   var parEl = dialogEl.parentNode;
 ;;   var dialogElx = parEl.removeChild(dialogEl);
 ;;   var bodyEl = document.getElementsByTagName('body')[0];
 ;;   bodyEl.appendChild(dialogElx) ;
 ;;};
 ;;EWD.utils.getHighestZIndex = function() {
 ;;   var allElems = document.getElementsByTagName?document.getElementsByTagName("*"):document.all;
 ;;   var maxZIndex = 0;
 ;;   for(var i=0;i<allElems.length;i++) {
 ;;      var elem = allElems[i];
 ;;      var cStyle = null;
 ;;      if (elem.currentStyle) {
 ;;         cStyle = elem.currentStyle;
 ;;      }
 ;;      else if (document.defaultView && document.defaultView.getComputedStyle) {
 ;;         cStyle = document.defaultView.getComputedStyle(elem,"");
 ;;      }
 ;;      var sNum;
 ;;      if (cStyle) {
 ;;         sNum = Number(cStyle.zIndex);
 ;;      } else {
 ;;         sNum = Number(elem.style.zIndex);
 ;;      }
 ;;      if (!isNaN(sNum)) {
 ;;         maxZIndex = Math.max(maxZIndex,sNum);
 ;;      }
 ;;   }
 ;;   return maxZIndex ;
 ;;};
 ;;***END***
