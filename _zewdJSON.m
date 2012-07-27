%zewdJSON	; Enterprise Web Developer JSON functions
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
 ;QUIT
 ;
parseJSON(jsonString,propertiesArray,mode)
 ;
 n array,arrRef,buff,c,error
 ;
 k propertiesArray
 s error=""
 s buff=$g(jsonString)
 s buff=$$removeSpaces(buff)
 s buff=$$replaceAll^%zewdAPI(buff,"\""","\'")
 s arrRef="array"
 s c=$e(buff,1)
 s buff=$e(buff,2,$l(buff))
 d
 . i c="{" d  q
 . . n prefix
 . . s prefix="""zobj1"""
 . . i $g(mode)=1 s prefix=""
 . . s error=$$parseJSONObject(.buff,prefix)
 . . q:error
 . . i buff'="" s error=1
 . i c="[" d  q
 . . n prefix
 . . s prefix=1
 . . i $g(mode)=1 s prefix=""
 . . s error=$$parseJSONArray(.buff,prefix)
 . . q:error
 . . i buff'="" s error=1
 . s error=1
 i error=1 QUIT "Invalid JSON"
 m propertiesArray=array
 QUIT ""
 ;
parseJSONObject(buff,subs)
 n c,error,name,stop,subs2,value,x
 s stop=0,name="",error=""
 f  d  q:stop
 . s c=$e(buff,1)
 . i c="" s error=1,stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . i c="[" s error=1,stop=1 q
 . i c="}" d  q
 . . s stop=1
 . i c=":" d  q
 . . n subs2
 . . s value=$$getJSONValue(.buff)
 . . d  q:stop
 . . . i value="" q
 . . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . . i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(value) q
 . . . s error=1,stop=1
 . . i value="",$e(buff,1)="{" d  q
 . . . i $e(name,1)'="""",$e(name,$l(name))'="""" s name=""""_name_""""
 . . . s subs2=subs
 . . . i subs'="" s subs2=subs2_","
 . . . s subs2=subs2_name
 . . . i $g(mode)="" s subs2=subs2_",""zobj1"""
 . . . s buff=$e(buff,2,$l(buff))
 . . . s error=$$parseJSONObject(.buff,subs2)
 . . . i error=1 s stop=1 q
 . . i value="",$e(buff,1)="[" d  q
 . . . ;s subs2=subs_","""_name_""",""1"""
 . . . i $e(name,1)'="""",$e(name,$l(name))'="""" s name=""""_name_""""
 . . . s subs2=subs
 . . . i subs'="" s subs2=subs2_","
 . . . s subs2=subs2_name
 . . . s buff=$e(buff,2,$l(buff))
 . . . s error=$$parseJSONArray(.buff,subs2)
 . . . i error=1 s stop=1 q
 . . i $e(name,1)="""",$e(name,$l(name))'="""" s error=1,stop=1 q
 . . i $e(name,1)'="""",$e(name,$l(name))="""" s error=1,stop=1 q
 . . i $e(name,1)'="""",$e(name,$l(name))'="""" s name=""""_name_""""
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_name
 . . i value["\'" s value=$$replaceAll^%zewdAPI(value,"\'","""""")
 . . s subs2=$$replaceAll^%zewdAPI(subs2,$c(2),":")
 . . s value=$$replaceAll^%zewdAPI(value,$c(2),":")
 . . s x="s "_arrRef_"("_subs2_")="_value
 . . x x
 . i c="," s name="" q
 . s name=name_c q
 QUIT error
 ;
parseJSONArray(buff,subs)
 n c,error,name,no,stop,subs2,value,x
 s stop=0,name="",no=0,error=""
 f  d  q:stop
 . s c=$e(buff,1)
 . i c="" s error=1,stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . i c=":" d  q:stop
 . . i name'="" q
 . . s error=1,stop=1
 . i c="]" d  q
 . . s stop=1
 . . i name="" q
 . . s no=no+1
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_no
 . . s subs2=$$replaceAll^%zewdAPI(subs2,$c(2),":")
 . . s name=$$replaceAll^%zewdAPI(name,$c(2),":")
 . . s x="s "_arrRef_"("_subs2_")="_name
 . . x x
 . i c="[" d  q
 . . s no=no+1
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_no
 . . ;s buff=$e(buff,2,$l(buff))
 . . s error=$$parseJSONArray(.buff,subs2)
 . . i error=1 s stop=1 q
 . i c="{" d  q
 . . s no=no+1
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_no
 . . i $g(mode)="" s subs2=subs2_",""zobj1"""
 . . ;s buff=$e(buff,2,$l(buff))
 . . s error=$$parseJSONObject(.buff,subs2)
 . . i error=1 s stop=1 q
 . s subs2=subs
 . i subs'="" s subs2=subs2_","
 . s subs2=subs2_""""_name_""""
 . i c="," d  q
 . . i name="" q
 . . d  q:stop
 . . . i $e(name,1)="""",$e(name,$l(name))="""" q
 . . . ;i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(name) q
 . . . s error=1,stop=1
 . . s no=no+1
 . . s subs2=subs
 . . i subs'="" s subs2=subs2_","
 . . s subs2=subs2_""""_no_""""
 . . s x="s "_arrRef_"("_subs2_")="_name
 . . x x
 . . s name=""
 . s name=name_c q
 QUIT error
 ;
getJSONValue(buff)
 n apos,c,isLiteral,lc,stop,value
 s stop=0,value="",isLiteral=0,lc=""
 f  d  q:stop  q:buff=""
 . s c=$e(buff,1)
 . i value="" d
 . . i c="""" s isLiteral=1,apos="""" q
 . . i c="'" s isLiteral=1,apos="'" q
 . i 'isLiteral,c="[" s stop=1 q
 . i 'isLiteral,c="{" s stop=1 q
 . i c="}" d  q:stop
 . . ;i isLiteral,lc'="""" q
 . . i isLiteral,lc'=apos q
 . . s stop=1
 . i c="," d  q:stop
 . . ;i isLiteral,lc'="""" q
 . . i isLiteral,lc'=apos q
 . . s stop=1
 . s buff=$e(buff,2,$l(buff))
 . s value=value_c
 . s lc=c
 i $e(value,1)="'" s value=""""_$e(value,2,$l(value)-1)_""""
 QUIT value
 ;
numeric(value)
 i $e(value,1,9)="function(" QUIT 1
 i value?1"0."1N.N QUIT 1
 i $e(value,1)=0,$l(value)>1 QUIT 0
 i $e(value,1,2)="-0",$l(value)>2,$e(value,1,3)'="-0." QUIT 0
 i value?1N.N QUIT 1
 i value?1"-"1N.N QUIT 1
 i value?1N.N1"."1N.N QUIT 1
 i value?1"-"1N.N1"."1N.N QUIT 1
 i value?1"."1N.N QUIT 1
 i value?1"-."1N.N QUIT 1
 QUIT 0
 ;
removeSpaces(string)
 ;
 n c,i,quote,quoted,outString
 ;
 s quoted=0,quote=""
 s outString=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . i $a(c)=9 q
 . i c="""" d
 . . i 'quoted d
 . . . s quoted=1
 . . . s quote=""""
 . . e  d
 . . . i quote="""" d
 . . . . s quoted=0
 . . . . s quote=""
 . i c="'" d
 . . i 'quoted d
 . . . s quoted=1
 . . . s quote="'"
 . . e  d
 . . . i quote="'" d
 . . . . s quoted=0
 . . . . s quote=""
 . i c=" ",'quoted q
 . i quoted,c=":" s c=$c(2)
 . s outString=outString_c
 ;
 QUIT outString
 ;
JSON2XML(jsonString,write)
 ;
 n array,arrRef,buff,c,error,no,xml,xmlText
 ;
 s xml=""
 k ^CacheTempEWD($j)
 i $g(write) d  i error'="" QUIT error
 . s error=$$validateJSON4XML(jsonString)
 k propertiesArray
 s error=""
 s buff=$g(jsonString)
 s arrRef="array"
 s c=$e(buff,1)
 s buff=$e(buff,2,$l(buff))
 i c="[" d
 . s buff="JSON:{Array:["_buff_"}}"
 . s c="{"
 i c="{" d
 . s error=$$JSON2XMLObject(.buff)
 . q:error
 . i buff'="" s error=1
 e  d
 . s error=1
 i error=1 QUIT "Invalid JSON syntax or invalid JSON representation of XML"
 s no=$increment(^CacheTempEWD($j))
 s ^CacheTempEWD($j,no)=xml
 QUIT ""
 ;
outputXML(text,xml)
 n no
 i $g(write) d
 . w text
 . s xml=""
 e  d
 . s xml=xml_text
 . i $l(xml)>15000 d
 . . s no=$increment(^CacheTempEWD($j))
 . . s ^CacheTempEWD($j,no)=xml
 . . s xml=""
 QUIT xml
 ;
JSON2XMLObject(buff,addedArray)
 n c,error,name,stop,value,x
 s stop=0,name="",error=""
 f  d  q:stop
 . s c=$e(buff,1)
 . i c="" s error=1,stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . i c="]"
 . i c="[" s error=1,stop=1 q
 . i c="}" d  q
 . . s stop=1
 . i c=":" d  q
 . . s value=$$getJSONValue(.buff)
 . . d  q:stop
 . . . i value="null" s value=""
 . . . i value="" q
 . . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . . i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(value) q
 . . . s error=1,stop=1
 . . i value="",$e(buff,1)="{" d  q
 . . . s xml=$$outputXML("<"_name_">",xml)
 . . . s buff=$e(buff,2,$l(buff))
 . . . s error=$$JSON2XMLObject(.buff)
 . . . i error=1 s stop=1 q
 . . . s xml=$$outputXML("</"_name_">",xml)
 . . i value="",$e(buff,1)="[" d  q
 . . . s buff=$e(buff,2,$l(buff))
 . . . s error=$$JSON2XMLArray(.buff,name)
 . . . i error=1 s stop=1 q
 . . . i $g(addedArray)=1 s buff="}"_buff
 . . i value="" d
 . . . s xml=$$outputXML("<"_name_" />",xml)
 . . e  d
 . . . i $e(value,1)="""",$e(value,$l(value))="""" s value=$e(value,2,$l(value)-1)
 . . . i name="#text" d
 . . . . s xmlText=value
 . . . e  d
 . . . . s xml=$$outputXML("<"_name_">"_value_"</"_name_">",xml)
 . i c="," s name="" q
 . s name=name_c q
 QUIT error
 ;
JSON2XMLArray(buff,name)
 n addedArray,c,error,stop,value,x
 s stop=0,value="",error="",addedArray=0
 f  d  q:stop
 . s c=$e(buff,1)
 . i c="" s error=1,stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . i c=":" s error=1,stop=1 q
 . i c="]" d  q
 . . s stop=1
 . . i value="" q
 . . d  q:error=1
 . . . i value="null" s value=""
 . . . i value="" q
 . . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . . i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(value) q
 . . . s error=1
 . . i $e(value,1)="""",$e(value,$l(value))="""" s value=$e(value,2,$l(value)-1)
 . . s xml=$$outputXML("<"_name_">"_value_"</"_name_">",xml)
 . i c="[" d
 . . s buff="Array:["_buff
 . . s addedArray=1
 . . s c="{"
 . i c="{" d  q
 . . n xmlText
 . . s xmlText=""
 . . s xml=$$outputXML("<"_name_">",xml)
 . . s error=$$JSON2XMLObject(.buff,addedArray)
 . . i xmlText'="" s xml=$$outputXML(xmlText,xml)
 . . s addedArray=0
 . . i error=1 s stop=1 q
 . . s xml=$$outputXML("</"_name_">",xml)
 . i c="," d  q
 . . i value="" q
 . . d  q:stop
 . . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . . i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(value) q
 . . . s error=1,stop=1
 . . i $e(value,1)="""",$e(value,$l(value))="""" s value=$e(value,2,$l(value)-1)
 . . w "<"_name_">"_value_"</"_name_">"
 . . s value=""
 . s value=value_c q
 QUIT error
 ;
validateJSON4XML(jsonString)
 ;
 n array,arrRef,buff,c,error
 ;
 k propertiesArray
 s error=""
 s buff=$g(jsonString)
 s arrRef="array"
 s c=$e(buff,1)
 s buff=$e(buff,2,$l(buff))
 i c="[" d
 . s buff="xml:{Array:["_buff_"}}"
 . s c="{"
 i c="{" d
 . s error=$$validateObject4XML(.buff)
 . q:error
 . i buff'="" s error=1
 e  d
 . s error=1
 i error=1 QUIT "Invalid JSON syntax or invalid JSON representation of XML"
 QUIT ""
 ;
validateObject4XML(buff,addedArray)
 n c,error,name,stop,value,x
 s stop=0,name="",error=""
 f  d  q:stop
 . s c=$e(buff,1)
 . i c="" s error=1,stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . i c="[" s error=1,stop=1 q
 . i c="}" d  q
 . . s stop=1
 . i c=":" d  q
 . . s value=$$getJSONValue(.buff)
 . . d  q:stop
 . . . i value="" q
 . . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . . i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(value) q
 . . . s error=1,stop=1
 . . i value="",$e(buff,1)="{" d  q
 . . . s buff=$e(buff,2,$l(buff))
 . . . s error=$$validateObject4XML(.buff)
 . . . i error=1 s stop=1 q
 . . i value="",$e(buff,1)="[" d  q
 . . . s buff=$e(buff,2,$l(buff))
 . . . s error=$$validateArray4XML(.buff,name)
 . . . i error=1 s stop=1 q
 . . . i $g(addedArray)=1 s buff="}"_buff
 . i c="," s name="" q
 . s name=name_c q
 QUIT error
 ;
validateArray4XML(buff,name)
 n addedArray,c,error,stop,value,x
 s stop=0,value="",error=""
 f  d  q:stop
 . s c=$e(buff,1)
 . i c="" s error=1,stop=1 q
 . s buff=$e(buff,2,$l(buff))
 . i c=":" s error=1,stop=1 q
 . i c="]" d  q
 . . s stop=1
 . . i value="" q
 . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . i value="true"!(value="false") s value=""""_value_"""" q
 . . i $$numeric(value) q
 . . s error=1
 . i c="[" d
 . . s buff="Array:["_buff
 . . s addedArray=1
 . . s c="{"
 . i c="{" d  q
 . . s error=$$validateObject4XML(.buff,addedArray)
 . . s addedArray=0
 . . i error=1 s stop=1 q
 . i c="," d  q
 . . i value="" q
 . . d  q:stop
 . . . i $e(value,1)="""",$e(value,$l(value))="""" q
 . . . i value="true"!(value="false") s value=""""_value_"""" q
 . . . i $$numeric(value) q
 . . . s error=1,stop=1
 . . s value=""
 . s value=value_c
 QUIT error
 ;
XML2JSON(nodeOID,write,response)
 ;
 n json,responseLineNo
 ;
 s json="",responseLineNo=1
 k response
 i nodeOID'?1N.N1"-"1N.N s nodeOID=$$getDocumentNode^%zewdDOM(nodeOID)
 i $g(nodeOID)="" QUIT ""
 i '$$nodeExists^%zewdDOM(nodeOID) QUIT ""
 d outputChars("{")
 s json=$$outputAsJSON(nodeOID)
 d outputChars("}")
 QUIT json
 ;
outputChars(text)
 i $g(write) d
 . w text
 e  d
 . s response(responseLineNo)=text,responseLineNo=responseLineNo+1
 QUIT
 ;
outputAsJSON(nodeOID)
 ;
 n json,nodeType
 ;
 s json=""
 s nodeType=$$getNodeType^%zewdDOM(nodeOID)
 i nodeType=9 d  Q json
 . n lastTag
 . s lastTag=$$outputChildren(nodeOID)
 ;
 i nodeType=1 d  Q json
 . n comma,tagName
 . s tagName=$$getTagName^%zewdDOM(nodeOID)
 . i $$hasAttributes^%zewdDOM(nodeOID)="false",'$$hasChildElements(nodeOID) d
 . . n lineNo,text,textArray
 . . s text=$$getElementText^%zewdDOM(nodeOID,.textArray)
 . . i text="",'$d(textArray) d  q
 . . .  d outputChars(tagName_":null")
 . . d outputChars(tagName_":""")
 . . i text'="***Array***" d  q
 . . . d outputChars(text_"""")
 . . s lineNo=""
 . . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . . d outputChars(textArray(lineNo))
 . . d outputChars("""")
 . e  d
 . . s comma=""
 . . d outputChars(tagName_":{")
 . . i $$hasAttributes^%zewdDOM(nodeOID)="true" d outputAttr(nodeOID) s comma=","
 . . i $$hasChildNodes^%zewdDOM(nodeOID)="true" d
 . . . d outputChars(comma)
 . . . s json=$$outputChildren(nodeOID)
 . . d outputChars("}")
 ;
 i nodeType=3 d  QUIT json
 . n lineNo,text,textArray
 . d outputChars("#text:""")
 . s text=$$getData^%zewdDOM(nodeOID,.textArray)
 . s lineNo=""
 . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . d outputChars(textArray(lineNo))
 . d outputChars("""")
 ;
 i nodeType=4 d  QUIT json
 . n lineNo,text,textArray
 . s text=$$getData^%zewdDOM(nodeOID,.textArray)
 . d outputChars("#CDATA:""")
 . s lineNo=""
 . f  s lineNo=$o(textArray(lineNo)) q:lineNo=""  d
 . . d outputChars(textArray(lineNo))
 . d outputChars("""")
 ;
 i nodeType=7 d  QUIT json
 . n comma,target,data
 . d outputChars("#ProcessingInstruction:{")
 . s target=$$getTarget^%zewdDOM(nodeOID)
 . s data=$$getData^%zewdDOM(nodeOID)
 . s comma=""
 . i target'="" d outputChars("Target:"""_target_"""") s comma=","
 . i data'="" d outputChars(comma_"Data:"""_data_"""")
 . d outputChars("}")
 ;
 i nodeType=8 d  QUIT json
 . n data
 . s data=$$getData^%zewdDOM(nodeOID)
 . d outputChars("#Comment:"""_data_"""")
 ;
 i nodeType=10 d  QUIT json
 . n publicId,systemId,qualifiedName
 . s qualifiedName=$$getTagName^%zewdDOM(nodeOID)
 . s publicId=$$getPublicId^%zewdDOM(nodeOID)
 . s systemId=$$getSystemId^%zewdDOM(nodeOID)
 . d outputChars("#DocumentType:{")
 . d outputChars("QualifiedName:"""_qualifiedName_"""")
 . d outputChars(",SystemId:"""_systemId_"""")
 . d outputChars(",PublicId:"""_publicId_"""")
 . d outputChars("}")
 ;
 QUIT ""
 ;
outputChildren(parentOID)
 ;
 n childOID,comma,comma2,json,n,no,nodeType,others,siblingOID,tagArray,tagName
 ;
 s json="",no=1
 s childOID=$$getFirstChild^%zewdDOM(parentOID)
 i childOID'="" d
 . s nodeType=$$getNodeType^%zewdDOM(childOID)
 . i nodeType=1 d
 . . s tagName=$$getTagName^%zewdDOM(childOID)
 . . s no=$increment(tagArray(tagName))
 . . s tagArray(tagName,no)=childOID,no=no+1
 . e  d
 . . s others(no)=childOID,no=no+1
 . s siblingOID=childOID
 . f  s siblingOID=$$getNextSibling^%zewdDOM(siblingOID) q:siblingOID=""  d
 . . s nodeType=$$getNodeType^%zewdDOM(siblingOID)
 . . i nodeType=1 d
 . . . s tagName=$$getTagName^%zewdDOM(siblingOID)
 . . . s n=$increment(tagArray(tagName))
 . . . s tagArray(tagName,no)=siblingOID,no=no+1
 . . e  d
 . . . s others(no)=siblingOID,no=no+1
 ;
 s tagName="",comma=""
 ; Deal with others
 i $d(others) d
 . s no=""
 . f  s no=$o(others(no)) q:no=""  d
 . . s childOID=others(no)
 . . d outputChars(comma)
 . . s json=$$outputAsJSON(childOID),comma=","
 f  s tagName=$o(tagArray(tagName)) q:tagName=""  d
 . i tagArray(tagName)=1 d
 . . s no=$o(tagArray(tagName,""))
 . . s childOID=tagArray(tagName,no)
 . . d outputChars(comma) 
 . . s json=$$outputAsJSON(childOID)
 . . s comma=","
 . . s siblingOID=childOID
 . e  d
 . . n comma1
 . . s comma1=""
 . . d outputChars(comma_tagName_":[")
 . . s no=""
 . . f  s no=$o(tagArray(tagName,no)) q:no=""  d
 . . . s childOID=tagArray(tagName,no)
 . . . d outputChars(comma1_"{") 
 . . . s comma2=""
 . . . i $$hasAttributes^%zewdDOM(childOID)="true" d outputAttr(childOID) s comma2=","
 . . . i $$hasChildNodes^%zewdDOM(childOID)="true" d
 . . . . d outputChars(comma2) 
 . . . . s json=$$outputChildren(childOID),comma=","
 . . . d outputChars("}")  
 . . . s comma1=","
 . . d outputChars("]")
 . . s comma=","
 QUIT json
 ;
outputAttr(nodeOID)
 ;
 n comma,d,ok,attrArray,attrOID
 ;
 s ok=$$getAttributes^%zewdDOM(nodeOID,.attrArray)
 s attrOID="",comma=""
 f  s attrOID=$o(attrArray(attrOID)) q:attrOID=""  d
 . s d=attrArray(attrOID)
 . d outputChars(comma_$p(d,$c(1),1)_":"""_$p(d,$c(1),2)_"""")
 . s comma=","
 QUIT
 ;
hasChildElements(nodeOID)
 ;
 n fc,stop
 ;
 s stop=0
 s fc=$$getFirstChild^%zewdDOM(nodeOID)
 i fc="" QUIT 0
 i $$getNodeType^%zewdDOM(fc)=1 QUIT 1
 f  s fc=$$getNextSibling^%zewdDOM(fc) q:fc=""  d  q:stop
 . i $$getNodeType^%zewdDOM(fc)=1 s stop=1
 QUIT stop
 ;
arrayToJSON(name)
 n subscripts
 i '$d(@name) QUIT "[]"
 QUIT $$walkArray("",name)
 ;
walkArray(json,name,subscripts)
 ;
 n allNumeric,arrComma,brace,comma,count,cr,dd,i,no,numsub,dblquot,quot
 n ref,sub,subNo,subscripts1,type,valquot,value,xref,zobj
 ;
 s cr=$c(13,10),comma=","
 s (dblquot,valquot)=""""
 s dd=$d(@name)
 i dd=1!(dd=11) d  i dd=1 QUIT json
 . s value=@name
 . i value'[">" q
 . s json=$$walkArray(json,value,.subscripts)
 s ref=name_"("
 s no=$o(subscripts(""),-1)
 i no>0 f i=1:1:no d
 . s quot=""""
 . i subscripts(i)?."-"1N.N s quot=""
 . s ref=ref_quot_subscripts(i)_quot_","
 s ref=ref_"sub)"
 s sub="",numsub=0,subNo=0,count=0
 s allNumeric=1
 f  s sub=$o(@ref) q:sub=""  d  q:'allNumeric
 . i sub'?1N.N s allNumeric=0
 . s count=count+1
 . i sub'=count s allNumeric=0
 ;i allNumeric,count=1 s allNumeric=0
 i allNumeric d
 . s json=json_"["
 e  d
 . s json=json_"{"
 s sub=""
 f  s sub=$o(@ref) q:sub=""  d
 . s subscripts(no+1)=sub
 . s subNo=subNo+1
 . s dd=$d(@ref)
 . i dd=1 d
 . . s value=@ref 
 . . i 'allNumeric d
 . . . s json=json_""""_sub_""":"
 . . s type="literal"
 . . i $$numeric(value) s type="numeric"
 . . ;i value?1N.N s type="numeric"
 . . ;i value?1"-"1N.N s type="numeric"
 . . ;i value?1N.N1"."1N.N s type="numeric"
 . . ;i value?1"-"1N.N1"."1N.N s type="numeric"
 . . i value="true"!(value="false") s type="boolean"
 . . i $e(value,1)="{",$e(value,$l(value))="}" s type="variable"
 . . i $e(value,1,4)="<?= ",$e(value,$l(value)-2,$l(value))=" ?>" d
 . . . s type="variable"
 . . . s value=$e(value,5,$l(value)-3)
 . . i type="literal" s value=valquot_value_valquot
 . . d
 . . . s json=json_value_","
 . k subscripts1
 . m subscripts1=subscripts
 . i dd>9 d
 . . i sub?1N.N,allNumeric d
 . . . i subNo=1 d
 . . . . s numsub=1
 . . . . s json=$e(json,1,$l(json)-1)
 . . . . s json=json_"["
 . . e  d
 . . . s json=json_""""_sub_""":"
 . . s json=$$walkArray(json,name,.subscripts1)
 . . d
 . . . s json=json_","
 ;
 s json=$e(json,1,$l(json)-1)
 i allNumeric d
 . s json=json_"]"
 e  d
 . s json=json_"}"
 QUIT json ; exit!
 ;
streamJSON(sessionName,return,var,sessid)
 ;
 n array
 ;
 d mergeArrayFromSession^%zewdAPI(.array,sessionName,sessid)
 i $g(var) w "var "
 w $g(return)_"="
 d streamArrayToJSON("array")
 w ";"
 ;
 QUIT
 ;
writeLine(line,technology)
 i technology="node" d
 . s ^CacheTempBuffer($j,$increment(^CacheTempBuffer($j)))=line
 e  d
 . w line
 QUIT
 ;
streamArrayToJSON(name)
 n line,subscripts,technology
 ;
 s technology=$$getSessionValue^%zewdAPI("ewd.technology",sessid)
 i technology="",$zv["Cache" s technology="wl"
 i technology="" s technology="gtm"
 ;
 i '$d(@name) d  QUIT
 . s line="[]"
 . d writeLine(line,technology)
 d streamWalkArray(name,,technology)
 QUIT
 ;
streamWalkArray(name,subscripts,technology)
 ;
 n allNumeric,arrComma,brace,comma,cr,dd,i,json,no,numsub,dblquot,quot,ref,sub,subNo,subscripts1,type,valquot,value,xref,zobj
 ;
 i '$d(technology) d
 . s technology=$$getSessionValue^%zewdAPI("ewd.technology",sessid)
 . i technology="",$zv["Cache" s technology="wl"
 . i technology="" s technology="gtm"
 ;
 s json=""
 s cr=$c(13,10),comma=","
 s (dblquot,valquot)=""""
 s dd=$d(@name)
 i dd=1!(dd=11) d  i dd=1 d writeLine(json,technology) QUIT
 . s value=@name
 . i value'[">" q
 . d writeLine(json,technology) s json=""
 . d streamWalkArray(value,.subscripts)
 s ref=name_"("
 s no=$o(subscripts(""),-1)
 i no>0 f i=1:1:no d
 . s quot=""""
 . i subscripts(i)?."-"1N.N s quot=""
 . s ref=ref_quot_subscripts(i)_quot_","
 s ref=ref_"sub)"
 s sub="",numsub=0,subNo=0
 s allNumeric=1
 f  s sub=$o(@ref) q:sub=""  d  q:'allNumeric
 . i sub'?1N.N s allNumeric=0
 i allNumeric d
 . s json=json_"["
 e  d
 . s json=json_"{"
 s sub=""
 f  s sub=$o(@ref) q:sub=""  d
 . s subscripts(no+1)=sub
 . s subNo=subNo+1
 . s dd=$d(@ref)
 . i dd=1 d
 . . s value=@ref 
 . . i 'allNumeric d
 . . . s json=json_""""_sub_""":"
 . . s type="literal"
 . . i $$numeric(value) s type="numeric"
 . . ;i value?1N.N s type="numeric"
 . . ;i value?1"-"1N.N s type="numeric"
 . . ;i value?1N.N1"."1N.N s type="numeric"
 . . ;i value?1"-"1N.N1"."1N.N s type="numeric"
 . . i value="true"!(value="false") s type="boolean"
 . . i $e(value,1)="{",$e(value,$l(value))="}" s type="variable"
 . . i $e(value,1,4)="<?= ",$e(value,$l(value)-2,$l(value))=" ?>" d
 . . . s type="variable"
 . . . s value=$e(value,5,$l(value)-3)
 . . i type="literal" s value=valquot_value_valquot
 . . d
 . . . s json=json_value_","
 . k subscripts1
 . m subscripts1=subscripts
 . i dd>9 d
 . . i sub?1N.N d
 . . . i subNo=1 d
 . . . . s numsub=1
 . . . . s json=$e(json,1,$l(json)-1)_"["
 . . e  d
 . . . s json=json_""""_sub_""":"
 . . d writeLine(json,technology) s json=""
 . . d streamWalkArray(name,.subscripts1)
 . . d
 . . . s json=json_","
 ;
 s json=$e(json,1,$l(json)-1)
 i allNumeric d
 . s json=json_"]"
 e  d
 . s json=json_"}"
 d writeLine(json,technology)
 QUIT
 ;
