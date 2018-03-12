.. _gae:

Gender, Age and Emotions Recognition
========================================

.. rubric:: In this section:

.. contents::
   :local:



Enable Gender, Age and Emotions Recognition
---------------------------------------------------

.. note:: 
     Gender, age and emotions recognition uses around 2 GB of RAM in addition to the FindFace Server :ref:`general requirements <requirements>`.


To enable gender, age and emotions recognition, uncomment and edit the line ``gae = False`` in the ``findface-facenapi`` configuration file. Restart ``findface-facenapi``.

   .. warning::
         The ``findface-facenapi.ini`` content must be correct Python code.

   .. code::

       sudo vi /etc/findface-facenapi.ini
 
             → gae = True

       sudo service findface-facenapi restart



API Requests for Gender, Age and Emotions Recognition
----------------------------------------------------------

An exemplary API request for recognizing gender, age and emotions of a person, and the corresponding response are shown below.

.. rubric:: Request #1

.. code::

    POST /v1/detect/ HTTP/1.1
    Host: 192.168.113.76:8000
    Connection:close
    Authorization: Token BpdNA6eaUlN9bPhXVSK1r92_SFOODPOU
    Content-Type:   application/json
    Content-Length: 108

    {
        "photo": "https://static.findface.pro/sample.jpg",
        "emotions": true,
        "gender": true,
        "age": true
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Thu, 06 Apr 2017 12:38:40 GMT
    Server: TornadoServer/4.4.2
    Content-Length: 120
    Content-Type: application/json; charset=UTF-8


    {
      "faces": [
        {
         "age": 26,
         "emotions": [
           "neutral",
           "sad"
         ],
         "gender": "female",
         "x1": 595,
         "x2": 812,
         "y1": 127,
         "y2": 344
        }
      ]
    }


To add a face to the database with its gender, age and emotions information, send a POST request to **v1/face**. 

.. rubric:: Request #2

.. code::

    POST /v1/face/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "meta": "Jane Berry",
      "photo": "http://static.findface.pro/sample.jpg",
      "galleries": ["gal1", "niceppl"],
      "emotions": true,
      "gender": true,
      "age": true
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 06:04:02 GMT
    Content-Type: application/json; charset=UTF-8
    Content-Length: [length]

    {
      "results": [
        {
          "galleries": ["default", "gal1", "niceppl"]
          "id": 2334,
          "meta": "Jane Berry",
          "photo": "http://static.findface.pro/sample.jpg",
          "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
          "timestamp": "2016-06-13T11:11:29.425339",
          "age": 26,
          "emotions": [
           "neutral",
           "sad"
          ],
          "gender": "female",
          "x1": 225,
          "x2": 307,
          "y1": 345,
          "y2": 428
        }
      ]
    }


