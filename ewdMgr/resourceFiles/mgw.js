var MGW = {} ;

MGW.downloader = {} ;
MGW.page = {
  currentPage: "compiler",
  section: new Array(),
  selectedColor: new Array(),
  unselectedColor: new Array(),
  tierLevel: new Array(),

  selectTab: function(curr) {
    var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
    if (pageName != MGW.page.currentPage) {
      curr.className = "highlightedTab" ;
    }
  },

  deSelectTab: function(curr) {
    var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
    if (pageName != MGW.page.currentPage) {
      curr.className = "unselectedTab" ;
    }
  },

  selectInnerTab: function(curr) {
    var section = curr.section ;
    var styleType = MGW.page.getStyleType(section) ;
    var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
    if (pageName != MGW.page.section[section]) {
      curr.className = "highlightedInnerTab" + styleType ;
      if (typeof(MGW.page.selectedColor[section]) != "undefined") {
         curr.style.backgroundColor = MGW.page.selectedColor[section];
      }
    }
  },

  deSelectInnerTab: function(curr) {
    var section = curr.section ;
    var styleType = MGW.page.getStyleType(section) ;
    var pageName = EWD.utils.getPiece(curr.id,"Tab",1) ;
    if (pageName != MGW.page.section[section]) {
      curr.className = "unselectedInnerTab" + styleType ;
      if (typeof(MGW.page.unselectedColor[section]) != "undefined") {
         curr.style.backgroundColor = MGW.page.unselectedColor[section];
      }
    }
  },
  clearPanel: function(name) {
    document.getElementById(name).innerHTML = "" ;
  },
  getTabPage: function(pageName,synch) {
         EWD.ajax.base = "/main/" ;
         EWD.ajax.getFragment(pageName + ".html","pageBody",synch) ;
         var previousPage = MGW.page.currentPage ;
         MGW.page.currentPage = pageName ;
         document.getElementById(previousPage + "Tab").className = "unselectedTab" ;
         document.getElementById(pageName + "Tab").className = "selectedTab" ;
  },
  getInnerTabPage: function(obj,synch) {
         EWD.ajax.base = "/main/" ;
         var id = obj.id ;
         var pageName = EWD.utils.getPiece(id,"Tab",1) ;
         var section = obj.section ;
         var styleType = MGW.page.getStyleType(section) ;
         // ******
         synch = "synch" ; 
         // ******
         EWD.ajax.getFragment(pageName + ".html",section,synch) ;
         var previousPage = MGW.page.section[section] ;
         MGW.page.section[section] = pageName ;
         document.getElementById(previousPage + "Tab").className = "unselectedInnerTab" + styleType ;
         if (typeof(MGW.page.unselectedColor[section]) != "undefined") document.getElementById(previousPage + "Tab").style.backgroundColor = MGW.page.unselectedColor[section];
         obj.className = "selectedInnerTab" + styleType ;
         if (typeof(MGW.page.selectedColor[section]) != "undefined") {
            obj.style.backgroundColor = MGW.page.selectedColor[section];
            document.getElementById(section).style.backgroundColor = MGW.page.selectedColor[section] ;
         }
  },
  defineInnerTab: function(section,id,selected) {
      EWD.ajax.base = "/main/" ;
      document.getElementById(id).section = section ;
      if (selected) {
        var styleType = MGW.page.getStyleType(section) ;
        document.getElementById(id).className = "selectedInnerTab" + styleType ;
        //document.getElementById(id).style.backgroundColor = MGW.page.selectedColor[section] ;
        var pageName = EWD.utils.getPiece(id,"Tab",1) ;
        MGW.page.section[section] = pageName ;
        MGW.page.getInnerTabPage(document.getElementById(id)) ;
        document.getElementById(section).className = "innerPanel" + styleType ;
      }
      else {
        var styleType = MGW.page.getStyleType(section) ;
        //if (id == "ewdDownloadMenuTab") alert("section = " + section + " ; styleType = " + styleType + " ; tierLevel=" + MGW.page.tierLevel[section]) ;
        document.getElementById(id).className = "unselectedInnerTab" + styleType ;
        //document.getElementById(id).style.backgroundColor = MGW.page.unselectedColor[section] ;
      }
  },
  getInnerPage: function(page) {
     var tabPage = page + "Tab" ;
     var obj = document.getElementById(tabPage) ;
     ;var str = "MGW.page.getInnerTabPage(document.getElementById('" + tabPage + "')) ;" ;
     ;setTimeout(str,100) ;
     MGW.page.getInnerTabPage(obj,"synch") ;
  },
  jumpTo: function(path) {
    var page = EWD.utils.getPiece(path,"/",1) ;
    MGW.page.getTabPage(page,"synch") ;
    var pieceNo = 2 ;
    while (typeof(EWD.utils.getPiece(path,"/",pieceNo)) != "undefined") {
      page = EWD.utils.getPiece(path,"/",pieceNo) ;
      MGW.page.getInnerPage(page) ;
      pieceNo++ ;
    }
  },
  help: function(obj,textid,width,method,x,y) {
    if (textid != "") {
       var text = document.getElementById(textid).innerHTML ;
    }
    else {
      eval('var text = ' + method) ;
    }
    if (!x) var xcoord = EWD.utils.findPosX(obj) ;
    else var xcoord = x ;
    if (!y) var ycoord = EWD.utils.findPosY(obj) ;
    else var ycoord = y ;
    var helpPanel = document.getElementById('helpPanel')
    helpPanel.className = "bubbleHelpPanelOn" ;
    helpPanel.style.width = width ;
    helpPanel.style.left = xcoord + 10 ;
    helpPanel.style.top = ycoord + 10 ;
    helpPanel.innerHTML = text ;
     var height = helpPanel.offsetWidth;
    var helpShim = document.getElementById('helpShim') ;
    helpShim.style.left = xcoord + 10 ;
    helpShim.style.top = ycoord + 10 ;
     helpShim.style.width = helpPanel.clientWidth + 3;
     helpShim.style.height = helpPanel.clientHeight + 2;
    helpShim.style.display = "inline" ;
  },
  helpOff: function() {
    document.getElementById('helpPanel').className = "alertPanelOff" ;
    document.getElementById('helpShim').style.display = "none" ;
  },
  getStyleType: function(section) {
    if (typeof(MGW.page.tierLevel[section]) == "undefined") return "" ;
    var styleType = "Odd" ;
    if (MGW.page.tierLevel[section]%2 == 0) {
      //style = "Even" ;
      styleType = "" ;
    }
    return styleType ;
  }
};





