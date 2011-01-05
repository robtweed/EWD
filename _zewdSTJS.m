%zewdSTJS ; Sencha Touch Main Static Javascript file
 ;
 ; Product: Enterprise Web Developer (Build 835)
 ; Build Date: Wed, 05 Jan 2011 11:13:34
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
ewdST ;
 ;;Ext.ns('Ext.ux');
 ;;EWD.sencha ={
 ;;    mainMenu: [{ 
 ;;       cls: 'launchscreen',
 ;;       text:"",
 ;;       leaf: true
 ;;    }],
 ;;
 ;;    detailButtonText:"Detail",
 ;;
 ;;    loadCard: function(item) {
 ;;       var card = EWD.sencha.card;
 ;;       if (item.displayBackButton == undefined) item.displayBackButton = true;
 ;;       if (item.displayDetailButton == undefined) item.displayDetailButton = true;
 ;;       var ui = EWD.sencha.Main.ui;
 ;;       ui.setCard(card, item.animation || 'slide');
 ;;       ui.currentCard = card;
 ;;       if (item.text) {
 ;;          ui.navigationBar.setTitle(item.text);
 ;;       }
 ;;       if (Ext.is.Phone) {
 ;;          if (item.displayBackButton) {
 ;;             ui.backButton.show();
 ;;          }
 ;;          else {
 ;;             ui.backButton.hide();
 ;;          }
 ;;          ui.navigationBar.doLayout();
 ;;       }
 ;;       ui.fireEvent('navigate', ui, item, EWD.sencha.list);
 ;;       if (item.displayDetailButton) {
 ;;         EWD.sencha.Main.detailButton.show();
 ;;       }
 ;;       else {
 ;;         EWD.sencha.Main.detailButton.hide();
 ;;       }
 ;;    },
 ;;
 ;;    replaceNavigationMenu: function() {
 ;;       if (Ext.orientation == 'portrait') EWD.sencha.navigationPanel.show();
 ;;       //if (!EWD.sencha.navigationPanel.getActiveItem()) return;
 ;;       //EWD.sencha.navigationPanel.getActiveItem().removeAll(true);
 ;;       //alert(1);
 ;;       //EWD.sencha.listStore.update(EWD.sencha.mainMenu);
 ;;       //EWD.sencha.navigationPanel.getActiveItem().add(EWD.sencha.mainMenu);
 ;;       //alert(5);
 ;;       //EWD.sencha.navigationPanel.getActiveItem().doLayout();
 ;;       EWD.sencha.navigationPanel.store.repopulate(EWD.sencha.mainMenu);
 ;;       if (!Ext.is.Phone) {
 ;;          if (Ext.orientation == 'portrait') EWD.sencha.navigationPanel.hide();
 ;;       }
 ;;    },
 ;;
 ;;    navigationOff: function() {
 ;;       if (!Ext.is.Phone) {
 ;;          EWD.sencha.hideNavigationButton = true;
 ;;          EWD.sencha.navigationButton.hide();
 ;;          if (Ext.orientation == 'portrait') {
 ;;             EWD.sencha.navigationPanel.hide();
 ;;             EWD.sencha.startOrientation = 'portrait';
 ;;          }
 ;;          else {
 ;;             //EWD.sencha.navigationPanel.hide();
 ;;             //EWD.sencha.Main.ui.removeDocked(EWD.sencha.Main.navigationPanel, false);
 ;;             //EWD.sencha.navigationPanel.setFloating(true);
 ;;             EWD.sencha.startOrientation = 'landscape';
 ;;          }
 ;;       }
 ;;    },
 ;;
 ;;    navigationOn: function(params) {
 ;;       if (!params) params = {};
 ;;       var ui = EWD.sencha.Main.ui;
 ;;       if (Ext.is.Phone) {
 ;;           ui.setCard(ui.navigationPanel, 'flip');
 ;;           ui.currentCard = ui.navigationPanel;
 ;;           ui.navigationBar.setTitle(ui.title);
 ;;           EWD.sencha.Main.detailButton.hide();
 ;;           ui.navigationBar.doLayout();
 ;;           //ui.fireEvent('navigate', ui, ui.navigationPanel.activeItem, ui.navigationPanel);
 ;;       }
 ;;       else {
 ;;           EWD.sencha.hideNavigationButton = false;
 ;;           EWD.isLogin = false;
 ;;           if (Ext.orientation == 'portrait') EWD.sencha.navigationButton.show();
 ;;           if (EWD.sencha.startOrientation == 'landscape') {
 ;;              document.getElementById('st-uui-nullId').style.display = '';
 ;;              EWD.sencha.navigationPanel.setFloating(false);
 ;;              if (!EWD.sencha.hideNavigationButton) EWD.sencha.navigationPanel.show(false);
 ;;              EWD.sencha.navigationButton.hide();
 ;;              EWD.sencha.Main.ui.insertDocked(0, EWD.sencha.navigationPanel);
 ;;           }
 ;;           else {
 ;;              if (Ext.orientation != 'portrait') {
 ;;                 EWD.sencha.navigationPanel.show();
 ;;                 EWD.sencha.navigationPanel.setFloating(false);
 ;;                 EWD.sencha.Main.ui.insertDocked(0, EWD.sencha.navigationPanel); 
 ;;              }
 ;;           }
 ;;           if (params.displayCard == undefined) params.displayCard = true;
 ;;           if (params.displayCard) EWD.sencha.displayCard();
 ;;       }
 ;;       if (EWD.sencha.detailButtonText) EWD.sencha.Main.detailButton.setText(EWD.sencha.detailButtonText);
 ;;       if (params.navigationButtonText) {
 ;;         EWD.sencha.navigationButton.setText(params.navigationButtonText);
 ;;         if (!Ext.is.Phone) {
 ;;            EWD.sencha.navigationPanel.toolbar.setTitle(params.navigationButtonText);
 ;;         }
 ;;       }
 ;;
 ;;       if (params.displayBackButton == undefined) params.displayBackButton = true;
 ;;       if (params.displayDetailButton == undefined) params.displayDetailButton = true;
 ;;
 ;;       if (params.displayDetailButton) {
 ;;         EWD.sencha.Main.detailButton.show();
 ;;       }
 ;;       else {
 ;;         EWD.sencha.Main.detailButton.hide();
 ;;       }
 ;;
 ;;       if (params.displayBackButton) {
 ;;         EWD.sencha.Main.ui.backButton.show();
 ;;       }
 ;;       else {
 ;;         EWD.sencha.Main.ui.backButton.hide();
 ;;       }
 ;;       EWD.sencha.Main.ui.navigationBar.doComponentLayout();
 ;;       if (!Ext.is.Phone) {
 ;;          if (Ext.orientation == 'portrait') EWD.sencha.navigationPanel.show();
 ;;       }
 ;;    },
 ;;
 ;;    cardStackPush: function(card) {
 ;;       if (!EWD.sencha.cardStack) EWD.sencha.cardStack = [];
 ;;       var len = EWD.sencha.cardStack.push(card);
 ;;       return len;
 ;;    },
 ;;
 ;;    cardStackPop: function() {
 ;;       var card = EWD.sencha.cardStack.pop();
 ;;       if (EWD.sencha.cardStack.length == 0) delete EWD.sencha.cardStack ;
 ;;       return card;
 ;;    },
 ;;
 ;;    onToolbarBack: function() {
 ;;       if (EWD.sencha.cardStack) {
 ;;          var dummy = EWD.sencha.cardStackPop() ;
 ;;          if (EWD.sencha.cardStack.length > 0) {
 ;;             prevCard = EWD.sencha.cardStack[EWD.sencha.cardStack.length - 1];
 ;;             EWD.sencha.card = prevCard;
 ;;          }
 ;;          EWD.sencha.Main.ui.setCard(prevCard, {type: 'slide', direction: 'right'});
 ;;          EWD.sencha.Main.ui.currentCard = prevCard;
 ;;          if (Ext.is.Phone) {
 ;;             if (EWD.sencha.keepDetailButton) {
 ;;                EWD.sencha.Main.detailButton.show();
 ;;                EWD.sencha.Main.detailButton.setText(EWD.sencha.detailButtonText);
 ;;                EWD.sencha.Main.ui.navigationBar.doComponentLayout();
 ;;             }
 ;;          }
 ;;          if (EWD.sencha.contentEl) {
 ;;             document.getElementById(EWD.sencha.contentEl).outerHTML = '';
 ;;             delete EWD.sencha.contentEl;
 ;;          }
 ;;       }
 ;;    },
 ;;
 ;;    openPopup: function(xparams) {
 ;;       var animation = 'flip';
 ;;       if (xparams.animation) animation = xparams.animation;
 ;;       if (xparams.src) {
 ;;          var src = xparams.src;
 ;;          if (xparams.nvp) {
 ;;             var sep = "?" ;
 ;;             if (EWD.utils.contains(src,"?")) sep = "&";
 ;;             src = src + sep + xparams.nvp;
 ;;          }
 ;;          EWD.ajax.makeRequest(src,'codeBox','get','','');
 ;;       }
 ;;       if (xparams.func) eval(xparams.func);
 ;;       if (!Ext.is.Phone) {
 ;;            if (xparams.showByEl) {
 ;;               EWD.sencha.detailPanel.showBy(xparams.showByEl, 'fade');
 ;;            }
 ;;            else {
 ;;               if (xparams.x) EWD.sencha.detailPanel.x = xparams.x;
 ;;               if (xparams.y) EWD.sencha.detailPanel.y = xparams.y;
 ;;               EWD.sencha.detailPanel.show();
 ;;            }
 ;;            var height = EWD.sencha.codePanel.height;
 ;;            if (xparams.height) height = xparams.height;
 ;;            var width = EWD.sencha.codePanel.width ;
 ;;            if (xparams.width) width = xparams.width;
 ;;            EWD.sencha.detailPanel.width = width;
 ;;            EWD.sencha.detailPanel.height = height;
 ;;            if (xparams.showByEl) {
 ;;              if (xparams.width != EWD.sencha.codePanel.width) {
 ;;                EWD.sencha.detailPanel.showBy(xparams.showByEl, 'fade');
 ;;              }
 ;;            }
 ;;            else {
 ;;              if (xparams.width != EWD.sencha.codePanel.width) {
 ;;                 EWD.sencha.detailPanel.show();
 ;;              }
 ;;            }
 ;;       }
 ;;       else {
 ;;            var ui = EWD.sencha.Main.ui ;
 ;;            if (EWD.sencha.Main.detailActive) {
 ;;                ui.setCard(ui.currentCard, Ext.is.Android ? false : animation);
 ;;                EWD.sencha.Main.detailActive = false;
 ;;                ui.navigationBar.setTitle(EWD.sencha.Main.currentTitle);
 ;;                EWD.sencha.Main.detailButton.setText(EWD.sencha.currentItem.button.text);
 ;;            }
 ;;            else {
 ;;                ui.setCard(EWD.sencha.detailPanel, Ext.is.Android ? false : animation);
 ;;                EWD.sencha.Main.detailActive = true;
 ;;                EWD.sencha.Main.currentTitle = ui.navigationBar.title;
 ;;                if (xparams.title) ui.navigationBar.setTitle(xparams.title);
 ;;                EWD.sencha.Main.detailButton.setText(EWD.sencha.Main.currentTitle);
 ;;                if (xparams.buttonText) {
 ;;                  EWD.sencha.Main.detailButton.setText(xparams.buttonText);
 ;;                }
 ;;                else {
 ;;                  EWD.sencha.Main.detailButton.prevText = EWD.sencha.Main.detailButton.text ;
 ;;                }
 ;;                EWD.sencha.Main.detailButton.show();
 ;;                EWD.sencha.Main.detailButton.isHidden = false;
 ;;                if (xparams.hideDetailButton) EWD.sencha.Main.detailButton.isHidden = true;
 ;;            }
 ;;            ui.navigationBar.doLayout();
 ;;       }
 ;;       if (xparams.scroll) {
 ;;          EWD.sencha.detailPanel.scroll = xparams.scroll;
 ;;       }
 ;;       EWD.sencha.detailPanel.scroller.scrollTo({x: 0, y: 0});
 ;;    },
 ;;
 ;;    displayCard: function(params) {
 ;;       if (!params) params = {};
 ;;       EWD.sencha.cardStackPush(EWD.sencha.card);
 ;;       if (params.animation == undefined) params.animation = 'slide';
 ;;       if (params.displayDetailButton == undefined) params.displayDetailButton = true;
 ;;       if (params.displayBackButton == undefined) params.displayBackButton = true;
 ;;       EWD.sencha.loadCard({animation:params.animation,displayDetailButton:params.displayDetailButton,displayBackButton:params.displayBackButton});
 ;;       EWD.sencha.Main.detailButton.setText(EWD.sencha.detailButtonText);
 ;;       EWD.sencha.Main.ui.navigationBar.doComponentLayout();
 ;;       if (params.backButtonText) EWD.sencha.Main.ui.backButton.setText(params.backButtonText);
 ;;    },
 ;;
 ;;    noLoginMode: function(menuTitle) {
 ;;       EWD.sencha.navigationOn();
 ;;       EWD.sencha.Main.detailButton.setText(EWD.sencha.detailButtonText);
 ;;       EWD.sencha.navigationButton.setText(menuTitle);
 ;;       EWD.sencha.Main.detailButton.hide();
 ;;       EWD.sencha.Main.ui.backButton.hide();
 ;;       EWD.sencha.Main.ui.navigationBar.doComponentLayout();
 ;;       if (Ext.orientation == 'portrait') EWD.sencha.navigationPanel.show();
 ;;       if (!Ext.is.Phone) {
 ;;          EWD.sencha.navigationPanel.toolbar.setTitle(menuTitle);
 ;;          if (Ext.orientation == 'portrait') EWD.sencha.navigationPanel.hide();
 ;;       }
 ;;       else {
 ;;          EWD.sencha.MenuToolbar.hide();
 ;;          EWD.sencha.navigationPanel.doComponentLayout();
 ;;       }
 ;;    },
 ;;
 ;;    blurFields: function(obj,ignoreId) {    
 ;;       var inputs = obj.getElementsByTagName('input');
 ;;       for (var i=0 ; i<inputs.length; i++){
 ;;          if (!ignoreId) {
 ;;             inputs[i].blur();
 ;;          }
 ;;          else {
 ;;             if (inputs[i].id != ignoreId) inputs[i].blur();
 ;;          }
 ;;       }
 ;;    },
 ;;
 ;;    checkBoxHandler: function(cbox) {
 ;;       var value = cbox.getName();
 ;;       value = EWD.utils.getPiece(value,EWD.sencha.checkBox.nameRoot,2);
 ;;       var id = cbox.getId();
 ;;       var checked = cbox.getValue();
 ;;       EWD.sencha.onCheckboxChecked(value,id,checked);
 ;;    },
 ;;
 ;;    resetMenuHeight: function(widgetName) {
 ;;       var reduceBy = 0;
 ;;       if (widgetName == "toolbar") reduceBy = 40;
 ;;       if (widgetName == "stBlueHighlight") reduceBy = 44;
 ;;       var maxHeight = EWD.sencha.nestedList.maxHeight ;
 ;;       var currentHeight = EWD.sencha.nestedList.height ;
 ;;       if (currentHeight == maxHeight) {
 ;;           EWD.sencha.nestedList.height = maxHeight - reduceBy ;
 ;;       }
 ;;       else {
 ;;           EWD.sencha.nestedList.height = currentHeight - reduceBy ;
 ;;       }
 ;;    }
 ;;};
 ;;
 ;;Ext.regModel('ListItem',{
 ;;   fields: [{name: 'text',type: 'string'},{name: 'key',type: 'string'}]
 ;;});
 ;;
 ;;EWD.sencha.listStore = new Ext.data.TreeStore({
 ;;    model: 'ListItem',
 ;;    root: {
 ;;        items: EWD.sencha.mainMenu
 ;;    },
 ;;    proxy: {
 ;;       type: 'ajax',
 ;;       reader: {
 ;;           type: 'tree',
 ;;           root: 'items'
 ;;       }
 ;;    }
 ;;});
 ;;
 ;;Ext.ux.UniversalUI = Ext.extend(Ext.Panel, {
 ;;    fullscreen: true,
 ;;    layout: 'card',
 ;;    items: [{
 ;;        cls: 'launchscreen',
 ;;        html: 'Please wait...'
 ;;    }],
 ;;    backText: 'Back',
 ;;    useTitleAsBackText: true,
 ;;    initComponent : function() {
 ;;        this.backButton = new Ext.Button({
 ;;            hidden: true,
 ;;            text: this.backText,
 ;;            ui: 'back',
 ;;            handler: this.onBackButtonTap,
 ;;            scope: this
 ;;        });
 ;;
 ;;        this.navigationButton = new Ext.Button({
 ;;            hidden: Ext.is.Phone || Ext.orientation == 'landscape',
 ;;            text: EWD.sencha.navigationButtonText,
 ;;            handler: this.onNavButtonTap,
 ;;            scope: this
 ;;        });
 ;;        
 ;;       var btns = [this.navigationButton];
 ;;       if (Ext.is.Phone) {
 ;;           btns.unshift(this.backButton);
 ;;       }
 ;;        this.navigationBar = new Ext.Toolbar({
 ;;            ui: 'dark',
 ;;            dock: 'top',
 ;;            title: this.title,
 ;;            items: btns.concat(this.buttons || [])
 ;;        });
 ;;        
 ;;        var hideList = false;
 ;;        if (!Ext.is.Phone && Ext.orientation == 'portrait') hideList=true;
 ;;        if (!Ext.is.Phone && Ext.orientation == 'landscape' && EWD.isLogin) hideList=true;
 ;;
 ;;        EWD.sencha.MenuToolbar = new Ext.Toolbar({
 ;;                dock:'bottom',
 ;;                ui:'light',
 ;;                xtype:'toolbar',
 ;;                items: [{xtype: 'spacer'},{ 
 ;;                    id:'logoutButton',
 ;;                    text:'Logout',
 ;;                    handler: function() {EWD.sencha.logoutHandler();},
 ;;                    ui:'action'
 ;;                    },
 ;;                    {xtype: 'spacer'}
 ;;                ]
 ;;        });
 ;;        this.navigationPanel = new Ext.NestedList({
 ;;            store: EWD.sencha.listStore,
 ;;            useToolbar: Ext.is.Phone ? false : true,
 ;;            updateTitleText: false,
 ;;            dock: 'left',
 ;;            width: 250,
 ;;            height: 456,
 ;;            hidden: hideList,
 ;;            toolbar: Ext.is.Phone ? this.navigationBar : null,
 ;;            listeners: {
 ;;                itemtap: this.onNavPanelItemTap,
 ;;                scope: this
 ;;            },
 ;;            dockedItems: Ext.is.Phone ? EWD.sencha.MenuToolbar : null
 ;;        });
 ;;        
 ;;        this.navigationPanel.on('back', this.onNavBack, this);
 ;;
 ;;       if (!Ext.is.Phone) {
 ;;           this.navigationPanel.setWidth(250);
 ;;       }
 ;;        EWD.sencha.navigationPanel = this.navigationPanel;
 ;;        EWD.sencha.navigationButton = this.navigationButton;
 ;;        this.dockedItems = this.dockedItems || [];
 ;;        this.dockedItems.unshift(this.navigationBar);
 ;;        
 ;;        if (!Ext.is.Phone && Ext.orientation == 'landscape') {
 ;;            this.dockedItems.unshift(this.navigationPanel);
 ;;        }
 ;;        else if (Ext.is.Phone) {
 ;;            this.items = this.items || [];
 ;;            this.items.unshift(this.navigationPanel);
 ;;        }
 ;;        
 ;;        this.addEvents('navigate');
 ;;        
 ;;        Ext.ux.UniversalUI.superclass.initComponent.call(this);
 ;;    },
 ;;    
 ;;    onListChange : function(list, item) {
 ;;        if (Ext.orientation == 'portrait' && !Ext.is.Phone && !item.items && !item.preventHide) {
 ;;            this.navigationPanel.hide();
 ;;        }
 ;;        EWD.sencha.item = item;
 ;;        EWD.sencha.list = list;
 ;;        if (item.page) {
 ;;           EWD.ajax.makeRequest(item.page,EWD.sencha.div.nullId,'get','','');
 ;;        }
 ;;        if (item.key) {
 ;;           EWD.sencha.menuPage(item.key);
 ;;        }
 ;;    },
 ;;    
 ;; onNavPanelItemTap: function(subList, subIdx, el, e) {
 ;;     var store      = subList.getStore(),
 ;;         record     = store.getAt(subIdx),
 ;;         recordNode = record.node,
 ;;         nestedList = this.navigationPanel,
 ;;         title      = nestedList.renderTitleText(recordNode),
 ;;         key, page;
 ;;
 ;;      if (record) {
 ;;           key        = record.get('key');
 ;;           page        = record.get('page');
 ;;       }
 ;;     if (Ext.orientation == 'portrait' && !Ext.is.Phone && !recordNode.childNodes.length) {
 ;;         this.navigationPanel.hide();
 ;;     }
 ;;
 ;;        if (page) {
 ;;           EWD.ajax.makeRequest(page,EWD.sencha.div.nullId,'get','','');
 ;;        }
 ;;        if (key) {
 ;;           EWD.sencha.menuPage(key);
 ;;        }
 ;;
 ;;     //if (title) {
 ;;     //    this.navigationBar.setTitle(title);
 ;;     //}
 ;;     //this.toggleUiBackButton();
 ;;     //this.fireEvent('navigate', this, record);
 ;; },
 ;;
 ;;    onNavButtonTap : function() {
 ;;        this.navigationPanel.showBy(this.navigationButton, 'fade');
 ;;    },
 ;;    
 ;;    onBackButtonTap : function() {
 ;;        var prevCard = this.navigationPanel;
 ;;        if (EWD.sencha.backUsingCardStack) {
 ;;          if (EWD.sencha.cardStack) {
 ;;             var dummy = EWD.sencha.cardStackPop() ;
 ;;             prevCard = EWD.sencha.cardStack[EWD.sencha.cardStack.length - 1];
 ;;             EWD.sencha.card = prevCard;
 ;;          }
 ;;        }
 ;;        this.setCard(prevCard, {type: 'slide', direction: 'right'});
 ;;        this.currentCard = prevCard;
 ;;        if (Ext.is.Phone) {
 ;;            if (!EWD.sencha.backUsingCardStack) {
 ;;               this.backButton.hide();
 ;;               this.navigationBar.setTitle(this.title);
 ;;               this.navigationBar.doLayout();
 ;;            }
 ;;        }
 ;;        if (!EWD.sencha.backUsingCardStack) {
 ;;           this.fireEvent('navigate', this, this.navigationPanel.activeItem, this.navigationPanel);
 ;;        }
 ;;        if (EWD.sencha.keepDetailButton) {
 ;;           EWD.sencha.Main.detailButton.show();
 ;;           EWD.sencha.Main.detailButton.setText(EWD.sencha.detailButtonText);
 ;;           EWD.sencha.Main.ui.navigationBar.doComponentLayout();
 ;;        }
 ;;    },
 ;;    
 ;;    layoutOrientation : function(orientation, w, h) {
 ;;       if (!Ext.is.Phone) {
 ;;          if (orientation == 'portrait') {
 ;;             this.navigationPanel.hide(false);
 ;;             this.removeDocked(this.navigationPanel, false);
 ;;             if (this.navigationPanel.rendered) {
 ;;                 this.navigationPanel.el.appendTo(document.body);
 ;;             }
 ;;             this.navigationPanel.setFloating(true);
 ;;             this.navigationPanel.setHeight(400);
 ;;             if (!EWD.sencha.hideNavigationButton) this.navigationButton.show(false);
 ;;             //EWD.sencha.nestedList = {height:866,width:768};
 ;;             EWD.sencha.nestedList = {maxHeight:950,height:950,width:768};
 ;;          }
 ;;          else {
 ;;                //if (!EWD.isLogin) {
 ;;                   this.navigationPanel.setFloating(false);
 ;;                   if (!EWD.sencha.hideNavigationButton) this.navigationPanel.show(false);
 ;;                   this.navigationButton.hide(false);
 ;;                   this.insertDocked(0, this.navigationPanel);
 ;;                //}
 ;;                //EWD.sencha.nestedList = {height:610,width:775};
 ;;                EWD.sencha.nestedList = {maxHeight:694,height:694,width:775};
 ;;          }
 ;;          this.navigationBar.doComponentLayout();
 ;;       }
 ;;       else {
 ;;           //EWD.sencha.nestedList = {height:300,width:320};
 ;;           EWD.sencha.nestedList = {maxHeight:404,height:404,width:320};
 ;;       }
 ;;       
 ;;       Ext.ux.UniversalUI.superclass.layoutOrientation.call(this, orientation, w, h);
 ;;    } 
 ;; });
 ;;
 ;;EWD.sencha.Main = {
 ;;    init : function() {
 ;;        this.detailButton = new Ext.Button({
 ;;            text: 'Detail',
 ;;            ui: 'action',
 ;;            hidden: true,
 ;;            handler: this.onDetailButtonTap,
 ;;            scope: this
 ;;        });
 ;;        this.codeBox = new Ext.ux.CodeBox({scroll: false,id:'codeBox'});
 ;;        
 ;;        var detailConfig = {
 ;;            items: [this.codeBox],
 ;;            scroll: EWD.sencha.codePanel.scroll
 ;;        };
 ;;
 ;;        if (!Ext.is.Phone) {
 ;;            Ext.apply(detailConfig, {
 ;;                width: EWD.sencha.codePanel.width,
 ;;                height: EWD.sencha.codePanel.height,
 ;;                floating: true
 ;;            });
 ;;        }
 ;;                
 ;;        this.detailPanel = new Ext.Panel(detailConfig);
 ;;        EWD.sencha.detailPanel = this.detailPanel;
 ;;        
 ;;        this.ui = new Ext.ux.UniversalUI({
 ;;            title: Ext.is.Phone ? EWD.sencha.appTitle['phone'] : EWD.sencha.appTitle['tablet'],
 ;;            useTitleAsBackText: false,
 ;;            navigationItems: EWD.sencha.mainMenu,
 ;;            id: 'mainUI',
 ;;            buttons: [{xtype: 'spacer'}, this.detailButton],
 ;;            listeners: {
 ;;                navigate : this.onNavigate,
 ;;                scope: this
 ;;            }
 ;;        });
 ;;    },
 ;;    
 ;;    onNavigate : function(ui, item) {
 ;;      if (item.button) {
 ;;        if (item.button.show) {
 ;;            if (item.button.text) this.detailButton.setText(item.button.text);
 ;;            if (this.detailButton.hidden) {
 ;;                this.detailButton.show();
 ;;                ui.navigationBar.doComponentLayout();
 ;;            }
 ;;            this.codeBox.setValue('Empty');
 ;;            EWD.sencha.codeBox = this.codeBox;
 ;;            EWD.sencha.currentItem = item;
 ;;        }
 ;;      }
 ;;      else {
 ;;            this.codeBox.setValue('Please wait...');
 ;;            this.detailButton.hide();
 ;;            this.detailActive = false;
 ;;            this.detailButton.setText('Detail');
 ;;            ui.navigationBar.doComponentLayout();
 ;;      }
 ;;    },
 ;;    
 ;;    onDetailButtonTap : function() {
 ;;      if (EWD.sencha.detailButtonHandler) {
 ;;        EWD.sencha.detailButtonHandler();
 ;;        return;
 ;;      }
 ;;        if (!Ext.is.Phone) {
 ;;            this.detailPanel.showBy(this.detailButton.el, 'fade');
 ;;            var height = EWD.sencha.codePanel.height;
 ;;            if (popup.height) height = popup.height;
 ;;            var width = EWD.sencha.codePanel.width ;
 ;;            if (popup.width) width = popup.width;
 ;;            this.detailPanel.width = width;
 ;;            this.detailPanel.height = height;
 ;;            if (popup.width != EWD.sencha.codePanel.width) this.detailPanel.showBy(this.detailButton.el, 'fade');
 ;;        }
 ;;        else {
 ;;            if (this.detailActive) {
 ;;                EWD.sencha.Main.ui.setCard(EWD.sencha.Main.ui.currentCard, Ext.is.Android ? false : 'flip');
 ;;                this.detailActive = false;
 ;;                this.ui.navigationBar.setTitle(this.currentTitle);
 ;;                this.detailButton.setText(EWD.sencha.Main.detailButton.prevText);
 ;;                if (EWD.sencha.Main.detailButton.isHidden) EWD.sencha.Main.detailButton.hide();
 ;;            }
 ;;            else {
 ;;                this.ui.setCard(this.detailPanel, Ext.is.Android ? false : animation);
 ;;                this.detailActive = true;
 ;;                this.currentTitle = this.ui.navigationBar.title;
 ;;                this.ui.navigationBar.setTitle(EWD.sencha.currentItem.button.text);
 ;;                this.detailButton.setText(this.currentTitle);
 ;;            }
 ;;            this.ui.navigationBar.doLayout();
 ;;        }
 ;;        if (popup.scroll) {
 ;;          this.detailPanel.scroll = popup.scroll;
 ;;        }
 ;;        this.detailPanel.scroller.scrollTo({x: 0, y: 0});
 ;;      }
 ;; };
 ;;
 ;;Ext.data.TreeStore.override({
 ;;   repopulate: function(newItems) {
 ;;       var proxy    = this.proxy,
 ;;           reader   = proxy.reader,
 ;;           rootNode = this.getRootNode();
 ;;
 ;;       rootNode.attributes[reader.root] = newItems;
 ;;       this.read({
 ;;           node: rootNode,
 ;;           doPreload: true
 ;;       });
 ;;   }
 ;;});
 ;;
 ;;Ext.setup({
 ;;    tabletStartupScreen: EWD.senchaStartup.tabletStartupScreen,
 ;;    phoneStartupScreen: EWD.senchaStartup.phoneStartupScreen,
 ;;    icon: EWD.senchaStartup.icon,
 ;;    glossOnIcon: EWD.senchaStartup.addGlossToIcon,
 ;;    
 ;;    onReady: function() {
 ;;        EWD.sencha.Main.init();
 ;;    }
 ;;});
 ;;
 ;;***END***
 ;;
stJS ;;
 ;;EWD.sencha={
 ;;  widget:{},
 ;;  widgetIndex:{},
 ;;  parentPanel:{},
 ;;  popupParams:{},
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
 ;;  },
 ;;  loadCardPanel: function(panelId) {
 ;;     if (EWD.sencha.cardPanel) {
 ;;        var cp=Ext.getCmp(EWD.sencha.cardPanel.id);
 ;;        cp.add(Ext.getCmp(panelId));
 ;;        cp.doLayout();
 ;;        EWD.sencha.cardPanel.prevCard = cp.getActiveItem();
 ;;        cp.setActiveItem(Ext.getCmp(panelId), EWD.sencha.cardPanel.transition);
 ;;        var backButton=Ext.getCmp(EWD.sencha.backbuttonId);
 ;;        backButton.show();
 ;;        backButton.setHandler(function(btn,e) {
 ;;           Ext.getCmp(panelId).destroy();
 ;;           Ext.getCmp(EWD.sencha.cardPanel.id).setActiveItem(EWD.sencha.cardPanel.prevCard, {type:EWD.sencha.cardPanel.transition, direction: 'right'});
 ;;           backButton.hide();
 ;;        });
 ;;     }
 ;;  }
 ;;};
 ;;
 ;;***END***
