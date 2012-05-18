%zewdExt4Map ; Extjs Tag Processor Mappings
 ;
 ; Product: Enterprise Web Developer (Build 917)
 ; Build Date: Fri, 18 May 2012 14:46:59
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
mappingObjects
 ;;{tagName:"ext4:accordionpanel",className:"Ext.tab.Panel",xtype:"panel",addAttributes:{layout:"accordion"},xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:actioncolumn",className:"Ext.grid.column.Action",xtype:"actioncolumn",xtypeTagName:"ext4:item",containerTag:"ext4:columns"}
 ;;{tagName:"ext4:autoel",parse:{method:"object",optionName:"autoEl"}}
 ;;{tagName:"ext4:axes",parse:{method:"arrayOfOptions",optionName:"axes"}}
 ;;{tagName:"ext4:axis",className:"Ext.chart.axis.Axis",xtype:"dummy",xtypeTagName:"ext4:item",containerTag:"ext4:axes",hasId:false,pass1Method:"fieldsAttr"}
 ;;{tagName:"ext4:axisfield",parse:{method:"arrayItem"},pass1Method:"addAxisFields"}
 ;;{tagName:"ext4:axisfields",parse:{method:"array",optionName:"fields"}}
 ;;{tagName:"ext4:axisgrid",parse:{method:"object",optionName:"grid"},hasId:false}
 ;;{tagName:"ext4:axislabel",parse:{method:"object",optionName:"label"},hasId:false}
 ;;{tagName:"ext4:background",parse:{method:"object",optionName:"background"},hasId:false}
 ;;{tagName:"ext4:bbar",parse:{method:"arrayOfOptions",optionName:"bbar"}}
 ;;{tagName:"ext4:bodystyle",parse:{method:"object",optionName:"bodyStyle"}}
 ;;{tagName:"ext4:booleancolumn",className:"Ext.grid.column.Boolean",xtype:"booleancolumn",xtypeTagName:"ext4:item",containerTag:"ext4:columns",pass1Method:"editableColumn"}
 ;;{tagName:"ext4:button",className:"Ext.button.Button",xtype:"button",xtypeTagName:"ext4:item",containerTag:"ext4:items",allowedContainers:["ext4:buttons","ext4:bbar","ext4:fbar","ext4:rbar","ext4:tbar"],parse:{method:"item"}}
 ;;{tagName:"ext4:buttongroup",className:"Ext.container.ButtonGroup",xtype:"buttongroup",xtypeTagName:"ext4:item",containerTag:"ext4:tbar"}
 ;;{tagName:"ext4:buttonmenu",expandMethod:"expandButtonMenu",parse:{method:"arrayOfOptions",optionName:"menu"}}
 ;;{tagName:"ext4:buttons",parse:{method:"arrayOfOptions",optionName:"buttons"}}
 ;;{tagName:"ext4:cellediting",className:"Ext.grid.plugin.CellEditing",ptype:"cellediting",xtypeTagName:"ext4:item",containerTag:"ext4:plugins"}
 ;;{tagName:"ext4:chart",className:"Ext.chart.Chart",xtype:"chart",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandChart",instanceMethod:"chartInstance",pass1Method:"expandGauge"}
 ;;{tagName:"ext4:charttips",parse:{method:"object",optionName:"tips"}}
 ;;{tagName:"ext4:checkboxfield",className:"Ext.form.Checkbox",ptype:"checkboxfield",fieldType:"checkbox",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:checkboxgroup",className:"Ext.form.CheckboxGroup",xtype:"checkboxgroup",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandGroupField",instanceMethod:"groupFieldInstance"}
 ;;{tagName:"ext4:checkcolumn",className:"Ext.ux.CheckColumn",xtype:"checkcolumn",xtypeTagName:"ext4:item",containerTag:"ext4:columns",pass1Method:"editableColumn"}
 ;;{tagName:"ext4:childel",parse:{method:"item"}}
 ;;{tagName:"ext4:childels",parse:{method:"arrayOfOptions",optionName:"childEls"}}
 ;;{tagName:"ext4:colorpicker",className:"Ext.picker.Color",xtype:"colorpicker",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:column",parse:{method:"item"}}
 ;;{tagName:"ext4:columns",parse:{method:"arrayOfOptions",optionName:"columns"}}
 ;;{tagName:"ext4:combobox",className:"Ext.form.field.ComboBox",expandMethod:"expandComboBox",fieldType:"text",xtype:"combobox",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:configoption",parse:{method:"configOption"}}
 ;;{tagName:"ext4:container",className:"Ext.container.Container",xtype:"container",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:cycle",className:"Ext.button.Cycle"}
 ;;{tagName:"ext4:data",parse:{method:"object",optionName:"data"}}
 ;;{tagName:"ext4:dataarray",parse:{method:"arrayOfOptions",optionName:"data"}}
 ;;{tagName:"ext4:dataitem",parse:{method:"item"},hasId:false}
 ;;{tagName:"ext4:datecolumn",className:"Ext.grid.column.Date",xtype:"datecolumn",xtypeTagName:"ext4:item",containerTag:"ext4:columns",pass1Method:"editableColumn"}
 ;;{tagName:"ext4:datefield",className:"Ext.form.field.Date",xtype:"datefield",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:datepicker",className:"Ext.picker.Date",xtype:"datepicker",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:defaultlistconfig",parse:{method:"object",optionName:"defaultListConfig"}}
 ;;{tagName:"ext4:defaults",parse:{method:"object",optionName:"defaults"}}
 ;;{tagName:"ext4:desktop",pass1Method:"desktop"}
 ;;{tagName:"ext4:displayfield",className:"Ext.form.field.Display",fieldType:"text",xtype:"displayfield",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:dockeditems",parse:{method:"arrayOfOptions",optionName:"dockedItems"}}
 ;;{tagName:"ext4:draggable",parse:{method:"object",optionName:"draggable"}}
 ;;{tagName:"ext4:editor",parse:{method:"object",optionName:"editor"}}
 ;;{tagName:"ext4:fbar",parse:{method:"arrayOfOptions",optionName:"fbar"}}
 ;;{tagName:"ext4:features",parse:{method:"arrayOfOptions",optionName:"features"}}
 ;;{tagName:"ext4:field",parse:{method:"object",optionName:"field"},pass1Method:"swapFormFields"}
 ;;{tagName:"ext4:fieldcontainer",className:"Ext.form.FieldContainer",xtype:"fieldcontainer",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:fielddefaults",parse:{method:"object",optionName:"fieldDefaults"}}
 ;;{tagName:"ext4:fielditem",parse:{method:"item"},hasId:false}
 ;;{tagName:"ext4:fields",parse:{method:"arrayOfOptions",optionName:"fields"},pass1Method:"switchFields"}
 ;;{tagName:"ext4:fieldset",className:"Ext.form.FieldSet",xtype:"fieldset",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:fill",className:"Ext.toolbar.Fill",xtype:"tbfill",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:formpanel",className:"Ext.form.Panel",xtype:"form",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandPanel",instanceMethod:"panelInstance",pass1Method:"addEwdActionField"}
 ;;{tagName:"ext4:gradients",parse:{method:"arrayOfOptions",optionName:"gradients"}}
 ;;{tagName:"ext4:gradient",parse:{method:"object",optionName:"gradient"}}
 ;;{tagName:"ext4:grid",parse:{method:"object",optionName:"grid"},hasId:false}
 ;;{tagName:"ext4:gridcolumn",className:"Ext.grid.column.Column",xtype:"gridcolumn",xtypeTagName:"ext4:column",containerTag:"ext4:columns",pass1Method:"editableColumn"}
 ;;{tagName:"ext4:gridpanel",className:"Ext.grid.Panel",xtype:"gridpanel",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandGridPanel",instanceMethod:"gridPanelInstance"}
 ;;{tagName:"ext4:hiddenfield",className:"Ext.form.field.Hidden",xtype:"hiddenfield",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:highlight",parse:{method:"object",optionName:"highlight"},hasId:false}
 ;;{tagName:"ext4:htmleditorfield",className:"Ext.form.field.HtmlEditor",xtype:"htmleditor",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"addQuickTipManager",pass1Method:"setNameList"}
 ;;{tagName:"ext4:icon",xtype:"dummy",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:image",className:"Ext.Img",xtype:"image",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:item",parse:{method:"item"}}
 ;;{tagName:"ext4:items",parse:{method:"arrayOfOptions",optionName:"items"}}
 ;;{tagName:"ext4:json",parse:{method:"json"}}
 ;;{tagName:"ext4:label",className:"Ext.form.Label",xtype:"label",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"switchLabel"}
 ;;{tagName:"ext4:legend",parse:{method:"object",optionName:"legend"},hasId:"false"}
 ;;{tagName:"ext4:layout",parse:{method:"object",optionName:"layout"}}
 ;;{tagName:"ext4:listeners",parse:{method:"listeners"}}
 ;;{tagName:"ext4:markerconfig",parse:{method:"object",optionName:"markerConfig"},hasId:false}
 ;;{tagName:"ext4:menu",className:"Ext.menu.Menu",xtype:"menu",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"convertMenu",expandMethod:"expandButtonMenu"}
 ;;{tagName:"ext4:menucheckitem",className:"Ext.menu.CheckItem",xtype:"menucheckitem",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:menucolorpicker",className:"Ext.menu.ColorPicker"}
 ;;{tagName:"ext4:menudatepicker",className:"Ext.menu.DatePicker"}
 ;;{tagName:"ext4:menuitem",className:"Ext.menu.Item",xtype:"menuitem",xtypeTagName:"ext4:item",containerTag:"ext4:items",allowedContainers:["ext4:buttonmenu"],pass1Method:"convertMenuItem"}
 ;;{tagName:"ext4:menuseparator",className:"Ext.menu.Separator",xtype:"menuseparator",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:modalwindow",pass1Method:"replaceModalWindow"}
 ;;{tagName:"ext4:multislider",className:"Ext.slider.Multi",xtype:"multislider",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:numbercolumn",className:"Ext.grid.column.Number",xtype:"numbercolumn",xtypeTagName:"ext4:item",containerTag:"ext4:columns",pass1Method:"editableColumn"}
 ;;{tagName:"ext4:numberfield",className:"Ext.form.field.Number",xtype:"numberfield",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:odd",parse:{method:"object",optionName:"odd"},hasId:false,pass1Method:"odd"}
 ;;{tagName:"ext4:pagingtoolbar",className:"Ext.toolbar.Paging",xtype:"pagingtoolbar",addAttributes:{dock:"top"},xtypeTagName:"ext4:item",containerTag:"ext4:dockeditems"}
 ;;{tagName:"ext4:panel",className:"Ext.panel.Panel",xtype:"panel",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandPanel",instanceMethod:"panelInstance"}
 ;;{tagName:"ext4:paneltool",className:"Ext.panel.Tool",xtype:"tool",xtypeTagName:"ext4:tool",containerTag:"ext4:tools"}
 ;;{tagName:"ext4:plugins",parse:{method:"arrayOfOptions",optionName:"plugins"}}
 ;;{tagName:"ext4:progressbar",className:"Ext.ProgressBar",xtype:"progressbar",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:propertygrid",className:"Ext.grid.property.Grid",xtype:"propertygrid",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:proxy",parse:{method:"object",optionName:"proxy"}}
 ;;{tagName:"ext4:radiofield",className:"Ext.form.Radio",xtype:"radiofield",fieldType:"radio",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:radiogroup",className:"Ext.form.RadioGroup",xtype:"radiogroup",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandGroupField",instanceMethod:"groupFieldInstance"}
 ;;{tagName:"ext4:rbar",parse:{method:"arrayOfOptions",optionName:"rbar"}}
 ;;{tagName:"ext4:reader",parse:{method:"object",optionName:"reader"}}
 ;;{tagName:"ext4:renderdata",parse:{method:"object",optionName:"renderData"}}
 ;;{tagName:"ext4:renderselectors",parse:{method:"object",optionName:"renderSelectors"}}
 ;;{tagName:"ext4:rotate",parse:{method:"object",optionName:"rotate"},hasId=false}
 ;;{tagName:"ext4:rownumberer",className:"Ext.grid.RowNumberer",xtype:"rownumberer",xtypeTagName:"ext4:item",containerTag:"ext4:columns"}
 ;;{tagName:"ext4:segment",parse:{method:"object",optionName:"segment"},hasId:false}
 ;;{tagName:"ext4:separator",className:"Ext.toolbar.Separator",xtype:"tbseparator",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:series",className:"Ext.chart.series.Series",xtype:"dummy",xtypeTagName:"ext4:item",containerTag:"ext4:seriesarray",hasId="false",pass1Method:"seriesChildren"}
 ;;{tagName:"ext4:seriesarray",parse:{method:"arrayOfOptions",optionName:"series"}}
 ;;{tagName:"ext4:serieslabel",parse:{method:"object",optionName:"label"},hasId:false}
 ;;{tagName:"ext4:slider",className:"Ext.slider.Single",xtype:"slider",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:sliderfield",className:"Ext.slider.Single",xtype:"sliderfield",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:sorter",parse:{method:"item"}}
 ;;{tagName:"ext4:sorters",parse:{method:"arrayOfOptions",optionName:"sorters"}}
 ;;{tagName:"ext4:spacer",className:"Ext.toolbar.Spacer",xtype:"tbspacer",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:splitbutton",className:"Ext.button.Split"}
 ;;{tagName:"ext4:stop",parse:{method:"object",optionName:"stop"},hasId:false}
 ;;{tagName:"ext4:stops",parse:{method:"object",optionName:"stops"},hasId:false}
 ;;{tagName:"ext4:style",parse:{method:"object",optionName:"style"},hasId:false}
 ;;{tagName:"ext4:submitbutton",pass1Method:"expandSubmitButton",xtype:"button",xtypeTagName:"ext4:button",containerTag:"ext4:buttons"}
 ;;{tagName:"ext4:tabconfig",parse:{method:"object",optionName:"tabConfig"}}
 ;;{tagName:"ext4:tabpanel",className:"Ext.tab.Panel",xtype:"tabpanel",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"tabPanelActiveTab"}
 ;;{tagName:"ext4:tbar",parse:{method:"arrayOfOptions",optionName:"tbar"}}
 ;;{tagName:"ext4:templatecolumn",className:"Ext.grid.column.Template",xtype:"templatecolumn",xtypeTagName:"ext4:item",containerTag:"ext4:columns"}
 ;;{tagName:"ext4:textareafield",className:"Ext.form.field.TextArea",xtype:"textareafield",fieldType:"textarea",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:textfield",className:"Ext.form.field.Text",xtype:"textfield",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:timefield",className:"Ext.form.field.Time",xtype:"timefield",fieldType:"text",xtypeTagName:"ext4:item",containerTag:"ext4:items",pass1Method:"setNameList"}
 ;;{tagName:"ext4:textitem",className:"Ext.toolbar.TextItem",xtype:"tbtext",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:timepicker",className:"Ext.picker.Time",xtype:"timepicker",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:tips",parse:{method:"array",optionName:"tips"}}
 ;;{tagName:"ext4:toolbar",className:"Ext.toolbar.Toolbar",xtype:"toolbar",addAttributes:{dock:"top"},xtypeTagName:"ext4:item",containerTag:"ext4:dockeditems"}
 ;;{tagName:"ext4:tools",parse:{method:"arrayOfOptions",optionName:"tools"}}
 ;;{tagName:"ext4:tool",parse:{method:"item"}}
 ;;{tagName:"ext4:tooltip",className:"Ext.tip.ToolTip",xtype:"tooltip",xtypeTagName:"ext4:item",containerTag:"ext4:items"}
 ;;{tagName:"ext4:treepanel",className:"Ext.tree.Panel",xtype:"treepanel",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandTreePanel",instanceMethod:"treePanelInstance",pass1Method:"treePanelListener"}
 ;;{tagName:"ext4:viewconfig",parse:{method:"object",optionName:"viewConfig"}}
 ;;{tagName:"ext4:viewport",className:"Ext.container.Viewport"}
 ;;{tagName:"ext4:view",className:"Ext.view.View"}
 ;;{tagName:"ext4:window",className:"Ext.window.Window",xtype:"window",xtypeTagName:"ext4:item",containerTag:"ext4:items",expandMethod:"expandPanel",instanceMethod:"panelInstance"}
 ;;{tagName:"ext4:xfield",parse:{method:"arrayItem"},pass1Method:"addXFields"}
 ;;{tagName:"ext4:xfields",parse:{method:"array",optionName:"xField"}}
 ;;{tagName:"ext4:yfield",parse:{method:"arrayItem"},pass1Method:"addYFields"}
 ;;{tagName:"ext4:yfields",parse:{method:"array",optionName:"yField"}}
 ;;***END***
