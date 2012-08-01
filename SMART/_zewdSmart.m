%zewdSmart ; Smart App Support Code
 ;
 ; Product: Enterprise Web Developer (Build 933)
 ; Build Date: Wed, 01 Aug 2012 10:08:05
 ; 
 ; +---------------------------------------------------------------------------+
 ; | Enterprise Web Developer for GT.M and m_apache                            |
 ; | Copyright (c) 2004-12 M/Gateway Developments Ltd,                         |
 ; | Reigate, Surrey UK.                                                       |
 ; | All rights reserved.                                                      |
 ; |                                                                           |
 ; | http://www.mgateway.com                                                   |
 ; | Email: rtweed@mgateway.com                                                |
 ; |                                                                           |
 ; |   Licensed under the Apache License, Version 2.0 (the "License")          |
 ; |   you may not use this file except in compliance with the License.        |
 ; |   You may obtain a copy of the License at                                 |
 ; |                                                                           |
 ; |       http://www.apache.org/licenses/LICENSE-2.0                          |
 ; |                                                                           |
 ; |   Unless required by applicable law or agreed to in writing, software     |
 ; |   distributed under the License is distributed on an "AS IS" BASIS,       |
 ; |   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.|
 ; |   See the License for the specific language governing permissions and     |
 ; |   limitations under the License.                                          |
 ; +---------------------------------------------------------------------------+
 ;
 ;
 QUIT
 ;
container(nodeOID)
 ;
 n attr,rdfMethod,tempOID,text,xOID
 ;
 ; Add script tags etc for integration with Smart Apps
 ;
 s rdfMethod=$$getAttribute^%zewdDOM("rdfmethod",nodeOID)
 i rdfMethod="" s rdfMethod="vistRDF^%zewdSmart"
 d removeAttribute^%zewdDOM("smartcontainer",nodeOID)
 d removeAttribute^%zewdDOM("rdfmethod",nodeOID)
 ;
 s tempOID=$$insertNewFirstChildElement^%zewdDOM(nodeOID,"temp",docOID)
 s attr("src")="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",tempOID,,.attr)
 s attr("src")="http://sample-apps.smartplatforms.org/framework/smart/scripts/jschannel.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",tempOID,,.attr)
 s attr("src")="http://sandbox.smartplatforms.org/static/smart_common/resources/smart-api-container.js"
 s xOID=$$addElementToDOM^%zewdDOM("script",tempOID,,.attr)
 s text="var SMART=new SMART_CONNECT_HOST();"_$c(13,10)
 s text=text_"SMART.get_credentials_tokenised = function (app_instance, token, callback){"_$c(13,10)
 s text=text_"  var url='"_$$smartURL("SMART","getCredentials")_"';"_$c(13,10)
 ;s text=text_"  alert(JSON.stringify(app_instance));"_$c(13,10)
 s text=text_"  url=url + 'token=' + token + '&manifestId=' + app_instance.manifest.id;"_$c(13,10)
 s text=text_"  var success = function(data, status_code, xhr) {"_$c(13,10)
 s text=text_"    console.log(xhr.responseText);"
 s text=text_"    callback(JSON.parse(xhr.responseText));"_$c(13,10)
 s text=text_"  };"_$c(13,10)
 s text=text_"  var error = function(xhr, textStatus, error) {"_$c(13,10)
 s text=text_"    var ct = xhr.getResponseHeader('Content-Type#') || 'unknown';"_$c(13,10)
 s text=text_"    callback (xhr.status, {contentType: ct.split(';')[0], data: xhr.responseText});"_$c(13,10)
 s text=text_"  };"_$c(13,10)
 ;s text=text_"  alert('url=' + url);"_$c(13,10)
 s text=text_"  $.ajax({type: 'get', url: url, dataType: 'text'}).success(success).error(error);"_$c(13,10)
 ;
 s text=text_"};"_$c(13,10)
 s text=text_"SMART.get_iframe=function(app_instance, callback){"_$c(13,10)
 s text=text_"  var frame_id='app_iframe_'+app_instance.uuid;"_$c(13,10)
 s text=text_"  var iframe_str=""<iframe src='about:blank;' id='""+frame_id+""' height='100%' width='100%' scrolling='yes'></iframe>"";"_$c(13,10)
 s text=text_"  var iframe=$(iframe_str);"_$c(13,10)
 s text=text_"  var smartFrame = app_instance.context.frame;"_$c(13,10)
 s text=text_"  document.getElementById(smartFrame).innerHTML = '';"_$c(13,10)
 s text=text_"  var panelDiv = '#' + smartFrame;"_$c(13,10)
 s text=text_"  $(panelDiv).append(iframe);"_$c(13,10)
 s text=text_"  callback(iframe[0]);"_$c(13,10)
 s text=text_"};"_$c(13,10)
 s text=text_"SMART.launchApp=function(id,divId) {"_$c(13,10)
 s text=text_"  SMART.simple_context.frame = divId;"_$c(13,10)
 s text=text_"  SMART.launch_app(SMART.manifest[id], SMART.simple_context);"_$c(13,10)
 s text=text_"};"_$c(13,10)
 s text=text_"SMART.handle_api_tokenised = function(app_instance, api_call, token, callback_success, callback_error) {"_$c(13,10)
 s text=text_"  var url='"_$$smartURL()_"';"_$c(13,10)
 s text=text_"  var pieces=api_call.func.split('/');"_$c(13,10)
 s text=text_"  url=url + 'record=' + pieces[1] + '&patientId=' + pieces[2] + '&method=' + pieces[3] + '&token=' + token;"_$c(13,10)
 ;s text=text_"  alert(url);"_$c(13,10)
 ;s text=text_"  var url = '/smart' + api_call.func + '?token=' + token;"_$c(13,10)
 s text=text_"  var success = function(data, status_code, xhr) {"_$c(13,10)
 s text=text_"    var ct = xhr.getResponseHeader('Content-Type') || 'unknown';"_$c(13,10)
 s text=text_"    callback_success({contentType: ct.split(';')[0], data: data});"_$c(13,10)
 s text=text_"  };"_$c(13,10)
 s text=text_"  var error = function(xhr, textStatus, error) {"_$c(13,10)
 s text=text_"    var ct = xhr.getResponseHeader('Content-Type#') || 'unknown';"_$c(13,10)
 s text=text_"    callback_error (xhr.status, {contentType: ct.split(';')[0], data: xhr.responseText});"_$c(13,10)
 s text=text_"  };"_$c(13,10)
 s text=text_"  $.ajax({type: 'get', url: url, dataType: 'text'}).success(success).error(error);"_$c(13,10)
 s text=text_"};"_$c(13,10)
 s xOID=$$addElementToDOM^%zewdDOM("script",tempOID,,.attr,text) 
 s text=" d writeManifests^%zewdSmart("""_rdfMethod_""",sessid)"
 s xOID=$$addCSPServerScript^%zewdAPI(tempOID,text)
 d removeIntermediateNode^%zewdDOM(tempOID)
 ;
 QUIT
 ;
authorise(sessid)
 n token
 s token=$$getSessionValue^%zewdAPI("ewd_token",sessid)
 d setSessionValue^%zewdAPI("SMART.token",token,sessid)
 QUIT token
 ;
smartURL(app,page)
 n extension,url
 ;
 i $g(technology)="" s technology="gtm"
 i $g(app)="" s app="SMART"
 i $g(page)="" s page="run"
 s extension=".mgwsi"
 s url=$$getRootURL^%zewdCompiler(technology)_app_"/"_page_extension_"?"
 QUIT url
 ;
addManifest(filepath)
 ;
 n ok,manifest
 ;
 s ok=$$importFile^%zewdHTMLParser(filepath)
 i ok d
 . n array,dlim,i,id,line,lineNo,np
 . s lineNo="",manifest=""
 . f  s lineNo=$o(^CacheTempEWD($j,lineNo)) q:lineNo=""  d
 . . s line=^CacheTempEWD($j,lineNo)
 . . s dlim=$c(10) i line[$c(13,10) s dlim=$c(13,10)
 . . s np=$l(line,dlim)
 . . f i=1:1:np s manifest=manifest_$p(line,dlim,i)
 . s ok=$$parseJSON^%zewdJSON(manifest,.array,1)
 . i ok="" d
 . . s id=$g(array("id"))
 . . i id'="" d
 . . . i $g(array("name"))="" s ok="Missing Name" q
 . . . i $g(array("author"))="" s ok="Missing Author" q
 . . . i $g(array("description"))="" s ok="Missing Description" q
 . . . i $g(array("index"))="" s ok="Missing Index URL" q
 . . . k ^SMART("manifest",id)
 . . . m ^SMART("manifest",id)=array
 . . e  d
 . . . s ok="Missing Id"
 ;
 QUIT ok
 ;
removeSpaces(string)
 ;
 n c,i,quoted,outString
 ;
 s quoted=0
 s outString=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . i $a(c)=9 q
 . i c="""" s quoted='quoted
 . i c=" ",'quoted q
 . s outString=outString_c
 ;
 QUIT outString
 ;
