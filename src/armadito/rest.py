import requests
import json

class ApiClient(object):
    def __init__(self, port = 8888, verbose = False):
        self._port = port
        self._api_root = 'http://127.0.0.1:%d/api' % (self._port,)
        self._token = None
#        self._config = {}
#        if verbose:
#            self._config['verbose'] = sys.stderr

    def call(self, path, data = None):
        headers = {'User-Agent':'python-requests'}
        if self._token is not None:
            headers['X-Armadito-Token'] = self._token
        if data is not None:
            headers['Content-Type'] = 'application/json'
        if data is not None:
# error on config            resp = requests.post(self._api_root + path, data = json.dumps(data), headers = headers, config = self._config)
            resp = requests.post(self._api_root + path, data = json.dumps(data), headers = headers)
        else:
            resp = requests.get(self._api_root + path, headers = headers)
        return resp.json()

    def register(self):
        j_token = self.call('/register')
        self._token = j_token['token']

    def unregister(self):
        self.call('/unregister')
