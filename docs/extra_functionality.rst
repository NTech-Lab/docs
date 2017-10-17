.. _extra-functionality:

Extra Functionality
=============================

In addition to FindFace Server (installed on a :ref:`single <standalone>` or :ref:`several <cluster>` hosts), you can also harness advanced features provided by the following components from the :program:`<findface-repo>.deb` package:

+---------------------------------+---------------------------------------------------------------------------------------------+
| Component                       | Description                                                                                 |
+=================================+=============================================================================================+
| fkvideo_detector                | The video face detection component :ref:`fkvideo_detector <video>` extracts faces from      |
|                                 | a RTSP camera stream or a video file on-the-fly and sends them via REST API to              |
|                                 | findface-facenapi for further processing. Licensable.                                       |
+---------------------------------+---------------------------------------------------------------------------------------------+
| findface-extraction-api         | With the :ref:`findface-extraction-api <extraction-api>` component, you can flexibly        |
|                                 | configure the format of API responses to extract various face data, including the bounding  |
|                                 | box coordinates, normalized face, gender, age, and emotions, as well as the face feature    |
|                                 | vector (facen). Implementing this feature to your system can remarkably broaden the scope   |
|                                 | of analytic tasks it is capable of fulfilling. Licensable.                                  |
+---------------------------------+---------------------------------------------------------------------------------------------+
| findface-mass-enroll            | The :ref:`findface-mass-enroll <bulk-face>` component allows for enrolling faces to         |
|                                 | findface-facenapi from images in bulk.                                                      |          
+---------------------------------+---------------------------------------------------------------------------------------------+
| findface-ui                     | A :ref:`web user interface <ffui>` which generally duplicates the functionality available   |
|                                 | via REST API. To be installed on the findface-facenapi host.                                |
+---------------------------------+---------------------------------------------------------------------------------------------+
| findface-tarantool-build-index  | The :ref:`findface-tarantool-build-index <fast-index>` component creates a fast index for   |
|                                 | galleries with the number of faces over 1,000,000.                                          |        
+---------------------------------+---------------------------------------------------------------------------------------------+


