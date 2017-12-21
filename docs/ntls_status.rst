.. _ntls:

Retrieve Licensing Information
------------------------------------------

To retrieve the FindFace Enterprise Server SDK :ref:`licensing <licensing>` information and NTLS status, execute on the NTLS host console:

.. code::

   curl http://localhost:3185/license.json -s | jq


The response will be given in JSON. One of the most significant parameters is ``last_updated``. It indicates in seconds how long ago the local license has been checked for the last time.

Interpret the ``last_updated`` value as follows:

   * [0, 5] — everything is alright.
   * (5, 30] — there may be some problems with connection, or with the local drive where the license file is stored.
   * (30; 120] — almost certainly something bad happened.
   * (120; ∞) — the licensing source response has been timed out. Take action.
   * ``"valid": false``: connection with the licensing source was never established.


.. code::

   {
     "name": "NTLS",
     "time": 1504794255,
     "type": "online",
     "license_id": "2e46fed81cc843539f0cf8bd4c1df254",
     "generated": 1503571034,
     "last_updated": 3,
     "valid": {
       "value": true,
       "description": ""
     },
     "source": "/ntech/license/import_803e10f14948d5e8a7583de99b0411635743a01cd7afd8589c475f5b60e202cb.lic",
     "limits": [
       {
         "type": "time",
         "name": "end",
         "value": 4753938994
       },
       {
         "type": "number",
         "name": "faces",
         "value": 1000000000000,
         "current": 80037
       },
       {
         "type": "number",
         "name": "cameras",
         "value": 4294967295,
         "current": 2
       },
       {
         "type": "boolean",
         "name": "gender",
         "value": true
       },
       {
         "type": "boolean",
         "name": "age",
         "value": true
       },
       {
         "type": "boolean",
         "name": "emotions",
         "value": true
       },
       {
         "type": "boolean",
         "name": "fast-index",
         "value": true
       }
     ],
        "services": [
       {
         "name": "FindFace-tarantool",
         "ip": "127.0.0.1:37058"
       },
       {
         "name": "findface-nnapi",
         "ip": "127.0.0.1:37057"
       },
       {
         "name": "findface-extraction-api",
         "ip": "127.0.0.1:37056"
       },
       {
         "name": "fkvideo-detector",
         "ip": "127.0.0.1:37059"
       } 
     ]
   }


