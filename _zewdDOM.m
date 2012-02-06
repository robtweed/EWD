%zewdDOM	; Enterprise Web Developer support functions
 ;
 ; Product: Enterprise Web Developer (Build 896)
 ; Build Date: Mon, 06 Feb 2012 17:28:14
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
openDOM(%validateOFF,%dontNest,%checkOver,%p1,%p2,%p3,%p4,%p5,%p6,%p7,%p8,%p9,%p10,%p11,%p12,%p13,%p14,%p15)
 QUIT ""
 ;
closeDOM()
 QUIT ""
 ;
newDocument(documentName)
 ;
 n docNo
 ;
 s documentName=$g(documentName)
 i documentName'="",$d(^zewdDOM("docNameIndex",documentName)) QUIT $$setError("A DOM named "_documentName_" already exists")
 l +^zewdDOM:5 e  QUIT $$setError("Unable to lock the DOM in order to allocate a new record")
 s docNo=$$getNextDOMNo()
 i documentName="" s documentName="eXtcDOM"_docNo
 s ^zewdDOM("dom",docNo,"docName")=documentName
 s ^zewdDOM("docNameIndex",documentName)=docNo
 s ^zewdDOM("dom",docNo,"node")=1
 s $p(^zewdDOM("dom",docNo,"node",1),"|",2)=9
 s ^zewdDOM("dom",docNo,"creationDate")=$h
 l -^zewdDOM
 QUIT docNo
 ;
getNextDOMNo()
 QUIT $o(^zewdDOM("dom",""),-1)+1
 ;
listDOMs(list)
 d getListOfDOMs(.list)
 QUIT
 ;
getListOfDOMs(list)
 ;
 n name
 ;
 k list
 s name=""
 f  s name=$o(^zewdDOM("docNameIndex",name)) q:name=""  d
 . s list(name)=""
 QUIT
 ;
clearDOMs
 ;
 n name,ok
 ;
 s name=""
 f  s name=$o(^zewdDOM("docNameIndex",name)) q:name=""  d
 . s ok=$$removeDocument(name)
 . w name,!
 QUIT
 ; 
clearDOMsByPrefix(prefix)
 n len,name
 ;
 s len=$l(prefix)
 s name=""
 f  s name=$o(^zewdDOM("docNameIndex",name)) q:name=""  d
 . i $e(name,1,len)=prefix s ok=$$removeDocument(name)
 QUIT
 ; 
removeDocument(documentName,%p1,%p2)
 ;
 n docNo,docOID
 ;
 i $g(documentName)="" QUIT $$setError("Document Name was not specified")
 i '$$documentNameExists(documentName) QUIT $$setError("No such DOM: "_documentName)
 ;
 s docNo=$g(^zewdDOM("docNameIndex",documentName))
 k ^zewdDOM("dom",docNo)
 k ^zewdDOM("docNameIndex",documentName)
 i $d(^zewdDOM("dom"))=1 k ^zewdDOM
 ;
 QUIT documentName
 ;
newXMLDocument(docName,outerTag,hasProcIns)
 ;
 n deOID,docNo,docOID,ok,procOID
 ;
 i $g(docName)="" QUIT $$setError("newXMLDocument: Document Name was not specified")
 s ok=$$removeDocument(docName,0,0)
 s docNo=$$newDocument(docName)
 s docOID=$$getOID(docNo,1)
 i $g(hasProcIns) d
 . s procOID=$$createProcessingInstruction("xml","version='1.0' encoding='UTF-8'",docOID)
 . s procOID=$$appendChild(procOID,docOID)
 i $g(outerTag)'="" d
 . s deOID=$$createElement(outerTag,docOID)
 . s deOID=$$appendChild(deOID,docOID) 
 QUIT docOID
 ;
createDocument(namespaceURI,qualifiedName,doctype,documentName,eXtcInfo)
 ;
 n docElementOID,docNo,docOID
 ;
 s docNo=$$newDocument(documentName)
 s docOID=$$getOID(docNo,1)
 i 'docNo QUIT docNo
 i $g(namespaceURI)="" d
 . i $g(qualifiedName)'="" d
 . . s docElementOID=$$createElement(qualifiedName,docOID)
 . . s docElementOID=$$appendChild(docElementOID,docOID)
 QUIT docOID
 ;
 ;
 ; ^zewdDOM("dom",docNo,"node",nodeNo)=nodeName|nodeType|parent|firstChild|lastChild|previousSibling|nextSibling
 ;
setNodeName(nodeOID,nodeName)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 ;i '$$nodeExists(nodeOID) QUIT $$setError("Node OID does not exist in the DOM")
 i $g(nodeName)="" QUIT $$setError("Node Name was not specified")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",1)=nodeName
 i $$getNodeType(nodeOID)=1 d
 . s ^zewdDOM("dom",docNo,"nodeNameIndex",nodeName,nodeNo)=""
 . i nodeName[":" s ^zewdDOM("dom",docNo,"localNameIndex",$p(nodeName,":",2),nodeNo)=""
 QUIT
 ;
getNodeName(nodeOID)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node OID does not exist in the DOM")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 QUIT $p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",1)
 ;
setNodeType(nodeOID,nodeType)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 ;i '$$nodeExists(nodeOID) QUIT $$setError("Node OID does not exist in the DOM")
 i $g(nodeType)="" QUIT $$setError("Node Type was not specified")
 i nodeType'?1N.N QUIT $$setError("Invalid Node Type")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 ;s ^zewdDOM("dom",docNo,"node",nodeNo,"nodeType")=nodeType
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",2)=nodeType
 s ^zewdDOM("dom",docNo,"nodeTypeIndex",nodeType,nodeNo)=""
 QUIT
 ;
getNodeType(nodeOID)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node OID does not exist in the DOM")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 QUIT $p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",2)
 ;
setParent(nodeOID,parentOID)
 ;
 n docNo,nodeNo,parentNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 i $g(parentOID)="" QUIT $$setError("Parent Node OID was not specified")
 i '$$nodeExists(parentOID) QUIT $$setError("Parent Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 i docNo'=$$getDocNo(parentOID) QUIT $$setError("Child node belongs to a different DOM from the parent node")
 s nodeNo=$$getNodeNo(nodeOID) 
 s parentNo=$$getNodeNo(parentOID)
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",3)=parentNo
 QUIT 1
 ;
getParentNode(nodeOID)
 ;
 n docNo,nodeNo,pn
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s pn=$p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",3)
 i pn="" QUIT ""
 QUIT $$getOID(docNo,pn)
 ;
setFirstChild(nodeOID,childOID)
 ;
 n docNo,nodeNo,childNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 i $g(childOID)="" QUIT $$setError("Child Node OID was not specified")
 i '$$nodeExists(childOID) QUIT $$setError("Child Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 i docNo'=$$getDocNo(childOID) QUIT $$setError("Child node belongs to a different DOM from the parent node")
 s nodeNo=$$getNodeNo(nodeOID) 
 s childNo=$$getNodeNo(childOID)
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",4)=childNo
 QUIT 1
 ;
getFirstChild(nodeOID)
 ;
 n docNo,fcNode,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 i nodeNo="" QUIT ""
 s fcNode=$p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",4)
 i fcNode="" QUIT ""
 QUIT $$getOID(docNo,fcNode)
 ;
setLastChild(nodeOID,childOID)
 ;
 n docNo,nodeNo,childNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 i $g(childOID)="" QUIT $$setError("Child Node OID was not specified")
 i '$$nodeExists(childOID) QUIT $$setError("Child Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 i docNo'=$$getDocNo(childOID) QUIT $$setError("Child node belongs to a different DOM from the parent node")
 s nodeNo=$$getNodeNo(nodeOID) 
 s childNo=$$getNodeNo(childOID)
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",5)=childNo
 QUIT 1
 ;
getLastChild(nodeOID)
 ;
 n docNo,lcNode,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID) 
 i nodeNo="" QUIT ""
 s lcNode=$p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",5)
 i lcNode="" QUIT ""
 QUIT $$getOID(docNo,lcNode)
 ;
setPreviousSibling(nodeOID,siblingOID)
 ;
 n docNo,nodeNo,siblingNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 i $g(siblingOID)="" QUIT $$setError("Sibling Node OID was not specified")
 i '$$nodeExists(siblingOID) QUIT $$setError("Sibling Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 i docNo'=$$getDocNo(siblingOID) QUIT $$setError("Child node belongs to a different DOM from the parent node")
 s nodeNo=$$getNodeNo(nodeOID) 
 s siblingNo=$$getNodeNo(siblingOID)
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",6)=siblingNo
 QUIT 1
 ;
getPreviousSibling(nodeOID)
 ;
 n docNo,nodeNo,siblingNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID) 
 s siblingNo=$p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",6)
 i siblingNo="" QUIT ""
 QUIT $$getOID(docNo,siblingNo)
 ;