writeManifests(rdfMethod,sessid) ;
 ;
 n id,manifest,token
 ;
 w "SMART.manifest=[];"_$c(13,10)
 s id=""
 f  s id=$o(^SMART("manifest",id)) q:id=""  d
 . k manifest
 . m manifest=^SMART("manifest",id)
 . w "SMART.manifest['"_id_"']="
 . d streamArrayToJSON^%zewdJSON("manifest")
 . w ";"_$c(13,10)
 s token=$$authorise(sessid)
 w "SMART.handle_api = function(app_instance, api_call, callback_success, callback_error) {"_$c(13,10)
 w "  SMART.handle_api_tokenised(app_instance, api_call, '"_token_"', callback_success, callback_error);"_$c(13,10)
 w "};"_$c(13,10)
 w "SMART.get_credentials = function(app_instance, callback) {"_$c(13,10)
 w "  SMART.get_credentials_tokenised(app_instance, '"_token_"', callback);"_$c(13,10)
 w "};"_$c(13,10)
 d setSessionValue^%zewdAPI("SMART_rdfMethod",rdfMethod,sessid)
 QUIT
 ;
login(sessid)
 n username,password
 d clearFieldErrors^%zewdExt4Code(sessid)
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 s password=$$getSessionValue^%zewdAPI("password",sessid)
 s error="Invalid login attempt"
 d
 . i username="" d setFieldError^%zewdExt4Code("username","You must enter a username",sessid) q
 . i password="" d setFieldError^%zewdExt4Code("password","You must enter a password",sessid) q
 . i '$d(^SMART("authentication")) d
 . . i username="admin",password="admin" q
 . . d loginError
 . e  d
 . . i '$d(^SMART("authentication",username)) d loginError q
 . . n encPassword
 . . s encPassword=$$encodePassword(password)
 . . i $g(^SMART("authentication",username))'=encPassword d loginError
 QUIT $$formErrors^%zewdExt4Code(sessid)
 ;
loginError
 n error
 s error="Invalid login attempt"
 d setFieldError^%zewdExt4Code("username",error,sessid)
 d setFieldError^%zewdExt4Code("password",error,sessid)
 QUIT
 ;
encodePassword(password)
 n context
 s context=1
 i $d(^zewd("config","MGWSI")) s context=0
 QUIT $$SHA1^%ZMGWSIS(password,1,context)
 ;
demoEnabled(sessid)
 i '$d(^SMART("manifest","api-verifier@apps.smartplatforms.org")) QUIT "API Verifier Manifest not available"
 QUIT ""
 ;
getUsers(sessid)
 ;
 n id,user,no
 ;
 s id="",no=0
 f  s id=$o(^SMART("authentication",id)) q:id=""  d
 . s no=no+1
 . s user(no,"username")=id
 d setSessionValue^%zewdAPI("lastUserNo",no,sessid)
 d mergeArrayToSession^%zewdAPI(.user,"users",sessid)
 QUIT ""
 ;
