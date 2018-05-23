.. _plugins:


Plugins
========================

Plugins can interact with FindFace Enterprise Server SDK on the following levels:

#. Direct access to the ``findface-facenapi`` context. This is the basic level of interaction which allows you to directly access the database, extractors, decoders and detectors.

   .. tip::
      See :ref:`plugins-about` and :ref:`plugin-methods` for the full reference.

#. Through HTTP API handlers implemented to the FindFace API Environment in addition to the embedded :ref:`HTTP API <api>`. 
   
   You can write your own HTTP API handler or inherit from the following ready-to-use ones:

   * ``facenapi.core.http.base_handler.BaseHandler`` implements the FindFace Web Interface (without Video Processing)
   * ``facenapi.core.http.base_handler.BaseVideoHandler`` implements Video Processing

   .. tip::
      See :ref:`exemplary-plugins` for examples.

   .. note::
      Both ``BaseHandler`` and ``BaseVideoHandler`` provide token-based authentication.

.. toctree::
   :maxdepth: 1
   :caption: In this section:

   plugins_about
   plugin_methods
   start_plugin
   exemplary_plugins
   embed_plugin

  

