MongoDB
^^^^^^^^^^^^^^^^

Prior to installing FindFace Server, set up a database for it. You may install MongoDB either on the application host where the findface-facenapi component resides, or on a dedicated host. For the standalone architecture, we recommend you the first option.
FindFace Enterprise Server SDK is compatible with `MongoDB 3.2 <https://docs.mongodb.com/v3.2/tutorial/install-mongodb-on-ubuntu/>`_ or later.

.. _mongodb-app:

Install MongoDB on Application Host
_____________________________________

To install the latest stable version of MongoDB (3.4 at the moment) on the application host, do the following:

.. note::
   To install a different version of MongoDB, please refer to that version’s documentation. For example, see version `3.2 <https://docs.mongodb.com/v3.2/tutorial/install-mongodb-on-ubuntu/>`_. 

#. Import the public key used by the package management system::

     sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

#. Create a list file (/etc/apt/sources.list.d/mongodb-org-3.4.list ) for MongoDB::
 
     echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
 
#. Reload the local package database::

     sudo apt-get update

#. Install the latest stable version of MongoDB::
 
     sudo apt-get install -y mongodb-org

#. Start the ``mongod`` service::

     sudo service mongod start 


Install MongoDB on Dedicated Host
__________________________________________

To install MongoDB on a dedicated host, do the following:

#. On the dedicated host, install MongoDB in the same manner as on the :ref:`application host <mongodb-app>`.
#. Open the MongoDB configuration file::

     sudo vi /etc/mongod.conf

#. To allow for incoming connections, comment out the line bind_ip = 127.0.0.1. This will allow MongoDB to accept connections from any IP address. Ensure that the only access to the host is from the LAN::
    
     #bind_ip = 127.0.0.1

#. Restart the ``mongod`` service::

     sudo service mongod restart

Connect to Existing MongoDB
_________________________________

If you wish to establish connection to an existing MongoDB instance, specify its IP address in the :ref:`network settings <configure-network>`.
