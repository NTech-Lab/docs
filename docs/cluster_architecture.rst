.. _cluster:

Cluster Architecture
==========================

To meet high load requirements of your application, FindFace Enterprise Server SDK enables distributed installation of components in a cluster environment enhanced with Tarantool. The following diagram shows the typical network topology of FindFace Server:

.. tip::
     In addition to FindFace Server, you can also harness the :ref:`advanced features <extra-functionality>`.

.. image:: https://gcc-elb-public-prod.gliffy.net/embed/image/228618a7cabd81d070fa9ba4b4a6965c.png


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
| NTLS                                     | Local license server which interfaces with the Global NTechLab License Server (for the network licensing) or a USB dongle (for the on-premise licensing) and passes a license to licensable components.   |
+------------------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

