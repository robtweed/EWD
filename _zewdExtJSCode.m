%zewdExtJSCode	; Ext-JS tag processor fixed code
 ;
 ; Product: Enterprise Web Developer (Build 907)
 ; Build Date: Fri, 20 Apr 2012 11:29:32
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
gridCheckbox ;
	;;Ext.grid.CheckColumn = function(config){
	;;  Ext.apply(this, config);
	;;  if(!this.id){
	;;    this.id = Ext.id();
	;;  }
	;;  this.renderer = this.renderer.createDelegate(this);
	;;};
	;;Ext.grid.CheckColumn.prototype ={
	;;  init : function(grid){
	;;    this.grid = grid;
	;;    this.grid.on('render', function(){
	;;      var view = this.grid.getView();
	;;      view.mainBody.on('mousedown', this.onMouseDown, this);
	;;    }, this);
	;;  },
    ;;  onMouseDown : function(e, t){
	;;    if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	;;      e.stopEvent();
	;;      var index = this.grid.getView().findRowIndex(t);
	;;      var record = this.grid.store.getAt(index);
	;;      record.set(this.dataIndex, !record.data[this.dataIndex]);
	;;      EWD.ext.updateStore(EWD.ext.storeName[EWD.utils.getPiece(this.grid.container.id,"ext",2)],record.data["col0"],this.dataIndex,record.data[this.dataIndex],true)
	;;    }
	;;  },
	;;  renderer : function(v, p, record){
	;;    p.css += ' x-grid3-check-col-td'; 
    ;;    return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    ;;  }
	;;};
	;;***END***
	;;
zextUpdateSession
	;;<ewd:config pageType="ajax" isFirstPage="false" prepagescript="updateSession^%zewdExtJS">
	;;<span>&nbsp;</span>
	;;***END***
	;;
EWDext
	;;EWD.ext = {
	;;   treeClickHandler: {},
	;;   openDesktopWindow: function(title,pageName,width,height,dsName,treeValue,currentPageName) {
	;;      if (typeof(windowIndex)=="undefined") windowIndex = 0 ;
	;;      windowIndex++ ;
	;;      if (!dsName) dsName='';
	;;      if (!treeValue) treeValue='';
	;;      var win = {
	;;        windowId: "window" + windowIndex,
	;;        text:title,
	;;        fragmentName:pageName,
	;;        width:width,
	;;        height:height,
	;;        dsName:dsName,
	;;        treeValue:treeValue,
	;;        currentPageName:currentPageName
	;;      };
	;;      theDesktop.getModule('adhoc').createWindow(win) ;
	;;   },
	;;   openWindow: function(win,fragmentName,index,nvpValue) {
	;;      var nvp="" ;
	;;      if (typeof(fragmentName)=="undefined") {
	;;        fragmentName = win.src ;
	;;        windowIndex = 0 ;
	;;      }
	;;      if (typeof(nvpValue)!="undefined") {
	;;        nvp="windowNvp=" + nvpValue ;
	;;      }
	;;      if (typeof(index)!="undefined") windowIndex = index ;
	;;      if (typeof(windowIndex)=="undefined") windowIndex = 0 ;
	;;      windowIndex++ ;
	;;      win.windowId = "window" + windowIndex ;
	;;      if (!win.title) win.title = "New Window" ;
	;;      if (!win.width) win.width = 300 ;
	;;      if (!win.height) win.height = 400 ;
	;;      if (!win.html) win.html = "<div style='background-color:#ffffff;' id='" + win.windowId + "'>Please wait...</div>" ;
	;;      win.listeners = {activate:{fn:function(e){EWD.ext.loadWindowFragment(fragmentName,win.windowId,'','',win.currentPageName,nvp);}}} ;
	;;      EWD.ext.window = new Ext.Window(win) ;
	;;      EWD.ext.window.show() ;
	;;   },
	;;   validateGridEdit: function(store,editEvent,send) {
	;;      var grid = Ext.getCmp(editEvent.grid.id) ;
	;;      var col0 = grid.getColumnModel().getDataIndex(0) ;
	;;      var row = editEvent.record.data[col0] ;
	;;      var column = EWD.ext.columnIndex[editEvent.field] ;
	;;      var value = editEvent.value ;
	;;      var error = EWD.ext.updateStore(store,row,editEvent.field,value,send) ;
	;;      if (error.charAt(0) == "{") {
	;;        error = EWD.utils.getPiece(error,"{",2) ;
	;;        error = error.substring(0,error.length-1);
	;;        eval(error) ;
	;;      }
	;;      else if (error != "") {
	;;         Ext.Msg.alert("Error",error) ;
	;;         editEvent.record.set(editEvent.field,editEvent.originalValue) ;
	;;         editEvent.cancel = true ;
	;;      }
	;;      else { 
	;;         editEvent.cancel = false ;
	;;         editEvent.record.set(editEvent.field,editEvent.value) ;
	;;      }
	;;   },
	;;   updateStore: function(store,row,columnName,value,send) {
	;;      var column = EWD.ext.columnIndex[columnName] ;
	;;      var x = store + "[row][column] = value" ;
	;;      eval(x) ;
	;;      EWD.ext.error = "" ;
	;;      if (send) EWD.ext.updateSession(store,row,column,value) ;
	;;      return EWD.ext.error ;
	;;   },
	;;   columnIndex: {},
	;;   storeName: {},
	;;   getSelectedGridRecord: function(selectedRecord) {
	;;       var currentRow = {};
	;;       for (var col=0;col<selectedRecord.fields.length;col++) {
	;;         currentRow[col] = selectedRecord.get(selectedRecord.fields.keys[col]) ;
	;;       }
	;;       return currentRow ;
	;;   },
	;;   showField: function(obj) {
	;;       obj.getEl().up('.x-form-item').setDisplayed(true);
	;;   },
	;;   hideField: function(obj) {
    ;;       obj.getEl().up('.x-form-item').setDisplayed(false);
    ;;   }
	;;} ;
	;;***END***
