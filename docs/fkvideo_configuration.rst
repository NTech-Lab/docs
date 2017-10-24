.. _fkvideo-config:

Configuration Parameters
=============================

You can configure fkvideo_detector by using command line arguments or a configuration file. 

.. include:: /_inclusions/fkvideo_config_warning.rst

.. contents:: In this section:

Command Line Arguments
---------------------------

Usage:

.. code::

   $ fkvideo_detector [options]

.. rubric:: Allowed options:

.. warning::
    The following parameters are mandatory: ``api-host``, ``api-port``, ``api-token``, ``--license-ntls-server``.


.. csv-table::
   :header: "Option", "Description", "Argument", "Example"
   :file: _tables/fkvideo.csv
   :encoding: UTF-8
   :delim: ;


Configuration File Format
--------------------------------
   
.. code::

    [General]
    | long-arg=option ; long-arg from command line arguments
    | ...



