#!/usr/bin/env bash
if puppet config print server | grep -v -q `hostname`; then
  echo "This task can only be run on the master node."; 
  exit 1
fi
cd /etc/puppetlabs/puppet/;/opt/puppetlabs/puppet/bin/eyaml decrypt -s "$PT_data"