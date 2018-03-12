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

   curl http://localhost:3185/license.json -s | jq
   {
     "name": "NTLS",
     "time": 1520844897,
     "type": "offline (extended)",
     "license_id": "001278983",
     "generated": 487568400,
     "last_updated": 4,
     "valid": {
       "value": true,
       "description": ""
     },
     "source": "/ntech/license/001278983.lic",
     "limits": [
       {
         "type": "time",
         "name": "end",
         "value": 25343
       },
       {
         "type": "number",
         "name": "faces",
         "value": 90071,
         "current": 230258
       },
       {
         "type": "number",
         "name": "cameras",
         "value": 9007,
         "current": 3
       },
       {
         "type": "number",
         "name": "extraction_api",
         "value": 900,
         "current": 8
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
         "name": "fkvideo-detector",
         "ip": "127.0.0.1:58970"
       },
       {
         "name": "FindFace-tarantool",
         "ip": "127.0.0.1:58978"
       },
       {
         "name": "findface-extraction-api",
         "ip": "127.0.0.1:52376"
       }
     ]
   }







