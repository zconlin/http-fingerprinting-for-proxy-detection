# This flask server can act as a standalone echo server or as a WSGI app, but because flask natively edits header capitalizaion during processing we can't use it in production. 

from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/", defaults={"path": ""}) 
@app.route("/<path:path>")
def hello_world(path):
    method = request.method
    full_path = request.full_path
    if not request.args: full_path = full_path[:-1] # Clean the '?' off of the full path if no query string
    http_version = request.environ.get('SERVER_PROTOCOL')

    request_string = f"{method} /echo{full_path} {http_version}\n" 

    header_string = str(request.headers)
    print(request.headers)
    print(header_string)

    combo_string = "<html><body><pre>" + request_string + header_string + "</pre></body></html>"
    
    return combo_string

if __name__ == '__main__':
   app.run()