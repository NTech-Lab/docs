.. _tntapi-standalone:

Install tntapi standalone
"""""""""""""""""""""""""""""""

Install and configure the ``tntapi`` component as follows:

#. Install ``tntapi``. Tarantool will be installed automatically along with it.

   .. code::

       sudo apt-get update
       sudo apt-get install findface-tarantool-server

#. Disable the Tarantool example service autostart and stop the service.

   .. code::

       sudo systemctl disable tarantool@example && sudo systemctl stop tarantool@example

#. For a small-scale project, the ``tntapi`` shard created by default (``tarantool@FindFace``) would suffice as 1 shard can handle up to 10,000,000 faces. Configuration settings of the default shard are defined in the file ``/etc/tarantool/instances.enabled/FindFace.lua``. We strongly recommend you not to add or edit anything in this file, except the maximum memory usage (``memtx_memory``), the NTLS IP address required for the ``tntapi`` licensing, and the remote access setting. The maximum memory usage should be set in bytes, depending on the number of faces the shard handles, at the rate roughly 1280 byte per face. 

   Open the configuration file::

     sudo vi /etc/tarantool/instances.enabled/FindFace.lua

   Edit the value due to the number of faces the shard handles. The value ``1.2*1024*1024*1024`` corresponds to 1,000,000 faces::

     memtx_memory = 1.2 * 1024 * 1024 * 1024,

   Specify the NTLS IP address if NTLS is remote::

     FindFace.start(“127.0.0.1”, 8001, {license_ntls_server=“192.168.113.2:3133”})

   With standalone deployment, you can access Tarantool by default only locally (``127.0.0.1``). If you want to access Tarantool from a remote host, either specify the remote host IP address in the ``FindFace.start`` section, or change ``127.0.0.1`` to ``0.0.0.0`` there to allow access to Tarantool from any IP address.
   In the case-study below, you allow access only from ``192.168.113.10``::

     FindFace.start("192.168.113.10", 8001, {license_ntls_server=“192.168.113.2:3133”})

   Now you allow access from any IP address::

     FindFace.start("0.0.0.0", 8001, {license_ntls_server=“192.168.113.2:3133”})

#. Configure the ``tntapi`` shard to autostart and start the shard.

   .. code::

      sudo systemctl enable tarantool@FindFace && sudo systemctl start tarantool@FindFace

#. Retrieve the shard status. The command will return a service description, a status (should be Active), path and running time.

   .. code::

       sudo systemctl status tarantool@FindFace
   

   .. tip::
       You can view the ``tntapi`` :ref:`logs <logs>` by executing:

       .. code::

          sudo tail -f /var/log/tarantool/FindFace.log

#. The ``tntapi.json`` file containing the tntapi shard parameters is automatically installed along with ``tntapi`` into the ``/etc/`` folder. 

   .. important::
       You will have to uncomment the path to ``tntapi.json`` when :ref:`configuring network <configure-network>`.