updateSession ;
	;;EWD.ext.updateSession=function(sessionName,row,column,value) { 
	;;  ewd:updateSession^%zewdExtJS(sessionName,row,column,value) ;
	;;};
	;;***END***
	;;
desktop ;
	;;theDesktop.adhocModule = Ext.extend(Ext.app.Module, {
	;;    id:'adhoc',
	;;    init : function(){
	;;        this.launcher = {
	;;            text:'',
	;;            scope:this,
	;;            windowId:windowIndex
	;;        }
    ;;    },
	;;    createWindow : function(src){
	;;        var desktop = this.app.getDesktop();
	;;        var winNo = EWD.utils.getPiece(src.windowId,"window",2) ;
	;;        var win = desktop.getWindow('ewdwin'+winNo);
	;;        if (!src.backgroundColor) src.backgroundColor = "#ffffff" ;
	;;        if(!win){
	;;            win = desktop.createWindow({
	;;                id: 'ewdwin'+winNo,
	;;                title:src.text,
	;;                width:src.width,
	;;                height:src.height,
	;;                html : "<div style='background-color:" + src.backgroundColor + "' id='" + src.windowId + "'>Please wait...</div>",
	;;                iconCls: 'panel',
	;;                shim:false,
	;;                animCollapse:false,
	;;                constrainHeader:true,
	;;                listeners:{activate:{fn:function(e){EWD.ext.loadWindowFragment(src.fragmentName,src.windowId,src.dsName,src.treeValue,src.currentPageName);}}}
	;;            });
	;;        }
	;;        win.show();
	;;    }
	;;});
	;;***END***
	;;
zextDesktopLoginForm
	;;<ewd:config pageType="ajax" applyTemplate="false">
	;;<span>
	;;<script language="javascript">
	;;theDesktop.desktop.taskbar.startBtn.disable();
	;;document.getElementById("username").focus() ;
	;;</script>
	;;<form method="POST" action="ewd">
	;;<table border=0 align="center">
	;;<tr><td style="font-size:10pt">Username</td>
	;;<td style="font-size:10pt"><input type="text" name="username" focus="true" ></td>
	;;</tr><tr><td style="font-size:10pt">Password </td>
	;;<td style="font-size:10pt"><input type="password" name="password"></td>
	;;</tr><tr><td align="center" style="font-size:10pt" colspan="2"><input type="submit" class="actionButton" name="Submit" ajax="true" targetId="nullId" value="Login" action="zActionz" nextpage="zextDesktopDestroyWindow">
	;;</tr>
	;;</table>
	;;</form>
	;;</span>
	;;***END***
	;;
zextDesktopWindowLoader
	;;<ewd:config isFirstPage="false" pageType="ajax" prePageScript="desktopWindowLoader^%zewdExtJS2">
	;;<span>Error!  You're not allowed to load that page!</span>
	;;***END***
	;;
zextDesktopDestroyWindow
	;;<ewd:config pageType="ajax" applyTemplate="false">
	;;<script language="javascript">
	;;EWD.ext.window.destroy() ;
	;;theDesktop.desktop.taskbar.startMenu.setTitle('<?= #username ?>');
	;;theDesktop.desktop.taskbar.startBtn.enable();
	;;</script>
	;;<div>Please wait...</div>
	;;***END***
	;;
