#!/bin/sh
set -e

for I in `seq 1 4`; do
       TNT_PORT=$((33000+$I)) &&
       HTTP_PORT=$((8000+$I)) &&
       sed "
               s#/opt/ntech/var/lib/tarantool/default#/opt/ntech/var/lib/tarantool/shard_$I#g;
               s/listen = .*$/listen = '127.0.0.1:$TNT_PORT',/;
               s/\"127.0.0.1\", 8001,/\"0.0.0.0\", $HTTP_PORT,/;
       " /etc/tarantool/instances.enabled/FindFace.lua > /etc/tarantool/instances.enabled/FindFace_shard_$I.lua;

       mkdir -p /opt/ntech/var/lib/tarantool/shard_$I/snapshots
       mkdir -p /opt/ntech/var/lib/tarantool/shard_$I/xlogs
       mkdir -p /opt/ntech/var/lib/tarantool/shard_$I/index
       chown -R tarantool:tarantool /opt/ntech/var/lib/tarantool/shard_$I
       echo "Shard #$I inited"
done;
