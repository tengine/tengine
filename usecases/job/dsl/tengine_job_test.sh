#!/usr/bin/env bash
typeset -i time=$1
export LOGFILE=tengine_job_test.log
echo "`date` tengine_job_test $2 PID:$$" >> $LOGFILE
echo "`date` tengine_job_test $2 start" >> $LOGFILE
sleep `expr 1 + $time`
echo "`date` tengine_job_test $2 finish" >> $LOGFILE