saveUser(sessid)
 n lastUserNo,manifest,password,username,users
 d setFieldErrorAlert^%zewdExt4Code("Authentication Error","The user details you entered are invalid",sessid)
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 s password=$$getSessionValue^%zewdAPI("password",sessid)
 d
 . i username="" d setFieldError^%zewdExt4Code("username","Username must be defined",sessid) q
 . i $d(^SMART("authentication",username)) d setFieldError^%zewdExt4Code("username","Username already exists",sessid) q
 . i password="" d setFieldError^%zewdExt4Code("password","Password must be defined",sessid) q
 . s password=$$encodePassword(password)
 . s ^SMART("authentication",username)=password
 . ; synchronise local session array with displayed grid
 . s manifest="{username:'"_username_"'}"
 . d setSessionValue^%zewdAPI("userJSON",manifest,sessid)
 . s lastUserNo=$$getSessionValue^%zewdAPI("lastUserNo",sessid)+1
 . d setSessionValue^%zewdAPI("lastUserNo",lastUserNo,sessid)
 . d mergeArrayFromSession^%zewdAPI(.users,"users",sessid)
 . s users(lastUserNo)=username
 . d deleteFromSession^%zewdAPI("users",sessid)
 . d mergeArrayToSession^%zewdAPI(.users,"users",sessid)
 QUIT $$formErrors^%zewdExt4Code(sessid)
 ;
identifyUser(sessid)
 ;
 n id,users,rowIndex,rowNo
 ;
 d mergeArrayFromSession^%zewdAPI(.users,"users",sessid)
 s rowNo=$$getRequestValue^%zewdAPI("row",sessid)
 s rowIndex=$$getRequestValue^%zewdAPI("rowIndex",sessid)
 s id=$g(users(rowNo,"username"))
 d setSessionValue^%zewdAPI("username",id,sessid)
 d setSessionValue^%zewdAPI("userNo",rowNo,sessid)
 d setSessionValue^%zewdAPI("rowIndex",rowIndex,sessid)
 QUIT ""
 ;
deleteUser(sessid)
 ;
 n id,users,no
 ;
 d mergeArrayFromSession^%zewdAPI(.users,"users",sessid)
 s no=$$getSessionValue^%zewdAPI("userNo",sessid)
 s id=$g(users(no,"username"))
 k ^SMART("authentication",id)
 QUIT ""
 ;
savePassword(sessid)
 n password,username
 d setFieldErrorAlert^%zewdExt4Code("Authentication Error","The user details you entered are invalid",sessid)
 s password=$$getSessionValue^%zewdAPI("password",sessid)
 s username=$$getSessionValue^%zewdAPI("username",sessid)
 d
 . i password="" d setFieldError^%zewdExt4Code("password","Password must be defined",sessid) q
 . s password=$$encodePassword(password)
 . s ^SMART("authentication",username)=password
 QUIT $$formErrors^%zewdExt4Code(sessid)
 ;
getManifests(sessid)
 ;
 n id,manifest,no
 ;
 s id="",no=0
 f  s id=$o(^SMART("manifest",id)) q:id=""  d
 . s no=no+1
 . m manifest(no)=^SMART("manifest",id)
 d setSessionValue^%zewdAPI("lastManifestNo",no,sessid)
 d mergeArrayToSession^%zewdAPI(.manifest,"manifests",sessid)
 QUIT ""
 ;
saveManifest(sessid)
 n array,i,id,lastManifestNo,manifest,ok,text
 d setFieldErrorAlert^%zewdExt4Code("Manifest Error","The Manifest you tried to save is invalid",sessid)
 d getTextArea^%zewdAPI("manifest",.text,sessid)
 s manifest=""
 i $g(text(0))>0 f i=1:1:text(0) s manifest=manifest_$g(text(i))
 s ok=$$parseJSON^%zewdJSON(manifest,.array,1)
 i ok="" d
 . s id=$g(array("id"))
 . i id'="" d
 . . i $g(array("name"))="" s ok="Missing Name" q
 . . i $g(array("author"))="" s ok="Missing Author" q
 . . i $g(array("description"))="" s ok="Missing Description" q
 . . i $g(array("index"))="" s ok="Missing Index URL" q
 . . ; add to stored manifests
 . . k ^SMART("manifest",id)
 . . m ^SMART("manifest",id)=array
 . . ; synchronise local session array with displayed grid
 . . d setSessionValue^%zewdAPI("manifestJSON",manifest,sessid)
 . . s lastManifestNo=$$getSessionValue^%zewdAPI("lastManifestNo",sessid)+1
 . . d setSessionValue^%zewdAPI("lastManifestNo",lastManifestNo,sessid)
 . . d mergeArrayFromSession^%zewdAPI(.manifests,"manifests",sessid)
 . . m manifests(lastManifestNo)=array
 . . d deleteFromSession^%zewdAPI("manifests",sessid)
 . . d mergeArrayToSession^%zewdAPI(.manifests,"manifests",sessid)
 . e  d
 . . s ok="Missing Id"
 i ok'="" d setFieldError^%zewdExt4Code("manifest",ok,sessid)
 QUIT $$formErrors^%zewdExt4Code(sessid)
 ;
identifyManifest(sessid)
 ;
 n id,manifests,rowIndex,rowNo
 ;
 d mergeArrayFromSession^%zewdAPI(.manifests,"manifests",sessid)
 s rowNo=$$getRequestValue^%zewdAPI("row",sessid)
 s rowIndex=$$getRequestValue^%zewdAPI("rowIndex",sessid)
 s id=$g(manifests(rowNo,"id"))
 d setSessionValue^%zewdAPI("manifestId",id,sessid)
 d setSessionValue^%zewdAPI("manifestNo",rowNo,sessid)
 d setSessionValue^%zewdAPI("rowIndex",rowIndex,sessid)
 QUIT ""
 ;
