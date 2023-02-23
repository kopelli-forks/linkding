#! /usr/bin/env bash

DATE_STAMP=$(TZ=GMT date +"%Y-%m-%dT%H%M%SZ")
npm run dev 2> "./logs/${DATE_STAMP}-npm.err" 1> "./logs/${DATE_STAMP}-npm.out" &
PID[0]=$!
python3 manage.py runserver 2> "./logs/${DATE_STAMP}-python.err" 1> "./logs/${DATE_STAMP}-python.out" 2>&1 &
PID[1]=$!

trap "kill ${PID[0]} ${PID[1]}; exit 1" INT
#trap "kill ${PID[0]} ${PID[1]}; exit 0" EXIT

jobs -l
wait
