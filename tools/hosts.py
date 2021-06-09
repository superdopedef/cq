#!/usr/bin/env python
import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('-j')
args = parser.parse_args()

with open(args.j) as fh:
    data = json.load(fh)

for i in data:
    print(i['private_ip'] + '\t' + i['name'])
    print(i['public_ip'] + '\t' + i['name'] + '.public')
