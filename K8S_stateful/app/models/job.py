from flask import jsonify
from bson.json_util import dumps
import sys
 
from app.database import DB
 
 
class Configs(object):
 
    def __init__(self, dcname, metadata):
        self.name = dcname
        self.metadata = metadata
 
    def insert(self):
        try:
            if not DB.find_one("sinfo", {"name": self.name}):
#            try:
                id = DB.insert(collection='sinfo', data=self.json()).inserted_id
                return (id, 204)
#            except pymongo.errors.ConnectionFailure as e:
#                return jsonify({'ok': False, 'message': str(e)}), 500
#         else:
              #return jsonify({'ok': True, 'message': "Name already exist for {}".format(self.name))}), 400
        except:
            e = sys.exc_info()[0]
#            print(e)
            #return ('ok': True, 'message': "Name already exist for {}".format(self.name)}, 400
            return (e, 402)

    def delete(self):
        if not DB.find_one("sinfo", {"name": self.name}):
            return 0
        else:
            query_result = DB.delete(collection='sinfo', dcname={'name':self.name})
            return (query_result.deleted_count)
        

    def json(self):
        return {
            'name': self.name,
            'metadata': self.metadata
        }

    def find(self):
        result = DB.find("sinfo", self.name)

#        for keys in result:
        return dumps(result, indent=2)

