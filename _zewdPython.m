%zewdPython	;Enterprise Web Developer Python interfaces
 ;
 ; Product: Enterprise Web Developer (Build 838)
 ; Build Date: Tue, 25 Jan 2011 16:34:10
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
	;
	QUIT
	;
runPythonScript(script,sessid)
 ;
 n functionName,moduleName
 ;
 d deleteFromSession^%zewdAPI("ewd_request",sessid)
 d mergeArrayToSession^%zewdAPI(.requestArray,"ewd_request",sessid)
 i $e(script,1,3)="py:" s script=$e(script,4,$l(script))
 s moduleName=$p(script,".",1)
 s functionName=$p(script,".",2)
 QUIT $$runPythonMethod(moduleName,functionName,sessid)
 ;
runPythonMethod(moduleName,functionName,sessid)
 n command,i,io,line,max,p,result,response
 s io=$io
 s p="python"
 s command="import "_moduleName_";print "_moduleName_"."_functionName_"("_sessid_")"
 s command="python -c '"_command_"'"
 o p:(COMMAND=command)::"PIPE"
 u p
 f i=1:1 r line q:$ZEOF  s response(i)=line
 c p
 u io
 s result=response(1)
 s max=$o(response(""),-1)
 i max>1 d
 . f i=2:1:max s result=result_"; "_response(i)
 QUIT result
 ;
compilePage(app,page)
 d compilePage^%zewdCompiler($g(app),$g(page))
 QUIT ""
 ;
compileAll(app)
 d compileAll^%zewdCompiler($g(app))
 QUIT ""
 ;
setSessionValue(name,value,sessid)
 d setSessionValue^%zewdAPI($g(name),$g(value),$g(sessid))
 QUIT ""
 ;
deleteFromSession(name,sessid)
 d deleteFromSession^%zewdAPI($g(name),$g(sessid))
 QUIT ""
 ;
appendToList(listName,textValue,codeValue,sessid)
 d appendToList^%zewdAPI($g(listName),$g(textValue),$g(codeValue),$g(sessid))
 QUIT ""
 ;
createDataTableStore(dataStoreName,sessid)
 n dic
 d mergeArrayFromSession^%zewdAPI(.dic,"yuiTemp",sessid)
 d createDataTableStore^YUITags(.dic,dataStoreName,sessid)
 QUIT ""
 ;
createiWDMenuFromDictionary(keyName,sessionName,sessid)
 n dic,menu,no,value
 d mergeArrayFromSession^%zewdAPI(.dic,"yuiTemp",sessid)
 s no=""
 f  s no=$o(dic(no)) q:no=""  d
 . i '$d(dic(no,keyName)) q
 . s value=dic(no,keyName)
 . s menu(no,"text")=value
 d deleteFromSession^%zewdAPI(sessionName,sessid)
 d mergeArrayToSession^%zewdAPI(.menu,sessionName,sessid)
 QUIT ""
 ;
test(value)
 QUIT value+10
 ;
trace(string)
 d trace^%zewdAPI(string)
 QUIT ""
 ;
