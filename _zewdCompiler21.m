%zewdCompiler21	; Enterprise Web Developer Compiler : Combo+ Javascript
 ;
 ; Product: Enterprise Web Developer (Build 884)
 ; Build Date: Tue, 13 Sep 2011 11:17:26
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
comboPlus ;
 ;;/*
 ;;    ComboPlus Widget Controller
 ;;    Build date: 28 July 2008
 ;;*/
 ;;EWD.utils.comboPlus = {
 ;;      keystrokeThreshold: 1000,
 ;;      waitThreshold: 500,
 ;;      curDate: new Date(),
 ;;      highlightSet: false,
 ;;      optSelected: "",
 ;;      bottom: 1000000,
 ;;      scrolling: false,
 ;;      regionName: "",
 ;;      currentDropdown: "",
 ;;      currentLeft: 0,
 ;;      currentTop: 0,
 ;;      currentOption: 0,
 ;;      browserType: "",
 ;;      browserOS: "",
 ;;      allowAnyText: new Array(),
 ;;      lastNo: new Array(),
 ;;      fieldRef: new Array(),
 ;;      selectedText: "",
 ;;      selectedOption: new Array(),
 ;;      setButtonStyle: function(name) {
 ;;        var button = document.getElementById(name + "Btn") ;
 ;;        if (button) {
 ;;          var fileName = "/images/button_" + EWD.utils.comboPlus.browserType + EWD.utils.comboPlus.browserOS + ".jpg" ;
 ;;          var background = "#fff url(" + fileName + ") no-repeat 0 0" ;
 ;;          if (EWD.utils.comboPlus.browserType == "safari") {
 ;;              button.style.background = background ;
 ;;              button.style.top = "-1px" ;
 ;;              button.style.left = "-6px" ;
 ;;              button.style.width = "21px" ;
 ;;              button.style.height = "25px" ;
 ;;              button.style.border = "none" ;
 ;;              return;
 ;;          }
 ;;          if (EWD.utils.comboPlus.browserOS == "2000") {
 ;;            if (EWD.utils.comboPlus.browserType == "ie6") {
 ;;              button.style.background = background ;
 ;;              button.style.top = "-1px" ;
 ;;              button.style.left = "-8px" ;
 ;;              button.style.width = "19px" ;
 ;;              button.style.height = "22px" ;
 ;;              button.style.border = "1px solid #9093BE" ;
 ;;              button.style.borderLeft = "1px solid #ffffff" ;
 ;;              button.style.borderTop = "" ;
 ;;              return;
 ;;            }
 ;;          }
 ;;          if (EWD.utils.comboPlus.browserOS == "xp") {
 ;;            if (EWD.utils.comboPlus.browserType == "ie7") {
 ;;              button.style.background = background ;
 ;;              button.style.top = "0px" ;
 ;;              button.style.left = "-7px" ;
 ;;              button.style.width = "20px" ;
 ;;              button.style.height = "23px" ;
 ;;              button.style.border = "1px solid #9093BE" ;
 ;;              button.style.borderLeft = "1px solid #ffffff" ;
 ;;              button.style.borderTop = "" ;
 ;;              return;
 ;;            }
 ;;            if (EWD.utils.comboPlus.browserType == "ie6") {
 ;;              button.style.background = background ;
 ;;              button.style.top = "0px" ;
 ;;              button.style.left = "-7px" ;
 ;;              button.style.width = "20px" ;
 ;;              button.style.height = "23px" ;
 ;;              button.style.border = "1px solid #9093BE" ;
 ;;              button.style.borderLeft = "1px solid #ffffff" ;
 ;;              button.style.borderTop = "" ;
 ;;              return;
 ;;            }
 ;;            if (EWD.utils.comboPlus.browserType == "firefox") {
 ;;              button.style.background = background ;
 ;;              button.style.top = "1px" ;
 ;;              button.style.left = "-6px" ;
 ;;              button.style.width = "21px" ;
 ;;              button.style.height = "24px" ;
 ;;              button.style.border = "none" ;
 ;;              return;
 ;;            }
 ;;          }
 ;;          if (EWD.utils.comboPlus.browserOS == "linux") {
 ;;            if (EWD.utils.comboPlus.browserType == "firefox") {
 ;;              button.style.background = background ;
 ;;              button.style.top = "3px" ;
 ;;              button.style.left = "-6px" ;
 ;;              button.style.width = "21px" ;
 ;;              button.style.height = "24px" ;
 ;;              button.style.border = "none" ;
 ;;              return;
 ;;            }
 ;;          }
 ;;        }
 ;;      },
 ;;      getBrowserInfo: function() {
 ;;         var sig = navigator.userAgent ;
 ;;         EWD.utils.comboPlus.browserType="firefox" ;
 ;;         if (EWD.utils.comboPlus.contains(sig,"MSIE 6")) EWD.utils.comboPlus.browserType="ie6" ;
 ;;         if (EWD.utils.comboPlus.contains(sig,"MSIE 7")) EWD.utils.comboPlus.browserType="ie7" ;
 ;;         if (EWD.utils.comboPlus.contains(sig,"Safari")) EWD.utils.comboPlus.browserType="safari" ;
 ;;         EWD.utils.comboPlus.browserOS="linux" ;
 ;;         if (EWD.utils.comboPlus.contains(sig,"Windows NT 5.1")) EWD.utils.comboPlus.browserOS="xp" ;
 ;;         if (EWD.utils.comboPlus.contains(sig,"Windows NT 5.0")) EWD.utils.comboPlus.browserOS="2000" ;
 ;;         if (EWD.utils.comboPlus.contains(sig,"Windows NT 6")) EWD.utils.comboPlus.browserOS="vista" ;
 ;;      },
 ;;      contains: function(inString,subString) {
 ;;         if (inString.indexOf(subString) == -1) return false;
 ;;         return true;
 ;;      },
 ;;      initialiseScrollRegion: function(fieldName) {
 ;;         EWD.utils.comboPlus.trace("initialiseScrollRegion: fieldName=" + fieldName) ;
 ;;         EWD.utils.comboPlus.currentDropdown = fieldName ;
 ;;         var pointer=document.getElementById("scrollRegion" + fieldName);
 ;;         var shim = document.getElementById("scrollRegionShim" + fieldName);
 ;;         pointer.className = "cpScrollAreaOn";
 ;;         if ((EWD.utils.comboPlus.browserType == "ie7")&&(EWD.utils.comboPlus.browserOS == "xp")) {
 ;;            pointer.style.border = "1px solid #9093BE" ;
 ;;         }
 ;;         if ((EWD.utils.comboPlus.browserType == "firefox")&&(EWD.utils.comboPlus.browserOS == "xp")) {
 ;;            pointer.style.border = "1px solid #849DB1" ;
 ;;         }
 ;;         pointer.style.height = 96 ;
 ;;         EWD.utils.comboPlus.scrolling = false;
 ;;         var currPos = pointer.scrollTop;
 ;;         pointer.scrollTop=10000000;
 ;;         EWD.utils.comboPlus.bottom = pointer.scrollTop;
 ;;         pointer.scrollTop = currPos;
 ;;         EWD.utils.comboPlus.scrolling = true;
 ;;         EWD.utils.comboPlus.findPosition(document.getElementById(fieldName));
 ;;         var width = document.getElementById(fieldName).offsetWidth;
 ;;         pointer.style.left = EWD.utils.comboPlus.currentLeft + 1;
 ;;         pointer.style.top = EWD.utils.comboPlus.currentTop + 22;
 ;;         pointer.style.width = width + 15;
 ;;         shim.style.left = pointer.style.left;
 ;;         shim.style.top = pointer.style.top;
 ;;         shim.style.width = pointer.style.width;
 ;;         EWD.utils.comboPlus.trace("shim width = " + shim.style.width) ;
 ;;         shim.style.height = pointer.clientHeight + 2;
 ;;         shim.style.display = "inline";
 ;;      },
 ;;      waiting: function(value,atTime,fieldName) {
 ;;         EWD.utils.comboPlus.trace("waiting: fieldName=" + fieldName + " ; value=" + value + " ; atTime = " + atTime) ;
 ;;         if (atTime == EWD.utils.comboPlus.curTime) {
 ;;            var pointer=document.getElementById("scrollRegion" + fieldName);
 ;;            pointer.innerHTML= '' ;
 ;;            EWD.utils.comboPlus.optSelected = "" ;
 ;;            EWD.utils.comboPlus.selectedOption[fieldName]  = 0 ;
 ;;            EWD.utils.comboPlus.initialiseScrollRegion(fieldName) ;
 ;;            EWD.utils.comboPlus.trace("2: call to QuicklistMatches: value=" + value) ;
 ;;            EWD.utils.comboPlus.quickListMatches(fieldName,escape(value));
 ;;            EWD.utils.comboPlus.currentOption = 0 ;
 ;;            var curDate = new Date() ;
 ;;            EWD.utils.comboPlus.lastTime = curDate.getTime() ;
 ;;         }
 ;;      },
 ;;      quickList: function(e,fieldName,value,allowAnyText) {
 ;;         EWD.utils.comboPlus.trace("quickList: fieldName=" + fieldName + " ; value=" + value + " ; keyCode = " + e.keyCode) ;
 ;;         EWD.utils.comboPlus.allowAnyText["scrollRegion" + fieldName] = allowAnyText ;
 ;;         var pointer=document.getElementById("scrollRegion" + fieldName);
 ;;         if (e.keyCode == 9) {
 ;;            return ;
 ;;         }
 ;;         if (e.keyCode == 38) return ;
 ;;         if (e.keyCode == 40) return ; 
 ;;         if (e.keyCode == 13) {
 ;;            if (pointer.className == "cpScrollArea") return ;
 ;;            EWD.utils.comboPlus.initialise("scrollRegion" + fieldName) ;
 ;;            e.cancelBubble = true ;
 ;;            return ;
 ;;         }
 ;;         var curDate = new Date() ;
 ;;         EWD.utils.comboPlus.curTime = curDate.getTime() ;
 ;;         var timeDiff = EWD.utils.comboPlus.curTime - EWD.utils.comboPlus.lastTime ;
 ;;         EWD.utils.comboPlus.trace("curTime = " + EWD.utils.comboPlus.curTime + "; lastTime=" + EWD.utils.comboPlus.lastTime + "; timeDiff=" + timeDiff) ;
 ;;         if (timeDiff > EWD.utils.comboPlus.keystrokeThreshold) {
 ;;            pointer.innerHTML= '' ;
 ;;            EWD.utils.comboPlus.optSelected = "" ;
 ;;            EWD.utils.comboPlus.selectedOption[fieldName]  = 0 ;
 ;;            EWD.utils.comboPlus.initialiseScrollRegion(fieldName) ;
 ;;            EWD.utils.comboPlus.trace("1: call to QuicklistMatches: value=" + value) ;
 ;;            EWD.utils.comboPlus.quickListMatches(fieldName,escape(value));
 ;;            EWD.utils.comboPlus.currentOption = 0 ;
 ;;            var curDate = new Date() ;
 ;;            EWD.utils.comboPlus.lastTime = curDate.getTime() ;
 ;;         }
 ;;         else {
 ;;            setTimeout("EWD.utils.comboPlus.waiting('" + value + "','" + EWD.utils.comboPlus.curTime + "','" + fieldName + "')",EWD.utils.comboPlus.waitThreshold) ;
 ;;         }
 ;;      },
 ;;      appendOption: function(fieldName,text) {
 ;;         if (!EWD.utils.comboPlus.lastNo[fieldName]) {
 ;;            var no = 1 ;
 ;;         }
 ;;         else {
 ;;            var no = EWD.utils.comboPlus.lastNo[fieldName] ;
 ;;         }
 ;;         EWD.utils.comboPlus.addOption(fieldName,no+1,text) ;
 ;;      },        
 ;;      addOption: function(fieldName,no,text) {
 ;;         EWD.utils.comboPlus.trace("addOption: fieldName=" + fieldName + " ; no=" + no +" ; text=" + text) ; 
 ;;         var par=document.getElementById("scrollRegion" + fieldName);
 ;;         var el = document.createElement("div");
 ;;         var id = "cpOpt" + fieldName + no;
 ;;         el.setAttribute("id",id);
 ;;         el.setAttribute("className","txtMain");
 ;;         el.onclick = function() {
 ;;            EWD.utils.comboPlus.selectOption(this,fieldName);
 ;;         }
 ;;         el.onmouseover = function() {
 ;;            EWD.utils.comboPlus.highlightOn(this);
 ;;         }
 ;;         el.onmouseout = function() {
 ;;            EWD.utils.comboPlus.highlightOff(this);
 ;;         }
 ;;         par.appendChild(el);
 ;;         var tNode = document.createTextNode(text);
 ;;         el.appendChild(tNode);
 ;;         if (!EWD.utils.comboPlus.lastNo[fieldName]) {
 ;;            EWD.utils.comboPlus.lastNo[fieldName] = 1 ;
 ;;         }
 ;;         else {
 ;;            EWD.utils.comboPlus.lastNo[fieldName]++ ;
 ;;         }
 ;;         EWD.utils.comboPlus.currentDropdown = fieldName ;
 ;;      },
 ;;      checkScrolling: function(obj) {
 ;;         EWD.utils.comboPlus.trace("checkScrolling: obj.id=" + obj.id) ;
 ;;         if (EWD.utils.comboPlus.scrolling) {
 ;;            var currPos = obj.scrollTop;
 ;;            if (currPos >= EWD.utils.comboPlus.bottom) {
 ;;               var id=obj.id;
 ;;               id = EWD.utils.getPiece(id,"scrollRegion",2);
 ;;               EWD.utils.comboPlus.getNextOptions(id,"");
 ;;               EWD.utils.comboPlus.scrolling = false;
 ;;               var currPos = obj.scrollTop;
 ;;               obj.scrollTop=10000000;
 ;;               EWD.utils.comboPlus.bottom=obj.scrollTop;
 ;;               obj.scrollTop = currPos;
 ;;               EWD.utils.comboPlus.scrolling = true;
 ;;            }
 ;;         }
 ;;      },
 ;;      checkScrollRegionSize: function(fieldName) {
 ;;          EWD.utils.comboPlus.trace("checkScrollRegionSize: fieldName=" + fieldName) ;
 ;;          var par = document.getElementById("scrollRegion" + fieldName);
 ;;          if (par.hasChildNodes()) {
 ;;            var lastItem = par.childNodes[par.childNodes.length - 1];
 ;;            if (par.childNodes.length > 0) {
 ;;              var ht = lastItem.offsetTop + lastItem.offsetHeight + 3;
 ;;              if (ht < par.clientHeight) {
 ;;                par.style.height = ht + 'px';
 ;;                var shim = document.getElementById("scrollRegionShim" + fieldName);
 ;;                shim.style.height = (ht + 0) + 'px';
 ;;              }
 ;;            }
 ;;          }
 ;;      },
 ;;      selectOption: function(obj,fieldName) {
 ;;          EWD.utils.comboPlus.trace("selectOption: obj.id=" + obj.id + " ; fieldName=" + fieldName) ;
 ;;          EWD.utils.comboPlus.regionName = "scrollRegion" + fieldName;
 ;;          document.getElementById(EWD.utils.comboPlus.regionName).setAttribute("active",1);
 ;;          if (EWD.utils.comboPlus.optSelected != "") {
 ;;            EWD.utils.comboPlus.highlightOff(document.getElementById(EWD.utils.comboPlus.optSelected));
 ;;          }
 ;;          obj.className = "cpHlOn";
 ;;          EWD.utils.comboPlus.highlightSet = true;
 ;;          var field = document.getElementById(fieldName) ;
 ;;          field.value = obj.innerHTML;
 ;;          field.select();
 ;;          if (field.fireEvent) {
 ;;            field.fireEvent("onChange") ;
 ;;          }
 ;;          else {
 ;;            var hev = document.createEvent('HTMLEvents');
 ;;            hev.initEvent('change', false, false);
 ;;            field.dispatchEvent(hev);
 ;;          }
 ;;          EWD.utils.comboPlus.toggleDropdown(EWD.utils.comboPlus.regionName);
 ;;          EWD.utils.comboPlus.optSelected = obj.id;
 ;;      },
 ;;      highlightOn: function(obj) {
 ;;          EWD.utils.comboPlus.trace("highlightOn: obj.id=" + obj.id) ;
 ;;          if (EWD.utils.comboPlus.optSelected != "") {
 ;;            EWD.utils.comboPlus.highlightOff(document.getElementById(EWD.utils.comboPlus.optSelected));
 ;;          }
 ;;          if (EWD.utils.comboPlus.currentOption != 0) {
 ;;            document.getElementById(EWD.utils.comboPlus.currentOption).className = "cpHlOff" ;
 ;;          }
 ;;          obj.className = "cpHlOn";
 ;;          EWD.utils.comboPlus.highlightSet=false;
 ;;          EWD.utils.comboPlus.currentOption = obj.id ;
 ;;          EWD.utils.comboPlus.selectedOption[EWD.utils.comboPlus.currentDropdown] = obj.id ;
 ;;      },
 ;;      highlightOff: function(obj) {
 ;;          EWD.utils.comboPlus.trace("highlightOff: obj.id = " + obj.id) ;
 ;;          if (!EWD.utils.comboPlus.highlightSet) {
 ;;            obj.className = "cpHlOff";
 ;;          }
 ;;      },
 ;;      popupsOff: function(e) {
 ;;          if (!e) e = window.event;
 ;;          var srcEl ;
 ;;          if (e.srcElement) {
 ;;            srcEl = e.srcElement;
 ;;          } 
 ;;          else if (e.target) {
 ;;            srcEl = e.target;
 ;;          }
 ;;          EWD.utils.comboPlus.trace("popupsOff: EWD.utils.comboPlus.regionName=" + EWD.utils.comboPlus.regionName) ;
 ;;          if (EWD.utils.comboPlus.regionName != "") {
 ;;            if (document.getElementById(EWD.utils.comboPlus.regionName).getAttribute("active") == "0") {
 ;;              EWD.utils.comboPlus.toggleDropdown(EWD.utils.comboPlus.regionName);
 ;;              document.getElementById(EWD.utils.comboPlus.regionName).setAttribute("active",1);
 ;;              return;
 ;;            }
 ;;          }
 ;;          if (EWD.utils.comboPlus.currentDropdown == "") {
 ;;            return;
 ;;          }
 ;;          var src = srcEl.id;
 ;;          var match = "scrollRegion" + EWD.utils.comboPlus.currentDropdown ;
 ;;          if (src == match) {
 ;;            return;
 ;;          }
 ;;          if (src == (EWD.utils.comboPlus.currentDropdown + "Btn")) {
 ;;            return;
 ;;          }
 ;;          if (src.substr(0,5) == "cpOpt") {
 ;;            return;
 ;;          }
 ;;          if (src == EWD.utils.comboPlus.currentDropdown) {
 ;;            return;
 ;;          }
 ;;          EWD.utils.comboPlus.hideDropdown(EWD.utils.comboPlus.currentDropdown);
 ;;      },
 ;;      dsDebug: function(str) {
 ;;          var debugWindow = document.getElementById("dsDebug");
 ;;          if (debugWindow == null) {
 ;;            debugWindow = document.createElement("textarea");
 ;;            debugWindow.setAttribute("id", "dsDebug");
 ;;            debugWindow.setAttribute("cols", "80");
 ;;            debugWindow.setAttribute("rows", "20");
 ;;            document.body.appendChild(debugWindow);
 ;;          }
 ;;          debugWindow.value = debugWindow.value + str + "\n";
 ;;      },
 ;;      setMouseOut: function(dropdownId) {
 ;;          EWD.utils.comboPlus.trace("setMouseOut: dropdownId=" + dropdownId) ;
 ;;          var pointer = document.getElementById(dropdownId);
 ;;          if (pointer.className == "cpScrollArea") {
 ;;            document.getElementById(dropdownId).setAttribute("active",1);
 ;;          }
 ;;          else {
 ;;            document.getElementById(dropdownId).setAttribute("active",0);
 ;;          }
 ;;      },
 ;;      toggleDropdown: function(dropdownId) {
 ;;          EWD.utils.comboPlus.trace("toggleDropdown: dropdownId=" + dropdownId) ;
 ;;          var fieldName = EWD.utils.getPiece(dropdownId,"scrollRegion",2);
 ;;          EWD.utils.comboPlus.trace("toggleDropdown: fieldName=" + fieldName) ;
 ;;          var value = document.getElementById(fieldName).value ;
 ;;          EWD.utils.comboPlus.trace("toggleDropdown: value=" + value) ;
 ;;          var pointer = document.getElementById(dropdownId);
 ;;          if (pointer.className == "cpScrollArea") {
 ;;            EWD.utils.comboPlus.trace("toggleDropdown: toggling on") ;
 ;;            EWD.utils.comboPlus.initialiseScrollRegion(fieldName) ;
 ;;            if ((value !="")&&(!pointer.hasChildNodes())&&(!EWD.utils.comboPlus.allowAnyText[dropdownId])) {
 ;;              // nothing yet in drop-down panel, so run query from start
 ;;              EWD.utils.comboPlus.quickListMatches(fieldName,value);
 ;;            }
 ;;            else {
 ;;              var noOfChildren = pointer.childNodes.length ;
 ;;              var found = false;
 ;;              var browserType = EWD.utils.comboPlus.browserType;
 ;;              if ((browserType === "firefox")||(browserType === 'safari')) {
 ;;                if (noOfChildren > 1) {
 ;;                  for (var i=1;i<noOfChildren;i++) {
 ;;                    var fc = pointer.childNodes[i].firstChild ;
 ;;                    ch1 = fc.data ;
 ;;                    if (ch1 == value) found = true ;
 ;;                  }
 ;;                }
 ;;              }
 ;;              else if (noOfChildren > 0) {
 ;;                for (var i=0;i<noOfChildren;i++) {
 ;;                  var fc = pointer.childNodes[i].firstChild ;
 ;;                  ch1 = fc.data ;
 ;;                  if (ch1 == value) found = true ;
 ;;                }
 ;;              }
 ;;              if (!found) {
 ;;                EWD.utils.comboPlus.quickListMatches(fieldName,value);
 ;;              }
 ;;              EWD.utils.comboPlus.currentDropdown = fieldName;
 ;;              if (typeof EWD.utils.comboPlus.selectedOption[fieldName] != "undefined") {
 ;;                EWD.utils.comboPlus.currentOption = EWD.utils.comboPlus.selectedOption[fieldName] ;
 ;;                if (EWD.utils.comboPlus.currentOption != 0) {
 ;;                  var obj = document.getElementById(EWD.utils.comboPlus.currentOption) ;
 ;;                  EWD.utils.comboPlus.highlightOn(obj) ;
 ;;                }
 ;;              }
 ;;            }
 ;;            EWD.utils.comboPlus.checkScrollRegionSize(fieldName) ;
 ;;          }
 ;;          else {
 ;;            EWD.utils.comboPlus.trace("toggleDropdown: toggling off") ;
 ;;            EWD.utils.comboPlus.hideDropdown(fieldName);
 ;;            EWD.utils.comboPlus.currentDropdown = "";
 ;;          }
 ;;      },
 ;;      hideDropdown: function(field) {
 ;;            EWD.utils.comboPlus.trace("hideDropdown: field=" + field) ;
 ;;            var currentValue = EWD.utils.comboPlus.selectedText ;
 ;;            EWD.utils.comboPlus.trace("currentValue=" + currentValue) ;
 ;;            var panel = document.getElementById("scrollRegion" + field) ;
 ;;            panel.innerHTML = "" ;
 ;;            panel.className = "cpScrollArea";
 ;;            document.getElementById("scrollRegionShim" + field).style.display = "none";
 ;;            if (EWD.utils.comboPlus.userFunc) {
 ;;                EWD.utils.comboPlus.userFunc(field, currentValue) ;
 ;;            }
 ;;      },
 ;;      findPosition: function(obj) {
 ;;            EWD.utils.comboPlus.trace("findPosition: obj.id=" + obj.id) ;
 ;;	      EWD.utils.comboPlus.currentLeft = EWD.utils.comboPlus.currentTop = 0;
 ;;	      if (obj.offsetParent) {
 ;;                  EWD.utils.comboPlus.currentLeft = obj.offsetLeft ;
 ;;                  EWD.utils.comboPlus.currentTop = obj.offsetTop ;
 ;;                  while (obj = obj.offsetParent) {
 ;;                        EWD.utils.comboPlus.currentLeft += obj.offsetLeft ;
 ;;                        EWD.utils.comboPlus.currentTop += obj.offsetTop ;
 ;;                        var left = obj.style.left ;
 ;;                        if (left != '') {
 ;;                           left = EWD.utils.getPiece(left,"px",1) ;
 ;;                           EWD.utils.comboPlus.currentLeft -= left ;
 ;;                        }
 ;;                        var top = obj.style.top ;
 ;;                        if (top != '') {
 ;;                           top = EWD.utils.getPiece(top,"px",1) ;
 ;;                           EWD.utils.comboPlus.currentTop -= top ;
 ;;                        }
 ;;                  } 
 ;;            }
 ;;            return;
 ;;      },
 ;;      moveSelected: function(e) {
 ;;            if (!e) e = event ;
 ;;            EWD.utils.comboPlus.trace("moveSelected: keycode=" + e.keyCode + " ; EWD.utils.comboPlus.currentDropdown = " + EWD.utils.comboPlus.currentDropdown) ;
 ;;            if (EWD.utils.comboPlus.currentDropdown != "") {
 ;;                  var currId = EWD.utils.comboPlus.currentOption ;
 ;;                  var optionPrefix = "cpOpt" + EWD.utils.comboPlus.currentDropdown;
 ;;                  var optNo = EWD.utils.getPiece(currId,optionPrefix,2);
 ;;                  optNo = parseInt(optNo) ;
 ;;                  if (e.keyCode == 38) {
 ;;                        if (optNo > 1) {
 ;;                              var panelName = "scrollRegion" + EWD.utils.comboPlus.currentDropdown ;
 ;;                              var newId = "cpOpt" + EWD.utils.comboPlus.currentDropdown + (optNo - 1) ;
 ;;                              document.getElementById(EWD.utils.comboPlus.currentOption).className = "cpHlOff" ;
 ;;                              EWD.utils.comboPlus.highlightOn(document.getElementById(newId)) ;
 ;;                              var pos = document.getElementById(panelName).scrollTop ;
 ;;                              document.getElementById(panelName).scrollTop = pos - 16 ;
 ;;                        }
 ;;                        return false ;
 ;;                  }
 ;;                  if (e.keyCode == 40) {
 ;;                        if (!optNo) {
 ;;                              optNo = 1 ;
 ;;                        }
 ;;                        var panelName = "scrollRegion" + EWD.utils.comboPlus.currentDropdown ;
 ;;                        var panelPointer = document.getElementById(panelName) ;
 ;;                        var noOfChildren = panelPointer.childNodes.length ;
 ;;                        EWD.utils.comboPlus.trace("moveSelected: optNo = " + optNo + " ; noOfChildren=" + noOfChildren) ;
 ;;                        if ((optNo == 1)&&(noOfChildren == 1)) {
 ;;                              var newId = "cpOpt" + EWD.utils.comboPlus.currentDropdown + optNo ;
 ;;                              EWD.utils.comboPlus.highlightOn(document.getElementById(newId)) ;                                       
 ;;                        }
 ;;                        if (optNo < noOfChildren) {
 ;;                              var oldId = "cpOpt" + EWD.utils.comboPlus.currentDropdown + optNo ;
 ;;                              var oldStyle = document.getElementById(oldId).className ;
 ;;                              EWD.utils.comboPlus.trace("oldId = " + oldId + "; oldStyle = " + oldStyle) ;
 ;;                              if (oldStyle != "cpHlOn") {
 ;;                                    var newId = "cpOpt" + EWD.utils.comboPlus.currentDropdown + optNo ;
 ;;                                    EWD.utils.comboPlus.trace("1: newId = " + newId) ;
 ;;                              }
 ;;                              else {
 ;;                                    var newId = "cpOpt" + EWD.utils.comboPlus.currentDropdown + (optNo + 1) ;
 ;;                                    EWD.utils.comboPlus.trace("2: newId = " + newId) ;
 ;;                              }
 ;;                              if (EWD.utils.comboPlus.currentOption != 0) {
 ;;                                    document.getElementById(EWD.utils.comboPlus.currentOption).className = "cpHlOff" ;
 ;;                                    EWD.utils.comboPlus.trace("3: got here") ;
 ;;                              }
 ;;                              EWD.utils.comboPlus.highlightOn(document.getElementById(newId)) ; 
 ;;                              if (oldStyle == "cpHlOn") {
 ;;                                    var pos = document.getElementById(panelName).scrollTop ;
 ;;                                    document.getElementById(panelName).scrollTop = pos + 16 ;
 ;;                                    EWD.utils.comboPlus.trace("4: got here") ;
 ;;                              }
 ;;                        }
 ;;                        return false ;
 ;;                  }
 ;;                  if (e.keyCode == 13) {
 ;;                        if (EWD.utils.comboPlus.currentOption != 0) {
 ;;                              EWD.utils.comboPlus.selectOption(document.getElementById(EWD.utils.comboPlus.currentOption),EWD.utils.comboPlus.currentDropdown) ;
 ;;                        }
 ;;                        return false ;
 ;;                  }
 ;;                  if (e.keyCode == 9) {
 ;;                        EWD.utils.comboPlus.regionName = "scrollRegion" + EWD.utils.comboPlus.currentDropdown ;
 ;;                        EWD.utils.comboPlus.toggleDropdown(EWD.utils.comboPlus.regionName);
 ;;                        return false ;
 ;;                  }
 ;;            }
 ;;            else {
 ;;              //if (event.keyCode == 9) alert("tab pressed but currentDropdown not set") ;
 ;;            }
 ;;            return true ;
 ;;      },
 ;;      initialise: function(dropdownId,allowAnyText) {
 ;;            EWD.utils.comboPlus.trace("initialise: dropdownId=" + dropdownId) ;
 ;;            EWD.utils.comboPlus.highlightSet = false;
 ;;            EWD.utils.comboPlus.optSelected = "";
 ;;            EWD.utils.comboPlus.bottom = 1000000;
 ;;            EWD.utils.comboPlus.scrolling = false;
 ;;            EWD.utils.comboPlus.regionName = "";
 ;;            EWD.utils.comboPlus.currentDropdown = EWD.utils.getPiece(dropdownId,"scrollRegion",1) ;
 ;;            EWD.utils.comboPlus.currentLeft = 0;
 ;;            EWD.utils.comboPlus.currentTop = 0;
 ;;            EWD.utils.comboPlus.currentOption = 0;
 ;;            EWD.utils.comboPlus.toggleDropdown(dropdownId) ;
 ;;            EWD.utils.comboPlus.allowAnyText[dropdownId] = allowAnyText ;
 ;;      },
 ;;      trace: function (string) {
 ;;            return ;
 ;;            var trace = document.getElementById("trace") ;
 ;;            var fc = trace.firstChild ;
 ;;            var text ;
 ;;            if (EWD.utils.comboPlus.browserType == "firefox") {
 ;;              text = trace.value ;
 ;;            }
 ;;            else {
 ;;              text = fc.data ;
 ;;            }
 ;;            var val = string + "\r\n" + text ;
 ;;            if (EWD.utils.comboPlus.browserType == "firefox") {
 ;;              trace.value = val ;
 ;;            }
 ;;            else {
 ;;              fc.data = val ; 
 ;;            }
 ;;      }
 ;;}
 ;;/*
 ;;EWD.utils.comboPlus.lastTime = EWD.utils.comboPlus.curDate.getTime() ;
 ;;EWD.utils.comboPlus.curTime = EWD.utils.comboPlus.lastTime ;
 ;;document.onmousedown = EWD.utils.comboPlus.popupsOff;
 ;;document.onkeydown = EWD.utils.comboPlus.moveSelected;
 ;;EWD.utils.comboPlus.getBrowserInfo() ;
 ;;*/
 ;;***END***
