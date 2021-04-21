#!/bin/sh -l

kscript ktest.kts $1
echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
