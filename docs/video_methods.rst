.. _video-methods:

Methods for Video Face Detection
------------------------------------------

These methods extend :ref:`general API methods <methods>` of FindFace Enterprise Server SDK. 

.. rubric:: In this section:

.. contents::
   :local:


.. _camera-post:

.. _camera-first:

Method /camera POST
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Description

Creates a new camera.

.. rubric:: Parameters:

* ``meta`` [optional]: some user-defined string identifier
* ``enabled`` [boolean]: enable video processing in FindFace web interface
* ``url`` [optional]: url address of the camera's stream
* ``detector`` [optional]: some user-defined string identifier
* ``rot`` [W,H,X,Y] [optional]: enable detecting and tracking faces only inside a clipping rectangle (ROT, region of tracking).
* ``roi`` [W,H,X,Y] [optional]: enable posting faces detected only inside a region of interest (ROI).

.. rubric:: Returns:

A JSON representation of the added camera or a failure reason.

.. rubric:: Example

.. rubric:: Request

.. code::

    POST /v1/camera/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop
    Content-Type:   application/json
    Content-Length: [length]

    {
        "meta": "meta",
        "enabled": true,
        "url": "http://test.com:1234/stream.flv",
        "detector": "detec1"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 201 Created
    Content-Length: [length]
    Content-Type: application/json; charset=UTF-8
    {
        "meta": "meta",
        "enabled": true,
        "url": "http://test.com:1234/stream.flv",
        "detector": "detec1",
        "id": "7bb35e9d-9f4f-4e5b-8811-e1dded6de811"
    }


.. _camera-get:

Method /camera GET
^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Description

Lists all cameras.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Returns:

The list of all cameras.

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v1/camera HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Content-Length: [length]
    Date: Thu, 13 Oct 2016 12:14:22 GMT
    Content-Type: application/json; charset=UTF-8
    [
      {
        "enabled": true,
        "id": "32bc21fb-0aa2-4d17-88bb-1a2bf76d88ea",
        "meta": "Camera 1",
        "url": "rtsp://127.0.0.1/Streaming/Channels/1"
      },
      {
        "enabled": true,
        "id": "32bc21fb-0aa2-4d17-88bb-1a2bf76d88ea",
        "meta": "Camera 1",
        "roi": [
          200,
          300,
          400,
          500
        ],
        "rot": [
          100,
          100,
          800,
          800
        ],
        "url": "rtsp://127.0.0.1/Streaming/Channels/1"
      }
    ]

.. _camera-id-get:

Method /camera/<camera\_id> GET
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Description

Gets information about the camera with ``id = camera_id``.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Returns:

Info about the camera or a failure reason.

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v1/camera/32bc21fb-0aa2-4d17-88bb-1a2bf76d88ea HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Content-Length: [length]
    Content-Type: application/json; charset=UTF-8
    {
      "enabled": true,
      "id": "32bc21fb-0aa2-4d17-88bb-1a2bf76d88ea",
      "meta": "Camera 1",
      "roi": [
        200,
        300,
        400,
        500
      ],
      "rot": [
        100,
        100,
        800,
        800
      ],
      "url": "rtsp://127.0.0.1/Streaming/Channels/1"
    }


.. _camera-id-put:

Method /camera/<camera_id> PUT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Description

This method can be used to modify certain fields of the camera object with ``id = camera_id``.

.. rubric:: Parameters:

* ``meta`` [optional]: new meta string
* ``url`` [optional]: url address of the camera's stream
* ``rot`` [W,H,X,Y] [optional]: enable detecting and tracking faces only inside a clipping rectangle (ROT, region of tracking).  
* ``roi`` [W,H,X,Y] [optional]: enable posting faces detected only inside a region of interest (ROI).  

.. rubric:: Returns:

A JSON representation of the updated camera with id = <camera\_id>.

.. rubric:: Example #1

.. rubric:: Request

.. code::

    PUT /v1/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop
    Content-Type: application/json
    Content-Length: [length]
    {
        "meta": "newinfo",
        "url": "http://zzzz.com:1234/stream.flv"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Content-Length: [length]
    Content-Type: application/json; charset=UTF-8
    {
        "url": "http://zzzz.com:1234/stream.flv",
        "id": "b28a898b-6334-4d37-8888-c9dd858ddc47",
        "meta": "newinfo"
    }

.. rubric:: Example #2

.. rubric:: Request

.. code::

    PUT /v1/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop
    Content-Type: application/json
    Content-Length: [length]
    {
        "rot": [
          120,
          120,
          35,
          50
        ], 
        "roi": [
          100,
          100,
          40,
          50
        ]
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Content-Length: [length]
    Content-Type: application/json; charset=UTF-8
    {
        "id": "b28a898b-6334-4d37-8888-c9dd858ddc47",
        "rot": [
          120,
          120,
          35,
          50
        ], 
        "roi": [
          100,
          100,
          40,
          50
        ]
    }

.. _camera-id-delete:

Method /camera/<camera_id> DELETE
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Description

Deletes the camera with ``id = camera_id``.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Returns:

HTTP 204 No Content in the case of success, or the reason of failure.

.. rubric:: Example

.. rubric:: Request

.. code::

    DELETE /v1/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop
    Content-Length: 0

.. rubric:: Response

.. code::

    HTTP 204 No Content

