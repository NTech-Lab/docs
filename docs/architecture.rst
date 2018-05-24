.. _architecture:

*************************************
Choose Deployment Architecture
*************************************

FindFace Enterprise Server SDK is delivered in the following distributable packages:

 * A package with components :program:`<findface-repo>.deb`.
 * Several packages with neural network models :program:`<findface-data>.deb`. Each model is delivered in a separate package.
      
     
Depending on your system characteristics and performance requirements, there are 2 FindFace Enterprise Server SDK deployments:

+----------------+---------------------------------------------------------------------------------------------------------------------------------+
| Deployment     | Recommendation                                                                                                                  |
+================+=================================================================================================================================+
| Standalone     | You can deploy FindFace Enterprise Server SDK and neural network models on a single host (standalone)                           |
|                | if the number of faces in the database does not exceed some 1,000,000. This variant makes it easier to                          | 
|                | start deployment and cater to basic requirements of your applications.                                                          | 
|                | Standalone deployment can be done :ref:`step-by-step <install-server>`, from a :ref:`developer-friendly installer <installer>`, | 
|                | or as a fully pre-configured :ref:`virtual machine image <vm>`.                                                                 |
+----------------+---------------------------------------------------------------------------------------------------------------------------------+
| Cluster        | If the number of faces in the database does exceed 1,000,000, deploy FindFace Enterprise Server SDK                             |
|                | in a cluster environment and configure fast index search. In this case, FindFace Enterprise Server SDK                          |
|                | components will be distributed across several hosts. This is a medium and large deployment which can be scaled almost           |
|                | infinitely. It will also suit professional high load projects with severe requirements to performance.                          |
|                | Cluster deployment can be only done :ref:`step-by-step <install-server>`.                                                       |   
+----------------+---------------------------------------------------------------------------------------------------------------------------------+


The FindFace Enterprise Server SDK basic configuration (FindFace Server) includes the following components:

.. csv-table::
   :header: "Component", "Description"
   :widths: 15 40
   :file: _tables/components.csv
   :encoding: UTF-8
   :delim: ;

In addition to FindFace Server, you can also harness advanced features provided by the following components from the :program:`<findface-repo>.deb` package:

+---------------------------------+---------------------------------------------------------------------------------------------+
| Component                       | Description                                                                                 |
+=================================+=============================================================================================+
| fkvideo_detector                | The video face detection component :ref:`fkvideo_detector <video>` extracts faces from      |
|                                 | a RTSP camera stream or a video file on-the-fly and sends them via REST API to              |
|                                 | findface-facenapi for further processing. Licensable.                                       |
+---------------------------------+---------------------------------------------------------------------------------------------+
| findface-extraction-api         | By default, the :ref:`findface-extraction-api <architecture>` component is used as an       |
|                                 | extractor of the face feature vector.                                                       |
|                                 | The component also provides several :ref:`advanced features <extraction-api>`, for example, |
|                                 | flexible configuration of the API response format. Use this feature to extract various      |
|                                 | face data, including the bounding box coordinates, normalized face, gender, age, and        |
|                                 | emotions. Implementing this feature to your system can remarkably broaden the scope         |
|                                 | of analytic tasks it is capable of fulfilling. Licensable.                                  |
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

A typical FindFace Enterprise Server SDK architecture is shown in the diagram below.

|deploy_en|

.. |deploy_en| image:: /_static/deploy_en.png

.. |deploy_ru| image:: /_static/deploy_ru.png

