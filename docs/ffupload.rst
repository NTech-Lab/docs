.. _findface-upload:

Install findface-upload
""""""""""""""""""""""""""""""

To store all original images which have been processed by Server, as well as such Server artifacts as face thumbnails and normalized images, install and configure the ``findface-upload`` component.

.. tip::
    Skip this procedure if you do not want to store these data on the FindFace Enterprise Server SDK host. In this case, only face features vectors (facens) will be stored (in the MongoDB and Tarantool databases).

Do the following:

#. Install the component::

     sudo apt-get update
     sudo apt-get install findface-upload

#. By default the original images, thumbnails and normalized images are stored at ``/var/lib/ffupload/uploads/``. You can view this folder content at ``http://127.0.0.1:3333/uploads/`` in your browser. Make sure that this address is available (you will see ``Forbidden`` if so).

   .. code::

      curl -I http://127.0.0.1:3333/uploads/
      ##HTTP/1.1 403 Forbidden

   .. important::
      You will have to specify this address when :ref:`configuring network <configure-network>`.

.. seealso::

   :ref:`troubleshoot-uploads`




