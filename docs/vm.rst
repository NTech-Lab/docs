.. _vm:

Install as Pre-Configured Virtual Machine
------------------------------------------------------

You can deploy FindFace Enterprise Server SDK as a fully pre-configured ready-to-use virtual machine image that you can run inside a virtualization environment in any operating system. This type of installation is the simplest and requires minimum skills.

.. important::
   This type of installation is suitable only for the :ref:`standalone deployment <standalone>`.

.. warning::
   For highload projects, installation as a virtual machine is not recommended even in test mode.

.. seealso::
   
   * :ref:`install-server`
   * :ref:`installer`

.. important::
   We officially support only :program:`VMware` as a virtualization environment. Install it prior to proceeding with this instruction.  

.. tip::
   Contact your NtechLab manager by info@ntechlab.com to request the virtual machine image. You will be provided with files ``ffserver-*.ovf`` and ``disk-*.vmdk`` (discrete or in an archive).

The virtual machine image has the following software pre-installed:

* Ubuntu Server 16.04 LTS x64 with no graphical user interface
* FindFace Enterprise Server SDK in the following configuration:

   +--------------------------+------------------------------------------------------------------------------------------------------+
   | Component                | Details                                                                                              |
   +==========================+======================================================================================================+
   | findface-facenapi        | Installed and started with enabled and configured :ref:`dynamic person creation <persons>` and       |
   |                          | :ref:`“friend or foe” identification <friend>`.                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-nnapi           | Installed and started (1 instance) with enabled and configured                                       |
   |                          | :ref:`gender, age and emotions recognition <gae>`. :ref:`Load balancing <load-balancing>` may be     |
   |                          | required.                                                                                            |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-server-tarantool| Installed and started (1 shard).                                                                     |
   | (tntapi)                 | :ref:`Sharding <tntapi-sharding>` may be required.                                                   |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | findface-tarantool-build-| Installed. Before use, consult the :ref:`component documentation <fast-index>`.                      |
   | index       	      |                                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | ffupload                 | Installed and started.                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | fkvideo_detector 	      | Only installed. Use the command line or FindFace Web UI to manually start it. Before use,            |
   |                          | consult the :ref:`component documentation <video>`.                                                  |
   +--------------------------+------------------------------------------------------------------------------------------------------+
   | Extraction API 	      | Only installed. Exclusively for experienced users. Before use, be sure to consult                    |
   |                          | the :ref:`component documentation <extraction-api>`.                                                 |
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
 

To deploy FindFace Enterprise Server SDK as a virtual machine, do the following:

#. Put the ``ffserver-*.ovf`` and ``disk-*.vmdk`` virtual machine files into the same directory.
#. Start the virtualization environment. Click :guilabel:`Open a Virtual Machine` and select the ``ffserver-*.ovf`` file. If prompted, convert the file to a VMware format. This may take a while.
#. After the virtual machine is imported into the virtualization environment, navigate to the virtual machine hardware settings: :menuselection:`Edit virtual machine settings --> Hardware`.

   .. tip::
      Refer to the VMware `official documentation <https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-E2668921-F40D-4CED-BA1B-FE4DC497D910.html>`__.

   * Choose the `network connection type <https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-0CE1AE01-7E79-41BB-9EA8-4F839BE40E1A.html>`__, given the host networking.  
   * By default, the virtual machine hardware is already configured in the way that ensures optimal performance in most medium-load systems. Make sure it meets your project requirements as well. If you are going to simultaneously process several video streams, or maintain a large dataset, you may need to allocate additional resources to the virtual machine RAM and increase the number of CPU cores. Be sure to save the settings.

     .. important::
        You may also need to set up ``tntapi`` :ref:`sharding <tntapi-sharding>` and ``findface-nnapi`` :ref:`load balancing <load-balancing>` later on the virtual machine console.

#. Power on the virtual machine. Wait until Ubuntu is finished starting.
#. To log in, enter the following credentials: login ``user``, password ``ntechlab``.
#. Find out the primary network interface IP address of the virtual machine (``192.168.112.144`` in the case study).

   .. code::

      ifconfig 
      
      ens33 Link encap:Ethernet HWaddr 00:0c:29:8f:db:d5 
      inet addr:192.168.112.144 Bcast:192.168.112.255 Mask:255.255.255.0
      inet6 addr: fe80::20c:29ff:fe8f:dbd5/64 Scope:Link
      UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
      RX packets:37751 errors:0 dropped:0 overruns:0 frame:0
      TX packets:36205 errors:0 dropped:0 overruns:0 carrier:0
      collisions:0 txqueuelen:1000 
      RX bytes:5621377 (5.6 MB) TX bytes:39193951 (39.1 MB)

      lo Link encap:Local Loopback 
      inet addr:127.0.0.1 Mask:255.0.0.0
      inet6 addr: ::1/128 Scope:Host
      UP LOOPBACK RUNNING MTU:65536 Metric:1
      RX packets:152521 errors:0 dropped:0 overruns:0 frame:0
      TX packets:152521 errors:0 dropped:0 overruns:0 carrier:0
      collisions:0 txqueuelen:1000 
      RX bytes:24549909 (24.5 MB) TX bytes:24549909 (24.5 MB)

#. Assign the primary network interface IP address to the ``ffupload_url`` parameter in the ``findface-facenapi`` configuration file.

   .. code::      
   
      sudo vi /etc/findface-facenapi.ini

      ffupload_url = 'http://192.168.112.144:3333'

   .. warning::
       The ``findface-facenapi.ini`` content must be correct Python code.

#. Restart all the FindFace Enterprise Server SDK services.

   .. code::

      sudo service 'findface*' restart     

#. Make the virtual machine IP address static. To do so, open the ``etc/network/interfaces`` file and modify the current primary network interface entry as shown in the case study below. Be sure to substitute the suggested addresses with the actual ones, subject to your network specification.

   .. important::
      Be sure to edit the ``etc/network/interfaces`` file with extreme care. Please refer to the Ubuntu `guide on networking <https://help.ubuntu.com/lts/serverguide/network-configuration.html#ip-addressing>`__ before proceeding. 

   .. code::

      sudo vi /etc/network/interfaces

      # The primary network interface
      iface eth0 inet static
      address 192.168.112.144
      netmask 255.255.255.0
      gateway 192.168.112.254 
      dns-nameservers 192.168.112.254

#. Restart networking.

   .. code::
 
      sudo service networking restart

#. Upload the FindFace Enterprise Server SDK license file via the local license server web interface at ``http://<IP_address>:3185/#/`` (``http://192.168.112.144:3185/#/`` in our example).
#. Create an :ref:`authentication token <token>`. Use it to access the :ref:`FindFace Web Interface <ffui>` at ``http://<IP_address>:8000/``.
       