setNextSibling(nodeOID,siblingOID)
 ;
 n docNo,nodeNo,siblingNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 i $g(siblingOID)="" QUIT $$setError("Sibling Node OID was not specified")
 i '$$nodeExists(siblingOID) QUIT $$setError("Sibling Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 i docNo'=$$getDocNo(siblingOID) QUIT $$setError("Child node belongs to a different DOM from the parent node")
 s nodeNo=$$getNodeNo(nodeOID) 
 s siblingNo=$$getNodeNo(siblingOID)
 s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",7)=siblingNo
 QUIT 1
 ;
getNextSibling(nodeOID)
 ;
 n docNo,nodeNo,siblingNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID) 
 s siblingNo=$p($g(^zewdDOM("dom",docNo,"node",nodeNo)),"|",7)
 i siblingNo="" QUIT ""
 QUIT $$getOID(docNo,siblingNo)
 ;
addElementToDOM(tagName,parentOID,dummy,attr,text,asFirstChild)
 ;
 n docNo,docOID,elOID,name,ok,textOID,value
 ;
 i $g(tagName)="" QUIT $$setError("tagName was not specified")
 i $g(parentOID)="" QUIT $$setError("parentOID was not specified")
 i '$$nodeExists(parentOID) QUIT $$setError("parentOID does not exist in the DOM")
 ;
 s asFirstChild=+$g(asFirstChild)
 s docNo=$$getDocNo(parentOID)
 s docOID=$$getOID(docNo,1)
 i 'asFirstChild d
 . s elOID=$$createElement(tagName,docOID)
 . s elOID=$$appendChild(elOID,parentOID)
 e  d
 . s elOID=$$insertNewFirstChildElement(parentOID,tagName,docOID)
 s name=""
 f  s name=$o(attr(name)) q:name=""  d
 . i name[$c(10) q
 . i name="/" q
 . s value=attr(name)
 . d setAttribute(name,value,elOID)
 i $g(text)'="" d
 . s textOID=$$createTextNode(text,docOID)
 . s textOID=$$appendChild(textOID,elOID)
 k attr
 QUIT elOID
 ;
addElementToDOMNS(namespaceURI,qualifiedName,parentOID,propertiesList,propertiesArray,text)
 ;
 n dummy
 ;
 QUIT $$addElementToDOM($g(qualifiedName),$g(parentOID),.dummy,.propertiesArray,$g(text))
 ;
addTextToElement(elementOID,text)
 ;
 n docOID,textOID
 ;
 s docOID=$p(elementOID,"-",1)_"-1"
 s textOID=$$createTextNode(text,docOID)
 s textOID=$$appendChild(textOID,elementOID)
 QUIT textOID
 ;
createDocumentType(qualifiedName,publicId,systemId,docOID)
 ;
 n docNo,error,nodeNo,nodeOID
 ;
 i $g(qualifiedName)="" QUIT $$setError("Qualified Name was not specified")
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 s nodeOID=$$createNode(qualifiedName,10,docOID)
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID) 
 s ^zewdDOM("dom",docNo,"node",nodeNo,"publicId")=$g(publicId)
 s ^zewdDOM("dom",docNo,"node",nodeNo,"systemId")=$g(systemId)
 QUIT nodeOID
 ;
getPublicId(nodeOID)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID) 
 QUIT $g(^zewdDOM("dom",docNo,"node",nodeNo,"publicId"))
 ;
getSystemId(nodeOID)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID) 
 QUIT $g(^zewdDOM("dom",docNo,"node",nodeNo,"systemId"))
 ;
createTextNode(data,docOID)
 ;
 n docNo,error,nodeNo,nodeOID
 ;
 s error="",nodeOID=""
 ;i $g(data)'="" d  i error'="" QUIT $$setError(error)
 d
 . s docNo=$$getDocNo(docOID)
 . i '$d(^zewdDOM("dom",docNo)) s error="The specified DOM ("_docOID_") does not exist" q
 . s nodeNo=$increment(^zewdDOM("dom",docNo,"node"))
 . s nodeOID=$$getOID(docNo,nodeNo)
 . d setNodeType(nodeOID,3)
 . d setTextData(data,nodeOID)
 QUIT nodeOID
 ;
createProcessingInstruction(target,data,docOID)
 ;
 n docNo,error,nodeNo,nodeOID
 ;
 i $g(target)="" QUIT $$setError("Target was not specified")
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 s error="",nodeOID=""
 i $g(data)'="" d  i error'="" QUIT $$setError(error)
 . s docNo=$$getDocNo(docOID)
 . i '$d(^zewdDOM("dom",docNo)) s error="The specified DOM ("_docOID_") does not exist" q
 . s nodeNo=$increment(^zewdDOM("dom",docNo,"node"))
 . s nodeOID=$$getOID(docNo,nodeNo)
 . d setNodeType(nodeOID,7)
 . s ^zewdDOM("dom",docNo,"node",nodeNo,"target")=target
 . s ^zewdDOM("dom",docNo,"node",nodeNo,"data")=data
 QUIT nodeOID
 ;
createComment(data,docOID)
 ;
 n docNo,error,nodeNo,nodeOID
 ;
 i $g(data)="" QUIT $$setError("Comment data was not specified")
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 s error="",nodeOID=""
 d  i error'="" QUIT $$setError(error)
 . s docNo=$$getDocNo(docOID)
 . i '$d(^zewdDOM("dom",docNo)) s error="The specified DOM ("_docOID_") does not exist" q
 . s nodeNo=$increment(^zewdDOM("dom",docNo,"node"))
 . s nodeOID=$$getOID(docNo,nodeNo)
 . d setNodeType(nodeOID,8)
 . s ^zewdDOM("dom",docNo,"node",nodeNo,"data")=data
 QUIT nodeOID
 ;
createCDATASection(data,docOID)
 ;
 n docNo,error,nodeNo,nodeOID
 ;
 i $g(data)="" QUIT $$setError("CDATA data was not specified")
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 s error="",nodeOID=""
 d  i error'="" QUIT $$setError(error)
 . s docNo=$$getDocNo(docOID)
 . i '$d(^zewdDOM("dom",docNo)) s error="The specified DOM ("_docOID_") does not exist" q
 . s nodeNo=$increment(^zewdDOM("dom",docNo,"node"))
 . s nodeOID=$$getOID(docNo,nodeNo)
 . d setNodeType(nodeOID,4)
 . d setTextData(data,nodeOID)
 QUIT nodeOID
 ;
createNode(nodeName,nodeType,docOID)
 ;
 n docNo,nodeNo,nodeOID
 ;
 i $g(nodeName)="" QUIT $$setError("NodeName was not specified")
 i $g(nodeType)="" QUIT $$setError("NodeType was not specified")
 i (nodeType<1)!(nodeType>10) QUIT $$setError("Invalid NodeType")
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 ;
 s docNo=$$getDocNo(docOID)
 i '$d(^zewdDOM("dom",docNo)) QUIT $$setError("The specified DOM ("_docOID_") does not exist")
 s nodeNo=$increment(^zewdDOM("dom",docNo,"node"))
 s nodeOID=$$getOID(docNo,nodeNo)
 d setNodeType(nodeOID,nodeType)
 d setNodeName(nodeOID,nodeName)
 QUIT $$getOID(docNo,nodeNo)
 ;
setTextData(data,nodeOID)
 ;
 n docNo,lineNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node OID does not exist in the DOM")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s lineNo=$o(^zewdDOM("dom",docNo,"node",nodeNo,"data",""),-1)+1
 s ^zewdDOM("dom",docNo,"node",nodeNo,"data",lineNo)=data
 QUIT
 ;
getTagName(nodeOID)
 QUIT $$getNodeName(nodeOID)
 ;
renameTag(tagName,nodeOID)
 ;
 n attrArray,attrName,attrValue,docOID,newOID,ok
 ;
 i $g(tagName)="" QUIT ""
 i $g(nodeOID)="" QUIT ""
 i nodeOID'["-" QUIT ""
 s docOID=$p(nodeOID,"-",1)_"-1"
 s newOID=$$insertNewIntermediateElement^%zewdDOM(nodeOID,tagName,docOID)
 s ok=$$getAttributes^%zewdCompiler(nodeOID,.attrArray)
 s attrName=""
 f  s attrName=$o(attrArray(attrName)) q:attrName=""  d
 . s attrValue=$$getAttribute(attrName,nodeOID)
 . d setAttribute(attrName,attrValue,newOID)
 d removeIntermediateNode^%zewdDOM(nodeOID)
 ;
 QUIT newOID
 ;
