Configure Network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After you install the FindFace Server components, configure their interaction with each other. Do the following:

#. Open the ``findface-facenapi.ini`` configuration file:: 

     sudo vi /etc/findface-facenapi.ini

#. Uncomment and/or edit the settings to align with your network specifications, substituting the suggested values with actual location::
  
     ffupload_url = 'http://127.0.0.1:3333'
     mongo_host = '127.0.0.1'
     extraction_api_url = 'http://127.0.0.1:18088'
     tntapi_servers_file = '/etc/tntapi.json'


   .. warning::
       The ``findface-facenapi.ini`` content must be correct Python code.
   
   .. note::
       Do not specify ``ffupload_url`` if the ``findface-upload`` component is not installed. 

#. By default, if one or several tntapi shards are out of service during face identification, :program:`findface-facenapi` returns an error. If necessary, uncomment the ``tntapi_ignore_search_error`` parameter and assign it ``True``. In this case ``findface-facenapi`` will use available ``tntapi`` shards to obtain face identification results, indicating the number of available servers vs the total number of servers in the response::
      
     tntapi_ignore_search_errors = True

#. Restart all the FindFace Enterprise Server SDK services and nginx (for ``findface-upload``) on the relevant host(s).

   .. code::

      sudo service 'findface*' restart
      sudo service nginx restart

#. Check the services status. The command will return the services description, status (should be Active), path and running time.

   .. code:: 

      sudo service 'findface*' status
      sudo service nginx status



