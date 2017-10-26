.. _findface-upload:

Install findface-upload
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To store all uploaded original images and thumbnails of faces, install and configure the **findface-upload** component as follows:

.. tip::
    Do not install findface-upload, if you do not want to store original images and thumbnails of faces on the FindFace Enterprise Server SDK host.


#. Install the component::

   $ sudo apt-get update
   $ sudo apt-get install findface-upload

#. By default the uploaded images and thumbnails of faces are stored in the folder ``http://127.0.0.1:3333/uploads/``. Make sure that the folder is available. You will have to specify this folder when :ref:`configuring network <configure-network>`:

   .. code::

      $ curl -I http://127.0.0.1:3333/uploads/
      ## The command should return the following message.
      HTTP/1.1 200 OK