getPrefix(nodeOID)
 ;
 n nodeName
 ;
 s nodeName=$$getNodeName(nodeOID)
 i nodeName[":" QUIT $p(nodeName,":",1)
 QUIT ""
 ;
getLocalName(nodeOID)
 ;
 n nodeName
 ;
 s nodeName=$$getNodeName(nodeOID)
 i nodeName[":" QUIT $p(nodeName,":",2)
 QUIT nodeName
 ;
createElement(tagName,documentOID)
 ;
 n elementOID
 ;
 i $g(tagName)="" QUIT $$setError("tagName was not specified")
 i $g(documentOID)="" QUIT $$setError("Document OID was not specified")
 ;
 s elementOID=$$createNode(tagName,1,documentOID)
 QUIT elementOID
 ;
createElementNS(namespaceURI,qualifiedName,documentOID)
 QUIT $$createElement($g(qualifiedName),$g(documentOID))
 ;
getDocNo(nodeOID)
 QUIT $p(nodeOID,"-",1)
 ;
getNodeNo(nodeOID)
 QUIT $p(nodeOID,"-",2)
 ;
getOID(docNo,nodeNo)
 QUIT docNo_"-"_nodeNo
 ;
setError(text)
 QUIT "0~"_text
 ;
nodeExists(nodeOID)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 ;
 i docNo="" QUIT $$setError("invalid nodeOID: "_nodeOID)
 i '$d(^zewdDOM("dom",docNo)) QUIT $$setError("DOM does not exist")
 i '$d(^zewdDOM("dom",docNo,"node",nodeNo)) QUIT $$setError("Node does not exist")
 QUIT 1
 ;
documentNameExists(docName)
 ;
 i $g(docName)="" QUIT $$setError("Document Name was not specified") 
 QUIT $d(^zewdDOM("docNameIndex",docName))
 ;
getDocumentName(docOID)
 ;
 n docNo
 ;
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 s docNo=$$getDocNo(docOID)
 i docNo="" QUIT $$setError("Invalid Document OID")
 i docNo'?1N.N QUIT $$setError("Invalid Document OID")
 i '$d(^zewdDOM("dom",docNo)) QUIT $$setError("No DOM exists with the OID "_docOID)
 QUIT $g(^zewdDOM("dom",docNo,"docName"))
 ;
getDocumentNode(docName)
 ;
 n docNo,nodeNo
 ;
 i $g(docName)="" QUIT $$setError("Document Name was not specified")
 i '$$documentNameExists(docName) QUIT $$setError("No such DOM as "_docName)
 s docNo=$g(^zewdDOM("docNameIndex",docName))
 QUIT $$getOID(docNo,1)
 ;
getDocumentOID(docOID,docName)
	;
	; supply docOID or docName in param 1
	; if document exists, returns docOID as returnValue and
	; docName (called by reference)
	; if docOID or docName invalid, returns null
	;
	n error
	;
	i $g(docOID)="" QUIT ""
	s error="",docName=""
	i docOID'?1N.N1"-"1N.N d  i error="" QUIT docOID
	. s docName=docOID
	. s docOID=$$getDocumentNode^%zewdDOM(docName)
	. i $e(docOID,1)=0 s error=$p(docOID,"~",2)
	e  d  i error="" QUIT docOID
	. s docName=$$getDocumentName^%zewdDOM(docOID)
	. i $e(docName,1)=0 s error=$p(docName,"~",2)
	s docName=""
	QUIT ""
 ;
getDocumentElement(docOID)
 ;
 s docOID=$$getDocumentOID(docOID)
 QUIT $$getDocumentAttribute(docOID,"documentElement")
 ;
getDocumentAttribute(docOID,attributeName)
 ;
 n docNo,response
 ;
 i $g(docOID)="" QUIT $$setError("Document OID was not specified")
 i $g(attributeName)="" QUIT $$setError("Attribute name was not specified")
 s docNo=$$getDocNo(docOID)
 i docNo="" QUIT $$setError("Invalid Document OID")
 i docNo'?1N.N QUIT $$setError("Invalid Document OID") 
 ;
 i attributeName="documentElement" QUIT $$getOID(docNo,$g(^zewdDOM("dom",docNo,"documentElement")))
 i attributeName="documentName" QUIT $$getDocumentName(docOID)
 i attributeName="creationDate" d  QUIT response
 . s response=$g(^zewdDOM("dom",docNo,"creationDate"))
 . i response="" s response="Not Known" q
 . s response=$$inetDate^%zewdAPI($g(^zewdDOM("dom",docNo,"creationDate")))
 i attributeName="creationTime" d  QUIT response
 . s response=$g(^zewdDOM("dom",docNo,"creationDate"))
 . i response="" s response="Not Known" q
 . s response=$$inetTime^%zewdAPI($g(^zewdDOM("dom",docNo,"creationDate")))
 ;
 QUIT ""
 ;
appendChild(newChildOID,parentOID)
 ;
 n childNodeNo,docName,docNo,docOID,lastChildNo,lastChildOID
 n nodeType,parentNodeNo
 ;
 i $g(newChildOID)="" QUIT $$setError("New Child OID was not specified")
 i $g(parentOID)="" QUIT $$setError("Parent OID was not specified")
 i '$$nodeExists(newChildOID) QUIT $$setError("Child OID "_newChildOID_" does not exist in the DOM")
 i '$$nodeExists(parentOID) QUIT $$setError("Parent OID "_parentOID_" does not exist in the DOM")
 ;
 s docNo=$$getDocNo(newChildOID)
 i docNo'=$$getDocNo(parentOID) QUIT $$setError("Child node belongs to a different DOM from the parent node")
 s childNodeNo=$$getNodeNo(newChildOID)
 s parentNodeNo=$$getNodeNo(parentOID)
 s nodeType=$$getNodeType(newChildOID)
 ;
 i $$hasChildNodes(parentOID)="false" d
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",4)=childNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",5)=childNodeNo
 e  d
 . s lastChildOID=$$getLastChild(parentOID)
 . s lastChildNo=$$getNodeNo(lastChildOID)
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",5)=childNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",lastChildNo),"|",7)=childNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",childNodeNo),"|",6)=lastChildNo
 s $p(^zewdDOM("dom",docNo,"node",childNodeNo),"|",3)=parentNodeNo
 ;
 s docOID=$$getOID(docNo,1)
 s docName=$$getDocumentName(docOID)
 i nodeType=1,$g(^zewdDOM("dom",docNo,"documentElement"))="" s ^zewdDOM("dom",docNo,"documentElement")=childNodeNo QUIT newChildOID
 ;
 QUIT newChildOID
 ;
hasChildNodes(nodeOID)
 ;
 n fc
 ;
 s fc=$$getFirstChild(nodeOID)
 i $$getNodeNo(fc)="" QUIT "false"
 QUIT "true"
 ;
setAttribute(name,value,elementOID)
 ;
 n attrNodeNo,attrOID,docNo,docOID,nodeNo,oldValue,textNodeNo,textOID
 ;
 i $g(name)="" QUIT  ;$$setError("Attribute Name was not specified")
 ;i $g(value)="" QUIT $$setError("Attribute Value was not specified")
 i $g(elementOID)="" QUIT  ;$$setError("Element OID was not specified")
 ;
 i '$$nodeExists(elementOID) QUIT  ;$$setError("Element OID "_elementOID_" does not exist")
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 s docOID=$$getOID(docNo,1)
 s oldValue=$$getAttribute(name,elementOID)
 i oldValue'="" d removeAttribute(name,elementOID,1)
 s attrOID=$$createNode(name,2,docOID)
 s attrNodeNo=$$getNodeNo(attrOID)
 s ^zewdDOM("dom",docNo,"node",nodeNo,"attr",attrNodeNo)=""
 s ^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name)=attrNodeNo
 i name="id",value'="" s ^zewdDOM("dom",docNo,"idIndex",value)=nodeNo
 i name[":" s ^zewdDOM("dom",docNo,"node",nodeNo,"attrLocalNameIndex",$p(name,":",2))=attrNodeNo
 s $p(^zewdDOM("dom",docNo,"node",attrNodeNo),"|",3)=nodeNo
 s textOID=$$createTextNode(value,docOID)
 s textNodeNo=$$getNodeNo(textOID)
 s ^zewdDOM("dom",docNo,"node",attrNodeNo,"data")=textNodeNo
 s $p(^zewdDOM("dom",docNo,"node",textNodeNo),"|",3)=attrNodeNo
 QUIT
 ;
setAttributeNS(namespaceURI,qualifiedName,value,elementOID)
 ;
 s ok=$$setAttribute($g(qualifiedName),$g(value),$g(elementOID))
 i 'ok QUIT ok
 ;
hasAttribute(name,elementOID)
 ;
 n docNo,nodeNo
 ;
 i $g(name)="" QUIT $$setError("Attribute Name was not specified")
 i $g(elementOID)="" QUIT $$setError("Element OID was not specified")
 ;
 i '$$nodeExists(elementOID) QUIT $$setError("Element OID "_elementOID_" does not exist")
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 i $d(^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name)) QUIT "true"
 QUIT "false"
 ;
hasAttributes(elementOID)
 ;
 n docNo,nodeNo
 ;
 i $g(elementOID)="" QUIT "false"
 i '$$nodeExists(elementOID) QUIT "false"
 ;
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID) 
 i $d(^zewdDOM("dom",docNo,"node",nodeNo,"attr")) QUIT "true"
 QUIT "false"
 ;
getAttributeArray(elementOID,attrArray)
 QUIT $$getAttributes^%zewdCompiler($g(elementOID),.attrArray)
 ;
getAttributeValues(elementOID,attrs)
 ;
 n attrArray,attrName,ok
 ;
 k attrs
 s ok=$$getAttributes^%zewdCompiler($g(elementOID),.attrArray)
 s attrName=""
 f  s attrName=$o(attrArray(attrName)) q:attrName=""  d
 . s attrs(attrName)=$$getValue(attrArray(attrName))
 QUIT
 ;
