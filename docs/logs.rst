.. _logs:

Appendix C. Analyze Log Files
=====================================

Log files provide a complete record of each FindFace Enterprise Server SDK component activity.

.. rubric:: findface-facenapi
   
.. code::

   $ sudo tail -f /var/log/syslog | grep facenapi
   Jun 28 17:20:08 ubuntu findface-facenapi[17104]: [I 170628 17:20:08 base:234] 200 POST /v0/face (127.0.0.1) 1114 487 241 12

| The findface-facenapi log contains the following time values:
| ``1114`` — total response time (FindFace Enterprise Server SDK components + MongoDB + Python),
| ``487`` — face detection time,
| ``241`` — findface-nnapi response time,
| ``12`` — tntapi response time.



.. rubric:: findface-nnapi
    
.. code::

   $ sudo tail -f /var/log/syslog | grep nnapi
   Jul  7 03:53:05 ubuntu findface-nnapi[49606]: (2017-07-07 10:53:05) [INFO    ] Request: 127.0.0.1:34494 0x7fb100000960 HTTP/1.0 POST /facen
   Jul  7 03:53:06 ubuntu findface-nnapi[49606]: (2017-07-07 10:53:06) [INFO    ] Response: 0x7fb100000960 /facen?x2=0&y1=0&x1=0&y2=0 200 0

.. rubric:: fkvideo_detector

.. code::

   $ sudo tail -f /var/log/syslog | grep fkvideo_detector

.. rubric:: extraction-api

.. code::

     $ sudo tail -f /var/log/syslog | grep extraction-api	


.. rubric:: Load-balanced service

.. code::
   
   $ sudo tail -f  /var/log/nginx/service_name.access_log
   $ sudo tail -f  /var/log/nginx/nnapi.access_log
 

.. rubric:: Tarantool

.. code::

   $ sudo cat /var/log/tarantool/FindFace.log

