.. _regenerate-facens:

Migrate to Different Detector or Model
==========================================================

.. tip::
   Do not hesitate to contact our experts on migration by info@ntechlab.com.


Sometimes you have to migrate your FindFace Enterprise Server SDK instance to another face detector or neural network model. This usually happens when you decide to update to the latest version of the product.

.. tip::
   You can find the models summary :ref:`here <models>`. 

If you need to re-detect faces, you should regenerate both normalized face images, thumbnails and facens. If you just want to apply a different model, it usually suffices to regenerate only facens. FindFace Enterprise Server SDK provides tools that can handle most migration use cases. 

.. warning::
   Different detectors have diverse sensitivity to certain facial features. Be aware that, after re-detecting your database, you may miss out on some previously found faces.

.. contents:: In this section

Tools
--------------

To migrate your instance, you will need the following tools:

.. list-table::
   :header-rows: 1
   :widths: 13 43

   * - Tool
     - Description
   * - ``findface-regenerate``
     - Script that regenerates and overrides face data in MongoDB by applying different detector settings or another model to the images in the ``Uploads`` folder.
   * - ``mongo2searchapi``
     - Script that transfers newly generated facens from MongoDB to Tarantool.

Both tools are automatically installed with :ref:`findface-facenapi <install-facenapi>`.

Requirements
------------------------

The ``/var/lib/ffupload/uploads/`` folder (``Uploads``) has to be populated with at least the original images. Its content can be viewed at ``http://<findface_upload_IP:3333/uploads/`` in your browser.

Overall, the ``findface-regenerate`` tool works with the ``Uploads`` folder in the following way:

.. list-table::
   :header-rows: 1
   :widths: 13 43

   * - Use case
     - How it works
   * - Different detector settings
     - The ``findface-regenerate`` tool runs original images through the ``facenapi``-``nnapi`` pipeline with different detector [and model] settings, and returns regenerated normalized images, thumbnails and facens.
   * - Different model
     - The ``findface-regenerate`` tool runs normalized face images through ``nnapi`` with different model settings, and returns regenerated facens.


Regenerate Face Data
----------------------------------------------------

.. important::
   Before conducting any operations on your MongoDB database, be sure to create its backup. 
 
Apply ``findface-regenerate`` as follows:

#. Navigate into ``/usr/bin/``. Display and thoroughly examine the ``findface-regenerate`` help message: 

   .. code::

      $ cd /usr/bin/
      $ findface-regenerate --help

   .. code::

       ## findface-regenerate --help

       Usage: /usr/bin/findface-regenerate [OPTIONS]

       Options:

        --help                           show this help information

       /usr/lib/python3/dist-packages/facenapi/core/decoders/decoder_threaded.py options:

        --max-size                       Maximum allowed photo width/height (default
                                        4000)

       /usr/lib/python3/dist-packages/facenapi/core/detectors/detector_dlib.py options:

        --dlib-adjust-threshold          Adjust face detector threshold (default 0.0)
        --dlib-max-size                  images with width or height larger than
                                         dlib_max_size will be scaled down before
                                         being fed into detector (default 1200)
        --dlib-normalizer                path to normalizer data (default
                                         /usr/share/findface-data/normalizer.dat)

       /usr/lib/python3/dist-packages/facenapi/core/detectors/detector_nnd.py options:

        --nnd-max-face-size              Maximum face size in pixels (no limit if 0)
                                         (default 0)
        --nnd-min-face-size              Minimum face size in pixels (default 30.0)
        --nnd-o-net-thresh                (default 0.9)
        --nnd-p-net-thresh                (default 0.5)
        --nnd-r-net-thresh                (default 0.5)
        --nnd-scale-factor                (default 0.79)
        --nnd-workers                    Number of detector workers threads. (0 - as
                                         much as there are cpus) (default 0)

       /usr/lib/python3/dist-packages/facenapi/core/main_utils.py options:

        --decoder                        Image decoder (threaded) (default threaded)
        --detector                       Face detector (dlib,nnd) (default nnd)
        --extractor                      Feature extractor (nnapi,extraction-api)
                                         (default nnapi)
        --facen-storage                  Feature vector storage
                                         (searchapi_replicated,tntapi,searchapi)
                                         (default tntapi)
        --id-generator                   Face id generator (tntime,mongo) (default
                                         tntime)

       /usr/lib/python3/dist-packages/facenapi/server/context.py options:

        --fetch-proxy                    Fetch images from urls via proxy, ex:
                                         http://1.2.3.4:3128
        --ffupload-url                   url (without path) to PUT images uploaded to
                                         /face, ex: http://127.0.0.1:1234
        --friend-count                    (default 5)
        --friend-interval                 (default 604800)
        --gae                            enable Gender, Age and Emotions support
                                         (default False)
        --mongo-host                     mongo database host (default localhost)
        --mongo-port                     mongo database port (default 27017)
        --person-identify                identify persons (default False)
        --person-identify-global         identify persons across all cameras (default
                                         False)
        --person-identify-threshold      threshold for persons identify (default
                                         0.75)
        --upload-path                    path of $ffupload_url (default uploads)

       /usr/lib/python3/dist-packages/facenapi/server/regenerate_facens.py options:

        --config                         path to config file
        --coroutines                     Number of parallel coroutines (default 30)
        --every-other                     (default 1)
        --every-other-offset              (default 0)
        --facen-size                     Facen size in number of floats. (facens of
                                         this sizes are not regenerated when smart
                                         regeneration is enabled) (default -1)
        --max-id                         Maximum id (inclusive)
        --min-id                         Minimum id (inclusive)
        --regenerate                     What to regenerate: facens, thumbs,
                                         normalized (comma-separated). (default
                                         facens)

       /usr/lib/python3/dist-packages/tornado/log.py options:

        --log-file-max-size              max size of log files before rollover
                                         (default 100000000)
        --log-file-num-backups           number of log files to keep (default 10)
        --log-file-prefix=PATH           Path prefix for log files. Note that if you
                                         are running multiple tornado processes,
                                         log_file_prefix must be different for each
                                         of them (e.g. include the port number)
        --log-rotate-interval            The interval value of timed rotating
                                         (default 1)
        --log-rotate-mode                The mode of rotating files(time or size)
                                         (default size)
        --log-rotate-when                specify the type of TimedRotatingFileHandler
                                         interval other options:('S', 'M', 'H', 'D',
                                         'W0'-'W6') (default midnight)
        --log-to-stderr                  Send log output to stderr (colorized if
                                         possible). By default use stderr if
                                         --log_file_prefix is not set and no other
                                         logging is configured.

        --logging=debug|info|warning|error|none 
                                         Set the Python log level. If 'none', tornado
                                         won't touch the logging configuration.
                                         (default info)


