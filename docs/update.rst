.. _update:

Update to The Latest Version
=================================================

.. contents:: In this section:

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

#. :ref:`Prepare <prepare>` the new package on each designated host.
#. Upgrade the services by executing:

   .. code::
      
      sudo apt-get update
      sudo apt-get upgrade

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