deleteManifest(sessid)
 ;
 n id,manifests,no
 ;
 d mergeArrayFromSession^%zewdAPI(.manifests,"manifests",sessid)
 s no=$$getSessionValue^%zewdAPI("manifestNo",sessid)
 s id=$g(manifests(no,"id"))
 k ^SMART("manifest",id)
 QUIT ""
 ;
getManifest(sessid)
 ;
 n lineNo,manifest,manifests,no,prop,text
 ;
 d mergeArrayFromSession^%zewdAPI(.manifests,"manifests",sessid)
 s no=$$getRequestValue^%zewdAPI("row",sessid)
 m manifest=manifests(no)
 s json=$$arrayToJSON^%zewdJSON("manifest")
 f i=1:1:$l(json,",") d
 . ;s text(i)=$$replaceAll^%zewdAPI($p(json,",",i),"""","\""")
 . s text(i)=$p(json,",",i)
 . i i'=$l(json,",") s text(i)=text(i)_","
 d setTextAreaValue^%zewdExt4Code(.text,"manifest",sessid)
 QUIT ""
 ;
getCredentialNVPs(sessid)
 ;
 n manifestId,name,oauth,parentSessid,patientId,token,userId
 ;
 s token=$$getRequestValue^%zewdAPI("token",sessid)
 s parentSessid=$$getSessid^%zewdPHP(token)
 i parentSessid="" QUIT "Invalid request"
 i $$isTokenExpired^%zewdPHP(token) QUIT "Invalid request"
 i $$getSessionValue^%zewdAPI("SMART.token",parentSessid)'=token QUIT "invalid request"
 d setSessionValue^%zewdAPI("ewd_parentSessid",parentSessid,sessid)
 ;
 s manifestId=$$getRequestValue^%zewdAPI("manifestId",sessid)
 s patientId=$$getSessionValue^%zewdAPI("vista_patient.id",parentSessid)
 s userId=$$getSessionValue^%zewdAPI("vista_user.id",parentSessid)
 s oauth("clientRequest","manifestId")=manifestId
 s oauth("clientRequest","manifestURL")=$g(^SMART("manifest",manifestId,"index"))
 s oauth("clientRequest","patientId")=patientId
 s oauth("clientRequest","userId")=userId
 d mergeArrayToSession^%zewdAPI(.oauth,"ewd_oauth",sessid)
 QUIT ""
 ;
outputCredentials(sessid)
 ;
 n apiBase,connectToken,consumerSecret,ewdOAuth,header,manifestId
 n nonce,oauth,oauthToken,params,secretKey,timeStamp,tokenSecret
 ;
 s params("comma")=""
 ;
 s params("OAuth realm","in-oauth_header")=1
 s params("OAuth realm","in-stringToSign")=0
 s params("OAuth realm","is-responseNVP")=0
 ;
 s params("oauth_nonce","in-oauth_header")=1
 s params("oauth_nonce","in-stringToSign")=1
 s params("oauth_nonce","is-responseNVP")=0
 ;
 s params("oauth_timestamp","in-oauth_header")=1
 s params("oauth_timestamp","in-stringToSign")=1
 s params("oauth_timestamp","is-responseNVP")=0
 ;
 s params("smart_app_id","in-oauth_header")=1
 s params("smart_app_id","in-stringToSign")=1
 s params("smart_app_id","is-responseNVP")=0
 ;
 s params("oauth_signature_method","in-oauth_header")=1
 s params("oauth_signature_method","in-stringToSign")=1
 s params("oauth_signature_method","is-responseNVP")=0
 ;
 s params("smart_record_id","in-oauth_header")=1
 s params("smart_record_id","in-stringToSign")=1
 s params("smart_record_id","is-responseNVP")=0
 ;
 s params("oauth_version","in-oauth_header")=1
 s params("oauth_version","in-stringToSign")=1
 s params("oauth_version","is-responseNVP")=0
 ;
 s params("smart_user_id","in-oauth_header")=1
 s params("smart_user_id","in-stringToSign")=1
 s params("smart_user_id","is-responseNVP")=0
 ;
 s params("smart_oauth_token_secret","in-oauth_header")=1
 s params("smart_oauth_token_secret","in-stringToSign")=1
 s params("smart_oauth_token_secret","is-responseNVP")=0
 ;
 s params("oauth_consumer_key","in-oauth_header")=1
 s params("oauth_consumer_key","in-stringToSign")=1
 s params("oauth_consumer_key","is-responseNVP")=0
 ;
 s params("smart_oauth_token","in-oauth_header")=1
 s params("smart_oauth_token","in-stringToSign")=1
 s params("smart_oauth_token","is-responseNVP")=0
 ;
 s params("smart_container_api_base","in-oauth_header")=1
 s params("smart_container_api_base","in-stringToSign")=1
 s params("smart_container_api_base","is-responseNVP")=0
 ;
 s params("oauth_signature","in-oauth_header")=1
 s params("oauth_signature","in-stringToSign")=0
 s params("oauth_signature","is-responseNVP")=0
 ;
 s params("oauth_header","in-oauth_header")=0
 s params("oauth_header","in-stringToSign")=0
 s params("oauth_header","is-responseNVP")=1
 ;
 s params("connect_token","in-oauth_header")=0
 s params("connect_token","in-stringToSign")=0
 s params("connect_token","is-responseNVP")=1
 ;
 s params("api_base","in-oauth_header")=0
 s params("api_base","in-stringToSign")=0
 s params("api_base","is-responseNVP")=1
 ;
 s params("rest_token","in-oauth_header")=0
 s params("rest_token","in-stringToSign")=0
 s params("rest_token","is-responseNVP")=1
 ;
 s params("app_id","in-oauth_header")=0
 s params("app_id","in-stringToSign")=0
 s params("app_id","is-responseNVP")=1
 ;
 s params("rest_secret","in-oauth_header")=0
 s params("rest_secret","in-stringToSign")=0
 s params("rest_secret","is-responseNVP")=1
 ;
 d mergeArrayFromSession^%zewdAPI(.ewdOAuth,"ewd_oauth",sessid)
 s manifestId=$g(ewdOAuth("clientRequest","manifestId"))
 s header=$$addToHeader("","OAuth realm","",.params)
 s nonce=$$createToken^%zewdPHP(sessid)
 s header=$$addToHeader(header,"oauth_nonce",nonce,.params)
 s timeStamp=$$convertToEpochTime($h)
 s header=$$addToHeader(header,"oauth_timestamp",timeStamp,.params)
 s header=$$addToHeader(header,"smart_app_id",manifestId,.params)
 s header=$$addToHeader(header,"oauth_signature_method","HMAC-SHA1",.params)
 s header=$$addToHeader(header,"smart_record_id",$g(ewdOAuth("clientRequest","patientId")),.params)
 s header=$$addToHeader(header,"oauth_version","1.0",.params)
 s header=$$addToHeader(header,"smart_user_id",$g(ewdOAuth("clientRequest","userId")),.params)
 s tokenSecret=$$createToken^%zewdPHP(sessid)
 s header=$$addToHeader(header,"smart_oauth_token_secret",tokenSecret,.params)
 s header=$$addToHeader(header,"oauth_consumer_key",$g(ewdOAuth("clientRequest","manifestId")),.params)
 s oauthToken=$$createToken^%zewdPHP(sessid)
 s header=$$addToHeader(header,"smart_oauth_token",oauthToken,.params)
 s apiBase=$g(^zewd("SMART","api_base"))
 s header=$$addToHeader(header,"smart_container_api_base",apiBase,.params)
 s connectToken=$$createToken^%zewdPHP(sessid)
 s header=$$addToHeader(header,"connect_token",connectToken,.params)
 s header=$$addToHeader(header,"api_base",apiBase,.params)
 s header=$$addToHeader(header,"rest_token",oauthToken,.params)
 s header=$$addToHeader(header,"app_id",$g(ewdOAuth("clientRequest","manifestId")),.params)
 s header=$$addToHeader(header,"rest_secret",tokenSecret,.params)
 s ewdOAuth("tokenToSecret",oauthToken)=tokenSecret ; lookup index
 ;
 s consumerSecret=$g(^zewd("SMART","consumerSecret"))
 s secretKey=$$urlEscape(consumerSecret)_"&"
 s signature=$$getSignature(.ewdOAuth,secretKey)
 s header=$$addToHeader(header,"oauth_signature",signature,.params)
 ;
 s header=$$addToHeader(header,"oauth_header",header,.params)
 m oauth=ewdOAuth("clientResponse")
 d streamArrayToJSON^%zewdJSON("oauth")
 d mergeArrayToSession^%zewdAPI(.ewdOAuth,"ewd_oauth",sessid)
 i $g(^zewd("trace")) d trace^%zewdAPI("getCredentials finished")
 QUIT
 ;
addToHeader(header,name,value,params)
 ;
 ; s params("rest_secret","in-oauth_header")=0
 ; s params("rest_secret","in-stringToSign")=0
 ; s params("rest_secret","is-responseNVP")=1
 ;
 i $g(params(name,"in-stringToSign"))=1 d
 . s name=$$utf8Encode(name)
 . s value=$$utf8Encode(value)
 . s value=$$urlEscape(value)
 . s ewdOAuth("stringToSign",name)=value
 i $g(params(name,"in-oauth_header"))=1 d 
 . s header=header_$g(params("comma"))_name_"=\"""_value_"\"""
 . s params("comma")=", "
 i $g(params(name,"is-responseNVP"))=1 d
 . s ewdOAuth("clientResponse",name)=value
 s ewdOAuth("param",name)=value
 QUIT header
 ;
checkRESTRequest(sessid)
 n method,patientId,scriptName,status
 ;
 s status=$$OAuthValidation(sessid)
 i status'="" d  QUIT ""
 . d setSessionValue^%zewdAPI("reason403",status)
 . ;d setRedirect^%zewdAPI("rest403",sessid)
 . s status="403 Forbidden~"_status
 . d setRedirect^%zewdAPI("ewdHttpResponse~"_status,sessid)
 ;
 s scriptName=$$getServerValue^%zewdAPI("SCRIPT_NAME",sessid)
 i scriptName["/ontology" d setSessionValue^%zewdAPI("restRequest","ontology",sessid) QUIT ""
 ;
 s records=$p(scriptName,"rest.mgwsi/records/",2)
 s patientId=$p(records,"/",1)
 s method=$p(records,"/",2)
 d setSessionValue^%zewdAPI("restRequest","records",sessid)
 d setSessionValue^%zewdAPI("method",method,sessid)
 d setSessionValue^%zewdAPI("patientId",patientId,sessid)
 QUIT ""
 ;
outputOntology(sessid)
 ;
 n file,i,io,ok,path,stop
 ;
 s io=$io
 s path=$$getApplicationRootPath^%zewdAPI()
 i $e(path,$l(path))'="/" s path=path_"/"
 s file=path_"SMART/ontology.xml"
 s ok=$$openFile^%zewdAPI(file)
 s stop=0
 f i=1:1 d  q:stop
 . u file r line
 . u io w line,!
 . i line["</rdf:RDF>" s stop=1 q
 ;
 c file
 u io
 QUIT
 ;
OAuthValidation(sessid)
 ;
 n auth,consumerKey,i,name,np,nvp,ok,param,params,parentSessid,restToken,scriptName,url,value
 ;
 s auth=$$getServerValue^%zewdAPI("HTTP_AUTHORIZATION",sessid)
 i auth="" QUIT "No Authorization received"
 s np=$l(auth,", ")
 f i=1:1:np d
 . s nvp=$p(auth,", ",i)
 . s name=$p(nvp,"=",1)
 . s value=$p(nvp,"=",2)
 . s value=$e(value,2,$l(value)-1)
 . s param(name)=value
 s restToken=$g(param("oauth_token"))
 i restToken="" QUIT "oauth_token not defined"
 s parentSessid=$$getSessid^%zewdAPI(restToken)
 i parentSessid="" QUIT "Invalid oauth_token or parent session has timed out"
 ;
 d mergeArrayFromSession^%zewdAPI(.params,"ewd_oauth",parentSessid)
 s consumerKey=$g(params("param","oauth_consumer_key"))
 i $g(param("oauth_consumer_key"))="" QUIT "Consumer key is missing"
 i param("oauth_consumer_key")'=consumerKey QUIT "Consumer key ("_param("oauth_consumer_key")_") does not match the one sent with the original credentials"
 ;
 s scriptName=$$getServerValue^%zewdAPI("SCRIPT_NAME",sessid)
 s url="http://"_$$getServerValue^%zewdAPI("SERVER_NAME",sessid)_scriptName
 s ok=$$isSignatureValid(url,.param,parentSessid)
 i 'ok QUIT "Authorization signature mismatch"
 QUIT ""
 ;
isSignatureValid(url,params,sessid)
 ;
 n amp,consumerSecret,name,ok,restSecret,secretKey,signature,str,string
 ;
 s amp=""
 s string=$$urlEscape(url)
 s string="GET&"_string
 s str=""
 s name=""
 f  s name=$o(params(name)) q:name=""  d
 . i name="OAuth realm" q
 . i name="oauth_signature" q
 . s str=str_amp_name_"="_params(name)
 . s amp="&"
 s string=string_"&"_$$urlEscape(str)
 s consumerSecret=$g(^zewd("SMART","consumerSecret"))
 s restToken=$g(params("oauth_token"))
 ;
 d mergeArrayFromSession^%zewdAPI(.oauth,"ewd_oauth",sessid)
 s restSecret=$g(oauth("tokenToSecret",restToken))
 s secretKey=$$urlEscape(consumerSecret)_"&"_$$urlEscape(restSecret)
 s signature=$$urlEscape($$getSignedString(string,secretKey))
 ;
 i $g(^zewd("trace")) d
 . d trace^%zewdAPI("isSignatureValid: calculated="_signature_"; expected="_params("oauth_signature"))
 . d trace^%zewdAPI("string="_string)
 . d trace^%zewdAPI("secretKey="_secretKey)
 s ok=signature=$g(params("oauth_signature"))
 QUIT ok
 ;
getSignature(oAuth,secretKey)
 ;
 n amp,manifestURL,name,string,value
 ;
 s amp=""
 s string=""
 s name=""
 f  s name=$o(oAuth("stringToSign",name)) q:name=""  d
 . s string=string_amp_name_"="_oAuth("stringToSign",name)
 . s amp="&"
 s manifestURL=$g(oAuth("clientRequest","manifestURL"))
 s string="GET&"_$$urlEscape(manifestURL)_"&"_$$urlEscape(string)
 i $g(^zewd("trace")) d trace^%zewdAPI("string to sign: "_string_$c(13,10)_"secretKey: "_secretKey)
 QUIT $$getSignedString(string,$g(secretKey))
 ;
testit()
 ;s string=string_"&"_$$urlEscape("auth_header=OAuth realm="""", oauth_nonce=""juZ0At40lQYKCjLYPbjZ"", oauth_timestamp=""1339407895"", smart_app_id=""rx-reminder%40apps.smartplatforms.org"", oauth_signature_method=""HMAC-SHA1"", smart_record_id=""99912345"", oauth_version=""1.0"", smart_user_id=""rtweed%40mgateway.com"", smart_oauth_token_secret=""AUJHySr8wNZPUm43rscD"", oauth_consumer_key=""rx-reminder%40apps.smartplatforms.org"", smart_oauth_token=""QZdWHRnA2XU7ZfrL0T80"", smart_container_api_base=""http%3A%2F%2Fsandbox-api.smartplatforms.org""")
 ;s string=string_"&"_$$urlEscape("OAuth realm=&oauth_nonce=juZ0At40lQYKCjLYPbjZ&oauth_timestamp=1339407895&smart_app_id=rx-reminder%40apps.smartplatforms.org&oauth_signature_method=HMAC-SHA1&smart_record_id=99912345&oauth_version=1.0&smart_user_id=rtweed%40mgateway.com&smart_oauth_token_secret=AUJHySr8wNZPUm43rscD&oauth_consumer_key=rx-reminder%40apps.smartplatforms.org&smart_oauth_token=QZdWHRnA2XU7ZfrL0T80&smart_container_api_base=http%3A%2F%2Fsandbox-api.smartplatforms.org")
 ;s str=$$urlEscape("OAuth realm=&oauth_nonce=juZ0At40lQYKCjLYPbjZ&oauth_timestamp=1339407895&smart_app_id=rx-reminder@apps.smartplatforms.org&oauth_signature_method=HMAC-SHA1&smart_record_id=99912345&oauth_version=1.0&smart_user_id=rtweed@mgateway.com&smart_oauth_token_secret=AUJHySr8wNZPUm43rscD&oauth_consumer_key=rx-reminder@apps.smartplatforms.org&smart_oauth_token=QZdWHRnA2XU7ZfrL0T80&smart_container_api_base=http://sandbox-api.smartplatforms.org")
 ;
 s ewdOAuth("clientResponse","smart_record_id")=99912345
 s ewdOAuth("clientResponse","smart_app_id")="rx-reminder@apps.smartplatforms.org"
 s ewdOAuth("clientResponse","smart_user_id")="rtweed@mgateway.com"
 s ewdOAuth("clientResponse","smart_oauth_token_secret")="AUJHySr8wNZPUm43rscD"
 s ewdOAuth("clientResponse","smart_oauth_token")="QZdWHRnA2XU7ZfrL0T80"
 s ewdOAuth("clientResponse","smart_container_api_base")="http://sandbox-api.smartplatforms.org"
 ;
 s ewdOAuth("clientResponse","oauth_consumer_key")="rx-reminder@apps.smartplatforms.org"
 s ewdOAuth("clientResponse","oauth_timestamp")=1339407895
 s ewdOAuth("clientResponse","oauth_nonce")="juZ0At40lQYKCjLYPbjZ"
 ;s ewdOAuth("clientResponse","OAuth realm")=""
 s ewdOAuth("clientResponse","oauth_version")="1.0"
 ;
 s ewdOAuth("clientResponse","oauth_signature_method")="HMAC-SHA1"
 ;
 s amp=""
 s string=$$urlEscape("http://rxreminder.smartplatforms.org/smartapp/index.html")
 s string="GET&"_string
 s str=""
 s name=""
 f  s name=$o(ewdOAuth("clientResponse",name)) q:name=""  d
 . s str=str_amp_name_"="_$$urlEscape(ewdOAuth("clientResponse",name))
 . s amp="&"
 s string=string_"&"_$$urlEscape(str)
 s secretKey=$$urlEscape("smartapp-secret")_"&"
 w !,"string: ",!,string,!
 w !,"secretKey: "_secretKey,!!
 w "Computed signature: "_$$getSignedString(string,secretKey),!
 w "Should be: ZlqohpfmKmxN0jy35xgiTPV9Ijk="
 QUIT
 ;
