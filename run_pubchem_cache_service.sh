#!/bin/bash
# Use locking to ensure one instance of the script runs
# Note: use a lock directory to ensure checking and creating in one step (atomic)

if [[ $# -lt 1 ]]
then
  echo "Usage: $0 <required: [ dev | dev2 | prod] [python_script]"
  exit 1 
fi

SERVER=$1

LOCKDIR=/tmp/lincs.hms.harvard.edu-${SERVER}-pubchem_cache_service-lock
PIDFILE="${LOCKDIR}/PID"

if mkdir $LOCKDIR; then
  echo "$$" >"${PIDFILE}"
  echo "Locking succeeded for $LOCKDIR" >&2
  # pubchem_database_cache_service:
  # -d DAYS_TO_CACHE 
  # -de DAYS_TO_CACHE_ERRORS
  # -lt SERVICE_LOOP_TIME_SEC 
  # -rt RUN_TIME_SEC 
  # Run for 86340 sec so that the job exits before the next cron instance is started after 1 day
  ./run.sh $SERVER src/hms/pubchem/pubchem_database_cache_service.py -d 1 -de 1 -lt 3 -rt 86340
  rm -rf $LOCKDIR
else
  echo "Lock for $LOCKDIR failed - exit" >&2
  exit 1
fi
