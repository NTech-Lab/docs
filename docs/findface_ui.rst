.. _ffui:

***************************************
FindFace Web User Interface
***************************************

FindFace Enterprise Server SDK is equipped with a web user interface which generally duplicates the functionality available via REST API.

To install the web interface, execute the commands below on the findface-facenapi host:

.. code::

    ## If necessary, install nginx
    $ sudo apt-get install nginx

    ## Install the web interface
    $ sudo apt-get install findface-ui

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
     To allow the web interface to run Flash in :program:`Chrome`, add its IP address to the relevant list: **Settings** → **Advanced** → **Content settings** → **Flash** → **Allow** → **Add a site** (``http://<facenapi_ip>:8000/#/``). Restart :program:`Chrome`.

*  **Gallery management**.  In this section, you can view, create, delete and rename galleries, as well as add and remove faces. 

   
   .. image:: /_static/add_photo.png

   
   You can upload images in bulk by using the **Batch upload** option (select multiple faces or a directory).

   
   .. image:: /_static/batch_upload.png


   .. tip::
       To select photos in the **icons** mode, click on them as you hold down the CTRL key.

* **Photo processing**. Select this section to detect faces in static images, recognize gender, age and emotions, search a face in the database (identification), and compare two faces (verification). 

  
  .. image:: /_static/compare.png

 
* **Video processing**. In this section you can process a rtsp video stream or a video file to detect, enroll (add to a gallery) and identify faces in it, recognize gender, age and emotions.

  .. note::
      The video processing functionality in the web interface is great for tests. In production mode, use :ref:`fkvideo_detector <video>`.
   
  
  .. image:: /_static/video.png


