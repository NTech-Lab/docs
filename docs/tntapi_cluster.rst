.. _tntapi-sharding:

Install tntapi cluster
******************************

Install and configure the ``tntapi`` component as follows:

#. Install ``tntapi`` on designated hosts. Tarantool will be installed automatically along it. 

   .. code::

       sudo apt-get update
       sudo apt-get install findface-tarantool-server

#. Create ``tntapi`` shards on each ``tntapi`` host. To learn how to shard, let's consider a case-study of a cluster environment containing 4 database hosts. We'll create 4 shards on each.

   .. important::
       When creating shards in large installations, observe the following rules:

        #. 1 ``tntapi`` shard can handle approximately 10,000,000 faces.
        #. The number of shards on a single host should not exceed the number of its physical processor cores minus 1.

#. Disable the Tarantool example service autostart and stop the service. Do so for all the 4 hosts.

   .. code::

       sudo systemctl disable tarantool@example && sudo systemctl stop tarantool@example

#. Disable the shard created by default. Do so for all the 4 hosts.

   .. code::

       sudo systemctl disable tarantool@FindFace

#. Write a bash script ``shard.sh`` that will automatically create configuration files for all shards on a particular host. Do so for the 4 hosts. Use the following script as a base for your own code. The exemplary script creates 4 shards listening to the ports: tntapi ``33001..33004`` and http ``8001..8004``.

   .. important::
         The script below creates configuration files based on the default configuration settings stored in the file ``/etc/tarantool/instances.enabled/FindFace.lua``. We strongly recommend you not to add or edit anything in the default file, except the maximum memory usage (``memtx_memory``) and the NTLS IP address required for the ``tntapi`` licensing.
         The maximum memory usage should be set in bytes for each shard, depending on the number of faces a shard handles, at the rate roughly 1280 byte per face.

         Open the configuration file::

            sudo vi /etc/tarantool/instances.enabled/FindFace.lua

         Edit the value due the number of faces a shard handles. The value ``1.2*1024*1024*1024`` corresponds to 1,000,000 faces::

            memtx_memory = 1.2*1024*1024*1024,

         Specify the NTLS IP address if NTLS is remote::

            FindFace.start(“127.0.0.1”, 8001, {license_ntls_server=“192.168.113.2:3133”})

   .. code::

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

   .. tip::
      Download the :download:`exemplary script <_scripts/shard.sh>`.

#. Run the script from the home directory.

   .. code::

      sudo sh ~/shard.sh

#. Check the configuration files created.

   .. code::

       ls /etc/tarantool/instances.enabled/

       ##example.lua FindFace.lua FindFace_shard_1.lua FindFace_shard_2.lua FindFace_shard_3.lua FindFace_shard_4.lua 

#. Launch all the 4 shards. Do so on each host.

   .. code::

       for I in `seq 1 4`; do sudo systemctl enable tarantool@FindFace_shard_$I; done;
       for I in `seq 1 4`; do sudo systemctl start tarantool@FindFace_shard_$I; done;

#. Retrieve the shards status.

   .. code::

       sudo systemctl status tarantool@FindFace*

   You should get the following output::

       tarantool@FindFace_shard_3.service - Tarantool Database Server
       Loaded: loaded (/lib/systemd/system/tarantool@.service; disabled; vendor preset: enabled)
       Active: active (running) since Tue 2017-01-10 16:22:07 MSK; 32s ago
       ... 
       tarantool@FindFace_shard_2.service - Tarantool Database Server
       Loaded: loaded (/lib/systemd/system/tarantool@.service; disabled; vendor preset: enabled)
       Active: active (running) since Tue 2017-01-10 16:22:07 MSK; 32s ago
       ... 
       tarantool@FindFace_shard_1.service - Tarantool Database Server
       Loaded: loaded (/lib/systemd/system/tarantool@.service; disabled; vendor preset: enabled)
       Active: active (running) since Tue 2017-01-10 16:22:07 MSK; 32s ago
       ... 
       tarantool@FindFace_shard_4.service - Tarantool Database Server
       Loaded: loaded (/lib/systemd/system/tarantool@.service; disabled; vendor preset: enabled)
       Active: active (running) since Tue 2017-01-10 16:22:07 MSK; 32s ago
       ... 

   .. tip::
       You can view the ``tntapi`` :ref:`logs <logs>` by executing:

       .. code::

          sudo tail -f /var/log/tarantool/FindFace_shard_{1,2,3,4}.log

#. On the ``findface-facenapi`` host, create a file ``tntapi_cluster.json`` containing the addresses and ports of all the shards. Distribute available shards evenly over ~1024 cells in one line. Click `here <https://raw.githubusercontent.com/NTech-Lab/FFSER-file-examples/master/tntapi_cluster.json>`__ to see the file for 4 hosts with 4 shards on each. 

   .. tip:: 
       You can create ``tntapi_cluster.json`` as follows:

         #. Create a file that lists all the shards, each shard with a new line (click `here <https://raw.githubusercontent.com/NTech-Lab/FFSER-file-examples/master/s.txt>`__ to view the example). 

            .. code::

               sudo vi s.txt

         #. Run the script below (click `here <https://raw.githubusercontent.com/NTech-Lab/FFSER-file-examples/master/creating_tntapi_cluster.json_script.md>`__ to view the script). As a result, a new file ``tntapi_cluster.json`` will be created and contain a list of all shards distributed evenly over 1024 cells. 

           .. code::

              cat s.txt | perl -lane 'push(@s,$_); END{$m=1024; $t=scalar @s;for($i=0;$i<$m;$i++){$k=int($i*$t/$m); push(@r,"\"".$s[$k]."\"")} print "[[".join(", ",@r)."]]"; }' > tntapi_cluster.json

#. Move ``tntapi_cluster.json`` to the directory ``/etc/``. 

   .. important::
      You will have to uncomment and specify the path to ``tntapi_cluster.json`` when :ref:`configuring network <configure-network>`.