getAttributes(elementOID,attrArray)
 ;
 n attrName,attrNo,docNo,fixedArray,nodeNo,value
 ;
 s fixedArray=0
 i '$d(attrArray) s fixedArray=1
 k attrArray
 i $g(elementOID)="" QUIT $$setError("Element OID was not specified")
 i '$$nodeExists(elementOID) QUIT $$setError("Element OID "_elementOID_" does not exist")
 ;
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 ;
 s attrName=""
 f  s attrName=$o(^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",attrName)) q:attrName=""  d
 . s value=$$getAttributeValue(attrName,,elementOID)
 . s attrNo=^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",attrName)
 . s attrArray($$getOID(docNo,attrNo))=attrName_$c(1)_value
 i fixedArray k attr m attr=attrArray QUIT "1~attr"
 QUIT "1"
 ;
attributeExists(name,elementOID)
 ;
 n docNo,nodeNo
 ;
 i $g(elementOID)="" QUIT $$setError("Element OID was not specified")
 i $g(name)="" QUIT $$setError("Attribute name was not specified")
 i '$$nodeExists(elementOID) QUIT $$setError("Element OID "_elementOID_" does not exist")
 ;
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 i $g(^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name))="" QUIT 0
 QUIT 1
 ;
getAttribute(name,elementOID)
 QUIT $$getAttributeValue($g(name),1,$g(elementOID))
 ;
getAttrAttribute(attrOID,attributeName)
 ;
 i $g(attrOID)="" QUIT $$setError("Attribute OID was not specified")
 i '$$nodeExists(attrOID) QUIT $$setError("Attribute OID "_attrOID_" does not exist")
 i $g(attributeName)="" QUIT $$setError("Attribute Name was not specified") 
 i attributeName="value" QUIT $$getValue(attrOID)
 i attributeName="name" QUIT $$getNodeName(attrOID)
 i attributeName="ownerElement" QUIT $$getParentNode(attrOID)
 QUIT ""
 ;
getAttributeNS(namespaceURI,localName,elementOID)
 ;
 n attrNodeNo,docNo,nodeNo,textNodeNo
 ;
 i $g(localName)="" QUIT $$setError("Attribute Local Name was not specified")
 i $g(elementOID)="" QUIT $$setError("Element OID was not specified")
 i '$$nodeExists(elementOID) QUIT $$setError("Element OID "_elementOID_" does not exist")
 ;
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 s attrNodeNo=$g(^zewdDOM("dom",docNo,"node",nodeNo,"attrLocalNameIndex",localName))
 i attrNodeNo="" QUIT ""
 s textNodeNo=$g(^zewdDOM("dom",docNo,"node",attrNodeNo,"data"))
 i textNodeNo="" QUIT ""
 QUIT $g(^zewdDOM("dom",docNo,"node",textNodeNo,"data",1))
 ;
getValue(attrOID)
 ;
 n docNo,nodeNo,textNodeNo
 ;
 i $g(attrOID)="" QUIT $$setError("Attribute OID was not specified")
 i '$$nodeExists(attrOID) QUIT $$setError("Attribute OID "_attrOID_" does not exist")
 s docNo=$$getDocNo(attrOID)
 s nodeNo=$$getNodeNo(attrOID) 
 s textNodeNo=$g(^zewdDOM("dom",docNo,"node",nodeNo,"data"))
 i textNodeNo="" QUIT ""
 QUIT $g(^zewdDOM("dom",docNo,"node",textNodeNo,"data",1))
 ;
getAttributeDataNode(attrOID)
 ;
 n docNo,nodeNo,textNodeNo
 ;
 i $g(attrOID)="" QUIT $$setError("Attribute OID was not specified")
 i '$$nodeExists(attrOID) QUIT $$setError("Attribute OID "_attrOID_" does not exist")
 s docNo=$$getDocNo(attrOID)
 s nodeNo=$$getNodeNo(attrOID) 
 s textNodeNo=$g(^zewdDOM("dom",docNo,"node",nodeNo,"data"))
 i textNodeNo="" QUIT ""
 QUIT $$getOID(docNo,textNodeNo)
 ;
getAttributeValue(name,escaped,elementOID)
 ;
 n attrNodeNo,docNo,nodeNo,textNodeNo
 ;
 i $g(name)="" QUIT $$setError("Attribute Name was not specified")
 i $g(elementOID)="" QUIT $$setError("Element OID was not specified")
 i '$$nodeExists(elementOID) QUIT $$setError("Element OID "_elementOID_" does not exist")
 ;
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 i '$$attributeExists(name,elementOID) QUIT ""
 s attrNodeNo=$g(^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name))
 s textNodeNo=$g(^zewdDOM("dom",docNo,"node",attrNodeNo,"data"))
 i textNodeNo="" QUIT ""
 QUIT $g(^zewdDOM("dom",docNo,"node",textNodeNo,"data",1))
 ;
getName(attrOID)
 QUIT $$getTagName(attrOID)
 ;
getData(nodeOID,textArray)
 ;
 n docNo,lineNo,nodeNo,nodeType,text
 ;
 k textArray
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s nodeType=$$getNodeType(nodeOID)
 i nodeType=7!(nodeType=8) QUIT $g(^zewdDOM("dom",docNo,"node",nodeNo,"data"))
 i nodeType'=3,nodeType'=4 QUIT $$setError("Node "_nodeOID_" does not support this method")
 s text=$g(^zewdDOM("dom",docNo,"node",nodeNo,"data",1))
 s lineNo=""
 f  s lineNo=$o(^zewdDOM("dom",docNo,"node",nodeNo,"data",lineNo)) q:lineNo=""  d
 . s textArray(lineNo)=^zewdDOM("dom",docNo,"node",nodeNo,"data",lineNo)
 QUIT text
 ;
getTarget(nodeOID)
 ;
 n docNo,nodeNo
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 i $$getNodeType(nodeOID)'=7 QUIT $$setError("Node OID is not a processing instruction")
 QUIT $g(^zewdDOM("dom",docNo,"node",nodeNo,"target"))
 ;
displayDOM(docOID,escape,format)
 n ok
 s ok=$$outputDOM($g(docOID),$g(escape),$g(format))
 QUIT
 ;
outputDOM(docOID,escape,format,outputLocation,msgLength,outputRef,finalCRLF,showInfo)
 ;
 n dev,gloName,io,ok,returnValue,toGlobal
 ;
 ;d trace^%zewdAPI("in outputDOM: docOID="_docOID)
 s io=$io
 i $g(escape)="" s escape=1
 i $g(format)="" s format=2
 s outputLocation=$g(outputLocation)
 s outputRef=$g(outputRef)
 ;i docOID'["-" s docOID=$$getDocumentNode(docOID) i 'docOID QUIT docOID
 i outputLocation="file",outputRef="" QUIT 0
 i outputLocation="array",outputRef="" QUIT 0
 i outputLocation=79,outputRef="" QUIT 0
 s toGlobal=0
 i outputLocation=79!(outputLocation="array") d
 . s toGlobal=1
 . s gloName=outputRef
 . s outputLocation="file"
 . s outputRef="zewdTempDOM.txt"
 i outputLocation="file" d
 . s dev=outputRef
 . i '$$openNewFile^%zewdCompiler(dev) q
 . u dev
 . ;o dev:"nw" u dev
 i docOID'["-" d
 . s docOID=$$getDocumentNode(docOID) i 'docOID QUIT
 . s docOID=$p(docOID,"-",1)_"-1"
 i 'docOID QUIT docOID
 i +escape=11 d
 . i $zv'["GT.M" d
 . . w "var "_$e(escape,4,$l(escape))_"='&lt;?xml version=""1.0"" encoding=""UTF-8""?>';"
 . e  d
 . . w "var "_$e(escape,4,$l(escape))_"='';"
 s returnValue=$$outputNode(docOID,"",escape,format)
 i outputLocation="file" c dev u io
 i 'toGlobal QUIT returnValue
 n line,lines,no
 o outputRef:(readonly)
 u outputRef:exception="g eGDIP"
 s no=0
 f  r line i line'="" s line=$tr(line,$c(13)),no=no+1,lines(no)=line
eGDIP 
 c outputRef
 u io
 m @gloName=lines
 QUIT returnValue
 ;
