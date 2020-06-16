from flask import jsonify, request, current_app
         
from . import search
from app.models.job_search import Search
         
@search.route('/search', methods=['GET'])
def search():
    """Search metadata."""
    if request.method == 'GET':
        req_data = Search(query_string=request.args)
        answer = req_data.search()
        if answer != "[]":
            current_app.logger.info('%s %s %s Message:\"Search %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), request.args.to_dict())
            return (answer), 200
        else:
            current_app.logger.info('%s %s %s Message:\"Not Found %s\"', request.path, request.method, request.environ.get("REMOTE_ADDR"), request.args.to_dict())
            return jsonify({"message": "No records found"}), 404
