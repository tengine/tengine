#!/usr/bin/env bash

typeset -i time=$1
echo "`date` sleep.sh start"
sleep `expr 1 + $time`
echo "`date` sleep.sh finish"
