.. _standalone:

Standalone Architecture
============================

FindFace Enterprise Server SDK components and neural network models can be deployed on a single host (standalone) making it easier to start deployment and cater to basic requirements of your applications. A typical standalone installation of FindFace Server is shown on the diagram below.

.. tip::
    In addition to FindFace Server, you can also harness the :ref:`advanced features <extra-functionality>`.
    
.. note::
    Standalone installation can be done :ref:`step-by-step <install-server>` or from a :ref:`developer-friendly installer <installer>`.

.. image:: https://gcc-elb-public-prod.gliffy.net/embed/image/d29cc2fb68ce86a4c70f6ea16b57b281.png


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

