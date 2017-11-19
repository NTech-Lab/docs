.. _stats:

Shard Galleries Statistics
=============================================

You can get a shard galleries statistics and other data right in your browser. This functionality can be harnessed in monitoring systems.

.. note::
    In the case of standalone deployment, you can access Tarantool by default only locally (127.0.0.1). If you want to access Tarantool remotely, :ref:`change <tntapi-standalone>` the Tarantool configuration file.

.. rubric:: In this section:

.. contents::
   :local:


List Galleries
----------------------------

To list all galleries on a shard, type in the address bar of your browser:

.. code::

    http://<tarantool_host_ip:shard_port>/stat/list/:start/:limit

| ``:start`` is the number of a gallery the list starts with.
| ``:limit`` is the maximum number of galleries in the list.
|

.. rubric:: Example

.. rubric:: Request

.. code::

    http://127.0.0.1:8001/stat/list/1/99 
    or
    curl http://127.0.0.1:8001/stat/list/1/99 \| jq


.. rubric:: Response 

.. code::

       % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                      Dload  Upload   Total   Spent    Left  Speed
     100  6700  100  6700    0     0  45812      0 --:--:-- --:--:-- --:--:-- 45890
     {
       "galleries": [
         {
           "cnt_indexed": 0,
           "id": 1,
           "cnt_preindex": 0,
           "name": "591b0cdfb0d5bd7058ef0968_default",
           "cnt_linear": 35268
         },
         {
           "cnt_indexed": 0,
           "id": 2,
           "cnt_preindex": 0,
           "name": "591b0cdfb0d5bd7058ef0968_lublino",
           "cnt_linear": 1818
         },
         {
           "cnt_indexed": 0,
           "id": 3,
           "cnt_preindex": 0,
           "name": "591b0cdfb0d5bd7058ef0968_gifs",
           "cnt_linear": 297
         }
       ],
       "total": 3
     }
                                            

Get Gallery Information
----------------------------

To get a gallery information, type in the address bar of your browser:

.. code::

    http://<tarantool_host_ip:shard_port>/stat/info/:name

``:name`` is the gallery name.

.. rubric:: Example

.. rubric:: Request

.. code::

    curl http://127.0.0.1:8001/stat/info/5968bda4a2a4bb6018bee2b2_cam_cam1 | jq


.. rubric:: Response 

.. code::

      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
     100   210  100   210    0     0  17654      0 --:--:-- --:--:-- --:--:-- 19090
     {
       "cnt_indexed": 0,
       "cnt_preindex_deleted": 0,
       "index_file": "none",
       "index_loaded": false,
       "cnt_preindex": 0,
       "cnt_linear": 85011,
       "cptr": 29556448,
       "id": 34,
       "name": "5968bda4a2a4bb6018bee2b2_cam_cam1",
       "cnt_indexed_deleted": 0
     }




