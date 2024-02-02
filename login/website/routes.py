import json
import os
import subprocess
from flask import flash, jsonify, Blueprint, request, session, url_for, render_template, redirect
import time
from secrets import token_urlsafe
import requests
from sqlalchemy import desc
from werkzeug.security import gen_salt
from authlib.integrations.flask_oauth2 import current_token
from authlib.oauth2 import OAuth2Error
from .models import OAuth2Token, db, User, OAuth2Client, HistoryPipeline
from .oauth2 import PasswordGrant, authorization, require_oauth
from datetime import datetime
import random
import string
bp = Blueprint('home', __name__)

def current_user():
    if 'id' in session:
        uid = session['id']
        return User.query.get(uid)
    return None

def current_user_pipeline():
    if 'id' in session:
        uid = session['id']
        return HistoryPipeline.query.filter_by(idUser = uid).order_by(desc(column="id")).all()
    return None

def all_pipelines():
    return HistoryPipeline.query.order_by(desc(column="id")).all()

@bp.route('/last_user_pipeline', methods=['GET'])
def last_user_pipeline():
    if 'id' in session:
        uid = session['id']
        pipeline_data = HistoryPipeline.query.filter_by(idUser=uid).order_by(desc(column="id")).first()
        if pipeline_data:
            response_data = {
                'id': pipeline_data.id,
                'status': pipeline_data.status,
                'stages_status': pipeline_data.stages_status,
                'duration': pipeline_data.duration,
                'date': pipeline_data.date.strftime("%Y-%m-%dT%H:%M:%S.%fZ") if pipeline_data.date else None
            }
            return jsonify(response_data)
    return jsonify({'error': 'User not authenticated'}), 401

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
            return redirect('/protected')
        else:
            flash('Invalid username or password', 'danger')

    # Si la méthode est GET ou si la connexion échoue, afficher la page d'accueil normale
    user = current_user()

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
    redirect('/protected')

@bp.route('/logout')
def logout():
    del session['id']
    flash('Logout successful', 'success')
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
        new_user.set_password(password)
        db.session.add(new_user)
        db.session.commit()

        create_client_for_user(new_user)

    return redirect('/protected')

def generate_random_alphanumeric(length=8):
    charset = string.ascii_letters + string.digits
    result = ''.join(random.choice(charset) for _ in range(length))
    return result

@bp.route('/create_pipeline', methods=('GET', 'POST'))
def create_pipeline():
    user = current_user()

    if request.method == 'GET':
        return redirect('/protected')
    
    pipelineNumber = generate_random_alphanumeric()

    existing_user = User.query.filter_by(username=user.username).first()
    if existing_user:
        data = request.get_json()
        pipeline_id = '#' + str(pipelineNumber)
        pipeline_idUser = user.id
        pipeline = HistoryPipeline(idPipeline=pipeline_id, idUser=pipeline_idUser, date=datetime.strptime(data["date"], "%Y-%m-%dT%H:%M:%S.%fZ"), status="En cours", stages_status="", duration="")
        db.session.add(pipeline)
        db.session.commit()
        serializable_data = {
            'id':  pipeline_id,
            'idPipeline': pipeline.idPipeline,
            'idUser': pipeline.idUser,
            'date': pipeline.date.isoformat(),
            'status': pipeline.status,
            'stages_status': pipeline.stages_status,
            'duration': pipeline.duration
        }
        return jsonify({'newPipeline':serializable_data})
    else:
        flash(f"L'utilisateur '{user.username}' n'existe pas.", "danger")
        return render_template('create_user.html')

@bp.route('/update_pipeline', methods=('GET', 'POST'))
def update_pipeline():
    user = current_user()

    if request.method == 'GET':
        return redirect('/protected')

    existing_user = User.query.filter_by(username=user.username).first()
    # Assuming data is received as JSON in the request
    if existing_user:
        data = request.get_json()

        # Check if 'id' key is present in data
        if 'id' in data:
            pipeline_id = data['id']
            existing_pipeline = HistoryPipeline.query.filter_by(id=pipeline_id).first()

            if existing_pipeline:
                # Update the existing pipeline
                existing_pipeline.duration = str(data["duration"]) + " milliseconds"
                existing_pipeline.status = data["status"]
                existing_pipeline.stages_status = json.dumps(data["stages_status"])
                db.session.commit()
            else:
                flash(f"Pipeline with ID {pipeline_id} not found.", "danger")
    else:
        flash(f"L'utilisateur '{user.username}' n'existe pas.", "danger")
        return render_template('create_user.html')

    return redirect('/protected')

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
    all_clients = OAuth2Client.query.all() if user and user.isAdmin else []
    #print("Tous les clients:", all_clients)
    if user:
        clients = OAuth2Client.query.filter_by(user_id=user.id).all()
        print("Clients associés à l'utilisateur:", clients)
    else:
        clients = []
    # Vérifiez si l'utilisateur est authentifié
    if not user:
        print('Unauthorized')
        return redirect('/')
    
    # Récupérez le token actuel
    last_token = OAuth2Token.get_last_token_for_user(user.id)
    
    if user.isAdmin:
        pipelines = all_pipelines()
    else:
        pipelines = current_user_pipeline()
    
    print("Last token for user:", last_token)
    a = True if 'complete access' in last_token.scope else False
    print("token contains admin's rights ? ",a )

    if last_token:
        if 'complete access' or 'read only' in last_token.scope:
            print("Access granted to protected resource for user:", user.username)
            print("Access Token:", last_token.access_token)
            print("Scope:", last_token.scope)
        else:
            print("Insufficient scope for this resource. Admin rights required.")
            flash("Tu dois avoir les droits d'admin pour accéder à cette ressource.", "danger")
            return redirect('/')
    else:
        print("No access token found.")

    return render_template('Appcicd.html', user=user, pipelines=pipelines, clients=clients, all_clients=all_clients)

@bp.route('/run_code')
def run_code():
  
    script_path = './shells/codeGit.py'
    return execute_script(script_path, 'result1')

@bp.route('/run_second_code')
def run_second_code():
    script_path = os.path.join('shells', 'BuildBack.py')
    return execute_script(script_path, 'result2')

@bp.route('/run_sonar_code')
def run_sonar_code():
    script_path = os.path.join('shells', 'SonarQube.py')
    return execute_script(script_path, 'result3')

@bp.route('/create_dockers')
def create_dockers():
    script_path = os.path.join('shells', 'CreateDockerfile.py')
    return execute_script(script_path, 'result4')

@bp.route('/deploy')
def deploy():
    script_path = os.path.join('shells', 'DockerBuild.py')
    return execute_script(script_path, 'result5')


def execute_script(script_path, result_div_id):
    output_data = ""
    try:
        process = subprocess.Popen(['python', script_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        outputdata, _ = process.communicate()
        exit_code = process.returncode
        print(f'child process exited with code {exit_code}')

        # Utilisez outputdata au lieu de output_data
        output_data = outputdata.decode(encoding="ISO-8859-1")

        return jsonify(output=output_data, exitCode=exit_code, resultDivId=result_div_id)
    except Exception as e:
        print(f'Error executing script: {e}')
        return jsonify(error=str(e))
