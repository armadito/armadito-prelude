import prelude
from PreludeEasy import ClientEasy

class PreludeClient(ClientEasy):
    def __init__(self):
        ClientEasy.__init__(self, "armadito-prelude", 4, "armadito antivirus", "armadito antivirus class", "Teclib'")
