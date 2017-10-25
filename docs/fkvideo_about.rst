.. _fkvideo-about:

About Video Face Detection
=============================

To add video face detection to your FindFace Server Enterprise SDK instance, you need the :program:`fkvideo_detector` component. This component extracts faces from video and posts them to FindFace Server over API for further processing. It can work with both live streams and files, and supports all video file formats and codecs supported by the `FFmpeg framework <https://www.ffmpeg.org/general.html#Supported-File-Formats_002c-Codecs-or-Features>`__. 

.. contents:: In this section:

.. _fkvideo-install:

Installation
------------------

Install fkvideo_detector from the :program:`<findface-repo>.deb` package on one of the FindFace Server hosts or on a separate host:

.. tip::
   Click :ref:`here <prepare>` for the package preparation instruction. 

.. code::

      $ sudo apt-get update
      $ sudo apt-get install fkvideo-detector


How It Works
--------------------------

Motion Detection and Face Tracking
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When processing video, fkvideo_detector consequently uses the following algorithms:

* :program:`Motion detection`. 

  This algorithm is aimed to reduce system resources consumption. Only when the motion detector recognizes motion of certain intensity in video that the face tracker can be triggered.

* :program:`Face tracking`.
  
  The face tracker tracks, detects and captures faces from video, and posts them to FindFace Server. It can simultaneously process several faces.
  
   .. tip::
     Configure the maximum number of processed faces in the fkvideo_detector :ref:`configuration file <fkvideo-config>`.

  Each captured face is posted as a snapshot and a bbox in a request ``/face`` or ``/identify``, depending on the :ref:`configuration settings <fkvideo-config>`. If there are several active trackers, the face tracker sends the same number of requests with a unique snapshot and bbox in each.

Best Face Search
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When tracking a face, the face tracker searches for its best snapshot before posting it to FindFace Server.

The best face can be found in one of the following modes: 

* Real-time
* Offline

Real-Time Mode
""""""""""""""""""""""""

The real-time mode allows posting a face immediately after it appears in a camera field of view. In this mode, the face tracker searches for the best face snapshot dynamically:

#. First, the face tracker estimates whether the quality of a face snapshot exceeds a pre-defined threshold value. If so, the snapshot is posted to FindFace Server. 
#. The threshold value increases after each post. Each time the face tracker gets a higher quality snapshot of the same face, it is posted. 
#. When the face disappears from the camera field of view, the threshold value resets to default.

Offline Mode
"""""""""""""""""""""""

The offline mode is less storage intensive than the real-time one as it allows posting only one snapshot per face, but of the highest quality. In this mode, the face tracker buffers a video stream with a face in it until the face disappears from the camera field of view. Then
the face tracker picks up the best face snapshot from the buffered video and posts it to FindFace Server. 

Configuration and Usage
----------------------------

To configure fkvideo_detector, you can specify its options in any of the following ways: 

* As command line arguments upon starting fkvideo_detector.

  .. code::

     $ fkvideo_detector [options]

* As parameters in the fkvideo_detector configuration file. 

  .. include:: /_inclusions/fkvideo_config_warning.rst

See :ref:`fkvideo-config` for the full option list.

Video Stream Management
-----------------------------

You can specify video streams to be processed by fkvideo_detector as follows:
 
* A single stream can be specified directly by using the ``--camid`` or ``--source`` options when configuring fkvideo_detector. 
* A list of streams has first to be posted to FindFace Server by applying the :ref:`/camera POST <camera-post>` method to each stream. When posting, all streams in the list have to be assigned a common user-defined string, so called ``detector``. This string should then be specified as the ``--detector-name`` option when configuring fkvideo_detector. In this case, fkvideo_detector will retrieve the list of streams from FindFace Server, based on their ``detector-name``, and begin to process each stream individually. It will also be periodically updating the list of cameras from FindFace Server with a polling interval defined by the ``reload-timeout`` parameter.


