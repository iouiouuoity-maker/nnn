import argparse
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
p=argparse.ArgumentParser()
p.add_argument('--host',default='0.0.0.0')
p.add_argument('--port',type=int,default=4173)
p.add_argument('--strictPort',action='store_true')
a=p.parse_args()
root=Path(__file__).resolve().parents[1]/'dist'
ThreadingHTTPServer((a.host,a.port),partial(SimpleHTTPRequestHandler,directory=str(root))).serve_forever()
