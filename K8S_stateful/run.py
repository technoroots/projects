import os
import logging
from app import create_app

config_name = os.getenv('FLASK_CONFIG')
app = create_app(config_name)

# execute only if run as a script
if __name__ == '__main__':
    
    logging.basicConfig(filename='error.log',level=logging.DEBUG)
    app.run(debug=True)
