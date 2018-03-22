.. _extapi:

Install extraction-api
"""""""""""""""""""""""""

Install and configure the ``findface-extraction-api`` component as follows:


.. note::
   The ``extraction-api`` component requires the packages with :ref:`models <models>` :program:`<findface-data>.deb`. Make sure they have been installed.



#. Install the component.

   .. code::

       sudo apt-get update
       sudo apt-get install findface-extraction-api

#. Open the ``findface-extraction-api.ini`` configuration file.

   .. code::

       sudo vi /etc/findface-extraction-api.ini

#. If :ref:`NTLS <licensing>` is remote, specify its IP address. 

   .. code::

       license_ntls_server: 192.168.113.2:3133

#. The ``model_instances`` parameter indicates how many ``extraction-api`` instances are used. Specify the number of instances that you purchased. The default value (0) means that this number is equal to the number of CPU cores. 

   .. note::
      This parameter severely affects RAM consumption. 

   .. code::

       model_instances: 2

#. Enable the ``Extraction API`` service autostart and launch the service.

   .. code::

      sudo systemctl enable findface-extraction-api && sudo systemctl start findface-extraction-api

#. Make sure that the service is up and running. The command will return a service description, a status (should be Active), path and running time.

   .. code::

      sudo service findface-extraction-api status

 
.. tip::
    You can view the ``extraction-api`` :ref:`logs <logs>` by executing:

    .. code::

       sudo tail -f /var/log/syslog | grep extraction-api

