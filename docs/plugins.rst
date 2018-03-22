.. _plugins:

Extend Functionality with Plugins
========================================================

By default, the ``findface-facenapi`` component follows a predefined set of behaviour traits. That implies certain limitations on its functionality. Using plugins can significantly extend the scope of tasks that ``findface-facenapi`` is capable of fulfilling. 

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

The following case studies will help you write your first ``findface-facenapi`` plugin:

* The :download:`html-demo-report.py <_scripts/html-report-demo.py>` plugin identifies faces detected in video by the ``fkvideo_detector`` component and saves the identification results to a static HTML file.

  .. note::
     By default, faces detected in video are added to a database without identification. In order to identify them, :ref:`assign <fkvideo-config>` ``v1/identify`` to the ``request-url`` parameter of ``fkvideo_detector``.

* The :download:`websocket-demo-plugin <_scripts/websocket-demo-plugin.py>` plugin identifies faces and sends the identification results to a websocket.

First and foremost, when writing a plugin, you will have to work with the ``face`` and ``person`` objects in ``facenapi.server.models``/``facenapi.core.models``. Once the plugin is ready, implement it to ``findface-facenapi``.
   

Implement Plugin to ``findface-facenapi``
------------------------------------------

To implement a plugin to ``findface-facenapi``, do the following:

#. Put a plugin into a directory of your choice. You can use several directories to store plugins.
#. Open the ``findface-facenapi`` configuration file.

   .. code::

      sudo vi /etc/findface-facenapi.ini

   .. warning::
      The ``findface-facenapi.ini`` content must be correct Python code.


#. Uncomment the ``plugins_dirs`` parameter and specify the comma-separated list of plugin directories. 

   .. code::

      plugins_dirs                   = '/etc/findface/plugins/video, /etc/findface/plugins/html'

#. Uncomment the ``plugins_enabled`` parameter and specify the comma-separated list of plugins to load, or an asterisk (*) to load all plugins. 
      
   .. code::

      plugins_enabled                = '*'


