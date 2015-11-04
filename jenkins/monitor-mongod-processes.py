#!/usr/bin/env python
# Name: monitor-mongod-processes.py
# Purpose: SSH into boxes with mongodb running, fail if process is down
# Author: Freddie Rosario <rosario@ecohealthalliance.org>

import os,sys

# "Useful name": ["ssh_key", "ip address or fqdn"]
servers = {
  "grid-prod": ["grits-dev.pem", "54.164.176.170"],
  "mongo-tater-prod": ["infrastructure.pem", "52.21.23.33"],
  "grits.ecohealthalliance.org": ["grits-prod.pem", "grits.ecohealthalliance.org"],
  "mantle-dev": ["infrastructure.pem", "52.3.59.100"],
  "tater-prod": ["infrastructure.pem", "54.175.138.187"],
  "rana-dev": ["grits-dev.pem", "52.1.78.153"],
  "rana-prod": ["rana-prod.pem", "52.7.110.184"],
  "grits-dev.ecohealthalliance.org": ["grits-dev.pem", "52.71.252.57"]
}

key_dir = "/keys/"

for name in servers.keys():
  print "Checking " + name + "..."
  SSH = "/usr/bin/ssh -i " + key_dir + servers[name][0] + " ubuntu@" + servers[name][1] + " 'pgrep mongod'"
  return_code = os.system(SSH)
  if return_code != 0:
    print "Problem checking for running mongodb on " + name
    sys.exit(1)

