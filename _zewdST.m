%zewdST ; Sencha Touch Tag Processors and runtime logic
 ;
 ; Product: Enterprise Web Developer (Build 896)
 ; Build Date: Mon, 06 Feb 2012 14:48:18
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
createJSFile(label,jsFileName) ;
 ;
 n delim,filePath,io,line,lineNo,outputPath,x
 ;
 s outputPath=$g(^zewd("config","jsScriptPath",technology,"outputPath"))
 s delim=$$getDelim^%zewdAPI()
 i $e(outputPath,$l(outputPath))'=delim s outputPath=outputPath_delim
 s filePath=outputPath_jsFileName
 s io=$io
 i '$$openNewFile^%zewdCompiler(filePath) q
 u filePath
 s x="f lineNo=1:1 s line=$t("_label_"+lineNo^%zewdSTJS) q:line[""***END***""  w $p(line,"";;"",2,200)_$c(10)"
 x x
 c filePath u io
 ;
 QUIT
 ;
card(nodeOID,attrValue,docOID,technology)
 ;
 ;<st:card animation="fade" displayBackButton="false" displayDetailButton="false">
 ;
 n animation,attr,jsOID,jsText,mainAttrs,postSTOID,preSTOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s jsOID=$$createJS()
 s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 ;
 s animation=$g(mainAttrs("animation")) i animation="" s animation="slide"
 ;
 ;s jsText="EWD.sencha.loadCard({animation:'"_animation_"'"
 s jsText="EWD.sencha.displayCard({animation:'"_animation_"'"
 i $g(mainAttrs("displaybackbutton"))'="" s jsText=jsText_",displayBackButton:"_mainAttrs("displaybackbutton")
 i $g(mainAttrs("displaydetailbutton"))'="" s jsText=jsText_",displayDetailButton:"_mainAttrs("displaydetailbutton")
 s jsText=jsText_"});"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s jsText="if (EWD.sencha.nestedList) EWD.sencha.nestedList.height = EWD.sencha.nestedList.maxHeight;"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT  
 ;
js(nodeOID,attrValue,docOID,technology)
 ;
 ; <st:js block="ewdPreST" position="end">...javascript code </st:js>
 ;
 n at,attr,block,jsOID,mainAttrs,no,position,stOID,text,textarr,textOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s block=$g(mainAttrs("block")) i block="" s block="ewdST"
 s at=$g(mainAttrs("at"))
 i at="before"!(at="top")!(at="start") s block="ewdPreSTJS"
 i at="after"!(at="bottom")!(at="end") s block="ewdPostSTJS"
 i ((block="top")!(block="bottom")!(block="ewdPreSTJS")!(block="ewdPostSTJS")) i $$createJS("standard")
 i block="top" s block="ewdPreSTJS"
 i block="bottom" s block="ewdPostSTJS"
 s position=$g(mainAttrs("position")) i position="" s position="end"
 ;
 s stOID=$$getElementById^%zewdDOM(block,docOID)
 i stOID="" QUIT
 ;
 s jsOID=""
 i position="start"!(position="before") d
 . s jsOID=$$createElement^%zewdDOM("ewd:jssection",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,stOID)
 i position="end"!(position="after") d
 . s jsOID=$$insertNewNextSibling^%zewdST2("ewd:jssection",stOID)
 i jsOID="" QUIT
 ;
 s text=$$getElementText^%zewdDOM(nodeOID,.textarr)
 s no=""
 f  s no=$o(textarr(no)) q:no=""  d
 . s text=textarr(no)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text) 
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 QUIT
 ; 