outputNode(nodeOID,indent,escape,format)
 ;
 n displayIndent,endWithCR,lt,nodeType,returnValue,suppressIndent,var
 ;
 s returnValue=""
 s lt="<",var="xml"
 i +escape=11 d
 . s lt="&lt;"
 . s var=$e(escape,4,$l(escape))
 i nodeOID="" QUIT ""
 i format=0 s suppressIndent=1,endWithCR=0
 i format=1 s suppressIndent=1,endWithCR=1
 i format=2 s suppressIndent=0,endWithCR=1
 s displayIndent=indent i suppressIndent s displayIndent=""
 s nodeType=$$getNodeType(nodeOID)
 i nodeType=9 d  Q ""
 . n lastTag
 . s lastTag=$$outputChildren(nodeOID,indent,escape,format)
 ;
 i nodeType=1 d  Q returnValue
 . n firstChildOID,firstChildTagName,lastTag,nextIndent,tagName
 . s tagName=$$getTagName(nodeOID)
 . i +escape=11 w var_"="_var_"+'"
 . w displayIndent_lt_tagName
 . i $$hasAttributes(nodeOID)="true" d outputAttr(nodeOID)
 . i $$hasChildNodes(nodeOID)="false" w " /"
 . w ">"
 . i +escape=11 w "';"
 . i endWithCR d lf
 . i $$hasChildNodes(nodeOID)="false" q
 . s nextIndent=indent_"   "
 . s lastTag=$$outputChildren(nodeOID,nextIndent,escape,format)
 . i +escape=11 w var_"="_var_"+'"
 . w displayIndent_lt_"/"_tagName_">"
 . i +escape=11 w "';"
 . i endWithCR d lf
 ;
 i nodeType=3 d  QUIT returnValue
 . n lineNo,text,textArray
 . s text=$$getData(nodeOID,.textArray)
 . i $d(textArray) w displayIndent
 . s lineNo=""
 . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . i +escape=11 w var_"="_var_"+'"
 . . s text=textArray(lineNo)
 . . i +escape=11 d
 . . . s text=$$replaceAll^%zewdAPI(text,"\","\\")
 . . . s text=$$replaceAll^%zewdAPI(text,"'","\'")
 . . . s text=$$replaceAll^%zewdAPI(text,$c(9),"\t")
 . . . s text=$$replaceAll^%zewdAPI(text,$c(10),"\n")
 . . . s text=$$replaceAll^%zewdAPI(text,$c(13),"\r")
 . . . s text=$$replaceAll^%zewdAPI(text,"&amp;","&amp;amp;") ;DLW
 . . . s text=$$replaceAll^%zewdAPI(text,"&lt;","&amp;lt;") ;DLW
 . . . s text=$$replaceAll^%zewdAPI(text,"&gt;","&amp;gt;") ;DLW
 . . . s text=$$replaceAll^%zewdAPI(text,"&quot;","&amp;quot;")
 . . . s text=$$replaceAll^%zewdAPI(text,"&apos;","&amp;apos;")
 . . w text
 . . i +escape=11 w "';"
 . i endWithCR d
 . . i +escape=11 w "\r\n" q
 . . d lf
 ;
 i nodeType=4 d  QUIT returnValue
 . n lineNo,text,textArray
 . s text=$$getData(nodeOID,.textArray)
 . ;w "<![CDATA["_data_"]]>"
 . i +escape=11 w var_"="_var_"+'"
 . w lt_"![CDATA["
 . s lineNo=""
 . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . w textArray(lineNo)
 . w "]]>"
 . i +escape=11 w "';"
 . i endWithCR d lf 
 ;
 i nodeType=7 d  QUIT returnValue
 . n target,data
 . i +escape=11 w var_"="_var_"+'"
 . w displayIndent_lt_"?"
 . s target=$$getTarget(nodeOID)
 . s data=$$getData(nodeOID)
 . w target
 . i data'="" w " "_data
 . w "?>"
 . i +escape=11 w "';"
 . i endWithCR d lf 
 ;
 i nodeType=8 d  QUIT returnValue
 . n data
 . i +escape=11 q
 . s data=$$getData(nodeOID)
 . i +escape=11 w var_"="_var_"+'"
 . w lt_"!-- "_data_" -->"
 . i +escape=11 w "';"
 . i endWithCR d lf 
 ;
 i nodeType=10 d  QUIT returnValue
 . n publicId,systemId,qualifiedName
 . s qualifiedName=$$getTagName(nodeOID)
 . s publicId=$$getPublicId(nodeOID)
 . s systemId=$$getSystemId(nodeOID)
 . i +escape=11 w var_"="_var_"+'"
 . w lt_"!DOCTYPE "_qualifiedName
 . i systemId'="",publicId="" w " SYSTEM """_systemId_""""
 . i publicId'="" d
 . . w " PUBLIC """_publicId_""""
 . . i systemId'="" w " """_systemId_""""
 . w ">"
 . i +escape=11 w "';"
 . i endWithCR d lf 
 ;
 QUIT ""
 ;
outputChildren(parentOID,indent,escape,format)
 ;
 n childOID,siblingOID,returnValue,returnValue1
 ;
 s childOID=$$getFirstChild(parentOID)
 i childOID="" QUIT ""
 s returnValue=$$outputNode(childOID,indent,escape,format)
 s siblingOID=childOID
 f  s siblingOID=$$getNextSibling(siblingOID) q:siblingOID=""  d
 . s returnValue1=$$outputNode(siblingOID,indent,escape,format)
 Q returnValue
 ;
outputAttr(nodeOID)
 ;
 n attr,attrArray,attrOID,d,docNo,name,nodeNo,value
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s ok=$$getAttributes(nodeOID,.attrArray)
 s attrOID=""
 f  s attrOID=$o(attrArray(attrOID)) q:attrOID=""  d
 . s d=attrArray(attrOID)
 . s value=$p(d,$c(1),2)
 . i +escape=11 d
 . . s value=$$replaceAll^%zewdAPI(value,"\","\\")
 . . s value=$$replaceAll^%zewdAPI(value,"'","\'")
 . . i value["&lt;" s value=$$replaceAll^%zewdAPI(value,"&lt;","&amp;lt;")
 . . i value["&gt;" s value=$$replaceAll^%zewdAPI(value,"&gt;","&amp;gt;")
 . . s value=$$replaceAll^%zewdAPI(value,"<","&amp;lt;")
 . . s value=$$replaceAll^%zewdAPI(value,">","&amp;gt;")
 . . s value=$$replaceAll^%zewdAPI(value,"""","&amp;quot;")
 . . i value["&quot;" s value=$$replaceAll^%zewdAPI(value,"&quot;","&amp;quot;")
 . . i value["&apos;" s value=$$replaceAll^%zewdAPI(value,"&apos;","&amp;apos;")
 . w " "_$p(d,$c(1),1)_"="""_value_""""
 QUIT
 ;
getElementText(nodeOID,textarr)
 ;
 n text,textArray
 ;
 k textarr
 s text=$$getElementValueByOID(nodeOID,"textArray")
 m textarr=textArray
 QUIT text
 ;
modifyElementText(nodeOID,text)
 n textOID
 s textOID=$$getFirstChild^%zewdDOM(nodeOID)
 s textOID=$$modifyTextData^%zewdDOM(text,textOID)
 QUIT textOID
 ;
getElementValueByOID(nodeOID,arrayRef,escAction)
 ;
 n childOID,docNo,lineNo,longText,nodeNo,nodeType,stop,text
 ;
 k @arrayRef
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified")
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 i $$hasChildNodes(nodeOID)="false" QUIT ""
 s childOID="",text="",lineNo=0
 f  s childOID=$$getNextChild(nodeOID,childOID) q:childOID=""  d
 . s nodeType=$$getNodeType(childOID)
 . q:nodeType'=3
 . s text=$$getData(childOID,.longText)
 . i $d(longText) d
 . . n n
 . . s n=""
 . . f  s n=$o(longText(n)) q:n=""  d
 . . . s lineNo=lineNo+1
 . . . s textArray(lineNo)=longText(n)
 . e  d
 . . s lineNo=lineNo+1
 . . s textArray(lineNo)=text
 i $d(textArray(2)) d
 . s text="***Array***"
 . i arrayRef'="textArray" m @arrayRef=textArray k textArray
 QUIT text
 ;
getChildTextNodes(parentOID,OIDArray)
 ;
 n childOID
 ;
 k OIDArray
 s childOID=""
 f  s childOID=$$getNextChild(parentOID,childOID) q:childOID=""  d
 . i $$getNodeType(childOID)=3 s OIDArray(childOID)=""
 QUIT
 ;
removeChildTextNodes(parentOID)
 ;
 n nodeOID,OIDArray,ok
 ;
 d getChildTextNodes(parentOID,.OIDArray)
 s nodeOID=""
 f  s nodeOID=$o(OIDArray(nodeOID)) q:nodeOID=""  d
 . s ok=$$removeChild(nodeOID,1)
 QUIT
 ;
getNextChild(parentOID,childOID)
 ;
 i $g(parentOID)="" QUIT $$setError("Parent OID was not specified") 
 i '$$nodeExists(parentOID) QUIT $$setError("Parent Node "_parentOID_" does not exist")
 i $g(childOID)="" QUIT $$getFirstChild(parentOID)
 QUIT $$getNextSibling(childOID)
 ;
getNamedNodeMapAttribute(nnmOID,attrName)
 ;
 n array,arrayRef,length
 ;
 i $g(nnmOID)="" QUIT $$setError("Named Node Map identifier was not specified")
 i $g(attrName)="" QUIT $$setError("Attribute name was not specified")
 s arrayRef=$p(nnmOID,"~",2)
 i arrayRef="attr" QUIT 0
 m array=@arrayRef
 s length=0
 i attrName="length" d  QUIT length
 . s attrOID="",length=0
 . f  s attrOID=$o(array(attrOID)) q:attrOID=""  s length=length+1
 QUIT ""
 ;
getNodeListAttribute(nlOID,attrName)
 ;
 n array,arrayRef,length
 ;
 i $g(nlOID)="" QUIT $$setError("Named Node Map identifier was not specified")
 i $g(attrName)="" QUIT $$setError("Attribute name was not specified")
 s arrayRef=$p(nlOID,"~",2)
 i arrayRef="OIDArray" QUIT 0
 m array=@arrayRef
 s length=0
 i attrName="length" d  QUIT length
 . s attrOID="",length=0
 . f  s attrOID=$o(array(attrOID)) q:attrOID=""  s length=length+1
 QUIT ""
 ;
modifyTextData(newText,nodeOID)
 ;
 n docNo,nodeNo,nodeType
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s nodeType=$$getNodeType(nodeOID)
 i nodeType'=3 QUIT $$setError("Node "_nodeOID_" is not a text node")
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s ^zewdDOM("dom",docNo,"node",nodeNo,"data",1)=newText
 QUIT nodeOID
 ;
getChildNodes(elementOID,nodeArray)
 ;
 n childOID,fixedArray
 ;
 s fixedArray=0
 i '$d(nodeArray) s fixedArray=1
 k nodeArray
 i $g(elementOID)="" QUIT $$setError("Element OID was not specified")
 i '$$nodeExists(elementOID) QUIT $$setError("Element OID "_elementOID_" does not exist")
 ;
 s childOID=""
 f  s childOID=$$getNextChild(elementOID,childOID) q:childOID=""  d
 . s nodeArray(childOID)=""
 i fixedArray k childArray m children=nodeArray k nodeArray QUIT "1~childArray"
 QUIT "1"
 ;
getChildElementsArrayByTagName(tagName,documentName,nodeOID,elementsArray)
 ;
 n childArray,childOID,children,nodeArray
 ;
 k elementsArray
 i $g(tagName)="" QUIT $$setError("Tag Name was not specified")
 i $g(documentName)="",$g(nodeOID)="" QUIT ""
 i $g(nodeOID)="" s nodeOID=$$getDocumentNode(documentName)
 s ok=$$getChildNodes(nodeOID)
 s childOID=""
 f  s childOID=$o(children(childOID)) q:childOID=""  d
 . i tagName=$$getTagName(childOID) s elementsArray(childOID)=""
 QUIT 1
 ;
getChildElementsArrayByTagNameNS(namespaceURI,localName,documentName,nodeOID,elementsArray)
 ;
 n childArray,childOID,nodeArray
 ;
 k elementsArray
 i $g(localName)="" QUIT $$setError("Local Name was not specified")
 i $g(documentName)="",$g(nodeOID)="" QUIT ""
 i $g(nodeOID)="" s nodeOID=$$getDocumentNode(documentName)
 s ok=$$getChildNodes(nodeOID,.nodeArray)
 s childOID=""
 f  s childOID=$o(nodeArray(childOID)) q:childOID=""  d
 . i localName=$$getLocalName(childOID) s elementsArray(childOID)=""
 QUIT 1
 ;
removeChild(nodeOID,deleteFromDOM)
 ;
 n docNo,nextSiblingNodeNo,nextSiblingOID,nodeNo,OIDArray
 n parentNodeNo,parentOID,previousSiblingNodeNo,previousSiblingOID
 ;
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 ;
 s docNo=$$getDocNo(nodeOID)
 s nodeNo=$$getNodeNo(nodeOID)
 s parentOID=$$getParentNode(nodeOID)
 s parentNodeNo=$$getNodeNo(parentOID)
 s previousSiblingOID=$$getPreviousSibling(nodeOID)
 s previousSiblingNodeNo=$$getNodeNo(previousSiblingOID)
 s nextSiblingOID=$$getNextSibling(nodeOID)
 s nextSiblingNodeNo=$$getNodeNo(nextSiblingOID)
 ;
 i previousSiblingOID="",nextSiblingOID="" d
 . ; node being removed was the only child
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",4)=""
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",5)="" 
 ;
 i previousSiblingOID="",nextSiblingOID'="" d 
 . ; node being removed was the first child
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",4)=nextSiblingNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",nextSiblingNodeNo),"|",6)=""
 i previousSiblingOID'="",nextSiblingOID="" d 
 . ; node being removed was the last child
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",5)=previousSiblingNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",previousSiblingNodeNo),"|",7)=""
 i previousSiblingOID'="",nextSiblingOID'="" d 
 . ; node being removed was a middle sibling
 . s $p(^zewdDOM("dom",docNo,"node",previousSiblingNodeNo),"|",7)=nextSiblingNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",nextSiblingNodeNo),"|",6)=previousSiblingNodeNo
 . 
 i $g(deleteFromDOM) d
 . d deleteFromDOM(nodeOID)
 e  d
 . s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",7)=""
 . s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",6)=""
 . s $p(^zewdDOM("dom",docNo,"node",nodeNo),"|",3)="" 
 QUIT nodeOID
 ;
deleteFromDOM(nodeOID)
 ;
 n dNodeNo,dOID,nodeType,OIDArray,tagName
 ;
 d getDescendantNodes(nodeOID,.OIDArray)
 s OIDArray(nodeOID)=""
 s dOID=""
 f  s dOID=$o(OIDArray(dOID)) q:dOID=""  d
 . s tagName=$$getTagName(dOID)
 . s nodeType=$$getNodeType(dOID)
 . s dNodeNo=$$getNodeNo(dOID)
 . k ^zewdDOM("dom",docNo,"node",dNodeNo)
 . i tagName'="" k ^zewdDOM("dom",docNo,"nodeNameIndex",tagName,dNodeNo)
 . i nodeType'="" k ^zewdDOM("dom",docNo,"nodeTypeIndex",nodeType,dNodeNo)
 QUIT
 ;
removeAttribute(name,elementOID,deleteFromDOM)
 ;
 n attrNodeNo,attrOID,docNo,nodeNo,value
 ;
 i $g(elementOID)="" QUIT  ;$$setError("Node OID was not specified") 
 i '$$nodeExists(elementOID) QUIT  ;$$setError("Node "_elementOID_" does not exist")
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 i $$getAttributeNode(name,elementOID)="" QUIT
 s value=$$getAttribute(name,elementOID)
 s attrNodeNo=$g(^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name))
 s attrOID=$$getOID(docNo,attrNodeNo)
 k ^zewdDOM("dom",docNo,"node",nodeNo,"attr",attrNodeNo)
 k ^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name)
 i name="id",value'="" k ^zewdDOM("dom",docNo,"idIndex",value)
 i name[":" k ^zewdDOM("dom",docNo,"node",nodeNo,"attrLocalNameIndex",$p(name,":",2))
 ;
 i $g(deleteFromDOM) d
 . d deleteFromDOM(attrOID)
 e  d
 . s $p(^zewdDOM("dom",docNo,"node",attrNodeNo),"|",3)=""  
 QUIT
 ;
removeAttributeNS(namespaceURI,localName,elementOID,deleteNode)
 ;
 d removeAttribute($g(localName),$g(elementOID),$g(deleteNode))
 QUIT
 ;
getAttributeNode(name,elementOID)
 ;
 n attrNodeNo,attrOID,docNo,nodeNo
 ;
 i $g(name)="" QUIT $$setError("Attribute name was not specified") 
 i $g(elementOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(elementOID) QUIT $$setError("Node "_elementOID_" does not exist")
 s docNo=$$getDocNo(elementOID)
 s nodeNo=$$getNodeNo(elementOID)
 s attrNodeNo=$g(^zewdDOM("dom",docNo,"node",nodeNo,"attrNameIndex",name))
 i attrNodeNo="" QUIT ""
 QUIT $$getOID(docNo,attrNodeNo)
 ;
getDescendantNodes(nodeOID,OIDArray)
 ;
 n ok
 ;
 k OIDArray
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s ok=$$getDescendants(nodeOID,.OIDArray)
 QUIT
 ;
getDescendants(nodeOID,OIDArray)
 ;
 n childOID,ok,tagName
 ;
 s childOID=""
 f  s childOID=$$getNextChild(nodeOID,childOID) q:childOID=""  d
 . s tagName=$$getTagName(childOID)
 . s OIDArray(childOID)=tagName
 . s ok=$$getDescendants(childOID,.OIDArray)
 QUIT 1
 ;
getElementsArrayByTagName(tagName,docName,nodeOID,nodeArray)
 ;
 n docOID,OIDArray,ok
 ;
 k nodeArray
 i $g(tagName)="" QUIT $$setError("Tag Name was not specified") 
 i $g(nodeOID)="",$g(docName)="" QUIT $$setError("Document Name was not specified") 
 s docOID=""
 i $g(docName)'="" s docOID=$$getDocumentNode(docName)
 i $e(docOID,1)=0 QUIT docOID
 i $g(nodeOID)="" s nodeOID=docOID
 QUIT $$getElementsByTagName(tagName,nodeOID,.nodeArray)
 ;
getElementsArrayByTagNameNS(namespaceURI,localName,docName,nodeOID,nodeArray)
 ;
 n docOID,OIDArray,ok
 ;
 k nodeArray
 i $g(localName)="" QUIT $$setError("Local Name was not specified") 
 i $g(nodeOID)="",$g(docName)="" QUIT $$setError("Document Name was not specified") 
 s docOID=""
 i $g(nodeOID)="" s docOID=$$getDocumentNode(docName)
 i $e(docOID,1)=0 QUIT docOID
 i $g(nodeOID)="" s nodeOID=docOID
 QUIT $$getElementsByTagNameNS($g(namespaceURI),localName,nodeOID,.nodeArray)
 ;
getElementsByTagNameNS(namespace,localName,nodeOID,nodeArray)
 ;
 n docNo,fixedArray,nodeNo,parentOID,stop,tagOID
 ;
 i $g(localName)="" QUIT $$setError("Local Name was not specified") 
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s fixedArray=0
 i '$d(nodeArray) s fixedArray=1
 k nodeArray
 s nodeNo=""
 s docNo=$$getDocNo(nodeOID)
 f  s nodeNo=$o(^zewdDOM("dom",docNo,"localNameIndex",localName,nodeNo)) q:nodeNo=""  d
 . s tagOID=$$getOID(docNo,nodeNo)
 . i tagOID=nodeOID s nodeArray(tagOID)="" q
 . i $g(nodeOID)="" d
 . . s nodeArray(tagOID)=""
 . e  d
 . . s stop=0,parentOID=tagOID
 . . f  d  q:stop
 . . . s parentOID=$$getParentNode(parentOID)
 . . . i parentOID="" s stop=1 q
 . . . i parentOID=nodeOID d  q
 . . . . s stop=1
 . . . . s nodeArray(tagOID)=""
 . . . i parentOID=$$getOID(docNo,1) s stop=1
 k OIDArray m OIDArray=nodeArray QUIT "1~OIDArray"
 QUIT "1"
 ;
getElementById(id,docOID)
 ;
 n docNo,nodeNo
 ;
 i $g(id)="" QUIT ""
 i $g(docOID)="" QUIT ""
 s docNo=$$getDocNo(docOID)
 i docNo="" QUIT ""
 s docNo=$$getDocNo(docOID)
 i '$d(^zewdDOM("dom",docNo)) QUIT ""
 s nodeNo=$g(^zewdDOM("dom",docNo,"idIndex",id))
 i nodeNo="" QUIT ""
 QUIT $$getOID(docNo,nodeNo)
 ;
getElementsByTagName(tagName,nodeOID,nodeArray)
 ;
 n docNo,fixedArray,nodeNo,parentOID,stop,tagOID
 ;
 i $g(tagName)="" QUIT $$setError("Tag Name was not specified") 
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 s fixedArray=0
 i '$d(nodeArray) s fixedArray=1
 k nodeArray
 s nodeNo=""
 s docNo=$$getDocNo(nodeOID)
 f  s nodeNo=$o(^zewdDOM("dom",docNo,"nodeNameIndex",tagName,nodeNo)) q:nodeNo=""  d
 . s tagOID=$$getOID(docNo,nodeNo)
 . i $g(nodeOID)="" d
 . . s nodeArray(tagOID)=""
 . e  d
 . . s stop=0,parentOID=tagOID
 . . f  d  q:stop
 . . . s parentOID=$$getParentNode(parentOID)
 . . . i parentOID="" s stop=1 q
 . . . i parentOID=nodeOID d  q
 . . . . s stop=1
 . . . . s nodeArray(tagOID)=""
 . . . i parentOID=$$getOID(docNo,1) s stop=1
 k OIDArray m OIDArray=nodeArray QUIT "1~OIDArray"
 QUIT "1"
 ;
insertBefore(newOID,targetOID)
 ;
 n docNo,newNodeNo,nodeNo,parentNodeNo,parentOID
 n previousSiblingNodeNo,previousSiblingOID,targetNodeNo
 ;
 i $g(newOID)="" QUIT $$setError("New Node OID was not specified")
 i '$$nodeExists(newOID) QUIT $$setError("New Node "_newOID_" does not exist")
 i $g(targetOID)="" QUIT $$setError("Target Node OID was not specified")
 i '$$nodeExists(targetOID) QUIT $$setError("Target Node "_targetOID_" does not exist")
 s docNo=$$getDocNo(newOID)
 s newNodeNo=$$getNodeNo(newOID)
 i docNo'=$$getDocNo(targetOID) QUIT $$setError("New node belongs to a different DOM from the target node")
 s targetNodeNo=$$getNodeNo(targetOID)
 s parentOID=$$getParentNode(targetOID)
 s parentNodeNo=$$getNodeNo(parentOID)
 ;
 s previousSiblingOID=$$getPreviousSibling(targetOID)
 i previousSiblingOID="" d
 . s $p(^zewdDOM("dom",docNo,"node",parentNodeNo),"|",4)=newNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",newNodeNo),"|",7)=targetNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",targetNodeNo),"|",6)=newNodeNo
 e  d
 . s previousSiblingNodeNo=$$getNodeNo(previousSiblingOID)
 . s $p(^zewdDOM("dom",docNo,"node",previousSiblingNodeNo),"|",7)=newNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",newNodeNo),"|",6)=previousSiblingNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",newNodeNo),"|",7)=targetNodeNo
 . s $p(^zewdDOM("dom",docNo,"node",targetNodeNo),"|",6)=newNodeNo
 ;
 s $p(^zewdDOM("dom",docNo,"node",newNodeNo),"|",3)=parentNodeNo
 QUIT newOID
 ;
removeIntermediateNode(inOID,deleteFromDOM) ; remove an intermediate node, moving any of its children up to its parent
 ;
 n childArray,childNo,nOID,nodeOID
 ;
 d getChildrenInOrder(inOID,.childArray)
 s childNo=""
 f  s childNo=$o(childArray(childNo)) q:childNo=""  d
 . s nodeOID=childArray(childNo)
 . s nOID=$$removeChild(nodeOID)
 . s nOID=$$insertBefore(nOID,inOID)
 s inOID=$$removeChild(inOID,$g(deleteFromDOM))
 QUIT
 ;QUIT inOID
 ;
getChildrenInOrder(parentOID,childArray)
 ;
 n nodeOID,childNo,siblingOID
 ;
 k childArray
 s childNo=0
 s nodeOID=$$getFirstChild(parentOID)
 q:nodeOID=""
 s childNo=childNo+1
 s childArray(childNo)=nodeOID
 s siblingOID=nodeOID
 f  s siblingOID=$$getNextSibling(siblingOID) q:siblingOID=""  d
 . s childNo=childNo+1
 . s childArray(childNo)=siblingOID
 QUIT
 ;
getChildNodesArrayInOrder(documentName,nodeOID,nodesArray)
 ;
 n childNo,no
 ;
 k nodesArray
 i $g(documentName)="",$g(nodeOID)="" QUIT ""
 i $g(nodeOID)="" s nodeOID=$$getDocumentNode(documentName)
 d getChildrenInOrder(nodeOID,.nodesArray)
 s childNo="",no=0
 f  s childNo=$o(nodesArray(childNo)) q:childNo=""  d
 . s no=no+1
 QUIT no
 ;
getParentForm(nodeOID)
 ;
 n formFound,formOID,parentOID
 ;
 s parentOID=nodeOID,formFound=0
 f  s parentOID=$$getParentNode^%zewdDOM(parentOID) d  q:formFound  q:parentOID=docOID
 . i $$getTagName^%zewdDOM(parentOID)="form" s formFound=1
 i formFound QUIT parentOID
 QUIT ""
 ;
cloneDocument(fromDocName,toDocName)
 ;
 n fromDocNo,fromDocOID,toDocNo,toDocOID
 ;
 s toDocNo=$$newDocument($g(toDocName))
 i 'toDocNo QUIT toDocNo
 i $g(fromDocName)="" QUIT $$setError("Document being cloned was not specified")
 s fromDocOID=$$getDocumentNode(fromDocName)
 i 'fromDocOID QUIT fromDocOID
 s fromDocNo=$$getDocNo(fromDocOID)
 f sub="node","nodeNameIndex","nodeTypeIndex","documentElement","localNameIndex" d
 . m ^zewdDOM("dom",toDocNo,sub)=^zewdDOM("dom",fromDocNo,sub)
 s toDocOID=$$getOID(toDocNo,1)
 ;
 QUIT toDocOID
 ;
importNode(fromNodeOID,deep,toDocOID)
 ;
 n ok,toDocNo,toTopNodeOID
 ;
 s deep=$g(deep)
 i deep="" s deep="true"
 i $g(fromNodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(fromNodeOID) QUIT $$setError("Node "_fromNodeOID_" does not exist")
 s toDocNo=$$getDocNo(toDocOID)
 s toTopNodeOID=$$copyNodes(fromNodeOID,toDocOID,"",deep)
 QUIT toTopNodeOID
 ;
copyNodes(fromNodeOID,toDocOID,parentOID,deep)
 ;
 n childOID,data,nodeType,nodeName,nodeOID,ok,target,value
 ;
 s nodeType=$$getNodeType(fromNodeOID)
 s nodeName=$$getNodeName(fromNodeOID)
 s nodeOID=""
 i nodeType=1 d
 . s nodeOID=$$createElement(nodeName,toDocOID)
 . i $g(parentOID)'="" s nodeOID=$$appendChild(nodeOID,parentOID)
 . i $$hasAttributes(fromNodeOID)="true" d
 . . n attr,attrArray,attrName,attrOID,attrValue,ok
 . . s ok=$$getAttributes(fromNodeOID)
 . . s attrOID=""
 . . f  s attrOID=$o(attr(attrOID)) q:attrOID=""  d
 . . . s attrName=$p(attr(attrOID),$c(1),1)
 . . . s attrValue=$p(attr(attrOID),$c(1),2)
 . . . d setAttribute(attrName,attrValue,nodeOID)
 i nodeType=2 d  QUIT nodeOID
 . s value=$$getValue(fromNodeOID)
 . i $g(parentOID)'="" s ok=$$setAttribute(nodeName,value,parentOID) ; attribute
 i nodeType=3 d  QUIT nodeOID
 . s data=$$getData(fromNodeOID)
 . s nodeOID=$$createTextNode(data,toDocOID)
 . i $g(parentOID)'="" s nodeOID=$$appendChild(nodeOID,parentOID)
 i nodeType=7 d  QUIT nodeOID
 . s data=$$getData(fromNodeOID)
 . s target=$$getTarget(fromNodeOID)
 . s nodeOID=$$createProcessingInstruction(target,data,toDocOID)
 . i $g(parentOID)'="" s nodeOID=$$appendChild(nodeOID,parentOID) ; processing instruction
 i nodeType=8 d  QUIT nodeOID
 . s data=$$getData(fromNodeOID)
 . s nodeOID=$$createComment(data,toDocOID)
 . i $g(parentOID)'="" s nodeOID=$$appendChild(nodeOID,parentOID) ; comment
 i nodeType=4 d  QUIT nodeOID
 . s data=$$getData(fromNodeOID)
 . s nodeOID=$$createCDATASection(data,toDocOID)
 . i $g(parentOID)'="" s nodeOID=$$appendChild(nodeOID,parentOID) ; CDATA
 ;
 i nodeType=9 ; ignore
 ;
 i $g(deep)'="true" QUIT nodeOID
 s childOID=""
 f  s childOID=$$getNextChild(fromNodeOID,childOID) q:childOID=""  d
 . s ok=$$copyNodes(childOID,toDocOID,nodeOID,deep)
 QUIT nodeOID
 ;
insertNewIntermediateElement(parentOID,tagName,docOID)
 ;
 n newNodeOID,childArray,childNo
 ;
 d getChildrenInOrder(parentOID,.childArray)
 s newNodeOID=$$addElementToDOM(tagName,parentOID)
 s childNo=""
 f  s childNo=$o(childArray(childNo)) q:childNo=""  d
 . n nOID,nodeOID,mOID
 . s nodeOID=childArray(childNo)
 . s nOID=$$removeChild(nodeOID)
 . s mOID=$$appendChild(nOID,newNodeOID)
 QUIT newNodeOID
 ;
findNamespaceURI(nodeOID,NSPrefix)
 QUIT "*"
 ;
getFirstElementByTagName(tagName,documentName,nodeOID)
 ;
 n nodeArray,OIDArray,ok
 ;
 i $g(documentName)="",$g(nodeOID)="" QUIT ""
 i $g(nodeOID)="" s nodeOID=$$getDocumentNode(documentName)
 s ok=$$getElementsByTagName(tagName,nodeOID,.nodeArray)
 QUIT $o(nodeArray(""))
 ;
getFirstElementByTagNameNS(nsURI,localName,documentName,nodeOID)
 ;
 n nodeArray,OIDArray,ok
 ;
 i $g(documentName)="",$g(nodeOID)="" QUIT ""
 i $g(nodeOID)="" s nodeOID=$$getDocumentNode(documentName)
 s ok=$$getElementsByTagNameNS($g(nsURI),$g(localName),nodeOID,.nodeArray)
 QUIT $o(nodeArray(""))
 ;
insertNewFirstChildElement(parentOID,tagName,docOID)
 ;
 n tagOID,fcOID,newOID
 ;
 s tagOID=$$createElement(tagName,docOID)
 s fcOID=$$getFirstChild(parentOID)
 i fcOID'="" s newOID=$$insertBefore(tagOID,fcOID)
 e  s newOID=$$appendChild(tagOID,parentOID)
 QUIT newOID
 ;
insertNewFirstChildElementNS(parentOID,namespaceURI,qualifiedName,docOID)
 QUIT $$insertNewFirstChildElement($g(parentOID),$g(qualifiedName),$g(docOID))
 ;
getOwnerElement(attrOID)
 QUIT $$getParentNode($g(attrOID))
 ;
insertNewParentElement(nodeOID,parentTagName,docOID)
 ;
 n docNo,newParentOID,mOID
 ;
 i $g(parentTagName)="" QUIT $$setError("Parent TagName was not specified") 
 i $g(nodeOID)="" QUIT $$setError("Node OID was not specified") 
 i '$$nodeExists(nodeOID) QUIT $$setError("Node "_nodeOID_" does not exist")
 i docOID="" QUIT $$setError("Invalid Document OID")
 s docNo=$$getDocNo(docOID)
 i docNo'?1N.N QUIT $$setError("Invalid Document OID")
 i '$d(^zewdDOM("dom",docNo)) QUIT $$setError("No DOM exists with the OID "_docOID)
 ;
 s newParentOID=$$createElement(parentTagName,docOID)
 s newParentOID=$$insertBefore(newParentOID,nodeOID)
 s nodeOID=$$removeChild(nodeOID)
 s mOID=$$appendChild(nodeOID,newParentOID)
 ;
 QUIT newParentOID
 ;
insertNewParentElementNS(oldParent,namespaceURI,qualifiedName,documentOID)
 QUIT $$insertNewParentElement($g(oldParent),$g(qualifiedName),$g(documentOID))
 ;
getTagOID(tagName,docName,lowerCase)
 QUIT $$getTagOID^%zewdCompiler($g(tagName),$g(docName),$g(lowerCase))
 ;
getTagByNameAndAttr(tagName,attrName,attrValue,matchCase,docName)
 QUIT $$getTagByNameAndAttr^%zewdCompiler3($g(tagName),$g(attrName),$g(attrValue),$g(matchCase),$g(docName))
 ;
getFormTag(inputOID)
	n parentOID
	set parentOID=inputOID
	for  set parentOID=$$getParentNode^%zewdDOM(parentOID) quit:$$getNodeName^%zewdDOM(parentOID)="form"  quit:parentOID=""
	QUIT parentOID
 ;
addCSPServerScript(parentOID,text)
 QUIT $$addCSPServerScript^%zewdCompiler4($g(parentOID),$g(text))
 ;
addJavascriptFunction(docName,jsTextArray)
 QUIT $$addJavascriptFunction^%zewdCompiler7($g(docName),.jsTextArray)
 ;
addJavascriptObject(docName,jsText)
 QUIT $$addJavascriptObject^%zewdCompiler13($g(docName),.jsText)
 ;
createJSPCommand(data,docOID)
 QUIT $$createJSPCommand^%zewdCompiler4(data,docOID)
 ;
createPHPCommand(data,docOID)
 QUIT $$createPHPCommand^%zewdCompiler4(data,docOID)
 ;
getJavascriptFunctionBody(functionName,docName)
 QUIT $$getJavascriptFunctionBody^%zewdCompiler7($g(functionName),docName)
 ;
getJavascriptObjectBody(functionName,docName)
 QUIT $$getJavascriptObjectBody^%zewdCompiler13($g(functionName),$g(docName))
 ;
javascriptFunctionExists(functionName,docName)
 QUIT $$javascriptFunctionExists^%zewdCompiler7($g(functionName),$g(docName))
 ;
javascriptObjectExists(objectName,docName)
 QUIT $$javascriptObjectExists^%zewdCompiler13($g(objectName),$g(docName))
 ;
replaceJavascriptFunctionBody(functionName,jsText,docName)
 QUIT $$replaceJavascriptFunctionBody^%zewdCompiler7($g(functionName),$g(jsText),$g(docName))
 ;
replaceJavascriptObjectBody(functionName,newBody,docName)
 QUIT $$replaceJavascriptObjectBody^%zewdCompiler13($g(functionName),$g(newBody),$g(docName))
 ;
convertNodeToText(nodeOID)
 QUIT $$convertNodeToText^%zewdCompiler20($g(nodeOID))
 ;
documentation(rou) ;
 ;
 n docFile,i,labels,line,lineNo,x
 ;
 i $g(rou)="" s rou="%zewdDOM"
 s docFile=rou_"Documentation.txt"
 ;
 i $$openNewFile^%zewdAPI(docFile)
 u docFile
 s line=""
 f  s line=$o(labels(line)) q:line=""  d
 . w line,!!
 c docFile
 QUIT
 ;
lf ;
 i $g(outputLocation)="file" w ! q
 w $c(13,10)
 QUIT
 ;
