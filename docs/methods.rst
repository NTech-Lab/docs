.. _methods:

General Methods
=======================

.. rubric:: In this section:

.. contents::
   :local:


.. _detect-post:

Method /detect POST
--------------------------

This method detects faces in the provided image and recognize gender, age, and emotions, given the request parameters. You can either upload the image as multipart/form-data or provide the image URL.

.. rubric:: Parameters:

* ``photo``: an uploaded image, or a publicly accessible URL, containing the image
* ``gender``: if true, return gender
* ``age``: if true, return age
* ``emotions``: if true, return emotions

.. rubric:: Returns:

* A list of rectangles, containing the detected faces

.. rubric:: Example

.. rubric:: Request

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


.. _verify-post:

Method /verify POST
---------------------------

This method is used to verify that two faces belong to the same person, or, alternatively, measures the similarity between the two faces. You
can choose between these two modes by setting the ``threshold`` parameter. 

In the case, when a binary decision is required, the user should pass a value for the ``threshold`` parameter. You can use one of the 3 :ref:`preset values <thresholds>`: ``strict``, ``medium`` and ``low`` with the former aimed at minimizing the false accept rates and the latter being somewhat more permissive. You can also set a user-defined value.

In the case, when you need to calculate similarity of different persons or find similar people rather than verify identity, pass ``none`` to the ``threshold`` parameter. 

.. note::
   If no threshold level is specified, it is set to the default value ``0.75``.

.. tip::
   Please feel free to contact us if you need to tune the threshold value for your specific use-case and/or dataset.

.. rubric:: Parameters:

* ``photo1``: the first uploaded image or an external URL
* ``photo2``: the second uploaded image or an external URL
* ``bbox1`` [optional]: array of bounding boxes for the faces on the first photo
* ``bbox2`` [optional]: array of bounding boxes for the faces on the second photo
* ``threshold`` [optional]: one of "strict", "medium", "low" or "none", or a value between 0 and 1. Default is 0.75.
* ``mf_selector`` [optional]: specifies behavior in a case of multiple faces on a photo; one of:

    * ``"reject"``: return an error if more than one face was detected on any of image
    * ``"biggest"`` [default]: add the biggest face on the image
    * ``"all"``: verify all faces, found on both images.

  .. note::
       Note that providing ``bbox1`` or ``bbox2`` argument overrides the value of this parameter.

.. rubric:: Returns:

* binary verification result, only returned if threshold was not set to none. Each pair of faces is given it's own result. The given pair of photos is also provided with the verification result. It will be true if each face on the first photo has a match on the second.
* the coordinates of the bounding boxes with the faces on the images
* the algorithm's confidence in the decision, measured from 0 to 1

.. rubric:: Example

.. rubric:: Request

.. code::

    POST /v0/verify/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "photo1": "http://static.findface.pro/sample.jpg",
      "photo2": "http://static.findface.pro/sample2.jpg"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": [
        {
          "bbox1": {
            "x1": 225,
            "x2": 307,
            "y1": 345,
            "y2": 428
          },
          "bbox2": {
            "x1": 78,
            "x2": 185,
            "y1": 114,
            "y2": 222
          },
          "confidence": 0.4206026792526245,
          "verified": true
        }
      ],
      "verified": true
    }

.. _identify-post:

Method /identify POST
---------------------------

This method is used to search through the face database. The method returns at most n faces (one by default), which are the most similar to the specified face, and the similarity is above the specified :ref:`threshold <thresholds>`. You can optionally specify a gallery id to check a photo only against photos in this gallery.

.. rubric:: Parameters:

* ``photo``: the uploaded image, or an external URL
* ``x1, y1, x2, y2`` [optional]: coordinates of a bounding box of the face on the photo
* ``threshold`` [optional]: one of "strict", "medium", "low" or "none", or a value between 0 and 1. Default is 0.75.
* ``n`` [optional]: maximum number of closest faces to return, 1 by default
* ``strict`` [optional]: specifies behavior in case if one or several tntapi shards are out of service. This parameter takes priority over the ``tntapi_ignore_search_errors`` parameter from the findface-facenapi :ref:`configuration file <configure-network>`.

    * ``True``: return an error if some tntapi shards are out of service
    * ``False`` [default]: use available tntapi shards to obtain face identification results, indicating the number of available servers vs the total number of servers in the ``X-Live-Servers`` header.

* ``mf_selector`` [optional]: specifies behavior in case if multiple faces are detected on the photo or inside the provided bounding box:

    * ``"reject"``: return an error if more than one face was detected on any of image
    * ``"biggest"`` [default]: identify the biggest face on the image
    *  ``"all"``: identify all faces, found on the image.


