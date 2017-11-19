.. _persons:

Dynamic Person Creation
==============================

You can tailor FindFace Enterprise Server SDK to work in video surveillance and video analytics systems. To do so, harness the Dynamic Person Creation feature.

.. rubric:: In this section:

.. contents::
   :local:


How it works
-----------------------

|persons_en|

.. |persons_en| image:: https://gcc-elb-public-prod.gliffy.net/embed/image/cd111b8107e784960fe47261df2ea185.png

.. |persons_ru| image:: https://gcc-elb-public-prod.gliffy.net/embed/image/08485ff4781b8cf5ac479d7c30dda68e.png

*  An image containing a face (for example, extracted from a RTSP video stream by the video face detector) is sent via a ``/face POST`` request to FindFace Server for identification.
*  When identifying a person, the system uses a face property ``person_id``. For each person in the database, the value of this property should be unique. 
*  FindFace Server takes the new face and searches for the most similar one in the database (the so-called reference face). If similarity between the faces is equal or exceeds the threshold specified in the ``findface-facenapi.ini`` configuration file (``person_identify_threshold``), the new face is added to the database and assigned the same ``person_id`` value as the reference face. It also inherits some other reference face properties. This means that the new face has been identified as belonging to an existing person.
*  If similarity between the faces does not exceed the given threshold, the system considers the new face as unidentified. In this case, the new face is added to the database as belonging to a new person, with a new ``person_id``.
*  In either case, FindFace Server returns a response containing the ``person_id`` value assigned to the added face. This value can be then used in analysis. 

.. warning:: 
      On account of the very logic of dynamic person creation, resembling faces of different people can be identified as belonging to one person and get the same ``person_id``. To avoid this situation, we recommend you to periodically inspect the person database and manually resolve each identity conflict.

Configure Dynamic Person Creation
--------------------------------------

By default, dynamic person creation is disabled. This means that all newly added faces are not assigned the person_id property and the system does not discern persons. 

To enable dynamic person creation, do the following:

#. Open the ``findface-facenapi.ini`` configuration file for editing.

   .. code::

       sudo vi /etc/findface-facenapi.ini

#. Edit the settings. 

   .. warning::
        The ``findface-facenapi.ini`` content must be correct Python code.

   Uncomment and edit the line ``person_identify = False``. This will enable dynamic person creation.
   
   .. code::

             → person_identify = True

   By default, dynamic person creation is performed independently for each camera. To merge person identification results across all cameras, uncomment and edit the line ``person_identify_global = False``. This option works well only in small-scale systems with less than 5 cameras. Otherwise, leave it deactivated.

   .. code::

             → person_identify_global = True

   
   Uncomment and set the threshold for person identification between 0 and 1.

   .. code::

             → person_identify_threshold = 0.75

#. Restart the service.

   .. code::

       sudo service findface-facenapi restart

REST API Sequence for Person Dataset Analysis
--------------------------------------------------------

There are many ways to harness the dynamic person creation feature in analytics. A typical REST API sequence to identify a person and then work with their data is the following:

+-----+------------------------+------------------------------------------------------------------------------------------------------------------------------------+
| #   | Method                 | Description                                                                                                                        |
+=====+========================+====================================================================================================================================+
| 1   | /face POST             | Add a face to the database and receive a JSON representation of it, including the person\_id value.                                |
+-----+------------------------+------------------------------------------------------------------------------------------------------------------------------------+
| 2   | /history/search POST   | Retrieve all events from the history of cameras, related to the person whose person\_id was received in the /face POST response.   |
+-----+------------------------+------------------------------------------------------------------------------------------------------------------------------------+

Method /face POST
^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Request

.. code::

    POST /v0/face/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
        "photo": "http://static.findface.pro/sample.jpg"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": {
        "[595, 127, 812, 344]": [
          {
            "confidence": 1,
            "face": {
              "friend": false,
              "galleries": [
                "default"
              ],
              "id": 2,
              "meta": "Jack Smith",
              "normalized": "http://192.168.113.76:3333/uploads/20170418/1492509569217098.jpeg",
              "person_id": 2,
              "photo": "http://192.168.113.76:3333/uploads/20170418/14925095692111893.jpeg",
              "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
              "thumbnail": "http://192.168.113.76:3333/uploads/20170418/14925095692159095.jpeg",
              "timestamp": "2017-04-18T09:59:29.211000",
              "x1": 595,
              "x2": 812,
              "y1": 127,
              "y2": 344
            }
          }
        ]
      }
    }