testit2
 s string="GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Doriginal"
 s secretKey="kd94hf93k423kf44&pfkkdhi9sl3r4s00"
 w "Computed signature: "_$$getSignedString(string,secretKey),!
 w "Should be: tR3+Ty81lMeYAr/Fid0kMTYa/WM=",!
 QUIT
 ;problem-list%40apps.smartplatforms.org&smartapp-secret
 ;problem-list%2540apps.smartplatforms.org&smartapp-secret
 ;problem-list@apps.smartplatforms.org&smartapp-secret
 ;smartapp-secret&
testit3(secretKey)
 s string="GET&http%3A%2F%2Fsample-apps.smartplatforms.org%2Fframework%2Fproblem_list%2Findex.html&oauth_consumer_key%3Dproblem-list%2540apps.smartplatforms.org%26oauth_nonce%3DJ0AiVQHtYviFNYpB8gKq%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1340037299%26oauth_version%3D1.0%26smart_app_id%3Dproblem-list%2540apps.smartplatforms.org%26smart_container_api_base%3Dhttp%253A%252F%252Flocalhost%253A7000%26smart_oauth_token%3DnR0zMKWoUu4NXSQ2GdIq%26smart_oauth_token_secret%3D8gUB0TuFCII6fVDtTMhY%26smart_record_id%3D99912345%26smart_user_id%3Ddemouser%2540smartplatforms.org"
 ;s secretKey="problem-list%25apps.smartplatforms.org&smartapp-secret"
 w "Computed signature: "_$$getSignedString(string,secretKey),!
 w "Should be: 6zXiTwgBWBOYZstm72U8gPjWhKk=",!
 QUIT
 ;
