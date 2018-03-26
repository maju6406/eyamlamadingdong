#!/usr/bin/env bash
if puppet config print server | grep -v -q `hostname`; then
  echo "This task can only be run on the master node."; 
  exit 1
fi

#install eyaml gem
/opt/puppetlabs/puppet/bin/puppet resource package hiera-eyaml ensure=present provider=puppet_gem
#make backup copies of existing keys
mv /etc/puppetlabs/puppet/keys/private_key.pkcs7.pem "/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem.$today"
mv /etc/puppetlabs/puppet/keys/public_key.pkcs7.pem "/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem.$today"
cd /etc/puppetlabs/puppet/;/opt/puppetlabs/puppet/bin/eyaml createkeys
# Update hiera.yaml
IFS=',' read -a paths <<< "${PT_paths}"
for i in "${!paths[@]}"
do
  path_str+=$'      -  '
  path_str+=$"\"${paths[i]}\""
  path_str+=$'\n'
done
today=`date +%Y-%m-%dT%H:%M:%S%z` 
#make backup copy of existing hiera.yaml
cp /etc/puppetlabs/puppet/hiera.yaml "/etc/puppetlabs/puppet/hiera.yaml.$today"
/bin/tee -a /etc/puppetlabs/puppet/hiera.yaml <<EOF
  - name: "Eyaml hierarchy"
    lookup_key: eyaml_lookup_key # eyaml backend
    paths:
      - "common.eyaml"
$path_str
    options:
      pkcs7_private_key: "/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem"
      pkcs7_public_key:  "/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem"
EOF
#/opt/puppetlabs/puppet/bin/puppet agent -t
