.. _test:

Test Requests
-----------------------

Before you can proceed with development and deliver face recognition services to your customers, make sure that the FindFace Server components are working. To do so, run the test requests below, minding the sequence. To pretty-print responses, we recommend you to use :program:`jq`.

.. note::
      The request messages here are provided only for reference. To create valid requests out of the examples below, replace the token in the messages with the :ref:`actual <token>` one.

.. tip::
     To proceed with development, find more code samples (in C#, PHP, Java and Python) on our `GitHub <https://github.com/NTech-Lab/ffserver-examples>`_.

.. rubric:: In this section:

.. contents::
   :local:


How to Pretty-Print Responses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use :program:`jq` to parse JSON data in responses. To install :program:`jq`, execute:
::

 sudo apt-get install jq


List Galleries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This request returns the name of the only gallery existing at the present moment. It is the ``default`` gallery. Relevant REST API method: :ref:`/galleries GET <galleries-get>`.

.. rubric:: Request

::

 curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" http://localhost:8000/v0/galleries | jq


.. rubric:: Response

::
 
  {
    "results": [
      "default"
    ]
  }



Create New Gallery
^^^^^^^^^^^^^^^^^^^^^^^^^^^

This request creates a new gallery ``testgal``. Relevant REST API method: :ref:`/galleries/new POST <gallery-post>`.

.. rubric:: Request

::

    curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -X POST http://localhost:8000/v0/galleries/testgal | jq

.. rubric:: Response

::

  {
    "name": "testgal"
  }     

Detect Face in Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This request detects faces in a sample image on the Internet and returns coordinates of the rectangle around a detected face (:ref:`bbox <bbox>`). Relevant REST API method: :ref:`/detect POST <detect-post>`.

.. rubric:: Request

::

   curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F "photo=http://static.findface.pro/sample.jpg" http://localhost:8000/v0/detect | jq  
   
.. rubric:: Response

::

  {
    "faces": [
      {
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      }
    ],
    "orientation": 1
  }


Add Face to Gallery
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This request processes the same sample image as in the previous request, detects a face and adds the detected face to the default gallery with a unique meta tag. Relevant REST API method: :ref:`/face POST <face-post>`.

.. rubric:: Request

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F "photo=http://static.findface.pro/sample.jpg" -F "meta=Sam Berry" http://localhost:8000/v0/face | jq

.. rubric:: Response

::

  {
    "results": [
      {
        "friend": false,
        "galleries": [
          "default"
        ],
        "id": 3827229391220303,
        "meta": "Sam Berry",
        "normalized": "http://192.168.113.88:3333/uploads//20170517/1495011480937809.jpeg",
        "person_id": 5,
        "photo": "http://192.168.113.88:3333/uploads//20170517/14950114809306293.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://192.168.113.88:3333/uploads//20170517/149501148093593.jpeg",
        "timestamp": "2017-05-17T08:58:00.930572",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      }
    ]
  }

The following request also adds a face to a gallery but this time the face is extracted from a local image, and the gallery is custom ('testgal').

.. rubric:: Request

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F "photo=@sample.jpg" -F "meta=sample" -F "galleries=testgal" http://localhost:8000/v0/face | jq

.. rubric:: Response

:: 

  {
    "results": [
      {
        "friend": false,
        "galleries": [
          "default",
          "testgal"
        ],
        "id": 3827229578000564,
        "meta": "sample",
        "normalized": "http://192.168.113.88:3333/uploads//20170517/14950115538997407.jpeg",
        "person_id": 5,
        "photo": "http://192.168.113.88:3333/uploads//20170517/14950115538939695.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://192.168.113.88:3333/uploads//20170517/14950115538985784.jpeg",
        "timestamp": "2017-05-17T08:59:13.893921",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      }
    ]
  }
  
Compare Face with Those from Gallery
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following 2 requests process an image on the Internet (#1) and a local image (#2), detect a face and compare it with those from the default gallery. Return data of most similar faces and their similarity index. Relevant REST API method: :ref:`/identify POST <identify-post>`.

.. rubric:: Request #1

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F "photo=http://static.findface.pro/sample2.jpg" http://localhost:8000/v0/identify | jq

.. rubric:: Response

::

  {
    "results": {
      "[515, 121, 821, 427]": [
        {
          "confidence": 0.9373,
          "face": {
            "age": 26.0483455657959,
            "emotions": [
              "neutral",
              "sad"
            ],
            "friend": false,
            "galleries": [
              "default"
            ],
            "gender": "female",
            "id": 3827062458772442,
            "meta": "Sam Berry",
            "normalized": "http://192.168.113.88:3333/uploads//20170516/1494946272949371.jpeg",
            "person_id": 5,
            "photo": "http://192.168.113.88:3333/uploads//20170516/14949462729435823.jpeg",
            "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
            "thumbnail": "http://192.168.113.88:3333/uploads//20170516/14949462729480093.jpeg",
            "timestamp": "2017-05-16T14:51:12.943000",
            "x1": 595,
            "x2": 812,
            "y1": 127,
            "y2": 344
          }
        }
      ]
    }
  }

.. rubric:: Request #2

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F "photo=@Pictures/sample.jpg" http://localhost:8000/v0/identify | jq

.. rubric:: Response

::

  {
    "results": {
      "[595, 127, 812, 344]": [
        {
          "confidence": 0.9999,
          "face": {
            "age": 26.0483455657959,
            "emotions": [
              "neutral",
              "sad"
            ],
            "friend": false,
            "galleries": [
              "default"
            ],
            "gender": "female",
            "id": 3827062458772442,
            "meta": "Sam Berry",
            "normalized": "http://192.168.113.88:3333/uploads//20170516/1494946272949371.jpeg",
            "person_id": 5,
            "photo": "http://192.168.113.88:3333/uploads//20170516/14949462729435823.jpeg",
            "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
            "thumbnail": "http://192.168.113.88:3333/uploads//20170516/14949462729480093.jpeg",
            "timestamp": "2017-05-16T14:51:12.943000",
            "x1": 595,
            "x2": 812,
            "y1": 127,
            "y2": 344
          }
        }
      ]
    }
  }
  
Compare Two Faces
^^^^^^^^^^^^^^^^^^^^^^^^^^^

This request compares a face in a local image and that on the Internet. Relevant REST API method: :ref:`/verify POST <verify-post>`.

.. rubric:: Request

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F "photo1=@Pictures/sample.jpg" -F "photo2=http://static.findface.pro/sample2.jpg" http://localhost:8000/v0/verify | jq

.. rubric:: Response

::

  {
    "results": [
      {
        "bbox1": {
          "x1": 595,
          "x2": 812,
          "y1": 127,
          "y2": 344
        },
        "bbox2": {
          "x1": 515,
          "x2": 821,
          "y1": 121,
          "y2": 427
        },
        "confidence": 0.9373794198036194,
        "verified": true
      }
    ],
    "verified": true
  }
  
List Faces from Galleries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following requests return the list of all faces stored in galleries, both default and custom (#1), and only custom (#2). Relevant REST API method: :ref:`/faces GET <faces-get>`.

.. rubric:: Request #1

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" http://localhost:8000/v0/faces | jq

.. rubric:: Response

::

  {
    "next_page": "/v0/faces?max_id=3827058103081960",
    "prev_page": null,
    "results": [
      {
        "friend": false,
        "galleries": [
          "default",
          "testgal"
        ],
        "id": 3827229578000564,
        "meta": "sample",
        "normalized": "http://192.168.113.88:3333/uploads//20170517/14950115538997407.jpeg",
        "person_id": 5,
        "photo": "http://192.168.113.88:3333/uploads//20170517/14950115538939695.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://192.168.113.88:3333/uploads//20170517/14950115538985784.jpeg",
        "timestamp": "2017-05-17T08:59:13.893000",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      },
      {
        "friend": false,
        "galleries": [
          "default"
        ],
        "id": 3827229391220303,
        "meta": "Sam Berry",
        "normalized": "http://192.168.113.88:3333/uploads//20170517/1495011480937809.jpeg",
        "person_id": 5,
        "photo": "http://192.168.113.88:3333/uploads//20170517/14950114809306293.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://192.168.113.88:3333/uploads//20170517/149501148093593.jpeg",
        "timestamp": "2017-05-17T08:58:00.930000",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      },
      {
        "age": 26.0483455657959,
        "emotions": [
          "neutral",
          "sad"
        ],
        "friend": false,
        "galleries": [
          "default"
        ],
        "gender": "female",
        "id": 3827227793957831,
        "meta": "Sam Berry",
        "normalized": "http://192.168.113.88:3333/uploads//20170517/14950108570078573.jpeg",
        "person_id": 5,
        "photo": "http://192.168.113.88:3333/uploads//20170517/14950108570022256.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://192.168.113.88:3333/uploads//20170517/14950108570066717.jpeg",
        "timestamp": "2017-05-17T08:47:37.002000",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      }
    ]
  }



.. rubric:: Request #2

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" http://localhost:8000/v0/faces/gallery/testgal | jq

.. rubric:: Response

::

  {
    "next_page": "/v0/faces/gallery/testgal?max_id=3827059994026334",
    "prev_page": null,
    "results": [
      {
        "friend": false,
        "galleries": [
          "default",
          "testgal"
        ],
        "id": 3827229578000564,
        "meta": "sample",
        "normalized": "http://192.168.113.88:3333/uploads//20170517/14950115538997407.jpeg",
        "person_id": 5,
        "photo": "http://192.168.113.88:3333/uploads//20170517/14950115538939695.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://192.168.113.88:3333/uploads//20170517/14950115538985784.jpeg",
        "timestamp": "2017-05-17T08:59:13.893000",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      },
     {
        "galleries": [
          "default",
          "testgal"
        ],
        "id": 3827059994026334,
        "meta": "sample",
        "normalized": "http://127.0.0.1:3333/uploads//20170516/14949453101653092.jpeg",
        "photo": "http://127.0.0.1:3333/uploads//20170516/14949453101581762.jpeg",
        "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
        "thumbnail": "http://127.0.0.1:3333/uploads//20170516/14949453101640306.jpeg",
        "timestamp": "2017-05-16T14:35:10.158000",
        "x1": 595,
        "x2": 812,
        "y1": 127,
        "y2": 344
      }
    ]
  }
  
Recognize Gender, Age and Emotions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This request detects faces in a sample image on the internet and returns coordinates of the rectangle around a detected face (bbox) along with gender, age and emotions information. Relevant REST API method: :ref:`/detect POST <detect-post>`. API version: v1.

.. note::
     First, you need to :ref:`configure <gae>` gender, age and emotions recognition.

.. rubric:: Request

::

  curl -H "Authorization: Token t3WGNhZbyaE_GFyQaywYllFoR2QkHXi-" -F 'photo=https://static.findface.pro/sample2.jpg' -F 'gender=true' -F 'emotions=true' -F 'age=true' http://localhost:8000/v1/detect | jq

.. rubric:: Response

::

  {
    "faces": [
      {
        "age": 29.057680130004883,
        "emotions": [
          "neutral",
          "happy"
        ],
        "gender": "female",
        "x1": 515,
        "x2": 821,
        "y1": 121,
        "y2": 427
      }
    ],
    "orientation": 1
  }


