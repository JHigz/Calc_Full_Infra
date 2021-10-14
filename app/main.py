from flask import Flask, make_response, request, render_template
from random import random
import datetime
import jwt



SECRET_KEY = '72B161975BE6DC97F1693198A2741'
flask_app=Flask(__name__)


def verify_token(token):
    if token :
        decoded_token = jwt.decode(token, SECRET_KEY, "HS256")
        print (decoded_token)
        # Check whether the information in decoded token is correct or not

        return True # if info is correct otherwise return false
    else:
        return False



@flask_app.route('/')
def index_page():
    print(request.cookies)
    isUserLoggedIn=False
    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])


    if isUserLoggedIn:
        return "Welcome back to the website"
    else:
        user_id = random()
        print(f"User ID: {user_id}")
        resp = make_response("This is the Index page of the Secure REST API")
        resp.set_cookie('user_id', str(user_id))
        return resp

def create_token(username, password):
    validity = datetime.datetime.utcnow() + datetime.timedelta(days=15)
    token = jwt.encode({'user_id':617891, 'username' : username, 'expiry' : str(validity)}, SECRET_KEY, "HS256")
    return token



@flask_app.route('/help')
def help_page():
    return "This is the help page"

@flask_app.route('/login')
def login_page():
    return render_template('login.html')

@flask_app.route('/authenticate', methods = ['POST'])
def authenticate_user():
    data=request.form
    username = data['username']
    password = data['password']

    # check whether username and password are correct
    user_token = create_token(username, password)

    resp = make_response('Logged in successfully')
    #resp.set_cookie('LoggedIn', 'True')
    resp.set_cookie('token', user_token)
    return resp


if __name__ == "__main__":
    print("This is a Secure REST API Server")
    flask_app.run(debug = True, ssl_context=('cert/cert.pem', 'cert/key.pem'))
