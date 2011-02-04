%zewdXPath	; EWD XPath
 ;
 ; Product: Enterprise Web Developer (Build 844)
 ; Build Date: Fri, 04 Feb 2011 14:54:35
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
select(XPathQuery,docOID,outNodeOIDs,fromNode) ; 
	;
	n attr,docName,error,inNodeOIDs,nQuery,nset,ok,predicate,query,step
	;
	QUIT:XPathQuery="" "Null query"
	i $g(docOID)="" QUIT "Document OID not specified"
	s error=""
	i docOID'?1N.N1"-"1N.N d  i error'="" QUIT error
	. s docOID=$$getDocumentNode^%zewdDOM(docOID)
	. i $e(docOID,1)=0 s error=$p(docOID,"~",2)
	e  d  i error'="" QUIT error
	. s docName=$$getDocumentName^%zewdDOM(docOID)
	. i $e(docName,1)=0 s error=$p(docName,"~",2)
	;
	i XPathQuery="." d  QUIT +$o(outNodeOIDs(""),-1)
	. n nodeOID
	. s nodeOID=$g(outNodeOIDs(1))
	. k outNodeOIDs
	. i nodeOID'="" s outNodeOIDs(1)=nodeOID
	s fromNode=$g(fromNode)
	k outNodeOIDs
	i fromNode'="" s outNodeOIDs(1)=fromNode
	s query=$$expandQuery(XPathQuery,.predicate)
	i fromNode'="" s query="/"_$p(query,"/",2,2000)
	;
	s nset=$l(query,"/")
	f nQuery=1:1:nset d
	. s step=$p(query,"/",nQuery)
	. k inNodeOIDs
	. m inNodeOIDs=outNodeOIDs
	. k outNodeOIDs
	. d locationSet(step,nQuery,.inNodeOIDs,.outNodeOIDs)
	. ;
	. ; now process predicate to filter outNodeOIDs
	. ;
	. i '$d(predicate(nQuery)) q  ; no predicates defined
	. ;
	. k inNodeOIDs
	. m inNodeOIDs=outNodeOIDs
	. k outNodeOIDs
	. ;
	. d predicates(.predicate,nQuery,.inNodeOIDs,.outNodeOIDs)
	;
	k outNodeOIDs(0) ; delete the index
	QUIT +$o(outNodeOIDs(""),-1)
	;
 ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
expandQuery(query,predicate)
	;
	n %buf,%c,%c2,i,%len,%lvl,npieces,npred,nstep,%p2,%p3,pos,%pred,%stop
	;
	;i $e(query,1)'="/",$e(query,$l(query))'="/" s query="//"_query_"[1]/"
	; query="myNodeName" - get just first instance of it anywhere in the document
	i query'["/" s query="//"_query_"[1]/"
	; query="catalog/cd" - treat as //catalog/cd - get all instances of cd
	i $e(query,1)'="/",$e(query,$l(query))'="/" s query="//"_query
	i $e(query,1)'="/",$e(query,$l(query))="/" s query="//"_$e(query,1,$l(query)-1)_"[1]/"
	s query=$$replaceAll^%zewdAPI(query,"//","/descendant-or-self::node()/")
	s query=$$replaceAll^%zewdAPI(query,"..","parent::node()")
	s query=$$replaceAll^%zewdAPI(query,"./","self::node()/")
	s query=$$replaceAll^%zewdAPI(query,"@","attribute::")
	;
	s %len=$l(query)
	s %buf="",%stop=0,npred=0,nstep=1
	f pos=1:1 d  q:%stop
	. s %c=$e(query,pos)
	. i %c="" s %stop=1 q
	. ;
	. i %c="/" d  q
	. . s %buf=%buf_%c
	. . s nstep=nstep+1
	. i %c="[" d  q
	. . n %stopx
	. . s %lvl=1,%stopx=0,%pred=""
	. . f pos=pos+1:1 d  q:%stopx
	. . . s %c2=$e(query,pos)
	. . . i %c2="" s %stopx=1 q
	. . . i %c2="&" d
	. . . . s %c2="]"
	. . . . s $e(query,pos+1)="["
	. . . i %c2="[" s %lvl=%lvl+1
	. . . i %c2="]" d  q:%stopx
	. . . . s %lvl=%lvl-1
	. . . . i %lvl=0 d  q
	. . . . . s %stopx=1
	. . . . . s %pred=$$expandPredicate(%pred)
	. . . . s %pred=%pred_%c2
	. . . s %pred=%pred_%c2
	. . s npred=$o(predicate(nstep,""),-1)+1
	. . i $e(%pred,1)="(",$e(%pred,$l(%pred))=")" s %pred=$e(%pred,2,$l(%pred)-1)
	. . s predicate(nstep,npred)=%pred
	. ;
	. s %buf=%buf_%c
	;
	s npieces=$l(%buf,"/")
	f i=1:1:npieces d
	. s step=$p(%buf,"/",i)
	. i step'["::" s step="child::"_step,$p(%buf,"/",i)=step
	s query=$e(query,pos+1,$l(query))
	QUIT %buf
	;
