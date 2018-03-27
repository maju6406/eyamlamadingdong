#!/usr/bin/env bash
if puppet config print server | grep -v -q `hostname`; then
  echo "This task can only be run on the master node."; 
  exit 1
fi

#install eyaml gem
/opt/puppetlabs/bin/puppetserver gem install hiera-eyaml
echo "Installed hiera-eyaml gem."
#make backup copies of existing keys
mv /etc/puppetlabs/puppet/keys/private_key.pkcs7.pem "/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem.$today"
mv /etc/puppetlabs/puppet/keys/public_key.pkcs7.pem "/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem.$today"
cd /etc/puppetlabs/puppet/;/opt/puppetlabs/puppet/bin/eyaml createkeys
echo "eyaml keys created in /etc/puppetlabs/puppet/keys."

if [ "$PT_configure_global_hiera" = "true" ] ; then
  # Update hiera.yaml
  IFS=',' read -a paths <<< "${PT_paths}"
  path_str='["common.eyaml"'
  for i in "${!paths[@]}"
  do
    path_str+=$",\"${paths[i]}\""
  done
  path_str+="]"
  today=`date +%Y-%m-%dT%H:%M:%S%z` 
  #make backup copy of existing hiera.yaml
  cp /etc/puppetlabs/puppet/hiera.yaml "/etc/puppetlabs/puppet/hiera.yaml.$today"
  rb+="require 'yaml';"
  rb+="hiera =YAML.load_file('/etc/puppetlabs/puppet/hiera.yaml');"
  rb+='hiera["hierarchy"].push({"name"=>"Eyaml hierarchy", "lookup_key"=>"eyaml_lookup_key", "paths"=>$path_str, "options"=>{"pkcs7_private_key"=>"/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem", "pkcs7_public_key"=>"/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem"}});'
  rb+="output = YAML.dump hiera;"
  rb+="File.write('/etc/puppetlabs/puppet/hiera.yaml', output);"
  echo $"$rb" >/tmp/hiera_helper.rb  
  chmod a+x /tmp/hiera_helper.rb
  /opt/puppetlabs/puppet/bin/ruby /tmp/hiera_helper.rb
  echo "Updated /etc/puppetlabs/puppet/hiera.yaml file."
  rm -rf /tmp/hiera_helper.rb
fi
echo "Finished! Congrats!"
if [ "$PT_configure_global_hiera" = "false" ] ; then
  echo "Manual step: You will need to manually update your hiera.yaml files."
fi
service puppetserver reload 
echo "Find out more about eyaml here: https://puppet.com/blog/encrypt-your-data-using-hiera-eyaml"