form(nodeOID,attrValue,docOID,technology)
 ;
 ; <st:form id="contentDiv">
 ;   <st:fieldset title="Welcome to the Minimal Hold Order System">
 ;      <st:field type="text" id="username" label="Username" />
 ;      <st:field type="password" id="password" label="Password" />
 ;      <st:field type="submit" text="Login" style="drastic_round" nextpage="loggedIn" />
 ;   </st:fieldset>
 ; </st:form>
 ;
 n attr,attrName,autoRender,childNo,childOID,fcOID,formOID,fsOID,itemOID,itemsOID,jsOID
 n mainAttrs,OIDArray,parentOID,postSTOID,stop,tagName
 ;
 ; check if form is inside a panel - if so, ignore for now
 ;
 s stop=0
 s parentOID=nodeOID
 f  q:stop  d  q:parentOID=""
 . s parentOID=$$getParentNode^%zewdDOM(parentOID)
 . i $$getTagName^%zewdDOM(parentOID)="st:panel" s stop=1
 i stop QUIT
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s jsOID=$$createJS("standard")
 s postSTOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 ;
 s autoRender=$g(mainAttrs("autorender")) k mainAttrs("autorender")
 s formOID=$$insertNewNextSibling^%zewdST2("st:class",nodeOID)
 d setAttribute^%zewdDOM("name","Ext.form.FormPanel",formOID)
 i $g(mainAttrs("return"))="" d
 . i autoRender="" d
 . . s mainAttrs("return")="EWD.sencha.card"
 . e  d
 . . s mainAttrs("return")="var ewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 i autoRender'="" d
 . n id,xOID
 . s id="zewdSTFormDiv"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . s xOID=$$insertNewNextSibling^%zewdST2("div",nodeOID)
 . d setAttribute^%zewdDOM("id",id,xOID)
 . d setAttribute^%zewdDOM("renderto",id,formOID)
 ;
 s attrName=""
 f  s attrName=$o(mainAttrs(attrName)) q:attrName=""  d
 . d setAttribute^%zewdDOM(attrName,mainAttrs(attrName),formOID)
 s itemsOID=$$addElementToDOM^%zewdDOM("st:items",formOID)
 ;
 ; If form has a fieldset it will be the first child
 ;
 ;s parentOID=nodeOID
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:fieldset" d fieldSets(childOID,itemsOID)
 . ; move any listeners to form st:class tag
 . i tagName="st:listeners" d
 . . n lsOID
 . . s lsOID=$$removeChild^%zewdDOM(childOID)
 . . s lsOID=$$appendChild^%zewdDOM(lsOID,formOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
fieldSets(nodeOID,itemsOID)
 ;
 n attr,childNo,childOID,eOID,fsItemsOID,fsOID,hasChildren,itemsAttr,nameList,OIDArray
 ;
 s fsOID=$$fieldset(nodeOID,itemsOID)
 s itemsAttr=$$getAttribute^%zewdDOM("items",nodeOID)
 s hasChildren=$$hasChildNodes^%zewdDOM(nodeOID)
 ;i itemsAttr="",hasChildren="true" s fsItemsOID=$$addElementToDOM^%zewdDOM("st:items",fsOID)
 i itemsAttr="" s fsItemsOID=$$addElementToDOM^%zewdDOM("st:items",fsOID)
 ; add special ewd_action hidden field to automate transfer of values to session
 s attr("type")="hidden"
 s attr("id")="ewd_action"
 s attr("value")="zewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s eOID=$$addElementToDOM^%zewdDOM("st:field",nodeOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:defaults" d  q
 . . s childOID=$$removeChild^%zewdDOM(childOID)
 . . s childOID=$$appendChild^%zewdDOM(childOID,fsOID)
 . i tagName="st:field" d field(childOID,fsItemsOID,mainAttrs("return"),.nameList) q
 . i tagName="st:checkboxes" d  q
 . . n parentOID
 . . s parentOID=formOID
 . . i $$getTagName^%zewdDOM(fcOID)="st:fieldset" s parentOID=fsOID
 . . d checkboxes(childOID,parentOID)
 d processNameList^%zewdST2(.nameList,.formDeclarations)
 i $$removeChild^%zewdDOM(nodeOID)
 QUIT  
 ;
checkboxes(nodeOID,parentOID)
 ;
 n attr,checkIf,fcOID,idRoot,itemsOID,jsOID,jsText,jsVar,labelAlign,mainAttrs
 n nameRoot,preSTOID,sessionName,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s sessionName=$g(mainAttrs("sessionname")) i sessionName="" s sessionName="missingSessionValue" 
 s idRoot=$g(mainAttrs("idroot"))
 i idRoot="" s idRoot="ewdSTCheckbox"
 s checkIf=$g(mainAttrs("checkif"))
 i checkIf["&php;" d
 . n no
 . s no=$p(checkIf,"&php;",2)
 . s checkIf=$g(phpVars(no))
 . s checkIf=$$stripSpaces^%zewdAPI(checkIf)
 . s checkIf=$e(checkIf,3,$l(checkIf))
 ;
 s jsVar="zewdSTCheckboxes"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s nameRoot=$g(mainAttrs("nameroot"))
 i nameRoot="" s nameRoot=jsVar
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s jsText="EWD.sencha.checkBox={idRoot:'"_idRoot_"',nameRoot:'"_nameRoot_"'};"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 ;
 s labelAlign=$g(mainAttrs("labelalign"))
 i labelAlign="" s labelAlign="left"
 ;
 ;
 s attr("method")="writeCheckboxes^%zewdST2"
 s attr("param1")=sessionName
 s attr("param2")=jsVar
 s attr("param3")=idRoot
 s attr("param4")=nameRoot
 s attr("param5")=checkIf
 s attr("param6")=labelAlign
 s attr("param7")="#ewd_sessid"
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",preSTOID,,.attr)
 ;
 d setAttribute^%zewdDOM("items","."_jsVar,parentOID)
 s itemsOID=$$getFirstChild^%zewdDOM(parentOID)
 i $$getTagName^%zewdDOM(itemsOID)="st:items" s itemsOID=$$removeChild^%zewdDOM(itemsOID)
 ;
 s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
 i $$getTagName^%zewdDOM(fcOID)="st:onchecked" d
 . n attr,funcOID,jsOID,no,preSTOID,text,textarr,textOID
 . s text=$$getElementText^%zewdDOM(fcOID,.textarr)
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . s attr("return")="EWD.sencha.onCheckboxChecked"
 . s attr("addVar")="false"
 . s attr("parameters")="value,id,checked"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",postSTOID,,.attr)
 . s no=""
 . f  s no=$o(textarr(no)) q:no=""  d
 . . s text=textarr(no)
 . . s textOID=$$createTextNode^%zewdDOM(text,docOID)
 . . s textOID=$$appendChild^%zewdDOM(textOID,funcOID) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
fieldset(nodeOID,parentOID)
 ;
 ;   <st:fieldset title="Welcome to the Minimal Hold Order System">
 ;
 n fsOID,mainAttrs
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s mainAttrs("xtype")="fieldset"
 s fsOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.mainAttrs)
 ;
 QUIT fsOID
 ;
field(nodeOID,parentOID,return,nameList)
 ;
 ;      <st:field type="text" id="username" label="Username" />
 ;      <st:field type="password" id="password" label="Password" />
 ;      <st:field type="submit" text="Login" style="drastic_round" targetId="contentDiv" nextpage="loggedIn" />
 ;
 n attr,childNo,childOID,fieldOID,id,mainAttrs,name,OIDArray,type,value,xtype
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type")) i type="" s type="text"
 s xtype="textfield"
 i type="password" s xtype="passwordfield"
 i type="radio" s xtype="radiofield"
 i type="checkbox" s xtype="checkboxfield"
 i type="email" s xtype="emailfield"
 i type="url" s xtype="urlfield"
 i type="number" s xtype="numberfield"
 i type="hidden" s xtype="hiddenfield"
 i type="spinner" s xtype="spinnerfield"
 i type="select" s xtype="selectfield"
 i type="textarea" s xtype="textareafield"
 i type="slider" s xtype="sliderfield"
 i type="toggle" s xtype="togglefield"
 i type="combo" s xtype="textfield" d combo^%zewdST2(nodeOID,.mainAttrs,formOID)
 ;
 i type="date" d
 . s xtype="datepickerfield"
 . n attr,addPicker,i,pOID
 . i $g(mainAttrs("yearvalue"))'="" d
 . . s mainAttrs("value")=".{year:"_mainAttrs("yearvalue")_",day:15,month:6}"
 . . k mainAttrs("yearvalue")
 . s addPicker=0
 . f i="yearfrom","yearto","slotorder" d
 . . i $g(mainAttrs(i))'="" d
 . . . s addPicker=1
 . . . s attr(i)=mainAttrs(i)
 . . . k mainAttrs(i)
 . i addPicker d
 . . s pOID=$$addElementToDOM^%zewdDOM("st:picker",nodeOID,,.attr)
 i type="submit" s xtype="button"
 s attr("xtype")=xtype
 s id=$g(mainAttrs("id"))
 i id="",type'="radio" s id=$g(mainAttrs("name"))
 i id="" s id="zewdSTField"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 i type="radio" d
 . s nameList($g(mainAttrs("name")))=type
 e  d
 . s nameList(id)=type
 i id="ewd_action" s nameList(id)=type_"|"_$g(mainAttrs("value"))
 ;
 s attr("id")=id
 s attr("name")=$g(mainAttrs("name"))
 i type'="radio" s attr("name")=id
 i $g(mainAttrs("label"))'="" s attr("label")=mainAttrs("label")
 i xtype="button" d
 . i $g(mainAttrs("style"))'="" s attr("ui")=mainAttrs("style")
 . s attr("text")=$g(mainAttrs("text"))
 i $g(mainAttrs("value"))'="" s attr("value")=mainAttrs("value")
 ;
 i type="text"!(type="number")!(type="combo")!(type="hidden")!(type="email")!(type="toggle")!(type="url")!(type="spinner")!(type="select")!(type="textarea")!(type="slider") d
 . n id,phpVar
 . s id=$g(mainAttrs("id")) i id="" s id="missingTextId"
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_id,"j")
 . i $g(mainAttrs("value"))="" s mainAttrs("value")=phpVar
 ;
 i type="date" d
 . n id,phpVarDay,phpVarMonth,phpVarYear,value
 . s id=$g(mainAttrs("id")) i id="" s id="missingDateId"
 . s phpVarDay=$$addPhpVar^%zewdCustomTags("#"_id_".day","j")
 . s phpVarMonth=$$addPhpVar^%zewdCustomTags("#"_id_".month","j")
 . s phpVarYear=$$addPhpVar^%zewdCustomTags("#"_id_".year","j")
 . i $g(mainAttrs("value"))="" s mainAttrs("value")=".{day:'"_phpVarDay_"',month:'"_phpVarMonth_"',year:'"_phpVarYear_"'}"
 ;
 i type="radio" d
 . n name,phpVar,value
 . s name=$g(mainAttrs("name")) i name="" s name="missingRadioName"
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_name,"j")
 . s value=$g(mainAttrs("value"))
 . s mainAttrs("checked")=".'"_phpVar_"' === '"_value_"'"
 ;
 i type="checkbox" d
 . n id,phpVar,value
 . s id=$g(mainAttrs("id")) i id="" s id="missingRadioId"
 . s phpVar=$$addPhpVar^%zewdCustomTags("#"_id,"j")
 . s value=$g(mainAttrs("value"))
 . s mainAttrs("checked")=".'"_phpVar_"' === '"_value_"'"
 ;
 i type="select" d
 . n id,stOID,text
 . s id=$g(mainAttrs("id")) i id="" s id="missingSelectId"
 . s stOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 . s text=" d writeSelectOptions^%zewdST2("""_id_""",sessid)"
 . i $$addCSPServerScript^%zewdAPI(stOID,text)
 . s mainAttrs("valueField")="optionValue"
 . s mainAttrs("displayField")="displayText"
 . s mainAttrs("store")="."_id_"Store"
 ;
 i type="slider" d
 . i $g(mainAttrs("ondrag"))'="" d
 . . n attr,lOID,lsOID
 . . s lsOID=$$getFirstChild^%zewdDOM(nodeOID)
 . . i lsOID'="",$$getTagName^%zewdDOM(lsOID)="st:listeners" d
 . . . ;
 . . e  d
 . . . s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",nodeOID)
 . . s attr("drag")="."_mainAttrs("ondrag")
 . . s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 . . k mainAttrs("ondrag") 
 ;
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i name="type"!(name="label")!(name="style")!(name="nextpage") q
 . q:name="cardpanel"
 . s attr(name)=mainAttrs(name)
 s fieldOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.attr)
 ;
 i type="date" d
 . n attr,fcOID,iOID,pOID
 . s pOID=$$addElementToDOM^%zewdDOM("st:picker",fieldOID)
 . s fcOID=$$getFirstChild^%zewdDOM(nodeOID)
 . do getAttributeValues^%zewdCustomTags(fcOID,.attr)
 . i $g(attr("slotorder"))'="" d
 . . i attr("slotorder")="dmy" s attr("slotorder")=".['day','month','year']"
 . i $g(attr("yearvalue"))'="" d
 . . s attr("value")=".{year:"_attr("yearvalue")_"}"
 . . k attr("yearvalue")
 . s iOID=$$addElementToDOM^%zewdDOM("st:item",pOID,,.attr)
 . i $$removeChild^%zewdDOM(fcOID)
 ;
 ; any listeners etc?
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s childOID=$$removeChild^%zewdDOM(childOID)
 . s childOID=$$appendChild^%zewdDOM(childOID,fieldOID)
 ;
 i xtype="button" d
 . n attr,childNo,childOID,esc,fieldNames,formOID,funcOID,handler,jsText
 . n name,nextPage,OIDArray,plus,postSTOID,preSTOID,tagName,targetId
 . s esc=$g(mainAttrs("escapemethod"))
 . s formOID=$$getParentNode^%zewdDOM(nodeOID)
 . d getChildrenInOrder^%zewdDOM(formOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName="st:field" d
 . . . s name=$$getAttribute^%zewdDOM("id",childOID)
 . . . i name="" s name=$$getAttribute^%zewdDOM("name",childOID)
 . . . i name'="" s fieldNames(name)=""
 . ; <ewd:jsFunction return="xxx" addVar="true">...</ewd:jsFunction>
 . i $g(mainAttrs("handler"))'="" d  q
 . . d setAttribute^%zewdDOM("handler",mainAttrs("handler"),fieldOID)
 . ;
 . s handler="zewdSTHandler"_$$uniqueId^%zewdAPI(fieldOID,filename)
 . s attr("return")=handler
 . s attr("addVar")="false"
 . s jsText="EWD.sencha.blurFields(document);"_$c(13,10)
 . s jsText=jsText_"var nvp="
 . s name="",plus="'"
 . f  s name=$o(fieldNames(name)) q:name=""  d
 . . i esc="" s jsText=jsText_plus_name_"=' + "_return_".getValues()."_name
 . . i esc="escape" s jsText=jsText_plus_name_"=' + escape("_return_".getValues()."_name_")"
 . . i esc="encodeURI" s jsText=jsText_plus_name_"=' + encodeURI("_return_".getValues()."_name_")"
 . . i esc="encodeURIComponent" s jsText=jsText_plus_name_"=' + encodeURIComponent("_return_".getValues()."_name_")"
 . . s plus=" + '&"
 . s jsText=jsText_";"_$c(13,10)
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . s nextPage=$g(mainAttrs("nextpage")) ;i nextPage="" s nextPage="missingNextPage"
 . ;s targetId=$g(mainAttrs("targetid")) i targetId="" s targetId="ewdNullId"
 . i preSTOID="" d
 . . s preSTOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 . . ;
 . . ;i targetId="st-uui-nullId" s targetId="ewdNullId"
 . ;s jsText=jsText_"ewd.ajaxRequest("""_nextPage_""","""_targetId_""",nvp);"
 . i $g(mainAttrs("cardpanel"))'="" d
 . . i $g(mainAttrs("transition"))="" s mainAttrs("transition")="slide"
 . . s jsText=jsText_"EWD.sencha.cardPanelAction['"_nextPage_"']={transition:'"_mainAttrs("transition")_"',id:'"_mainAttrs("cardpanel")_"'};"
 . i nextPage'="" s jsText=jsText_"EWD.ajax.getPage({page:'"_nextPage_"',nvp:nvp});"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 . d setAttribute^%zewdDOM("handler",handler,fieldOID)
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 . s jsText="document.getElementById("_return_".body.id).parentNode.onsubmit = function() {"_handler_"();};"
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 ;
 QUIT
 ;
navigationMenu(nodeOID,attrValue,docOID,technology)
 ;
 n attr,comma,funcOID,jsText,jsOID,mainAttrs,nextPage,no,postSTOID,preSTOID,sessionName,xOID
 ;
 s jsOID=$$createJS()
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s sessionName=$g(mainAttrs("sessionname"))
 s nextPage=$g(mainAttrs("nextpage"))
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 i sessionName="" d
 . n childNo,childOID,objects,tagName
 . ;d getChildrenInOrder^%zewdDOM(panelOID,.OIDArray)
 . d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 . s childNo=""
 . f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . . s childOID=OIDArray(childNo)
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . i tagName="st:menuoption" d menuOption(childOID,.objects)
 . i $d(objects) d
 . . s no="",jsText="EWD.sencha.mainMenu=[",comma=""
 . . f  s no=$o(objects("json",no)) q:no=""  d
 . . . s jsText=jsText_comma_objects("json",no)
 . . . s comma=","
 . . s jsText=jsText_"];"_$c(13,10)
 . . s jsText=jsText_"EWD.sencha.replaceNavigationMenu();"_$c(13,10)
 . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 . . s attr("return")="EWD.sencha.menuPage"
 . . s attr("addVar")="false"
 . . s attr("parameters")="key"
 . . s jsText=""
 . . s no=""
 . . f  s no=$o(objects("xref",no)) q:no=""  d
 . . . s jsText=jsText_"if (key=="_no_") "_objects("xref",no)_"(key);"_$c(13,10)
 . . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 e  d
 . s attr("method")="replaceMenuOptions^%zewdST2"
 . s attr("param1")=sessionName
 . s attr("param2")="#ewd_sessid"
 . s attr("type")="procedure"
 . s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",preSTOID,,.attr)
 . ;
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 . s attr("return")="EWD.sencha.menuPage"
 . s attr("addVar")="false"
 . s attr("parameters")="key"
 . s jsText="var nvp='key='+key;"_$c(13,10)
 . s jsText=jsText_"ewd.ajaxRequest("""_nextPage_""",EWD.sencha.div.nullId,nvp);"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",postSTOID,,.attr,jsText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
menuOption(nodeOID,objects)
 ;
 n attr,card,funcOID,jsText,mainAttrs,optionNo,preSTOID,return,text
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s text=$g(mainAttrs("text")) i text="" s text="Undefined Option"
 s card=$g(mainAttrs("card")) 
 i card="" s card=$g(mainAttrs("nextpage")) 
 i card="" s card="UndefinedFragment"
 s optionNo=$o(objects("json",""),-1)+1
 s text="{text:'"_text_"',key:"_optionNo_"}"
 s objects("json",optionNo)=text
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s return="zewdSTFunc"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s attr("return")=return
 s attr("addVar")="false"
 s attr("parameters")="key"
 s jsText="var nvp='key='+key;"_$c(13,10)
 s jsText=jsText_"ewd.ajaxRequest("""_card_""",EWD.sencha.div.nullId,nvp);"
 s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 s objects("xref",optionNo)=return
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
loggedInView(nodeOID,attrValue,docOID,technology)
 ;
 n jsOID,jsText,mainAttrs,postSTOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s jsOID=$$createJS()
 s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 s jsText="EWD.sencha.navigationOn({displayBackButton:false,displayDetailButton:false});"_$c(13,10)
 s jsText=jsText_"EWD.sencha.replaceNavigationMenu();"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
stclass(nodeOID,attrValue,docOID,technology)
 ;
 n childNo,childOID,mainAttrs,name,OIDArray,parentOID,stop,tagName
 ;
 ;
 ; If another class tag exists as a previous sibling, process it instead
 ;
 s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 d getChildrenInOrder^%zewdDOM(parentOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  q:stop
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'="st:class" q
 . s stop=1
 i stop s nodeOID=childOID
 ;
 ; Now process this first st:class tag
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s name=$g(mainAttrs("name"))
 d removeAttribute^%zewdDOM("name",nodeOID)
 d class(name,nodeOID)
 QUIT
 ;
panel(nodeOID,attrValue,docOID,technology)
 ;
 n bodyxOID,bodyOID,childNo,childOID,extName,i,itemsAdded,itemsOID,mainAttrs,OIDArray,ok
 n panelOID,parentOID,parentTagName,postSTOID,return,stop,tagName,text,thisOID
 n widgetId,widgetObj,widgetObjName
 ;
 ; move up parents until no more panels found
 ;
 s stop=0
 s thisOID=nodeOID
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 f  d  q:stop
 . s parentOID=$$getParentNode^%zewdDOM(thisOID)
 . s parentTagName=$$getTagName^%zewdDOM(parentOID)
 . ;i tagName="st:panel",parentTagName="st:tabpanel" s thisOID=parentOID,stop=1 q
 . ;i tagName="st:panel",parentTagName="st:carousel" s thisOID=parentOID,stop=1 q
 . i parentTagName'="st:panel",parentTagName'="st:cardpanel",parentTagName'="st:tabpanel",parentTagName'="st:carousel",parentTagName'="st:dockeditems" s stop=1 q
 . s thisOID=parentOID
 s nodeOID=thisOID
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s panelOID=$$renameTag^%zewdDOM("st:class",nodeOID)
 s bodyxOID=$$getParentNode^%zewdDOM(panelOID)
 s bodyOID=$$getTagOID^%zewdDOM("body",docName) i bodyOID'="" s bodyxOID=bodyOID 
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s extName="Ext.Panel"
 i $g(mainAttrs("layout"))="" d setAttribute^%zewdDOM("layout","fit",panelOID)
 i tagName="st:tabpanel" d
 . s extName="Ext.TabPanel"
 . d setAttribute^%zewdDOM("layout","card",panelOID)
 i tagName="st:carousel" d
 . s extName="Ext.Carousel"
 . d setAttribute^%zewdDOM("layout","card",panelOID)
 d setAttribute^%zewdDOM("name",extName,panelOID)
 s widgetObjName="zewdST"_$$uniqueId^%zewdAPI(nodeOID,filename)	
 i $g(mainAttrs("object"))'="" d
 . s widgetObjName=mainAttrs("object")
 . k mainAttrs("object")
 s widgetObj="EWD.sencha.widget."_widgetObjName
 s widgetId=$g(mainAttrs("id"))
 i widgetId="" d
 . s widgetId=widgetObjName
 . d setAttribute^%zewdDOM("id",widgetId,panelOID)
 ;
 ;s return=$g(mainAttrs("return")) i return="" s return="EWD.sencha.card"
 d setAttribute^%zewdDOM("return",widgetObj,panelOID)
 ;
 d getChildrenInOrder^%zewdDOM(panelOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:pageitem" d pageItem^%zewdST2(childOID,,docOID,technology)
 . i tagName="ewd:comment" s ok=$$removeChild^%zewdAPI(childOID)
 ;
 d getChildrenInOrder^%zewdDOM(panelOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d  ;q:stop
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:animation" d animation(childOID) q
 . i tagName="st:carousel" s stop=1 q
 . i tagName="st:panel" s stop=1 q
 . i tagName="st:cardpanel" s stop=1 q
 . i tagName="st:tabpanel" s stop=1 q
 . i tagName="st:tabbar" s stop=1 q
 . i tagName="st:menu" s stop=1 q
 . i tagName="st:button" s stop=1 q
 . i tagName="st:form" s stop=1 q
 . i tagName="st:list" s stop=1 q
 . i tagName="st:touchgrid" s stop=1 q
 s itemsOID=""
 i stop s itemsOID=$$addElementToDOM^%zewdDOM("st:items",panelOID)
 s childNo="",itemsAdded=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:pageitem" s tagName=$$pageItemSub^%zewdST2(childOID)
 . i tagName="st:toolbar" d toolbar(childOID,panelOID) q
 . i tagName="st:tabbar" d toolbar(childOID,panelOID) q
 . i tagName="st:carousel" d subPanel(childOID,parentOID,itemsOID)  q
 . i tagName="st:panel" d subPanel(childOID,parentOID,itemsOID)  q
 . i tagName="st:cardpanel" d cardPanel(childOID,parentOID,itemsOID)  q
 . i tagName="st:tabpanel" d subPanel(childOID,parentOID,itemsOID)  q
 . i tagName="st:menu" d menu(childOID,itemsOID)  q
 . i tagName="st:button" d button(childOID,itemsOID) q
 . i tagName="st:form" d formPanel(childOID,parentOID,itemsOID) q
 . i tagName="st:dockeditems" d dockedItems(childOID) q
 . i tagName="st:list" d list(childOID,itemsOID)  q
 . i tagName="st:touchgrid" d touchGridSub^%zewdST2(childOID,itemsOID)  q
 . i tagName'["st:" d contentEl(childOID,panelOID)
 ;
 i $g(mainAttrs("parentpanel"))'=""!($g(mainAttrs("parentwidget"))'="") d
 . n jsOID,parent,postSTOID,text
 . d removeAttribute^%zewdDOM("parentpanel",nodeOID)
 . d removeAttribute^%zewdDOM("parentwidget",nodeOID)
 . s parent=$g(mainAttrs("parentpanel"))
 . i parent="" s parent=$g(mainAttrs("parentwidget"))
 . s text="EWD.sencha.widget."_parent_".add("_widgetObj_");EWD.sencha.widget."_parent_".doLayout();"
 . i $$createJS("standard")
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,text)
 ;
 i $g(mainAttrs("addto"))'="" d
 . n jsOID,parent,postSTOID,text
 . s parent=$g(mainAttrs("addto"))
 . s text="Ext.getCmp('"_parent_"').add(Ext.getCmp('"_widgetId_"'));Ext.getCmp('"_parent_"').doLayout();"
 . i $g(mainAttrs("setactive"))="true" d
 . . n transition
 . . s transition=$g(mainAttrs("transition"))
 . . i transition="" s transition="slide"
 . . s text=text_"Ext.getCmp('"_parent_"').setActiveItem(Ext.getCmp('"_widgetId_"'),'"_transition_"');"
 . i $$createJS("standard")
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,text)
 ;
 ;s text="EWD.sencha.addWidget('"_$p(filename,".ewd",1)_"','"_widgetId_"');"
 i $$createJS("standard")
 ;s postSTOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 s postSTOID=$$getElementById^%zewdDOM("ewdSTJS",docOID)
 ;s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,text)
 s text="EWD.sencha.loadCardPanel('"_$p(filename,".ewd",1)_"','"_widgetId_"');"
 s postSTOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,text)
 ;
 ; node - remove extra attributes here before they get into st:class
 f i="parentpanel","addto","field","setactive" d removeAttribute^%zewdDOM(i,panelOID)
 ;
 QUIT
 ;
dockedItems(nodeOID)
 ;
 n childNo,childOID,OIDArray,tagName
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo="",stop=0
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:panel" d subPanel(childOID,nodeOID,nodeOID)
 QUIT
 ;
animation(nodeOID)
 i $$renameTag^%zewdDOM("st:cardswitchanimation",nodeOID)
 QUIT
 ;
formPanel(nodeOID,bodyOID,itemsOID)
 ;
 n itemOID,return,xOID
 ;
 s xOID=$$removeChild^%zewdDOM(nodeOID)
 s xOID=$$appendChild^%zewdDOM(nodeOID,bodyOID)
 s return="zewdSTForm"_$$uniqueId^%zewdAPI(nodeOID,filename)
 d setAttribute^%zewdDOM("return",return,nodeOID)
 d setAttribute^%zewdDOM("placeattop","true",nodeOID)
 s itemOID=$$addElementToDOM^%zewdDOM("st:object",itemsOID)
 d setAttribute^%zewdDOM("name",return,itemOID)
 QUIT
 ;
contentEl(nodeOID,parentOID)
 ;
 n class,gpOID,htmlOID,id,sOID
 ;
 s id=$$getAttribute^%zewdDOM("id",nodeOID)
 i id="" d
 . s id="zewdSTTag"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . d setAttribute^%zewdDOM("id",id,nodeOID)
 d setAttribute^%zewdDOM("contentEl",id,parentOID)
 s class=$$getAttribute^%zewdDOM("class",nodeOID)
 s nodeOID=$$removeChild^%zewdDOM(nodeOID)
 s htmlOID=$$getTagOID^%zewdDOM("ewd:xhtml",docName)
 s gpOID=$$getParentNode^%zewdDOM(parentOID)
 i htmlOID'="" s gpOID=$$getTagOID^%zewdDOM("body",docName)
 s nodeOID=$$appendChild^%zewdDOM(nodeOID,gpOID)
 s sOID=$$insertNewParentElement^%zewdDOM(nodeOID,"span",docOID)
 d setAttribute^%zewdDOM("style","display:none",sOID)
 ;
 i class="stBlueHighlight" d
 . n jsOID,text,preSTOID
 . s text="EWD.sencha.resetMenuHeight('stBlueHighlight');"
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,text)
 ;
 QUIT
 ;
button(nodeOID,parentOID)
 ;
 n attr,mainAttrs,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s mainAttrs("xtype")="button"
 i $g(mainAttrs("style"))'="" d
 . s mainAttrs("ui")=mainAttrs("style")
 . k mainAttrs("style")
 ;i $g(mainAttrs("handler"))'="" s mainAttrs("handler")="EWD.sencha.restartSessionTimer=true;"_mainAttrs("handler")
 s xOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.mainAttrs)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
list(nodeOID,itemsOID)
 ;
 n attr,childNo,childOID,comma,cspOID,fcOID,field,imgHandler,itemOID,jsOID,listOID,lsOID
 n mainAttrs,name,OIDArray,onTap,phpVar,sessionName,stOID,store,tagName,template
 n text,value,widgetObj,widgetObjName,widgetId
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s listOID=$$createElement^%zewdDOM("st:class",docOID)
 s listOID=$$insertBefore^%zewdDOM(listOID,panelOID)
 d setAttribute^%zewdDOM("name","Ext.List",listOID)
 d setAttribute^%zewdDOM("placeattop","true",listOID)
 ;
 s store=$g(mainAttrs("store"))
 i store="" d
 . s store="zewdSTStore"_$$uniqueId^%zewdAPI(nodeOID,filename)	
 . s mainAttrs("store")=store
 s widgetObjName="zewdST"_$$uniqueId^%zewdAPI(nodeOID,filename)	
 i $g(mainAttrs("object"))'="" d
 . s widgetObjName=mainAttrs("object")
 . k mainAttrs("object")
 s widgetObj="EWD.sencha.widget."_widgetObjName
 s widgetId=$g(mainAttrs("id"))
 i widgetId="" s widgetId="zewdSTLst"_$$uniqueId^%zewdAPI(nodeOID,filename)
 k mainAttrs("id")
 ;
 d setAttribute^%zewdDOM("return",widgetObj,listOID)
 d setAttribute^%zewdDOM("id",widgetId,listOID)
 ;
 i $g(mainAttrs("addto"))'="" d
 . n jsOID,parent,postSTOID,text
 . s parent=$g(mainAttrs("addto"))
 . k mainAttrs("addto")
 . s text="Ext.getCmp('"_parent_"').add(Ext.getCmp('"_widgetId_"'));Ext.getCmp('"_parent_"').doLayout();"
 . i $g(mainAttrs("setactive"))="true" d
 . . n transition
 . . s transition=$g(mainAttrs("transition"))
 . . i transition="" s transition="slide"
 . . s text=text_"Ext.getCmp('"_parent_"').setActiveItem(Ext.getCmp('"_widgetId_"'),'"_transition_"');"
 . i $$createJS("standard")
 . s postSTOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,text)
 ;
 i $g(mainAttrs("renderfn"))'="" d
 . i $g(lsOID)="" s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",listOID)
 . s attr("afterrender")="."_mainAttrs("renderfn")
 . s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 . k mainAttrs("renderfn")
 ;
 i $g(mainAttrs("nextpagefield"))'="" d
 . s mainAttrs("nextpage")=".record.get('"_mainAttrs("nextpagefield")_"')"
 . k mainAttrs("nextpagefield") 
 ;
 i $g(mainAttrs("nextpage"))'="" d
 . n cpid,fn,lOID
 . s cpid=$g(mainAttrs("cardpanel"))
 . k mainAttrs("cardpanel")
 . i $g(lsOID)="" s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",listOID)
 . s text="function(view,index,item,e){"
 . s text=text_"if (EWD.sencha.listClicked) return;"
 . s text=text_"EWD.sencha.listClicked = true;"
 . s text=text_"var record = "_store_".getAt(index);"
 . i $g(mainAttrs("transition"))="" s mainAttrs("transition")="slide"
 . i $g(mainAttrs("transition"))'="" d
 . . n nextpage
 . . s nextpage=mainAttrs("nextpage")
 . . i $e(nextpage,1)'="." d
 . . . s nextpage="'"_nextpage_"'"
 . . e  d
 . . . s nextpage=$e(nextpage,2,$l(nextpage))
 . . s text=text_"EWD.sencha.cardPanelAction["_nextpage_"]={transition:'"_mainAttrs("transition")_"',id:'"_cpid_"'};"
 . . k mainAttrs("transition")
 . s text=text_"var nvp='listItemNo='+(index+1);"
 . s text=text_"var page="
 . i $e(mainAttrs("nextpage"),1)'="." d
 . . s text=text_"'"_mainAttrs("nextpage")_"';"
 . e  d
 . . s text=text_$e(mainAttrs("nextpage"),2,$l(mainAttrs("nextpage")))_";"
 . ; + DLW
 . i $g(mainAttrs("synch"))'="" d
 . . s text=text_"var synch="
 . . s text=text_mainAttrs("synch")_";"
 . . s text=text_"EWD.ajax.getPage({page:page,synch:synch,nvp:nvp});"
 . . k mainAttrs("synch")
 . e  d
 . . s text=text_"EWD.ajax.getPage({page:page,nvp:nvp});"
 . ; - DLW
 . ;s text=text_"EWD.ajax.getPage({page:page,nvp:nvp});"
 . ;s fn=$$ewdAjaxRequest(mainAttrs("nextpage"),"ewdNullId",1,listOID)
 . ;s text=text_fn_"(nvp);"
 . k mainAttrs("nextpage")
 . s text=text_"}"
 . s attr("itemtap")="."_text
 . s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 ;
 s sessionName=$g(mainAttrs("sessionname")) k mainAttrs("sessionname")
 ;
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i name="storeid" q
 . i name="ontap" q
 . s value=mainAttrs(name)
 . i name="store" s value="."_value
 . d setAttribute^%zewdDOM(name,value,listOID)
 ;
 s text="EWD.sencha.addWidget('"_$p(filename,".ewd",1)_"','"_widgetId_"');"
 i $$createJS("standard")
 s stOID=$$getElementById^%zewdDOM("ewdSTJS",docOID)
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text)
 ;
 s attr("objectname")=widgetObj
 i $g(itemsOID)'="" s itemOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID,,.attr)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:imagehandler" d  q
 . . d imageHandler(childOID,listOID,$g(lsOID))
 . ;
 . i tagName="st:layout" d
 . . i $g(lsOID)="" s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",listOID)
 . . d layout(childOID,listOID,.field,lsOID,widgetId)
 ;
 i $g(mainAttrs("ontap"))'=""  d
 . n lOID
 . i $g(lsOID)="" s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",listOID)
 . s text="function(view,index,item,e){"
 . s text=text_"var record = "_store_".getAt(index);"
 . i $g(mainAttrs("transition"))'="" d
 . . s text=text_"EWD.sencha.transition='"_mainAttrs("transition")_"';"
 . . k mainAttrs("transition")
 . s text=text_mainAttrs("ontap")_"(index,record"
 . i mainAttrs("ontap")="EWD.sencha.listItemTapProxy" s text=text_",'"_widgetId_"'"
 . s text=text_");"
 . s text=text_"}"
 . s attr("itemtap")="."_text
 . s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 . ;s onTap("handler")=mainAttrs("ontap")
 . ;s onTap("listenerOID")=lOID
 . k mainAttrs("ontap")
 ;
 s text="Ext.regModel('"_widgetId_"',{fields:["
 s name="",comma=""
 f  s name=$o(field(name)) q:name=""  s text=text_comma_"'"_name_"'",comma=","
 s text=text_"]});"
 s stOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text)
 ;
 s text=store_"=new Ext.data.JsonStore({"
 s text=text_"model:'"_widgetId_"'"
 i $g(mainAttrs("storeid"))'="" s text=text_",id:'"_mainAttrs("storeid")_"'"
 s text=text_"});"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text)
 ;
 s stOID=$$getElementById^%zewdDOM("ewdPostSTJS",docOID)
 s text=" d writeListData^%zewdST2("""_sessionName_""","_isAjax_",sessid)"
 s cspOID=$$addCSPServerScript^%zewdAPI(stOID,text)
 i 'isAjax d
 . s cspOID=$$removeChild^%zewdDOM(cspOID)
 . s cspOID=$$insertBefore^%zewdDOM(cspOID,stOID)
 s text="EWD.sencha.loadListData("_store_",EWD.sencha.jsonData);"
 ;s phpVar=$$addPhpVar^%zewdCustomTags("#"_sessionName)
 ;s text="EWD.sencha.loadListData("_store_","_phpVar_");"
 s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text) 
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
imageHandler(nodeOID,listOID,listenersOID,imgHandler)
 n attr,lOID
 i $g(imgHandler)="" s imgHandler=$$getAttribute^%zewdDOM("fn",nodeOID)
 i $g(listenersOID)="" s listenersOID=$$addElementToDOM^%zewdDOM("st:listeners",listOID)
 s attr("el")=".{delegate:'img',click:"_imgHandler_"}"
 s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 QUIT
 ;
layout(nodeOID,listOID,field,lsOID,listId)
 ;
 n childNo,childOID,OIDArray,tagName,template
 ;
 s template=""
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:field" d  q
 . . n display,name
 . . s name=$$getAttribute^%zewdDOM("name",childOID)
 . . s display=$$getAttribute^%zewdDOM("displayinlist",childOID)
 . . i display="" s display="true"
 . . s field(name)=""
 . . i display="true" s template=template_"{"_name_"}"
 . i tagName="st:imagefield" d  q
 . . n name
 . . s name=$$getAttribute^%zewdDOM("name",childOID)
 . . s field(name)=""
 . . s template=template_"&lt;img src='{"_name_"}'>&lt;/img>"
 . i tagName="st:text" d
 . . n value
 . . s value=$$getAttribute^%zewdDOM("value",childOID)
 . . s value=$$replaceAll^%zewdAPI(value,"&nbsp;"," ")
 . . s template=template_value
 . i tagName="st:image" d
 . . n align,class,dataField,height,idField,idRoot,onClick,src,width
 . . s align=$$getAttribute^%zewdDOM("align",childOID)
 . . s class=$$getAttribute^%zewdDOM("class",childOID)
 . . s idField=$$getAttribute^%zewdDOM("idfield",childOID)
 . . s dataField=$$getAttribute^%zewdDOM("datafield",childOID)
 . . s idRoot=$$getAttribute^%zewdDOM("idroot",childOID)
 . . i class="" s class=idRoot
 . . s onClick=$$getAttribute^%zewdDOM("onclick",childOID)
 . . s src=$$getAttribute^%zewdDOM("src",childOID)
 . . s height=$$getAttribute^%zewdDOM("height",childOID)
 . . i height="" s height=40
 . . s width=$$getAttribute^%zewdDOM("width",childOID)
 . . i width="" s width=40
 . . s template=template_"&lt;img height='"_height_"' width='"_width_"'"
 . . i idField'="" s template=template_" id='"_idRoot_"{"_idField_"}'"
 . . i dataField'="" s template=template_" data='{"_dataField_"}'"
 . . i src'="" s template=template_" src='"_src_"'"
 . . i class'="" s template=template_" class='"_class_"'"
 . . i align="right" s template=template_" style='float:right;margin-left:15px'"
 . . s template=template_">&lt;/img>"
 . . i align'="right" s template=template_"&nbsp;&nbsp;"
 . . i $g(onClick)'="" d
 . . . n imgHandler,jsOID,stOID,text
 . . . s text="EWD.sencha.handlerByClass['"_class_"']='"_onClick_"';"
 . . . i $$createJS("standard")
 . . . s stOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 . . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text)
 . . . s imgHandler="EWD.sencha.onListImageClick"
 . . . d imageHandler(childOID,listOID,$g(lsOID),imgHandler)
 . . . i $g(mainAttrs("ontap"))'="" d
 . . . . s text="EWD.sencha.onListItemTap['"_listId_"']='"_mainAttrs("ontap")_"';"
 . . . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",stOID,,,text)
 . . . . s mainAttrs("ontap")="EWD.sencha.listItemTapProxy"
 . ;
 . i tagName="st:tag" d
 . . n class,name,idField,idRoot,lOID
 . . s class=$$getAttribute^%zewdDOM("class",childOID)
 . . s name=$$getAttribute^%zewdDOM("name",childOID)
 . . s idField=$$getAttribute^%zewdDOM("idfield",childOID)
 . . s idRoot=$$getAttribute^%zewdDOM("idroot",childOID)
 . . s template=template_"&lt;"_name
 . . i idField'="" s template=template_" id='"_idRoot_"{"_idField_"}'"
 . . i class'="" s template=template_" class='"_class_"'"
 . . s template=template_">&lt;/"_name_"> "
 d setAttribute^%zewdDOM("itemtpl",template,listOID)
 QUIT
 ; 
menu(nodeOID,parentOID)
 ;
 n attr,childOID,fitHeight,fitWidth,funcOID,items,jsText,listChange,lOID,lsOID,mainAttrs,menuOID,nextPage
 n postSTOID,preSTOID,sessionName,title,xOID
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s fitWidth=$g(mainAttrs("fitwidth")) k mainAttrs("fitwidth")
 s fitHeight=$g(mainAttrs("fitheight")) k mainAttrs("fitheight")
 s sessionName=$g(mainAttrs("sessionname")) k mainAttrs("sessionname")
 s title=$g(mainAttrs("title")) k mainAttrs("title")
 s nextPage=$g(mainAttrs("nextpage")) k mainAttrs("nextpage")
 s items=$g(mainAttrs("return"))
 i items="" s items="zewdSTNList"_$$uniqueId^%zewdAPI(nodeOID,filename)
 ;
 s attr("xtype")="nestedlist"
 i fitWidth="true" s attr("width")=".EWD.sencha.nestedList.width"
 i fitHeight="true" s attr("height")=".EWD.sencha.nestedList.height"
 s attr("store")="."_items_"Store"
 s menuOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.attr)
 s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",menuOID)
 s listChange="zewdSTListchange"_$$uniqueId^%zewdAPI(lsOID,filename)
 s attr("itemtap")="."_listChange
 s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 ;
 i title'="" d
 . s attr("title")=title
 . s xOID=$$addElementToDOM^%zewdDOM("st:toolbar",menuOID,,.attr)
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s attr("method")="writeMenuOptions^%zewdST2"
 s attr("param1")=sessionName
 s attr("param2")=items
 s attr("param3")="#ewd_sessid"
 s attr("type")="procedure"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:execute",preSTOID,,.attr)
 ;
 i nextPage'="" d
 . s attr("return")=listChange
 . s attr("addVar")="false"
 . s attr("parameters")="subList, subIdx"
 . s jsText="var store=subList.getStore();"_$c(13,10)
 . s jsText=jsText_"var record=store.getAt(subIdx);"_$c(13,10)
 . s jsText=jsText_"var nvp='menuItemNo='+record.get('key');"_$c(13,10)
 . s jsText=jsText_"ewd.ajaxRequest("""_nextPage_""",EWD.sencha.div.nullId,nvp);"
 . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 ;
 s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 i childOID'="" d
 . i $$getTagName^%zewdDOM(childOID)="st:popup" d popup(childOID,listChange)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT
 ;
popup(nodeOID,jsVar)
 ;
 n attr,buttonText,height,hideDetailButton,jsText,mainAttrs,page,preSTOID
 n return,title,width,x,xOID,y
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s page=$g(mainAttrs("page")) i page="" s page="missingPopupPage"
 i page'[".ewd" s page=page_".ewd"
 s height=$g(mainAttrs("height")) i height="" s height="500"
 s width=$g(mainAttrs("width")) i width="" s width="500"
 s x=$g(mainAttrs("x")) i x="" s x=200
 s y=$g(mainAttrs("y")) i y="" s y=200
 s title=$g(mainAttrs("title"))
 s hideDetailButton=$g(mainAttrs("hidedetailbutton")) i hideDetailButton="" s hideDetailButton="true"
 s buttonText=$g(mainAttrs("buttontext")) i buttonText="" s buttonText="Back"
 ;
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 s attr("src")=page
 s return="zewdSTPageURL"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s attr("return")=return
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jspage",preSTOID,,.attr)
 s attr("return")=jsVar
 s attr("addVar")="false"
 s attr("parameters")="subList, subIdx"
 s jsText="var store=subList.getStore();"_$c(13,10)
 s jsText=jsText_"var record=store.getAt(subIdx);"_$c(13,10)
 s jsText=jsText_"var nvp='menuItemNo='+record.get('key');"_$c(13,10)
 s jsText=jsText_"EWD.sencha.selectedMenuItem=record;"_$c(13,10)
 s jsText=jsText_"EWD.sencha.openPopup({src:"_return_",nvp:nvp"
 i height'="" s jsText=jsText_",height:"_height
 i width'="" s jsText=jsText_",width:"_width
 i x'="" s jsText=jsText_",x:"_x
 i y'="" s jsText=jsText_",y:"_y
 i title'="" s jsText=jsText_",title:"""_title_""""
 i hideDetailButton'="" s jsText=jsText_",hideDetailButton:"_hideDetailButton
 i buttonText'="" s jsText=jsText_",buttonText:"""_buttonText_""""
 s jsText=jsText_"});"
 s xOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText) 
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
cardPanel(nodeOID,bodyOID,itemsOID)
 ;
 n childNo,childOID,id,tagName,xnodeOID,OIDArray
 ;
 d setAttribute^%zewdDOM("layout","card",nodeOID)
 s xnodeOID=$$renameTag^%zewdDOM("st:panel",nodeOID)
 s id=$$getAttribute^%zewdDOM("id",xnodeOID)
 i id="" d
 . s id="zewdSTcardPanel"_$$uniqueId^%zewdAPI(xnodeOID,filename)
 . d setAttribute^%zewdDOM("id",id,xnodeOID)
 ;
 d getChildrenInOrder^%zewdDOM(xnodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:listcard"!(tagName="st:list") d
 . . n panelOID,xchildOID
 . . s panelOID=$$insertNewParentElement^%zewdDOM(childOID,"st:panel",docOID)
 . . s xchildOID=childOID
 . . i tagName="st:listcard" s xchildOID=$$renameTag^%zewdDOM("st:list",childOID)
 . . d setAttribute^%zewdDOM("cardpanel",id,xchildOID)
 ;
 d subPanel(xnodeOID,bodyOID,itemsOID)
 ;
 QUIT
 ;
subPanel(nodeOID,bodyOID,itemsOID)
 ;
 n attr,childNo,childOID,itemOID,lOID,lsOID,mainAttrs,name,OIDArray,subItemsOID,tagName,xOID,xtype
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s xtype="panel"
 i tagName="st:carousel" s xtype="carousel"
 i tagName="st:tabpanel" s xtype="tabpanel"
 i tagName="st:icon" s xtype=""
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID)
 i xtype'="" d setAttribute^%zewdDOM("xtype",xtype,itemOID)
 i $g(mainAttrs("fitwidth"))'="" d
 . s mainAttrs("minwidth")=".EWD.sencha.nestedList.width"
 . s mainAttrs("maxwidth")=".EWD.sencha.nestedList.width"
 . k mainAttrs("fitwidth")
 ;
 i $g(mainAttrs("page"))'="" d
 . s lsOID=$$addElementToDOM^%zewdDOM("st:listeners",itemOID)
 . s attr("afterrender")=".function() {EWD.ajax.getPage({page:'"_mainAttrs("page")_"'});}"
 . s lOID=$$addElementToDOM^%zewdDOM("st:listener",lsOID,,.attr)
 . k mainAttrs("page")
 ;
 s name=""
 f  s name=$o(mainAttrs(name)) q:name=""  d
 . i name="object" q
 . d setAttribute^%zewdDOM(name,mainAttrs(name),itemOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:pageitem" d pageItem^%zewdST2(childOID,,docOID,technology)
 . i tagName="st:layout"!(tagName="st:tabbar")!(tagName="st:defaults") d panelLayout^%zewdST2(childOID,itemOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo="",subItemsOID=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName'["st:" d  q
 . . n class,id,jsOID,jsText,postSTOID,preSTOID
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,bodyxOID)
 . . s id=$$getAttribute^%zewdDOM("id",childOID)
 . . i id="" d
 . . . n sOID
 . . . s id="zewdSTMarkup"_$$uniqueId^%zewdAPI(childOID,filename)
 . . . d setAttribute^%zewdDOM("id",id,childOID)
 . . . s sOID=$$insertNewParentElement^%zewdDOM(childOID,"span",docOID)
 . . . d setAttribute^%zewdDOM("style","display:none",sOID)
 . . d setAttribute^%zewdDOM("contentEl",id,itemOID)
 . . s class=$$getAttribute^%zewdDOM("class",childOID)
 . . s postSTOID=$$getElementById^%zewdDOM("ewdPostST",docOID)
 . . s jsText="EWD.sencha.contentEl='"_id_"';"
 . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",postSTOID,,,jsText)
 . . i class="stBlueHighlight" d
 . . . s jsText="EWD.sencha.resetMenuHeight('stBlueHighlight');"
 . . . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . . . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,jsText)
 . ;
 . i tagName="st:toolbar" d  q
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,itemOID)
 . . d toolbar(xOID,,1)
 . ;
 . ;i tagName="st:tabbar"!(tagName="st:defaults") d  q
 . ;. s xOID=$$removeChild^%zewdDOM(childOID)
 . ;. s xOID=$$appendChild^%zewdDOM(childOID,itemOID)
 . ;
 . i tagName="st:form" d  q
 . . s xOID=$$removeChild^%zewdDOM(childOID)
 . . s xOID=$$appendChild^%zewdDOM(childOID,bodyxOID)
 . . s return="zewdSTForm"_$$uniqueId^%zewdAPI(childOID,filename)
 . . d setAttribute^%zewdDOM("return",return,childOID)
 . . d setAttribute^%zewdDOM("placeattop","true",childOID)
 . . d setAttribute^%zewdDOM("items",".["_return_"]",itemOID)
 . ;
 . i tagName="st:panel"!(tagName="st:icon")!(tagName="st:tabpanel")!(tagName="st:carousel")!(tagName="st:list")!(tagName="st:touchgrid") d
 . . i subItemsOID="" s subItemsOID=$$addElementToDOM^%zewdDOM("st:items",itemOID)
 . . i tagName="st:list" d list(childOID,subItemsOID) q
 . . i tagName="st:touchgrid" d touchGridSub^%zewdST2(childOID,subItemsOID) q
 . . d subPanel(childOID,nodeOID,subItemsOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
 ;
toolbar(nodeOID,parentOID,isSubpanel)
 ;
 n attr,childNo,childOID,diOID,itemOID,itemsOID,jsOID
 n mainAttrs,OIDArray,preSTOID,tagName,text
 ;
 ;   <st:toolbar style="light" position="bottom" spaced="true">
 ;     <st:toolbarButton style="action" text="Logout" nextPage="logout" />
 ;   </st:toolbar>
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 ;
 i '$g(isSubpanel) d
 . s diOID=$$getTagOID^%zewdDOM("st:dockeditems",docName)
 . i diOID="" s diOID=$$insertNewNextSibling^%zewdST2("st:dockeditems",nodeOID)
 e  d
 . s diOID=$$insertNewNextSibling^%zewdST2("st:dockedItems",nodeOID)
 ;
 i $g(mainAttrs("style"))'="" d
 . s mainAttrs("ui")=mainAttrs("style")
 . k mainAttrs("style")
 i $g(mainAttrs("position"))'="" d
 . s mainAttrs("dock")=mainAttrs("position")
 . k mainAttrs("position")
 s tagName=$$getTagName^%zewdDOM(nodeOID)
 s attr("xtype")="toolbar"
 i tagName="st:tabbar" s attr("xtype")="tabbar"
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",diOID,,.attr)
 d addAttrs(.mainAttrs,itemOID)
 s itemsOID=$$addElementToDOM^%zewdDOM("st:items",itemOID)
 ;
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . i tagName="st:toolbarbutton"!(tagName="st:button") d toolbarButton(childOID,itemsOID)
 . i tagName="st:icon" d
 . . n iconAttrs,itemOID
 . . do getAttributeValues^%zewdCustomTags(childOID,.iconAttrs)
 . . ;i $g(iconAttrs("iconcls"))'="" d
 . . . ;s iconAttrs("iconMask")="."_iconAttrs("iconmask")
 . . . ;s iconAttrs("iconCls")=iconAttrs("iconcls")
 . . . ;k iconAttrs("iconcls"),iconAttrs("iconmask")
 . . s itemOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID,,.iconAttrs)
 . i tagName="st:spacer" d
 . . n attr,spacerOID
 . . s attr("xtype")="spacer"
 . . s spacerOID=$$addElementToDOM^%zewdDOM("st:item",itemsOID,,.attr)
 ;
 s text="EWD.sencha.resetMenuHeight('toolbar');"
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 i preSTOID'="" s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,text)
 ;
 i $$removeChild^%zewdDOM(nodeOID)
 ;
 QUIT
 ;
ewdAjaxRequest(nextPage,targetId,hasNVP,nodeOID,addVar)
 ;
 n attr,fn,funcOID,jsOID,jsText,preSTOID
 ;
 s fn="zewdSTFn"_$$uniqueId^%zewdAPI(nodeOID,filename)
 s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 i preSTOID="" d
 . s jsOID=$$createJS("standard")
 . s preSTOID=$$getElementById^%zewdDOM("ewdSTJS",docOID)
 i $g(targetId)="" s targetId="ewdNullId"
 s attr("return")=fn
 i $g(addVar)="" s addVar="false"
 s attr("addVar")=addVar
 s nextPage=$g(nextPage) 
 i nextPage="" s nextPage="missingNextPage"
 s jsText="ewd.ajaxRequest("""_nextPage_""","""_targetId_""""
 i $g(hasNVP)=1 d
 . s jsText=jsText_",nvp"
 . s attr("parameters")="nvp"
 s jsText=jsText_");"
 s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 QUIT fn
 ;
toolbarButton(nodeOID,parentOID)
 ;
 n attr,funcOID,handler,id,itemOID,jsOID,jsText,lOID,lsOID,mainAttrs,nextPage,preSTOID,targetId,type
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 s type=$g(mainAttrs("type")) ;i type="" s type="action" 
 i type'="",type'="autoback" d
 . n handler
 . s handler=$g(mainAttrs("handler"))
 . i handler="" d
 . . s handler="zewdSTHandler"_$$uniqueId^%zewdAPI(nodeOID,filename)
 . . s preSTOID=$$getElementById^%zewdDOM("ewdPreST",docOID)
 . . i preSTOID="" d
 . . . s jsOID=$$createJS("standard")
 . . . s preSTOID=$$getElementById^%zewdDOM("ewdSTJS",docOID)
 . . . i $g(mainAttrs("targetid"))="" s mainAttrs("targetid")="ewdNullId"
 . . s attr("return")=handler
 . . s attr("addVar")="false"
 . . s nextPage=$g(mainAttrs("nextpage")) i nextPage="" s nextPage="missingNextPage"
 . . s targetId=$g(mainAttrs("targetid")) i targetId="" s targetId="st-uui-nullId"
 . . s jsText="ewd.ajaxRequest("""_nextPage_""","""_targetId_""");"
 . . s funcOID=$$addElementToDOM^%zewdDOM("ewd:jsfunction",preSTOID,,.attr,jsText)
 ;e  d
 ;. s handler="EWD.sencha.onToolbarBack"
 ;
 s id=$g(mainAttrs("id"))
 i id="" s id="zewdSTToolbar"_$$uniqueId^%zewdAPI(nodeOID,filename)
 i type'="",type'="icon" s attr("ui")=mainAttrs("type")
 i type="autoback" s attr("ui")="back"
 i $g(mainAttrs("text"))'="" s attr("text")=mainAttrs("text")
 s attr("id")=id
 i $g(mainAttrs("hidden"))'="" s attr("hidden")=mainAttrs("hidden")
 i type'="icon" s attr("xtype")="button"
 i type="icon" d
 . i $g(mainAttrs("iconcls"))'="" s attr("iconCls")=mainAttrs("iconcls")
 . i $g(mainAttrs("iconmask"))'="" s attr("iconMask")=mainAttrs("iconmask")
 . i $g(mainAttrs("ui"))'="" s attr("ui")=mainAttrs("ui")
 i $g(mainAttrs("ui"))'="",type="" s attr("ui")=mainAttrs("ui")
 i $g(mainAttrs("handler"))'="" d
 . s attr("handler")="."_mainAttrs("handler")
 s itemOID=$$addElementToDOM^%zewdDOM("st:item",parentOID,,.attr)
 i $g(mainAttrs("type"))="autoback" d
 . n jsOID,text,preSTOID
 . i $g(mainAttrs("cardpanel"))'="" d
 . . s text="EWD.sencha.cardBackButton['"_mainAttrs("cardpanel")_"']='"_id_"';"
 . e  d
 . . s text="EWD.sencha.backbuttonId='"_id_"';"
 . s jsOID=$$createJS("standard")
 . s preSTOID=$$getElementById^%zewdDOM("ewdPreSTJS",docOID)
 . s jsOID=$$addElementToDOM^%zewdDOM("ewd:jsline",preSTOID,,,text)
 ;
 QUIT
 ;
class(className,nodeOID)
 ;
 n attr,childNo,childOID,cOID,jsOID
 n mainAttrs,OIDArray,oOID,parentOID,pOID,sOID,stop,subTagName,tagName
 ;
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d convertAttrsToCamelCase^%zewdST2(.mainAttrs)
 s jsOID=$$createJS()
 s jsOID=$$getElementById^%zewdDOM("ewdST",docOID)
 i jsOID="" s jsOID=$$getElementById^%zewdDOM("ewdSTJS",docOID)
 s cOID=$$addConstructor(jsOID,.mainAttrs,className)
 s pOID=$$addElementToDOM^%zewdDOM("ewd:jsparameters",cOID)
 s oOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",pOID)
 k mainAttrs("placeattop")
 d addNVPs(.mainAttrs,oOID)
 ;
 k OIDArray
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . s subTagName=$p(tagName,"st:",2)
 . s subTagName=$$convertToCamelCase^%zewdST2(subTagName)
 . s sOID=$$subTag(subTagName,childOID,oOID)
 ;
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT  
 ;
subTag(subTagName,nodeOID,parentOID)
 ;
 n attr,childNo,childOID,mainAttrs,OIDArray,sOID,stOID,subName,subTagOID,tagName
 ;
 i subTagName="item" d
 . s subTagOID=parentOID
 e  i subTagName="listener" d
 . s subTagOID=parentOID
 e  i subTagName="object" d  QUIT subTagOID
 . do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 . d setAttribute^%zewdDOM("ref",$g(mainAttrs("name")),parentOID)
 . d removeIntermediateNode^%zewdDOM(nodeOID)
 . s subTagOID=parentOID
 e  d
 . i subTagName="tabbar" s subTagName="tabBar"
 . s attr("name")=subTagName
 . s attr("type")="object"
 . i subTagName="items"!(subTagName="dockedItems") s attr("type")="array"
 . s subTagOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 do getAttributeValues^%zewdCustomTags(nodeOID,.mainAttrs)
 d addNVPs(.mainAttrs,subTagOID)
 s stOID=subTagOID
 d getChildrenInOrder^%zewdDOM(nodeOID,.OIDArray)
 s childNo=""
 f  s childNo=$o(OIDArray(childNo)) q:childNo=""  d
 . s childOID=OIDArray(childNo)
 . s tagName=$$getTagName^%zewdDOM(childOID)
 . s subName=$p(tagName,"st:",2)
 . i subTagName="items"!(subTagName="dockedItems")  s subTagOID=$$addElementToDOM^%zewdDOM("ewd:jsobject",stOID)
 . s sOID=$$subTag(subName,childOID,subTagOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 QUIT subTagOID
 ;
addNVPs(mainAttrs,parentOID)
 ;
 n attr,attrcc,attrlc,count,nvpOID,terms,type,value
 ;
 d defineCamelCaseTerms^%zewdST2(.terms)
 s attrlc="",count=0
 f  s attrlc=$o(mainAttrs(attrlc)) q:attrlc=""  d
 . s count=count+1
 ;
 i count=1,$g(mainAttrs("objectname"))'="" d  QUIT
 . s parentOID=$$renameTag^%zewdDOM("ewd:jsvariable",parentOID)
 . d setAttribute^%zewdDOM("name",mainAttrs("objectname"),parentOID)
 ;
 s attrlc=""
 f  s attrlc=$o(mainAttrs(attrlc)) q:attrlc=""  d
 . s attrcc=$$getCamelCase^%zewdST2(attrlc,.terms)
 . s value=mainAttrs(attrlc)
 . s type="literal"
 . i value="true"!(value="false") s type="boolean"
 . i $$numeric^%zewdJSON(value) s type="numeric"
 . i attrcc="handler" s type="reference"
 . i $e(value,1)="." s value=$e(value,2,$l(value)),type="reference"
 . s attr("name")=attrcc
 . s attr("value")=value
 . s attr("type")=type
 . s nvpOID=$$addElementToDOM^%zewdDOM("ewd:jsnvp",parentOID,,.attr)
 QUIT
 ;
addAttrs(mainAttrs,nodeOID)
 ;
 n attrcc,attrlc,terms,value
 ;
 d defineCamelCaseTerms^%zewdST2(.terms)
 s attrlc=""
 f  s attrlc=$o(mainAttrs(attrlc)) q:attrlc=""  d
 . s attrcc=$$getCamelCase^%zewdST2(attrlc,.terms)
 . s value=mainAttrs(attrlc)
 . d setAttribute^%zewdDOM(attrcc,value,nodeOID)
 QUIT
 ;
addConstructor(parentOID,mainAttrs,className)
 ;
 n attr,cOID,placeAtTop,return
 ;
 s return=$g(mainAttrs("return"))
 i return="" s return="ExtPanel"_$$uniqueId^%zewdAPI(nodeOID,filename)
 k mainAttrs("return")
 ;
 s placeAtTop=$g(mainAttrs("placeattop"))
 i placeAtTop="" d
 . s cOID=$$addElementToDOM^%zewdDOM("ewd:jsconstructor",parentOID)
 e  d
 . s cOID=$$insertNewFirstChildElement^%zewdDOM(parentOID,"ewd:jsconstructor",docOID)
 ;
 d setAttribute^%zewdDOM("return",return,cOID)
 d setAttribute^%zewdDOM("object",className,cOID)
 d removeAttribute^%zewdDOM("placeattop",cOID)
 QUIT cOID
 ;
createJS(type)
 ;
 n attr,jsOID,postSTOID,preSTOID,stOID
 ;
 s jsOID=$$getTagOID^%zewdDOM("ewd:js",docName)
 i jsOID="" d
 . n nsOID
 . s nsOID=$$getElementById^%zewdDOM("ewdajaxonload",docOID)
 . s jsOID=$$createElement^%zewdDOM("ewd:js",docOID)
 . s jsOID=$$insertBefore^%zewdDOM(jsOID,nsOID)
 s stOID=$$getElementById^%zewdDOM("ewdSTJS",docOID)
 i stOID'="" s type="standard"
 i stOID="" d
 . s stOID=$$getElementById^%zewdDOM("ewdST",docOID)
 i $g(stOID)="",$g(type)="" d
 . s attr("id")="ewdPreST"
 . s preSTOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 . s attr("id")="ewdST"
 . s stOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 . s attr("id")="ewdPostST"
 . s postSTOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 i stOID="",$g(type)="standard" d
 . s attr("id")="ewdPreSTJS"
 . s preSTOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 . s attr("id")="ewdSTJS"
 . s stOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 . s attr("id")="ewdPostSTJS"
 . s postSTOID=$$addElementToDOM^%zewdDOM("ewd:jssection",jsOID,,.attr)
 QUIT jsOID
 ;
addSlashAtEnd(string)
 i $e(string,$l(string))'="/" s string=string_"/"
 QUIT string
 ;
