#!/bin/bash
typeset -i time="$1"
export LOGFILE=tengine_job_test.log
echo "`date` tengine_job_test $MM_ACTUAL_JOB_NAME_PATH start" >> $LOGFILE
case "$MM_ACTUAL_JOB_NAME_PATH" in
  "/jn3002/j1" ) 
    sleep ${J1_SLEEP:=0}
    if [ "$J1_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/j2" ) 
    sleep ${J2_SLEEP:=0}
    if [ "$J2_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/jn4/j41" ) 
    sleep ${J41_SLEEP:=0} 
    if [ "$J41_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/jn4/j42" ) 
    sleep ${J42_SLEEP:=0} 
    if [ "$J42_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/jn4/j43" ) 
    sleep ${J43_SLEEP:=0} 
    if [ "$J43_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/jn4/j44" ) 
    sleep ${J44_SLEEP:=0} 
    if [ "$J44_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/jn4/finally/jn4_f" ) 
    sleep ${JN4_F_SLEEP:=0} 
    if [ "$JN4_F_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/j4" ) 
    sleep ${J4_SLEEP:=0}
    if [ "$J4_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/finally/jn3002_fjn/jn3002_f1" ) 
    sleep ${JN3002_F1_SLEEP:=0} 
    if [ "$JN3002_F1_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/finally/jn3002_fjn/jn3002_f2" ) 
    sleep ${JN3002_F2_SLEEP:=0} 
    if [ "$JN3002_F2_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/finally/jn3002_fjn/finally/jn3002_fif" ) 
    sleep ${JN3002_FIF_SLEEP:=0} 
    if [ "$JN3002_FIF_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
  "/jn3002/finally/jn3002_f" ) 
    sleep ${JN3002_F_SLEEP:=0}
    if [ "$JN3002_F_FAIL" = "true" ] ; then
      exit 1
    fi
    ;;
esac

echo "`date` tengine_job_test $MM_ACTUAL_JOB_NAME_PATH finish" >> $LOGFILE
