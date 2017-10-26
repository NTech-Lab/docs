.. _remove-sdk:

Remove FindFace Enterprise Server SDK
==============================================

You can automatically remove FindFace Enterprise Server SDK, and, optionally, MongoDB and Tarantool by using the :program:`ffserver_uninstall.sh` script. Do the following:

#. Download the :download:`ffserver_uninstall.sh <_scripts/ffserver_uninstall.sh>` script from our GitHub to some directory on a designated host (for example, to ``/home/username/``):

   .. code::

       $ wget https://raw.githubusercontent.com/NTech-Lab/FFSER-file-examples/master/ffserver_uninstall.sh

#.  From this directory, make the :program:`ffserver_uninstall.sh` script executable. 

   .. code::

       $ sudo chmod +x ffserver_uninstall.sh

#. Launch the :program:`ffserver_uninstall.sh` script. 

   .. code::

       $ sudo ./ffserver_uninstall.sh

#. Answer the questions provided by the script interactive wizard to choose whether to remove FindFace Enterprise Server SDK completely (along with all the enrolled faces), or while maintaining face data.

