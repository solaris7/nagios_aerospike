#!/bin/bash
# Nagios Plugin
# Check Cluster Size
usage()
{
cat << EOF
usage: $0 options
By Kali Nguyen, 2013 - github.com/solaris7
This nagios plugins checks for aerospike migrate_msgs_recv. The same number over a 1 minute period may indicate a problem.
This script creates a temporary file at ~/.aerospike-migrate_msgs_recv
OPTIONS:
    -h       Show this message
    -H       Hostname
    -p       Server port
    -n       Nagios plugins dir ($USER1$)
    -o       Last service output for changes in msgs recv.
EOF
}
HOSTNAME=
PORT=
WARN=
CRIT=
PLUGINDIR=
OUT=
while getopts “hH:p:n:o:” OPTION
    do
    case $OPTION in
    h)
    usage
    exit 2
    ;;
    H)
    HOSTNAME=$OPTARG
    ;;
    p)
    PORT=$OPTARG
    ;;
    n)
    PLUGINDIR=$OPTARG
    ;;
    o)
    OUT=$OPTARG
    ;;
    ?)
    usage
    exit
    ;;
    esac
    done
    if [[ -z $HOSTNAME ]] || [[ -z $PORT ]] || [[ -z $PLUGINDIR ]] || [[ -z $OUT ]]
    then
    usage
    exit 2
    fi
if [ ! -e /usr/bin/clmonitor ] ; then
  echo "clmonitor file does not exist. Exiting."
  exit 2
fi
if [ ! -e $PLUGINDIR/citrusleaf_stats.py ] ; then
  echo "citrusleaf_stats.py file does not exist."
  exit 2
fi

METRIC="$(python $PLUGINDIR/citrusleaf_stats.py -h $HOSTNAME -p $PORT -s migrate_msgs_recv | cut -d= -f 2)"

# Comparing the result and setting the correct level:

LASTBYTES=`echo $OUT | cut -d= -f 2`

if ! [[ "$LASTBYTES" =~ ^[0-9]+$ ]] ; then
   $LASTBYTES = $METRIC
fi

if [[ $METRIC -ne $LASTBYTES ]]; then
    msg="OK"
    status=0
else if [[ $METRIC -eq $LASTBYTES ]]; then
    msg="CRITICAL"
    status=2
fi
fi

echo "$msg - $HOSTNAME aerospike migrate_msgs_recv=$METRIC | '$HOSTNAME migrate_msgs_recv'=$METRIC;$WARN;$CRIT;"

# Bye!
exit $status
