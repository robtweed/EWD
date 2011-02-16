%zewdSTJS2 ; More Sencha Touch Static Javascript files
 ;
 ; Product: Enterprise Web Developer (Build 852)
 ; Build Date: Wed, 16 Feb 2011 15:47:20
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
touchGrid ;
 ;;EWD.sencha.touchGrid = {
 ;;  editCell: function(e, cell, dataview) {
 ;;    //console.log(grid);
 ;;    //console.log(el);
 ;;    //console.log(rowIndex);
 ;;    //console.log(e);
 ;;    var colIndex = cell.colIndex;
 ;;    var value = cell.value;
 ;;    var rowIndex = cell.rowIndex;
 ;;    var editPanel = Ext.getCmp('ewdSTTouchGridEditPanel');
 ;;    editPanel.showBy(e.target);
 ;;    Ext.getCmp("ewdSTTouchGridCell").setValue(value);
 ;;    var store = dataview.getStore();
 ;;    var record = store.getAt(rowIndex-1);
 ;;    cell.record = record;
 ;;    EWD.sencha.touchGrid.editedCell = cell;
 ;;  },
 ;;  updateCell: function() {
 ;;    var update = true;
 ;;    var cell = EWD.sencha.touchGrid.editedCell;
 ;;    var value = Ext.getCmp("ewdSTTouchGridCell").getValue();
 ;;    if (EWD.sencha.touchGrid.onSave) update = EWD.sencha.touchGrid.onSave(cell.rowIndex,cell.colIndex,value);
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
 ;;License      : GPL v3 (http://www.gnu.org/licenses/gpl.html)
 ;;Warranty     : none
 ;;Price        : free
 ;;Version      : 2.0b1
 ;;Date         : 1/31/2011
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
 ;;  layout: "fit",
 ;;  multiSelect: false,
 ;;  initComponent: function() {
 ;;    this.dataview = this.buildDataView();
 ;;    this.items = this.dataview;
 ;;    if (!Ext.isArray(this.dockedItems)) {
 ;;      this.dockedItems = [];
 ;;    }
 ;;    this.header = new Ext.Component(this.buildHeader());
 ;;    this.dockedItems.push(this.header);
 ;;    Ext.ux.TouchGridPanel.superclass.initComponent.call(this);
 ;;  },
 ;;  buildHeader: function() {
 ;;    var colModel = this.colModel,
 ;;      colNum = this.getColNum(false),
 ;;      cellWidth = 100/colNum,
 ;;      colTpl = '<table class="x-grid-header">';
 ;;    colTpl += '    <tr>';
 ;;    for (var i = 0; i < colModel.length; i++) {
 ;;      var col = colModel[i],
 ;;        flex = col.flex || 1,
 ;;        cls = "";
 ;;      var width = flex * cellWidth;
 ;;      if (col.hidden) {
 ;;        cls += "x-grid-col-hidden";
 ;;      }
 ;;      colTpl += '<td width="' + width + '%" class="x-grid-cell x-grid-hd-cell x-grid-col-' + col.mapping + ' ' + cls + '" mapping="' + col.mapping + '">' + col.header + '</td>';
 ;;    }
 ;;    colTpl += '    </tr>';
 ;;    colTpl += '</table>';
 ;;    return {
 ;;      dock: "top",
 ;;      html: colTpl,
 ;;      listeners: {
 ;;        scope: this,
 ;;        afterrender: this.initHeaderEvents
 ;;      }
 ;;    };
 ;;  },
 ;;  // addition for row selection
 ;;  initCellEvents: function(cmp) {
 ;;    var el = cmp.getEl();
 ;;    el.on("tap", this.onCellTap, this);
 ;;  },
 ;;  onCellTap: function(e, t) {
 ;;    e.stopEvent();
 ;;    var cellValue = t.innerText;
 ;;    var rowIndex = t.getAttribute('rowIndex');
 ;;    var colIndex = t.getAttribute('colIndex');
 ;;    var mapping = t.getAttribute("mapping");
 ;;    var cell = {value:cellValue,rowIndex:rowIndex,colIndex:colIndex,mapping:mapping};
 ;;    this.fireEvent("rowTap", e, cell, this.dataview);
 ;;  },
 ;;  //   end of addition
 ;;  //
 ;;  initHeaderEvents: function(cmp) {
 ;;    var el = cmp.getEl();
 ;;    el.on("click", this.handleHeaderClick, this);
 ;;  },
 ;;  handleHeaderClick: function(e, t) {
 ;;    e.stopEvent();
 ;;    var el = Ext.get(t);
 ;;    var mapping = el.getAttribute("mapping");
 ;;    if (typeof mapping === "string") {
 ;;      this.store.sort(mapping);
 ;;      el.set({
 ;;        sort: this.store.sortToggle[mapping]
 ;;      });
 ;;    }
 ;;  },
 ;;  buildDataView: function() {
 ;;    var colModel = this.colModel,
 ;;    colNum = this.getColNum(false),
 ;;    colTpl = '<tr class="x-grid-row">',
 ;;    cellWidth = 100/colNum;
 ;;    for (var i = 0; i < colModel.length; i++) {
 ;;      var col = colModel[i],
 ;;       flex  = col.flex || 1,
 ;;       width = flex * cellWidth,
 ;;       style = (i === colModel.length - 1) ? "padding-right: 10px;" : "",
 ;;       cls = col.cls || "";
 ;;      style += col.style || "";
 ;;      if (col.hidden) {
 ;;        cls += "x-grid-col-hidden";
 ;;      }
 ;;      colTpl += '<td width="' + width + '%" class="x-grid-cell x-grid-col-' + col.mapping + ' ' + cls + '" rowIndex={[xindex]} colIndex=' + i + ' style="' + style + '" mapping="' + col.mapping + '">{' + col.mapping + '}</td>';
 ;;    }
 ;;    colTpl += '</tr>';
 ;;    return new Ext.DataView({
 ;;      store: this.store,
 ;;      itemSelector: "tr.x-grid-row",
 ;;      simpleSelect: this.multiSelect,
 ;;      selectedItemCls: '',
 ;;      tpl: new Ext.XTemplate(
 ;;        '<table style="width: 100%;">',
 ;;        '<tpl for=".">',
 ;;        colTpl,
 ;;        '</tpl>',
 ;;        '</table>'
 ;;      ),
 ;;      bubbleEvents: [
 ;;        "beforeselect",
 ;;        "containertap",
 ;;        "itemdoubletap",
 ;;        "itemswipe",
 ;;        "itemtap",
 ;;        "selectionchange"
 ;;      ],
 ;;      listeners: {
 ;;        scope: this,
 ;;        afterrender: this.initCellEvents
 ;;      }
 ;;    });
 ;;  },
 ;;  // hidden = true to count all columns
 ;;  getColNum: function(hidden) {
 ;;    var colModel = this.colModel,
 ;;    colNum   = 0;
 ;;    for (var i = 0; i < colModel.length; i++) {
 ;;      var col = colModel[i];
 ;;      if (!hidden && typeof col.header !== "string") { continue; }
 ;;      if (!col.hidden) {
 ;;        colNum += col.flex || 1;
 ;;      }
 ;;    }
 ;;    return colNum;
 ;;  },
 ;;  getMappings: function() {
 ;;    var mappings = {},
 ;;    colModel = this.colModel;
 ;;    for (var i = 0; i < colModel.length; i++) {
 ;;      mappings[colModel[i].mapping] = i
 ;;    }
 ;;    return mappings;
 ;;  },
 ;;  toggleColumn: function(index) {
 ;;    if (typeof index === "string") {
 ;;      var mappings = this.getMappings();
 ;;      index = mappings[index];
 ;;    }
 ;;    var el = this.getEl(),
 ;;     mapping = this.colModel[index].mapping,
 ;;     cells = el.query("td.x-grid-col-"+mapping);
 ;;    for (var c = 0; c < cells.length; c++) {
 ;;      var cellEl = Ext.get(cells[c]);
 ;;      if (cellEl.hasCls("x-grid-col-hidden")) {
 ;;        cellEl.removeCls("x-grid-col-hidden");
 ;;        this.colModel[index].hidden = false;
 ;;      }
 ;;      else {
 ;;        cellEl.addCls("x-grid-col-hidden");
 ;;        this.colModel[index].hidden = true;
 ;;      }
 ;;    }
 ;;    this.updateWidths();
 ;;  },
 ;;  updateWidths: function() {
 ;;    var el = this.getEl(),
 ;;     headerWidth = this.header.getEl().getWidth(),
 ;;     colModel = this.colModel,
 ;;     cells = el.query("td.x-grid-cell"),
 ;;     colNum = this.getColNum(false),
 ;;     cellWidth = 100 / colNum;
 ;;    var mappings = this.getMappings();
 ;;    for (var c = 0; c < cells.length; c++) {
 ;;      var cellEl = Ext.get(cells[c]),
 ;;       mapping = cellEl.getAttribute("mapping"),
 ;;       col = colModel[mappings[mapping]],
 ;;       flex = col.flex || 1,
 ;;       width = flex * cellWidth / 100 * headerWidth;
 ;;      cellEl.setWidth(width);
 ;;    }
 ;;  }
 ;;});
 ;;Ext.reg("touchgridpanel", Ext.ux.TouchGridPanel);
 ;;***END***
 ;;
touchGridOld ;
 ;;EWD.sencha.touchGrid = {
 ;;  editCell: function(grid,el,rowIndex,e) {
 ;;    //alert("row: " + rowIndex + "; col: " + el.dom.getAttribute('colIndex') + "; " + el.dom.innerHTML);
 ;;    //console.log(grid);
 ;;    //console.log(el);
 ;;    //console.log(rowIndex);
 ;;    //console.log(e);
 ;;    var colIndex = el.dom.getAttribute('colIndex');
 ;;    if (!colIndex) {
 ;;      colIndex = el.dom.parentNode.getAttribute('colIndex');
 ;;      rowIndex = el.dom.parentNode.getAttribute('rowIndex');
 ;;    }
 ;;    var record = grid.store.getAt(rowIndex);
 ;;    var mapping = grid.colModel[colIndex].mapping;
 ;;    var value = record.get(mapping);
 ;;    var editPanel = Ext.getCmp('ewdSTTouchGridEditPanel');
 ;;    editPanel.showBy(el);
 ;;    Ext.getCmp("ewdSTTouchGridCell").setValue(value);
 ;;    EWD.sencha.touchGrid.editedCell = {grid:grid,record:record,colIndex:colIndex,rowIndex:rowIndex,mapping:mapping,value:value};
 ;;  },
 ;;  updateCell: function() {
 ;;    var update = true;
 ;;    var cell = EWD.sencha.touchGrid.editedCell;
 ;;    var value = Ext.getCmp("ewdSTTouchGridCell").getValue();
 ;;    if (EWD.sencha.touchGrid.onSave) update = EWD.sencha.touchGrid.onSave(cell.rowIndex,cell.colIndex,value);
 ;;    if (update) {
 ;;      if (value != cell.oldValue) {
 ;;        cell.record.set(cell.mapping,value);
 ;;        cell.grid.refresh();
 ;;      }
 ;;    }
 ;;    Ext.getCmp('ewdSTTouchGridEditPanel').hide();
 ;;  }
 ;;};
 ;;
 ;;/*
 ;;    Author       : Mitchell Simoens
 ;;    Site         : http://simoens.org/Sencha-Projects/demos/
 ;;    Contact Info : mitchellsimoens@gmail.com
 ;;    Purpose      : Creation of a grid for Sencha Touch
 ;;	   License      : GPL v3 (http://www.gnu.org/licenses/gpl.html)
 ;;    Warranty     : none
 ;;    Price        : free
 ;;    Version      : 1.5.1
 ;;    Date         : 12/16/2010
 ;;*/
 ;;
 ;;/*
 ;; * Limitation of CSS3 columns is there cannot be different widths.
 ;; * Future spec may include this.
 ;; */
 ;;
 ;;Ext.ns("Ext.ux");
 ;;
 ;;Ext.ux.TouchGridPanel = Ext.extend(Ext.Panel, {
 ;;  defaultRenderer: function(value) {
 ;;    return value;
 ;;  },
 ;;  selModel: {
 ;;   singleSelect: false,
 ;;   locked: false
 ;;  },
 ;;  initComponent: function() {
 ;;    this.templates = this.initTemplates();
 ;;    Ext.ux.TouchGridPanel.superclass.initComponent.call(this);
 ;;    this.on("afterrender", this.renderGrid, this);
 ;;  },
 ;;  initTemplates: function() {
 ;;    var templates = {};
 ;;    templates.wrap = new Ext.XTemplate(
 ;;      '<tpl for=".">',
 ;;        '{header}',
 ;;        '{body}',
 ;;      '</tpl>'
 ;;    ).compile();
 ;;    templates.header = new Ext.XTemplate(
 ;;      '<tpl for=".">',
 ;;        '<div class="x-grid-header" style="{style}">{row}</div>',
 ;;      '</tpl>'
 ;;    ).compile();
 ;;    templates.body = new Ext.XTemplate(
 ;;      '<tpl for=".">',
 ;;        '<div class="x-grid-rows" style="{style}">{rows}</div>',
 ;;      '</tpl>'
 ;;    ).compile();
 ;;    templates.row = new Ext.XTemplate(
 ;;      '<tpl for=".">',
 ;;        '<div class="x-grid-row" style="{style}" rowIndex="{rowIndex}" selected="false">{cells}</div>',
 ;;      '</tpl>'
 ;;    ).compile();
 ;;    templates.cell = new Ext.XTemplate(
 ;;      '<tpl for=".">',
 ;;        '<div class="x-grid-cell {addlClass}" rowIndex="{rowIndex}" colIndex="{colIndex}">{text}</div>',
 ;;      '</tpl>'
 ;;    ).compile();
 ;;    return templates;
 ;;  },
 ;;  initScroller: function() {
 ;;    var scrollers = {};
 ;;    scrollers.rows = new Ext.util.Scroller(this.body.dom.lastChild, {
 ;;      direction: "vertical",
 ;;      listeners: {
 ;;        scope: this,
 ;;        scrollstart: this.onScrollStart,
 ;;        scrollend: this.onScrollEnd
 ;;      }
 ;;    });
 ;;    scrollers.wrap = new Ext.util.Scroller(this.body, {
 ;;      direction: "horizontal",
 ;;      listeners: {
 ;;        scope: this,
 ;;        scrollstart: this.onScrollStart,
 ;;        scrollend: this.onScrollEnd
 ;;      }
 ;;    });
 ;;    this.scrollers = scrollers;
 ;;  },
 ;;  initEvents: function() {
 ;;    Ext.ux.TouchGridPanel.superclass.initEvents.call(this);
 ;;    if (this.isRendered === true) {
 ;;      return ;
 ;;    }
 ;;    var el = this.body;
 ;;    this.mon(el, {
 ;;      scope: this,
 ;;      tap: this.onTap
 ;;    });	
 ;;    this.store.on({
 ;;      scope: this,
 ;;      datachanged: this.onDataChange
 ;;    });
 ;;    var header = el.child(".x-grid-header");
 ;;    header.on("tap", this.handleHdDown, this);
 ;;  },
 ;;	 initSelModel: function() {
 ;;   this.on("rowtap", this.onRowTapSelModel, this);
 ;;  },
 ;;  handleHdDown: function(e, target) {
 ;;    var colModel  = this.colModel,
 ;;      el = Ext.get(target),
 ;;      index = this.findColumnIndex(el),
 ;;      column = colModel[index],
 ;;      direction = this.sortDirection;
 ;;    this.sortDirection = (this.sortDirection === "ASC") ? "DESC" : "ASC";
 ;;    this.clearSortIcons();
 ;;    el.set({"sort": this.sortDirection});
 ;;    this.store.sort(column.mapping, this.sortDirection);
 ;;  },
 ;;  onDataChange: function() {
 ;;    this.refresh();
 ;;  },
 ;;  onRowTapSelModel: function(grid, el, index, e) {
 ;;    var row = Ext.get(el.findParent(".x-grid-row"));
 ;;    this.selectRows(row);
 ;;  },
 ;;  onScrollStart: function() {
 ;;    this.lockSelection(true);
 ;;  },
 ;;  onScrollEnd: function() {
 ;;    this.lockSelection(false);
 ;;  },
 ;;  onTap: function(e) {
 ;;    this.processEvent("tap", e);
 ;;  },
 ;;  lockSelection: function(lock) {
 ;;    this.selModel.locked = lock;
 ;;  },
 ;;  renderGrid: function() {
 ;;    var templates = this.templates;
 ;;    var header = this.renderHeader();
 ;;    var body = this.renderRows();
 ;;    var wrap = templates.wrap.apply({
 ;;      header: header,
 ;;      body: body
 ;;    });
 ;;    this.update(wrap);
 ;;    this.initEvents();
 ;;    this.initScroller();
 ;;    this.initSelModel();
 ;;    this.isRendered = true;
 ;;  },
 ;;  renderHeader: function() {
 ;;    var colModel = this.colModel,
 ;;    totNumCol = this.getColumnCount(true),
 ;;    numCol = this.getColumnCount(),
 ;;    templates = this.templates,
 ;;    header = "";
 ;;    for (var i = 0; i < totNumCol; i++) {
 ;;      var column = colModel[i];
 ;;      if (column.hidden !== true) {
 ;;        var renderer = column.renderer || this.defaultRenderer;
 ;;        column.renderer = renderer;
 ;;        header += templates.cell.apply({
 ;;          rowIndex: null,
 ;;          colIndex: i,
 ;;          addlClass: "x-grid-hd-cell",
 ;;          text: column.header
 ;;        });
 ;;      }
 ;;    }
 ;;    return templates.header.apply({
 ;;      row: header,
 ;;      style: "-webkit-column-count:"+numCol
 ;;    });
 ;;  },
 ;;  renderRows: function(start, end) {
 ;;    var startRow = startRow || 0,
 ;;      endRow   = Ext.isDefined(endRow) ? endRow : this.store.getCount() - 1,
 ;;      records  = this.store.getRange(startRow, endRow);
 ;;    return this.doRenderRows(records, startRow);
 ;;  },
 ;;  doRenderRows: function(records, start) {
 ;;    var numRecs = records.length,
 ;;	   colModel = this.colModel,
 ;;    totNumCol = this.getColumnCount(true),
 ;;    numCol = this.getColumnCount(),
 ;;    templates = this.templates;
 ;;    var rows = "";
 ;;    for (var i = 0; i < numRecs; i++) {
 ;;      var record = records[i];
 ;;      var row = "";
 ;;      for (var x = 0; x < totNumCol; x++) {
 ;;        var column = colModel[x];
 ;;        if (column.hidden !== true) {
 ;;          var text = column.renderer.call(this, record.get(column.mapping), record, i, x, this.store);
 ;;          row += templates.cell.apply({
 ;;            rowIndex: i,
 ;;            colIndex: x,
 ;;            text: text,
 ;;            addlClass: "x-grid-cell-no-of"
 ;;          });
 ;;        }
 ;;      }
 ;;      rows += templates.row.apply({
 ;;        rowIndex: i,
 ;;        cells: row,
 ;;        style: "-webkit-column-count:"+numCol
 ;;      });
 ;;    }
 ;;    return templates.body.apply({
 ;;      rows: rows
 ;;    });
 ;;  },
 ;;  getRow: function(index, returnDom) {
 ;;    var node = this.body.child(".x-grid-rows").dom.childNodes[index];
 ;;    if (returnDom !== true) {
 ;;      node = Ext.get(node);
 ;;    }
 ;;    return node;
 ;;  },
 ;;  selectRows: function(rows) {
 ;;    if (this.selModel.locked === true) {
 ;;      return ;
 ;;    }
 ;;    if (!Ext.isArray(rows)) {
 ;;      rows = [rows];
 ;;    }
 ;;    for (var i = 0; i < rows.length; i++ ) {
 ;;      var row = rows[i],
 ;;        selected = row.getAttribute("selected"),
 ;;        newSelect = (selected === "true") ? false : true,
 ;;        deselect = (newSelect === false) ? "de" : "",
 ;;        index = row.getAttribute("rowIndex"),
 ;;        record = this.store.getAt(index);
 ;;      if (this.fireEvent("beforerow"+deselect+"select", this, index, record) !== false) {
 ;;        if (this.selModel.singleSelect) {
 ;;          var selected = this.selModel.selected;
 ;;          if (typeof selected !== "undefined" && selected !== row) {
 ;;            selected.set({
 ;;              selected : false
 ;;            });
 ;;          }
 ;;          this.selModel.selected = row;
 ;;        }
 ;;        row.set({
 ;;          selected: newSelect
 ;;        });
 ;;        this.fireEvent("row"+deselect+"select", this, index, record);
 ;;        this.fireEvent("selectionchange", this);
 ;;      }
 ;;    }
 ;;  },
 ;;  isHeader: function(el) {
 ;;    var isHdCell = el.hasCls("x-grid-hd-cell"),
 ;;       isHdRow = el.hasCls("x-grid-header");
 ;;    if (isHdCell === true || isHdRow === true) {
 ;;      return true;
 ;;    }
 ;;    return false;
 ;;  },
 ;;  findRowIndex: function(el) {
 ;;    return parseFloat(el.getAttribute("rowIndex"));
 ;;  },
 ;;  findColumnIndex: function(el) {
 ;;    return parseFloat(el.getAttribute("colIndex"));
 ;;  },
 ;;  getStore: function() {
 ;;    return this.store;
 ;;  },
 ;;  getColumnModel: function() {
 ;;    return this.colModel;
 ;;  },
 ;;  getColumnCount: function(getHidden) {
 ;;    if (getHidden === true) {
 ;;      return this.colModel.length;
 ;;    }
 ;;    var i = 0,
 ;;      count = 0;
 ;;    for (; i < this.colModel.length; i++) {
 ;;      if (this.colModel[i].hidden !== true) {
 ;;        count++;
 ;;      }
 ;;    }
 ;;    return count;
 ;;  },
 ;;  getColumn: function(index) {
 ;;    return this.colModel[index];
 ;;  },
 ;;  clearSelections: function() {
 ;;    var rows = this.body.child(".x-grid-rows"),
 ;;      nodes = rows.dom.children;
 ;;    for (i = 0; i < nodes.length; i++) {
 ;;      node = Ext.get(nodes[i]);
 ;;      node.set({
 ;;        selected : false
 ;;      });
 ;;    }
 ;;    delete this.selModel.selected;
 ;;  },
 ;;  clearSortIcons: function() {
 ;;    var header = this.body.child(".x-grid-header"),
 ;;      nodes = header.dom.children;
 ;;    for (i = 0; i < nodes.length; i++) {
 ;;      node = Ext.get(nodes[i]);
 ;;      node.set({
 ;;        sort : null
 ;;      });
 ;;    }
 ;;  },
 ;;  moveColumn: function(oldIndex, newIndex) {
 ;;    var colModel = this.colModel,
 ;;      column = colModel[oldIndex];
 ;;    colModel.splice(oldIndex, 1);
 ;;    colModel.splice(newIndex, 0, column);
 ;;    this.colModel = colModel;
 ;;    this.refresh(true);
 ;;  },
 ;;  hideColumn: function(index, cancelRefresh) {
 ;;    this.colModel[index].hidden = true;
 ;;    if (cancelRefresh !== true) {
 ;;      this.refresh(true);
 ;;    }
 ;;  },
 ;;  refreshHeaders: function() {
 ;;    var el = this.body.child(".x-grid-header");
 ;;    el.update(this.renderHeaders());
 ;;  },
 ;;  refresh: function(headers) {
 ;;    if (this.fireEvent("beforerefresh", this, headers) === false) {
 ;;      return ;
 ;;    }
 ;;    if (headers === true) {
 ;;      this.refreshHeaders();
 ;;    }
 ;;    var el = this.body.child(".x-grid-rows");
 ;;    el.setStyle("padding-top", "0em");
 ;;    el.update(this.renderRows());
 ;;    this.fireEvent("refresh", this);
 ;;  },
 ;;  processEvent: function(name, e) {
 ;;    var target = e.getTarget(),
 ;;      el = Ext.get(target),
 ;;      isHeader = this.isHeader(el);
 ;;    this.fireEvent(name, e);
 ;;    if (isHeader === true) {
 ;;      var header = el.findParent(".x-grid-header");
 ;;      this.fireEvent("header" + name, this, header, el, e);
 ;;    } 
 ;;    else {
 ;;      var rowIndex = this.findRowIndex(el);
 ;;      if (typeof rowIndex === "number") {
 ;;        var colIndex = this.findColumnIndex(el);
 ;;        if (typeof colIndex === "number") {
 ;;          if (this.fireEvent("cell" + name, this, el, rowIndex, colIndex, e) !== false) {
 ;;            this.fireEvent("row" + name, this, el, rowIndex, e);
 ;;          }
 ;;        } 
 ;;        else {
 ;;          if (this.fireEvent("row" + name, this, el, rowIndex, e) !== false) {
 ;;            this.fireEvent("rowbody" + name, this, el, rowIndex, e);
 ;;          }
 ;;        }
 ;;      }
 ;;      else {
 ;;        this.fireEvent("container" + name, this, el, e);
 ;;      }
 ;;    }
 ;;  }
 ;;});
 ;;Ext.reg("touchgridpanel", Ext.ux.TouchGridPanel);
 ;;
 ;;***END***
 ;;
combo ;
 ;; EWD.sencha.combo = {
 ;;  panel: {},
 ;;  filter: function(params) {
 ;;    var seed = params.seed;
 ;;    var id = params.id;
 ;;    EWD.sencha.combo.id = id;
 ;;    var panel = Ext.getCmp('ewdComboPanel')
 ;;    panel.showBy(Ext.getCmp(id));
 ;;    panel.setWidth(params.width);
 ;;    panel.setHeight(params.height);
 ;;    Ext.getCmp("ewdComboMatches").scroller.scrollTo({x: 0, y: 0});
 ;;    EWD.ajax.getPage({page:'zewdComboMatches',nvp:'seed=' + seed + "&id=" + id});
 ;;  },
 ;;  selectItem: function(index,record) {
 ;;    Ext.getCmp(EWD.sencha.combo.id).setValue(record.get("text"));
 ;;    Ext.getCmp(EWD.sencha.combo.id).blur();
 ;;    Ext.getCmp('ewdComboPanel').hide();
 ;;  }
 ;;};
 ;;
 ;;***END***
 ;;
