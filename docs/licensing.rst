.. _licensing:

Licensing
^^^^^^^^^^^^^^^^^^^^^^^

You receive a license file from your NTechLab manager along with the FindFace Enterprise Server SDK distributable packages. If you opt for on-premise licensing, we will also send you a Guardant USB dongle. The licensing scheme for FindFace Enterprise Server SDK is shown on the diagram below.

|licensing_en|

.. |licensing_en| image:: https://gcc-elb-public-prod.gliffy.net/embed/image/8a534e69c2f181422ef0c298f11b1fcb.png

.. |licensing_ru| image:: https://gcc-elb-public-prod.gliffy.net/embed/image/2c3603daa6273196be48334e448dde5a.png


To provide the FindFace Enterprise Server SDK licensing, follow the steps below:

#. Install and configure the local license server :program:`NTLS`.
#. If the licensable components (``findface-nnapi``, ``tntapi``, ``fkvideo_detector``, ``extraction-api``) are installed on remote hosts, specify the NTLS host IP address in their configuration files.

To install and configure NTLS, do the following:

#. Install the NTLS component::

    sudo apt-get update
    sudo apt-get install ntls

   .. tip::
       In the NTLS configuration file, you can change the license folder and specify your proxy server IP address if necessary. You can also change the NTLS web interface remote access settings. To open the NTLS configuration file, execute::

          sudo vi /etc/ntls.cfg

       If necessary, change the license folder in the ``license-dir`` parameter. By default, license files are stored at ``/ntech/license``::
 
          license-dir = /ntech/license

       If necessary, uncomment the ``proxy`` line and specify your proxy server IP address::

          proxy = http://192.168.1.1:12345

       By default, you can access the NTLS web interface from any remote host (``ui = 0.0.0.0:3185``). To indicate that accessing the NTLS web interface must originate from a specific IP address, edit the ``ui`` parameter::

          ui = 127.0.0.1:3185
		
#. Enable the NTLS service autostart and launch the service::

      sudo systemctl enable ntls && sudo systemctl start ntls

#. Upload the license file via the NTLS web interface ``http://<NTLS_IP_address>:3185/#/``. You can also use the NTLS web interface to consult your license information, and upgrade or extend the license.

    .. image: license_info.png

#. For on-premise licensing, insert the Guardant dongle into a USB port.

.. important::
    If the licensable components (``findface-nnapi``, ``tntapi``, ``fkvideo_detector``, ``extraction-api``) are to be installed on remote hosts, keep in mind that you have to specify the IP address of the NTLS host in their configuration files after installation.

.. seealso::
    
    :ref:`troubleshoot-ntls`
