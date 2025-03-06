from mitmproxy import ctx
from mitmproxy import http

def response(flow: http.HTTPFlow):
	flow.response.content=bytes("ENCORE HACKED", "UTF-8")
	ctx.log.info("REPONSE ENVOYEE")
