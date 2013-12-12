#!/bin/bash
killall wstest 2>/dev/null
wstest -m echoserver -w ws://localhost:${LUAWS_WSTEST_PORT:=8088}  &
pid=$!
echo "Waiting for wstest to start..."
until nc -w 1 localhost 8088
do
    echo "..."
    sleep 1
done
for spec in `find spec -name "*_spec.lua"`
do
  echo "running busted" $spec
  busted  $spec
done
bustedcode=$?
kill ${pid}
exit $bustedcode

