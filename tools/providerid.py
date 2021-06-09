#!/usr/bin/env python
import argparse
import json
import copy
patch = {'spec': {}}

parser = argparse.ArgumentParser()
parser.add_argument('-j')
args = parser.parse_args()

with open(args.j) as fh:
    data = json.load(fh)

for i in data:
    p = copy.deepcopy(patch)
    p['spec']['providerID'] = 'aws:///' + i['az'] + '/' + i['id']
    print('kubectl patch node ' + i['private_dns'] + ' -p \'' + json.dumps(p) + '\'')
