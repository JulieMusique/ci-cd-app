# website/app.py
from flask import Flask
from .models import User, db
from .routes import bp
from .oauth2 import config_oauth

def create_app(config=None):
    app = Flask(__name__)
    # load app sepcified configuration
    if config is not None:
        if isinstance(config, dict):
            app.config.update(config)
        elif config.endswith('.py'):
            app.config.from_pyfile(config)
    setup_app(app)
    return app

def setup_app(app):

    db.init_app(app)
    # Create tables if they do not exist already
    with app.app_context():
        db.create_all()
        # Check if an admin user exists
        admin_user = User.query.filter_by(username='admin').first()

        # If admin user doesn't exist, create one
        if not admin_user:
            admin_user = User(username='admin', _is_admin=True)
            # You should hash the password in a real-world scenario
            admin_user.set_password('admin')  
            db.session.add(admin_user)
            db.session.commit()
    config_oauth(app)
    app.register_blueprint(bp, url_prefix='')