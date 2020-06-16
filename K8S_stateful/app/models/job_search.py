import datetime
from bson.json_util import dumps
 
from app.database import DB
 
 
class Search(object):
 
    def __init__(self, query_string):
        self.query = query_string
 
    def search(self):
        result = DB.find("sinfo", self.query.to_dict())
        
        return dumps(result, indent=2)
