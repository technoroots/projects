import pymongo
import os
          
          
class DB(object):
    
    URI = os.getenv('MONGO_URI')      
          
    @staticmethod
    def init():
        client = pymongo.MongoClient(DB.URI)
        DB.DATABASE = client['sample_app']                                                                                                                                   
          
    @staticmethod
    def insert(collection, data):
        DB.DATABASE[collection].insert(data)
          
    @staticmethod
    def find_one(collection, query):
        return DB.DATABASE[collection].find_one(query)

    @staticmethod
    def find(collection, query):
        return DB.DATABASE[collection].find(query, {'_id': False})

    @staticmethod
    def delete(collection, dcname):
        return DB.DATABASE[collection].delete_one(dcname)

    @staticmethod
    def patch(collection, data):
        return DB.DATABASE[collection].update_one(data)
