.. _installer:

Standalone Installer
======================================================================

To install FindFace Enterprise Server SDK in a standalone configuration, you can use the :program:`<findface-server-xxx>.run` file. Do the following:

.. warning::
     The .run file cannot be used for FindFace Enterprise Server SDK update from version 2.3 or earlier.

#. Put the .run file into some directory on the designated host (for example, `/home/username`).

#. From this directory, make the .run file executable.

   .. code::

       $ sudo chmod +x <findface-server-xxx>.run

#. Execute the .run file.

   .. include:: _inclusions/ntech_user_warning.rst

   .. code::

       $ sudo ./<findface-server-xxx>.run

   The installer will perform several automated checks to ensure that the host meets the system requirements. After that, FindFace Enterprise Server SDK components will be automatically installed, configured and/or started in the following configuration:

   +--------------------------+------------------------------------------------------------------------------------------------------+
   | Component                | Details                                                                                              |
   +==========================+======================================================================================================+
   | findface-facenapi        | Installed and started with enabled and configured dynamic person creation and “friend or foe”        |
   |                          | identification.                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-nnapi           | Installed and started with the number of instances N = min(cores, RAM/2Gb)/2 and                     |
   |                          | enabled and configured gender, age and emotions recognition.                                         |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-server-tarantool| Installed and started with the number of tntapi shards: N = min(cores, RAM/2Gb)/2                    |
   | (tntapi)                 |                                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-tarantool-      | Installed. Before use, consult the :ref:`component documentation <fast-index>`.                      |
   | build-index 	      |                                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | ffupload                 | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | fkvideo_detector 	      | Only installed. Use the command line interface or FindFace Web UI to manually start it. Before use,  |
   |                          | consult the :ref:`component documentation <video>`.                                                  |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | Extraction API 	      | Only installed. Exclusively for experienced users. Before use, be sure to consult                    |
   |                          | the :ref:`component documentation <extraction-api>`.                                                 |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | NTLS 	              | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | FindFace Web UI          | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+  
   | findface-mass-enroll     | Only installed. Use the command line interface to work with it. Before use,                          |
   |                          | consult the :ref:`component documentation <bulk-face>`.                                              |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | nginx                    | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | MongoDB                  | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | Tarantool Database       | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | jq 	              | Installed. Used to pretty-print API responses from FindFace Server.                                  |
   +--------------------------+------------------------------------------------------------------------------------------------------+
 
#. Once the installation is complete, the following output will be shown in the console:

   .. tip::
       Be sure to save this data: you will need it later.

   .. code::

       ###############################################
       #          Installation is complete           #
       ###############################################
       - upload your license to http://172.16.213.249:3185/
         login:          admin
         password:       fZh9-zZDX
       - user interface: http://172.16.213.249:8000/
       - token for UI:   fZh9-zZDX
       - documentation:  http://172.16.213.249:8000/v1/docs/v1/overview.html
       Should you forget your password, recover it by executing
         findface-facenapi.token
        user@ubuntu:~$

#. Upload a license file via the NTLS web interface ``http://<Host_IP_address>:3185/#/``. To access the NTLS web interface, use the credentials provided in the console. 

   .. note::
       Depending on whether the host belongs to a network, the host IP address in the links to FindFace web services is provided either as ``127.0.0.1``, or ``IP address in the network``.

