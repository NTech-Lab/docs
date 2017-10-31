.. _requirements:

**************************
System Requirements
**************************

.. contents:: In this chapter:

.. _general-requirements:

General Requirements
=============================

Hosts
--------------------

Prior to installing FindFace Enterprise Server SDK, ensure that the host(s) meet the following minimum requirements:

.. note::
    :ref:`Standalone installation <standalone>` of FindFace Enterprise Server SDK is recommended when the number of faces in the database **does not** exceed some ``1,000,000``. Otherwise you should install Findface Enterprise Server SDK in a :ref:`cluster environment <cluster>` and configure :ref:`fast index <fast-index>` search.


+--------------------+-----------------------------------------------------------------------------+
| Requirement        | Description                                                                 |
+====================+=============================================================================+
| CPU                | x86-64 CPU (Intel), >2.0 Ghz, >2 cores.                                     |
|                    | The CPU AVX support is required for operation of all the components,        |
|                    | except findface-upload.                                                     |
+--------------------+-----------------------------------------------------------------------------+
| RAM                | RAM consumption depends on the number of faces in your dataset.             |
|                    | Use the benchmark results :ref:`below <RAM-benchmark>` to calculate         |
|                    | the memory size you need.                                                   |
|                    |                                                                             |
|                    | Note that if there are 2 or more galleries with facens, you have to         |
|                    | multiply the given MongoDB and Tarantool RAM consumption by the relevant    | 
|                    | number of galleries.                                                        |
+--------------------+-----------------------------------------------------------------------------+
| Storage            | ~1280 byte per face in dataset. 10M faces = ~12Gb.                          |
|                    | To store all uploaded images via findface-upload:                           |
|                    | size of all uploaded images + 10%                                           |
+--------------------+-----------------------------------------------------------------------------+
| Operating system   | Ubuntu 16.04 LTS.                                                           |
|                    | The 32-bit version is not supported.                                        |
+--------------------+-----------------------------------------------------------------------------+
| Virtual machine    | VMware: vSphere 5.0 or later.                                               |
| support            |                                                                             |
+--------------------+-----------------------------------------------------------------------------+

.. _RAM-benchmark:

Here you can see the FindFace Enterprise Server SDK memory usage benchmark results. Use these data to calculate the RAM size you need.

.. note::
   Memory usage may slightly vary from test to test.

.. note::
   Depending on your needs, :ref:`adjust <tntapi>` the Tarantool maximum memory usage at ``/etc/tarantool/instances.enabled/FindFace.lua``. 

The testing setup is the following:

* Neural network facen :ref:`model <models>`: ``apricot_320``
* Models for :ref:`gender, age and emotions recognition <gae>` (GAE in the table): ``fr_1_gender0``, ``fr_1_age0``, ``emotion_1``
* Models used in :ref:`extraction-api <extraction-api>`: ``apricot_320``, ``fr_1_gender0``, ``fr_1_age0``, ``emotion_1``
* ``MongoDB``, ``Tarantool``: facens are stored in one gallery. If there are 2 or more galleries with facens, multiply the given RAM amount by the relevant number of galleries.


+-----------------+-----------------------------------------------------------------------------------------+
| Number of faces | RAM consumption by components, MB                                                       | 
|                 +-------------+--------------+----------+--------------------+----------------------------+   
|                 | MongoDB     | Tarantool    | nnapi    | nnapi + GAE        | extraction-api             |
+=================+=============+==============+==========+====================+============================+  
| 0 (own needs)   | ~70         | ~77          | ~265     | ~1000              | ~1GB (1 Core)/~7GB         |
+-----------------+-------------+--------------+----------+--------------------+ (8 Cores)                  |           
| 50,000          | ~181        | ~189         | ~400     | ~1400              | (up to 10,5 under load)    |
+-----------------+-------------+--------------+----------+--------------------+                            |
| 100,000         | ~294        | ~263         | ~400     | ~1400              |                            |
+-----------------+-------------+--------------+----------+--------------------+                            |
| 500,000         | ~1190       | ~1013        | ~400     | ~1400              |                            |
+-----------------+-------------+--------------+----------+--------------------+                            | 
| 1,000,000       | ~2310       | ~1943        | ~400     | ~1400              |                            |
+-----------------+-------------+--------------+----------+--------------------+----------------------------+  





Supported Images
-----------------------------

FindFace Enterprise Server SDK supports the following image formats:

* JPEG,
* PNG,
* WebP.

The maximum image size is 10 MB. The minimum distance between pupils is 40 px.


.. _video-requirements:

Video Face Detection
=================================

Video Face Detector Host
----------------------------------

A host for the :ref:`video face detection <video>` component must meet the following requirements (given that a video stream is 1 x 720p (1280×720) at 25FPS playback speed):

.. note:: 
     Requirements depend on motion activity and the number of faces in video, the video face detector settings and FindFace Enterprise Server SDK overall load. To select an optimal configuration, contact our experts by info@ntechlab.com.


+------------------------+-------------------------------------------------------------------------+
| Requirement            | Description                                                             |
+========================+=========================================================================+
| CPU                    | ≥ INTEL Core i5 6400 (2 physical core CPU). AVX support required.       |
+------------------------+-------------------------------------------------------------------------+
| RAM                    | 4 GB in the real-time mode.                                             |
+------------------------+-------------------------------------------------------------------------+
| Operating system       | Ubuntu 16.04 LTS (only x64).                                            |
+------------------------+-------------------------------------------------------------------------+


Supported Video File Formats and Codecs
-------------------------------------------------

The fkvideo_detector component supports all video file formats and codecs that can be decoded by `FFmpeg <https://www.ffmpeg.org/general.html#Supported-File-Formats_002c-Codecs-or-Features>`__. 


FindFace Web User Interface
=================================

To process video in the FindFace Enterprise Server SDK :ref:`web user interface <ffui>`, its host should meet the same requirements as for the :ref:`video face detector <video-requirements>`.


