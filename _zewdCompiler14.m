%zewdCompiler14	; Enterprise Web Developer Compiler : ajax fixed text
 ;
 ; Product: Enterprise Web Developer (Build 896)
 ; Build Date: Mon, 06 Feb 2012 17:28:14
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
 QUIT
 ;
ewdAjaxError ;
	;;<ewd:config />
	;;<ewdAjaxError><?= #ewd_ajaxError ?></ewdAjaxError>
	;;***END***
ewdAjaxErrorRedirect ;
	;;<ewd:config pageType="ajax" applyTemplate="false">
	;;<span>
	;;<div id="zewdRef" href="ewdErrorRedirect.ewd"></div>
	;;<ewd:ajaxOnLoad>
	;;document.location = document.getElementById("zewdRef").getAttribute("href") ;
	;;</ewd:ajaxOnLoad>
	;;</span>
	;;***END***
	;;
ewdErrorRedirect ;
	;;<ewd:config isFirstpage="false" applyTemplate="false" prePageScript="ajaxErrorRedirect^%zewdAPI">
	;;<html>
	;;<head>
	;;<title>Ajax Error Redirect page</title>
	;;<head>
	;;<body>
	;;Please wait....
	;;</body>
	;;</html>
	;;***END***
	;;
iWD ;;
	;;iWD = {
	;;  build: '<buildnumber>',
	;;  updateOrientation: function() {
	;;        var fragName = jQT.getCurrentPage();
	;;        if (document.getElementById(fragName + "-bottomToolbar").innerHTML != '') {
	;;           var scroller = document.getElementById(fragName + "-content-scrollWrapper");
	;;           if (window.orientation == -90) {
	;;              scroller.style.height = '220px';
	;;           }
	;;           if (window.orientation == 0) {
	;;              scroller.style.height = '366px';
	;;           }
	;;        }
	;;  },
	;;  fragmentLoaded: {},
	;;  goMenuOption: {},
	;;  loadFragment: {},
    ;;  createNewPage: function(fragmentName) {
    ;;       var obj = document.getElementById(fragmentName) ;
    ;;       if (!obj) {
    ;;          var obj = iWD.addDiv(fragmentName) ;
    ;;          var toolbarId = fragmentName + "-toolbar";
    ;;          var toolbar = iWD.addSubDiv(toolbarId,fragmentName);
    ;;          toolbar.setAttribute("class","toolbar");
    ;;          var h1 = document.createElement('h1');
    ;;          toolbar.appendChild(h1);
    ;;          var title = document.createTextNode(iWD.toolbarTitle);
    ;;          h1.appendChild(title);
    ;;          h1.id=fragmentName + "-toolbarTitle";
    ;;          var buts = document.createElement('span');
    ;;          toolbar.appendChild(buts);
    ;;          buts.id = fragmentName + "-toolbarButtons" ;
    ;;          var tabbarId = fragmentName + "-tabbar";
    ;;          var tabbar = iWD.addSubDiv(tabbarId,fragmentName);
    ;;          var contentWrapperId = fragmentName + "-content-scrollWrapper";
    ;;          var content = iWD.addSubDiv(contentWrapperId,fragmentName);
    ;;          content.setAttribute("style","height:410px;");
    ;;          document.getElementById(contentWrapperId).setAttribute("class","vertical-scroll");
    ;;          var contentBottomTBId = fragmentName + "-bottomToolbar";
    ;;          var content = iWD.addSubDiv(contentBottomTBId,fragmentName);
    ;;          var contentId = fragmentName + "-content";
    ;;          var content = iWD.addSubDiv(contentId,contentWrapperId);
    ;;          document.getElementById(contentId).setAttribute("style","-webkit-transform: translate3d(0px, 0px, 0px);-webkit-transition-duration: 0ms;-webkit-transition-timing-function: cubic-bezier(0, 0, 0.2, 1);");
    ;;          var contentBodyId = fragmentName + "-content-body";
    ;;          var contentBody = iWD.addSubDiv(contentBodyId,contentId);
    ;;          var contentFooterId = fragmentName + "-content-footer";
    ;;          var contentFooter = iWD.addSubDiv(contentFooterId,contentId);
    ;;          contentFooter.setAttribute("class","footer");
    ;;          contentFooter.innerHTML=iWD.footerContent;
    ;;          if (typeof(localStorage) != 'undefined') {
	;;            if (iWD.pageStorage=='local') {
	;;               var content = localStorage.getItem('zewd-lastContent-' + contentId) ;
	;;               if (content != null) {
	;;                 document.getElementById(contentId).innerHTML = content ;
	;;               }
	;;            }
	;;            /*
	;;            else {
	;;               var content = sessionStorage.getItem('zewd-lastContent-' + contentId) ;
    ;;            }
	;;            if (content != null) {
	;;              document.getElementById(contentId).innerHTML = content ;
	;;            }
	;;            */
	;;          }
    ;;          var xx=new iWD.iScroll(document.getElementById(contentId));
    ;;       }
    ;;       document.getElementById(fragmentName + '-content').style.webkitTransform = 'translate3d(0,0,0)';
    ;;       return obj;
	;;  },
	;;  scrollUpPage: function(fragmentName) {
    ;;       document.getElementById(fragmentName + '-content').style.webkitTransform = 'translate3d(0,0,0)';
	;;  },
	;;  removeActive: function() {
	;;    if (iWD.active) {
	;; 	     if (iWD.active.removeClass){
	;;         iWD.active.removeClass('active');
	;;       }
	;;    }
	;;  },
	;;  resetSubmit: function() {
	;;    if (iWD.submitPressed) {
	;;      iWD.submitPressed.parentNode.className='submitbutton';
	;;      delete iWD.submitPressed ;
	;;    }
	;;    
	;;  },
	;;  overlayShim: function(obj) {
	;;    iWD.lastMenuPanel = obj.parentNode.parentNode ;
	;;  },
	;;  hideLastMenu: function(obj) {
	;;    if (iWD.lastMenuPanel) {
	;;      iWD.lastMenuPanel.style.display = 'none';
	;;      delete iWD.lastMenuPanel ;
	;;    }
	;;  },
	;;  onTap: function(fragmentName,loadOnce) {
	;;       var obj=iWD.createNewPage(fragmentName);
    ;;       //iWD.target=fragmentName ;
    ;;       if (!loadOnce) {
    ;;          iWD.loadFragment[fragmentName]() ;
    ;;       }
    ;;       else {
    ;;          if (!iWD.fragmentLoaded[fragmentName]) {
    ;;             iWD.loadFragment[fragmentName]() ;
    ;;             iWD.fragmentLoaded[fragmentName] = true;
    ;;          }
    ;;       }
    ;;       iWD.currentFragmentName = fragmentName;
    ;;  },
    ;;  addDiv: function(id) {
	;;    if (!document.getElementById(id)) {
    ;;      var obj = document.createElement("div") ;
    ;;      obj.id = id ;
    ;;      //document.getElementById("iwdBody").appendChild(obj) ;
    ;;      document.getElementById("jqt").appendChild(obj) ;
    ;;      return obj;
    ;;    }
    ;;  },
    ;;  addSubDiv: function(id,parentId) {
	;;    if (!document.getElementById(id)) {
    ;;      var obj = document.createElement("div") ;
    ;;      obj.id = id ;
    ;;      document.getElementById(parentId).appendChild(obj) ;
    ;;      return obj;
    ;;    }
    ;;  },
	;;  switchTab: function(obj) {
	;;     document.getElementById(iWD.currentTab).className = '';
	;;     obj.className = 'pressed';
	;;     iWD.currentTab = obj.id;
    ;;  },
	;;  blurFields: function(obj,ignoreId) {    
    ;;    var inputs = obj.getElementsByTagName('input');
    ;;    for (var i=0 ; i<inputs.length; i++){
	;;       if (!ignoreId) {
	;;         inputs[i].blur();
	;;       }
	;;       else {
	;;         if (inputs[i].id != ignoreId) inputs[i].blur();
	;;       }
	;;    }
    ;;  },
    ;;  getChildCheckbox: function(obj) {
	;;     var fc = obj.firstChild;
	;;     if (fc.nodeType == 1) {
	;;        if (fc.getAttribute("type") == 'checkbox') {
	;;          return fc;
	;;        }
	;;     }
	;;     var nc = fc.nextSibling;
	;;     while (nc) {
	;;        if (nc.nodeType == 1) {
	;;          if (nc.getAttribute("type") == 'checkbox') {
	;;            return nc;
	;;          }
	;;        }
	;;        nc = nc.nextSibling ;
	;;     }
	;;     return '' ; 
	;;  },
	;;  alert: function(message) {
	;;    if (iWD.alertTitle) {
	;;      document.getElementById('iWDAlertTitle').innerHTML = iWD.alertTitle;
	;;    }
	;;    else {
	;;      document.getElementById('iWDAlertTitle').innerHTML = 'Error!';
	;;    }
	;;    delete iWD.target;
	;;    document.getElementById('iWDAlertText').innerHTML = message;
	;;    iWD.openAlert();
	;;  },
	;;  openAlert: function(){
	;;     document.getElementById("loading").className = 'loadingOff';
	;;     var aframe = document.getElementById("iWDAlertFrame");
	;;     aframe.style.display = 'block';
	;;     aframe.className="alertPanelOn";
	;;     if (jQT.getOrientation() == 'landscape') {
	;;        aframe.style.marginLeft = '100px' ;
	;;        aframe.style.bottom = '100px';
	;;     }
	;;     else {
	;;        aframe.style.marginLeft = '20px' ;
	;;        aframe.style.bottom = '180px';    
	;;     }
	;;     document.getElementById("cover").className="cover";
	;;     document.getElementById(jQT.getCurrentPage() + "-content-scrollWrapper").style.overflow='visible';
	;;     iWD.disableScroll = true;
	;;  },
	;;  closeAlert: function(){
	;;     var aframe = document.getElementById("iWDAlertFrame");
	;;     aframe.className="alertPanelOff";
	;;     var b=document.getElementById("cover");
	;;     b.className="nocover";
	;;     iWD.disableScroll = false;
	;;     setTimeout("document.getElementById('iWDAlertFrame').style.display='none';",1000);
	;;     document.getElementById(jQT.getCurrentPage() + "-content-scrollWrapper").style.overflow='hidden';
	;;  },
	;;  loadingOff: function() {
	;;     document.getElementById("loading").className = 'loadingOff';
	;;  },
	;;  SpinningWheelInUse: false,
	;;  SpinningWheelUse: '',
    ;;  openCalendar: function(fieldId,startYear,endYear) {
    ;;      if (!iWD.SpinningWheelInUse) {
	;;         iWD.SpinningWheelInUse = true ; 
	;;         iWD.SpinningWheelUse = 'calendar' ; 
	;;         var now = new Date();
	;;         var days = { };
	;;         var years = { };
	;;         var monthIndex = {'Jan':1,'Feb':2,'Mar':3,'Apr':4,'May':5,'Jun':6,'Jul':7,'Aug':8,'Sep':9,'Oct':10,'Nov':11,'Dec':12} ;
	;;         var months = { 1: 'Jan', 2: 'Feb', 3: 'Mar', 4: 'Apr', 5: 'May', 6: 'Jun', 7: 'Jul', 8: 'Aug', 9: 'Sep', 10: 'Oct', 11: 'Nov', 12: 'Dec' };
	;;         for( var i = 1; i < 32; i += 1 ) {
	;;           days[i] = i;
	;;         }
	;;         for( i = startYear; i < endYear; i += 1 ) {
	;;            years[i] = i;
	;;         }
	;;         var date = document.getElementById(fieldId).value ;
	;;         var dd,mm,yy ;
	;;         if (date == '') {
	;;            dd = now.getDate();
	;;            mm = now.getMonth()+1;
	;;            yy = now.getFullYear();
	;;         }
	;;         else {
	;;            var dateFields = date.split(" ") ;
	;;            dd = dateFields[1] ;
	;;            mm = dateFields[0] ;
	;;            mm = monthIndex[mm] ;
	;;            yy = dateFields[2] ;
	;;         }
	;;         SpinningWheel.addSlot(months, '', mm);
	;;         SpinningWheel.addSlot(days, 'right', dd);
	;;         SpinningWheel.addSlot(years, 'right', yy);
	;;         SpinningWheel.setCancelAction(function(){
	;;           //document.getElementById(elem1).innerHTML = "cancelled";
	;;           iWD.SpinningWheelInUse = false ; 
	;;         });
	;;         SpinningWheel.setDoneAction(function(){
	;;             var results = SpinningWheel.getSelectedValues();
	;;             document.getElementById(fieldId).value = results.values.join(' ');
	;;             iWD.SpinningWheelInUse = false ; 
	;;         });
	;;         SpinningWheel.open();
	;;      }
	;;   },
    ;;   openTimeSelector: function(fieldId) {
    ;;      if (!iWD.SpinningWheelInUse) {
	;;         iWD.SpinningWheelInUse = true ; 
	;;         iWD.SpinningWheelUse = 'time' ; 
	;;         var now = new Date();
	;;         var minutes = { };
	;;         var hours = { };
	;;         for( var i = 0; i < 60; i += 1 ) {
	;;           var j = i;
	;;           if (j < 10) j = "0" + j ;
	;;           minutes[i] = j;
	;;         }
	;;         for( var i = 0; i < 24; i += 1 ) {
	;;           var j = i;
	;;           if (j < 10) j = "0" + j ;
	;;           hours[i] = j;
	;;         }
	;;         var time = document.getElementById(fieldId).value ;
	;;         var hr,min ;
	;;         if (time == '') {
	;;           hr = now.getHours();
	;;           min = now.getMinutes();
	;;         }
	;;         else {
	;;            var timeFields = time.split(":") ;
	;;            hr = timeFields[0] ;
	;;            min = timeFields[1] ;
	;;            if (hr.charAt(0) == "0") hr = hr.substring(1) ;
	;;            if (min.charAt(0) == "0") min = min.substring(1) ;
	;;         }
	;;         SpinningWheel.addSlot(hours, 'right', hr);
	;;         SpinningWheel.addSlot(minutes, 'right', min);
	;;         SpinningWheel.setCancelAction(function(){
	;;           //document.getElementById(elem1).innerHTML = "cancelled";
	;;           iWD.SpinningWheelInUse = false ; 
	;;         });
	;;         SpinningWheel.setDoneAction(function(){
	;;             var results = SpinningWheel.getSelectedValues();
	;;             document.getElementById(fieldId).value = results.values.join(':');
	;;             iWD.SpinningWheelInUse = false ; 
	;;         });
	;;         SpinningWheel.open();
	;;      }
	;;   }
	;;};
	;;try {
	;;  addEventListener("orientationchange", iWD.updateOrientation);
	;;} 
	;;catch (e) {}
	;;/*
	;;if (typeof(localStorage) != 'undefined') {
	;;   if (localStorage.getItem('iWD.build') != "") {
	;;      localStorage.clear();
	;;      //localStorage.setItem('iWD.build',iWD.build);
	;;   }
	;;}
	;;*/
 ;;EWD = {
 ;; page: {
 ;;   errorMessage: function(message) {
 ;;      if (message != '') {
 ;;        if (typeof(Ext) != "undefined") {
 ;;              Ext.MessageBox.alert('EWD Error',message);
 ;;        }
 ;;        else {
 ;;          alert(message) ;
 ;;        }
 ;;      }
 ;;   },
 ;;   goNextPage: function(page,token,sessionToken) {
 ;;      if (page == "*") return ;
 ;;      var x ;
 ;;      x = "document.location = '" + page + "'" ;
 ;;      eval(x) ;
 ;;   },
 ;;   showConfirmMessage: false,
 ;;   displayConfirm: function(confirmText) {
 ;;      if (!EWD.page.showConfirmMessage) return true ;
 ;;      confirmText= EWD.utils.replace(confirmText,"&#39;","'") ;
 ;;      var ok = confirm(confirmText) ;
 ;;      EWD.page.showConfirmMessage = false ;
 ;;      return ok ; 
 ;;   },
 ;;   fetchResource: function(url,type) {
 ;;      /* synchronously fetches a resource file. type=js|css */
 ;;      var http_request=false;
 ;;      if (window.XMLHttpRequest) { // Mozilla, Safari,...
 ;;         http_request=new XMLHttpRequest();
 ;;         if (http_request.overrideMimeType) {
 ;;            if (type == 'js') {
 ;;              http_request.overrideMimeType('text/javascript');
 ;;            }
 ;;            else if (type == 'css') {
 ;;              http_request.overrideMimeType('text/css');
 ;;            } 
 ;;         }
 ;;      }
 ;;      else if (window.ActiveXObject) { // IE
 ;;         try {
 ;;            http_request=new ActiveXObject("Msxml2.XMLHTTP");
 ;;         }
 ;;         catch (e) {
 ;;            try {
 ;;                http_request=new ActiveXObject("Microsoft.XMLHTTP");
 ;;            }
 ;;            catch (e) {}
 ;;         }
 ;;      }
 ;;      if (!http_request) {
 ;;         alert('Ajax error : Your browser may not support the XMLHTTP Request Object needed to support Ajax');
 ;;        return '';
 ;;      }
 ;;      http_request.open('GET', url, false);
 ;;      http_request.send(null);
 ;;      var txt=http_request.responseText;
 ;;      return txt;
 ;;   },
 ;;   resourceLoaded: {},
 ;;   loadResource: function(url,type) {
 ;;      var elmnt;
 ;;      if (typeof(EWD.page.resourceLoaded[url]) == "undefined") {
 ;;        if (type == 'js') {
 ;;          elmnt = document.createElement("script");
 ;;          elmnt.type="text/javascript";
 ;;          elmnt.text = EWD.page.fetchResource(url,type);
 ;;          document.getElementsByTagName("head")[0].appendChild(elmnt); 
 ;;        }
 ;;        else if (type='css') {
 ;;            elmnt = document.createElement('style') ;
 ;;            elmnt.type = "text/css" ;
 ;;            var text = EWD.page.fetchResource(url,type);
 ;;            if (elmnt.styleSheet) {
 ;;               //IE
 ;;               elmnt.styleSheet.cssText = text ;
 ;;               document.getElementsByTagName("head")[0].appendChild(elmnt); 
 ;;            }
 ;;            else {
 ;;              var lnk = document.getElementsByTagName("head")[0].appendChild(elmnt); 
 ;;              var txtNode = document.createTextNode(text) ;
 ;;              lnk.appendChild(txtNode);
 ;;            }
 ;;        }
 ;;        EWD.page.resourceLoaded[url] = true ;
 ;;      }
 ;;   }
 ;; },
 ;; utils: {
 ;;    replace: function (string,text,by) {
 ;;      var strLength = string.length, txtLength = text.length;
 ;;      if ((strLength == 0) || (txtLength == 0)) return string;
 ;;      var i = string.indexOf(text);
 ;;      if ((!i) && (text != string.substring(0,txtLength))) return string;
 ;;      if (i == -1) return string;
 ;;      var newstr = string.substring(0,i) + by;
 ;;      if (i+txtLength < strLength) newstr = replace(string.substring(i+txtLength,strLength),text,by);
 ;;      return newstr;
 ;;    },
 ;;    findPosX: function (obj) {
 ;;      var curleft = 0;
 ;;      if(obj.offsetParent) while(1) {
 ;;         curleft += obj.offsetLeft;
 ;;         if(!obj.offsetParent) break;
 ;;         obj = obj.offsetParent;
 ;;      }
 ;;      else if(obj.x) curleft += obj.x;
 ;;      return curleft;
 ;;    },
 ;;    findPosY: function (obj) {
 ;;      var curtop = 0;
 ;;      if(obj.offsetParent) while(1) {
 ;;         curtop += obj.offsetTop;
 ;;         if(!obj.offsetParent) break;
 ;;         obj = obj.offsetParent;
 ;;      }
 ;;      else if(obj.y) curtop += obj.y;
 ;;      return curtop;
 ;;    },
 ;;    getPiece: function(refStr,delim,pieceNo) {
 ;;      var tempArray;
 ;;      if (refStr == "") return "";
 ;;      if (delim == "") return string;
 ;;      if (pieceNo == "") return string;
 ;;      tempArray = refStr.split(delim);
 ;;      return tempArray[pieceNo - 1];
 ;;    },
 ;;    contains: function(inString,subString) {
 ;;      if (inString.indexOf(subString) == -1) return false;
 ;;      return true;
 ;;    },
 ;;    isInteger: function(sText) {
 ;;      var validChars = "0123456789";
 ;;      if (sText.substring(0,1) == '-') sText = sText.substring(1) ;
 ;;      var isInt = true;
 ;;      var charx;
 ;;      for (var i = 0; i < sText.length && isInt == true; i++) {
 ;;         charx = sText.charAt(i);
 ;;         if (validChars.indexOf(charx) == -1) {
 ;;            isInt = false;
 ;;         }
 ;;      }
 ;;      return isInt;
 ;;    },
 ;;    getOption: function(fieldName) {
 ;;      var obj = document.getElementById(fieldName) ;
 ;;      return obj.options[obj.selectedIndex].value;
 ;;    },
 ;;    getBrowserInfo: function() {
 ;;      var sig = navigator.userAgent ;
 ;;      EWD.browserType="firefox" ;
 ;;      if (EWD.utils.contains(sig,"Safari")) EWD.browserType="safari" ;
 ;;      if (EWD.utils.contains(sig,"iPhone")) EWD.browserType="iphone" ;
 ;;      if (EWD.utils.contains(sig,"iPod")) EWD.browserType="iphone" ;
 ;;      if (EWD.utils.contains(sig,"iPad")) EWD.browserType="ipad" ;
 ;;      if (EWD.utils.contains(sig,"Opera")) EWD.browserType="opera" ;
 ;;      if (EWD.utils.contains(sig,"MSIE 6")) EWD.browserType="ie6" ;
 ;;      if (EWD.utils.contains(sig,"MSIE 7")) EWD.browserType="ie7" ;
 ;;      if (EWD.utils.contains(sig,"MSIE 8")) EWD.browserType="ie8" ;
 ;;      if (EWD.utils.contains(sig,"MSIE 8")) EWD.browserType="ie9" ;
 ;;      EWD.browserOS="linux" ;
 ;;      if (EWD.utils.contains(sig,"Windows NT 5.1")) EWD.browserOS="xp" ;
 ;;      if (EWD.utils.contains(sig,"Windows NT 5.0")) EWD.browserOS="2000" ;
 ;;      if (EWD.utils.contains(sig,"Windows NT 6")) EWD.browserOS="vista" ;
 ;;      EWD.browser = {};
 ;;      EWD.browser.isHTML5 = true;
 ;;      if (typeof(localStorage) == 'undefined') EWD.browser.isHTML5 = false;
 ;;    }
 ;; },
	;; json : {
	;;   initialize: function(technology) {
	;;      if (technology == 'wl') {
	;;          var url = "/scripts/mgwms32.dll?MGWLPN=LOCAL&MGWAPP=ewdwl&app=ewdMgr2&page=jsoninit" ;
	;;      }
    ;;      EWD.ajax.getFragment(url,"","synch") ;
	;;   },
	;;   dataSource: function(name) {
	;;      return EWD.json.url + name ;
	;;   }
	;; }
	;;};
	;;EWD.utils.getBrowserInfo() ;
	;;***END***
	;;
