%zewdSTJS2 ; More Sencha Touch Static Javascript files
 ;
 ; Product: Enterprise Web Developer (Build 908)
 ; Build Date: Mon, 23 Apr 2012 11:56:20
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
touchGrid ;
 ;;EWD.sencha.touchGrid = {
 ;;  editCell: function(e, cell, dataview) {
 ;;    //console.log(grid);
 ;;    //console.log(el);
 ;;    //console.log(rowIndex);
 ;;    //console.log(e);
 ;;    var value = cell.value;
 ;;    var rowIndex = cell.rowIndex;
 ;;    var edit = true;
 ;;    if (EWD.sencha.touchGrid.allowEdit) edit = EWD.sencha.touchGrid.allowEdit(rowIndex,cell.mapping,value);
 ;;    if (edit) {
 ;;      var editPanel = Ext.getCmp('ewdSTTouchGridEditPanel');
 ;;      editPanel.showBy(e.target);
 ;;      Ext.getCmp("ewdSTTouchGridCell").setValue(value);
 ;;      var store = dataview.getStore();
 ;;      var record = store.getAt(rowIndex);
 ;;      cell.record = record;
 ;;      EWD.sencha.touchGrid.editedCell = cell;
 ;;    }
 ;;  },
 ;;  getPage: function(e, cell, dataview) {
 ;;    //console.log(grid);
 ;;    //console.log(el);
 ;;    //console.log(rowIndex);
 ;;    //console.log(e);
 ;;    var value = cell.value;
 ;;    var rowIndex = cell.rowIndex;
 ;;    if (rowIndex !== null) {
 ;;      var nvp = 'rowIndex=' + rowIndex + '&columnName=' + cell.mapping + '&cellValue=' + value;
 ;;      EWD.ajax.getPage({page: EWD.sencha.touchGrid.nextPage, nvp: nvp, targetId: 'ewdNullId'});
 ;;    }
 ;;  },
 ;;  updateCell: function() {
 ;;    var update = true;
 ;;    var cell = EWD.sencha.touchGrid.editedCell;
 ;;    var value = Ext.getCmp("ewdSTTouchGridCell").getValue();
 ;;    if (EWD.sencha.touchGrid.onSave) update = EWD.sencha.touchGrid.onSave(cell.rowIndex,cell.mapping,value);
 ;;    if (update) {
 ;;      if (value != cell.oldValue) {
 ;;        cell.record.set(cell.mapping,value);
 ;;      }
 ;;    }
 ;;    Ext.getCmp('ewdSTTouchGridEditPanel').hide();
 ;;  }
 ;;};
 ;;/*
 ;;Author       : Mitchell Simoens
 ;;Site         : http://simoens.org/Sencha-Projects/demos/
 ;;Contact Info : mitchellsimoens@gmail.com
 ;;Purpose      : Creation of a grid for Sencha Touch
 ;;
 ;;License      : MIT (http://www.opensource.org/licenses/mit-license.php)
 ;;Warranty     : none
 ;;Price        : free
 ;;Version      : 2.0b2
 ;;Date         : 3/22/2011
 ;;*/
 ;;
 ;;/*
 ;; * Because of limitation of the current WebKit implementation of CSS3 column layout,
 ;; * I have decided to revert back to using table.
 ;; */
 ;;
 ;;Ext.ns("Ext.ux");
 ;;
 ;;Ext.ux.TouchGridPanel = Ext.extend(Ext.Panel, {
 ;;	layout        : "fit",
 ;;
 ;;	multiSelect   : false,
 ;;	scroll        : "vertical",
 ;;
 ;;	initComponent : function() {
 ;;		var me = this;
 ;;
 ;;		me.items = me.dataview = me.buildDataView();
 ;;
 ;;		if (!Ext.isArray(me.dockedItems)) {
 ;;			me.dockedItems = [];
 ;;		}
 ;;
 ;;		me.header = new Ext.Component(me.buildHeader());
 ;;		me.dockedItems.push(me.header);
 ;;
 ;;		Ext.ux.TouchGridPanel.superclass.initComponent.call(me);
 ;;
 ;;		var store = me.store;
 ;;
 ;;		store.on("update", me.dispatchDataChanged, me);
 ;;	},
 ;;
 ;;	dispatchDataChanged: function(store, rec, operation) {
 ;;		var me = this;
 ;;
 ;;		me.fireEvent("storeupdate", store, rec, operation);
 ;;	},
 ;;
 ;;	buildHeader   : function() {
 ;;		var me        = this,
 ;;			colModel  = me.colModel,
 ;;			colNum    = me.getColNum(false),
 ;;			cellWidth = 100/colNum,
 ;;			colTpl    = '<table class="x-grid-header">';
 ;;
 ;;		colTpl += '    <tr>';
 ;;		for (var i = 0; i < colModel.length; i++) {
 ;;			var col  = colModel[i],
 ;;				flex = col.flex || 1,
 ;;				cls  = "";
 ;;
 ;;			var width = flex * cellWidth;
 ;;
 ;;			if (col.hidden) {
 ;;				cls += "x-grid-col-hidden";
 ;;			}
 ;;
 ;;			colTpl += '<td width="' + width + '%" class="x-grid-cell x-grid-hd-cell x-grid-col-' + col.mapping + ' ' + cls + '" mapping="' + col.mapping + '">' + col.header + '</td>';
 ;;		}
 ;;		colTpl += '    </tr>';
 ;;		colTpl += '</table>';
 ;;
 ;;		return {
 ;;			dock      : "top",
 ;;			html      : colTpl,
 ;;			listeners : {
 ;;				scope       : me,
 ;;				afterrender : me.initHeaderEvents
 ;;			}
 ;;		};
 ;;	},
 ;;
 ;;	initHeaderEvents: function(cmp) {
 ;;		var me = this,
 ;;			el = cmp.getEl();
 ;;
 ;;		el.on("click", me.handleHeaderClick, me);
 ;;	},
 ;;
 ;;	handleHeaderClick: function(e, t) {
 ;;		e.stopEvent();
 ;;
 ;;		var me      = this,
 ;;			el      = Ext.get(t),
 ;;			mapping = el.getAttribute("mapping");
 ;;
 ;;		if (typeof mapping === "string") {
 ;;			me.store.sort(mapping);
 ;;			el.set({
 ;;				sort : me.store.sortToggle[mapping]
 ;;			});
 ;;		}
 ;;	},
 ;;  // addition for row selection
 ;;  initCellEvents: function(cmp) {
 ;;    var el = cmp.getEl();
 ;;    el.on("tap", this.onCellTap, this);
 ;;  },
 ;;  onCellTap: function(e, t) {
 ;;    e.stopEvent();
 ;;    if (t.getAttribute('rowindex') === null) t = t.parentNode;
 ;;    var rowIndex = t.getAttribute('rowindex');
 ;;    var cellValue = t.innerText;
 ;;    var mapping = t.getAttribute("mapping");
 ;;    var cell = {value:cellValue,rowIndex:rowIndex,mapping:mapping};
 ;;    this.fireEvent("rowTap", e, cell, this.dataview);
 ;;  },
 ;;  //   end of addition
 ;;  //
 ;;	buildDataView : function() {
 ;;		var me        = this,
 ;;			colModel  = me.colModel,
 ;;			colNum    = me.getColNum(false),
 ;;			colTpl    = '<tr class="x-grid-row {isDirty:this.isRowDirty(parent)}">',
 ;;			cellWidth = 100/colNum;
 ;;
 ;;		for (var i = 0; i < colModel.length; i++) {
 ;;			var col   = colModel[i],
 ;;				flex  = col.flex || 1,
 ;;				width = flex * cellWidth,
 ;;				style = (i === colModel.length - 1) ? "padding-right: 10px;" : "",
 ;;				cls   = col.cls || "";
 ;;
 ;;			style += col.style || "";
 ;;
 ;;			if (col.hidden) {
 ;;				cls += "x-grid-col-hidden";
 ;;			}
 ;;
 ;;			colTpl += '<td width="' + width + '%" class="x-grid-cell x-grid-col-' + col.mapping + ' ' + cls + ' {isDirty:this.isCellDirty(parent)}" style="' + style + '" mapping="' + col.mapping + '" rowIndex="{rowIndex}">{' + col.mapping + '}</td>';
 ;;		}
 ;;		colTpl += '</tr>';
 ;;
 ;;		return new Ext.DataView({
 ;;			store        : me.store,
 ;;			itemSelector : "tr.x-grid-row",
 ;;			simpleSelect : me.multiSelect,
 ;;			scroll       : me.scroll,
 ;;			tpl          : new Ext.XTemplate(
 ;;				'<table style="width: 100%;">',
 ;;					'<tpl for=".">',
 ;;						colTpl,
 ;;					'</tpl>',
 ;;				'</table>',
 ;;				{
 ;;					isRowDirty: function(dirty, data) {
 ;;						return dirty ? "x-grid-row-dirty" : "";
 ;;					},
 ;;					isCellDirty: function(dirty, data) {
 ;;						return dirty ? "x-grid-cell-dirty" : "";
 ;;					}
 ;;				}
 ;;			),
 ;;			prepareData  : function(data, index, record) {
 ;;				var column,
 ;;					i  = 0,
 ;;					ln = colModel.length;
 ;;
 ;;				data.dirtyFields = {};
 ;;
 ;;				for (; i < ln; i++) {
 ;;					column = colModel[i];
 ;;					if (typeof column.renderer === "function") {
 ;;						data[column.mapping] = column.renderer.apply(me, [data[column.mapping]]);
 ;;					}
 ;;				}
 ;;
 ;;				data.isDirty = record.dirty;
 ;;
 ;;				data.rowIndex = index;
 ;;
 ;;				return data;
 ;;			},
 ;;			bubbleEvents : [
 ;;				"beforeselect",
 ;;				"containertap",
 ;;				"itemdoubletap",
 ;;				"itemswipe",
 ;;				"itemtap",
 ;;				"selectionchange"
 ;;			],
 ;;         listeners: {
 ;;           scope: this,
 ;;           afterrender: this.initCellEvents
 ;;         }
 ;;		});
 ;;	},
 ;;
 ;;	// hidden = true to count all columns
 ;;	getColNum     : function(hidden) {
 ;;		var me       = this,
 ;;			colModel = me.colModel,
 ;;			colNum   = 0;
 ;;
 ;;		for (var i = 0; i < colModel.length; i++) {
 ;;			var col = colModel[i];
 ;;			if (!hidden && typeof col.header !== "string") { continue; }
 ;;			if (!col.hidden) {
 ;;				colNum += col.flex || 1;
 ;;			}
 ;;		}
 ;;
 ;;		return colNum;
 ;;	},
 ;;
 ;;	getMappings: function() {
 ;;		var me       = this,
 ;;			mappings = {},
 ;;			colModel = me.colModel;
 ;;
 ;;		for (var i = 0; i < colModel.length; i++) {
 ;;			mappings[colModel[i].mapping] = i
 ;;		}
 ;;
 ;;		return mappings;
 ;;	},
 ;;
 ;;	toggleColumn: function(index) {
 ;;		var me = this;
 ;;
 ;;		if (typeof index === "string") {
 ;;			var mappings = me.getMappings();
 ;;			index = mappings[index];
 ;;		}
 ;;		var el      = me.getEl(),
 ;;			mapping = me.colModel[index].mapping,
 ;;			cells   = el.query("td.x-grid-col-"+mapping);
 ;;
 ;;		for (var c = 0; c < cells.length; c++) {
 ;;			var cellEl = Ext.get(cells[c]);
 ;;			if (cellEl.hasCls("x-grid-col-hidden")) {
 ;;				cellEl.removeCls("x-grid-col-hidden");
 ;;				this.colModel[index].hidden = false;
 ;;			} else {
 ;;				cellEl.addCls("x-grid-col-hidden");
 ;;				this.colModel[index].hidden = true;
 ;;			}
 ;;		}
 ;;
 ;;		me.updateWidths();
 ;;	},
 ;;
 ;;	updateWidths: function() {
 ;;		var me          = this,
 ;;			el          = me.getEl(),
 ;;			headerWidth = me.header.getEl().getWidth(),
 ;;			colModel    = me.colModel,
 ;;			cells       = el.query("td.x-grid-cell"),
 ;;			colNum      = me.getColNum(false),
 ;;			cellWidth   = 100 / colNum,
 ;;			mappings    = me.getMappings();
 ;;
 ;;		for (var c = 0; c < cells.length; c++) {
 ;;			var cellEl  = Ext.get(cells[c]),
 ;;				mapping = cellEl.getAttribute("mapping"),
 ;;				col     = colModel[mappings[mapping]],
 ;;				flex    = col.flex || 1,
 ;;				width   = flex * cellWidth / 100 * headerWidth;
 ;;
 ;;			cellEl.setWidth(width);
 ;;		}
 ;;	},
 ;;
 ;;	scrollToRow: function(index) {
 ;;		var me       = this,
 ;;			el       = me.getEl(),
 ;;			rows     = el.query("tr.x-grid-row"),
 ;;			rowEl    = Ext.get(rows[index]),
 ;;			scroller = me.dataview.scroller;
 ;;
 ;;		var pos = {
 ;;			x: 0,
 ;;			y: rowEl.dom.offsetTop
 ;;		};
 ;;
 ;;		scroller.scrollTo(pos, true);
 ;;	},
 ;;
 ;;	getView: function() {
 ;;		var me = this;
 ;;
 ;;		return me.dataview;
 ;;	},
 ;;
 ;;	bindStore: function(store) {
 ;;		var me   = this,
 ;;			view = me.getView();
 ;;
 ;;		view.bindStore(store);
 ;;	},
 ;;
 ;;	getStore: function() {
 ;;		var me   = this,
 ;;			view = me.getView();
 ;;
 ;;		return view.getStore();
 ;;	},
 ;;
 ;;	getRow: function(index) {
 ;;		var me = this;
 ;;		if (typeof index === "object") {
 ;;			var store = me.getStore(),
 ;;				index = store.indexOf(index);
 ;;		}
 ;;
 ;;		var el   = me.getEl(),
 ;;			rows = el.query("tr");
 ;;
 ;;		return rows[index+1];
 ;;	}
 ;;});
 ;;
 ;;Ext.reg("touchgridpanel", Ext.ux.TouchGridPanel);
 ;;
 ;;***END***
 ;;
