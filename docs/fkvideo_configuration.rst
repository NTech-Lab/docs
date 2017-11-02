.. _fkvideo-config:

Configuration Parameters
=============================

.. include:: /_inclusions/fkvideo_config_warning.rst

.. contents:: In this section:

Command Line Arguments
---------------------------

Usage:

.. code::

   $ fkvideo_detector [options]

.. rubric:: Allowed options:

.. warning::
    The following parameters are mandatory: ``api-host``, ``api-port``, ``api-token``, ``--license-ntls-server``.

.. list-table::
   :widths: 10 20 15 10
   :header-rows: 1
   
   * - Option
     - Description
     - Argument
     - Example
   * - -c [ ‑‑config ] arg
     - Invokes fkvideo_detector with a given configuration file (``.ini``). The command line parameters and those in the configuration file have the same names and meaning, but if a parameter is set either way, the command line value has priority.
     - Path to the .ini configuration file. If you specify the file name alone (without the full path), fkvideo_detector will search for the file in the fkvideo_detector working directory. The default fkvideo_detector configuration file is ``/etc/fkvideo.ini``. If fkvideo_detector and :ref:`FindFace Web UI <ffui>` are running on the same host, avoid editing ``/etc/fkvideo.ini`` as it is also used by FindFace Web UI. Instead, make a copy of this file, edit the copy and specify it in the option ``-c`` when starting fkvideo_detector.
     - $ fkvideo_detector -c /etc/fkvideo_example.ini
   * - ‑‑license-ntls-server arg
     - Mandatory. Defines the IP address and port of :ref:`NTLS <licensing>`. Edit only if NTLS is remote.
     - NTLS IP address:port
     - ‑‑license-ntls-server 192.168.10.1:3133
   * - -n [ ‑‑detector-name ] arg
     - Applies fkvideo_detector to a given list of cameras.
     - Unique video detector identifier (hostname by default) which corresponds to a particular list of cameras stored on FindFace Server.   
     - ‑‑detector-name detec1
   * - -d [ ‑‑detectors-max ] arg
     - Defines the maximum number of video streams to be processed by fkvideo_detector.
     - Maximum number of video streams simultaneously processed by fkvideo_detector (5 by default).
     - ‑‑detectors-max 7
   * - -t [ ‑‑reload-timeout ] arg
     - Defines the interval between 2 consecutive requests fkvideo_detector sends to FindFace Server to update the list of cameras.
     - Interval in seconds between 2 consecutive camera list updates (15 s by default).
     - -t 20
   * - ‑‑camid arg
     - Defines a video stream to be processed by fkvideo_detector, as the relevant camera id (see also ``‑‑source``). If a video stream is not specified, fkvideo_detector requests the :ref:`list of cameras <video-methods>` from FindFace Server with a polling interval defined by the ``reload-timeout`` parameter.
     - Camera id.
     - ‑‑camid b28a898b-6334
   * - ‑‑api-host arg
     - Mandatory. Defines the FindFace Server host fkvideo_detector will be sending API requests to.
     - FindFace Server host IP address.
     - ‑‑api-host 127.0.0.1
   * - ‑‑api-port arg
     - Mandatory. Defines the FindFace Server host port for API requests.
     - Port number.
     - ‑‑api-port 8000
   * - ‑‑api-token arg
     - Mandatory. Defines the authentication token for FindFace Server.
     - :ref:`Authentication token <token>`.
     - ‑‑api-token c9FsRNDAt
   * - -S [ ‑‑source ] arg
     - Defines a video stream to be processed by fkvideo_detector, as the relevant camera address (see also ``‑‑camid``). If a video stream is not specified, fkvideo_detector requests the :ref:`list of cameras <video-methods>` from FindFace Server with a polling interval defined by the ``reload-timeout`` parameter.
     - Camera address: ``rtsp://...`` - network stream, ``/dev/video0`` – webcam, ``file@FPS:PATH`` - file with configurable FPS.
     - ‑‑source rtsp://192.168.120.55:500
   * - ‑‑source-params arg
     - Defines ffmpeg options for a video stream.
     - List of ffmpeg options with their values.
     - ‑‑source-params rtsp_transport=tcp, rtsp_flags=prefer, timeout=-1
   * - ‑‑md-threshold arg
     - Defines the minimum motion intensity to be detected by the motion detector. The threshold value is to be fitted empirically.
     - Motion intensity in empirical units (zero and positive rational numbers). Milestones: 0 = detector disabled, 0.002 = default value, 0.05 = minimum intensity is too high to detect motion.
     - ‑‑md-threshold 0.003
   * - ‑‑scale arg
     - Defines a video frame scaling coefficient for the motion detector. Scale down in the case of high resoultion cameras, or close up faces, or if the CPU load is too high, to reduce the system resources consumption. Make sure that the scaled face size exceeds the ``min-face-size`` value.
     - Video frame scaling coefficient.
     - ‑‑scale 0.3
   * - ‑‑request-url arg
     - Defines the request fkvideo_detector sends to FindFace Server when posting a face.
     - /v0/face/ or /v0/identify/.
     - ‑‑request-url /v0/identify
   * - ‑‑camera-url arg
     - Defines the request fkvideo_detector sends to FindFace Server to obtain the list of cameras.
     - /v0/camera (default) or /v1/camera.
     - ‑‑camera-url /v1/camera
   * - ‑‑img-arg arg
     - Defines the name of the argument containing a bbox with a face, in an API request.
     - Argument name (photo by default).
     - ‑‑img-arg picture
   * - ‑‑req-timeout arg
     - Defines a timeout for a FindFace Server response to a fkvideo_detector API request.
     - API response timeout in seconds (3 s by default).
     - ‑‑req-timeout 2
   * - ‑‑headers arg
     - Creates an additional header field in a POST request when posting a face.
     - Additional header field in a POST request.
     - ‑‑headers xxx = yyy ‑‑headers kkk = ppp
   * - ‑‑body arg
     - Creates additional body fields in the request body when posting a face.
     - Additional body field(s).
     - ‑‑body galleries=testgal ‑‑body gender=true ‑‑body age=true ‑‑body emotions=true ‑‑body meta=video.mp4
   * - ‑‑bbox-scale
     - Defines a bbox scaling coefficient.
     - Bbox scaling coefficient (1 by default).
     - ‑‑bbox-scale 1.3
   * - ‑‑post-uniq arg
     - Enables posting only a certain number of faces belonging to one person, during a certain period of time. In this case, if fkvideo_detector posts a face to FindFace Server and then tracks another one within the time period ``uc-max-time-diff``, and the distance between the two faces doesn't exceed ``uc-max-avg-shift``, fkvideo_detector estimates their similarity. If the faces are similar and the total number of similar faces during the ``uc-max-time-diff`` period does not exceed the number ``uc-max-dup``, fkvideo_detector posts the other face. Otherwise, the other face is not posted.
     - Boolean: 1 = only a certain number of faces belonging to one person are posted, 0 = all captured faces are posted.
     - ‑‑post-uniq 1
   * - ‑‑uc-max-time-diff arg
     - Defines the maximum time period during which a number of similar faces are considered as belonging to one person.
     - Maximum time period in seconds.
     - ‑‑uc-max-time-diff 1
   * - ‑‑uc-max-dup arg
     - Defines the maximum number of faces during the ``uc-max-time-diff`` period that is posted for a person.
     - Maximum number of faces.
     - ‑‑uc-max-dup 3
   * - ‑‑uc-max-avg-shift arg
     - Defines the distance within which a number of similar faces are considered as belonging to one person.
     - Distance in pixels.
     - ‑‑uc-max-avg-shift 10
   * - -r [ ‑‑realtime ] [=arg(=1)]
     - Enables the :ref:`real-time <fkvideo-about>` mode of fkvideo_detector.
     - Mode of fkvideo_detector: 1 = real-time, 0 = off-line. -r and -r 1 are equal.
     - -r or -r 1, -r 0
   * - ‑‑min-score arg
     - Defines the minimum threshold value for a face image quality. A face is posted if it has better quality. The threshold value is to be fitted empirically.
     - Minimum threshold value for the face quality in empirical units (negative rational numbers to zero). Milestones: 0 = poor quality, -10 = satisfactory quality, -15 = good quality etc. The default value is -7.
     - ‑‑min-score -11.5
   * - ‑‑min-dir-score arg
     - Defines the maximum deviation of a face from its frontal position. A face is posted if its deviation is less than this value. The deviation is to be fitted empirically.
     - Maximum deviation of a face from its frontal position in empirical units (negative rational numbers to zero). Milestones: -20 = satisfactory deviation, -10 = close to the frontal position, 0 = frontal face. The default value is -1000.
     - ‑‑min-dir-score -12
   * - ‑‑rt-refresh arg
     - Only for the real-time mode. Defines the time interval for the best face score auto-refresh during the better snapshot dynamic search.
     - Time period in milliseconds. The default value is 0 (disabled).
     - ‑‑rt-refresh 10
   * - ‑‑rt-score-step arg
     - Only for the real-time mode. Defines the threshold increase step for the better snapshot dynamic search.
     - Threshold increase step (positive rational numbers).
     - ‑‑rt-score-step 3.4
   * - ‑‑rt-delay arg
     - Only for the real-time mode. Defines the minimum time period between 2 posts of the same face with increased quality.
     - Time period in milliseconds between 2 posts of the same face with increased quality.
     - ‑‑rt-delay 100
   * - ‑‑rot arg
     - Enable detecting and tracking faces only inside a clipping rectangle. You can use this option to reduce fkvideo_detector load.
     - Clipping rectangle: WxH+X+Y (see the specification of X geometry).
     - ‑‑rot 150x123+300+155
   * - ‑‑roi arg
     - Enable posting faces detected only inside a region of interest.
     - Region of interest: WxH+X+Y (see the specification of X geometry).
     - ‑‑roi 123x122+159+220
   * - ‑‑draw-track [=arg(=1)]
     - Enable drawing a face motion track in a bbox.
     - Boolean: 1 = tracks are enabled, 0 = tracks are disabled. ‑‑draw-track and ‑‑draw-track 1 are equal.
     - ‑‑draw-track
   * - ‑‑min-face-size arg
     - Defines the minimum size of a face. Undersized faces are not posted.
     - Minimum size of a bbox minor side in pixels.
     - ‑‑min-face-size 50
   * - ‑‑max-face-size arg
     - Defines the maximum size of a face. Oversized faces are not posted.
     - Maximum size of a bbox major side in pixels.
     - ‑‑max-face-size 120
   * - ‑‑max-persons arg
     - Defines the maximum number of faces simultaneously tracked by the face tracker. This parameter severely affects performance.
     - Maximum number of simultaneously tracked faces.
     - ‑‑max-persons 4
   * - ‑‑single-pass [=arg(=1)]
     - Disables periodical updates of the list of cameras. Use this option if fkvideo_detector should process a video file. In this case, fkvideo_detector will request the list of cameras only once.
     - Boolean: 1 = updates are disabled, 0 = updates are enabled. ‑‑ single-pass and ‑‑single-pass 1 are equal.
     - ‑‑ single-pass 0
   * - ‑‑start-ts arg
     - Adds a frame timestamp into a face posting request.
     - Boolean: 1 = timestamps are added, 0 = timestamps are disabled.
     - ‑‑start-ts 1
   * - ‑‑disable-drops [=arg(=1)]
     - Enables posting all appropriate faces without drops. By default, if fkvideo_detector does not have enough resources to process all frames with faces, it drops some of them. If this option is active, fkvideo_detector puts odd frames on the waiting list to process them later.
     - Boolean: 1 = drops are disabled, 0 = drops are enabled. ‑‑disable-drops and ‑‑disable-drops 1 are equal.
     - ‑‑disable-drops
   * - ‑‑sink-url arg
     - Only if fkvideo_detector processes 1 camera defined in the configuration file or in command line arguments. Defines the nginx video server IP address for the output video stream (it is there further redirected to :ref:`FindFace Web UI <ffui>`).
     - Nginx video server IP address.
     - ‑‑sink-url 192.168.15.1:3222
   * - ‑‑sink-res arg
     - Defines the output video stream resolution.
     - Resolution WхH
     - ‑‑sink-res 1280x720
   * - ‑‑tracker-threads arg
     - Defines the number of tracking threads for the face tracker. This value should be less or equal to the ``max-persons`` value. We recommend you to set them equal. If the number of tracking threads is less than the maximum number of tracked faces, resource consumption is reduced but so is the tracking speed.
     - Number of tracking threads
     - ‑‑tracker-threads 4
   * - -h [ ‑‑help ]
     - Produce the fkvideo_detector help message.
     - ─
     - ─



Configuration File Format
--------------------------------
   
.. code::

    [General]
    | long-arg=option ; long-arg from command line arguments
    | ...

    | license-ntls-server = 192.168.10.1:3133
    | source-params =rtsp_transport=tcp,rtsp_flags=prefer,timeout=-1
    | body =galleries=testgal,gender=true,age=true,emotions=true,meta=video.mp4




