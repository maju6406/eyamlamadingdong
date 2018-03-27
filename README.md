# hiera_eyaml_setup

#### Table of Contents

1. [Description](#description)
2. [Requirements](#requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Getting help - Some Helpful commands](#getting-help)

## Description

This module provides a task to set up hiera-eyaml on the master. The install task installs the hiera-eyaml gem, generate keys, optionally updates the global hiera.yaml, and restarts the puppet server. There is a separate task for encrypting hiera values. 

NOTE: This task is meant to be an one-time operation. If you want to manage the keys and hieradata we recommend using Puppet Code instead of this task.

## Requirements
This module is compatible with Puppet Enterprise and Puppet Bolt.

* To run tasks with Puppet Enterprise, PE 2017.3.2 or later must be installed on the machine from which you are running task commands. Machines receiving task requests must be Puppet agents.

* To run tasks with Puppet Bolt, Bolt 0.5 or later must be installed on the machine from which you are running task commands. Machines receiving task requests must have SSH or WinRM services enabled.

## Usage

To run a hiera_eyaml_setup task, use the task command:

* With PE, run `puppet task run hiera_eyaml_setup --nodes neptune`.
* With Bolt, run `bolt task run hiera_eyaml_setup --nodes neptune --modulepath ~/modules`.

You can also run tasks in the PE console. See PE task documentation for complete information.

## Parameters

* `configure_global_hiera`: Configure the global hiera. Defaults to false.
* `paths`: Additional hiera search paths separated by commas. The default is `common.eyaml`. Only used if configure_global_hiera is true.

## Reference

To view the available actions and parameters, on the command line, run `puppet task show hiera_eyaml_setup` or see the hiera_eyaml_setup module page on the [Forge](https://forge.puppet.com/puppetlabs/hiera_eyaml_setup/tasks).

For a complete list of optional hiera_eyaml_setup providers that are supported, see the [Puppet Types](https://docs.puppet.com/puppet/latest/types/hiera_eyaml_setup.html) documentation.

## Getting Help

To display help for the hiera_eyaml_setup task, run `puppet task show hiera_eyaml_setup`

To show help for the task CLI, run `puppet task run --help` or `bolt task run --help`
