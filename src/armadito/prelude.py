import prelude

class PreludeClient(prelude.ClientEasy):
    def __init__(self):
        prelude.ClientEasy.__init__(self, "armadito-prelude", 4, "armadito antivirus", "armadito antivirus class", "Teclib'")

    def send_scan_event(self, json_event):
        idmef = prelude.IDMEF()

        # Source
        #idmef.Set("alert.source(0).node.address(0).address", "127.0.0.1")

        # Target
        idmef.set("alert.classification.text", "Threat detected")
        idmef.set("alert.target(0).file(0).name", json_event['module_report'].encode('ascii', 'replace'))
        idmef.set("alert.target(0).file(0).path", json_event['path'].encode('ascii', 'replace'))

        # Assessment
        #idmef.Set("alert.assessment.impact.severity", "low")
        #idmef.Set("alert.assessment.impact.completion", "failed")
        #idmef.Set("alert.assessment.impact.type", "recon")

        # Additional Data
        #idmef.Set("alert.additional_data(0).data", '')

        self.sendIDMEF(idmef)        
