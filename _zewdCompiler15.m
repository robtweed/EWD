%zewdCompiler15	; Enterprise Web Developer Compiler
 ;
 ; Product: Enterprise Web Developer (Build 850)
 ; Build Date: Sat, 12 Feb 2011 14:13:17
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
	;;ewd:foreach~sessionName,index,return,subscriptList,startValue,endValue~0~forEach^%zewdCompiler8
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
	;;ewd:incrementCounter~~1~incrementCounter^%zewdCompiler7
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
	;;st:class~~0~stclass^%zewdST
	;;st:container~~0~container^%zewdST2
	;;st:form~~0~form^%zewdST
	;;st:formpanel~~0~panel^%zewdST
	;;st:js~~0~js^%zewdST
	;;st:list~~0~list^%zewdST2
	;;st:loggedinview~~0~loggedInView^%zewdST
	;;st:navigationmenu~~0~navigationMenu^%zewdST
	;;st:pageitem~~0~pageItem^%zewdST2
	;;st:panel~~0~panel^%zewdST
	;;st:qrcode~~0~qrCode^%zewdST2
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
jsBlock ;
 ;;EWD = {} ;
 ;;EWD.page = {
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
 ;;*php* if ((page.indexOf("?static") != -1)&&(page.indexOf(".") != -1)) {
 ;;*php*    x = "document.location = '" + page.substring(0,page.indexOf("?static")) + "'" ;
 ;;*php*    eval(x) ;
 ;;*php*    return ;
 ;;*php* }
 ;;*php* if (page.indexOf("?static") != -1) {
 ;;*php*    x = "document.location = '" + page.substring(0,page.indexOf("?static")) + ".php'" ;
 ;;*php* }
 ;;*php* else {
 ;;*php*    x = "document.location = '" + page + '.php?ewd_token=' + sessionToken + "&n=" + token + "'" ;
 ;;*php* }
 ;;*csp* x = "document.location = '" + page + "'" ;
 ;;*jsp* if ((page.indexOf("?static") != -1)&&(page.indexOf(".") != -1)) {
 ;;*jsp*    x = "document.location = '" + page.substring(0,page.indexOf("?static")) + "'" ;
 ;;*jsp*    eval(x) ;
 ;;*jsp*    return ;
 ;;*jsp* }
 ;;*jsp* if (page.indexOf("?static") != -1) {
 ;;*jsp*    x = "document.location = '" + page.substring(0,page.indexOf("?static")) + ".jsp'" ;
 ;;*jsp* }
 ;;*jsp* else {
 ;;*jsp*    x = "document.location = '" + page + '.jsp?ewd_token=' + sessionToken + '&n=' + token + "'" ;
 ;;*jsp* }
 ;;*vb.net* if ((page.indexOf("?static") != -1)&&(page.indexOf(".") != -1)) {
 ;;*vb.net*    x = "document.location = '" + page.substring(0,page.indexOf("?static")) + "'" ;
 ;;*vb.net*    eval(x) ;
 ;;*vb.net*    return ;
 ;;*vb.net* }
 ;;*vb.net* if (page.indexOf("?static") != -1) {
 ;;*vb.net*    x = "document.location = '" + page.substring(0,page.indexOf("?static")) + ".aspx'" ;
 ;;*vb.net* }
 ;;*vb.net* else {
 ;;*vb.net*    x = "document.location = '" + page + '.aspx?ewd_token=' + sessionToken + '&n=' + token + "'" ;
 ;;*vb.net* }
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
 ;;   openWindow: function(url,winHandle,winName,x,y,height,width,toolbar,location,directories,status,menubar,scrollbars,resizable) {
 ;;      var noOfParams = EWD.page.openWindow.arguments.length ;
 ;;      if (noOfParams > 14) {
 ;;         for (nParam = 14; nParam < noOfParams; nParam++) {
 ;;            url = url.replace(/\[x]/, EWD.page.openWindow.arguments[nParam]) ;
 ;;         }
 ;;      }
 ;;      var winRef = winHandle;
 ;;      var arrIndex = winHandle.indexOf("[");
 ;;      if(arrIndex != -1) {
 ;;         winRef = winHandle.substring(0,arrIndex) ;
 ;;         winHandle = winRef + "[" + winRef + ".length]" ;
 ;;      }
 ;;      if (winName == "") winName = winRef + Math.floor(Math.random()*100) ;
 ;;      var openWin = winHandle + '=window.open("' + url + '","' + winName + '","' ; 
 ;;      if (navigator.appName == 'Netscape') { 
 ;;         openWin = openWin + 'ScreenX=' + x + ',ScreenY=' + y + ',' ;
 ;;      }
 ;;      else {
 ;;         openWin = openWin + 'left=' + x + ',top=' + y + ',' ;
 ;;      }
 ;;      openWin = openWin + 'height=' + height + ',width=' + width + ',toolbar=' + toolbar + ',location=' + location + ',directories=' + directories + ',' ;
 ;;      openWin = openWin + 'status=' + status + ',menubar=' + menubar + ',scrollbars=' + scrollbars + ',resizable=' + resizable + '")' ;
 ;;      eval(openWin) ; 
 ;;   },
 ;;   spinnerKeyDown: false,
 ;;   incrementSpinner:  function(fieldId,max,interval) {
 ;;      var field = document.getElementById(fieldId) ;
 ;;      field.focus() ;
 ;;      if (EWD.page.spinnerKeyDown) {
 ;;         if (field.value < max) {
 ;;            field.value++ ;
 ;;         }
 ;;         setTimeout("EWD.page.incrementSpinner('" + fieldId + "'," + max + "," + interval +")",interval) ;
 ;;      }
 ;;   },
 ;;   decrementSpinner:  function(fieldId,min,interval) {
 ;;      var field = document.getElementById(fieldId) ;
 ;;      field.focus() ;
 ;;      if (EWD.page.spinnerKeyDown) {
 ;;         if (field.value > min) {
 ;;            field.value-- ;
 ;;         }
 ;;         setTimeout("EWD.page.decrementSpinner('" + fieldId + "'," + min + "," + interval +")",interval) ;
 ;;      }
 ;;   },
 ;;   spinnerControl:  function(e,fieldId,min,max) {
 ;;      var keyCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
 ;;      if (keyCode == 38) {
 ;;         if (document.getElementById(fieldId).value < max) {
 ;;            document.getElementById(fieldId).value++ ;
 ;;         }
 ;;      }
 ;;      if (keyCode == 40) {
 ;;         if (document.getElementById(fieldId).value > min) {
 ;;            document.getElementById(fieldId).value-- ;
 ;;         }
 ;;      }
 ;;   },                                  
 ;;   spinnerValueCheck:  function(value,fieldName,min,max) {
 ;;      if (!EWD.utils.isInteger(value)) {
 ;;         alert("Value of " + fieldName+ " is invalid!") ;
 ;;         return ;
 ;;      }
 ;;      if (value < min) {
 ;;         alert("Value of " + fieldName+ " is less than the minimuml!") ;
 ;;         return ;
 ;;      }
 ;;      if (value > max) {
 ;;         alert("Value of " + fieldName+ " is larger than the maximum!") ;
 ;;         return ;
 ;;      }
 ;;   },
 ;;   addStylesheet: function(doc,src,media) {
 ;;      if(doc.createStyleSheet) {
 ;;         var ssobj = doc.createStyleSheet(src);
 ;;         if (media) ssobj.media = media ;
 ;;         return ssobj ;
 ;;      }
 ;;      else {
 ;;         var linkNode=doc.createElement('link');
 ;;         linkNode.setAttribute("href",src) ;
 ;;         if (!media) media = "screen" ;
 ;;         linkNode.setAttribute("media",media);
 ;;         linkNode.setAttribute("rel","stylesheet") ;
 ;;         linkNode.setAttribute("type","text/css") ;
 ;;         doc.getElementsByTagName("head")[0].appendChild(linkNode);
 ;;         return linkNode ;
 ;;      }
 ;;   },
 ;;   printDiv: function(obj,height,width,top,left,title,styleSrc,autoprint,path,optionalURL,modal) {
 ;;      var divId;
 ;;      if (typeof(obj) == 'object') {
 ;;         divId = obj.divId;
 ;;         height = obj.height;
 ;;         width = obj.width;
 ;;         top = obj.top;
 ;;         left = obj.left;
 ;;         title = obj.title;
 ;;         styleSrc = obj.styleSrc;
 ;;         autoprint = obj.autoprint;
 ;;         path = obj.path;
 ;;         optionalURL = obj.optionalURL;
 ;;         modal = obj.modal;
 ;;      }
 ;;      else {
 ;;         divId = obj;
 ;;      }
 ;;      if (!height) height= "500" ;
 ;;      if (!width) width= "500" ;
 ;;      if (!top) top= "50" ;
 ;;      if (!left) left= "100" ;
 ;;      if (modal) {
 ;;          obj.content = document.getElementById(divId).innerHTML;
 ;;          if ((path == "")||(path == undefined)) path = "/" ;
 ;;          var features = "dialogHeight:" + height + "px;dialogWidth:" + width + "px;"
 ;;          features = features + "dialogTop:" + top + "px;dialogLeft:" + left + "px;status:no"
 ;;          var resp = window.showModalDialog(path + "printDiv.html",obj,features);
 ;;      }
 ;;      else {
 ;;         var domNode = document.getElementById(divId) ;
 ;;         var params="height=" + height + ",width=" + width ;
 ;;         if (navigator.appName == 'Netscape') { 
 ;;           params = params + ',ScreenX=' + left + ',ScreenY=' + top ;
 ;;         }
 ;;         else {
 ;;           params = params + ',left=' + left + ',top=' + top + ',' ;
 ;;         }
 ;;         var outputWindow ;
 ;;         var winURL = "" ;
 ;;         if (optionalURL) winURL = optionalURL;
 ;;         outputWindow=window.open(winURL,"",params);
 ;;         outputWindow.document.open("text/html", "replace");
 ;;         if (!title) title = "Print" ;
 ;;         outputWindow.document.write("<html><head><title>" + title + "</title>\n");
 ;;         outputWindow.document.write("</head><body>\n");
 ;;         if (!autoprint) outputWindow.document.write("<div id='printButton'><input type='button' value='Print' onClick='document.getElementById(\"printButton\").innerHTML = \"\" ; window.print()' /><hr/></div>\n");
 ;;         outputWindow.document.write("<div id='add'></div>\n");
 ;;         outputWindow.document.write("</body></html>\n");
 ;;         outputWindow.document.close();
 ;;         if (styleSrc) EWD.page.addStylesheet(outputWindow.document,styleSrc) ;
 ;;         var importedMarkup = domNode.innerHTML ;
 ;;         outputWindow.document.getElementById('add').innerHTML = importedMarkup ;
 ;;         if (autoprint) {
 ;;            outputWindow.print() ;
 ;;            outputWindow.close() ;
 ;;         }
 ;;      }
 ;;   },
 ;;   section: new Array(),
 ;;   currentPage: '',
 ;;   selectedColor: new Array(),
 ;;   unselectedColor: new Array(),
 ;;   selectTab: function(curr) {
 ;;     var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
 ;;     if (pageName != EWD.page.currentPage) {
 ;;       curr.className = "highlightedTab" ;
 ;;     }
 ;;   },
 ;;   deSelectTab: function(curr) {
 ;;     var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
 ;;     if (pageName != EWD.page.currentPage) {
 ;;       curr.className = "unselectedTab" ;
 ;;     }
 ;;   },
 ;;   getTabPage: function(pageName) {
 ;;         var previousPage = EWD.page.currentPage ;
 ;;         EWD.page.currentPage = pageName ;
 ;;         document.getElementById(previousPage + "Tab").className = "unselectedTab" ;
 ;;         document.getElementById(pageName + "Tab").className = "selectedTab" ;
 ;;  },
 ;;   selectInnerTab: function(curr) {
 ;;     var section = curr.section ;
 ;;     var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
 ;;     if (pageName != MGW.page.section[section]) {
 ;;       curr.className = "highlightedInnerTab" ;
 ;;       if (typeof(MGW.page.selectedColor[section]) != "undefined") {
 ;;          curr.style.backgroundColor = MGW.page.selectedColor[section];
 ;;       }
 ;;     }
 ;;   },
 ;;   deSelectInnerTab: function(curr) {
 ;;     var section = curr.section ;
 ;;     var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
 ;;     if (pageName != MGW.page.section[section]) {
 ;;       curr.className = "unselectedInnerTab" ;
 ;;       if (typeof(MGW.page.unselectedColor[section]) != "undefined") {
 ;;          curr.style.backgroundColor = MGW.page.unselectedColor[section];
 ;;       }
 ;;     }
 ;;   },
 ;;  defineInnerTab: function(section,id,selected) {
 ;;       document.getElementById(id).section = section ;
 ;;       if (selected) {
 ;;         document.getElementById(id).className = "selectedInnerTab" ;
 ;;         document.getElementById(id).style.backgroundColor = EWD.page.selectedColor[section] ;
 ;;         var pageName = EWD.utils.getPiece(id,"Tab",1) ;
 ;;         EWD.page.section[section] = pageName ;
 ;;         EWD.page.setInnerTabPage(document.getElementById(id)) ;
 ;;       }
 ;;       else {
 ;;         document.getElementById(id).className = "unselectedInnerTab" ;
 ;;         document.getElementById(id).style.backgroundColor = EWD.page.unselectedColor[section] ;
 ;;       }
 ;;   },
 ;;   setInnerTabPage: function(obj,synch) {
 ;;          var id = obj.id ;
 ;;          var pageName = EWD.utils.getPiece(id,"Tab",1) ;
 ;;          var section = obj.section ;
 ;;          var previousPage = EWD.page.section[section] ;
 ;;          EWD.page.section[section] = pageName ;
 ;;          document.getElementById(previousPage + "Tab").className = "unselectedInnerTab" ;
 ;;          if (typeof(EWD.page.unselectedColor[section]) != "undefined") document.getElementById(previousPage + "Tab").style.backgroundColor = EWD.page.unselectedColor[section];
 ;;          obj.className = "selectedInnerTab" ;
 ;;          if (typeof(EWD.page.selectedColor[section]) != "undefined") {
 ;;             obj.style.backgroundColor = EWD.page.selectedColor[section];
 ;;             document.getElementById(section).style.backgroundColor = EWD.page.selectedColor[section] ;
 ;;          }
 ;;   },
 ;;   selectInnerTab: function(curr) {
 ;;     var section = curr.section ;
 ;;     var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
 ;;     if (pageName != EWD.page.section[section]) {
 ;;       curr.className = "highlightedInnerTab" ;
 ;;       if (typeof(EWD.page.selectedColor[section]) != "undefined") {
 ;;          curr.style.backgroundColor = EWD.page.selectedColor[section];
 ;;       }
 ;;     }
 ;;   },
 ;;   deSelectInnerTab: function(curr) {
 ;;     var section = curr.section ;
 ;;     var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
 ;;     if (pageName != EWD.page.section[section]) {
 ;;       curr.className = "unselectedInnerTab" ;
 ;;       if (typeof(EWD.page.unselectedColor[section]) != "undefined") {
 ;;          curr.style.backgroundColor = EWD.page.unselectedColor[section];
 ;;       }
 ;;     }
 ;;   },
 ;;   loadJSFile: function(src,isDojo) {
 ;;      var fileref=document.createElement('script') ;
 ;;      fileref.setAttribute("type","text/javascript") ;
 ;;      fileref.setAttribute("src", src) ;
 ;;      if (isDojo) fileref.setAttribute("djConfig", "parseOnLoad: true") ;
 ;;      document.getElementsByTagName("head")[0].appendChild(fileref) ;
 ;;   },
 ;;   loadCSSFile: function(filename) {
 ;;      var fileref=document.createElement("link") ;
 ;;      fileref.setAttribute("rel", "stylesheet") ;
 ;;      fileref.setAttribute("type", "text/css") ;
 ;;      fileref.setAttribute("href", filename) ;
 ;;      document.getElementsByTagName("head")[0].appendChild(fileref) ;
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
 ;;      EWD.page.resourceLoaded[url] = true ;
 ;;      }
 ;;   },
 ;;   addStyle: function(cssText) {
 ;;      var elmnt = document.createElement('style') ;
 ;;      elmnt.type = "text/css" ;
 ;;      if (elmnt.styleSheet) {
 ;;        //IE
 ;;        elmnt.styleSheet.cssText = cssText ;
 ;;        document.getElementsByTagName("head")[0].appendChild(elmnt); 
 ;;      }
 ;;      else {
 ;;        var lnk = document.getElementsByTagName("head")[0].appendChild(elmnt); 
 ;;        var txtNode = document.createTextNode(cssText) ;
 ;;        lnk.appendChild(txtNode);
 ;;      }
 ;;   }
 ;;};
 ;;EWD.page.chartIndex = {} ;
 ;;EWD.utils = {
 ;;   replace: function (string,text,by) {
 ;;      var strLength = string.length, txtLength = text.length;
 ;;      if ((strLength == 0) || (txtLength == 0)) return string;
 ;;      var i = string.indexOf(text);
 ;;      if ((!i) && (text != string.substring(0,txtLength))) return string;
 ;;      if (i == -1) return string;
 ;;      var newstr = string.substring(0,i) + by;
 ;;      if (i+txtLength < strLength) newstr = replace(string.substring(i+txtLength,strLength),text,by);
 ;;      return newstr;
 ;;   },
 ;;   findPosX: function (obj) {
 ;;      var curleft = 0;
 ;;      if(obj.offsetParent) while(1) {
 ;;         curleft += obj.offsetLeft;
 ;;         if(!obj.offsetParent) break;
 ;;         obj = obj.offsetParent;
 ;;      }
 ;;      else if(obj.x) curleft += obj.x;
 ;;      return curleft;
 ;;   },
 ;;   findPosY: function (obj) {
 ;;      var curtop = 0;
 ;;      if(obj.offsetParent) while(1) {
 ;;         curtop += obj.offsetTop;
 ;;         if(!obj.offsetParent) break;
 ;;         obj = obj.offsetParent;
 ;;      }
 ;;      else if(obj.y) curtop += obj.y;
 ;;      return curtop;
 ;;   },
 ;;   getPiece: function(refStr,delim,pieceNo) {
 ;;      var tempArray;
 ;;      if (refStr == "") return "";
 ;;      if (delim == "") return string;
 ;;      if (pieceNo == "") return string;
 ;;      tempArray = refStr.split(delim);
 ;;      return tempArray[pieceNo - 1];
 ;;   },
 ;;   contains: function(inString,subString) {
 ;;      if (inString.indexOf(subString) == -1) return false;
 ;;      return true;
 ;;   },
 ;;   getBrowserInfo: function() {
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
 ;;      if (EWD.utils.contains(sig,"MSIE 9")) EWD.browserType="ie9" ;
 ;;      EWD.browserOS="linux" ;
 ;;      if (EWD.utils.contains(sig,"Windows NT 5.1")) EWD.browserOS="xp" ;
 ;;      if (EWD.utils.contains(sig,"Windows NT 5.0")) EWD.browserOS="2000" ;
 ;;      if (EWD.utils.contains(sig,"Windows NT 6")) EWD.browserOS="vista" ;
 ;;      EWD.browser = {};
 ;;      EWD.browser.isHTML5 = true;
 ;;      if (typeof(localStorage) == 'undefined') EWD.browser.isHTML5 = false;
 ;;   },
 ;;   isInteger: function(sText) {
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
 ;;   },
 ;;   getOption: function(fieldName) {
 ;;     var obj = document.getElementById(fieldName) ;
 ;;     return obj.options[obj.selectedIndex].value;
 ;;   },
 ;;   sleep: function(delay) {
 ;;     var start = new Date().getTime();
 ;;    while (new Date().getTime() < start + delay);
 ;;   }
 ;;};
 ;;EWD.utils.getBrowserInfo() ;
 ;;    
 ;;***END***
 ;;
