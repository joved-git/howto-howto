from mitmproxy import http


def response(flow: http.HTTPFlow):
    reflector = b"HACKED"
    flow.response.content = flow.response.content.replace(b"Science", reflector)
