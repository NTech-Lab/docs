.. _tntapi:

Install tntapi
^^^^^^^^^^^^^^^^^^^^^^

The tntapi component connects the Tarantool database and the facenapi component, transferring search results from the database to facenapi for further processing. To increase search speed, multiple tntapi shards can be created on each Tarantool host. Their running concurrently leads to a remarkable increase in performance.
Each shard can handle up to approximately 10,000,000 faces. In the case of standalone deployment, you need only one shard (created by default), while in a cluster environment the number of shards has to be calculated depending on several parameters (see below).

.. include:: tntapi_standalone.rst

.. include:: tntapi_cluster.rst
