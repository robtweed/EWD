%zewdDocumentation1 ;
 ;
 ; Product: Enterprise Web Developer (Build 894)
 ; Build Date: Wed, 14 Dec 2011 08:43:21
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
DOM1 ;
 ;;<ewdDocumentation api="DOM">
 ;;<method id="addElementToDOM">
 ;;<call>
 ;;s newOID=$$addElementToDOM^%zewdDOM(tagName,parentOID,"",.attrArray,text,asFirstChild)
 ;;</call>
 ;;<purpose>
 ;;Add an element, its associated attributes and text, if any, as a child of a parent element
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="tagName" mandatory="true">
 ;;The name of the new element to instantiate (NB case-sensitive)
 ;;</parameter>
 ;;<parameter no="2" name="parentOID" mandatory="true">
 ;;The OID of the new element's parent
 ;;</parameter>
 ;;<parameter no="3" name="null">
 ;;Not used: leave null
 ;;</parameter>
 ;;<parameter no="4" name="attrArray">
 ;;Local array containing attribute name/value pairs, in the format:
 ;;attrArray(attrName)=attrValue
 ;;For example:
 ;;attrArray("hello")="world"
 ;;attrArray("source")="c:\myFiles"
 ;;</parameter>
 ;;<parameter no="5" name="text">
 ;;Optional text to be added inside the element's opening and closing tags
 ;;</parameter>
 ;;<parameter no="6" name="asFirstChild">
 ;;By default, addElementToDoM adds the new element as the last child of the specified parent
 ;;element.  If you set the asFirstChild parameter to "1", then the new element is added as
 ;;the first child of the parent node.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Element, or an error string
 ;;</returnValue>
 ;;</method>
 ;;<method id="addTextToElement">
 ;;<call>
 ;;s textOID=$$addTextToElement^%zewdDOM(elementOID,text)
 ;;</call>
 ;;<purpose>
 ;;Adds/appends a text node to an element
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="elementOID" mandatory="true">
 ;;The OID of the element to which the text is to be added
 ;;</parameter>
 ;;<parameter no="2" name="text" mandatory="true">
 ;;The text to be added
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Text Node, or an error string
 ;;</returnValue>
 ;;</method>
 ;;<method id="appendChild">
 ;;<call>
 ;;s childOID=$$appendChild^%zewdDOM(newChildOID,parentOID)
 ;;</call>
 ;;<purpose>
 ;;Appends an element node as the last child of a parent element.  The node
 ;;to be appended must exist within the DOM tree but must be currently
 ;;un-connected to any other node.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="newChildOID" mandatory="true">
 ;;The OID of the element that is to be appended as a last child
 ;;</parameter>
 ;;<parameter no="2" name="parentOID" mandatory="true">
 ;;The OID of the parent element
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Child Node, or an error string
 ;;</returnValue>
 ;;</method>
 ;;<method id="attributeExists">
 ;;<call>
 ;;s exists=$$attributeExists^%zewdDOM(attributeName,elementOID)
 ;;</call>
 ;;<purpose>
 ;;Tests whether or not the specified element contains the specified attribute
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attributeName" mandatory="true">
 ;;The name of the attribute
 ;;</parameter>
 ;;<parameter no="2" name="parentOID" mandatory="true">
 ;;The OID of the element
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns a value of 1 if the element contains the attribute; 0 if not
 ;;</returnValue>
 ;;</method>
 ;;<method id="clearDOMs">
 ;;<call>
 ;;d clearDOMs^%zewdDOM
 ;;</call>
 ;;<purpose>
 ;;Deletes all EWD DOMs from the current namespace.
 ;;</purpose>
 ;;<parameters />
 ;;<returnValue />
 ;;</method>
 ;;<method id="cloneDocument">
 ;;<call>
 ;;s toDocOID=$$cloneDocument^%zewdDOM(fromDocName,toDocName)
 ;;</call>
 ;;<purpose>
 ;;Creates an exact copy of a DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="fromDocName" mandatory="true">
 ;;The name of the DOM to be copied
 ;;</parameter>
 ;;<parameter no="2" name="toDocName" mandatory="true">
 ;;The name of the DOM to be created
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created DOM
 ;;</returnValue>
 ;;</method>
 ;;<method id="copyNodes">
 ;;<call>
 ;;s toNodeOID=$$copyNodes^%zewdDOM(fromNodeOID,toDocOID,parentOID,deep)
 ;;</call>
 ;;<purpose>
 ;;Copies a DOM node and, optionally the sub-tree underneath it, from one DOM to another. The
 ;;top copied node is appended as the last child of a specified parent element in the other DOM.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="fromNodeOID" mandatory="true">
 ;;The node to be copied.  If a sub-tree is being copied, specify the top node.
 ;;</parameter>
 ;;<parameter no="2" name="toDocOID" mandatory="true">
 ;;The OID of the DOM to which the node/subtree will be copied
 ;;</parameter>
 ;;<parameter no="3" name="parentOID" mandatory="true">
 ;;The OID of the element to which the node will be appended as the last child
 ;;</parameter>
 ;;<parameter no="4" name="deep" mandatory="true">
 ;;If a value of "true" is specified, then the entire sub-tree under the specified "fromNode" will be copied.
 ;;If any other value is specified, only the specified "fromNode" will be copied.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the copied node within the DOM to which it has been copied.
 ;;</returnValue>
 ;;</method>
 ;;<method id="createCDATASection">
 ;;<call>
 ;;s cdataOID=$$createCDATASection^%zewdDOM(data,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a CDATA Section node.  The node will not be attached to any other node in the DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="data" mandatory="true">
 ;;Text string containing the data to be included in the CDATA section.  Any line breaks should
 ;;be specified using either $c(13,10) or $c(10)
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the DOM into which the CDATA Section is to be added.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created CDATA Section node
 ;;</returnValue>
 ;;</method>
 ;;<method id="createComment">
 ;;<call>
 ;;s commentOID=$$createComment^%zewdDOM(data,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a comment node.  The node will not be attached to any other node in the DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="data" mandatory="true">
 ;;Text string containing the comment.  Any line breaks should
 ;;be specified using either $c(13,10) or $c(10)
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the DOM into which the comment node is to be added.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Comment node
 ;;</returnValue>
 ;;</method>
 ;;<method id="createDocumentType">
 ;;<call>
 ;;s docTypeOID=$$createDocumentType^%zewdDOM(qualifiedName,publicId,systemId,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a Document Type node.  The node will not be attached to any other node in the DOM
 ;;eg:
 ;;&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;
 ;;
 ;;Here the qualifiedName = "html", the publicID = "-//W3C//DTD XHTML 1.0 Strict//EN" and
 ;;the systemId = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="qualifiedName" mandatory="true">
 ;;The document type name, eg "html"
 ;;</parameter>
 ;;<parameter no="2" name="publicId">
 ;;The public ID of the document type, eg "-//W3C//DTD XHTML 1.0 Strict//EN".  If specified, the word
 ;;"PUBLIC" will appear in the DOCTYPE tag.
 ;;</parameter>
 ;;<parameter no="3" name="systemId">
 ;;The system ID of the document type, eg "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd".
 ;;If a system ID is specified but no public ID is specified, the word "SYSTEM" will appear in the DOCTYPE tag.
 ;;</parameter>
 ;;<parameter no="4" name="docOID" mandatory="true">
 ;;The OID of the DOM into which the Document Type node is to be added.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Document Type node
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="createElement">
 ;;<call>
 ;;s elementOID=$$createElement^%zewdDOM(tagName,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates an empty element node.  The node will not be attached to any other node in the DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="tagName" mandatory="true">
 ;;The element's tag name
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the DOM into which the element node is to be added.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Element node
 ;;</returnValue>
 ;;</method>
 ;;<method id="createProcessingInstruction">
 ;;<call>
 ;;s piOID=$$createProcessingInstruction^%zewdDOM(target,data,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a processing instruction node.  The node will not be attached to any other node in the DOM.
 ;;eg:
 ;;&lt;?xml version='1.0' encoding='UTF-8' ?&gt;
 ;;In this example, target = "xml", data = "version='1.0' encoding='UTF-8'
 ;;This method can also be used to create PHP processing instructions, eg:
 ;;&lt;?php
 ;;//this is some PHP code
 ;;?&gt;
 ;;In this example, "php" is the target and your PHP code is specified as data.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="target" mandatory="true">
 ;;The Processing Instruction target
 ;;</parameter>
 ;;<parameter no="2" name="data" mandatory="true">
 ;;The data portion of the Processing Instruction
 ;;</parameter>
 ;;<parameter no="3" name="docOID" mandatory="true">
 ;;The OID of the DOM into which the processing instruction node is to be added.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Processing Instruction node
 ;;</returnValue>
 ;;</method>
 ;;<method id="createTextNode">
 ;;<call>
 ;;s textOID=$$createTextNode^%zewdDOM(data,docOID)
 ;;</call>
 ;;<purpose>
 ;;Creates a text node.  The node will not be attached to any other node in the DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="data" mandatory="true">
 ;;Text string containing the text
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the DOM into which the text node is to be added.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the newly created Text node
 ;;</returnValue>
 ;;</method>
 ;;<method id="documentNameExists">
 ;;<call>
 ;;s exists=$$documentNameExists^%zewdDOM(docName)
 ;;</call>
 ;;<purpose>
 ;;Tests whether or not the specified DOM exists in the current namespace
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The name of the DOM document
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns a value of 1 if the named DOM exists; 0 if not
 ;;</returnValue>
 ;;</method>
 ;;<method id="getAttribute">
 ;;<call>
 ;;s attrValue=$$getAttribute^%zewdDOM(attrName,elementOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the value of the specified attribute in the specified element
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attrName" mandatory="true">
 ;;The name of the attribute
 ;;</parameter>
 ;;<parameter no="2" name="elementOID" mandatory="true">
 ;;The OID of the element
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The value of the specified attribute
 ;;</returnValue>
 ;;</method>
 ;;<method id="getAttributeArray">
 ;;<call>
 ;;s status=$$getAttributeArray^%zewdDOM(elementOID,.attrArray)
 ;;</call>
 ;;<purpose>
 ;;Returns a local array of attributes belonging to the specified element.
 ;;The array is of the format:
 ;;attrArray(attrName)=attrOID
 ;;eg:
 ;;attrArray("href")="7-107"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="elementOID" mandatory="true">
 ;;The OID of the element
 ;;</parameter>
 ;;<parameter no="2" name="attrArray" mandatory="true">
 ;;The name of the array in which the list of attributes will be returned.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns a value of null ("") if it ran successfully
 ;;</returnValue>
 ;;</method>
 ;;<method id="getAttributeValues">
 ;;<call>
 ;;d getAttributeValues^%zewdDOM(elementOID,.attrArray)
 ;;</call>
 ;;<purpose>
 ;;Returns a local array of attribute name/value pairs belonging to the specified element.
 ;;The array is of the format:
 ;;attrArray(attrName)=attrValue
 ;;eg:
 ;;attrArray("href")="http://www.mgateway.com"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="elementOID" mandatory="true">
 ;;The OID of the element
 ;;</parameter>
 ;;<parameter no="2" name="attrArray" mandatory="true">
 ;;The name of the array in which the list of attributes will be returned.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue />
 ;;</method>
 ;;<method id="getChildrenInOrder">
 ;;<call>
 ;;d getChildrenInOrder^%zewdDOM(parentOID,.childArray)
 ;;</call>
 ;;<purpose>
 ;;Returns a local array of the OIDs of a node's child nodes, sorted in child position order
 ;;The array is of the format:
 ;;childArray(no)=childOID
 ;;eg:
 ;;childArray(1)="7-15"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="parentOID" mandatory="true">
 ;;The OID of the parent element whose child elements you wish to locate
 ;;</parameter>
 ;;<parameter no="2" name="childArray" mandatory="true">
 ;;The name of the array in which the list of child nodes will be returned.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue />
 ;;</method>
 ;;<method id="getData">
 ;;<call>
 ;;s text=$$getData^%zewdDOM(nodeOID,.textArray)
 ;;</call>
 ;;<purpose>
 ;;Returns the data property for a node.  This method is only applicable to those node types
 ;;that have a data property, eg 3 (text), 4 (CDATA), 7 (Processing Instruction), 8 (Comment)
 ;;
 ;;If the data content is under 15k, then it is returned as a single text string return value.
 ;;Longer content may be returned in the textArray
 ;;
 ;;The array is of the format:
 ;;textArray(lineNo)=line of data text
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node whose data is required
 ;;</parameter>
 ;;<parameter no="2" name="textArray" mandatory="true">
 ;;The name of the array in which text will be returned if too much to be returned as a simple return value.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The data content of the node (if less than 15k in size)
 ;;</returnValue>
 ;;</method>
 ;;<method id="getDescendantNodes">
 ;;<call>
 ;;d getDescendantNodes^%zewdDOM(nodeOID,.OIDArray)
 ;;</call>
 ;;<purpose>
 ;;Returns a local array of the OIDs for all a node's descendant nodes (ie all nodes in the sub-tree beneath it)
 ;;The array is of the format:
 ;;OIDArray(nodeOID)=tagName | null if not an element
 ;;eg:
 ;;OIDArray("7-15")="div"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the parent element whose descendents you wish to locate
 ;;</parameter>
 ;;<parameter no="2" name="OIDArray" mandatory="true">
 ;;The name of the array in which the list of descendant nodes will be returned.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue />
 ;;</method>
 ;;<method id="getDocumentAttribute">
 ;;<call>
 ;;s attrib=$$getDocumentAttribute^%zewdDOM(docOID,attributeName)
 ;;</call>
 ;;<purpose>
 ;;Returns the value of the specified DOM document attribute.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;<parameter no="2" name="attributeName" mandatory="true">
 ;;The attribute required.  The following are supported:
 ;;documentElement
 ;;documentName
 ;;creationDate
 ;;creationTime
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The value of the specified attribute
 ;;</returnValue>
 ;;</method>
 ;;<method id="getDocumentElement">
 ;;<call>
 ;;s deOID=$$getDocumentElement^%zewdDOM(docOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of a DOM's Document Element (ie its outermost element node)
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the Document Element
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="getDocumentName">
 ;;<call>
 ;;s docName=$$getDocumentName^%zewdDOM(docOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the Document Name of a specified DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The Document Name
 ;;</returnValue>
 ;;</method>
 ;;<method id="getDocumentNode">
 ;;<call>
 ;;s docOID=$$getDocumentNode^%zewdDOM(docName)
 ;;</call>
 ;;<purpose>
 ;;Returns the Document Node (ie the top-most DOM node) for a specified named DOM
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="docName" mandatory="true">
 ;;The DOcument Name of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the Document Node
 ;;</returnValue>
 ;;</method>
 ;;<method id="getElementById">
 ;;<call>
 ;;s nodeOID=$$getElementById^%zewdDOM(id,docOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of the element that has the specified id attribute value
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="id" mandatory="true">
 ;;The id attribute value
 ;;</parameter>
 ;;<parameter no="2" name="docOID" mandatory="true">
 ;;The OID of the DOM
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the matching element
 ;;</returnValue>
 ;;</method>
 ;;<method id="getElementText">
 ;;<call>
 ;;s text=$$getElementText^%zewdDOM(nodeOID,.textArray)
 ;;</call>
 ;;<purpose>
 ;;Returns the text inside an element node, if it exists
 ;;
 ;;If the text is less than 15k, then it is returned as a single text string return value.
 ;;Longer content may be returned in the textArray
 ;;
 ;;The array is of the format:
 ;;textArray(lineNo)=line of data text
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node whose text is required
 ;;</parameter>
 ;;<parameter no="2" name="textArray" mandatory="true">
 ;;The name of the array in which text will be returned if too much to be returned as a simple return value.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The text content of the element (if less than 15k in size)
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="getElementsArrayByTagName">
 ;;<call>
 ;;s status=$$getElementsArrayByTagName^%zewdDOM(tagName,docName,fromNodeOID,.OIDArray)
 ;;</call>
 ;;<purpose>
 ;;Returns a local array of all element nodes with the specified tag name.
 ;;The array is of the format:
 ;;OIDArray(nodeOID)=""
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="tagname" mandatory="true">
 ;;The name of the tag required, eg "div"
 ;;</parameter>
 ;;<parameter no="2" name="docName">
 ;;The Document Name of the DOM being searched.  Specify this parameter if you want to search the entire DOM.
 ;;Leave blank if you want to search a sub-tree within the DOM
 ;;</parameter>
 ;;<parameter no="3" name="fromNodeOID">
 ;;The OID of the node at the top of the sub-tree you wish to search.
 ;;Specify this parameter if you want to search a sub-tree within the DOM.
 ;;Leave blank if you want to search the entire DOM.
 ;;</parameter>
 ;;<parameter no="4" name="OIDArray" mandatory="true">
 ;;The name of the array in which the list of matching elements will be returned.
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;Returns the value "1~OIDArray" if successful
 ;;</returnValue>
 ;;</method>
 ;;
 ;;<method id="getFirstChild">
 ;;<call>
 ;;s childOID=$$getFirstChild^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of an element's first child node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the parent node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the first child node.  Returns null if the specified node has no child nodes
 ;;</returnValue>
 ;;</method>
 ;;<method id="getLastChild">
 ;;<call>
 ;;s childOID=$$getLastChild^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of an element's last child node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the parent node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the last child node.  Returns null if the specified node has no child nodes
 ;;</returnValue>
 ;;</method>
 ;;<method id="getListOfDOMs">
 ;;<call>
 ;;d getListOfDOMs^%zewdDOM(.domList)
 ;;</call>
 ;;<purpose>
 ;;Returns a local array of the EWD DOMs by Document Name in the current namespace
 ;;
 ;;The array is of the format:
 ;;domList(docName)=""
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="domList" mandatory="true">
 ;;The name of the array in which the DOM Document Names will be returned
 ;;NB: called by reference
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue />
 ;;</method>
 ;;<method id="getLocalName">
 ;;<call>
 ;;s localName=$$getLocalName^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the local name of a specified element.  In the case of a tag name such as "ewd:config", then
 ;;the local name is "config".  If the tag name does not contain a ":" character, then the tag name is
 ;;returned
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The tag Local Name
 ;;</returnValue>
 ;;</method>
 ;;<method id="getName">
 ;;<call>
 ;;s attrName=$$getName^%zewdDOM(attrOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the name of the specified attribute node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attrOID" mandatory="true">
 ;;The OID of the attribute node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The attribute name
 ;;</returnValue>
 ;;</method>
 ;;<method id="getNextChild">
 ;;<call>
 ;;s nextChildOID=$$getNextChild^%zewdDOM(parentOID,childOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of the next sibling node after the one specified for a parent node. This method
 ;;can be called repeatedly to iterate through a node's child nodes.
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="parentOID" mandatory="true">
 ;;The OID of the parent node whose child nodes you wish to access
 ;;</parameter>
 ;;<parameter no="2" name="childOID" mandatory="true">
 ;;The OID of the previous child node.  If this is set to null, the parent's first child is returned.
 ;;If the parent node's last child is specified, the method returns null.
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the next child node.  Returns null if there are no more children.
 ;;</returnValue>
 ;;</method>
 ;;<method id="getNextSibling">
 ;;<call>
 ;;s siblingOID=$$getNextSibling^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of an element's next sibling node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the previous sibling node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the next sibling node.  Returns null if the specified node has no sibling nodes
 ;;</returnValue>
 ;;</method>
 ;;<method id="getNodeType">
 ;;<call>
 ;;s nodeType=$$getNodeType^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the XML node type of the specified node.  Supported node types are as follows:
 ;;1 = Element
 ;;2 = Attribute
 ;;3 = Text
 ;;4 = CDATA Section
 ;;7 = Processing Instruction
 ;;8 = Comment
 ;;10 = Document Type
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The Node Type
 ;;</returnValue>
 ;;</method>
 ;;<method id="getOwnerElement">
 ;;<call>
 ;;s elementOID=$$getOwnerElement(attrOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of the element node that contains the specified attribute node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="attrOID" mandatory="true">
 ;;The OID of the attribute node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the owner element node
 ;;</returnValue>
 ;;</method>
 ;;<method id="getParentNode">
 ;;<call>
 ;;s parentOID=$$getParentNode^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of a node's parent node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the child node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the parent node.
 ;;</returnValue>
 ;;</method>
 ;;<method id="getPrefix">
 ;;<call>
 ;;s prefix=$$getPrefix^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the prefix of a specified element.  In the case of a tag name such as "ewd:config", then
 ;;the prefix is "ewd".  If the tag name does not contain a ":" character, then the tag name is
 ;;returned
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The tag Prefix
 ;;</returnValue>
 ;;</method>
 ;;<method id="getPreviousSibling">
 ;;<call>
 ;;s siblingOID=$$getPreviousSibling^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the OID of an element's previous sibling node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the next sibling node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the previous sibling node.  Returns null if the specified node has no previous sibling node
 ;;</returnValue>
 ;;</method>
 ;;<method id="getPublicId">
 ;;<call>
 ;;s publicId=$$getPublicId^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the Public ID of a Document Type (DOCTYPE) element
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the Document Type node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The Public ID
 ;;</returnValue>
 ;;</method>
 ;;<method id="getSystemId">
 ;;<call>
 ;;s systemId=$$getSystemId^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the System ID of a Document Type (DOCTYPE) element
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the Document Type node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The System ID
 ;;</returnValue>
 ;;</method>
 ;;<method id="getTagByNameAndAttr">
 ;;<call>
 ;;s nodeOID=$$getTagByNameAndAttr^%zewdDOM(tagName,attrName,attrValue,matchCase,docName)
 ;;</call>
 ;;<purpose>
 ;;Locates a node in the DOM that matches by tag name and a specified attribute value.  For example you
 ;;could use this method to locate an &lt;a&gt; tag with an href attribute with a value of "page1.ewd"
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="tagName" mandatory="true">
 ;;The tag name required
 ;;</parameter>
 ;;<parameter no="2" name="attrName" mandatory="true">
 ;;The name of the attribute required
 ;;</parameter>
 ;;<parameter no="3" name="attrValue" mandatory="true">
 ;;The value of the required attribute
 ;;</parameter>
 ;;<parameter no="4" name="matchCase">
 ;;If set to 1, then the matching by attribute value is case-sensitive.
 ;;Default value is 0 (case-insensitive value match)
 ;;</parameter>
 ;;<parameter no="5" name="docName" mandatory="true">
 ;;The Document Name of the DOM being searched
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The OID of the matching Element node.
 ;;</returnValue>
 ;;</method>
 ;;<method id="getTagName">
 ;;<call>
 ;;s tagName=$$getTagName^%zewdDOM(nodeOID)
 ;;</call>
 ;;<purpose>
 ;;Returns the Tag Name of the specified Element Node
 ;;</purpose>
 ;;<parameters>
 ;;<parameter no="1" name="nodeOID" mandatory="true">
 ;;The OID of the element node
 ;;</parameter>
 ;;</parameters>
 ;;<returnValue>
 ;;The Element's Tag Name
 ;;</returnValue>
 ;;</method>
 ;;***END***
