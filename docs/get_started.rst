.. _start:

****************
Get Started
****************

A typical FindFace Enterprise Server SDK-based biometric system is shown on the diagram below:

.. image:: https://gcc-elb-public-prod.gliffy.net/embed/image/4090da7b962be0327d893afdcd000b54.png

FindFace Enterprise Server SDK consists of the :program:`Biometric Data Analysis and Recognition Server` (:program:`FindFace Server` or :program:`Server` hereinafter) and, optionally, the video face detector and other :ref:`additional components <extra-functionality>`. 

The FindFace Server functioning is provided by interaction of the following components: 


.. csv-table::
   :header: "Service", "Description"
   :file: _tables/components.csv
   :encoding: UTF-8
   :delim: ;


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