ajaxTimer ;
 ;;      EWD.ajax.refreshInit = function () {
 ;;                               EWD.ajax.counter = new Array ;
 ;;                               EWD.ajax.counter[1] = 0 ;
 ;;                             };
 ;;      EWD.ajax.runFunc = function (no,sec,url,targetID) {
 ;;                           var noOfParams = EWD.ajax.runFunc.arguments.length ;
 ;;                           if (noOfParams > 4) {
 ;;                             for (var nParam = 4; nParam < noOfParams; nParam++) {
 ;;                               url = url.replace(/\[x]/, EWD.ajax.runFunc.arguments[nParam]) ;
 ;;                             }
 ;;                           }
 ;;                           EWD.ajax.counter[no]++ ;
 ;;                           if (EWD.ajax.counter[no] == sec) {
 ;;                             EWD.ajax.makeRequest(url,targetID,'get','','') ;
 ;;                             EWD.ajax.counter[no] = 0 ;
 ;;                           }
 ;;                         };
 ;;                         
 ;;      setInterval("EWD.ajax.refresh()",1000) ;
 ;;      EWD.ajax.refreshInit() ;
 ;;
 ;;***END***
 ;;
iWDLoader ;;
 ;;iWDLoader = {
 ;;  build: '<buildnumber>',
 ;;  loadJavascript: function(url) {
 ;;     var js = localStorage.getItem(url);
 ;;     if (js != null) {
 ;;        eval(js);
 ;;     }
 ;;     else {	    
 ;;        http_request = new XMLHttpRequest();
 ;;        http_request.onreadystatechange = function() { 
 ;;           iWDLoader.saveJS(http_request,url); 
 ;;        };
 ;;        http_request.open('GET', url, false);
 ;;        http_request.send(null);
 ;;     }
 ;;  },
 ;;  setBaseHref: function(basehref) {
 ;;    var thebase = document.getElementsByTagName("base"); 
 ;;    thebase[0].href = basehref; 
 ;;  },
 ;;  saveJS: function(http_request,saveName) {
 ;;     if (http_request.readyState == 4) {
 ;;        if (http_request.status == 200) {
 ;;           var text = http_request.responseText ;
 ;;           localStorage.setItem(saveName,text);
 ;;           eval(text);
 ;;        }
 ;;     }
 ;;  },
 ;;  loadCSS: function(url,path) {
 ;;     if (path) iWDLoader.setBaseHref(path) ;
 ;;     var elmnt = document.createElement('style') ;
 ;;     elmnt.type = "text/css" ;
 ;;     var text = localStorage.getItem(url);
 ;;     if (text == null) {
 ;;        //alert("loading " + url);
 ;;        var text = iWDLoader.fetchResource(url,"css");
 ;;        localStorage.setItem(url,text);
 ;;     }
 ;;     else {
 ;;        //alert(url + "already in local storage");
 ;;     }
 ;;     var lnk = document.getElementsByTagName("head")[0].appendChild(elmnt); 
 ;;     var txtNode = document.createTextNode(text) ;
 ;;     lnk.appendChild(txtNode);
 ;;     if (path) iWDLoader.setBaseHref('') ;
 ;;  },
 ;;  fetchResource: function(url,type) {
 ;;    /* synchronously fetches a resource file. type=js|css */
 ;;    var http_request=false;
 ;;    http_request=new XMLHttpRequest();
 ;;    if (http_request.overrideMimeType) {
 ;;       if (type=='js') {
 ;;         http_request.overrideMimeType('text/javascript');
 ;;       }
 ;;       else if (type=='css') {
 ;;         http_request.overrideMimeType('text/css');
 ;;       }
 ;;    }
 ;;    http_request.open('GET', url, false);
 ;;    http_request.send(null);
 ;;    var txt=http_request.responseText; 
 ;;    return txt;
 ;;  }
 ;;};
 ;;if (localStorage.getItem('iWDLoader.build') != iWDLoader.build) {
 ;;  localStorage.clear();
 ;;  localStorage.setItem('iWDLoader.build',iWDLoader.build);
 ;;}
 ;;***END***
 ;;
