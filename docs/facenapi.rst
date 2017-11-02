.. _install-facenapi:

Install facenapi
^^^^^^^^^^^^^^^^^^^^

Install and configure the ``findface-facenapi`` component as follows:


#. Install the component.
   
   .. code::

      $ sudo apt-get update
      $ sudo apt-get install python3-facenapi

#. If MongoDB is installed on a remote host, specify its IP address in the findface-facenapi configuration file.
    
   .. code::
       
      ## Open the configuration file.
      $ sudo vi /etc/findface-facenapi.ini

      ## Specify the MongoDB host IP address.
      mongo_host = '192.168.113.1'

#. Check if the component is runnable. To do so, invoke the ``findface-facenapi`` application by executing the command below. As the application is invoked, hold 1 minute, and if no errors display, hit Ctrl+C.
     
   .. code::
       
      ## If MongoDB is installed on the same host
      $ findface-facenapi

      ## If MongoDB is installed on a remote host
      $ sudo findface-facenapi --config=/etc/findface-facenapi.ini

#. Check if the ``findface-facenapi`` service autostart at system startup is enabled.
      
   .. code::
       
      $ systemctl list-unit-files | grep findface-facenapi

      ## You should see the following output
      findface-facenapi.service disabled

#. Enable the service autostart and launch the service.
    
   .. code::
      
      $ sudo systemctl enable findface-facenapi.service && sudo service findface-facenapi start

#. Make sure that the service is up and running.
    
   .. code::
       
      $ sudo service findface-facenapi status

      ## The command will return a service description, a status (should be Active), path and running time. 

.. tip::
    You can view the findface-facenapi :ref:`logs <logs>` by executing:
         
    .. code::
            
       $ sudo tail -f /var/log/syslog | grep facenapi


