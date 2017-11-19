.. _install-facenapi:

Install facenapi
^^^^^^^^^^^^^^^^^^^^

Install and configure the ``findface-facenapi`` component as follows:


#. Install the component.
   
   .. code::

      sudo apt-get update
      sudo apt-get install python3-facenapi

#. If MongoDB is installed on a remote host, specify its IP address in the ``findface-facenapi`` configuration file. 
    
   .. code::
      
      sudo vi /etc/findface-facenapi.ini

      mongo_host = '192.168.113.1'

#. Check if the component is runnable. To do so, invoke the ``findface-facenapi`` application by executing the command below. As the application is invoked, hold 1 minute, and if no errors display, hit :kbd:`Ctrl+C`.
 
   If MongoDB is installed on the same host, execute:
    
   .. code::
       
      findface-facenapi

   If MongoDB is installed on a remote host, execute::

      sudo findface-facenapi --config=/etc/findface-facenapi.ini

#. Check if the ``findface-facenapi`` service autostart at system startup is disabled.
      
   .. code::
       
      systemctl list-unit-files | grep findface-facenapi

#. Enable the service autostart and launch the service.
    
   .. code::
      
      sudo systemctl enable findface-facenapi.service && sudo service findface-facenapi start

#. Make sure that the service is up and running. The command will return a service description, a status (should be Active), path and running time.
    
   .. code::
       
      sudo service findface-facenapi status


.. tip::
    You can view the ``findface-facenapi`` :ref:`logs <logs>` by executing:
         
    .. code::
            
       sudo tail -f /var/log/syslog | grep facenapi