#. To change detector settings, uncomment and edit the detector-related parameters in the ``findface-facenapi`` configuration file.

   .. code::

      sudo vi /etc/findface-facenapi.ini

      detector                       = 'nnd' 
      ...    
  
#. To change a face biometric :ref:`model <models>`, edit the ``model_facen`` parameter in the ``findface-nnapi`` configuration file:
 
   .. code::
      
      sudo vi /etc/findface-nnapi.ini
       
      model_facen = apricot_320

#. Configure ``findface-regenerate`` by using command line arguments as described in the help message. To run the script, execute from ``/usr/bin``: 

   .. code::

       ## When switching a face detector:
       $ sudo findface-regenerate --regenerate=normalized,thumbs,facens --config=/etc/findface-facenapi.ini

       ## When switching a model:
       $ sudo findface-regenerate --regenerate=facens --config=/etc/findface-facenapi.ini


Transfer Facens from MongoDB to Tarantool
--------------------------------------------------

Apply ``mongo2searchapi`` as follows:

#. Create a backup for Tarantool.
#. Stop Tarantool.

   .. code::

      $ sudo systemctl stop tarantool@FindFace*
 
#. Delete snapshot ``.snap``, xlog ``.xlog`` and :ref:`fast index <fast-index>` ``.idx`` files for all tntapi shards.

   .. tip::
      By default, these files are stored in the following folders:
       
      * Standalone instance:

        * ``/opt/ntech/var/lib/tarantool/default/snapshots``
        * ``/opt/ntech/var/lib/tarantool/default/xlogs``
        * ``/opt/ntech/var/lib/tarantool/default/index``

      * Cluster instance:

        * :samp:`/opt/ntech/var/lib/tarantool/shard_{N}/snapshots`
        * :samp:`/opt/ntech/var/lib/tarantool/shard_{N}/xlogs`
        * :samp:`/opt/ntech/var/lib/tarantool/shard_{N}/index`          

#. If facens :ref:`differ in size <models>` for the old and new models, update the facen size in the ``FindFace.start`` section of the Tarantool configuration file :samp:`/etc/tarantool/instances.enabled/FindFace_{shard_N}.lua`. Do so for each shard.

   .. code::
         
      $ sudo vi /etc/tarantool/instances.enabled/FindFace_shard_N.lua 

      FindFace.start("127.0.0.1", 8001, {license_ntls_server="127.0.0.1:3133", facen_size = 320})      
 
#. Run ``mongo2searchapi`` on the ``findface-facenapi`` host:

   .. code::
   
      $ sudo python3 -m facenapi.server.tools.mongo2searchapi --config=/etc/findface-facenapi.ini

#. Start Tarantool

   .. code::

      $ sudo systemctl start tarantool@FindFace*


