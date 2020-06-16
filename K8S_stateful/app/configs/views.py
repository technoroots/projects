from flask import jsonify, request, json, current_app
         
from . import configs
from app.models.job import Configs
         

#health check
@configs.route('/health')
def index():
    """Main page route."""
    current_app.logger.info('%s %s %s', request.path, request.method, request.environ.get("REMOTE_ADDR"))
    return jsonify(status="200", message="Sever Running")

                 
@configs.route('/configs', methods=['GET', 'POST', 'PUT', 'DELETE'])
def query_configs():
    """List, Create, Get, Update, Delete Server config"""
    # Validate the request body contains JSON
    if request.is_json:
        dcinfo = request.get_json()
        if request.method == 'POST':
            new_job = Configs(dcname=dcinfo["name"], metadata=dcinfo["metadata"])
            response = new_job.insert()
            if response == None:
                 current_app.logger.info('%s %s %s Message:\"Name already exist for %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcinfo["name"])
                 return jsonify({ "ok":False, "message": "Name already exist for {}".format(dcinfo["name"]) }), 404
            else:
                current_app.logger.info('%s %s %s Message:\"Successfully inserted for %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcinfo["name"])
                return jsonify({ "ok":True, "message": "Successfully inserted for {}".format(dcinfo["name"]) }), 200
    elif request.path == "/configs":
        req_data = Configs(dcname={}, metadata={})
        answer = req_data.find()
        current_app.logger.info('%s %s %s Message:\"Show all DCs\"', request.path, request.method, request.environ.get("REMOTE_ADDR"))
        return answer, 200
    else:
        return jsonify({"ok":False, "message": "Invalid JSON"}), 400



@configs.route('/configs/<dcname>', methods=['GET', 'PUT', 'DELETE'])
def query_routes(dcname):
    if request.method == 'GET':
        req_data = Configs(dcname={'name':dcname}, metadata={})
        answer = req_data.find()
        if answer != "[]":
            current_app.logger.info('%s %s %s Message:\"Requested %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcname)
            return answer, 200
        else:
            current_app.logger.info('%s %s %s Message:\"Not found %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcname)
            response = {'message':"{} not found".format(dcname)}
            return jsonify(response), 404

    if request.method == 'DELETE':
            delete_job = Configs(dcname=dcname, metadata={})
            response = delete_job.delete()
            if response == 1:
                current_app.logger.info('%s %s %s Message:\"Record deleted %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcname)
                response = {'ok': True, 'message': 'record deleted'}
            else:
                current_app.logger.info('%s %s %s Message:\"Record not found %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcname)
                response = {'ok': True, 'message': 'no record found'}
            return jsonify(response), 200

    if request.method == 'PUT':
        if request.is_json:
            delete_job = Configs(dcname=dcname, metadata={})
            response = delete_job.delete()
            if response == 1:
                dcinfo = request.get_json()
                new_job = Configs(dcname=dcinfo["name"], metadata=dcinfo["metadata"])
                response = new_job.insert()
                current_app.logger.info('%s %s %s Message:\"DC info updated for %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcinfo["name"])
                return jsonify({"ok": True, "message": "DC Info updated for {}".format(dcname) }), 200
            else:
                current_app.logger.info('%s %s %s Message:\"DC info not found for %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), dcname)
                return jsonify({ "ok":False, "message": "No records found for {}".format(dcname) }), 404
        else:
            return jsonify({"ok":False, "message": "Invalid JSON"}), 400

