.. _video-methods:

Methods for Video Face Detection
====================================

These methods extend :ref:`general API methods <methods>` of FindFace Enterprise Server SDK. 

.. contents:: In this section:

.. _camera-post:

Method /camera POST
-----------------------------

.. rubric:: Description

Creates a new camera.

.. rubric:: Parameters:

* ``meta`` [optional]: some user-defined string identifier
* ``url`` [optional]: url address of the camera's stream
* ``detector`` [optional]: some user-defined string identifier
* ``rot`` [W,H,X,Y] [optional]: enable detecting and tracking faces only inside a clipping rectangle (ROT, region of tracking).
* ``roi`` [W,H,X,Y] [optional]: enable posting faces detected only inside a region of interest (ROI).

.. rubric:: Returns:

A JSON representation of the added camera or a failure reason.

.. rubric:: Example

.. rubric:: Request

.. code::

    POST /v0/camera/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop
    Content-Type:   application/json
    Content-Length: [length]

    {
        "meta": "test",
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
        "url": "http://test.com:1234/stream.flv",
        "detector": "detec1",
        "id": "7bb35e9d-9f4f-4e5b-8811-e1dded6de811"
    }

.. _camera-get:

Method /camera GET
--------------------------

.. rubric:: Description

Lists all cameras.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Returns:

The list of all cameras.

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/camera HTTP/1.1
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
            "meta": "firstcam", 
            "url": "http://192.168.133.37:1234/stream.flv" 
            "id": "34ba07c4-0677-4d5c-9946-62c625cd7127"
        },
        {
            "meta": "newinfo",
            "url": "http://5.6.7.8:1234/stream.flv",
            "id": "b28a898b-6334-4d37-8888-c9dd858ddc47"
        },
        ...
    ]

.. _camera-id-get:

Method /camera/<camera\_id> GET
------------------------------------

.. rubric:: Description

Gets information about the camera with ``id = camera_id``.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Returns:

Info about the camera or a failure reason.

.. rubric:: Example

.. rubric:: Request

.. code::

    GET /v0/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Content-Length: [length]
    Content-Type: application/json; charset=UTF-8
    {
        "meta": "test info",
        "url": "http://5.6.7.8:1234/stream.flv",
        "id": "b28a898b-6334-4d37-8888-c9dd858ddc47"
    }

.. _camera-id-put:

Method /camera/<camera_id> PUT
-----------------------------------

.. rubric:: Description

This method can be used to modify certain fields of the camera object with ``id = camera_id``.

.. rubric:: Parameters:

* ``meta`` [optional]: new meta string
* ``url`` [optional]: url address of the camera's stream
* ``rot`` [W,H,X,Y] [optional]: enable detecting and tracking faces only inside a clipping rectangle (ROT, region of tracking). If you use ROT, be sure to pass this parameter to the camera each time you send a PUT request because if this parameter is missing or empty in the request, ROT on the camera will be deleted. 
* ``roi`` [W,H,X,Y] [optional]: enable posting faces detected only inside a region of interest (ROI). If you use ROI, be sure to pass this parameter to the camera each time you send a PUT request because if this parameter is missing or empty in the request, ROI on the camera will be deleted. 

.. rubric:: Returns:

A JSON representation of the updated camera with id = <camera\_id>.

.. rubric:: Example #1

.. rubric:: Request

.. code::

    PUT /v0/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
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

    PUT /v0/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
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
-----------------------------------------

.. rubric:: Description

Deletes the camera with ``id = camera_id``.

.. rubric:: Parameters:

This method doesn't accept any additional parameters.

.. rubric:: Returns:

HTTP 204 No Content in the case of success, or the reason of failure.

.. rubric:: Example

.. rubric:: Request

.. code::

    DELETE /v0/camera/b28a898b-6334-4d37-8888-c9dd858ddc47 HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token 1234567890qwertyuiop
    Content-Length: 0

.. rubric:: Response

.. code::

    HTTP 204 No Content

