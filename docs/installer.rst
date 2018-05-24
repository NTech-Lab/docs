.. _installer:

Install from Console Installer
---------------------------------------------------------------------

To install FindFace Enterprise Server SDK in a standalone configuration, you can use a developer-friendly console installer.

.. warning::
     The installer cannot be used to update FindFace Enterprise Server SDK from version 2.3 or earlier.

.. seealso::
   
   * :ref:`install-server`
   * :ref:`vm`

Do the following:

#. Download the installer file ``<findface-server-xxx>.run``.
#. Put the ``.run`` file into some directory on the designated host (for example, `/home/username`).
#. From this directory, make the ``.run`` file executable.

   .. code::

       chmod +x <findface-server-xxx>.run

#. Execute the ``.run`` file.

   .. include:: _inclusions/ntech_user_warning.rst

   .. code::

       sudo ./<findface-server-xxx>.run

   The installer will perform several automated checks to ensure that the host meets the system requirements. After that, the FindFace Enterprise Server SDK components will be automatically installed, configured and/or started in the following configuration:

   +--------------------------+------------------------------------------------------------------------------------------------------+
   | Component                | Details                                                                                              |
   +==========================+======================================================================================================+
   | findface-facenapi        | Installed and started with enabled and configured :ref:`dynamic person creation <persons>` and       |
   |                          | :ref:`“friend or foe” identification <friend>`.                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-server-tarantool| Installed and started with the number of tntapi shards: ``N = min(cores, RAM/2Gb)/2``                |
   | (tntapi)                 |                                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-tarantool-      | Installed. Before use, consult the :ref:`component documentation <fast-index>`.                      |
   | build-index 	      |                                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | ffupload                 | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | fkvideo_detector 	      | Only installed. Use the command line or FindFace Web UI to manually start it. Before use,            |
   |                          | consult the :ref:`component documentation <video>`.                                                  |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-extraction-api  | Installed and started as a face detector and facen extractor. Consult                                |
   |                          | the :ref:`component documentation <extraction-api>` for advanced features.                           |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | NTLS 	              | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | FindFace Web UI          | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+  
   | findface-mass-enroll     | Only installed. Use the command line to work with it. Before use,                                    |
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

#. Upload the FindFace Enterprise Server SDK license file via the NTLS web interface ``http://<Host_IP_address>:3185/#/``. To access the NTLS web interface, use the credentials provided in the console. 

   .. note::
      The host IP address is shown in the links to FindFace web services in the following way: as an external IP address if the host belongs to a network, or ``127.0.0.1`` otherwise.


