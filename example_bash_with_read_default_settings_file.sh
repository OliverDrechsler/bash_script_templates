#!/bin/bash
_scriptname="${0##*/}"
_script="${_scriptname%.*}"
script=${script:-"$_script"}
log=${log:-"/tmp/${script}_`date +%d%m%y`.log"}


# checks if variable "volume" exist and if not executes - read config file
[ -z ${VOLUMES+x} ] && . volumes.conf

echo "show volumes variable : ${VOLUMES}"