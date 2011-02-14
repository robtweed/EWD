%zewdSTJS ; Sencha Touch Main Static Javascript file
 ;
 ; Product: Enterprise Web Developer (Build 851)
 ; Build Date: Mon, 14 Feb 2011 15:50:55
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
stJS ;;
 ;;EWD.sencha={
 ;;  widget:{},
 ;;  widgetIndex:{},
 ;;  parentPanel:{},
 ;;  popupParams:{},
 ;;  handlerByClass:{},
 ;;  onListItemTap:{},
 ;;  blurFields: function(obj,ignoreId){
 ;;     var inputs = obj.getElementsByTagName('input');
 ;;     for (var i=0;i<inputs.length;i++) {
 ;;        if (!ignoreId) {
 ;;           inputs[i].blur();
 ;;        }
 ;;        else {
 ;;           if (inputs[i].id != ignoreId) inputs[i].blur();
 ;;        }
 ;;     }
 ;;     //EWD.sencha.restartSessionTimer = true;
 ;;  },
 ;;  defineParentWidget: function(pageName,parentWidgetId) {
 ;;     EWD.sencha.parentPanel[pageName] = Ext.getCmp(parentWidgetId);
 ;;  },
 ;;  removeWidgetById: function(id) {
 ;;     Ext.getCmp(id).destroy();
 ;;  },
 ;;  addWidget: function(currentPage, widgetId) {
 ;;     if (EWD.sencha.parentPanel[currentPage]) {
 ;;        EWD.sencha.parentPanel[currentPage].add(Ext.getCmp(widgetId));
 ;;        EWD.sencha.parentPanel[currentPage].doLayout();
 ;;        delete EWD.sencha.parentPanel[currentPage];
 ;;     }
 ;;     //EWD.sencha.restartSessionTimer = true;
 ;;  },
 ;;  openPopup: function(params) {
 ;;     var thePanel = Ext.getCmp(params.panelId);
 ;;     if (params.by) {
 ;;        thePanel.showBy(params.by);
 ;;     }
 ;;     else {
 ;;        thePanel.show();
 ;;     }
 ;;     if (Ext.is.Phone) {
 ;;        thePanel.setSize({width:320});
 ;;        thePanel.setCentered(true);
 ;;     }
 ;;     else {
 ;;        thePanel.setPosition(params.x,params.y);
 ;;     }
 ;;     if (params.draggable) thePanel.setDraggable(true);
 ;;     if (params.fn) params.fn();
 ;;  },
 ;;  loadListData: function(store,arrayName) {
 ;;     for (var i=0; i < arrayName.length; i++) {
 ;;        store.add(arrayName[i]);
 ;;     }
 ;;     //EWD.sencha.restartSessionTimer = true;
 ;;  },
 ;;  loadCardPanel: function(panelId) {
 ;;     //EWD.sencha.restartSessionTimer = true;
 ;;     if (EWD.sencha.cardPanel) {
 ;;        if (EWD.sencha.cardPanel.id) {
 ;;          if (EWD.sencha.cardPanel.id !== '') {
 ;;            var cp=Ext.getCmp(EWD.sencha.cardPanel.id);
 ;;            cp.add(Ext.getCmp(panelId));
 ;;            cp.doLayout();
 ;;            EWD.sencha.cardPanel.prevCard = cp.getActiveItem();
 ;;            cp.setActiveItem(Ext.getCmp(panelId), EWD.sencha.cardPanel.transition);
 ;;            if (EWD.sencha.backbuttonId) {
 ;;              var backButton=Ext.getCmp(EWD.sencha.backbuttonId);
 ;;              backButton.show();
 ;;              backButton.setHandler(function(btn,e) {
 ;;                Ext.getCmp(panelId).destroy();
 ;;                Ext.getCmp(EWD.sencha.cardPanel.id).setActiveItem(EWD.sencha.cardPanel.prevCard, {type:EWD.sencha.cardPanel.transition, direction: 'right'});
 ;;                backButton.hide();
 ;;              });
 ;;            }
 ;;          }
 ;;        }
 ;;     }
 ;;  },
 ;;  onListImageClick: function(evt) {
 ;;     if (EWD.sencha.handlerByClass[evt.target.className]) {
 ;;        EWD.sencha.imageHandler = EWD.sencha.handlerByClass[evt.target.className];
 ;;        EWD.sencha.cancelListItemTap = true;
 ;;        var data = evt.target.getAttribute('data');
 ;;        eval(EWD.sencha.imageHandler + '(evt,evt.target.id,data);');
 ;;     }
 ;;  },
 ;;  listItemTapProxyHandler: function() {
 ;;     if (!EWD.sencha.cancelListItemTap) {
 ;;	       var index = EWD.sencha.itemTapProxyData.index;
 ;;	       var record = EWD.sencha.itemTapProxyData.record;
 ;;	       var listId = EWD.sencha.itemTapProxyData.listId;
 ;;        eval(EWD.sencha.onListItemTap[listId] + '(index,record);');
 ;;     }
 ;;     else {
 ;;        delete EWD.sencha.cancelListItemTap;
 ;;     }
 ;;  },
 ;;  listItemTapProxy: function(index,record,listId) {
 ;;	    EWD.sencha.itemTapProxyData = {index:index,record:record,listId:listId};
 ;;     setTimeout('EWD.sencha.listItemTapProxyHandler()',250);
 ;;  },
 ;;  timer: function(timeout,action) {
 ;;     var timeLeft=timeout;
 ;;     EWD.sencha.sessionTimeout = timeout;
 ;;     EWD.sencha.restartSessionTimer = false;
 ;;     closedownSession = function() {
 ;;        if (EWD.sencha.restartSessionTimer) {
 ;;          timeLeft = EWD.sencha.sessionTimeout;
 ;;          EWD.sencha.restartSessionTimer = false;
 ;;        }
 ;;        timeLeft--;
 ;;        if (timeLeft < 20) {
 ;;          if (action === 'reload') {
 ;;            window.location.reload();
 ;;          }
 ;;          else {
 ;;            EWD.ajax.getPage({page:action});
 ;;          }
 ;;          return;
 ;;        }
 ;;        //try {Ext.getCmp("topToolbar").setTitle(timeLeft);}
 ;;        //catch(error) {}
 ;;        setTimeout("closedownSession()",1000);
 ;;     }
 ;;     closedownSession();
 ;;  }
 ;;};
 ;;
 ;;***END***
 ;;
