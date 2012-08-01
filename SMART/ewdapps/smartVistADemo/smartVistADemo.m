smartVistADemo ; SMART VistA Demo scripts
 ;
login(sessid)
 ;
 N U S U="^"
 N X D NOW^%DTC S DT=X
 N IO,IOF,IOM,ION,IOS,IOSL,IOST,IOT,POP
 S (IO,IO(0),IOF,IOM,ION,IOS,IOSL,IOST,IOT)="",POP=0
 ;
 N V4WACC S V4WACC=$$getRequestValue^%zewdAPI("accessCode",sessid)
 i V4WACC="" QUIT "Please enter your Access Code"
 ;
 N V4WVER S V4WVER=$$getRequestValue^%zewdAPI("verifyCode",sessid)
 i V4WVER="" QUIT "Please enter your Verify Code"
 N V4WAVC S V4WAVC=V4WACC_";"_V4WVER,V4WAVC=$$ENCRYP^XUSRB1(V4WAVC)
 ;
 D SETUP^XUSRB()
 N DUZ,V4WUSER D VALIDAV^XUSRB(.V4WUSER,V4WAVC)
 S V4WDUZ=V4WUSER(0)
 ;
 ;KBAZ/ZAG - add logic to check if verify code needs to be changed.
 ;0 = VC does not need to be changed
 ;1 = VC needs to be changed
 N V4WVCC S V4WVCC=$G(V4WUSER(2))
 N V4WVCMSG S V4WCVMSG=$G(V4WUSER(3)) ;sign in message
 ;
 ;
 N V4WTR S V4WTR=""
 I 'V4WDUZ,$G(DUZ) S V4WTR=": "_$$GET1^DIQ(200,DUZ_",",9.4) ;Termination reason
 i 'V4WDUZ QUIT V4WUSER(3)_V4WTR
 ;
 N USRNAME,PNAME
 S USRNAME=$P(^VA(200,V4WDUZ,0),"^")
 S PNAME=$P(USRNAME,",",2)_" "_$P(USRNAME,",")
 ;
 D setSessionValue^%zewdAPI("DT",DT,sessid)
 D setSessionValue^%zewdAPI("DUZ",V4WDUZ,sessid)
 D setSessionValue^%zewdAPI("vista_user.name",USRNAME,sessid)
 d setSessionValue^%zewdAPI("vista_user.id",V4WDUZ,sessid)
 D setSessionValue^%zewdAPI("displayName",PNAME,sessid)
 Q ""
 ;
getManifests(sessid)
 n manifest,no
 ;
 s id="",no=0
 f  s id=$o(^SMART("manifest",id)) q:id=""  d
 . s no=no+1
 . s manifest(no,"text")=^SMART("manifest",id,"name")
 . s manifest(no,"nvp")="manifestId="_id
 d mergeArrayToSession^%zewdAPI(.manifest,"SMART_manifests",sessid)
 ;d setSessionValue^%zewdAPI("vista_user.name","LILLY, GEORGE",sessid)
 ;d setSessionValue^%zewdAPI("vista_user.id",77,sessid)
 QUIT ""
 ;
getManifest(sessid)
 ;
 n id
 ;
 s id=$$getRequestValue^%zewdAPI("manifestId",sessid)
 i id="" QUIT "No Manifest selected!"
 i '$d(^SMART("manifest",id)) QUIT "Unknown Manifest"
 s patientId=$$getSessionValue^%zewdAPI("vista_patient.id",sessid)
 i patientId="" QUIT "You must first select a patient"
 d setSessionValue^%zewdAPI("SMART_manifest.id",id,sessid)
 s name=$g(^SMART("manifest",id,"name"))
 d setSessionValue^%zewdAPI("SMART_manifest.name",name,sessid)
 QUIT ""
 ;
initialisePatientList(sessid)
 d clearList^%zewdAPI("patientName",sessid)
 d appendToList^%zewdAPI("patientName","Select Name","null",sessid)
 QUIT ""
 ;
updateCombo(sessid)
 n comma,no,options,prefix
 ;
 s prefix=$$getRequestValue^%zewdAPI("text",sessid)
 s comboId=$$getRequestValue^%zewdAPI("comboId",sessid)
 d setSessionValue^%zewdAPI("comboId",comboId,sessid)
 d deleteFromSession^%zewdAPI("options",sessid)
 d comboList(prefix,.options)
 d mergeArrayToSession^%zewdAPI(.options,"options",sessid)
 s values="["
 s no="",comma=""
 f  s no=$o(options(no)) q:no=""  d
 . s values=values_comma_"{name:'"_options(no,"displayText")_"',value:'"_options(no,"value")_"'}"
 . s comma=","
 s values=values_"]"
 d setSessionValue^%zewdAPI("values",values,sessid)
 QUIT ""
 ;
comboList(prefix,options) ;Generates the list of patients for the combo box
 n id,no,name,stop,U
 ;
 s U="^"
 s prefix=$$zcvt^%zewdAPI(prefix,"U")
 ;
 ;Generate the list of patients in the combo box to match what the user typed
 ;Using the patient XREF
 ;
 k options
 s name=prefix
 i prefix'="" s name=$O(^DPT("B",prefix),-1)
 s no=1,stop=0
 f  s name=$o(^DPT("B",name)) quit:name=""  d  q:stop
 . i $e(name,1,$l(prefix))'=prefix s stop=1 q
 . s id=""
 . f  s id=$o(^DPT("B",name,id)) q:id=""  d  q:stop
 . . s no=no+1 i no>500 s stop=1 q
 . . s options(no,"displayText")=name
 . . s options(no,"value")=no
 . . s options(no,"id")=id
 Q
 ;
setPatient(sessid)
 ;
 n id,name,no,options
 ;
 s no=$$getSessionValue^%zewdAPI("patientName",sessid)
 d mergeArrayFromSession^%zewdAPI(.options,"options",sessid)
 s id=$g(options(no,"id"))
 s name=$g(options(no,"displayText"))
 d setSessionValue^%zewdAPI("vista_patient.id",id,sessid)
 d setSessionValue^%zewdAPI("vista_patient.name",name,sessid)
 QUIT ""
 ;
 ;