combo ;
 ;; EWD.sencha.combo = {
 ;;  init: function() {
 ;;    Ext.regModel('ewdComboMatches', {
 ;;      fields: ['text']
 ;;    });
 ;;    EWD.sencha.combo.store = new Ext.data.JsonStore({
 ;;      model: 'ewdComboMatches'
 ;;    });
 ;;    EWD.sencha.widget.zewdComboList = new Ext.List({
 ;;      id: "ewdComboMatches",
 ;;      itemTpl: "{text}",
 ;;      scroll: true,
 ;;      store: EWD.sencha.combo.store,
 ;;      listeners: {
 ;;        itemtap: function (view, index, item, e) {
 ;;          var record = EWD.sencha.combo.store.getAt(index);
 ;;          EWD.sencha.combo.selectItem(index, record);
 ;;        }
 ;;      }
 ;;    });
 ;;    EWD.sencha.widget.zewdcm = new Ext.Panel({
 ;;      draggable:false,
 ;;      floating:true,
 ;;      height:200,
 ;;      hidden:true,
 ;;      hideOnMaskTap:true,
 ;;      id:'zewdComboPanel',
 ;;      layout:'fit',
 ;;      modal:false,
 ;;      scroll:'vertical',
 ;;      width:400,
 ;;      items:[]
 ;;    });
 ;;  },
 ;;  listAdded: false,
 ;;  panel: {},
 ;;  filter: function(params) {
 ;;    var seed = params.seed;
 ;;    var id = params.id;
 ;;    var width = params.width;
 ;;    var height = params.height;
 ;;    if (Ext.is.Phone) {
 ;;      width = params.phoneWidth;
 ;;      height = params.phoneHeight;
 ;;    }
 ;;    EWD.sencha.combo.id = id;
 ;;    var panel = Ext.getCmp('zewdComboPanel')
 ;;    panel.showBy(Ext.getCmp(id));
 ;;    panel.setWidth(width);
 ;;    panel.setHeight(height);
 ;;    if (!EWD.sencha.combo.listAdded) {
 ;;      panel.add(Ext.getCmp("ewdComboMatches"));
 ;;      panel.doLayout();
 ;;      EWD.sencha.combo.listAdded = true;
 ;;    }
 ;;    Ext.getCmp("ewdComboMatches").scroller.scrollTo({x: 0, y: 0});
 ;;    EWD.ajax.getPage({page:'zewdcm',nvp:'seed=' + seed + "&id=" + id});
 ;;  },
 ;;  selectItem: function(index,record) {
 ;;    Ext.getCmp(EWD.sencha.combo.id).setValue(record.get("text"));
 ;;    Ext.getCmp(EWD.sencha.combo.id).blur();
 ;;    Ext.getCmp('zewdComboPanel').hide();
 ;;  }
 ;;};
 ;;
 ;;***END***
 ;;
