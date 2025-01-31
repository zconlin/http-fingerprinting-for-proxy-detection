from flask import Flask, request

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

    combo_string = "<html><body><pre>" + request_string + header_string + "</pre></body></html>"
    
    return combo_string

if __name__ == '__main__':
   app.run()