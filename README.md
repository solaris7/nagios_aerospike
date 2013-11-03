Description
===========
Nagios plugins for Citrusleaf / Aerospike servers 2.6.x.
By Kali Nguyen, 2013 - github.com/solaris7.

Requirements
============
Must have citruleaf-tools installed.

Attributes
==========

Usage
=====

./chk_as_clustersize.sh
usage: ./chk_as_clustersize.sh options
By Kali Nguyen, 2013 - github.com/solaris7
This nagios plugins checks for aerospike cluster size.
OPTIONS:
    -h       Show this message
    -H       Hostname
    -c       Total number of Aerospike XDR nodes
Eg. ./chk_as_clustersize.sh -H myaerospikenode1.org -c 8
