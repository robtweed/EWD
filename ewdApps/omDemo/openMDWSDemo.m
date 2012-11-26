schedulerDemo ; EWD/MDWS demo scheduler system: scripts
 ;
initialise(sessid)
 ;
 d setSessionValue^%zewdAPI("vista.systemId","Robs dEWDrop Server",sessid)
 d setSessionValue^%zewdAPI("mdws.host","192.168.0.14",sessid)
 d setSessionValue^%zewdAPI("mdws.facade","SchedulingSvc",sessid)
 d setSessionValue^%zewdAPI("mdws.version","openMDWS",sessid)
 d setSessionValue^%zewdAPI("mdws.path","/vista/",sessid) 
 ;d setSessionValue^%zewdAPI("vista.host","192.168.0.14",sessid)
 d setSessionValue^%zewdAPI("vista.host","localhost",sessid)
 d setSessionValue^%zewdAPI("vista.sslProxyPort","89",sessid)
 QUIT ""
 ;
login(sessid)
 ;
 n data,nvps,ok,results,vaSystem
 ;
 s vaSystem=$$getSessionValue^%zewdAPI("vista.systemId",sessid)
 ;
 s nvps("sitelist")=vaSystem
 s ok=$$request^%zewdMDWSClient("connect",.nvps,.results,sessid)
 i '$$isConnected^%zewdMDWSClient(.results) QUIT "Unable to connect to VA system "_vaSystem_": "_$$getFaultMessage^%zewdMDWSClient(.results)
 ;
 s nvps("username")=$$getSessionValue^%zewdAPI("accessCode",sessid)
 s nvps("pwd")=$$getSessionValue^%zewdAPI("verifyCode",sessid)
 s nvps("context")=""
 s ok=$$request^%zewdMDWSClient("login",.nvps,.results,sessid)
 i '$$isLoggedIn^%zewdMDWSClient(.results) QUIT $$getFaultMessage^%zewdMDWSClient(.results)
 s ok=$$getLoginData^%zewdMDWSClient(.results,.data)
 ;
 d setSessionValue^%zewdAPI("vista.DUZ",data("DUZ"),sessid)
 d setSessionValue^%zewdAPI("vista.name",data("name"),sessid)
 d setSessionValue^%zewdAPI("vista.SSN",data("SSN"),sessid)
 ;
 QUIT ""
 ;
getClinics(sessid)
 n nvps,ok
 s nvps("target")=""
 s ok=$$request^%zewdMDWSClient("getClinics",.nvps,.results,sessid)
 i $$isFault^%zewdMDWSClient(.results) QUIT $$getFaultMessage^%zewdMDWSClient(.results)
 s ok=$$getClinicData^%zewdMDWSClient(.results,.clinic)
 d mergeArrayToSession^%zewdAPI(.clinic,"vista.clinics",sessid)
 QUIT ""
 ;
getSelectedClinic(sessid)
 ;
 n clinicName,clinicNo,clinics
 ;
 s clinicNo=$$getRequestValue^%zewdAPI("clinicNo",sessid)
 d mergeArrayFromSession^%zewdAPI(.clinics,"vista.clinics",sessid)
 s clinicName=$g(clinics(clinicNo,"text"))
 d setSessionValue^%zewdAPI("clinicName",clinicName,sessid)
 QUIT ""
 ;
 ;