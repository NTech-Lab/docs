.. _embed:


Implement Plugin to ``findface-facenapi``
================================================

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






