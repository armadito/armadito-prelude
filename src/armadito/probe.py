import prelude

class Probe(prelude.ClientEasy):
    def __init__(self):
        prelude.ClientEasy.__init__(self, "armadito-prelude", 4, "armadito antivirus", "antivirus", "Teclib'")

    def _json_str(jobj, attr):
        return jobj[attr].encode('ascii', 'replace')

    def newIDMEF(self):
        idmef = prelude.IDMEF()

        # Source
        #idmef.Set("alert.source(0).node.address(0).address", "127.0.0.1")

        # analyzer
        idmef.set("alert.analyzer(0).name", "Armadito antivirus")
        idmef.set("alert.analyzer(0).manufacturer", "www.teclib.com")
        idmef.set("alert.analyzer(0).class", "Antivirus")

        return idmef
        

    #from https://www.prelude-siem.org/projects/prelude-lml-rules/repository/revisions/master/entry/ruleset/clamav.rules
    # classification.text=Virus found: $2; \
    # id=3200; \
    # revision=2; \
    # analyzer(0).name=Clam Antivirus; \
    # analyzer(0).manufacturer=www.clamav.net; \
    # analyzer(0).class=Antivirus; \
    # assessment.impact.severity=high; \
    # assessment.impact.type=file; \
    # assessment.impact.completion=succeeded; \
    # assessment.impact.description=A virus has been identified by ClamAV; \
    # additional_data(0).type=string; \
    # additional_data(0).meaning=File location; \
    # additional_data(0).data=$1; \
    # additional_data(1).type=string; \
    # additional_data(1).meaning=Malware name; \
    # additional_data(1).data=$1; \
    # last


    def send_scan_event(self, json_event):
        idmef = self.newIDMEF()

        # classification
        idmef.set("alert.classification.text", "Threat detected")

        # Assessment
        idmef.set("alert.assessment.impact.severity", "high")
        idmef.set("alert.assessment.impact.type", "file")
        idmef.set("alert.assessment.impact.completion", "succeeded")
        idmef.set("alert.assessment.impact.description", "virus detected by Armadito antivirus")

        # Additional Data
        idmef.set("alert.additional_data(0).type", "string")
        idmef.set("alert.additional_data(0).meaning", "File location")
        idmef.set("alert.additional_data(0).data", _json_str(json_event, 'path'))

        idmef.set("alert.additional_data(1).type", "string")
        idmef.set("alert.additional_data(1).meaning", "Virus name")
        idmef.set("alert.additional_data(1).data", _json_str(json_event, 'module_report'))

        self.sendIDMEF(idmef)        


    def send_scan_event(self, json_event):
        idmef = self.newIDMEF()
        
        # classification
        idmef.set("alert.classification.text", "t detected")

        # Assessment
        idmef.set("alert.assessment.impact.severity", "info")
        idmef.set("alert.assessment.impact.type", "other")
        idmef.set("alert.assessment.impact.completion", "succeeded")
        idmef.set("alert.assessment.impact.description", "status for Armadito antivirus ")

        self.sendIDMEF(idmef)        