.. rubric:: Returns:

* A map where keys are array representations of bounding boxes of faces on provided photo and values are arrays face objects, along with match confidence, measured from 0 (lowest) to 1 (highest)

.. rubric:: Example

.. rubric:: Request

.. code::

    POST /v0/identify/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "n": 10,
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
        "[419, 236, 345, 311]": [
          {
            "confidence": 1,
            "face": {
              "galleries": ["default", "ppl"]
              "id": 316275,
              "meta": "Sam Berry",
              "photo": "http://static.findface.pro/sample.jpg",
              "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
              "timestamp": "2016-07-01T12:18:27.477653",
              "x1": 236,
              "x2": 311,
              "y1": 345,
              "y2": 419
            }
          },
          {
            "confidence": 0.723975,
            "face": {
              "galleries": ["default", "ppl"]
              "id": 316283,
              "meta": "Sam Berry",
              "photo": "http://test.flexify.io/img/sample2.jpg",
              "photo_hash": "9b1dd93259fe87df122cd678ce95b9f9",
              "timestamp": "2016-07-01T13:19:36.376548",
              "x1": 78,
              "x2": 185,
              "y1": 114,
              "y2": 222
            }
          }
        ]
      }
    }

.. _face-post:

Method /face POST
-----------------------

Processes the uploaded image or provided URL, detects faces and adds the
detected faces to the searchable database. If there are multiple faces
on the photos, only the biggest face is added by default. You can add a
custom string meta, such as name or ID, which uniquely identifies a
person. Multiple face objects may have the same meta. We recommend that
you don't assign the same meta to different persons. Thus when using
person's name as a meta, make sure that all names are unique. You can
optionally prefix it with a gallery id to upload into non-default
gallery.

.. rubric:: Parameters:

* ``photo``: an uploaded image, or a publicly accessible URL, containing the image
* ``meta`` [optional]: some user-defined string identifier
* ``bbox`` [optional]: array of bounding boxes specifying face locations on the image
* ``mf_selector`` [optional]: specifies behavior in case if there are multiple faces found on the image or inside the specified rectangle; one of:

    * ``"reject"``: return an error if more than one face was detected
    * ``"biggest"`` [default]: add the biggest face on the image
    * ``"all"``: add all faces, found on the image. Please note that the meta will be the same for all faces added

* ``galleries`` [optional]: list of gallery names
* ``cam_id`` [optional]: UUID of the camera

.. rubric:: Returns:

* A JSON representation of the added faces or a failure reason
* In the case multiple faces are detected and ``mf_selector`` is set to reject, this method returns ``400 Bad Request`` and a list of bounding box coordinates for each detected face.

.. rubric:: Example #1

.. rubric:: Request

.. code::

    POST /v0/face/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "meta": "Sam Berry",
      "photo": "http://static.findface.pro/sample.jpg",
      "galleries": ["gal1", "niceppl"]
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
          "meta": "Sam Berry",
          "photo": "http://static.findface.pro/sample.jpg",
          "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
          "timestamp": "2016-06-13T11:11:29.425339",
          "x1": 225,
          "x2": 307,
          "y1": 345,
          "y2": 428
        }
      ]
    }

.. rubric:: Example #2

.. rubric:: Request

.. code::

    POST /v0/face/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "mf_selector": "reject",
      "photo": "http://static.findface.pro/sample-multiface.jpg"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 400 Bad Request
    Date: Mon, 13 Jun 2016 06:04:02 GMT
    Content-Type: application/json; charset=UTF-8
    Content-Length: [length]

    {
      "code": 400,
      "faces": [
        {
          "x1": 1952,
          "x2": 2137,
          "y1": 838,
          "y2": 1023
        },
        {
          "x1": 1766,
          "x2": 1952,
          "y1": 1312,
          "y2": 1498
        },
        {
          "x1": 1385,
          "x2": 1540,
          "y1": 939,
          "y2": 1094
        },
        {
          "x1": 2452,
          "x2": 2607,
          "y1": 664,
          "y2": 818
        },
        {
          "x1": 1609,
          "x2": 1764,
          "y1": 767,
          "y2": 922
        }
      ],
      "reason": "Too many faces: 5"
    }

.. _face-id-get:

Method /face/id/<id> GET
----------------------------------

Returns detailed information about the face with id = FaceID.

.. rubric:: Parameters:

* This method doesn't accept any additional parameters.

.. rubric:: Returns:

* A JSON representation of the face with ``id = FaceID``.

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/face/id/2333/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "galleries": ["default", "ppl"]
      "id": 2333,
      "meta": "Sam Berry",
      "photo": "http://static.findface.pro/sample.jpg",
      "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
      "timestamp": "2016-06-13T11:06:42.075754",
      "x1": 225,
      "x2": 307,
      "y1": 345,
      "y2": 428
    }