testit4()
 ;
 s ewdOAuth("clientResponse","oauth_consumer_key")="my-app@apps.smartplatforms.org"
 s ewdOAuth("clientResponse","oauth_timestamp")=1340116008
 s ewdOAuth("clientResponse","oauth_nonce")="rwdlbyYXPpLgFJsyVZH1"
 s ewdOAuth("clientResponse","oauth_version")="1.0"
 s ewdOAuth("clientResponse","oauth_token")="YY5vjpDT1Qu0YSont1I9rpEayTb77M"
 s ewdOAuth("clientResponse","oauth_signature_method")="HMAC-SHA1"
 ;
 s amp=""
 s string=$$urlEscape("http://smart2.vistaewd.net:8080/SMART/restGet/records/11/medications/")
 s string="GET&"_string
 s str=""
 s name=""
 f  s name=$o(ewdOAuth("clientResponse",name)) q:name=""  d
 . s str=str_amp_name_"="_$$urlEscape(ewdOAuth("clientResponse",name))
 . s amp="&"
 s string=string_"&"_$$urlEscape(str)
 s secretKey=$$urlEscape("smartapp-secret")_"&"_$$urlEscape("YoeXcf5PM0db7cfMt2tWYXMt5BCTtp")
 w !,"string: ",!,string,!
 w !,"secretKey: "_secretKey,!!
 w "Computed signature: "_$$getSignedString(string,secretKey),!
 w "Should be: Qdt70RtnLPyX7Irsh387wPs9AcM="
 QUIT
 ;
