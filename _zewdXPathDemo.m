%zewdXPathDemo ; Demonstration of EWD's XPath capabilities
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
run ;
 n desc,docName,docOID,error,i,line,nodes,ok,query,stop,xml
 ;
 s error=""
 s docName="XPathTestDOM"
 ;
 ; Build list of XPath queries
 f i=1:1 DO  QUIT:query="END"
 . s line=$T(query+i)
 . s query=$P(line,";;",2)
 . s desc=$P(line,";;",3)
 . QUIT:query="END"
 . s query(i)=query
 . s desc(i)=desc
 ;Build test XML document
 f i=1:1 DO  QUIT:line="END"
 . s line=$T(xml+i)
 . s line=$P(line,";;",2)
 . QUIT:line="END"
 . s xml(i)=line
 ; Parse the XML document into a DOM
 ; This demonstrates how to parse an XML document that is held in a global or local array
 ; first merge it into the reserved temp global ^CacheTempEWD($j)
 k ^CacheTempEWD($j)
 m ^CacheTempEWD($j)=xml
 ; then run the EWD parser via the following API  (0 = this is XML, not HTML)
 s error=$$parseDocument^%zewdHTMLParser(docName,0)
 k ^CacheTempEWD($j)
 i error'="" w !,error QUIT
 ;
 s docOID=$$getDocumentNode^%zewdDOM(docName)
 ;Run the queries one by one
 s stop=0
 f i=1:1 QUIT:'$d(query(i))  DO  QUIT:error'=""  QUIT:stop
 . s error=$$runQuery(i)
 . QUIT:error'=""
 . w !,"------------------",!,"press Enter to continue, anything else to stop " r ok
 . i ok'="" s stop=1
 ;
end
 i $$removeDocument^%zewdDOM(docName)
 i error'="" w !,error
 QUIT
 ;
runQuery(i) ;
 ; Run an example XPath Query
 n error
 s error=$$select^%zewdXPath(query(i),docOID,.nodes)
 i error'?1.n,error'="" QUIT error
 w !!,"Query : ",query(i),!
 w !,desc(i),!!
 d displayNodes^%zewdXPath(.nodes)
 QUIT ""
 ;