.. _face-id-put:

Method /face/id/<id> PUT
----------------------------------

This method can be used to modify certain fields of the face object with ``id = FaceID``. Currently only changes to the meta attribute are supported.

.. rubric:: Parameters:

* ``meta``: new meta string
* ``person_id``: unique identifier of the person
* ``galleries``: JSON dictionary with one key and one value. Either \ ``{"add":["list","of","galleries"]}``, \ ``{"del":["list","of","galleries"]}``, \ ``{"set":["list","of","galleries"]}``. Allows you to add face to galleries, remove from galleries or replace gallery list completely.

.. rubric:: Returns:

* A JSON representation of the updated face with id = FaceID

.. rubric:: Example

.. rubric:: Request

.. code::

    PUT /v0/face/id/5/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
      "meta": "Sam Berry #2"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "id": 2333,
      "meta": "Sam Berry #2",
      "photo": "http://static.findface.pro/sample2.jpg",
      "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
      "timestamp": "2016-06-13T11:06:42.075754",
      "x1": 225,
      "x2": 307,
      "y1": 345,
      "y2": 428
    }

.. _face-id-delete:

Method /face/id/<id> DELETE
--------------------------------

Deletes a face with the id = FaceId.

.. rubric:: Parameters:

* This method does not accept any additional parameters.

.. rubric:: Returns:

* HTTP 204 No Content in the case of success, or the reason of failure

.. rubric:: Example

.. rubric:: Request

.. code::

    DELETE /v0/face/id/2332/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token ca7916cdac260628c411cb5d895dd566
    Content-Length: 0

.. rubric:: Response

.. code::

    HTTP/1.1 204 No Content

.. _face-meta-get:

Method /face/meta/<meta> GET
-----------------------------------

Returns the list of faces with a given meta string. Note that the method
is case-sensitive, so the given meta has to fully match the one from the
database. A meta string has to be URL encoded, and according to the
standard, spaces should be encoded as **%20** (not +) in this part of
the URL.

.. rubric:: Parameters:

* This method doesn't accept any additional parameters.

.. rubric:: Returns:

* Returns the list of faces with a <meta>. 

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/face/meta/Sam%20Berry/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": [
        {
          "galleries": ["default", "ppl"],
          "id": 2333,
          "meta": "Sam Berry",
          "photo": "http://static.findface.pro/sample.jpg",
          "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
          "timestamp": "2016-06-13T11:06:42.075754",
          "x1": 225,
          "x2": 307,
          "y1": 345,
          "y2": 428
        },
        {
          "galleries": ["default", "ppl"],
          "id": 2378,
          "meta": "Sam Berry",
          "photo": "http://static.findface.pro/sample2.jpg",
          "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
          "timestamp": "2016-06-13T11:06:42.075754",
          "x1": 46,
          "x2": 502,
          "y1": 472,
          "y2": 789
        }
      ]
    }

.. _faces-get:

Method /faces GET
------------------------

.. rubric:: Parameters

* This method doesn't accept any additional parameters. 

.. rubric:: Returns:

* Returns the list of all faces stored in database.

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/faces/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": [
        {
          "galleries": ["default", "ppl"]
          "id": 2333,
          "meta": "Sam Berry",
          "photo": "http://static.findface.pro/sample.jpg",
          "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
          "timestamp": "2016-06-13T11:06:42.075754",
          "x1": 225,
          "x2": 307,
          "y1": 345,
          "y2": 428
        },
        {
          "galleries": ["default", "ppl"]
          "id": 2335,
          "meta": "",
          "photo": "http://static.findface.pro/sample2.jpg",
          "photo_hash": "9879efb38d2dae550460c9edb6f36982",
          "timestamp": "2016-06-13T11:34:57.275394",
          "x1": 8,
          "x2": 152,
          "y1": 406,
          "y2": 550
        }
      ]
    }

.. _faces-gallery-get:

Method /faces/gallery/<gallery> GET
--------------------------------------

Returns the list of all faces stored in a specified gallery.

.. _meta-get:

Method /meta GET
-------------------

This method retrieves all the meta string stored in the database along with one of the associated faces. To get more faces call ``GET /v0/face/meta/[Meta]``.

.. rubric:: Parameters:

* This method doesn't accept any additional parameters

.. rubric:: Returns:

* A list of objects containing meta string, number of faces marked with this meta string, and JSON representation of the first face object marked with this meta string

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/meta/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": [
        {
          "count": 1,
          "face": {
            "galleries": ["default", "ppl"]
            "id": 2333,
            "meta": "Sam Berry",
            "photo": "http://static.findface.pro/sample.jpg",
            "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
            "timestamp": "2016-06-13T11:06:42.075754",
            "x1": 225,
            "x2": 307,
            "y1": 345,
            "y2": 428
          },
          "meta": "Sam Berry"
        },
        {
          "galleries": ["default", "ppl"]
          "count": 15,
          "face": {
            "id": 2563,
            "meta": "Angelina Jolie",
            "photo": "http://static.findface.pro/sample2.jpg",
            "photo_hash": "dc7ac54590729669ca869a18d92cd05e",
            "timestamp": "2016-06-13T11:06:42.075754",
            "x1": 225,
            "x2": 307,
            "y1": 345,
            "y2": 428
          },
          "meta": "Angelina Jolie"
        }
      ]
    }

.. _galleries-get:

Method /galleries GET
-------------------------------

List all your galleries.

.. rubric:: Returns:

* A JSON dictionary with list of gallery ids

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/galleries/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": [
        "default",
        "test"
        "57bd75f941741d36ab4614a0",
        "57bd76a241741d377bf881ac",
      ]
    }

.. _gallery-post:

Method /galleries/<gallery> POST
----------------------------------------

Creates a new gallery under a given name. The gallery name can contain
English letters, numbers, underscore and minus sign
(``[a-zA-Z0-9_-]+``). It shouldn't be longer than 48 characters.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Example

.. rubric:: Request

.. code::

    POST /v0/galleries/testgal HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json

.. rubric:: Response

.. code::

    HTTP/1.1 201 Created
    Date: Mon, 13 Jun 2016 06:04:02 GMT

.. _gallery-delete:

Method /galleries/<gallery> DELETE
------------------------------------------

Deletes the gallery and all faces in it.

.. rubric:: Returns:

* HTTP 204 No content.

.. rubric:: Example

.. rubric:: Request

.. code::

    DELETE /v0/galleries/niceppl HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Length: 0

.. rubric:: Response

.. code::

    HTTP/1.1 204 No Content

.. _docs-get:

Method /docs GET
-----------------------------

Lists documented API versions. Available without authorization.

.. _ doc-version-get:

Method /docs/<version> GET
------------------------------

Get documentation for specified API version. Available without
authorization.

.. _person-id-get:

Method /person/id/<id> GET
-----------------------------------

.. rubric:: Parameters:

* This method doesn't accept any additional parameters

.. rubric:: Returns:

* A JSON representation of the person with id = FaceID

.. rubric:: Example

.. rubric:: Request

.. code::

    GET    /person/history/id/2001 HTTP/1.1
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

.. _history-search-post:

Method /history/search POST
---------------------------------------

This method retrieves all events from camera history of the given
parameters.

.. rubric:: Parameters:

* ``"person_id"`` [optional]: unique person id
* ``"cam_ids"`` [optional]: array of camera ids.
* ``"start"`` [optional]: search history interval, start time as ISO8601 string
* ``"end"`` [option]: search history interval, end time as ISO8601 string
* ``"friend"`` [optional]: friend or foe identification
* ``"limit"`` [optional]: records per page, if 0 (default) - unlimited

.. rubric:: Returns:

* A list of history events.
* ``next_page``: URL to the next page (path and query portion only). If no such field in response - no more pages exist.

.. rubric:: Example

.. rubric:: Request

.. code::

    POST /v0/history/search    HTTP/1.1
    Host:   127.0.0.1
    Authorization:  Token   e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type:   application/json
    Content-Length: [length]
    {
        "limit": 2,
    }

.. rubric:: Response

.. code::

    HTTP/1.1   200 OK
    Date:   Mon,    12  Oct 2016    12:23:56    GMT
    Content-Type:   application/json
    Content-Length: [length]
    {  
       "next_page": "/v0/history/search?max_id=4",
       "results":[  
          {  
             "friend":false,
             "meta":"",
             "photo_hash":"9fda49f2444f93c33ad8aa914e20e53b",
             "cam_id":"12345678123456781234567812345678",
             "person_id":8,
             "timestamp":"2016-10-11T14:36:27.450000",
             "photo":"",
             "id":20146,
             "y1":77,
             "x1":285,
             "x2":552,
             "y2":345
          },
          {  
             "friend":false,
             "meta":"",
             "photo_hash":"dc7ac54590729669ca869a18d92cd05e",
             "cam_id":"12345678123456781234567812345678",
             "person_id":8,
             "timesamp":"2016-10-12T12:57:07.509000",
             "photo":"",
             "id":20147,
             "x1":236,
             "y1":345,
             "x2":311,
             "y2":419
          }
       ]
    }

