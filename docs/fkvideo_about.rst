About Video Face Detection
=============================

The video face detection component :program:`fkvideo_detector` extracts faces on-the-fly from a RTSP camera stream or a video file and sends them to FindFace Server via REST API for further processing.

.. contents:: In this section:

Summary
----------------

.. rubric:: Compatibility

FindFace Enterprise Server SDK 1.2 or later.

.. rubric:: Installation

On one of the FindFace Enterprise Server SDK hosts or on a separate host.

.. rubric:: Functionality

* Motion detector
* Face tracker

These 2 functions enable effective processing of a video stream and capturing faces from it.

.. rubric:: Operation modes

Depending on your integration scenario, fkvideo_detector can operate in the following modes: 

* Real-time
* Offline

.. rubric:: Connection with FindFace Server 

For each face tracked, fkvideo_detector sends a bbox via a POST request ``/face`` or ``/identify``, depending on the fkvideo_detector :ref:`configuration settings <fkvideo-config>`.


.. contents: In this section:


Motion Detector
--------------------

The motion detector as part of fkvideo_detector reduces system resources consumption as the face tracker starts only if motion is detected.

Face Tracker and Bbox Functionality
-----------------------------------------

The face tracker of fkvideo_detector is able to track several people simultaneously. You can configure the maximum number of tracked people
in the fkvideo_detector :ref:`configuration file <fkvideo-config>`.

For each face tracked, fkvideo_detector sends a bbox to FindFace Server via a POST request (``/face`` or ``/identify``, depending
on the :ref:`configuration settings <fkvideo-config>`). If there are several active trackers, FindFace Server receives the
same number of requests with a unique bbox in each.

Real-Time Mode
----------------------

In the real-time mode, face tracking starts as soon as a human face is detected in your camera field of view. Then the best image dynamic
search comes into play:

#. The face tracker calculates the quality of the face image. If it exceeds a pre-defined threshold value, the face image is sent to FindFace Server. 
#. The threshold value increases. If the face tracker gets a higher quality image of the same face, this image will be sent to FindFace Server. 
#. When the face disappears from the camera field of view, the threshold value resets to default.

Offline Mode
-------------------

In the offline mode, the face tracker buffers a video stream with a face in it until the face disappears from the camera field of view. Then
fkvideo_detector gets the best image from the buffered video and sends it to FindFace Server. The offline mode is more resource
intensive than the real-time one.

How to Render API Responses to Detector Requests
------------------------------------------------

The fkvideo_detector component does not process FindFace Server responses to face identification and camera operation API requests. You should write your own proxy script that will manage communication between fkvideo_detector and FindFace Server and redirect API responses to an application that can process and render them. A typical rendering topology is shown on the diagram below:

.. image:: https://gcc-elb-public-prod.gliffy.net/embed/image/e1e6f14528d931131fd3d25fea862232.png

When writing the proxy script, hold to the following logic:

#. A request from fkvideo_detector transparently goes to FindFace Server in the following format:

   .. code::

      curl -X POST -H 'Authorization: Token ntech' -F "gender=true" -F "emotions=true" -F "age=true" -F "cam_id=1b19a189-26b9-42e5-8cd8-6cabde79dc7e" -F "timestamp=2017-08-25T13:09:54" -F "bbox=[[620,380,1383,1143]]" -F "photo=@15036665986531599.jpeg" -F "face0=@15036665986766284_norm.png" -F 'detectorParams={"score": -0.000911839, "direction_score": -0.568228}' http://192.168.104.184:8000/v1/face

#. As FindFace Server replies to fkvideo_detector, your proxy script should redirect the response to your application for further processing.
   
   .. note::
       FindFace Server responses to requests sent directly or by fkvideo_detector are same. They may contain a link to a face thumbnail and other data which can be parsed in your application.