getSignedString(string,secretKey,signatureMethod)
 ;
 n context,hash,returnValue
 ;
 s returnValue=""
 i $zv["GT.M" d
 . s context=1
 . i $d(^zewd("config","MGWSI")) s context=0
 . i $$zcvt^%zewdAPI($g(signatureMethod),"l")="hmacsha256" d
 . . s returnValue=$$HMACSHA256^%ZMGWSIS(string,secretKey,1,context)
 . e  d
 . . s returnValue=$$HMACSHA1^%ZMGWSIS(string,secretKey,1,context)
 e  d
 . i $$zcvt^%zewdAPI($g(signatureMethod),"l")="hmacsha256" d
 . . ;s hash=$System.Encryption.HMACSHA256(string,secretKey)
 . e  d
 . . ;s hash=$System.Encryption.HMACSHA1(string,secretKey)
 . ;s returnValue=$System.Encryption.Base64Encode(hash)
 ;
 QUIT returnValue
 ;
convertToEpochTime(dh)
 ;
 n time
 ;
 s time=(dh*86400)+$p(dh,",",2)
 s time=time-4070908800
 QUIT time
 ;
convertFromEpochTime(time)
 ;
 n dh
 ;
 s time=time+4070908800
 s dh=time\86400
 s time=time#86400
 QUIT dh_","_time
 ;
urlEscape(string)
 ;The unreserved characters are A-Z, a-z, 0-9, hyphen ( - ), underscore ( _ ), period ( . ), and tilde ( ~ ). 
 i string?1AN.AN QUIT string
 n a,c,esc,i,pass
 f i=45,46,95,126 s pass(i)=""
 s esc=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . i c?1AN s esc=esc_c q
 . s a=$a(c)
 . i $d(pass(a)) s esc=esc_c q
 . s a=$$hex(a)
 . s esc=esc_"%"_$$zcvt^%zewdAPI(a,"u")
 QUIT esc
 ;
hex(number)
 n hex,no,str
 s hex=""
 s str="123456789ABCDEF"
 f  d  q:number=0
 . s no=number#16
 . s number=number\16
 . i no s no=$e(str,no)
 . s hex=no_hex
 QUIT hex
 ;
utf8Encode(string)
 ;
 n a,buff,c,i
 ;
 s buff=""
 f i=1:1:$l(string) d
 . s c=$e(string,i)
 . s a=$a(c)
 . i a>160 d
 . . s buff=buff_"\x"_$$hex(a) q
 . . i a<192 d
 . . . s buff=buff_"%C2%"_$$hex(a)_c
 . . e  d
 . . . s buff=buff_"%C3%"_$$hex(a-64)
 . e  d
 . . s buff=buff_c
 QUIT buff
 ;
parseRequest(sessid)
 n method,parentSessid,patientId,token
 s method=$$getRequestValue^%zewdAPI("method",sessid)
 s patientId=$$getRequestValue^%zewdAPI("patientId",sessid)
 s token=$$getRequestValue^%zewdAPI("token",sessid)
 s parentSessid=$$getSessid^%zewdPHP(token)
 i parentSessid="" QUIT "Invalid request"
 i $$isTokenExpired^%zewdPHP(token) QUIT "Invalid request"
 i $$getSessionValue^%zewdAPI("SMART.token",parentSessid)'=token QUIT "invalid request"
 d setSessionValue^%zewdAPI("SMART_method",method,sessid)
 d setSessionValue^%zewdAPI("SMART_patientId",patientId,sessid)
 d setSessionValue^%zewdAPI("SMART_parentSessid",parentSessid,sessid)
 QUIT ""
 ;
outputRDF(sessid)
 ;
 n method,parentSessid,restRequest
 ;
 s restRequest=$$getSessionValue^%zewdAPI("restRequest",sessid)
 i restRequest="ontology" d  QUIT
 . d outputOntology(sessid)
 i restRequest="records" d  QUIT
 . n DT,method,patientId
 . s DT=""
 . s method=$$getSessionValue^%zewdAPI("method",sessid)
 . s patientId=$$getSessionValue^%zewdAPI("patientId",sessid)
 . i method="lab_results" d getRDF(patientId,"lab") QUIT
 . i method="capabilities" d emptyRDF QUIT
 . i method="allergies" d emptyRDF QUIT  ; *** allergies
 . i method="fulfillments" d emptyRDF QUIT  ; *** fulfillments
 . i method="problems" d getRDF(patientId,"problem") QUIT
 . i method="vital_signs" d emptyRDF QUIT  ; *** vital_signs
 . i method="medications" d getRDF(patientId,"med") QUIT
 . i method="demographics" d getRDF(patientId,"patient") QUIT
 e  d
 . s parentSessid=$$getSessionValue^%zewdAPI("SMART_parentSessid",sessid)
 . s method=$$getSessionValue^%zewdAPI("SMART_rdfMethod",parentSessid)
 . s method="d "_method_"(sessid)"
 x method
 QUIT
 ;
vistARDF(sessid)
 n DT,g,i,line,method,parentSessid,patientId,stop
 ;
 s parentSessid=$$getSessionValue^%zewdAPI("SMART_parentSessid",sessid)
 s DT=$$getSessionValue^%zewdAPI("DT",parentSessid)
 d setSessionValue^%zewdAPI("DT",DT,sessid)
 s method=$$getSessionValue^%zewdAPI("SMART_method",sessid)
 s patientId=$$getSessionValue^%zewdAPI("SMART_patientId",sessid)
 s DT=$$getSessionValue^%zewdAPI("DT",sessid)
 ;d trace^%zewdAPI("*** method = "_method_"; patientId="_patientId_"; DT="_DT)
 i method="lab_results" d getRDF(patientId,"lab") QUIT
 i method="capabilities" d emptyRDF QUIT
 i method="allergies" d emptyRDF QUIT  ; *** allergies
 i method="fulfillments" d emptyRDF QUIT  ; *** fulfillments
 i method="problems" d getRDF(patientId,"problem") QUIT
 i method="vital_signs" d emptyRDF QUIT  ; *** vital_signs
 i method="medications" d getRDF(patientId,"med") QUIT
 i method="demographics" d getRDF(patientId,"patient") QUIT
 QUIT
 ;
getRDF(patientId,type)
 n no
 i patientId["hack" d
 . d getGraph^C0XGET1(.g,"/home/vista/hack/"_patientId_".xml","rdf")
 . d transform
 e  d
 . d EN^C0SMART(.g,patientId,type,"rdf")
 . i '$d(g) d emptyRDF QUIT
 . s no=""
 . f  s no=$o(g(no)) q:no=""  d
 . . w g(no)_$c(10)
 QUIT
 ;
transform
 n array,nodeOID,ok
 ;
 k ^CacheTempEWD($j)
 m ^CacheTempEWD($j)=g
 s ok=$$parseDocument^%zewdHTMLParser("rdf")
 s ok=$$getElementsArrayByTagName^%zewdDOM("problemName","rdf",,.array)
 s nodeOID=""
 f  s nodeOID=$o(array(nodeOID)) q:nodeOID=""  d
 . s text=$$getElementText^%zewdDOM(nodeOID)
 . d setAttribute^%zewdDOM("rdf:nodeID",text,nodeOID)
 i $$outputDOM^%zewdDOM("rdf",1,1)
 QUIT
 ;
outputRDFGlobal(method)
 n lineNo
 s lineNo=""
 f  s lineNo=$o(^rdf(method,lineNo)) q:lineNo=""  d
 . w ^rdf(method,lineNo)_$c(10)
 QUIT
 ;
emptyRDF
 w "<?xml version='1.0' encoding='UTF-8' ?>"_$c(10)
 w "<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>"_$c(10)
 w "</rdf:RDF>"_$c(10)
 QUIT
 ;
