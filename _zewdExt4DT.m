%zewdExt4DT ; Extjs Desktop processor
 ;
 ; Product: Enterprise Web Developer (Build 931)
 ; Build Date: Fri, 27 Jul 2012 12:05:05
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
 ;
desktop(nodeOID)
 ;
 n attr,cspOID,i,line,logoutFn,parentOID,phpVar,rootPath,sessionName,srcs,stop,text,wallpaper,xOID
 ;
 s sessionName=$$getAttribute^%zewdDOM("sessionname",nodeOID)
 i sessionName'="" d
 . s text=" d writeDesktopConfig^%zewdExt4Code("""_sessionName_""",sessid)"
 e  d
 . n childNo,childOID,comma,OIDArray
 . i technology="node" d
 . . s text=" s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=""EWD.desktop = {windows:["""_$c(13,10)
 . e  d
 . . s text=" w ""EWD.desktop = {windows:["""_$c(13,10)
 . d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 . s childNo="",comma=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . i $$getTagName^%zewdDOM(childOID)="ext4:window" d
 . . . n comma2,mainAttrs,name,value
 . . . s comma2=""
 . . . d getAttributes^%zewdExt4(childOID,.mainAttrs)
 . . . i $g(mainAttrs("title"))="" s mainAttrs("title")="Unnamed Window"
 . . . i $g(mainAttrs("name"))="" s mainAttrs("name")="Unnamed Icon"
 . . . i $g(mainAttrs("iconCls"))="" s mainAttrs("iconCls")="accordion-shortcut"
 . . . i $g(mainAttrs("width"))="" s mainAttrs("width")=300
 . . . i $g(mainAttrs("height"))="" s mainAttrs("height")=400
 . . . i $g(mainAttrs("fragment"))="" s mainAttrs("title")="unspecifiedFragment"
 . . . i $g(mainAttrs("quickStart"))="" s mainAttrs("quickStart")="false"
 . . . i technology="node" d
 . . . . s text=text_" s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))="""_comma_"{"
 . . . e  d
 . . . . s text=text_" w """_comma_"{"
 . . . s name=""
 . . . f  s name=$o(mainAttrs(name)) q:name=""  d
 . . . . s value=mainAttrs(name)
 . . . . d
 . . . . . i value="true"!(value="false") q
 . . . . . i $$numeric^%zewdJSON(value) q
 . . . . . s value="'"_value_"'"
 . . . . s text=text_comma2_name_":"_value
 . . . . s comma2=","
 . . . s text=text_"}"""_$c(13,10)
 . . . s comma=","
 . . i $$removeChild^%zewdDOM(childOID,1)
 . i technology="node" d
 . . s text=text_" s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=""]};"""_$c(13,10)
 . e  d
 . . s text=text_" w ""]};"""_$c(13,10)
 s cspOID=$$addCSPServerScript^%zewdAPI(nodeOID,text)
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 s rootPath=$$getAttribute^%zewdDOM("rootpath",parentOID)
 i $e(rootPath,$l(rootPath))'="/" s rootPath=rootPath_"/"
 s wallpaper=$$getAttribute^%zewdDOM("wallpaper",nodeOID)
 i wallpaper="" s wallpaper=rootPath_"examples/desktop/wallpapers/Blue-Sencha.jpg"
 ;
 s stop=0
 s text="if (typeof EWD.desktop.wallpaper === 'undefined') EWD.desktop.wallpaper = '"_wallpaper_"';"_$c(13,10)
 s phpVar=$$addPhpVar^%zewdCustomTags("#EWD.desktop.username","j")
 s text=text_"EWD.desktop.username = '"_phpVar_"';"_$c(13,10)
 s logoutFn=$$getAttribute^%zewdDOM("logoutfn",nodeOID)
 i logoutFn="" s logoutFn="function() {alert('undefined logout function');}"
 s text=text_"EWD.desktop.logoutFn="_logoutFn_";"
 s xOID=$$addElementToDOM^%zewdDOM("ext4:jsLine",nodeOID,,,text)
 f i=1:1 d  q:stop
 . s line=$t(desktopJS+i)
 . i line["***END***" s stop=1 q
 . s text=$p(line,";;",2,200)_$c(13,10)
 . s xOID=$$addElementToDOM^%zewdDOM("ext4:jsLine",nodeOID,,,text)
 s text="EWD.desktop.app = new EWDDesktop.App();"
 s xOID=$$addElementToDOM^%zewdDOM("ext4:jsLine",nodeOID,,,text)
 s attr("href")=rootPath_"examples/desktop/css/desktop.css"
 s xOID=$$addElementToDOM^%zewdDOM("link",parentOID,,.attr)
 s srcs(1)="Desktop"
 s srcs(2)="Module"
 s srcs(3)="StartMenu"
 s srcs(4)="TaskBar"
 s srcs(5)="Video"
 s srcs(6)="Wallpaper"
 s srcs(7)="App"
 s srcs(8)="FitAllLayout"
 s srcs(9)="ShortcutModel"
 f i=1:1:7 d
 . s attr("src")=rootPath_"examples/desktop/js/"_srcs(i)_".js"
 . s attr("type")="text/javascript"
 . s attr("defer")="defer"
 . s xOID=$$addElementToDOM^%zewdDOM("script",parentOID,,.attr)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
desktopJS ;
 ;;Ext.define('Ext.ux.desktop.ShortcutModel', {
 ;;   extend: 'Ext.data.Model',
 ;;   fields: [
 ;;      { name: 'name' },
 ;;      { name: 'iconCls' },
 ;;      { name: 'module' },
 ;;      { name: 'position' },
 ;;      { name: 'top' },
 ;;      { name: 'left' }
 ;;   ]
 ;;});
 ;;Ext.Loader.setConfig({enabled:true});
 ;;Ext.override(Ext.ux.desktop.Desktop, {
 ;;  shortcutTpl: [
 ;;    '<tpl for=".">',
 ;;      '<div class="ux-desktop-shortcut" id="{name}-shortcut"',
 ;;        '<tpl if="position == \'absolute\'">',
 ;;          ' style="position:absolute;left:{left}px;top:{top}px;"',
 ;;        '</tpl>',
 ;;        '>',
 ;;        '<div class="ux-desktop-shortcut-icon {iconCls}">',
 ;;          '<img src="',Ext.BLANK_IMAGE_URL,'" title="{name}">',
 ;;        '</div>',
 ;;        '<span class="ux-desktop-shortcut-text">{name}{extra}</span>',
 ;;      '</div>',
 ;;    '</tpl>',
 ;;    '<div class="x-clear"></div>'
 ;;  ]
 ;;});
 ;;Ext.define('EWDDesktop.Window', {
 ;;  extend: 'Ext.ux.desktop.Module',
 ;;  init : function(){
 ;;    var window = this;
 ;;    this.launcher = {
 ;;      text: window.name,
 ;;      iconCls:'accordion',
 ;;      handler : this.createWindow,
 ;;      scope: this
 ;;    };
 ;;  },
 ;;  createWindow : function(){
 ;;    var desktop = this.app.getDesktop();
 ;;    var win = desktop.getWindow(this.id);
 ;;    var window = this;
 ;;    EWD.window = this;
 ;;    if (typeof window.windowIconCls === 'undefined') window.windowIconCls = 'accordion';
 ;;    if (typeof window.width === 'undefined') window.width = 300;
 ;;    if (typeof window.height === 'undefined') window.height = 400;
 ;;    if (typeof window.title === 'undefined') window.title = 'Unnamed Window';
 ;;    if (typeof window.fragment === 'undefined') window.fragment = 'undefinedFragment';
 ;;    if (!win) {
 ;;      win = desktop.createWindow({
 ;;        id: window.id,
 ;;        title: window.title,
 ;;        width: window.width,
 ;;        height: window.height,
 ;;        iconCls: window.windowIconCls,
 ;;        animCollapse: false,
 ;;        constrainHeader: true,
 ;;        bodyBorder: true,
 ;;        layout: 'accordion',
 ;;        border: false,
 ;;        listeners: {
 ;;          render: function() {
 ;;            EWD.ajax.getPage({page:window.fragment, nvp:'ext4_addTo=' + window.id});
 ;;          }
 ;;        }
 ;;      });
 ;;    }
 ;;    win.show();
 ;;    return win;
 ;;  }
 ;;});
 ;;Ext.define('EWDDesktop.App', {
 ;;  extend: 'Ext.ux.desktop.App',
 ;;  init: function() {
 ;;    // custom logic before getXYZ methods get called...
 ;;    this.callParent();
 ;;    // now ready...
 ;;  },
 ;;  getModules : function(){
 ;;    var window;
 ;;    var modules = [];
 ;;    for (var no = 0; no < EWD.desktop.windows.length; no++) {
 ;;      window = EWD.desktop.windows[no];
 ;;      modules[no] = new EWDDesktop.Window(window);
 ;;    }
 ;;    return modules;
 ;;  },
 ;;  getDesktopConfig: function () {
 ;;    var me = this, ret = me.callParent();
 ;;    var configData = [];
 ;;    var window;
 ;;    for (var no = 0; no < EWD.desktop.windows.length; no++) {
 ;;      window = EWD.desktop.windows[no];
 ;;      if (typeof window.iconCls === 'undefined') window.iconCls = 'accordion-shortcut';
 ;;      if (typeof window.name === 'undefined') window.name = 'Unnamed icon';
 ;;      configData[no] = {
 ;;        name: window.name,
 ;;        iconCls: window.iconCls,
 ;;        module: window.id,
 ;;      };
 ;;      if (window.position === 'absolute') {
 ;;        configData[no].position = 'absolute';
 ;;        configData[no].left = window.left;
 ;;        configData[no].top = window.top;
 ;;      }
 ;;    } 
 ;;    return Ext.apply(ret, {
 ;;      //cls: 'ux-desktop-black',
 ;;      contextMenuItems: [
 ;;        { text: 'Change Settings', handler: me.onSettings, scope: me }
 ;;      ],
 ;;      shortcuts: Ext.create('Ext.data.Store', {
 ;;        model: 'Ext.ux.desktop.ShortcutModel',
 ;;        data: configData
 ;;      }),
 ;;      wallpaper: EWD.desktop.wallpaper,
 ;;      wallpaperStretch: false
 ;;    });
 ;;  },
 ;;  // config for the start menu
 ;;  getStartConfig : function() {
 ;;    var me = this, ret = me.callParent();
 ;;    var cfg = Ext.apply(ret, {
 ;;      title: EWD.desktop.username,
 ;;      iconCls: 'user',
 ;;      id: 'startMenuPanel',
 ;;      height: 300,
 ;;      toolConfig: {
 ;;        width: 100,
 ;;        items: [
 ;;          /*
 ;;          {
 ;;            text:'Settings',
 ;;            iconCls:'settings',
 ;;            handler: me.onSettings,
 ;;            scope: me
 ;;          },
 ;;          '-',
 ;;          */
 ;;          {
 ;;            text:'Logout',
 ;;            iconCls:'logout',
 ;;            handler: me.onLogout,
 ;;            scope: me
 ;;          }
 ;;        ]
 ;;      }
 ;;    });
 ;;    return cfg;
 ;;  },
 ;;  getTaskbarConfig: function () {
 ;;    var ret = this.callParent();
 ;;    var quickStartArr = [];
 ;;    var window;
 ;;    var index = 0;
 ;;    for (var no = 0; no < EWD.desktop.windows.length; no++) {
 ;;      window = EWD.desktop.windows[no];
 ;;      if (typeof window.windowIconCls === 'undefined') window.windowIconCls = 'accordion';
 ;;      if (window.quickStart) {
 ;;        quickStartArr[index] = {
 ;;          name: window.name,
 ;;          iconCls: window.windowIconCls,
 ;;          module: window.id
 ;;        };
 ;;        index++;
 ;;      }
 ;;    }
 ;;    return Ext.apply(ret, {
 ;;      quickStart: quickStartArr,
 ;;      trayItems: [
 ;;        { xtype: 'trayclock', flex: 1 }
 ;;      ]
 ;;    });
 ;;  },
 ;;  onLogout: function () {
 ;;    if (typeof EWD.desktop.logoutFn !== 'undefined') EWD.desktop.logoutFn();
 ;;  },
 ;;  onSettings: function () {
 ;;    return;
 ;;    // optional stuff!
 ;;    var dlg = new MyDesktop.Settings({
 ;;      desktop: this.desktop
 ;;    });
 ;;    dlg.show();
 ;;  }
 ;;});
 ;;***END***
 ;
