import ewd


def getCDTracksXArtist(sessid):
 artist = ewd.getSessionValue('cdArtist',sessid)
 if artist == '':
   return "You must specify an artist"
 mdb = ewd.mdb_connect('rob','1234567','127.0.0.1')
 query="SELECT Name FROM itunes where Artist = '" + artist + "'"
 items=mdb.select('itunes',query)
 noOfItems = len(items)
 if noOfItems == 0:
   return "No matches found"
 ewd.createiWDMenuFromDictionary(items,"Name","TrackList",sessid)
 return ""


def getTrackDetails(sessid):
 trackTitle = ewd.getSelectediWDMenuValue("TrackList",sessid)
 trackName = ewd.double_up_quotes(trackTitle)
 artist = ewd.getSessionValue('cdArtist',sessid)
 mdb = ewd.mdb_connect('rob','1234567','127.0.0.1')
 query="SELECT * FROM itunes where Artist = '" + artist + "' and Name = '" + trackName +"'"
 items=mdb.select('itunes',query)
 ewd.setSessionValue("trackName",trackTitle,sessid)
 ewd.setSessionValue("albumName",items[0]["Album"],sessid)
 ewd.setSessionValue("composer",items[0]["Composer"],sessid)
 ewd.setSessionValue("trackNo",items[0]["Track Number"],sessid)
 ewd.setSessionValue("time",items[0]["Time"],sessid)
 return ""