Method /history/search POST
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Request

.. code::

    POST /v0/history/search    HTTP/1.1
    Host:   127.0.0.1
    Authorization:  Token   e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type:   application/json
    Content-Length: [length]
    {
        "person_id": 2,
    }

.. rubric:: Response

.. code::

    HTTP/1.1   200 OK
    Date:   Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type:   application/json
    Content-Length: [length]
    {  
       "next_page": "/v0/history/search?max_id=4",
       "results":[  
          {  
             "friend":false,
             "meta":"Jack Smith",
             "photo_hash":"9fda49f2444f93c33ad8aa914e20e53b",
             "cam_id":"12345678123456781234567812345678",
             "person_id":2,
             "timesamp":"2016-10-11T14:36:27.450000",
             "photo":"http://192.168.113.76:3333/uploads/20170418/149250956922566.jpeg",
             "id":20146,
             "y1":77,
             "x1":285,
             "x2":552,
             "y2":345
          },
          {  
             "friend":false,
             "meta":"Jack Smith",
             "photo_hash":"dc7ac54590729669ca869a18d92cd05e",
             "cam_id":"12345678123456781234567812345678",
             "person_id":2,
             "timesamp":"2016-10-12T12:57:07.509000",
             "photo":"http://192.168.113.76:3333/uploads/20170418/14925095692111596.jpeg",
             "id":20147,
             "x1":236,
             "y1":345,
             "x2":311,
             "y2":419
          }
       ]
    }

Other API Methods to Work with Persons
----------------------------------------------

Add and change ``person_id``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To add or change the ``person_id`` value for a particular face, use the method ``PUT /face/id/<face_id>``.

.. warning::
    Since the ``person_id`` property is assigned only to newly added faces, old faces in the database are excluded from the person identification process. Use the method ``PUT /face/id/<face_id>`` to solve the problem.

.. rubric:: Request

.. code::

    PUT /v0/face/id/5/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "person_id": "4"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "id": 5,
      "meta": "Jane Richardson",
      "person_id": "4",
      "photo": "http://static.findface.pro/sample2.jpg",
      "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
      "timestamp": "2016-06-13T11:06:42.075754",
      "x1": 225,
      "x2": 307,
      "y1": 345,
      "y2": 428
    }


Retrieve person history
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve all events from the history of cameras, related to the person with a given ``person_id``, you can use the method ``GET /person/history/id/<person_id>`` (equally with ``/history/search POST``).

.. rubric:: Request

.. code::

    GET    v0/person/history/id/2001   HTTP/1.1
    Host:   127.0.0.1
    Authorization:  Token   e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type:   application/json
    Content-Length: [length]
    {
        "cam_ids":    [1, 25, 26, 27],
        "start":  "2016-06-13T11:00:00.000000",
        "end":    "2016-06-14T11:00:00.000000"
    }

.. rubric:: Response

.. code::

    HTTP/1.1   200 OK
    Date:   Mon,    13  Jun 2016    12:23:56    GMT
    Content-Type:   application/json
    Content-Length: [length]
    {
        "results":    
        [
            {
                "person_id":  2001,
                "face_id":    240344,
                "cam_id": 25,
                "meta":   "Sam   Berry",
        "screenshot":"https://static.findface.pro/57726179d6946f02f3763824/dc7ac54590729669ca869a18d92cd05e_thumb.j
    pg",
                "timestamp":  "2016-06-13T11:06:42.075754",
            },
            {
                "person_id":  2001,
                "face_id":    240422,
                "cam_id": 25,
                "meta":   "Sam   Berry",
                "screenshot": "https://static.findface.pro/57726179
    d6946f02f3763824/dc7ac54590729669ca869a18d92cd05e_thumb.j
    pg",
                "timestamp":  "2016-06-13T11:08:44.073452",
            }
        ]
    }

List persons
^^^^^^^^^^^^^^^^^^^^^

To get the list of all existing persons, use the method ``GET /persons``.

.. rubric:: Request

.. code::

    GET /v0/persons HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e

.. rubric:: Response

.. code::

    HTTP/1.1   200 OK
    Date:   Mon,    13  Jun 2016    12:23:56    GMT
    Content-Type:   application/json
    Content-Length: [length]

    {
      "results": [
        {
          "id": 2,
          "meta": ""
        }
      ]
    }


