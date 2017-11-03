To configure fkvideo_detector, you can specify its options in any of the following ways: 

* As command line arguments upon starting fkvideo_detector.

  .. code::

     fkvideo_detector [options]

* As parameters in the fkvideo_detector configuration file.

  .. warning::
     The default fkvideo_detector configuration file is ``/etc/fkvideo.ini``. Avoid editing ``/etc/fkvideo.ini``, especially if fkvideo_detector and :ref:`FindFace Web UI <ffui>` are running on the same host, as FindFace Web UI also uses this configuration file. Instead, make a copy of this file, edit the copy and specify it in the option ``-c`` when starting fkvideo_detector.

     .. code::

        ## Make a copy of fkvideo.ini
        sudo cp /etc/fkvideo.ini /etc/fkvideo_example.ini
        
        ## Use this copy when starting fkvideo_detector
        fkvideo_detector -c /etc/fkvideo_example.ini
