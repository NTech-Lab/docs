.. _start:

****************
Get Started
****************

A typical FindFace Enterprise Server SDK-based biometric system is shown on the diagram below:

.. image:: https://gcc-elb-public-prod.gliffy.net/embed/image/4090da7b962be0327d893afdcd000b54.png

FindFace Enterprise Server SDK consists of the Biometric Data Analysis and Recognition Server (FindFace Server or Server hereinafter) and, optionally, the video face detector. Besides the latter, you can also install the other :ref:`additional components <extra-functionality>`. The FindFace Server functioning is provided by interaction of the following components: 


+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Service                                  | Description                                                                                                                                                                                               |
+==========================================+===========================================================================================================================================================================================================+
| findface-facenapi                        | Python daemon which runs HTTP API. This daemon executes face detection functions, interfaces with MongoDB and findface-nnapi and tarantool@FindFace daemons.                                              |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| tntapi (tarantool@FindFace as a shard)   | Daemon which enables interaction with the face descriptors index.                                                                                                                                         |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| findface-nnapi                           | Daemon extracts a feature vector (based on neural network). Requires the package with models <findface-data>.deb.                                                                                         |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| MongoDB                                  | Database which stores faces metadata, galleries details, settings, etc.                                                                                                                                   |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| findface-upload                          | Nginx web server used to receive images using WebDAV.                                                                                                                                                     |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| NTLS                                     | Local license server which interfaces with the Global NTechLab License Server (for the network licensing) or a USB dongle (for the on-premise licensing) and passes a license to licensable components.   |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Follow the **9 steps** below to start delivering face recognition services to your customers:

#. :ref:`Choose deployment architecture <architecture>`
#. :ref:`Prepare hardware <requirements>`
#. :ref:`Install prerequisites <prerequisites>`
#. :ref:`Install FindFace Server <install-server>`
#. :ref:`Create a token <token>` and :ref:`test the system work <test>`
#. :ref:`Configure video face detection <video>`
#. Increase performance by setting up :ref:`nginx load balancing <load-balancing>` and :ref:`fast index <fast-index>`
#. :ref:`Add advanced features <advanced>`
#. :ref:`Finalize the system with coding <api>`
