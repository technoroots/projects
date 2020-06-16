from flask import Flask
from config import app_config
from app.database import DB
import logging
 
 
def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(app_config[config_name]) #Updates the values from the given object : Load Configuration Defaults
    logging.basicConfig(filename='flask.log', level=logging.DEBUG, format='%(asctime)s %(levelname)s : %(message)s')
    DB.init()
    register_blueprints(app)
    return app
 
 
def register_blueprints(app):
 
    from app.configs import configs as configs_bp
    from app.search import search as search_bp
    app.register_blueprint(configs_bp)
    app.register_blueprint(search_bp)

