#!/usr/bin/env python2.7
import sys
import logging
import getopt

import armadito.rest
import armadito.probe

def usage():
    print >> sys.stderr, 'Usage: armadito-prelude-agent OPTIONS ARGS'
    print >> sys.stderr, 'Launch Armadito Prelude agent.'
    print >> sys.stderr, ''
    print >> sys.stderr, 'Options:'
    print >> sys.stderr, '  -a ACTION | --action=ACTION     launch ACTION (\'scan\' or \'status\''
    print >> sys.stderr, ''
    sys.exit(1)

logger = None

def main():
    fmt = '%(asctime)s (process:%(process)s) %(levelname)s %(message)s'
    logging.basicConfig(format=fmt)
    #d = {'clientip': '192.168.0.1', 'user': 'fbloggs'}
    global logger
    logger = logging.getLogger('armadito prelude')
    logger.setLevel(logging.DEBUG)
    logger.info('Armadito Prelude probe (C) Teclib\' 2016')

    try:
        opts, args = getopt.getopt(sys.argv[1:], "ha:v", ["help", "action="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print str(err)  # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    action = None
    verbose = False
    for o, a in opts:
        if o == "-v":
            verbose = True
        elif o in ("-h", "--help"):
            usage()
        elif o in ("-a", "--action"):
            action = a
        else:
            assert False, "unhandled option"
    if action is None:
        usage()
    logger.info('options parsed')
    do_action(action, verbose, args)


def do_action(action, verbose, args):
    a = armadito.rest.ApiClient(verbose = verbose)
    p = armadito.probe.Probe()
    global logger
    logger.info('PreludeClient initialized')
    p.start()
    logger.info('PreludeClient started')
    a.register()
    logger.info('Armadito REST client registered')
    if action == 'scan':
        a.call('/scan', {'path' : args[0]})
    elif action == 'status':
        a.call('/status')
    while True:
        j_ev = a.call('/event')
        logger.debug('got event: %s', str(j_ev))
        if j_ev['event_type'] == 'DetectionEvent':
            p.send_scan_event(j_ev)
        elif j_ev['event_type'] == 'OnDemandProgressEvent':
            # do nothing for now
            continue
        elif j_ev['event_type'] == 'OnDemandCompletedEvent':
            break
        elif j_ev['event_type'] == 'StatusEvent':
            p.send_status_event(j_ev)
            break
    a.unregister()
    logger.info('Armadito REST client unregistered')


if __name__ == "__main__":
    main()
    
