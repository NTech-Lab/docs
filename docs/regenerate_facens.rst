.. _regenerate-facens:

Regenerate Facens, Thumbnails, Normalized Faces
==========================================================

You can apply different neural network settings to the original face images stored at ``http://<findface_upload_host:3333/uploads/``, to regenerate and override facens, thumbnails, or normalized face images in the database. To do so, invoke the :program:`findface-regenerate` script.

Do the following:

.. note::
    The ``http://<findface_upload_host:3333/uploads/`` folder has to be populated.

#. To display the :program:`findface-regenerate` script help message, execute from ``/usr/bin/``: 

   .. code::

       $ findface-regenerate --help

   .. code::

       ## findface-regenerate --help

       Usage: /usr/bin/findface-regenerate [OPTIONS]

       Options:

         --help                           show this help information

       /usr/lib/python3/dist-packages/facenapi/core/decoder_threaded.py options:

         --max-size                       Maximum allowed photo width/height (default
                                          4000)

       /usr/lib/python3/dist-packages/facenapi/core/detector_dlib.py options:

         --dlib-adjust-threshold          Adjust face detector threshold (default 0.0)
         --dlib-max-size                  images with width or height larger than
                                          dlib_max_size will be scaled down before
                                          being fed into detector (default 1200)
         --dlib-normalizer                path to normalizer data (default
                                          /usr/share/findface-data/normalizer.dat)

       /usr/lib/python3/dist-packages/facenapi/core/detector_nnd.py options:

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
         --detector                       Face detector (nnd,dlib) (default nnd)

       /usr/lib/python3/dist-packages/facenapi/core/nnapi.py options:

         --nnapi-connect-timeout          nnapi connect timeout (default 10.0)
         --nnapi-max-clients              nnapi max clients (default 100)
         --nnapi-timeout                  nnapi request timeout (default 10.0)
         --nnapi-url                      findface-nnapi url (default
                                          http://localhost:18088)

       /usr/lib/python3/dist-packages/facenapi/server/regenerate_facens.py options:

         --config                         path to config file
         --coroutines                     Number of parallel coroutines (default 30)
         --every-other                     (default 1)
         --every-other-offset              (default 0)
         --facen-size                     Facen size in number of floats. (facens of
                                          this sizes are not regenerated when smart
                                          regeneration is enabled) (default -1)
         --ffupload-url                   url (without path) to PUT images uploaded to
                                          /face, ex: http://127.0.0.1:1234/
         --max-id                         Maximum id (inclusive)
         --min-id                         Minimum id (inclusive)
         --mongo-host                      (default localhost)
         --mongo-port                      (default 27017)
         --regenerate                     What to regenerate: facens, thumbs,
                                          normalized (comma-separated). (default
                                          facens)
         --upload-path                    path of $ffupload_url (default uploads/)

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

#. Configure the :program:`findface-regenerate` script by using command line arguments and/or relevant configuration files as described in the help message. To run the script, execute from ``/usr/bin``: 

   .. code::

       $ findface-regenerate [OPTIONS]

       ## For example, to regenerate facens using findface-facenapi.ini, execute:
       $ findface-regenerate --regenerate=facens --config=/etc/findface-facenapi.ini