query	; example XPath queries
	;;/child::doc;;Get the root node
	;;/doc;;Abbreviated syntax for getting the root node
	;;/child::doc/child::foo;;Get all <foo> elements that are children of the <doc> root node
	;;/doc/foo;;Abbreviated syntax for getting all <foo> elements that are children of the <doc> root node
	;;//foo;;Get all <foo> nodes
	;;/doc/foo/bar;;Get all <bar> nodes that are children of <foo> nodes, and grandchildren of the <doc> nodes
	;;/doc/foo/*;;Get all nodes that are children of <foo> nodes and grandchildren of the <doc> node
	;;/doc/aaa/descendant::*;;Get all descendants of <aaa> nodes that are children of the <doc> node
	;;//foo/descendant::*;;Get all descendants of all <foo> nodes
	;;//aaa/descendant::bar;;Get all <bar> nodes that have <aaa> as an ancestor
	;;//bar/parent::*;;Get parents of all <bar> nodes
	;;/doc/foo/bar/ancestor::*;;Get all elements in the path, excluding <bar> nodes
	;;/doc/foo/bar/*/ancestor::*;;Get all elements in the path, including <bar> nodes
	;;//bar/ancestor::*;;Get all ancestors of <bar> nodes
	;;/doc/foo[1]/following-sibling::*;;All following siblings of the first <foo> node
	;;//bar[2]/following-sibling::*;;All following siblings of the second <bar> node
	;;/doc/aaa/preceeding-sibling::*;;All siblings preceeding the <aaa> tag
	;;//*;;Return all nodes (apart from attribute nodes)
	;;//node();;Also returns all nodes (apart from attribute nodes)
	;;/descendant::*;;Select all descendants of the root node, so select all nodes
	;;//bar;;Get all <bar> nodes
	;;//foo/bar;;Get <bar> nodes that are children of all <foo> nodes
	;;/*/*/*/bar;;Get all <bar> nodes that have 3 ancestors
	;;//bar/attribute::name;;Get "name=" attributes for all <bar> nodes
	;;//bar/attribute::node();;Get all attributes for all <bar> nodes
	;;//attribute::name;;Get all "name=" attributes
	;;//@name;;Abbreviated syntax for getting all "name=" attributes
	;;//bar[@name];;Get all <bar> nodes that have a "name=" attribute
	;;//bar[@closed];;Get all <bar> nodes that have a "closed=" attribute
	;;//bar[@*];;Get all <bar> nodes that have attributes
	;;//foo[not(@*)];;Get all <foo> nodes that don't have attributes
	;;//bar[@name="Grogan's"];;Get all <bar> nodes with a name="Grogan's" attribute
	;;//bar[./@name="Grogan's"];;Synonymous with the above: Get all <bar> nodes with a name="Grogan's" attribute
	;;/doc/foo/bar[.='pub 5'];;Get all <bar> nodes that are children of <foo> nodes and grandparents of the <doc> node, with a text value of "pub 5"
	;;/doc/foo[./bar='pub 5'];;Get all <foo> nodes that are children of the <doc> node and have a <bar> child node with a text value of "pub 5"
	;;//bar[3];;Get the third <bar> node from the complete set of all <bar> nodes
	;;//foo/bar[2];;Get the second <bar> node from those that are children of all <foo> nodes
	;;//bar[last()];;Get the last <bar> node from the set of all <bar> nodes
	;;//foo[2]/bar[3];;Get the third <bar> node from those that are children of the second <foo> node
	;;//foo[1]/bar[last()];;Get the last <bar> node from those that are children of the first  <foo> node
	;;//bar[parent::*/@location = 'Drumcondra'];;Get all <bar> nodes whose parent has a location attribute of "Drumcondra"
	;;//bar[position()>3][2];;First get the fourth and higher <bar> nodes, then select the second from that set (ie get the 5th one)
	;;//bar[contains(@name,'ogan')][parent::*/@location = 'Town'];;Get the <bar> nodes that have a "name=" attribute that contains "ogan", and whose parent node has a "location=" attribute of "Town"
	;;//bar[contains(@name,'ogan') & (parent::*/@location = 'Town')];;Synonymous with the previous query
	;;//bar[2][parent::*/@location = 'Drumcondra'];;Get the second <bar> tag, and only include it if its parent's "location=" attribute is "Drumcondra"
	;;//bar[starts-with(@owner,'Jo')];;Get all <bar> nodes whose "owner=" attribute starts with "Jo"
	;;//bar[starts-with(@owner,'J')];;Get all <bar> nodes whose "owner=" attribute starts with "J"
	;;//bar[starts-with(.,'pub');;Get all <bar> nodes whose text value starts with "pub"
	;;//bar[contains(@name,'ogan')];;Get all <bar> nodes whose "name=" attribute contains "ogan"
	;;//bar[contains(@name,'ogan')][2];;Get the second <bar> node whose "name=" attribute contains "ogan"
	;;//bar[2][contains(@name,'ogan')];;Get the second <bar> tag, and only include it if its "name=" attribute contains "ogan"
	;;//bar[2][contains(@name,'agan')];;Get the second <bar> tag, and only include it if its "name=" attribute contains "agan"
	;;"//bar[2][contains(@name,'ogan')];;This query has an erroneous quote at the start, so returns no nodes
	;;//bar[./[@name];;This query has an extra [ so returns no nodes
	;;END
	;
xml	; example xml document
	;;<?xml version="1.0"?>
	;;    <doc>
	;;      <foo location="Drumcondra">
	;;        <bar name="Cat and Cage">pub 1</bar>
	;;        <bar name="Fagan's" owner="John" tied="true">pub 2</bar>
	;;        <offlicense name="oddbins"/>
	;;        <bar name="Gravedigger's">pub 3</bar>
	;;        <bar name="Ivy House">pub 4</bar>
	;;      </foo>
	;;      <foo location="Town">
	;;        <bar name="Peter's Pub">pub 5</bar>
	;;        <bar name="Grogan's">pub 6</bar>
	;;        <bar name="Hogans's">club 1</bar>
	;;        <bar name="Brogan's" tied="false" owner="James">pub 8</bar>
	;;        <bar closed="yes">pub 9</bar>
	;;        <offlicense name="unwins"/>
	;;      </foo>
	;;      <aaa>
	;;         <bbb>
	;;            <bar name="Robin Hood">pub 10
	;;               <beer name="guinness"/>
	;;               <beer name="tetleys"/>
	;;            </bar>
	;;            <bar>As yet un-named pub</bar>
	;;         </bbb>
	;;         <foo>
	;;            <ccc/>
	;;         </foo>
	;;      </aaa>
	;;    </doc>
	;;END
