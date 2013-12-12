#!/bin/bash
killall wstest 2>/dev/null
wstest -m echoserver -w ws://localhost:${LUAWS_WSTEST_PORT:=8081}  &
pid=$!
for T in {1..2}
do
    echo "Waiting for wstest to start..." $T "/10 secs"
    sleep 1
done
for spec in `find spec -name "*_spec.lua"`
do
  echo "running busted" $spec
  busted -o TAP $spec
done
bustedcode=$?
kill ${pid}
exit $bustedcode

