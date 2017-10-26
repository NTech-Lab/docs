.. _tntapi-add:

Additional Tntapi Functionality
===================================================

.. contents:: In this section:

Additional Configuration Parameters
-----------------------------------------------

To configure interaction between findface-facenapi and Tarantool, specify additional parameters in the 3rd argument of the ``FindFace.start`` section in the tntapi configuration file:

.. code::

    $ sudo vi /etc/tarantool/instances.enabled/FindFace.lua

    FindFace.start("127.0.0.1", 8001, {license_ntls_server="127.0.0.1:3133", additional parameter 1, ..., additional parameter N})

    ## Example:
    FindFace.start("127.0.0.1", 8001, {license_ntls_server="127.0.0.1:3133", facen_size = 320, log_requests = false})

.. rubric:: Additional parameters:  


+----------------------+-----------------+--------------------------------------------------------------------------------------------------------------------+
| Parameter            | Default value   | Description                                                                                                        |
+======================+=================+====================================================================================================================+
| log\_requests        | true            | Enable request logging (/var/log/tarantool/FindFace.log).                                                          |
+----------------------+-----------------+--------------------------------------------------------------------------------------------------------------------+
| facen\_size          | 320             | Facen's size. Before editing this parameter, be sure to consult NTechLab experts.                                  |
+----------------------+-----------------+--------------------------------------------------------------------------------------------------------------------+
| search\_threads      | 1               | Number of threads for fast index search.                                                                           |
+----------------------+-----------------+--------------------------------------------------------------------------------------------------------------------+
| replication          | nil             | Only for a replica. Master instance IP address.                                                                    |
+----------------------+-----------------+--------------------------------------------------------------------------------------------------------------------+
| soft\_delete\_mode   | false           | Enable the soft deletion mode, when the faces are not removed from the fast index, but hidden in search results.   |
+----------------------+-----------------+--------------------------------------------------------------------------------------------------------------------+

Soft Deletion Mode
------------------------------

Tarantool supports the soft deletion mode, when the faces are not removed from the fast index, but hidden in search results. We recommend you to enable this mode due to the following benefits:

* Tarantool starting time linearly depends on the number of faces removed from the ``Indexed`` space (fast index). If the soft deletion mode is on, the faces are not physically removed from the fast index, so face deletion doesn't affect the starting time. 
* Fast index search quality also depends on the number of physically removed faces. It doesn't sink in the soft deletion mode. 

To enable the soft deletion mode, edit the FindFace.start section as follows:

.. code::

    FindFace.start("127.0.0.1", 8001, {license_ntls_server="127.0.0.1:3133", soft_delete_mode = true})

Tarantool Replication
------------------------------

Replication allows multiple Tarantool instances to work on copies of the same face database. The database copies are kept in sync because each
instance can communicate its changes to all the other instances. Tarantool supports master-slave replication. You can add and delete data
only by using the master instance, slave instances (aka replicas) are read-only, i.e. can be used only for searching and consulting data.

To learn how to deploy a Tarantool replica set, refer to the Tarantool `official documentation <https://tarantool.org/en/doc/1.7/singlehtml.html#document-doc/1.7/book/replication/index>`__.

To start a created replica for the first time, do the following:

#. Start the master instance.
#. In the replica configuration file, specify the IP address and listening port of the master instance.

   .. code::

       FindFace.start("127.0.0.1", 48001, {replication = "127.0.0.1:33001"}) 

#. Copy the latest snapshot (.snap) of the master instance into the ``memtx_dir`` directory of the replica.

   .. code::

        --Directory to store data
           memtx_dir = '/opt/ntech/var/lib/tarantool/default/snapshots'

#. Copy the master instance logs into the ``wal_dir`` directory of the replica.

   .. code::

       --Directory to store data
            wal_dir = '/opt/ntech/var/lib/tarantool/default/xlogs'

#. Start the replica. You can start as many replicas affiliated with the same master instance as needed.
   
.. important::
      Before enabling the :ref:`fast index <fast-index>` for the master instance ``:use_index("/path/to/<index>.idx")``, copy the index file (``<index>.idx``) to the same path on its replica. Then perform ``use_index`` on the master instance.

.. tip::
    Delete obsolete index files on the replica in order to avoid unnecessary index transitions, should the master instance and replica be heavily out of sync.

.. tip::
    To synchronize the master instance and replica, you can also copy the latest master snapshot to the replica.

