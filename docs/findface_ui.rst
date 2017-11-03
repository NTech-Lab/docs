.. _ffui:

***************************************
FindFace Web User Interface
***************************************

FindFace Enterprise Server SDK is equipped with a web user interface which generally duplicates the functionality available via REST API.

To install the web interface, execute on the ``findface-facenapi`` host:

.. code::

    ## If necessary, install nginx
    sudo apt-get install nginx

    ## Install the web interface
    sudo apt-get install findface-ui

To open the web interface, do the following:

#. In the address bar of your browser, enter ``http://<facenapi_ip>:8000/#/``.
#. To log in, specify the :ref:`authentication token <token>` for your FindFace Enterprise Server SDK instance. The web interface home page
   will appear.

   .. image:: /_static/ffui.png


The web interface has a highly intuitive and handy design and provides the following functionality:

.. note::
     To work with gender, age and emotions recognition (GAE) in the web interface, you need to :ref:`configure <gae>` it in the settings.

.. note::     
     Working with photos requires configured :ref:`findface-upload <findface-upload>`.

.. note::
     Working with persons requires configured :ref:`dynamic person creation <persons>`.

.. note::
     To allow the web interface to run Flash in :program:`Chrome`, add its IP address to the relevant list: :menuselection:`Settings -->  Advanced --> Content settings --> Flash --> Allow --> Add a site` ``http://<facenapi_ip>:8000/#/``. Restart :program:`Chrome`.

* :guilabel:`Galleries`.  Create and delete galleries here. 

   
     .. image:: /_static/galleries.png
        :scale: 60%

   
* :guilabel:`Faces`. In this section, you can view, add and delete faces from the galleries.

     .. image:: /_static/add_photo.png

  Use the :guilabel:`Batch upload` option to upload image files in bulk. 
   
     .. image:: /_static/batch_upload.png

  .. tip::
     You may also want to use its :ref:`console alternative <bulk-face>`.
  

  Select multiple files or a directory, and then configure the automatic meta description for the enrolled faces. Use :guilabel:`&MF selector` to specify behavior in case if multiple faces are detected in an image: enroll all faces, only the biggest one, or reject enrollment.

     .. image:: /_static/meta.png
        :scale: 60%

  .. tip::
     You can configure the automatic face meta by appending a custom prefix and/or postfix to the image file name. To avoid merging the 3 words into one, use underscore or another symbol in the prefix and postfix.

  .. tip::
     To select photos in the :guilabel:`icons` mode, click on them as you hold down the :kbd:`CTRL` key.

* :guilabel:`Persons`. View and filter persons here.

     .. image:: /_static/persons.png

* :guilabel:`Photo processing`. Select this section to detect faces in static images, recognize gender, age and emotions, search a face in the database (identification), and compare two faces (verification). 

  
    .. image:: /_static/compare.png

 
* :guilabel:`Video processing`. Here you can work with video streams from rtsp and web cameras, and video files. Detect, enroll (add to a gallery) and identify faces in video with gender, age and emotions recognition. Generate enrollment and face identification reports in HTML by clicking on the :guilabel:`Save demo report` button.   
  
    .. image:: /_static/video.png

    .. image:: /_static/report.png

  .. note::
      The video processing functionality in the web interface is great for tests. In production mode, use :ref:`fkvideo_detector <video>`.



