.. _fast-index:

Fast Index
===================

For galleries with the number of faces over 1,000,000, we recommend you to speed up search by using a fast index. To prepare the fast index, you
will need the ``findface-tarantool-build-index`` utility from your distribution package. This utility is independent of the tntapi component and can be installed either on a localhost or on a remote host with access to Tarantool. 

To prepare the fast index, do the following:

#.  Install the ``findface-tarantool-build-index`` utility.

   .. code::

       sudo apt-get install findface-tarantool-build-index

#. Create the fast index for your gallery (``testgal`` in the examples below). First, connect to the Tarantool console.

   .. note::
       You have to repeat the fast index creation on each tntapi shard. 

   .. code::

       tarantoolctl connect 127.0.0.1:33001

#. Run :program:`prepare_preindex`. Each element of the linear for this gallery will be moved to the preindex: 

   .. code::

       127.0.0.1:33001> FindFace.Gallery.new("testgal"):prepare_preindex()
       ---
       ...

#. Prepare a file for generating the index:

   .. code::

       127.0.0.1:33001> FindFace.Gallery.new("testgal"):save_preindex("/tmp/preindex.bin")
       ---
       ...

#. Launch index generation with the ``findface-build-index`` utility (see --help for additional options). Depending on the number of elements, this process can take up to several hours and can be done on a separate, more powerful machine (for huge galleries we recommend c4.8xlarge amazon, for example spot-instance).

   .. code::

       sudo findface-build-index --input /tmp/preindex.bin --facen_size 320 --out /opt/ntech/var/lib/tarantool/default/index/testgal.idx

       0% 10 20 30 40 50 60 70 80 90 100%
       |----|----|----|----|----|----|----|----|----|----|
       **************************************************
       0% 10 20 30 40 50 60 70 80 90 100%
       |----|----|----|----|----|----|----|----|----|----|
       **************************************************

       [Benchmark] create_index took 29.994ms
       Index saved at /opt/ntech/var/lib/tarantool/default/index/testgal.idx


#. Delete the ``preindex.bin`` file.

   .. code::

       sudo rm /tmp/preindex.bin

#. Enable the fast index for the gallery.

   .. note::
       If Tarantool works as a :ref:`replica set <tntapi-add>`, copy the index file (.idx) from the master instance to the same path on the replica before enabling the fast index for the master instance (:program:`:use_index`).

   .. tip::
       Do not forget to remove obsolete index files on the replica in order to avoid unnecessary index transitions, should the master instance and replica be heavily out of sync.

   .. code::

       127.0.0.1:33001> FindFace.Gallery.new("testgal"):preindex_to_index()
       ---
       ...
       127.0.0.1:33001> FindFace.Gallery.new("testgal"):use_index("/opt/ntech/var/lib/tarantool/default/index/testgal.idx")
       ---
       ...

#. Search through the gallery should now be significantly faster. Information about the index remains in the service space, so when you restart Tarantool, index will also be uploaded.

   .. warning::
         Do not move the index file to another location!

