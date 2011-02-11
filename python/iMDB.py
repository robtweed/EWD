import ewd

def getDomainList(sessid):
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 domains = mdb.get_all_domains()
 domainList = {}
 no = 0
 for domain in domains:
   no = no + 1
   item = {}
   nvp = {'Name':domain.name.encode('ascii','xmlcharrefreplace')}
   item.update(nvp)
   nvp = {no:item}
   domainList.update(nvp)
 ewd.mergeDictionaryToSession(domainList,"yuiTemp",sessid)
 ewd.deleteFromSession("domainList",sessid)
 if domainList != {}:
    result = ewd.m_python.m_proc(0, "createiWDMenuFromDictionary^%zewdPython","Name","domainList",sessid)
 ewd.deleteFromSession("yuiTemp",sessid)  
 return ""

def deleteDomain(sessid):
 domainName=ewd.getSessionValue("domainName",sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 ok = mdb.delete_domain(domainName)
 return getDomainList(sessid)

def initialiseDomain(sessid):
  ewd.deleteFromSession("newDomainName",sessid)
  return ""

def saveDomain(sessid):
 domainName=ewd.getRequestValue("domainName",sessid)
 if domainName == "":
   return "You did not enter a Domain Name"
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 ok = mdb.create_domain(domainName)
 return getDomainList(sessid)

def getItemList(sessid):
 selectedNo = ewd.getRequestValue('menuItemNo',sessid)
 if selectedNo != "":
   domainName = ewd.getSelectediWDMenuValue("domainList",sessid)
   ewd.setSessionValue("domainName",domainName,sessid)
 else:
   domainName = ewd.getSessionValue("domainName",sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 query="select itemName() from " + domainName
 items=mdb.select(domainName,query)
 ewd.deleteFromSession("itemList",sessid)
 if items != []:
   ewd.createiWDMenuFromDictionary(items,"itemName()","itemList",sessid)
 return ""

def saveItem(sessid):
 domainName=ewd.getSessionValue("domainName",sessid)
 itemName=ewd.getRequestValue("itemName",sessid)
 if itemName == "":
   return "You did not enter an Item Name"
 attributeName=ewd.getRequestValue("attrName",sessid)
 if attributeName == "":
   return "You must enter an Attribute Name"
 ewd.setSessionValue("attrName",attributeName,sessid)
 value=ewd.getRequestValue("attrValue",sessid)
 ewd.setSessionValue("attrValue",value,sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 attr = {attributeName:value}
 ok = mdb.put_attributes(domainName,itemName,attr,False)
 return getItemList(sessid)

def deleteItem(sessid):
 domainName=ewd.getSessionValue("domainName",sessid)
 itemName=ewd.getSessionValue("itemName",sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 ok = mdb.delete_attributes(domainName,itemName)
 return getItemList(sessid)

def getAttributes(sessid):
 selectedNo = ewd.getRequestValue('menuItemNo',sessid)
 if selectedNo != "":
   itemName = ewd.getSelectediWDMenuValue("itemList",sessid)
   ewd.setSessionValue("itemName",itemName,sessid)
 else:
   itemName = ewd.getSessionValue("itemName",sessid)
 domainName=ewd.getSessionValue("domainName",sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 query="select * from " + domainName + " where itemName() = '" + itemName + "'"
 items=mdb.select(domainName,query)
 dic = items[0]
 ewd.deleteFromSession("iwdTemp",sessid)
 ewd.deleteFromSession("attributeValues",sessid)
 ewd.mergeDictionaryToSession(dic,"iwdTemp",sessid)
 result = ewd.m_python.m_proc(0, "createAttrList^MDBMgr","attributeValues","iwdTemp",sessid)
 ewd.deleteFromSession("iwdTemp",sessid)
 return ""

def getAttributeDetails(sessid):
 selectedNo = ewd.getRequestValue('menuItemNo',sessid)
 dic = ewd.mergeDictionaryFromSession("attributeValues",sessid)
 ewd.setSessionValue("attribute",dic[selectedNo]['text'],sessid)
 ewd.setSessionValue("attributeName",dic[selectedNo]['name'],sessid)
 ewd.setSessionValue("editAttributeValue",dic[selectedNo]['value'],sessid)
 return ""

def saveAttributeValue(sessid):
 newValue=ewd.getRequestValue("attrValue",sessid)
 domainName=ewd.getSessionValue("domainName",sessid)
 itemName=ewd.getSessionValue("itemName",sessid)
 attributeName=ewd.getSessionValue("attributeName",sessid)
 oldValue=ewd.getSessionValue("editAttributeValue",sessid)
 ewd.setSessionValue("attrValue",newValue,sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 attr2 = {attributeName:newValue}
 ok = mdb.put_attributes(domainName,itemName,attr2,False)
 attr = {attributeName:[oldValue]}
 ok = mdb.delete_attributes(domainName,itemName,attr)
 return getAttributes(sessid)

def saveAttribute(sessid):
 domainName=ewd.getSessionValue("domainName",sessid)
 itemName=ewd.getSessionValue("itemName",sessid)
 attributeName=ewd.getRequestValue("attrName",sessid)
 if attributeName == "":
   return "You must enter an Attribute Name"
 ewd.setSessionValue("attrName",attributeName,sessid)
 value=ewd.getRequestValue("attrValue",sessid)
 ewd.setSessionValue("attrValue",value,sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 attr = {attributeName:value}
 ok = mdb.put_attributes(domainName,itemName,attr,False)
 return getAttributes(sessid)

def initialiseAttribute(sessid):
  ewd.deleteFromSession("attributeName",sessid)
  ewd.deleteFromSession("attributeValue",sessid)
  return ""

def initialiseItem(sessid):
  ewd.deleteFromSession("newItemName",sessid)
  ewd.deleteFromSession("newItemAttributeName",sessid)
  ewd.deleteFromSession("newItemAttributeValue",sessid)
  return ""

def deleteAttribute(sessid):
 domainName=ewd.getSessionValue("domainName",sessid)
 itemName=ewd.getSessionValue("itemName",sessid)
 attributeName=ewd.getSessionValue("attributeName",sessid)
 attributeValue=ewd.getSessionValue("editAttributeValue",sessid)
 username=ewd.getSessionValue("username",sessid)
 password=ewd.getSessionValue("password",sessid)
 mdb = ewd.mdb_connect(username,password,'127.0.0.1')
 attr = {attributeName:[attributeValue]}
 ok = mdb.delete_attributes(domainName,itemName,attr)
 return getAttributes(sessid)




