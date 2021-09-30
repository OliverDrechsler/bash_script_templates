#!/usr/bin/env bash
IFS=$'\n\t'
#======================================================================
#/ Author: Oliver Drechsler
#/ Date:
#/ Version: 0.0.1
#/ Name: example bash script
#/ Options:
#/   Arguments
#/    /enable_logging=enable / disable
#/    /_tmp=tmp dir
#/    /src=a_what_ever_value_for_src_variable
#/   or as existing ENV variables
#/    export enable_logging=enable
#/    export _tmp=tmp dir
#/    export src=a_what_ever_value_for_src_variable
#/ Usage:
#/ Description:
#/ --help: Display this help message
#/ --debug: debug scipt mode
#/ if script was failed , you get a logfile under $_tmp folder
#======================================================================
# Show Script Help  lines with #/
#======================================================================
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }

#======================================================================
# Script Pipe Error and EXIT code handling
#======================================================================
set -euo pipefail
# sometimes 'set +eu' required for loop and while... with break commands

#======================================================================
# LOG File definition
#======================================================================
# get scriptname 
_scriptname="${0##*/}"
_script="${_scriptname%.*}"
# if not set , set tmp file path
_tmp=${_tmp:-"/tmp"}
# if not set variables syslog logging it will be enabled and logged
enable_logging=${enable_logging:-"enable"}
# delete logfile if successful
DELETE_LOG=${DELETE_LOG:-"true"}

# set logfile name
readonly LOG="${_tmp}/${_script}_$(date '+%d-%m-%Y_%H-%M-%S').log"
# set logging infos
info() {
  if [ "${enable_logging}" == "enable" ]; then
    logger "[${_script}] [INFO] $(date '+%d.%m.%Y %H:%M:%S')  $*"
  fi
  echo "[${_script}] [INFO] $(date '+%d.%m.%Y %H:%M:%S')  $*" | tee -a "$LOG" >&2
}
error() {
  if [ "${enable_logging}" == "enable" ]; then
    logger "[${_script}] [ERROR] $(date '+%d.%m.%Y %H:%M:%S')  $*"
  fi
  echo "[${_script}] [ERROR] $(date '+%d.%m.%Y %H:%M:%S')  $*" | tee -a "$LOG" >&2;
}

# Log all Script output to Logfile
exec &> >(tee -a "$LOG")

#======================================================================
#EXIT & Error Handling - does not delelte LOG File if error occurs
#======================================================================
err_report() {
  # error handling of script
  DELETE_LOG="false"
  error "Error with command at line: $*"
  error "Script will abort"
  exit 1
}
# Script EXIT/END handling normally deletes LOG File if no error occured
cleanup() {
  # cleanup with rm all tmp files on every end / exit
  if [[ "$DELETE_LOG" == "true" ]]; then
    rm -f ${LOG}
  fi
}
#======================================================================
# activate TRAP Scrip EXIT & ERROR handling
#======================================================================
trap 'err_report $LINENO $BASH_COMMAND' ERR
trap cleanup EXIT

#======================================================================
# read Commandline Arguments as Variables
#======================================================================
get_argument_as_variables()
{
               until [ -z "$*" ]
               do
                              echo "Processing of commandline arguments parameter of: '$1'"
                              if [[ "${1:0:1}" = "/" ]]; then
                                             tmp="${1:1}"               # Strip off leading '/' . . .
                                             variable="${tmp%%=*}"     # Extract name.
                                             value="${tmp##*=}"         # Extract value.
                                             echo "Variable: ${variable} with value: ${value}"
                                             eval $variable='${value}'
                              fi
                              shift
               done
}
get_argument_as_variables $*

#======================================================================
# other possibility of setting Variables with defaults if no command line argument given
#======================================================================
ARG1=${1:-"commandline_argument_1"}
echo "Variable ARG1 with Value=${ARG1}"

#======================================================================
# special Command line arguments
#======================================================================
expr "$*" : '.*--help' > /dev/null && usage
expr "$*" : '.*--debug' > /dev/null && PS4='-DEBUG: $((LASTNO=$LINENO)) : ' && set -x

#======================================================================
# MAIN SCRIPT STARTS HERE
#======================================================================
echo "start script"


src=${src:-"none"}
if [[ "$src" == "none" ]]; then
  read -p 'Please enter source path incl filename: ' src
fi

echo "check path is a real path and read into new variable"
full_src_path="$(realpath "$src")"
echo "full file path: ${full_src_path}"
echo ""

echo "get the base filename without path"
src_filename="$(basename "${full_src_path}")"
echo "only filename: ${src_filename}"
echo ""

echo "get filename without filename extension"
src_filename_without_ext="${src_filename%.*}"
echo "filename without extension: ${src_filename_without_ext}"
echo ""

echo ""
echo "now a command which produce an example error"
echo ""
echo ""

what_ever_none_existing_command_to_produce_an_error
