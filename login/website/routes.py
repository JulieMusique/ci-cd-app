from flask import flash
import time
from secrets import token_urlsafe
from flask import Blueprint, request, session, url_for
from flask import render_template, redirect
import requests
from werkzeug.security import gen_salt
from authlib.integrations.flask_oauth2 import current_token
from authlib.oauth2 import OAuth2Error
from .models import OAuth2Token, db, User, OAuth2Client
from .oauth2 import PasswordGrant, authorization, require_oauth

bp = Blueprint('home', __name__)


def current_user():
    if 'id' in session:
        uid = session['id']
        return User.query.get(uid)
    return None


@bp.route('/', methods=('GET', 'POST'))
def home():
    if request.method == 'POST':
        # Si la méthode est POST, cela signifie que l'utilisateur soumet le formulaire de connexion
        username = request.form.get('username')
        password = request.form.get('password')

        user = User.query.filter_by(username=username).first()

        if user and user.check_password(password):
            session['id'] = user.id
            flash('Login successful', 'success')
            create_client_for_user(user)
            return redirect('/')
        else:
            flash('Invalid username or password', 'danger')

    # Si la méthode est GET ou si la connexion échoue, afficher la page d'accueil normale
    user = current_user()

    # Si l'utilisateur n'est pas authentifié, rediriger vers la page de connexion
    #if not user:
    #    return render_template('SignIn.html')

    all_clients = OAuth2Client.query.all() if user and user.isAdmin else []
    print("Tous les clients:", all_clients)
    if user:
        clients = OAuth2Client.query.filter_by(user_id=user.id).all()
        print("Clients associés à l'utilisateur:", clients)
    else:
        clients = []

    return render_template('home.html', user=user, clients=clients, all_clients=all_clients)

def issue_token():
    return authorization.create_token_response()

def create_client_for_user(user):
    print("Créer un client pour l'utilisateur")
    client_id = gen_salt(24)
    client_id_issued_at = int(time.time())
    client = OAuth2Client(
        client_id=client_id,
        client_id_issued_at=client_id_issued_at,
        user_id=user.id,
    )
    client_metadata = {
        "username": user.username,
        "scope": "complete access" if user and user.isAdmin else "read only"
    }
    client.set_client_metadata(client_metadata)
    client.client_secret = gen_salt(48)

    db.session.add(client)
    db.session.commit()

    access_token = token_urlsafe(32)
    print("access_token : ", access_token )
    token = OAuth2Token(
        user_id=user.id,
        client_id=client.client_id,
        token_type=None,  
        access_token=access_token,  
        refresh_token=None, 
        scope="complete access" if user.isAdmin else "read only",
        issued_at=int(time.time()),
        access_token_revoked_at=0,
        refresh_token_revoked_at=0,
        expires_in=0,
    )

    print("token : ", token )
    db.session.add(token)
    db.session.commit()
    
    flash(f"Client '{client_id}' créé avec succès pour l'utilisateur '{user.username}'.", "success")


@bp.route('/logout')
def logout():
    del session['id']
    return redirect('/')


@bp.route('/create_user', methods=('GET', 'POST'))
def create_user():
    user = current_user()

    if request.method == 'GET':
        return render_template('create_user.html')

    form = request.form
    username = form['username']
    password = form['password']

    existing_user = User.query.filter_by(username=username).first()

    if existing_user:
        flash(f"L'utilisateur '{username}' existe déjà.", "danger")
    else:
        # L'utilisateur n'existe pas, créons un nouvel utilisateur et un client associé
        new_user = User(username=username)
        new_user.set_password(password)  # Utilisez la fonction set_password pour hacher le mot de passe
        db.session.add(new_user)
        db.session.commit()

        create_client_for_user(new_user)

    return redirect('/')

@bp.route('/oauth/authorize', methods=['GET', 'POST'])
def authorize():
    user = current_user()
    # if user log status is not true (Auth server), then to log it in
    if not user:
        return redirect(url_for('home.home', next=request.url))
    if request.method == 'GET':
        try:
            grant = authorization.get_consent_grant(end_user=user)
        except OAuth2Error as error:
            return error.error
        return render_template('authorize.html', user=user, grant=grant)
    if not user and 'username' in request.form:
        username = request.form.get('username')
        user = User.query.filter_by(username=username).first()
    if request.form['confirm']:
        grant_user = user
    else:
        grant_user = None
    return authorization.create_authorization_response(grant_user=grant_user)





@bp.route('/oauth/token', methods=['POST'])
def issue_token():
    return authorization.create_token_response()


@bp.route('/oauth/revoke', methods=['POST'])
def revoke_token():
    return authorization.create_endpoint_response('revocation')

@bp.route('/protected', methods=['GET'])
def protected_resource():
    user = current_user()

    # Vérifiez si l'utilisateur est authentifié
    if not user:
        print('Unauthorized')
        return redirect('/')
    
    # Récupérez le token actuel
    last_token = OAuth2Token.get_last_token_for_user(user.id)

    print("Last token for user:", last_token)
    a = True if 'complete access' in last_token.scope else False
    print("token contains admin's rights ? ",a )

    if last_token:
        if 'complete access' in last_token.scope:
            print("Access granted to protected resource for user:", user.username)
            print("Access Token:", last_token.access_token)
            print("Scope:", last_token.scope)
        else:
            print("Insufficient scope for this resource. Admin rights required.")
            flash("Tu dois avoir les droits d'admin pour accéder à cette ressource.", "danger")
            return redirect('/')
    else:
        print("No access token found.")

    return render_template('Appcicd.html', user=user)



