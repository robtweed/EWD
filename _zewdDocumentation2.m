%zewdDocumentation2 ;
 ;
 ; Product: Enterprise Web Developer (Build 846)
 ; Build Date: Wed, 09 Feb 2011 13:14:58
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
DOM2 ;
 ;;<method id="getTagOID">
 ;;<call>
 ;;s nodeOID=$$getTagOID^%zewdDOM(tagName,docName,lowerCase)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of the first Element node found in the DOM with the specified tag name.  This is a fast way
 ;;of finding tags that occur only once in a document, eg the "head" or "body" tags.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="tagName" mandatory="true">
 ;;The required Tag Name
 ;;</parameter>
 ;;<parameter no="2" name="docName" mandatory="true">
 ;;The DOM Document Name
 ;;</parameter>
 ;;<parameter no="3" name="lowerCase">
 ;;If set to 0, then the tag name match is case-sensitive.  The default value is 0 = case insensitive tag name matching.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the matching Element node
 ;;</returnValue>
 ;;</method>
 ;;<method id="getTarget">
 ;;<call>
 ;;s target=$$getTarget^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the target value for a Processing Instruction node.  For example in the processing instruction:
 ;;&lt;?xml version='1.0' encoding='UTF-8' ?&gt;
 ;;the Target is "xml"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the Processing Instruction node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The Processing Instruction node's target value
 ;;</returnValue>
 ;;</method>
 ;;<method id="hasAttribute">
 ;;<call>
 ;;s has=$$hasAttribute^%zewdDOM(attrName,elementOID)
 ;;</call>
 ;;<purpose>
 ;;Returns "true" if the specified element contains the specified attribute
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attrName" mandatory="true">
 ;;The name of the required attribute
 ;;</parameter>
 ;;<parameter no="2" name="elementOID" mandatory="true">
 ;;The OID of the element node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns the literal string value "true" if the element contains the attribute, otherwise returns "false"
 ;;</returnValue>
 ;;</method>
 ;;<method id="hasAttributes">
 ;;<call>
 ;;s has=$$hasAttributes^%zewdDOM(elementOID)
 ;;</call>
 ;;<purpose>
 ;;Returns "true" if the specified element contains one or more attributes
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="elementOID" mandatory="true">
 ;;The OID of the element node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns the literal string value "true" if the element contains any attributes, otherwise returns "false"
 ;;</returnValue>
 ;;</method>
 ;;<method id="hasChildNodes">
 ;;<call>
 ;;s has=$$hasChildNodes^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns "true" if the specified node has one or more child nodes
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the parent node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns the literal string value "true" if the node has any child nodes, otherwise returns "false"
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="importNode">
 ;;<call>
 ;;s toNodeOID=$$importNode^%zewdDOM(fromNodeOID,deep,toDocOID)
 ;;</call>
 ;;<purpose>
 ;;Copies a DOM node and, optionally the sub-tree underneath it, from one DOM to another. The
 ;;top copied node is left unattached to any other node in the DOM into which it was copied.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="fromNodeOID" mandatory="true">
 ;;The node to be imported.  If a sub-tree is being copied, specify the top node.
 ;;</parameter>
 ;;<parameter no="2" name="deep" mandatory="true">
 ;;If a value of "true" is specified, then the entire sub-tree under the specified "fromNode" will be copied.
 ;;If any other value is specified, only the specified "fromNode" will be copied.
 ;;</parameter>
 ;;<parameter no="3" name="toDocOID" mandatory="true">
 ;;The OID of the DOM into which the node/subtree will be copied
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the copied node within the DOM to which it has been imported.
 ;;</returnValue>
 ;;</method>
 ;;<method id="insertBefore">
 ;;<call>
 ;;s nodeOID=$$insertBefore^%zewdDOM(newOID,nextSiblingOID)
 ;;</call>
 ;;<purpose>
 ;;Attaches an element node as the previous sibling of a specified node.  The node
 ;;to be attached must exist within the DOM tree but must be currently
 ;;un-attached to any other node.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="newOID" mandatory="true">
 ;;The OID of the element that is to be inserted
 ;;</parameter>
 ;;<parameter no="2" name="parentOID" mandatory="true">
 ;;The OID of the node before which the new node is to be attached
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly attached node, or an error string
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="insertNewFirstChildElement">
 ;;<call>
 ;;s nodeOID=$$insertNewFirstChildElement^%zewdDOM(parentOID,tagName,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a new Element node with the specified tag name and attaches it as the first child of
 ;;the specified parent Element.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="parentOID" mandatory="true">
 ;;The OID of the parent Element
 ;;</parameter>
 ;;<parameter no="2" name="tagName" mandatory="true">
 ;;The Tag Name of the new Element to be created
 ;;</parameter>
 ;;<parameter no="3" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Element
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="insertNewIntermediateElement">
 ;;<call>
 ;;s nodeOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,tagName,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a new Element node with the specified tag name and attaches it as the first and only child of
 ;;the specified parent Element.  Any child nodes of the parent are moved to become child nodes of
 ;;the newly created node.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="parentOID" mandatory="true">
 ;;The OID of the parent Element
 ;;</parameter>
 ;;<parameter no="2" name="tagName" mandatory="true">
 ;;The Tag Name of the new Element to be created
 ;;</parameter>
 ;;<parameter no="3" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Element
 ;;</returnValue>
 ;;</method>
 ;;<method id="insertNewIntermediateElement">
 ;;<call>
 ;;s nodeOID=$$insertNewIntermediateElement^%zewdDOM(parentOID,tagName,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a new Element node with the specified tag name and attaches it as the first and only child of
 ;;the specified parent Element.  Any child nodes of the parent are moved to become child nodes of
 ;;the newly created node.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="parentOID" mandatory="true">
 ;;The OID of the parent Element
 ;;</parameter>
 ;;<parameter no="2" name="tagName" mandatory="true">
 ;;The Tag Name of the new Element to be created
 ;;</parameter>
 ;;<parameter no="3" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Element
 ;;</returnValue>
 ;;</method>
 ;;<method id="modifyTextData">
 ;;<call>
 ;;s nodeOID=$$modifyTextData^%zewdDOM(newText,elementOID)
 ;;</call>
 ;;<purpose>
 ;;Modifies the text inside an Element tag.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="newText" mandatory="true">
 ;;String value containing the new text
 ;;</parameter>
 ;;<parameter no="2" name="elementOID" mandatory="true">
 ;;The OID of the Element whose text is to be modified
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the Element
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="newXMLDocument">
 ;;<call>
 ;;s docOID=$$newXMLDocument^%zewdDOM(docName,outerTag,hasProcIns)
 ;;
 ;;For example if the following call was made:
 ;;
 ;;s docOID=$$newXMLDocument^%zewdDOM("myDOM","hello",1)
 ;;
 ;;The following document will be created:
 ;;
 ;;&lt;?xml version='1.0' encoding='UTF-8'?&gt;
 ;;&lt;hello /&gt;
 ;;</call>
 ;;<purpose>
 ;;Creates a new EWD XML DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The Name to assign to the new DOM (any DOM with this name is deleted)
 ;;</parameter>
 ;;<parameter no="2" name="outerTag" mandatory="true">
 ;;Tag Name for the outer tag (ie Document Element)
 ;;</parameter>
 ;;<parameter no="2" name="hasProcIns">
 ;;If set to 1, a standard XML Processing instruction is added to the top of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the new DOM
 ;;</returnValue>
 ;;</method>
 ;;<method id="nodeExists">
 ;;<call>
 ;;s exists=$$nodeExists^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns 1 if the specified node exists in an EWD DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node to be checked
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns 1 if the node exists.
 ;;Returns "0~DOM does not exist" if the DOM is non-existent
 ;;Returns "0~Node does not exist" if the DOM exists but does not contain the specified node OID
 ;;</returnValue>
 ;;</method>
 ;;<method id="outputDOM">
 ;;<call>
 ;;s ok=$$outputDOM^%zewdDOM(docName,escape,format,outputLocation,msgLength,outputRef)
 ;;</call>
 ;;<purpose>
 ;;Outputs the DOM as an XML document. The most frequent use is when debugging and examining
 ;;an EWD DOM, for which the call is:
 ;;
 ;;s ok=$$outputDOM^%zewdDOM(docName,1,2)
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The Document Name or Document OID of the DOM to be output as XML
 ;;</parameter>
 ;;<parameter no="2" name="escape" mandatory="true">
 ;;If set to 1, any entities are escaped.  1 is recommended
 ;;</parameter>
 ;;<parameter no="3" name="format" mandatory="true">
 ;;0 = no whitespace is added between tags
 ;;1 = a line break is added between tags
 ;;2 = a line break is added and the tags are indented according to the tree hierarchy
 ;;</parameter>
 ;;<parameter no="4" name="outputLocation">
 ;;By default the XML is output to the current device.  However you can specify output
 ;;to a file, global or local array using this parameter:
 ;;
 ;;"file" = output to a file
 ;;79     = output to global or local array
 ;;</parameter>
 ;;<parameter no="5" name="msgLength">
 ;;Not used
 ;;</parameter>
 ;;<parameter no="6" name="outputRef">
 ;;If outputLocation is specified, this parameter determines the filename or global/local array name
 ;;to which the XML will be directed, eg:
 ;;
 ;;"d:\myFiles\myXMLFile.xml"
 ;;"^myXMLDOcument($j)"
 ;;
 ;;If a global or local array is specified, the structure of the global/array that is created is:
 ;;
 ;;@gloRef@(lineNo) = line of XML
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns null ("")
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="removeAttribute">
 ;;<call>
 ;;d removeAttribute^%zewdDOM(attrName,elementOID,deleteFromDOM)
 ;;</call>
 ;;<purpose>
 ;;Removes a named attribute from a specified Element
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attrName" mandatory="true">
 ;;The name of the attribute to be removed
 ;;</parameter>
 ;;<parameter no="2" name="elementOID" mandatory="true">
 ;;The OID of the Element from which the attribute is to be removed
 ;;</parameter>
 ;;<parameter no="3" name="deleteFromDOM">
 ;;If set to 1, the attribute node is permanently removed from the DOM.
 ;;If set to 0, the attribute node is disconnected from the Element, but left within the DOM tree
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue />
 ;;</method>
 ;;<method id="removeChild">
 ;;<call>
 ;;s nodeOID=$$removeChild^%zewdDOM(nodeOID,deleteFromDOM)
 ;;</call>
 ;;<purpose>
 ;;Removes a specified node from the document
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node to be removed
 ;;</parameter>
 ;;<parameter no="2" name="deleteFromDOM">
 ;;If set to 1, the node and any descendent nodes are permanently removed from the DOM.
 ;;If set to 0, the node (and any descendents) is disconnected from its parent, but left within the DOM tree
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the removed node
 ;;</returnValue>
 ;;</method>
 ;;<method id="removeDocument">
 ;;<call>
 ;;s docName=$$removeDocument^%zewdDOM(docName)
 ;;</call>
 ;;<purpose>
 ;;Deletes an EWD DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The name of the DOM to be deleted
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The name of the document
 ;;</returnValue>
 ;;</method>
 ;;<method id="removeIntermediateNode">
 ;;<call>
 ;;s nodeOID=$$removeIntermediateNode^%zewdDOM(nodeOID,deleteFromDOM)
 ;;</call>
 ;;<purpose>
 ;;Removes a specified node from the DOM, but any child nodes belonging to the deleted node are moved up
 ;;the tree hierarchy to replace the deleted node.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node to be removed
 ;;</parameter>
 ;;<parameter no="2" name="deleteFromDOM">
 ;;If set to 1, the node is permanently removed from the DOM.
 ;;If set to 0, the node is disconnected from its parent, but left within the DOM tree
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the deleted node
 ;;</returnValue>
 ;;</method>
 ;;<method id="setAttribute">
 ;;<call>
 ;;d setAttribute^%zewdDOM(attrName,attrValue,elementOID)
 ;;</call>
 ;;<purpose>
 ;;Adds an attribute to an Element node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attrName" mandatory="true">
 ;;The name of the attribute to be added to the Element
 ;;</parameter>
 ;;<parameter no="2" name="attrValue" mandatory="true">
 ;;The value of the attribute to be added to the Element
 ;;</parameter>
 ;;<parameter no="3" name="elementOID" mandatory="true">
 ;;The OID of the Element to which the attribute is being added
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue />
 ;;</method>
 ;;<method id="addCSPServerScript">
 ;;<call>
 ;;s newOID=$$addCSPServerScript^%zewdDOM(parentOID,text)
 ;;</call>
 ;;<purpose>
 ;;Adds an inline CSP script block into the EWD Page DOM, ie:
 ;;&lt;script language="cache" runat="server"&gt;
 ;;  // adds your code here, as defined in the text parameter
 ;;&lt;/script&gt;
 ;;
 ;;This tag is required if your custom tag needs to add some CSP/WebLink-specific
 ;;logic to the page.  Note that use of this method will make your custom tag usable 
 ;;only by users of CSP or WebLink.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="parentOID" mandatory="true">
 ;;The OID of the parent node under which the script will be added as the last child
 ;;</parameter>
 ;;<parameter no="2" name="text" mandatory="true">
 ;;The Cache Objectscript code that you want to add to the page.  Any line breaks
 ;;should be defined as $c(13,10)
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created script tag
 ;;</returnValue>
 ;;</method>
 ;;<method id="addJavascriptFunction">
 ;;<call>
 ;;s newOID=$$addJavascriptFunction^%zewdDOM(docName,.jsTextArray)
 ;;</call>
 ;;<purpose>
 ;;Adds a Javascript function to an EWD Page DOM.  If a script tag does not 
 ;;exist to contain the function, then it is added to the page or fragment.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM
 ;;</parameter>
 ;;<parameter no="2" name="jsTextArray" mandatory="true">
 ;;A local array containing the lines of text that comprise the JavaScript function, eg:
 ;;   jsTextArray(1)=”function myFunc() {“
 ;;   jsTextArray(2)=” alert('test function') '
 ;;   jsTextArray(3)=”}”
 ;;
 ;;Passed by Reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the script tag that contains the Javascript function
 ;;</returnValue>
 ;;</method>
 ;;<method id="addJavascriptObject">
 ;;<call>
 ;;s newOID=$$addJavascriptObject^%zewdDOM(docName,.jsTextArray)
 ;;</call>
 ;;<purpose>
 ;;Adds a Javascript object declaration to an EWD Page DOM.  If a script tag does not 
 ;;exist to contain the function, then it is added to the page or fragment.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM
 ;;</parameter>
 ;;<parameter no="2" name="jsTextArray" mandatory="true">
 ;;A local array containing the lines of text that comprise the JavaScript object, eg:
 ;;
 ;;jsTextArray(1)=”myObj.test = function() {“ 
 ;;jsTextArray(2)=” alert('test function') '
 ;;jsTextArray(3)=”} ;”
 ;;
 ;;Passed by Reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the script tag that contains the Javascript function
 ;;</returnValue>
 ;;</method>
 ;;<method id="createJSPCommand">
 ;;<call>
 ;;s newOID=$$createJSPCommand^%zewdDOM(data,docOID)
 ;;</call>
 ;;<purpose>
 ;;Adds an inline JSP script block into the EWD Page DOM, ie:
 ;;&lt%
 ;;  //Your JSP code in here
 ;;%&gt;
 ;;
 ;;This tag is required if your custom tag needs to add some JSP-specific
 ;;logic to the page.  Note that use of this method will make your custom tag usable 
 ;;only by users of JSP, unless you cater for all other potential technologies.
 ;;
 ;;Note: this function adds the JSP script block to the page but does not attach it to
 ;;any node.  You must do this yourself, eg using appendChild().
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="data" mandatory="true">
 ;;The JSP code that you want to add to the page.  Any line breaks
 ;;should be defined as $c(13,10)
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the EWD Page DOM into which the JSP script block is to be added
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created JSP script tag
 ;;</returnValue>
 ;;</method>
 ;;<method id="createPHPCommand">
 ;;<call>
 ;;s newOID=$$createPHPCommand^%zewdDOM(data,docOID)
 ;;</call>
 ;;<purpose>
 ;;Adds an inline PHP script block into the EWD Page DOM, ie:
 ;;&lt?php
 ;;  //Your PHP code in here
 ;;?%&gt;
 ;;
 ;;This tag is required if your custom tag needs to add some PHP-specific
 ;;logic to the page.  Note that use of this method will make your custom tag usable 
 ;;only by users of PHP, unless you cater for all other potential technologies.
 ;;
 ;;Note: this function adds the PHP script block to the page but does not attach it to
 ;;any node.  You must do this yourself, eg using appendChild().
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="data" mandatory="true">
 ;;The PHP code that you want to add to the page.  Any line breaks
 ;;should be defined as $c(13,10)
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the EWD Page DOM into which the PHP script block is to be added
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created JSP script tag
 ;;</returnValue>
 ;;</method>
 ;;<method id="getJavascriptFunctionBody">
 ;;<call>
 ;;s newOID=$$getJavascriptFunctionBody^%zewdDOM(functionName,docName)
 ;;</call>
 ;;<purpose>
 ;;This function allows you to extract the contents of a named Javascript 
 ;;function from the EWD page DOM.
 ;;
 ;;Note that the body of the specified Javascript function is returned as a
 ;;single string, with line breaks denoted by CRLF [$c(13,10)] characters,
 ;;and also note that the body does not include the “function myFunction
 ;;{“ declaration line or the closing brace [ } ]
 ;;
 ;;This method will search for the specified javascript function in all
 ;;&lt;script&gt; tags within the EWD page DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="functionName" mandatory="true">
 ;;The name of the Javascript function you want to find
 ;;</parameter>
 ;;<parameter no="2" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM containing the function
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;A text string that contains the body of the specified Javascript function.
 ;;
 ;;In a page that contains the following Javascript function:
 ;;
 ;;function release(objid) {
 ;;var obj=document.getElementById(objid) ;
 ;;obj.className = "popupOn" ;
 ;;grabbed = false ;
 ;;}
 ;;
 ;;the returnValue from this function would be:
 ;;
 ;;var obj=document.getElementById(objid) ;
 ;;obj.className = "popupOn" ;
 ;;grabbed = false ;
 ;;</returnValue>
 ;;</method>
 ;;<method id="getJavascriptObjectBody">
 ;;<call>
 ;;s newOID=$$getJavascriptObjectBody^%zewdDOM(objMethodName,docName)
 ;;</call>
 ;;<purpose>
 ;;This function allows you to extract the contents of a named Javascript 
 ;;Object declaration from the EWD page DOM.
 ;;
 ;;Note that the body of the specified Javascript object definition is
 ;;returned as a single string, with line breaks denoted by CRLF [$c
 ;;(13,10)] characters, and also note that the body does not include the
 ;;“myObj.myFunction = function() {“ declaration line or the closing
 ;;brace [ } ]
 ;;
 ;;This method will search for the specified javascript object in all
 ;;&lt;script&gt; tags within the EWD page DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="objMethodName" mandatory="true">
 ;;The name of the required Javascript object method
 ;;</parameter>
 ;;<parameter no="2" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM containing the function
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;A text string that contains the body of the specified Javascript object method definition.
 ;;
 ;;In a page that contains the following Javascript function:
 ;;
 ;;myObj.myFunc = function(objid) {
 ;;var obj=document.getElementById(objid) ;
 ;;obj.className = "popupOn" ;
 ;;grabbed = false ;
 ;;}
 ;;
 ;; the returnValue from this function would be:
 ;;
 ;;var obj=document.getElementById(objid) ;
 ;;obj.className = "popupOn" ;
 ;;grabbed = false ;
 ;;</returnValue>
 ;;</method>
 ;;<method id="javascriptFunctionExists">
 ;;<call>
 ;;s exists=$$javascriptFunctionExists^%zewdDOM(functionName,docName)
 ;;</call>
 ;;<purpose>
 ;;Determines whether or not the specified Javascript function exists in the EWD page DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="functionName" mandatory="true">
 ;;The name of the Javascript function. Eg if you have a function declared as:
 ;;
 ;; function myFunc() {
 ;;  ....
 ;; }
 ;;
 ;;then the function name would be “myFunc”
 ;;</parameter>
 ;;<parameter no="2" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM containing the function
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;1 = the function exists; 
 ;;0 = the function does not exist
 ;;</returnValue>
 ;;</method>
 ;;<method id="javascriptObjectExists">
 ;;<call>
 ;;s exists=$$javascriptObjectExists^%zewdDOM(objectName,docName)
 ;;</call>
 ;;<purpose>
 ;;Determines whether or not the specified Javascript Object declaration exists in the EWD page DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="objectName" mandatory="true">
 ;;The name of the Javascript object. Eg if you have an object declared as:
 ;;
 ;; myObj.myFunc = function(objid) {
 ;; var obj=document.getElementById(objid) ;
 ;; obj.className = "popupOn" ;
 ;; grabbed = false ;
 ;; }
 ;;
 ;;then you would be able to determine that the declaration exists if you specify the objectName as “myObj.myFunc”
 ;;</parameter>
 ;;<parameter no="2" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM containing the function
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;1 = the Object declaration exists; 
 ;;0 = the Object declaration does not exist
 ;;</returnValue>
 ;;</method>
 ;;<method id="replaceJavascriptFunctionBody">
 ;;<call>
 ;;s exists=$$replaceJavascriptFunctionBody^%zewdDOM(functionName,jsText,docName)
 ;;</call>
 ;;<purpose>
 ;;Finds a specified Javascript function in the EWD page DOM and replaces its contents.
 ;;The new function body content is held in a single text variable with line breaks denoted by CRLF [$c(13,10)] characters
 ;;Note that this function performs a complete body replacement – the original contents of the JavaScript function will be discarded
 ;;
 ;;For example:
 ;;
 ;;Set newBody=” alert('testing') ;”
 ;;set newBody=newBody_$c(13,10)_” var x = 123 ;”
 ;;set ok=$$replaceJavascriptFunctionBody^%zewdDOM(“myFunc”,newBody,docName)
 ;;
 ;;This would result in:
 ;;
 ;;function myFunc(a,b) {
 ;;alert('testing') ;
 ;;var x = 123 ;
 ;}
 ;;Note that the function declaration and any inputs are left unchanged.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="functionName" mandatory="true">
 ;;The name of the Javascript function to be replaced.
 ;;</parameter>
 ;;<parameter no="2" name="jsText" mandatory="true">
 ;;Text string containing the new lines of Javascript.  Line breaks should be denoted using $c(13,10)
 ;;</parameter>
 ;;<parameter no="3" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM containing the function
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;1 = successful function substitution
 ;;</returnValue>
 ;;</method>
 ;;<method id="replaceJavascriptObjectBody">
 ;;<call>
 ;;s exists=$$replaceJavascriptObjectBody^%zewdDOM(objectName,jsText,docName)
 ;;</call>
 ;;<purpose>
 ;;Finds a specified Javascript object declaration in the EWD page DOM and replaces its contents.
 ;;The new object declaration body content is held in a single text variable with line breaks denoted by CRLF [$c(13,10)] characters.
 ;;Note that this function performs a complete body replacement – the original contents of the JavaScript object declaration will be discarded
 ;;
 ;;For example:
 ;;
 ;;set newBody=” alert('testing') ;”
 ;;set newBody=newBody_$c(13,10)_” var x = 123 ;”
 ;;set ok=$$replaceJavascriptObjectBody^%zewdAPI(“myObj.myFunc”,newBody,docName)
 ;;
 ;;This would result in:
 ;;
 ;;myObj.myFunc = function(objid) {
 ;;alert('testing') ;
 ;;var x = 123 ;
 ;;}
 ;;
 ;;Note that the object declaration wrapper and any inputs are left unchanged.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="objectName" mandatory="true">
 ;;The name of the Javascript object whose definition is be replaced.
 ;;</parameter>
 ;;<parameter no="2" name="jsText" mandatory="true">
 ;;Text string containing the new lines of Javascript.  Line breaks should be denoted using $c(13,10)
 ;;</parameter>
 ;;<parameter no="3" name="docName" mandatory="true">
 ;;The name of the EWD Page DOM containing the object
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;1 = successful object substitution
 ;;</returnValue>
 ;;</method>
 ;;</ewdDocumentation>
 ;;***END***