locationSet(step,nQuery,inNodes,outNodes)
	;
	n nlOID,outNodeNo,pred,predStep
	;
	k outNodes
	i nQuery=1 d  QUIT
	. i step="child::" s outNodes(1)=docOID q
	. m outNodes=inNodes
	. q  ; something strange happened !
	;
	d applyAxis(step,.inNodes,.outNodes) 
	QUIT
	;
applyAxis(step,inNodes,outNodes)
	;
	n axis,nodeNo,nodeOID,nodeTest,ok,%p2
	;
	s axis=$p(step,"::",1)
	s %p2=$p(step,"::",2,255)
	s nodeTest=$p(%p2,"[",1)
	i nodeTest["/" s nodeTest=$p(nodeTest,"/",1)
	i nodeTest="" s nodeTest="node()"
	;
	i axis="self" d  QUIT
	. ;
	. ; just use nodes in array
	. ;
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="child" d  QUIT
	. ;
	. ; for each context node in turn, get children
	. ;
	. n nodes
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . d getChildrenInOrder^%zewdDOM(nodeOID,.nodes)
	. . ; now select according to nodeTest, so test each node in the node list array
	. . d applyNodeTestToNodeList(nodeTest,.nodes,.outNodes)
	;
	i axis="descendant-or-self"!(axis="descendant") d  QUIT
	. n descNodes
	. ;
	. ; for each context node in turn, get all descendants
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . i axis="descendant-or-self" d addNode(nodeOID,.descNodes) ; add self node
	. . d getDescendantNodes(nodeOID,.descNodes,0)
	. ; now select according to the nodeTest
	. s nodeNo=0
	. f  s nodeNo=$o(descNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=descNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="ancestor-or-self"!(axis="ancestor") d  QUIT
	. n ancNodes
	. ;
	. ; for each context node in turn, get all ancestor nodes
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . i axis="ancestor-or-self" d addNode(nodeOID,.ancNodes) ; add self node
	. . d getAncestorNodes(nodeOID,.ancNodes,0,docOID)
	. ; now select according to the nodeTest
	. s nodeNo=0
	. f  s nodeNo=$o(ancNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=ancNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="preceeding" d  QUIT
	. n sibNodes
	. ;
	. ; for each context node in turn, get all sibling nodes
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . d getPreceedingNodes(nodeOID,docOID,.sibNodes,0)
	. ; now select according to the nodeTest
	. s nodeNo=0
	. f  s nodeNo=$o(sibNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=sibNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="following" d  QUIT
	. n sibNodes
	. ;
	. ; for each context node in turn, get all sibling nodes
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . d getFollowingNodes(nodeOID,docOID,.sibNodes,0)
	. ; now select according to the nodeTest
	. s nodeNo=0
	. f  s nodeNo=$o(sibNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=sibNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="following-sibling" d  QUIT
	. n sibNodes
	. ;
	. ; for each context node in turn, get all sibling nodes
	. s nodeNo=0
	. f  S nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . d getFollowingSiblingNodes(nodeOID,.sibNodes,0)
	. ; now select according to the nodeTest
	. s nodeNo=0
	. f  s nodeNo=$o(sibNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=sibNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="preceeding-sibling" d  QUIT
	. n sibNodes
	. ;
	. ; for each context node in turn, get all sibling nodes
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . d getPreceedingSiblingNodes(nodeOID,.sibNodes,0)
	. ; now select according to the nodeTest
	. s nodeNo=0
	. f  s nodeNo=$o(sibNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=sibNodes(nodeNo)
	. . d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	;
	i axis="parent" d  QUIT
	. n parentOID
	. ;
	. ; for each context node in turn, get parent
	. ;
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	. . d applyNodeTest(nodeTest,parentOID,.outNodes,nodeNo)
	;
	i axis="attribute" d  QUIT
	. n attrs,nnmOID
	. s nodeNo=0
	. f  s nodeNo=$o(inNodes(nodeNo)) q:nodeNo=""  d
	. . s nodeOID=inNodes(nodeNo)
	. . Set nnmOID=$$getAttributes^%zewdDOM(nodeOID,.attrs)
	. . d applyNodeTestToAttrs(nodeTest,.attrs,.outNodes)
	;
	; axis not implemented !
	Q
	;
applyNodeTestToNodeList(nodeTest,nodeArray,outNodes) ;
	;
	n nodeNo,nodeOID
	;
	s nodeNo=""
	f  s nodeNo=$o(nodeArray(nodeNo)) q:nodeNo=""  d
	. s nodeOID=nodeArray(nodeNo)
	. d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	QUIT
	;
applyNodeTestToAttrs(nodeTest,nodeArray,outNodes) ;
	;
	n nodeNo,nodeOID
	;
	s nodeNo=0,nodeOID=""
	f  s nodeOID=$o(nodeArray(nodeOID)) q:nodeOID=""  d
	. s nodeNo=nodeNo+1
	. d applyNodeTest(nodeTest,nodeOID,.outNodes,nodeNo)
	QUIT
	;
applyNodeTest(nodeTest,nodeOID,outNodes,contextPos)
	;
	n nodeType,tagName
	;
	i nodeTest="node()" d addNode(nodeOID,.outNodes) QUIT  ; all node types allowed
	i nodeTest="*" d addNode(nodeOID,.outNodes) QUIT  ; add all element nodes
	;
	s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	i nodeTest="text()",nodeType=3 d addNode(nodeOID,.outNodes) QUIT
	i nodeTest="comment()",nodeType=8 d addNode(nodeOID,.outNodes) QUIT
	i nodeTest["processing-instruction(",nodeType=7 d addNode(nodeOID,.outNodes) QUIT
	;
	i nodeType=2 d  QUIT
	. i nodeTest["=" d  q
	. . n attrName,attrValue
	. . s attrValue=$p(nodeTest,"=",2)
	. . s attrName=$p(nodeTest,"=",1)
	. . i $$getName^%zewdDOM(nodeOID)=attrName,$$getValue^%zewdDOM(nodeOID)=attrValue d addNode(nodeOID,.outNodes)
	. i $$getName^%zewdDOM(nodeOID)=nodeTest d addNode(nodeOID,.outNodes)
	;
	i $$getTagName^%zewdDOM(nodeOID)=nodeTest d addNode(nodeOID,.outNodes) QUIT
	QUIT
	;
addNode(nodeOID,outNodes)
	;
	n outNodeNo
	i $d(outNodes(0,nodeOID)) QUIT  ; already exists in list
	s outNodeNo=$o(outNodes(""),-1)+1
	s outNodes(outNodeNo)=nodeOID
	s outNodes(0,nodeOID)="" ; index
	QUIT
	;
predicates(predicates,nStep,inNodes,outNodes) ; predicate processing
	; 
	n predno,pred
	;
	k outNodes
	m outNodes=inNodes
	;
	s predno=""
	f  s predno=$o(predicate(nStep,predno)) q:predno=""  d
	. s pred=predicate(nStep,predno)
	. k inNodes
	. m inNodes=outNodes
	. k outNodes
	. d predicate(pred,.inNodes,.outNodes)
	QUIT
	;
predicate(pred,inNodes,outNodes) ; predicate processing
	;
	n %buf,%c1,%c12,contextNo,contextSize,i,left,len,nodeOID,%oper,right,%stop
	;
	i pred?1N.N s pred="position()="_pred
	s %buf="",%stop=0,%oper=""
	s len=$l(pred)
	f i=1:1:len d  q:%stop
	. s %c1=$e(pred,i)
	. s %c12=$e(pred,i,i+1)
	. i %c12="!=" s %oper=%c12,%stop=1 q
	. i %c12="<=" s %oper=%c12,%stop=1 q
	. i %c12=">=" s %oper=%c12,%stop=1 q
	. i %c1="=" s %oper=%c1,%stop=1 q
	. i %c1="<" s %oper=%c1,%stop=1 q
	. i %c1=">" s %oper=%c1,%stop=1 q
	. s %buf=%buf_%c1
	;
	s left=%buf,right=$e(pred,i+1,$l(pred))
	s left=$$stripSpaces^%zewdAPI(left)
	S right=$$stripSpaces^%zewdAPI(right)
	i $e(right,1)="'",$e(right,$l(right))="'" s right=$e(right,2,$l(right)-1)
	i $e(right,1)="""",$e(right,$l(right))="""" s right=$e(right,2,$l(right)-1)
	;
	s contextSize=$o(inNodes(""),-1)
	f contextNo=1:1:contextSize d
	. s nodeOID=inNodes(contextNo)
	. i $$filter(nodeOID,contextNo,contextSize,left,right,%oper) d addNode(nodeOID,.outNodes)
	QUIT
	;
filter(contextNodeOID,contextNo,contextSize,left,right,oper)
	;
	n bool,i,nodeOID,ok,p,param
	;
	i left'["/",left'["::",left'["(" s left="child::"_left ; assume to be a child name
	i left="last()" QUIT (contextNo=contextSize)
	i left["contains(" d  QUIT bool
	. d evaluateParams(left,"contains",.param,contextNodeOID)
	. i param(1)'="",'param(1) s bool=0 q  ; 1st parameter didnt resolve to any nodes
	. i param(2)'="",'param(2) s bool=0 q  ; 2nd parameter didnt resolve to any nodes
	. d getParamValues(.param,.p)
	. s bool=p(1)[p(2)
	;
	i left["starts-with(" d  QUIT bool
	. d evaluateParams(left,"starts-with",.param,contextNodeOID)
	. i param(1)'="",'param(1) s bool=0 q  ; 1st parameter didnt resolve to any nodes
	. i param(2)'="",'param(2) s bool=0 q  ; 2nd parameter didnt resolve to any nodes
	. d getParamValues(.param,.p)
	. s bool=($e(p(1),1,$l(p(2)))=p(2))
	;
	i left["not(" d  QUIT bool
	. d evaluateParams(left,"not",.param,contextNodeOID)
	. i param(1)="" s bool='param(1,1) q
	. s bool='param(1)
	;
	i left["/"!(left["::") d  QUIT bool
	. ;
	. ; relative path needs to be resolved
	. ;
	. n inSubNodes,nodeOID,nQuery,nodeType,nset,outSubNodes,step,x
	. ;
	. s outSubNodes(1)=contextNodeOID
	. s nset=$l(left,"/")
	. f nQuery=1:1:nset d
	. . k inSubNodes
	. . m inSubNodes=outSubNodes
	. . k outSubNodes
	. . s step=$p(left,"/",nQuery)
	. . d applyAxis(step,.inSubNodes,.outSubNodes)
	. ; should now just be one or no nodes in outSubNodes
	. s nodeOID=$g(outSubNodes(1))
	. i '$d(outSubNodes) s bool=0 q
	. i nodeOID="" s bool=0 q
	. i oper="" s bool=1 q
	. ;
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. s x="s bool=0"
	. i nodeType=2 s x="s bool=($$getValue^%zewdDOM(nodeOID)"_oper_""""_right_""")"
	. i nodeType=1 s x="s bool=($$getTextValue(nodeOID)"_oper_""""_right_""")"
	. x x
	;
	i left="position()" d  QUIT bool
	. ;
	. n x
	. s x="s bool=contextNo"_oper_right
	. x x
	QUIT ""
	;
getParamValues(param,values)
	;
	n nodeOID,nodeType,nparams
	;
	s nparams=$o(param(""),-1)
	s values(1)="",values(2)=""
	f i=1:1:nparams d
	. s values(i)=param(i,1)
	. i param(i)'="",param(i) d
	. . s nodeOID=param(i,1)
	. . s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. . i nodeType=2 s values(i)=$$getValue^%zewdDOM(nodeOID)
	. . i nodeType=1 s values(i)=$$getTextValue(nodeOID)
	QUIT
	;
stripQuotes(string)
	;
	i $e(string,1)="'",$e(string,$l(string))="'" s string=$e(string,2,$l(string)-1) QUIT string
	i $e(string,1)="""",$e(string,$l(string))="""" s string=$e(string,2,$l(string)-1)
	QUIT string
	;
evaluateParams(funcCall,funcName,param,contextNodeOID)
	;
	n nodes,%np,%p1,%p3
	;
	k param,ok
	s funcName=funcName_"("
	s %p3=$p(funcCall,funcName,2)
	s %p3=$e(%p3,1,$l(%p3)-1)
	f %np=1:1 q:%p3=""  d
	. s %p1=$$extractParam(.%p3)
	. i %p1["::" d  q
	. . d evalString(%p1,contextNodeOID,.nodes)
	. . s param(%np)=$d(nodes)
	. . m param(%np)=nodes
	. s param(%np)=""
	. s param(%np,1)=%p1
	QUIT
	;
extractParam(string)
	;
	n %dlim,%p1,%p2
	;
	s %p1=$e(string,1)
	s %dlim=""
	i (%p1="'")!(%p1="""") s %dlim=%p1
	i %dlim="" d  QUIT %p1
	. s %p1=$p(%p3,",",1)
	. s string=$p(string,",",2,500)
	s %p1=$p(%p3,%dlim,2)
	s %p2=%dlim_%p1_%dlim
	s string=$p(string,%p2_",",2,500)
	QUIT %p1
	;
evalString(string,contextNodeOID,outSubNodes)	;
	;
	n inSubNodes,%p2
	;
	k outSubNodes
	s inSubNodes(1)=contextNodeOID
	d applyAxis(string,.inSubNodes,.outSubNodes)
	QUIT
	;
	;I '$D(outSubNodes) S bool=0 Q
	;. I nodeOID="" S bool=0 Q
	;. I oper="" b  S bool=1 Q
	;S nodeOID=$G(outSubNodes(1)) I nodeOID="" S %p2=$C(0) Q %p2
	;Set nodeType=$$getNodeType^%eDOMNode(nodeOID)
	;I nodeType=2 S %p2=$$getValue^%eDOMAttr(nodeOID) Q %p2
	;I nodeType=1 S %p2=$$getTextValue(nodeOID) Q %p2
	;Q ""
	;
expandPredicate(query)
	;
	n axis,%buf,%c,i,%len,nodeTest,npieces,%p1,%p3,pos,predicate,%stop
	;
	s %len=$l(query)
	s %buf="",%stop=0
	f pos=1:1:%len d   QUIT:%stop
	. s %c=$e(query,pos)
	. i %c="" s %stop=1 q
	. ;
	. i %c="/" d  q
	. . i $e(query,pos+1)="/" d
	. . . s query="/descendant-or-self::"_$e(query,pos+2,$l(query))
	. . s %buf=%buf_%c
	. ;
	. i %c="." d  q
	. . i $e(query,pos+1)="." d  q
	. . . s %buf=%buf_"parent::node()"
	. . . s pos=pos+1
	. . s %buf=%buf_"self::node()"
	. ;
	. i %c="@" d  q
	. . s %buf=%buf_"attribute::"
	. s %buf=%buf_%c
	;
	i %buf?1N.N s %buf="position()="_%buf
	s npieces=$l(%buf,"/")
	i %buf["/" f i=1:1:npieces d
	. s step=$p(%buf,"/",i)
	. i step'["::" s step="child::"_step,$p(%buf,"/",i)=step
	s query=$e(query,pos+1,$l(query))
	QUIT %buf
	;
getTextValue(nodeOID) ; get text node value for an element
	;
	QUIT $$getData^%zewdDOM($$getFirstChild^%zewdDOM(nodeOID))
	;
getText(path,docName)
	;
	n nodes,ok
	;
	s ok=$$select^%zewdXPath(path,docName,.nodes)
	QUIT $$getTextValue(nodes(1))
	;
getDescendantNodes(nodeOID,nodes,clear)
	;
	i +$g(clear) k nodes
	d getDescendant(nodeOID,.nodes)
	QUIT
	;
getDescendant(nodeOID,nodes)
	;
	n childOID,siblingOID
	;
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	i childOID'="" d
	. d addNode(childOID,.nodes)
	. d getDescendant(childOID,.nodes)
	. s siblingOID=childOID
	. f  s siblingOID=$$getNextSibling^%zewdDOM(siblingOID) q:siblingOID=""  d
	. . d addNode(siblingOID,.nodes)
	. . d getDescendant(siblingOID,.nodes)
	QUIT
	;
getPreceedingNodes(nodeOID,docOID,nodes,clear)
	;
	n %stop
	;
	i +$g(clear) k nodes
	k %stop
	s %stop=0
	d getPreceeding(docOID,nodeOID,.nodes)
	QUIT
	;
getPreceeding(nodeOID,selfOID,nodes)
	;
	n childOID,siblingOID
	;
	QUIT:%stop
	i nodeOID=selfOID s %stop=1 QUIT
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	i childOID=selfOID s %stop=1 QUIT
	i childOID'="" d
	. d addNode(childOID,.nodes)
	. d getPreceeding(childOID,selfOID,.nodes)
	. s siblingOID=childOID
	. f  S siblingOID=$$getNextSibling^%zewdDOM(siblingOID) s:siblingOID=selfOID %stop=1 q:%stop  q:siblingOID=selfOID  q:siblingOID=""  d
	. . d addNode(siblingOID,.nodes)
	. . d getPreceeding(siblingOID,selfOID,.nodes)
	QUIT
	;
getFollowingNodes(nodeOID,docOID,nodes,clear)
	;
	n started
	;
	i +$g(clear) k nodes
	s %started=0
	d getFollowing(docOID,nodeOID,.nodes)
	QUIT
	;
getFollowing(nodeOID,selfOID,nodes)
	;
	n childOID,siblingOID
	;
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	i childOID'="" D
	. i %started d addNode(childOID,.nodes)
	. d getFollowing(childOID,selfOID,.nodes)
	. s siblingOID=childOID
	. f  S siblingOID=$$getNextSibling^%zewdDOM(siblingOID)  q:siblingOID=""  d
	. . i %started d addNode(siblingOID,.nodes)
	. . d getFollowing(siblingOID,selfOID,.nodes)
	i childOID=selfOID S %started=1
	QUIT
	;
getAncestorNodes(nodeOID,nodes,clear,docOID)
	;
	i +$g(clear) k nodes
	d getAncestor(nodeOID,.nodes,docOID)
	QUIT
	;
getAncestor(nodeOID,nodes,docOID)
	;
	n parentOID
	;
	s parentOID=$$getParentNode^%zewdDOM(nodeOID)
	QUIT:parentOID=docOID
	i parentOID'="" d
	. d addNode(parentOID,.nodes)
	. d getAncestor(parentOID,.nodes,docOID)
	QUIT
	;
getFollowingSiblingNodes(nodeOID,nodes,clear)
	;
	i +$g(clear) k nodes
	d getNextSibling(nodeOID,.nodes)
	QUIT
	;
getNextSibling(nodeOID,nodes)
	;
	n siblingOID
	;
	s siblingOID=$$getNextSibling^%zewdDOM(nodeOID)
	i siblingOID'="" d
	. d addNode(siblingOID,.nodes)
	. d getNextSibling(siblingOID,.nodes)
	QUIT
	;
getPreceedingSiblingNodes(nodeOID,nodes,clear)
	;
	i +$g(clear) k nodes
	d getPreviousSibling(nodeOID,.nodes)
	QUIT
	;
getPreviousSibling(nodeOID,nodes)
	;
	n siblingOID
	;
	s siblingOID=$$getPreviousSibling^%zewdDOM(nodeOID)
	i siblingOID'="" D
	. d addNode(siblingOID,.nodes)
	. d getPreviousSibling(siblingOID,.nodes)
	QUIT
	;
getElementDetails(nodeOID,details)
	;
	n attrName,attrOID,attrs,attrValue,childNo,childOID,i,length
	n ok,nnmOID,nodeType,sibOID
	;
	k details
	s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	i nodeType'=1 QUIT  ; only applies to elements!
	s details("nodeType")="element"
	s details("nodeTypeCode")=nodeType
	s details("tagName")=$$getTagName^%zewdDOM(nodeOID)
	s ok=$$getAttributes^%zewdDOM(nodeOID,.attrs)
	s attrOID=""
	f  s attrOID=$o(attrs(attrOID)) q:attrOID=""  d
	. s attrName=$p(attrs(attrOID),$c(1),1)
	. s attrValue=$p(attrs(attrOID),$c(1),2)
	. s details("attr",attrName)=attrValue
	. s details("attr",attrName,"OID")=attrOID
	s childNo=0
	s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	i childOID'="" d
	. s nodeType=$$getNodeType^%zewdDOM(childOID)
	. i nodeType'=3 s childNo=childNo+1,details("child",childNo)=childOID
	. i nodeType=3 d
	. . s details("text")=$$getData^%zewdDOM(childOID)
	. . s details("textOID",$e(details("text"),1,240))=childOID
	. s sibOID=childOID
	. f  s sibOID=$$getNextSibling^%zewdDOM(sibOID) q:sibOID=""  d
	. . i nodeType'=3 s childNo=childNo+1,details("child",childNo)=sibOID
	. . i nodeType=3 s details("text")=$g(details("text"))_$$getData^%zewdDOM(childOID)
	i childNo>0 s details("child")=childNo
	s details("parent")=$$getParentNode^%zewdDOM(nodeOID)
	;
	QUIT
	;
getNodeDetails(nodeOID,details)
	;
	n nodeType
	;
	s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	i nodeType=1 d getElementDetails(nodeOID,.details) QUIT
	k details
	i nodeType=2 d  QUIT
	. s details("nodeType")="attribute"
	. s details("nodeTypeCode")=nodeType
	. s details("name")=$$getName^%zewdDOM(nodeOID)
	. s details("value")=$$getValue^%zewdDOM(nodeOID)
	. s details("elementOID")=$$getAttrAttribute^%zewdDOM(nodeOID,"ownerElement")
	;
	s details("nodeType")=nodeType
	i nodeType=9 d  q  ; document Node
	. n childOID,childNo,sibOID
	. s details("nodeType")="Document Node"
	. s details("nodeTypeCode")=nodeType
	. s childNo=0
	. s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	. i childOID'="" d
	. . s childNo=childNo+1,details("child",childNo)=childOID
	. .	s sibOID=childOID
	. . f  s sibOID=$$getNextSibling^%zewdDOM(sibOID) Q:sibOID=""  D
	. . . s childNo=childNo+1,details("child",childNo)=sibOID
	. i childNo>0 s details("child")=childNo
	;
	i nodeType=7 d  QUIT  ; Processing Instruction
	. n childNo,childOID,sibOID
	. s details("nodeType")="Processing Instruction"
	. s details("nodeTypeCode")=nodeType
	. s details("target")=$$getTarget^%zewdDOM(nodeOID)
	. s details("data")=$$getData^%zewdDOM(nodeOID)
	. s childNo=0
	. s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	. i childOID'="" d
	. . s childNo=childNo+1,details("child",childNo)=childOID
	. . s sibOID=childOID
	. . f  s sibOID=$$getNextSibling^%zewdDOM(sibOID) q:sibOID=""  d
	. . . s childNo=childNo+1,details("child",childNo)=sibOID
	. i childNo>0 s details("child")=childNo
	. s details("parent")=$$getParentNode^%zewdDOM(nodeOID)
	;
	i nodeType=3 d  QUIT  ; Text
	. n childNo,childOID,sibOID
	. s details("nodeType")="Text"
	. s details("nodeTypeCode")=nodeType
	. s details("data")=$$getData^%zewdDOM(nodeOID)
	. s childNo=0
	. s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	. i childOID'="" d
	. . s childNo=childNo+1,details("child",childNo)=childOID
	. . s sibOID=childOID
	. . f  s sibOID=$$getNextSibling^%zewdDOM(sibOID) q:sibOID=""  d
	. . . s childNo=childNo+1,details("child",childNo)=sibOID
	. i childNo>0 S details("child")=childNo
	. s details("parent")=$$getParentNode^%zewdDOM(nodeOID)
	;
 	i nodeType=8 d  QUIT  ; Comment
	. n childNo,childOID,sibOID
	. s details("nodeType")="Comment"
	. s details("nodeTypeCode")=nodeType
	. s details("data")=$$getData^%zewdDOM(nodeOID)
	. s childNo=0
	. s childOID=$$getFirstChild^%zewdDOM(nodeOID)
	. i childOID'="" d
	. . s childNo=childNo+1,details("child",childNo)=childOID
	. . s sibOID=childOID
	. . f  s sibOID=$$getNextSibling^%zewdDOM(sibOID) q:sibOID=""  d
	. . . s childNo=childNo+1,details("child",childNo)=sibOID
	. i childNo>0 s details("child")=childNo
	. s details("parent")=$$getParentNode^%zewdDOM(nodeOID)
	QUIT
	;
displayNodes(nodes) ;
	;
	n i,nodeOID,nodeType
	;
	w "Nodes selected",!!
	;
	i '$d(nodes) w "no nodes selected",! QUIT
	f i=1:1 q:'$d(nodes(i))  d
	. s nodeOID=nodes(i)
	. s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	. w i," : ",nodeOID," : "
	. i nodeType=1 d  q
	. . w "<",$$getTagName^%zewdDOM(nodeOID)
	. . d displayAttributes(nodeOID)
	. . w ">",! q
	. i nodeType=3 w $$getData^%zewdDOM(nodeOID),! q
	. i nodeType=2 w $$getName^%zewdDOM(nodeOID)_"='"_$$getValue^%zewdDOM(nodeOID)_"'",! q
	. w $$getNodeName^%zewdDOM(nodeOID)
	QUIT
	;
getXML(nodeOID)
	;
	n xml
	;
	s xml=$$renderNode(nodeOID)
	s xml=$$replaceAll^%zewdAPI(xml,"&lt;","<")
	s xml=$$replaceAll^%zewdAPI(xml,"&gt;",">")
	;
	QUIT xml
	;
getAttributeValue(xpath,docOID)
	;
	n no,nodeOID,nodes
	s no=$$select(xpath,docOID,.nodes)
	i no<1 QUIT ""
	s nodeOID=$g(nodes(1))
	QUIT $$getValue^%zewdDOM(nodeOID)
	;
renderNode(nodeOID)
	;
	n attr,nodeType
	;
	s nodeType=$$getNodeType^%zewdDOM(nodeOID)
	i nodeType=1 d  QUIT string
	. n node
	. d getNodeDetails(nodeOID,.node)
	. s string="&lt;"_node("tagName")
	. i $d(node("attr")) d
	. . s attr=""
	. . f  s attr=$o(node("attr",attr)) q:attr=""  d
	. . . s string=string_" "_attr_"="_node("attr",attr)
	. s string=string_"&gt;"
	i nodeType=7 D  Q string
	. n node
	. d getNodeDetails(nodeOID,.node)
	. s string="&lt;?"_node("target")
	. s string=string_" "_node("data")
	. s string=string_"?&gt;" 
	;
	i nodeType=2 d  QUIT string
	. n node
	. d getNodeDetails(nodeOID,.node)
	. s string=node("name")_"="_node("value")
	;
	i nodeType=3 d  QUIT string
	. n node
	. d getNodeDetails(nodeOID,.node)
	. s string=node("data")
	;
	i nodeType=8 d  QUIT string
	. n node
	. d getNodeDetails(nodeOID,.node)
	. s string="&lt;!--"_node("data")_"--&gt;"
	QUIT nodeType(nodeType)
	;
displayAttributes(elOID) ; display the attributes of a tag
	;
	n attrName,attrOID,attrs,attrValue,ok
	;
	s ok=$$getAttributes^%zewdDOM(elOID,.attrs)
	s attrOID=""
	f  s attrOID=$o(attrs(attrOID)) q:attrOID=""  d
	. s attrName=$p(attrs(attrOID),$c(1),1)
	. s attrValue=$p(attrs(attrOID),$c(1),2)
	. w " "_attrName_"='"_attrValue_"'"
	QUIT
	;
sort(sortPath,nodes,sortedNodes,docOID)
	;
	n nfound,nodeIndex,nodeNo,nodeOID,sNodes,text,textOID,value
	;
	i $e(sortPath,$l(sortPath))'="/" s sortPath=sortPath_"/text()"
	i $g(sortPath)="" QUIT
	s nodeNo=""
	f  s nodeNo=$o(nodes(nodeNo)) q:nodeNo=""  d
	. s nodeOID=nodes(nodeNo)
	. s nfound=$$select(sortPath,docOID,.sNodes,nodeOID)
	. s textOID=$g(sNodes(1))
	. s text=$$getData^%zewdDOM(textOID)
	. i text="" s text=" "
	. s nodeIndex(text,nodeOID)=""
	s text="",nodeNo=0
	f  s text=$o(nodeIndex(text)) q:text=""  d
	. s nodeOID=""
	. f  s nodeOID=$o(nodeIndex(text,nodeOID)) q:nodeOID=""  d
	. . s nodeNo=nodeNo+1
	. . s sortedNodes(nodeNo)=nodeOID
	;
	QUIT
	;
getXPathFromNode(nodeOID)
	QUIT $$getPath^%zewdCompiler5(nodeOID)
	;
