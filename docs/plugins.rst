.. _plugins:

Extend Functionality with Plugins
========================================================

By default, the ``findface-facenapi`` component follows a predefined set of behaviour traits. That implies certain limitations on its functionality. Using plugins can significantly extend the scope of tasks ``findface-facenapi`` is capable of fulfilling. 

Here are just few examples of how you can implement the plugins to your system: 

.. note::
   To write a plugin, you require good command of the Python programming language.

* By default, the ``fkvideo_detector`` component does not process the ``findface-facenapi`` responses to face identification and camera operation API requests. You can use a plugin as a proxy script that will manage communication between ``fkvideo_detector`` and ``findface-facenapi`` and redirect API responses to an application that can process and render them.
* Use plugins to send the facial recognition results to a websocket or save them to a file.

.. rubric:: In this section:

.. contents::
   :local:


.. _write-plugin:

Write Plugin
-----------------------------

The following use cases will help you write your first ``findface-facenapi`` plugin:

* The :download:`html-demo-report.py <_scripts/html-report-demo.py>` plugin identifies faces detected in video by the ``fkvideo_detector`` component and saves the identification results to a static HTML file.
* The :download:`websocket-demo-plugin <_scripts/websocket-demo-plugin.py>` plugin identifies faces and sends the identification results to a websocket.

First and foremost, you will have to work with the ``face`` and ``person`` objects in ``facenapi.server.models``/``facenapi.core.models`` when writing a plugin. Once the plugin is ready, implement it to ``findface-facenapi``.
   

Implement Plugin to ``findface-facenapi``
------------------------------------------

To add a plugin to ``findface-facenapi``, do the following:

#. Open the ``findface-facenapi`` configuration file.

   .. code::

      sudo vi /etc/findface-facenapi.ini

   .. warning::
      The ``findface-facenapi.ini`` content must be correct Python code.


#. Uncomment the ``plugins_dirs`` parameter and specify the comma-separated list of directories with plugins. 

   .. code::

      plugins_dirs                   = '/etc/plugins, /etc/findface/plugins'

#. Uncomment the ``plugins_enabled`` parameter and specify the comma-separated list of plugins to load or an asterisk (*) to load all plugins. 
      
   .. code::

      plugins_enabled                = '*'


