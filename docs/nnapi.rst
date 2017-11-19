Install nnapi
^^^^^^^^^^^^^^^^^^

Install and configure the ``findface-nnapi`` component as follows:

.. tip:: 
     You may also want to learn about :ref:`gender, age and emotions recognition <gae>`.

#. Install the component.

   .. code::

      sudo apt-get update
      sudo apt-get install findface-nnapi

#. If :ref:`NTLS <licensing>` is installed on a remote host, specify its IP address in the ``findface-nnapi`` configuration file.

   .. code::

      sudo vi /etc/findface-nnapi.ini

      license_ntls_server = 192.168.113.2:3133

#. Check if the component is runnable. To do so, invoke the ``findface-nnapi`` application by executing the command below. As the application is invoked, hold 1 minute, and if no errors display, hit :kbd:`Ctrl+C`.

   .. code::

      findface-nnapi

#. Check if the ``findface-nnapi`` service autostart at system startup is disabled.

   .. code::

      systemctl list-unit-files | grep findface-nnapi

#. Enable the service autostart and launch the service.

   .. code::

      sudo systemctl enable findface-nnapi.service && sudo service findface-nnapi start

#. Make sure that the service is up and running. The command will return a service description, a status (should be Active), path and running time.

   .. code::

      sudo service findface-nnapi status

 
.. tip::
    You can view the ``findface-nnapi`` :ref:`logs <logs>` by executing:

    .. code::

       sudo tail -f /var/log/syslog | grep nnapi


