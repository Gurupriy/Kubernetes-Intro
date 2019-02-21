#!/usr/bin/env python
'''
Demo Application for Cisco Live

Michael Petrinovic 2019
'''

from flask import Flask,request
import os

app = Flask(__name__)

def get_server_name():
    return os.environ['HOSTNAME']

def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError("Not running with the Werkzeug Server")
    func()

@app.route("/<event_name>")
def hello(event_name):
    msg = "<h1>Hello Cisco Live " + event_name + "</h1><br/>"
    server = get_server_name()
    msg = msg + "<h3>I'm brought to you by Container: </h3><h2><b>" + server + "</b></h2><br/>"
    return msg

@app.route('/shutdown', methods=['GET'])
def shutdown():
    shutdown_server()
    server = get_server_name()
    msg = "<h3>Shutting down server: </h3><h2><b>" + server + "</b></h2><br/>"
    return msg

if __name__ == "__main__":
    app.run(host='0.0.0.0')