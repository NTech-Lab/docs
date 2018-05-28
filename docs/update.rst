.. _update:

Update to The Latest Version
=================================================

.. rubric:: In this section:

.. contents::
   :local:


Update with Data Preservation
---------------------------------------

To update FindFace Enterprise Server SDK to the latest version while maintaining face data, do the following:

#. Stop all the FindFace Enterprise Server SDK services:
   
   .. code::

      sudo service 'findface*' stop
      sudo service 'fkvideo*' stop
      sudo service 'ntls' stop
      sudo service 'nginx*' stop
      sudo service 'tarantool*' stop
      sudo service 'mongod*' stop     

   .. note::
      Starting with version 2.6, the ``nnapi`` component is deprecated, and ``extraction-api`` is used as a default facen extractor (as well as a default face detector). If you update from a ``nnapi``-based version, install ``extraction-api`` after this step and then remove ``nnapi``. It is important that you do so, minding the sequence, otherwise you can accidentally remove some important data. 

      .. code::

         sudo apt-get update
         sudo apt-get install findface-extraction-api
         sudo apt-get remove findface-nnapi

#. :ref:`Prepare <prepare>` the new package on each designated host.
#. Upgrade the services by executing:

   .. code::
      
      sudo apt-get update
      sudo apt-get upgrade

   .. tip::
      Be sure to check configuration files after this step.      

#. Start the FindFace Enterprise Server SDK services.

   .. code::
 
      sudo service 'findface*' start
      sudo service 'fkvideo*' start
      sudo service 'ntls' start
      sudo service 'nginx*' start
      sudo service 'tarantool*' start
      sudo service 'mongod*' start

#. :ref:`Migrate <regenerate-facens>` FindFace Enterprise Server SDK to a different detector or neural network model if necessary.
      
Reinstall in Full
----------------------

To fully reinstall FindFace Enterprise Server SDK, do the following:

#. :ref:`Remove <remove-sdk>` the old instance with all the enrolled faces.
#. Deploy the latest version, following the standard :ref:`deployment procedure <deploy>`. 


