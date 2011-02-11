#import subprocess

import m_python
import boto
import boto.sdb
import boto.sdb.regioninfo

gtm_dist    = "/usr/local/gtm"
gtmroutines = "/usr/local/gtm/ewd"
gtmgbldir   = "/usr/local/gtm/ewd/mumps.gld"

gtmci       = "/usr/mgwsi/m/gtm/zmgwsi.ci"
use_gtm_api = m_python.m_bind_gtm_server(0, gtm_dist, gtmci, gtmroutines, gtmgbldir, "", "", "")
#subprocess.call("stty echo",shell=True)


def version():
  arguments = []
  return m_python.ma_proc(0, "version^%zewdAPI",arguments,0)

def trace(text):
  result = m_python.m_proc(0, "trace^%zewdPython",text)

def appendToList(listName,textValue,codeValue,sessid):
  result = m_python.m_proc(0, "appendToList^%zewdPython",listName,textValue,codeValue,sessid)

def clearList(listName,sessid):
  if listName <> "" and sessid <> "":
    m_python.m_kill(0, "^%zewdSession", "session", sessid, "ewd_list", listName)
    m_python.m_kill(0, "^%zewdSession", "session", sessid, "ewd_listIndex", listName)

def isListDefined(listName,sessid):
  data = m_python.m_data(0, "^%zewdSession", "session", sessid, "ewd_list", listName)
  if data == '0':
    return False
  else:
    return True

def compilePage(appName,pageName):
  result = m_python.m_proc(0, "compilePage^%zewdPython",appName,pageName)

def compileAll(appName):
  result = m_python.m_proc(0, "compileAll^%zewdPython",appName)

def getRequestValue(name,sessid):
  return m_python.m_get(0, "^%zewdSession", "session", sessid, "ewd_request", name)

def getSessionValue(name,sessid):
  return m_python.m_proc(0, "getSessionValue^%zewdAPI",name,sessid)

def setSessionValue(name,value,sessid):
  result = m_python.m_proc(0, "setSessionValue^%zewdPython",name,value.encode('ascii','xmlcharrefreplace'),sessid)

def copyRequestValueToSession(name,sessid):
  value = getRequestValue(name,sessid)
  setSessionValue(name,value,sessid)

def deleteFromSession(name,sessid):
  result = m_python.m_proc(0, "deleteFromSession^%zewdPython",name,sessid)

def setRedirect(toPage,sessid):
  setSessionValue("ewd_nextPage",toPage,sessid)
  setSessionValue("ewd_jump",toPage,sessid)

def existsInSession(name,sessid):
  name = name.strip()
  if name == '':
    return False
  elif sessid == '':
    return False
  else:
    data = m_python.m_data(0, "^%zewdSession", "session", sessid, name)
    if data == '0':
      return False
    else:
      return True

def test1(value1):
  args = []
  m_python.ma_arg_set(0, args, 1, value1, 0)
  return m_python.ma_proc(0, "test1^%zewdPython",args,1)

def test1a(value1):
  return m_python.m_proc(0, "test1^%zewdPython",value1)

def test2(value1,value2):
  args = []
  m_python.ma_arg_set(0, args, 1, value1, 0)
  m_python.ma_arg_set(0, args, 2, value2, 0)
  return m_python.ma_proc(0, "test2^%zewdPython",args,2)

def mergeDictionaryToSession(dictionary,sessionName,sessid):
  traverseDict(dictionary,"^%zewdSession",["session",sessid,sessionName])

def mergeDictionaryFromSession(sessionName,sessid):
 key = [4,"session",sessid,sessionName,""]
 globalName="^%zewdSession"
 dictionary = {}
 array = []
 traverseGlobal(globalName,key,dictionary,array)
 return dictionary

def createDataTableStore(dictionary,dataStoreName,sessid):
  deleteFromSession("yuiTemp",sessid)
  mergeDictionaryToSession(dictionary,"yuiTemp",sessid)
  result = m_python.m_proc(0, "createDataTableStore^%zewdPython",dataStoreName,sessid)
  deleteFromSession("yuiTemp",sessid)  

