.. _tarantool-recovery:

Automatic Tarantool Recovery
=====================================

If your system architecture doesn't imply uninterrupted availability of Tarantool servers, it is recommended to enable automatic database recovery. In this case, each time an error occurs while reading a snapshot or xlog file, Tarantool will skip invalid records, read as much data as possible, and re-build the file. 

.. warning::
   The automatic recovery process may result in MongoDB and Tarantool being out of sync.

To enable automatic database recovery , do the following:

#. Open the Tarantool configuration file.

   .. code::

      sudo vi /etc/tarantool/instances.enabled/FindFace.lua

#. Uncomment ``force_rcovery = true``.

   .. code::

      box.cfg{

          force_recovery = true,
      }

