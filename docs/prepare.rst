.. _prepare:

Prepare Packages for Installation
-----------------------------------------

FindFace Enterprise Server SDK can be installed from a local repository. You can receive the FindFace Enterprise Server SDK distributable packages from your NTechLab manager. To prepare the packages for installation, do the following:

.. include:: _inclusions/ntech_user_warning.rst

#. Unpack the package with components on each designated host.

   .. code::

      $ sudo dpkg -i <findface_repo>.deb 

#. Unpack the package with models. In the cluster environment, models are installed only on the **findface-nnapi** hosts.

   .. code::

      $ sudo dpkg -i <findface_data>.deb 

#. Add a signature key on each designated host.

   .. code::

      $ sudo apt-key add /var/findface-repo/public.key