def createiWDMenuFromDictionary(dictionary,keyName,sessionName,sessid):
  deleteFromSession("yuiTemp",sessid)
  data=convertDic(dictionary)
  mergeDictionaryToSession(data,"yuiTemp",sessid)
  result = m_python.m_proc(0, "createiWDMenuFromDictionary^%zewdPython",keyName,sessionName,sessid)
  deleteFromSession("yuiTemp",sessid)  

def getSelectediWDMenuValue(sessionName,sessid):
 selectedNo = getRequestValue('menuItemNo',sessid)
 dic = mergeDictionaryFromSession(sessionName,sessid)
 return dic[selectedNo]['text']

def saveDictionary(dictionary,globalName,sessid):
 traverseDict(dictionary,globalName,[sessid])

def traverseDict(dictionary,globalName,subs):
 for key,value in dictionary.items():
  if type(value) == dict:
   subs.append(key)
   traverseDict(value,globalName,subs)
   subs.pop()
  elif type(value) == list:
   subs.append(key)
   no=0
   for val in value:
     no=no+1
     subs2=subs[:]
     noOfSubs=len(subs)+1
     subs2.insert(0,noOfSubs)
     subs2.append(no)
     if type(val) != dict:
       m_python.ma_set(0,globalName,subs2,str(val).encode('ascii','xmlcharrefreplace'))
     else:
       subs.append(no)
       traverseDict(val,globalName,subs)
       subs.pop()
   subs.pop()
  else:
   noOfSubs=len(subs)+1
   subs2=subs[:]
   subs2.insert(0,noOfSubs)
   subs2.append(str(key).encode('ascii','xmlcharrefreplace'))
   m_python.ma_set(0,globalName,subs2,str(value).encode('ascii','xmlcharrefreplace'))
 return

def getDictionary(globalName):
 key = [1,""]
 dictionary = {}
 array = []
 traverseGlobal(globalName,key,dictionary,array)
 return dictionary

def traverseGlobal(globalName,key,dictionary,array):
  subtype="string"
  intSubtype="string"
  while (m_python.ma_order(0,globalName,key) <> ""):
    data = m_python.ma_data(0,globalName,key)
    if data == "1" or data == "11":
      value=m_python.ma_get(0,globalName,key)
      np = len(key)
      sub = key[np-1]
      #if sub == "1":
      #  subtype="int"
      if subtype == "string":
        d2 = {sub:value}
        dictionary.update(d2)
      else:
        array.append(value)
    if data == "10" or data == "11":
      key2 = key[:]
      np = len(key2)
      key2[0] = np
      key2.append("")
      dictionary2 = {}
      array2 = []
      traverseGlobal(globalName,key2,dictionary2,array2)
      np = len(key)
      sub = key[np-1]
      #if sub == "1":
      #  intSubtype="int"
      if intSubtype == "string":
        if array2 == []:
          dictionary[sub] = dictionary2
        else:
          dictionary[sub] = array2
      else:
        if array2 == []:
          array.append(dictionary2)
        else:
          array.append(array2)

def convertDic(items):
 data = {}
 noOfItems = len(items)
 if noOfItems == 0:
   return ""
 for no in range(noOfItems):
   item = items[no]
   stringItem = {}
   for key,value in item.items():
     nvp = {str(key):value.encode('ascii','xmlcharrefreplace')}
     stringItem.update(nvp)
   nvp = {no:stringItem}
   data.update(nvp)
 return data

def zts(sessid):
  import time
  return time.time()
    
def mdb_connect(userId,secretKey,ipAddress):
 mdbRegion = boto.sdb.regioninfo.SDBRegionInfo(name='mdb', endpoint=ipAddress)
 return boto.connect_sdb(userId,secretKey,is_secure=False,region=mdbRegion,path='/mdb/request.mgwsi')

def double_up_quotes(string):
 esc = string.replace("'","||")
 return esc.replace("|","'")

