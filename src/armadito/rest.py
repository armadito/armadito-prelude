import requests
import json

class Client(object):
    def __init__(self, port):
        self._port = port
        self.api_root = 'http://127.0.0.1:%d/api' % (self.port,)

    def call(self, path, data = None):
        headers = {'User-Agent':'python-requests'}
        if self._token is not None:
            headers['X-Armadito-Token'] = self._token
        if data is not None:
            headers['Content-Type'] = 'application/json'

        if data is not None:
            resp = requests.post(api_root + path, data = json.dumps(data), headers = headers)
        else:
            resp = requests.get(api_root + path, headers = headers)

        return resp.json()

    def register(self):
        j_token = self.call('/register')
        self.token = j_token['token']

    def unregister(self):
        call('/unregister')

#resp
#resp.headers
#resp.text
#token = resp.json()['token']
#scan = requests.post(api_root + '/scan', data = {'path':'/home/fdechelle/Bureau/MalwareStore/contagio-malware'})
#scan
#my_headers = {'User-Agent':'python-requests', 'X-Armadito-Token' : str(token)}
#scan = requests.post(api_root + '/scan', data = {'path':'/home/fdechelle/Bureau/MalwareStore/contagio-malware'}, headers = my_headers)
#scan
#my_headers['Content-Type']='application/json'
#my_headers
#scan = requests.post(api_root + '/scan', data = {'path':'/home/fdechelle/Bureau/MalwareStore/contagio-malware'}, headers = my_headers)
#scan
#scan_data =  {'path':'/home/fdechelle/Bureau/MalwareStore/contagio-malware'}
#scan = requests.post(api_root + '/scan', data = json.dumps(scan_data), headers = my_headers)
#scan
#ev_resp = requests.post(api_root + '/event', headers = my_headers)
#ev_resp = requests.get(api_root + '/event', headers = my_headers)
#ev_resp.json()
#requests.get(api_root + '/event', headers = my_headers).json()
