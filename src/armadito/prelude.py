import prelude
from PreludeEasy import ClientEasy, IDMEF
import prelude

class PreludeClient(ClientEasy):
    def __init__(self):
        ClientEasy.__init__(self, "armadito-prelude", 4, "armadito antivirus", "armadito antivirus class", "Teclib'")

    def send_scan_event(self, json_event):
        idmef = IDMEF()

        # Source
        #idmef.Set("alert.source(0).node.address(0).address", "127.0.0.1")

        # Target
        idmef.Set("alert.classification.text", "Threat detected")
        idmef.Set("alert.target(0).file(0).name", json_event['module_report'].encode('ascii', 'replace'))
        idmef.Set("alert.target(0).file(0).path", json_event['path'].encode('ascii', 'replace'))

        # Assessment
        #idmef.Set("alert.assessment.impact.severity", "low")
        #idmef.Set("alert.assessment.impact.completion", "failed")
        #idmef.Set("alert.assessment.impact.type", "recon")

        # Additional Data
        #idmef.Set("alert.additional_data(0).data", '')

        self.SendIDMEF(idmef)        
