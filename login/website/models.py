import time
from flask_sqlalchemy import SQLAlchemy
from authlib.integrations.sqla_oauth2 import (
    OAuth2ClientMixin,
    OAuth2AuthorizationCodeMixin,
    OAuth2TokenMixin,
)
from sqlalchemy import desc
#from sqlalchemy import DateTime
#from sqlalchemy import text
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(40), unique=True)
    _password_hash = db.Column("password_hash", db.String(128))  # Champ pour stocker le mot de passe haché
    _is_admin = db.Column("isAdmin", db.Boolean, default=False)

    def __str__(self):
        return self.username

    def get_user_id(self):
        return self.id

    @property
    def isAdmin(self):
        return self._is_admin

    @property
    def password_hash(self):
        return self._password_hash

    def set_password(self, password):
        # Fonction pour hacher et définir le mot de passe
        self._password_hash = generate_password_hash(password, method='pbkdf2:sha1', salt_length=8)

    def check_password(self, password):
        # Fonction pour vérifier le mot de passe
        return check_password_hash(self._password_hash, password)


class OAuth2Client(db.Model, OAuth2ClientMixin):
    __tablename__ = 'oauth2_client'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(
        db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'))
    user = db.relationship('User')


class OAuth2AuthorizationCode(db.Model, OAuth2AuthorizationCodeMixin):
    __tablename__ = 'oauth2_code'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(
        db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'))
    user = db.relationship('User')


class OAuth2Token(db.Model, OAuth2TokenMixin):
    __tablename__ = 'oauth2_token'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(
        db.Integer, db.ForeignKey('user.id', ondelete='CASCADE'))
    user = db.relationship('User')

    def is_refresh_token_active(self):
        if self.revoked:
            return False
        expires_at = self.issued_at + self.expires_in * 2
        return expires_at >= time.time()
    
    def get_last_token_for_user(user_id):
        # Récupérer le dernier token pour un utilisateur spécifique
        return OAuth2Token.query.filter_by(user_id=user_id).order_by(desc(OAuth2Token.issued_at)).first()

class HistoryPipeline(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    idPipeline = db.Column(db.Integer)
    idUser = db.Column(db.Integer)
    date = db.Column(db.DateTime)
    status = db.Column(db.String(20))
    stages_status = db.Column(db.String(50))
    duration = db.Column(db.String(20))

    def __str__(self):
        return str(self.idPipeline)

    def get_user_id(self):
        return self.idUser

    def get_status(self):
        return self.status

    def get_date(self):
        return self.date

    def get_stages_status(self):
        return self.stages_status

    def get_duration(self):
        return self.duration

    def set_duration(self, duration):
        self.duration = duration

    def set_status(self, status):
        self.status = status

    def set_stages_status(self, stages_status):
        self.stages_status = stages_status