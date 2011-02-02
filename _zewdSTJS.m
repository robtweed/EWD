%zewdSTJS ; Sencha Touch Main Static Javascript file
 ;
 ; Product: Enterprise Web Developer (Build 842)
 ; Build Date: Wed, 02 Feb 2011 09:31:08
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
 ;;  }
 ;;};
 ;;
 ;;***END***
 ;;
QRCode ;;
 ;;EWD.sencha.qrCode = {
 ;;  draw: function(params) {
 ;;     var qr = new QRCode(params.pointSize, EWD.sencha.qrCode.errorCorrectLevel[params.correctionLevel]);
 ;;     qr.addData(params.data);
 ;;     qr.make();
 ;;     var canvasSize = qr.getModuleCount() * params.blockSize;
 ;;     var el = document.getElementById(params.id);
 ;;     el.setAttribute("width",canvasSize);
 ;;     el.setAttribute("height",canvasSize);
 ;;     var ctx = el.getContext("2d");
 ;;     for (var r = 0; r < qr.getModuleCount(); r++) {
 ;;        for (var c = 0; c < qr.getModuleCount(); c++) {
 ;;           if (qr.isDark(r, c) ) {
 ;;              ctx.fillStyle = "rgb(0,0,0)";
 ;;           } 
 ;;           else {
 ;;              ctx.fillStyle = "rgb(255, 255, 255)";
 ;;           }
 ;;           ctx.fillRect ((params.blockSize*c), (params.blockSize*r), params.blockSize, params.blockSize);
 ;;        }
 ;;     }
 ;;  }
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRCode for JavaScript
 ;;//
 ;;// Copyright (c) 2009 Kazuhiko Arase
 ;;//
 ;;// URL: http://www.d-project.com/
 ;;//
 ;;// Modified for use with EWD by Rob Tweed
 ;;//
 ;;// Licensed under the MIT license:
 ;;//   http://www.opensource.org/licenses/mit-license.php
 ;;//
 ;;// The word "QR Code" is registered trademark of 
 ;;// DENSO WAVE INCORPORATED
 ;;//   http://www.denso-wave.com/qrcode/faqpatent-e.html
 ;;//
 ;;//---------------------------------------------------------------------
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QR8bitByte
 ;;//---------------------------------------------------------------------
 ;;
 ;;function QR8bitByte(data) {
 ;;   this.mode = EWD.sencha.qrCode.mode.MODE_8BIT_BYTE;
 ;;   this.data = data;
 ;;}
 ;;
 ;;QR8bitByte.prototype = {
 ;;  getLength: function(buffer) {
 ;;    return this.data.length;
 ;;  },      
 ;;  write: function(buffer) {
 ;;    for (var i = 0; i < this.data.length; i++) {
 ;;      // not JIS ...
 ;;      buffer.put(this.data.charCodeAt(i), 8);
 ;;    }
 ;;  }
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRCode
 ;;//---------------------------------------------------------------------
 ;;
 ;;function QRCode(typeNumber, errorCorrectLevel) {
 ;;  this.typeNumber = typeNumber;
 ;;  this.errorCorrectLevel = errorCorrectLevel;
 ;;  this.modules = null;
 ;;  this.moduleCount = 0;
 ;;  this.dataCache = null;
 ;;  this.dataList = new Array();
 ;;}
 ;;
 ;;QRCode.prototype = {
 ;;  addData: function(data) {
 ;;    var newData = new QR8bitByte(data);
 ;;    this.dataList.push(newData);
 ;;    this.dataCache = null;
 ;;  },      
 ;;  isDark: function(row, col) {
 ;;    if (row < 0 || this.moduleCount <= row || col < 0 || this.moduleCount <= col) {
 ;;      throw new Error(row + "," + col);
 ;;    }
 ;;    return this.modules[row][col];
 ;;  },
 ;;  getModuleCount: function() {
 ;;    return this.moduleCount;
 ;;  },
 ;;  make: function() {
 ;;    this.makeImpl(false, this.getBestMaskPattern() );
 ;;  },
 ;;  makeImpl: function(test, maskPattern) {
 ;;    this.moduleCount = this.typeNumber * 4 + 17;
 ;;    this.modules = new Array(this.moduleCount);
 ;;    for (var row = 0; row < this.moduleCount; row++) {
 ;;      this.modules[row] = new Array(this.moduleCount);
 ;;      for (var col = 0; col < this.moduleCount; col++) {
 ;;        this.modules[row][col] = null;//(col + row) % 3;
 ;;      }
 ;;    }
 ;;    this.setupPositionProbePattern(0, 0);
 ;;    this.setupPositionProbePattern(this.moduleCount - 7, 0);
 ;;    this.setupPositionProbePattern(0, this.moduleCount - 7);
 ;;    this.setupPositionAdjustPattern();
 ;;    this.setupTimingPattern();
 ;;    this.setupTypeInfo(test, maskPattern);
 ;;    if (this.typeNumber >= 7) {
 ;;      this.setupTypeNumber(test);
 ;;    }
 ;;    if (this.dataCache == null) {
 ;;      this.dataCache = QRCode.createData(this.typeNumber, this.errorCorrectLevel, this.dataList);
 ;;    }
 ;;    this.mapData(this.dataCache, maskPattern);
 ;;  },
 ;;  setupPositionProbePattern: function(row, col)  {
 ;;    for (var r = -1; r <= 7; r++) {
 ;;      if (row + r <= -1 || this.moduleCount <= row + r) continue;
 ;;      for (var c = -1; c <= 7; c++) {
 ;;        if (col + c <= -1 || this.moduleCount <= col + c) continue;
 ;;        if ( (0 <= r && r <= 6 && (c == 0 || c == 6) )
 ;;          || (0 <= c && c <= 6 && (r == 0 || r == 6) )
 ;;          || (2 <= r && r <= 4 && 2 <= c && c <= 4) ) {
 ;;            this.modules[row + r][col + c] = true;
 ;;        } else {
 ;;          this.modules[row + r][col + c] = false;
 ;;        }
 ;;      }               
 ;;    }               
 ;;  },
 ;;  getBestMaskPattern: function() {
 ;;    var minLostPoint = 0;
 ;;    var pattern = 0;
 ;;    for (var i = 0; i < 8; i++) {
 ;;      this.makeImpl(true, i);
 ;;      var lostPoint = EWD.sencha.qrCode.util.getLostPoint(this);
 ;;      if (i == 0 || minLostPoint > lostPoint) {
 ;;        minLostPoint = lostPoint;
 ;;        pattern = i;
 ;;      }
 ;;    }
 ;;    return pattern;
 ;;  },
 ;;  createMovieClip: function(target_mc, instance_name, depth) {
 ;;    var qr_mc = target_mc.createEmptyMovieClip(instance_name, depth);
 ;;    var cs = 1;
 ;;    this.make();
 ;;    for (var row = 0; row < this.modules.length; row++) {
 ;;      var y = row * cs;
 ;;      for (var col = 0; col < this.modules[row].length; col++) {
 ;;        var x = col * cs;
 ;;        var dark = this.modules[row][col];
 ;;        if (dark) {
 ;;          qr_mc.beginFill(0, 100);
 ;;          qr_mc.moveTo(x, y);
 ;;          qr_mc.lineTo(x + cs, y);
 ;;          qr_mc.lineTo(x + cs, y + cs);
 ;;          qr_mc.lineTo(x, y + cs);
 ;;          qr_mc.endFill();
 ;;        }
 ;;      }
 ;;    }
 ;;    return qr_mc;
 ;;  },
 ;;  setupTimingPattern: function() {
 ;;    for (var r = 8; r < this.moduleCount - 8; r++) {
 ;;      if (this.modules[r][6] != null) {
 ;;        continue;
 ;;      }
 ;;      this.modules[r][6] = (r % 2 == 0);
 ;;    }
 ;;    for (var c = 8; c < this.moduleCount - 8; c++) {
 ;;      if (this.modules[6][c] != null) {
 ;;        continue;
 ;;      }
 ;;      this.modules[6][c] = (c % 2 == 0);
 ;;    }
 ;;  },
 ;;  setupPositionAdjustPattern: function() {
 ;;    var pos = EWD.sencha.qrCode.util.getPatternPosition(this.typeNumber);
 ;;    for (var i = 0; i < pos.length; i++) {
 ;;      for (var j = 0; j < pos.length; j++) {
 ;;        var row = pos[i];
 ;;        var col = pos[j];
 ;;        if (this.modules[row][col] != null) {
 ;;          continue;
 ;;        }
 ;;        for (var r = -2; r <= 2; r++) {
 ;;          for (var c = -2; c <= 2; c++) {
 ;;            if (r == -2 || r == 2 || c == -2 || c == 2 
 ;;              || (r == 0 && c == 0) ) {
 ;;                this.modules[row + r][col + c] = true;
 ;;            } 
 ;;            else {
 ;;              this.modules[row + r][col + c] = false;
 ;;            }
 ;;          }
 ;;        }
 ;;      }
 ;;    }
 ;;  },
 ;;  setupTypeNumber: function(test) {
 ;;    var bits = EWD.sencha.qrCode.util.getBCHTypeNumber(this.typeNumber);
 ;;    for (var i = 0; i < 18; i++) {
 ;;      var mod = (!test && ( (bits >> i) & 1) == 1);
 ;;      this.modules[Math.floor(i / 3)][i % 3 + this.moduleCount - 8 - 3] = mod;
 ;;    }
 ;;    for (var i = 0; i < 18; i++) {
 ;;      var mod = (!test && ( (bits >> i) & 1) == 1);
 ;;      this.modules[i % 3 + this.moduleCount - 8 - 3][Math.floor(i / 3)] = mod;
 ;;    }
 ;;  },
 ;;  setupTypeInfo: function(test, maskPattern) {
 ;;    var data = (this.errorCorrectLevel << 3) | maskPattern;
 ;;    var bits = EWD.sencha.qrCode.util.getBCHTypeInfo(data);
 ;;    // vertical             
 ;;    for (var i = 0; i < 15; i++) {
 ;;      var mod = (!test && ( (bits >> i) & 1) == 1);
 ;;      if (i < 6) {
 ;;        this.modules[i][8] = mod;
 ;;      } 
 ;;      else if (i < 8) {
 ;;        this.modules[i + 1][8] = mod;
 ;;      } 
 ;;      else {
 ;;        this.modules[this.moduleCount - 15 + i][8] = mod;
 ;;      }
 ;;    }
 ;;    // horizontal
 ;;    for (var i = 0; i < 15; i++) {
 ;;      var mod = (!test && ( (bits >> i) & 1) == 1);
 ;;      if (i < 8) {
 ;;        this.modules[8][this.moduleCount - i - 1] = mod;
 ;;      } 
 ;;      else if (i < 9) {
 ;;        this.modules[8][15 - i - 1 + 1] = mod;
 ;;      } 
 ;;      else {
 ;;        this.modules[8][15 - i - 1] = mod;
 ;;      }
 ;;    }
 ;;    // fixed module
 ;;    this.modules[this.moduleCount - 8][8] = (!test);
 ;;  },
 ;;  mapData : function(data, maskPattern) {
 ;;    var inc = -1;
 ;;    var row = this.moduleCount - 1;
 ;;    var bitIndex = 7;
 ;;    var byteIndex = 0;
 ;;    for (var col = this.moduleCount - 1; col > 0; col -= 2) {
 ;;      if (col == 6) col--;
 ;;      while (true) {
 ;;        for (var c = 0; c < 2; c++) {
 ;;          if (this.modules[row][col - c] == null) {
 ;;            var dark = false;
 ;;            if (byteIndex < data.length) {
 ;;              dark = ( ( (data[byteIndex] >>> bitIndex) & 1) == 1);
 ;;            }
 ;;            var mask = EWD.sencha.qrCode.util.getMask(maskPattern, row, col - c);
 ;;            if (mask) {
 ;;              dark = !dark;
 ;;            }
 ;;            this.modules[row][col - c] = dark;
 ;;            bitIndex--;
 ;;            if (bitIndex == -1) {
 ;;              byteIndex++;
 ;;              bitIndex = 7;
 ;;            }
 ;;          }
 ;;        }
 ;;        row += inc;
 ;;        if (row < 0 || this.moduleCount <= row) {
 ;;          row -= inc;
 ;;          inc = -inc;
 ;;          break;
 ;;        }
 ;;      }
 ;;    }
 ;;  }
 ;;};
 ;;
 ;;QRCode.PAD0 = 0xEC;
 ;;QRCode.PAD1 = 0x11;
 ;;
 ;;QRCode.createData = function(typeNumber, errorCorrectLevel, dataList) {
 ;;  var rsBlocks = QRRSBlock.getRSBlocks(typeNumber, errorCorrectLevel);
 ;;  var buffer = new QRBitBuffer();
 ;;  for (var i = 0; i < dataList.length; i++) {
 ;;    var data = dataList[i];
 ;;    buffer.put(data.mode, 4);
 ;;    buffer.put(data.getLength(), EWD.sencha.qrCode.util.getLengthInBits(data.mode, typeNumber) );
 ;;    data.write(buffer);
 ;;  }
 ;;  // calc num max data.
 ;;  var totalDataCount = 0;
 ;;  for (var i = 0; i < rsBlocks.length; i++) {
 ;;    totalDataCount += rsBlocks[i].dataCount;
 ;;  }
 ;;  if (buffer.getLengthInBits() > totalDataCount * 8) {
 ;;    throw new Error("code length overflow. ("
 ;;      + buffer.getLengthInBits()
 ;;      + ">"
 ;;      +  totalDataCount * 8
 ;;      + ")");
 ;;  }
 ;;  // end code
 ;;  if (buffer.getLengthInBits() + 4 <= totalDataCount * 8) {
 ;;    buffer.put(0, 4);
 ;;  }
 ;;  // padding
 ;;  while (buffer.getLengthInBits() % 8 != 0) {
 ;;    buffer.putBit(false);
 ;;  }
 ;;  // padding
 ;;  while (true) {
 ;;    if (buffer.getLengthInBits() >= totalDataCount * 8) {
 ;;      break;
 ;;    }
 ;;    buffer.put(QRCode.PAD0, 8);
 ;;    if (buffer.getLengthInBits() >= totalDataCount * 8) {
 ;;      break;
 ;;    }
 ;;    buffer.put(QRCode.PAD1, 8);
 ;;  }
 ;;  return QRCode.createBytes(buffer, rsBlocks);
 ;;};
 ;;
 ;;QRCode.createBytes = function(buffer, rsBlocks) {
 ;;  var offset = 0;
 ;;  var maxDcCount = 0;
 ;;  var maxEcCount = 0;
 ;;  var dcdata = new Array(rsBlocks.length);
 ;;  var ecdata = new Array(rsBlocks.length);
 ;;  for (var r = 0; r < rsBlocks.length; r++) {
 ;;    var dcCount = rsBlocks[r].dataCount;
 ;;    var ecCount = rsBlocks[r].totalCount - dcCount;
 ;;    maxDcCount = Math.max(maxDcCount, dcCount);
 ;;    maxEcCount = Math.max(maxEcCount, ecCount);
 ;;    dcdata[r] = new Array(dcCount);
 ;;    for (var i = 0; i < dcdata[r].length; i++) {
 ;;      dcdata[r][i] = 0xff & buffer.buffer[i + offset];
 ;;    }
 ;;    offset += dcCount;
 ;;    var rsPoly = EWD.sencha.qrCode.util.getErrorCorrectPolynomial(ecCount);
 ;;    var rawPoly = new QRPolynomial(dcdata[r], rsPoly.getLength() - 1);
 ;;    var modPoly = rawPoly.mod(rsPoly);
 ;;    ecdata[r] = new Array(rsPoly.getLength() - 1);
 ;;    for (var i = 0; i < ecdata[r].length; i++) {
 ;;      var modIndex = i + modPoly.getLength() - ecdata[r].length;
 ;;      ecdata[r][i] = (modIndex >= 0)? modPoly.get(modIndex) : 0;
 ;;    }
 ;;  }
 ;;  var totalCodeCount = 0;
 ;;  for (var i = 0; i < rsBlocks.length; i++) {
 ;;    totalCodeCount += rsBlocks[i].totalCount;
 ;;  }
 ;;  var data = new Array(totalCodeCount);
 ;;  var index = 0;
 ;;  for (var i = 0; i < maxDcCount; i++) {
 ;;    for (var r = 0; r < rsBlocks.length; r++) {
 ;;      if (i < dcdata[r].length) {
 ;;        data[index++] = dcdata[r][i];
 ;;      }
 ;;    }
 ;;  }
 ;;  for (var i = 0; i < maxEcCount; i++) {
 ;;    for (var r = 0; r < rsBlocks.length; r++) {
 ;;      if (i < ecdata[r].length) {
 ;;        data[index++] = ecdata[r][i];
 ;;      }
 ;;    }
 ;;  }
 ;;  return data;
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRMode
 ;;//---------------------------------------------------------------------
 ;;
 ;;EWD.sencha.qrCode.mode = {
 ;;  MODE_NUMBER:    1 << 0,
 ;;  MODE_ALPHA_NUM: 1 << 1,
 ;;  MODE_8BIT_BYTE: 1 << 2,
 ;;  MODE_KANJI:     1 << 3
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRErrorCorrectLevel
 ;;//---------------------------------------------------------------------
 ;; 
 ;;EWD.sencha.qrCode.errorCorrectLevel = {
 ;;  L: 1,
 ;;  M: 0,
 ;;  Q: 3,
 ;;  H: 2
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRMaskPattern
 ;;//---------------------------------------------------------------------
 ;;
 ;;EWD.sencha.qrCode.maskPattern = {
 ;;  PATTERN000: 0,
 ;;  PATTERN001: 1,
 ;;  PATTERN010: 2,
 ;;  PATTERN011: 3,
 ;;  PATTERN100: 4,
 ;;  PATTERN101: 5,
 ;;  PATTERN110: 6,
 ;;  PATTERN111: 7
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRUtil
 ;;//---------------------------------------------------------------------
 ;; 
 ;;EWD.sencha.qrCode.util = {
 ;;  PATTERN_POSITION_TABLE: [
 ;;    [],
 ;;    [6, 18],
 ;;    [6, 22],
 ;;    [6, 26],
 ;;    [6, 30],
 ;;    [6, 34],
 ;;    [6, 22, 38],
 ;;    [6, 24, 42],
 ;;    [6, 26, 46],
 ;;    [6, 28, 50],
 ;;    [6, 30, 54],                
 ;;    [6, 32, 58],
 ;;    [6, 34, 62],
 ;;    [6, 26, 46, 66],
 ;;    [6, 26, 48, 70],
 ;;    [6, 26, 50, 74],
 ;;    [6, 30, 54, 78],
 ;;    [6, 30, 56, 82],
 ;;    [6, 30, 58, 86],
 ;;    [6, 34, 62, 90],
 ;;    [6, 28, 50, 72, 94],
 ;;    [6, 26, 50, 74, 98],
 ;;    [6, 30, 54, 78, 102],
 ;;    [6, 28, 54, 80, 106],
 ;;    [6, 32, 58, 84, 110],
 ;;    [6, 30, 58, 86, 114],
 ;;    [6, 34, 62, 90, 118],
 ;;    [6, 26, 50, 74, 98, 122],
 ;;    [6, 30, 54, 78, 102, 126],
 ;;    [6, 26, 52, 78, 104, 130],
 ;;    [6, 30, 56, 82, 108, 134],
 ;;    [6, 34, 60, 86, 112, 138],
 ;;    [6, 30, 58, 86, 114, 142],
 ;;    [6, 34, 62, 90, 118, 146],
 ;;    [6, 30, 54, 78, 102, 126, 150],
 ;;    [6, 24, 50, 76, 102, 128, 154],
 ;;    [6, 28, 54, 80, 106, 132, 158],
 ;;    [6, 32, 58, 84, 110, 136, 162],
 ;;    [6, 26, 54, 82, 110, 138, 166],
 ;;    [6, 30, 58, 86, 114, 142, 170]
 ;;  ],
 ;;  G15: (1 << 10) | (1 << 8) | (1 << 5) | (1 << 4) | (1 << 2) | (1 << 1) | (1 << 0),
 ;;  G18: (1 << 12) | (1 << 11) | (1 << 10) | (1 << 9) | (1 << 8) | (1 << 5) | (1 << 2) | (1 << 0),
 ;;  G15_MASK: (1 << 14) | (1 << 12) | (1 << 10)        | (1 << 4) | (1 << 1),
 ;;  
 ;;  getBCHTypeInfo: function(data) {
 ;;    var d = data << 10;
 ;;    var util = EWD.sencha.qrCode.util;
 ;;    while (util.getBCHDigit(d) - util.getBCHDigit(util.G15) >= 0) {
 ;;      d ^= (util.G15 << (util.getBCHDigit(d) - util.getBCHDigit(util.G15) ) );    
 ;;    }
 ;;    return ( (data << 10) | d) ^ util.G15_MASK;
 ;;  },
 ;;  getBCHTypeNumber: function(data) {
 ;;    var d = data << 12;
 ;;    var util = EWD.sencha.qrCode.util;
 ;;    while (util.getBCHDigit(d) - util.getBCHDigit(util.G18) >= 0) {
 ;;      d ^= (util.G18 << (util.getBCHDigit(d) - util.getBCHDigit(util.G18) ) );    
 ;;    }
 ;;    return (data << 12) | d;
 ;;  },
 ;;  getBCHDigit: function(data) {
 ;;    var digit = 0;
 ;;    while (data != 0) {
 ;;      digit++;
 ;;      data >>>= 1;
 ;;    }
 ;;    return digit;
 ;;  },
 ;;  getPatternPosition: function(typeNumber) {
 ;;    return EWD.sencha.qrCode.util.PATTERN_POSITION_TABLE[typeNumber - 1];
 ;;  },
 ;;  getMask: function(maskPattern, i, j) {
 ;;    switch (maskPattern) {
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN000: return (i + j) % 2 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN001: return i % 2 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN010: return j % 3 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN011: return (i + j) % 3 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN100: return (Math.floor(i / 2) + Math.floor(j / 3) ) % 2 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN101: return (i * j) % 2 + (i * j) % 3 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN110: return ( (i * j) % 2 + (i * j) % 3) % 2 == 0;
 ;;      case EWD.sencha.qrCode.maskPattern.PATTERN111: return ( (i * j) % 3 + (i + j) % 2) % 2 == 0;
 ;;      default :
 ;;        throw new Error("bad maskPattern:" + maskPattern);
 ;;    }
 ;;  },
 ;;  getErrorCorrectPolynomial: function(errorCorrectLength) {
 ;;    var a = new QRPolynomial([1], 0);
 ;;    for (var i = 0; i < errorCorrectLength; i++) {
 ;;      a = a.multiply(new QRPolynomial([1, EWD.sencha.qrCode.math.gexp(i)], 0) );
 ;;    }
 ;;    return a;
 ;;  },
 ;;  getLengthInBits: function(mode, type) {
 ;;    if (1 <= type && type < 10) {
 ;;      // 1 - 9
 ;;      switch(mode) {
 ;;        case EWD.sencha.qrCode.mode.MODE_NUMBER:    return 10;
 ;;        case EWD.sencha.qrCode.mode.MODE_ALPHA_NUM: return 9;
 ;;        case EWD.sencha.qrCode.mode.MODE_8BIT_BYTE: return 8;
 ;;        case EWD.sencha.qrCode.mode.MODE_KANJI:     return 8;
 ;;        default : throw new Error("mode:" + mode);
 ;;      }
 ;;    } 
 ;;    else if (type < 27) {
 ;;      // 10 - 26
 ;;      switch(mode) {
 ;;        case EWD.sencha.qrCode.mode.MODE_NUMBER:    return 12;
 ;;        case EWD.sencha.qrCode.mode.MODE_ALPHA_NUM: return 11;
 ;;        case EWD.sencha.qrCode.mode.MODE_8BIT_BYTE: return 16;
 ;;        case EWD.sencha.qrCode.mode.MODE_KANJI:     return 10;
 ;;        default: throw new Error("mode:" + mode);
 ;;      }
 ;;    } 
 ;;    else if (type < 41) {
 ;;      // 27 - 40
 ;;      switch(mode) {
 ;;        case EWD.sencha.qrCode.mode.MODE_NUMBER:    return 14;
 ;;        case EWD.sencha.qrCode.mode.MODE_ALPHA_NUM: return 13;
 ;;        case EWD.sencha.qrCode.mode.MODE_8BIT_BYTE: return 16;
 ;;        case EWD.sencha.qrCode.mode.MODE_KANJI:     return 12;
 ;;        default : throw new Error("mode:" + mode);
 ;;      }
 ;;    } 
 ;;    else {
 ;;      throw new Error("type:" + type);
 ;;    }
 ;;  },
 ;;  getLostPoint: function(qrCode) {
 ;;    var moduleCount = qrCode.getModuleCount();
 ;;    var lostPoint = 0;
 ;;    // LEVEL1
 ;;    for (var row = 0; row < moduleCount; row++) {
 ;;      for (var col = 0; col < moduleCount; col++) {
 ;;        var sameCount = 0;
 ;;        var dark = qrCode.isDark(row, col);
 ;;        for (var r = -1; r <= 1; r++) {
 ;;          if (row + r < 0 || moduleCount <= row + r) {
 ;;            continue;
 ;;          }
 ;;          for (var c = -1; c <= 1; c++) {
 ;;            if (col + c < 0 || moduleCount <= col + c) {
 ;;              continue;
 ;;            }
 ;;            if (r == 0 && c == 0) {
 ;;              continue;
 ;;            }
 ;;            if (dark == qrCode.isDark(row + r, col + c) ) {
 ;;              sameCount++;
 ;;            }
 ;;          }
 ;;        }
 ;;        if (sameCount > 5) {
 ;;          lostPoint += (3 + sameCount - 5);
 ;;        }
 ;;      }
 ;;    }
 ;;    // LEVEL2
 ;;    for (var row = 0; row < moduleCount - 1; row++) {
 ;;      for (var col = 0; col < moduleCount - 1; col++) {
 ;;        var count = 0;
 ;;        if (qrCode.isDark(row,col)) count++;
 ;;        if (qrCode.isDark(row + 1, col)) count++;
 ;;        if (qrCode.isDark(row,col + 1) ) count++;
 ;;        if (qrCode.isDark(row + 1,col + 1) ) count++;
 ;;        if (count == 0 || count == 4) {
 ;;          lostPoint += 3;
 ;;        }
 ;;      }
 ;;    }
 ;;    // LEVEL3
 ;;    for (var row = 0; row < moduleCount; row++) {
 ;;      for (var col = 0; col < moduleCount - 6; col++) {
 ;;        if (qrCode.isDark(row, col)
 ;;          && !qrCode.isDark(row, col + 1)
 ;;          &&  qrCode.isDark(row, col + 2)
 ;;          &&  qrCode.isDark(row, col + 3)
 ;;          &&  qrCode.isDark(row, col + 4)
 ;;          && !qrCode.isDark(row, col + 5)
 ;;          &&  qrCode.isDark(row, col + 6) ) {
 ;;            lostPoint += 40;
 ;;        }
 ;;      }
 ;;    }
 ;;    for (var col = 0; col < moduleCount; col++) {
 ;;      for (var row = 0; row < moduleCount - 6; row++) {
 ;;        if (qrCode.isDark(row, col)
 ;;          && !qrCode.isDark(row + 1, col)
 ;;          &&  qrCode.isDark(row + 2, col)
 ;;          &&  qrCode.isDark(row + 3, col)
 ;;          &&  qrCode.isDark(row + 4, col)
 ;;          && !qrCode.isDark(row + 5, col)
 ;;          &&  qrCode.isDark(row + 6, col) ) {
 ;;            lostPoint += 40;
 ;;        }
 ;;      }
 ;;    }
 ;;    // LEVEL4
 ;;    var darkCount = 0;
 ;;    for (var col = 0; col < moduleCount; col++) {
 ;;      for (var row = 0; row < moduleCount; row++) {
 ;;        if (qrCode.isDark(row, col) ) {
 ;;          darkCount++;
 ;;        }
 ;;      }
 ;;    }
 ;;    var ratio = Math.abs(100 * darkCount / moduleCount / moduleCount - 50) / 5;
 ;;    lostPoint += ratio * 10;
 ;;    return lostPoint;           
 ;;  }
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRMath
 ;;//---------------------------------------------------------------------
 ;;
 ;;EWD.sencha.qrCode.math = {
 ;;  glog: function(n) {
 ;;    if (n < 1) {
 ;;      throw new Error("glog(" + n + ")");
 ;;    }
 ;;    return EWD.sencha.qrCode.math.LOG_TABLE[n];
 ;;  },
 ;;  gexp: function(n) {
 ;;    while (n < 0) {
 ;;      n += 255;
 ;;    }
 ;;    while (n >= 256) {
 ;;      n -= 255;
 ;;    }
 ;;    return EWD.sencha.qrCode.math.EXP_TABLE[n];
 ;;  },
 ;;  EXP_TABLE: new Array(256),
 ;;  LOG_TABLE: new Array(256)
 ;;};
 ;;        
 ;;for (var i = 0; i < 8; i++) {
 ;;  EWD.sencha.qrCode.math.EXP_TABLE[i] = 1 << i;
 ;;}
 ;;for (var i = 8; i < 256; i++) {
 ;;  EWD.sencha.qrCode.math.EXP_TABLE[i] = EWD.sencha.qrCode.math.EXP_TABLE[i - 4]
 ;;  ^ EWD.sencha.qrCode.math.EXP_TABLE[i - 5]
 ;;  ^ EWD.sencha.qrCode.math.EXP_TABLE[i - 6]
 ;;  ^ EWD.sencha.qrCode.math.EXP_TABLE[i - 8];
 ;;}
 ;;for (var i = 0; i < 255; i++) {
 ;;  EWD.sencha.qrCode.math.LOG_TABLE[EWD.sencha.qrCode.math.EXP_TABLE[i] ] = i;
 ;;}
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRPolynomial
 ;;//---------------------------------------------------------------------
 ;;
 ;;function QRPolynomial(num, shift) {
 ;;  if (num.length == undefined) {
 ;;    throw new Error(num.length + "/" + shift);
 ;;  }
 ;;  var offset = 0;
 ;;  while (offset < num.length && num[offset] == 0) {
 ;;    offset++;
 ;;  }
 ;;  this.num = new Array(num.length - offset + shift);
 ;;  for (var i = 0; i < num.length - offset; i++) {
 ;;    this.num[i] = num[i + offset];
 ;;  }
 ;;}
 ;;
 ;;QRPolynomial.prototype = {
 ;;  get: function(index) {
 ;;    return this.num[index];
 ;;  },
 ;;  getLength: function() {
 ;;    return this.num.length;
 ;;  },
 ;;  multiply: function(e) {
 ;;    var num = new Array(this.getLength() + e.getLength() - 1);
 ;;    var math = EWD.sencha.qrCode.math;
 ;;    for (var i = 0; i < this.getLength(); i++) {
 ;;      for (var j = 0; j < e.getLength(); j++) {
 ;;        num[i + j] ^= math.gexp(math.glog(this.get(i) ) + math.glog(e.get(j) ) );
 ;;      }
 ;;    }
 ;;    return new QRPolynomial(num, 0);
 ;;  },
 ;;  mod: function(e) {
 ;;    var math = EWD.sencha.qrCode.math;
 ;;    if (this.getLength() - e.getLength() < 0) {
 ;;      return this;
 ;;    }
 ;;    var ratio = math.glog(this.get(0) ) - math.glog(e.get(0) );
 ;;    var num = new Array(this.getLength() );
 ;;    for (var i = 0; i < this.getLength(); i++) {
 ;;      num[i] = this.get(i);
 ;;    }
 ;;    for (var i = 0; i < e.getLength(); i++) {
 ;;      num[i] ^= math.gexp(math.glog(e.get(i) ) + ratio);
 ;;    }
 ;;    // recursive call
 ;;    return new QRPolynomial(num, 0).mod(e);
 ;;  }
 ;;};
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRRSBlock
 ;;//---------------------------------------------------------------------
 ;;
 ;;function QRRSBlock(totalCount, dataCount) {
 ;;  this.totalCount = totalCount;
 ;;  this.dataCount  = dataCount;
 ;;}
 ;;
 ;;QRRSBlock.RS_BLOCK_TABLE = [
 ;;  // L
 ;;  // M
 ;;  // Q
 ;;  // H
 ;;  // 1
 ;;  [1, 26, 19],
 ;;  [1, 26, 16],
 ;;  [1, 26, 13],
 ;;  [1, 26, 9],
 ;;  // 2
 ;;  [1, 44, 34],
 ;;  [1, 44, 28],
 ;;  [1, 44, 22],
 ;;  [1, 44, 16],
 ;;  // 3
 ;;  [1, 70, 55],
 ;;  [1, 70, 44],
 ;;  [2, 35, 17],
 ;;  [2, 35, 13],
 ;;  // 4            
 ;;  [1, 100, 80],
 ;;  [2, 50, 32],
 ;;  [2, 50, 24],
 ;;  [4, 25, 9],
 ;;  // 5
 ;;  [1, 134, 108],
 ;;  [2, 67, 43],
 ;;  [2, 33, 15, 2, 34, 16],
 ;;  [2, 33, 11, 2, 34, 12],
 ;;  // 6
 ;;  [2, 86, 68],
 ;;  [4, 43, 27],
 ;;  [4, 43, 19],
 ;;  [4, 43, 15],
 ;;  // 7            
 ;;  [2, 98, 78],
 ;;  [4, 49, 31],
 ;;  [2, 32, 14, 4, 33, 15],
 ;;  [4, 39, 13, 1, 40, 14],
 ;;  // 8
 ;;  [2, 121, 97],
 ;;  [2, 60, 38, 2, 61, 39],
 ;;  [4, 40, 18, 2, 41, 19],
 ;;  [4, 40, 14, 2, 41, 15],
 ;;  // 9
 ;;  [2, 146, 116],
 ;;  [3, 58, 36, 2, 59, 37],
 ;;  [4, 36, 16, 4, 37, 17],
 ;;  [4, 36, 12, 4, 37, 13],
 ;;  // 10           
 ;;  [2, 86, 68, 2, 87, 69],
 ;;  [4, 69, 43, 1, 70, 44],
 ;;  [6, 43, 19, 2, 44, 20],
 ;;  [6, 43, 15, 2, 44, 16]
 ;;];
 ;;
 ;;QRRSBlock.getRSBlocks = function(typeNumber, errorCorrectLevel) {
 ;;  var rsBlock = QRRSBlock.getRsBlockTable(typeNumber, errorCorrectLevel);
 ;;  if (rsBlock == undefined) {
 ;;    throw new Error("bad rs block @ typeNumber:" + typeNumber + "/errorCorrectLevel:" + errorCorrectLevel);
 ;;  }
 ;;  var length = rsBlock.length / 3;
 ;;  var list = new Array();
 ;;  for (var i = 0; i < length; i++) {
 ;;    var count = rsBlock[i * 3 + 0];
 ;;    var totalCount = rsBlock[i * 3 + 1];
 ;;    var dataCount  = rsBlock[i * 3 + 2];
 ;;    for (var j = 0; j < count; j++) {
 ;;      list.push(new QRRSBlock(totalCount, dataCount) );       
 ;;    }
 ;;  }
 ;;  return list;
 ;;}
 ;;
 ;;QRRSBlock.getRsBlockTable = function(typeNumber, errorCorrectLevel) {
 ;;  switch(errorCorrectLevel) {
 ;;    case EWD.sencha.qrCode.errorCorrectLevel.L: return QRRSBlock.RS_BLOCK_TABLE[(typeNumber - 1) * 4 + 0];
 ;;    case EWD.sencha.qrCode.errorCorrectLevel.M: return QRRSBlock.RS_BLOCK_TABLE[(typeNumber - 1) * 4 + 1];
 ;;    case EWD.sencha.qrCode.errorCorrectLevel.Q: return QRRSBlock.RS_BLOCK_TABLE[(typeNumber - 1) * 4 + 2];
 ;;    case EWD.sencha.qrCode.errorCorrectLevel.H: return QRRSBlock.RS_BLOCK_TABLE[(typeNumber - 1) * 4 + 3];
 ;;    default: return undefined;
 ;;  }
 ;;}
 ;;
 ;;//---------------------------------------------------------------------
 ;;// QRBitBuffer
 ;;//---------------------------------------------------------------------
 ;;
 ;;function QRBitBuffer() {
 ;;  this.buffer = new Array();
 ;;  this.length = 0;
 ;;}
 ;;
 ;;QRBitBuffer.prototype = {
 ;;  get: function(index) {
 ;;    var bufIndex = Math.floor(index / 8);
 ;;    return ( (this.buffer[bufIndex] >>> (7 - index % 8) ) & 1) == 1;
 ;;  },
 ;;  put: function(num, length) {
 ;;    for (var i = 0; i < length; i++) {
 ;;      this.putBit( ( (num >>> (length - i - 1) ) & 1) == 1);
 ;;    }
 ;;  },
 ;;  getLengthInBits: function() {
 ;;    return this.length;
 ;;  },
 ;;  putBit: function(bit) {
 ;;    var bufIndex = Math.floor(this.length / 8);
 ;;    if (this.buffer.length <= bufIndex) {
 ;;      this.buffer.push(0);
 ;;    }
 ;;    if (bit) {
 ;;      this.buffer[bufIndex] |= (0x80 >>> (this.length % 8) );
 ;;    }
 ;;    this.length++;
 ;;  }
 ;;};
 ;;***END***
