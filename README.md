# elk #

[![Puppet Forge](https://img.shields.io/badge/puppetforge-v0.1.0-blue.svg)](https://forge.puppetlabs.com/swizzley88/elk)

**Table of Contents**

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Requirements](#requirements)
6. [Compatibility](#compatibility)
7. [Limitations](#limitations)
8. [Development](#development)
    * [TODO](#todo)
    
## Overview ##

This module sets up the E.L.K. stack for log analysis.    

## Module Description ##

This module can be used to configure the stack in the following ways:

  * A single node (all-in-one) for tiny or single use case 
  * Clustered with HA-Proxy as load balancer
  * Clustered without HA-Proxy for use behind alternative load balancer
  * Auto-scalable cluster using puppetdb with or without HA-Proxy

## Setup ##

Modify or inherit parameters in params.pp as needed. Default is all-in-one 

## Usage ##

```
include ::elk
```

## Requirements ##

puppetlabs/stdlib

puppetlabs/java

puppetlabs/rabbitmq

puppetlabs/haproxy

elasticsearch/elasticsearch

elasticsearch/logstash

elasticsearch/logstashforwarder

evenup/kibana

## Compatibility ##

  * RHEL 6
  * CentOS 6

## Limitations ##

This module has been tested on:

  - CentOS 6

## Development ##

I'd like to fork the logstashforwarder module and refactor it into what I've found to be a better method of configuring logstash-forwarder. However at this time, that's currently not in development so this module is designed to work with the official elasticsearch puppet module for logstash-forwarder with it's main limitation being unable to configure multiple files with different fields.

Other than that any updates or contibutions are welcome.

Report any issues with current release, as any input will be considered valuable.


#### TODO ####

  * add other OS support
 
###### Contact ######

Email:  morgan@aspendenver.org

WWW:    www.aspendenver.org

Github: https://github.com/swizzley
