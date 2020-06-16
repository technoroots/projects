from flask import Blueprint
            
configs = Blueprint('configs', __name__)
            
from . import views
