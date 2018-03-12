.. _logs:

Analyze Log Files
=====================================

Log files provide a complete record of each FindFace Enterprise Server SDK component activity.

.. rubric:: findface-facenapi
   
.. code::

   sudo tail -f /var/log/syslog | grep facenapi
   Jun 28 17:20:08 ubuntu findface-facenapi[17104]: [I 170628 17:20:08 base:234] 200 POST /v0/face (127.0.0.1) 1114 487 241 12

| The findface-facenapi log contains the following time values:
| ``1114`` — total response time (FindFace Enterprise Server SDK components + MongoDB + Python),
| ``487`` — face detection time,
| ``241`` — ``findface-extraction-api`` response time,
| ``12`` — ``tntapi`` response time.
|


.. rubric:: extraction-api

.. code::

   sudo tail -f /var/log/syslog | grep extraction-api	
 

.. rubric:: fkvideo_detector

.. code::

   sudo tail -f /var/log/syslog | grep fkvideo_detector



.. rubric:: Tarantool

.. code::

   sudo cat /var/log/tarantool/FindFace.log

