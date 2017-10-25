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
    :ref:`Standalone installation <standalone>` of FindFace Enterprise Server SDK is recommended when the number of faces in the database **does not** exceed some 1,000,000. Otherwise you should install Findface Enterprise Server SDK in a :ref:`cluster environment <cluster>` and configure :ref:`fast index <fast-index>` search.

+--------------------+-----------------------------------------------------------------------------+
| Requirement        | Description                                                                 |
+====================+=============================================================================+
| CPU                | x86-64 CPU (Intel), >2.0 Ghz, >2 cores.                                     |
|                    | The CPU AVX support is required for operation of all the components,        |
|                    | except findface-upload.                                                     |
+--------------------+-----------------------------------------------------------------------------+
| RAM                | 2GB plus extra 1.5GB for each 1M faces in datasets.                         |
|                    | Additional 2 GB for :ref:`gender, age and emotions recognition <gae>`.      |
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
     Requirements depend on motion activity and the number of faces in video, the video face detector settings and FindFace Enterprise Server SDK overall load. To select an optimal configuration, contact NTechLab experts by email info@ntechlab.com.


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

The fkvideo_detector component supports all video file formats and codecs supported by the `FFmpeg framework <https://www.ffmpeg.org/general.html#Supported-File-Formats_002c-Codecs-or-Features>`__. 


FindFace Web User Interface
=================================

To process video in the FindFace Enterprise Server SDK :ref:`web user interface <ffui>`, its host should meet the same requirements as for the :ref:`video face detector <video-requirements>`.


