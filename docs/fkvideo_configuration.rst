.. _fkvideo-config:

Configuration Parameters
=============================

.. include:: /_inclusions/fkvideo_config_warning.rst

.. rubric:: In this section:

.. contents::
   :local:


Command Line Arguments
---------------------------

Usage:

.. code::

   fkvideo_detector [options]

.. rubric:: Allowed options:

.. warning::
    The following parameters are mandatory: ``api-url``, ``api-token``, ``--license-ntls-server``.

.. list-table::
   :widths: 10 20 15 10
   :header-rows: 1
   
   * - Option
     - Description
     - Argument
     - Example
   * - -c [ ‑‑config ] arg
     - Invoke fkvideo_detector with a given configuration file (``.ini``). The command line parameters and those in the configuration file have the same names and meaning, but if a parameter is set either way, the command line value has priority.
     - Path to the .ini configuration file. If you specify the file name alone (without the full path), fkvideo_detector will search for the file in the fkvideo_detector working directory. The default fkvideo_detector configuration file is ``/etc/fkvideo.ini``. If fkvideo_detector and :ref:`FindFace Web UI <ffui>` are running on the same host, avoid editing ``/etc/fkvideo.ini`` as it is also used by FindFace Web UI. Instead, make a copy of this file, edit the copy and specify it in the option ``-c`` when starting fkvideo_detector.
     - $ fkvideo_detector -c /etc/fkvideo_example.ini
   * - -S [ ‑‑source ] arg
     - Define a video stream as the relevant camera address (see also ``--camid``). If a video stream is not specified, fkvideo_detector requests the :ref:`list of cameras <video-methods>` from FindFace Server with a polling interval defined by the ``reload-timeout`` parameter.
     - Camera address: ``rtsp://...`` - network stream, ``/dev/video0`` – webcam, ``file@FPS:PATH`` - file with configurable FPS.
     - ‑‑source rtsp://192.168.120.55:500
   * - ‑‑camid arg
     - Define a video stream as the relevant camera id (see also ``--source``). If a video stream is not specified, fkvideo_detector requests the :ref:`list of cameras <video-methods>` from FindFace Server with a polling interval defined by the ``reload-timeout`` parameter.
     - Camera id.
     - ‑‑camid b28a898b-6334
   * - ‑‑source-params arg
     - Define ffmpeg options for a video stream.
     - List of ffmpeg options with their values.
     - ‑‑source-params rtsp_transport=tcp, rtsp_flags=prefer, timeout=-1
   * - ‑‑md-threshold arg
     - Define the minimum motion intensity to be detected by the motion detector. The threshold value is to be fitted empirically.
     - Motion intensity in empirical units (zero and positive rational numbers). Milestones: 0 = detector disabled, 0.002 = default value, 0.05 = minimum intensity is too high to detect motion.
     - ‑‑md-threshold 0.003
   * - ‑‑scale arg
     - Define a video frame scaling coefficient for the motion detector. Scale down in the case of high resolution cameras, or close up faces, or if the CPU load is too high, to reduce the system resources consumption. Make sure that the scaled face size exceeds the ``min-face-size`` value.
     - Video frame scaling coefficient.
     - ‑‑scale 0.3
   * - ‑‑rescale-height arg
     - Define a video frame height for the face tracker. Scale down in the case of high resolution cameras, or close up faces, or if the CPU load is too high, to reduce the system resources consumption. Make sure that the scaled face size exceeds the ``min-face-size`` value.
     - Video frame height in pixels.
     - ‑‑rescale-height 480
   * - ‑‑uc-max-time-diff arg
     - Define the maximum time period during which a number of similar faces are considered as belonging to one person.
     - Maximum time period in seconds.
     - ‑‑uc-max-time-diff 1
   * - ‑‑uc-max-dup arg
     - Define the maximum number of faces during the ``uc-max-time-diff`` period that is posted for a person.
     - Maximum number of faces.
     - ‑‑uc-max-dup 3
   * - ‑‑uc-max-avg-shift arg
     - Define the distance within which a number of similar faces are considered as belonging to one person.
     - Distance in pixels.
     - ‑‑uc-max-avg-shift 10
   * - -r [ ‑‑realtime ] [=arg(=1)]
     - Enable the :ref:`real-time <fkvideo-about>` mode of fkvideo_detector.
     - Mode of fkvideo_detector: 1 = real-time, 0 = off-line. -r and -r 1 are equal.
     - -r or -r 1, -r 0
   * - ‑‑realtime1844 [=arg(=1)]
     - Simultaneously use the real-time and off-line modes of fkvideo_detector. In this case, fkvideo-detector will be sending bounding boxes to FindFace Server under 2 different labels.
     - Boolean: 1 = use both modes of fkvideo_detector, 0 = use the mode defined by the ``-r`` parameter. ‑‑realtime1844 and ‑‑realtime1844 1 are equal.
     - ‑‑realtime1844 or ‑‑realtime1844 1, ‑‑realtime1844 0
   * - ‑‑start-ts=arg
     - By default, faces are posted to FindFace Server with a current time stamp. To change the time stamp, specify a different start time of a video stream processing. In the case of a video file processing, you have to specify the start date and time of a video file. 
     - Start date and time of a video file, or a video stream processing.
     - ‑‑start-ts='2016-01-20 12:34:56'
   * - ‑‑max-persons arg
     - Define the maximum number of faces simultaneously tracked by the face tracker. This parameter severely affects performance.
     - Maximum number of simultaneously tracked faces.
     - ‑‑max-persons 4
   * - ‑‑disable-drops [=arg(=1)]
     - Enable posting all appropriate faces without drops. By default, if fkvideo_detector does not have enough resources to process all frames with faces, it drops some of them. If this option is active, fkvideo_detector puts odd frames on the waiting list to process them later.
     - Boolean: 1 = drops are disabled, 0 = drops are enabled. ‑‑disable-drops and ‑‑disable-drops 1 are equal.
     - ‑‑disable-drops
   * - ‑‑tracker-threads arg
     - Define the number of tracking threads for the face tracker. This value should be less or equal to the ``max-persons`` value. We recommend you to set them equal. If the number of tracking threads is less than the maximum number of tracked faces, resource consumption is reduced but so is the tracking speed.
     - Number of tracking threads
     - ‑‑tracker-threads 4
   * - ‑‑sink-url arg
     - Only if fkvideo_detector processes 1 camera defined in the configuration file or in command line arguments. Defines the nginx video server IP address for the output video stream (it is there further redirected to :ref:`FindFace Web UI <ffui>`).
     - Nginx video server IP address.
     - ‑‑sink-url 192.168.15.1:3222
   * - ‑‑sink-res arg
     - Define the output video stream resolution.
     - Resolution WхH
     - ‑‑sink-res 1280x720
   * - ‑‑rotate arg
     - Rotate input video in a clockwise direction.
     - Rotation angle in degrees from 0° to 360°.
     - ‑‑rotate 90
   * - ‑‑request-url arg
     - Define the request fkvideo_detector sends to FindFace Server when posting a face.
     - /v0/face/ or /v0/identify/.
     - ‑‑request-url /v0/identify
   * - ‑‑img-arg arg
     - Define the name of the argument containing a bbox with a face, in an API request.
     - Argument name (photo by default).
     - ‑‑img-arg picture
   * - ‑‑headers arg
     - Create an additional header field in a POST request when posting a face.
     - Additional header field in a POST request.
     - ‑‑headers xxx = yyy ‑‑headers kkk = ppp
   * - ‑‑body arg
     - Create additional body fields in the request body when posting a face.
     - Additional body field(s). You can specify several values for each field, separated by a comma. 
     - ‑‑body galleries='testgal1,testgal2' ‑‑body gender=true ‑‑body age=true ‑‑body emotions=true ‑‑body meta=video.mp4
   * - ‑‑bbox-scale
     - Define a bbox scaling coefficient.
     - Bbox scaling coefficient (1 by default).
     - ‑‑bbox-scale 1.3
   * - ‑‑post-uniq arg
     - Enable posting only a certain number of faces belonging to one person, during a certain period of time. In this case, if fkvideo_detector posts a face to FindFace Server and then tracks another one within the time period ``uc-max-time-diff``, and the distance between the two faces doesn't exceed ``uc-max-avg-shift``, fkvideo_detector estimates their similarity. If the faces are similar and the total number of similar faces during the ``uc-max-time-diff`` period does not exceed the number ``uc-max-dup``, fkvideo_detector posts the other face. Otherwise, the other face is not posted.
     - Boolean: 1 = only a certain number of faces belonging to one person are posted, 0 = all captured faces are posted.
     - ‑‑post-uniq 1
   * - ‑‑min-score arg
     - Define the minimum threshold value for a face image quality. A face is posted if it has better quality. The threshold value is to be fitted empirically.
     - Minimum threshold value for the face quality in empirical units (negative rational numbers to zero). Milestones: 0 = high quality faces, -1 = good quality, -2 = satisfactory quality, -5 = face recognition maybe inefficient. The default value is -7.
     - ‑‑min-score -1.5
   * - ‑‑min-dir-score arg
     - Define the maximum deviation of a face from its frontal position. A face is posted if its deviation is less than this value. The deviation is to be fitted empirically.
     - Maximum deviation of a face from its frontal position in empirical units (negative rational numbers to zero). Milestones: -3.5 = large face angles, face recognition may be inefficient, -2.5 = satisfactory deviation, -0.05 = close to the frontal position, 0 = frontal face. The default value is -1000.
     - ‑‑min-dir-score -1
   * - ‑‑rt-delay arg
     - Only for the real-time mode. If ``rt-perm=True``, defines the time period within which the face tracker picks up the best snapshot and posts it to FindFace Server. If ``rt-perm=False``, defines the minimum time period between 2 posts of the same face with increased quality.
     - Time period in milliseconds.
     - ‑‑rt-delay 100
   * - ‑‑rt-perm arg
     - Only for the realtime mode. Post best snapshots obtained within each ``rt-delay`` time period.
     - Boolean: 1 = post best snapshots obtained within each ``rt-delay`` time period, 0 = search for the best snapshot dynamically and send snapshots in order of increasing quality.
     - ‑‑rt-perm 1
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
     - Boolean: 1 = enable drawing a track, 0 = disable drawing a track. ‑‑draw-track and ‑‑draw-track 1 are equal.
     - ‑‑draw-track
   * - ‑‑send-track [=arg(=1)]
     - Enable posting coordinates of a face motion track along with a bbox in a request.
     - Boolean: 1 = enable posting a track coordinates, 0 = disable posting a track coordinates. ‑‑send-track and ‑‑send-track 1 are equal.
     - ‑‑send-track
   * - ‑‑min-face-size arg
     - Define the minimum size of a face. Undersized faces are not posted.
     - Minimum size of a bbox minor side in pixels.
     - ‑‑min-face-size 50
   * - ‑‑max-face-size arg
     - Define the maximum size of a face. Oversized faces are not posted.
     - Maximum size of a bbox major side in pixels.
     - ‑‑max-face-size 120
   * - ‑‑only-norm arg
     - Enable posting only normalized face images without full frames.
     - Boolean: 1 = only normalized faces are posted to FindFace Server, 0 = full frames and normalized faces are posted. 
     - ‑‑only-norm 1
   * - ‑‑license-ntls-server arg
     - Mandatory. Define the IP address and port of :ref:`NTLS <licensing>`. Edit only if NTLS is remote.
     - NTLS IP address:port
     - ‑‑license-ntls-server 192.168.10.1:3133
   * - ‑‑api-url arg
     - Mandatory. Define the host fkvideo_detector sends requests to (FindFace Server in particular).
     - IP address:port.
     - ‑‑api-host 127.0.0.1:8000
   * - ‑‑api-token arg
     - Mandatory. Define the authentication token for FindFace Server.
     - :ref:`Authentication token <token>`.
     - ‑‑api-token c9FsRNDAt
   * - ‑‑to-verify-cert arg
     - Need to verify a https certificate.
     - Boolean: 1 = a https certificate verification is necessary, 0 = a self-signed certificate can be accepted.
     - ‑‑to-verify-cert 1
   * - -n [ ‑‑detector-name ] arg
     - Applie fkvideo_detector to a given list of cameras.
     - Unique video detector identifier (hostname by default) which corresponds to a particular list of cameras stored on FindFace Server.   
     - ‑‑detector-name detec1
   * - -d [ ‑‑detectors-max ] arg
     - Define the maximum number of video streams to be processed by fkvideo_detector.
     - Maximum number of video streams simultaneously processed by fkvideo_detector (5 by default).
     - ‑‑detectors-max 7
   * - -t [ ‑‑reload-timeout ] arg
     - Define the interval between 2 consecutive requests fkvideo_detector sends to FindFace Server to update the list of cameras.
     - Interval in seconds between 2 consecutive camera list updates (15 s by default).
     - -t 20
   * - ‑‑camera-url arg
     - Define the request fkvideo_detector sends to FindFace Server to obtain the list of cameras.
     - /v0/camera (default) or /v1/camera.
     - ‑‑camera-url /v1/camera
   * - ‑‑req-timeout arg
     - Define a timeout for a FindFace Server response to a fkvideo_detector API request.
     - API response timeout in seconds (3 s by default).
     - ‑‑req-timeout 2
   * - ‑‑single-pass [=arg(=1)]
     - Disable periodical updates of the list of cameras. Use this option if fkvideo_detector should process a video file. In this case, fkvideo_detector will request the list of cameras only once.
     - Boolean: 1 = updates are disabled, 0 = updates are enabled. ‑‑ single-pass and ‑‑single-pass 1 are equal.
     - ‑‑single-pass 0
   * - ‑‑remote-config [=arg(=1)]
     - Get the list of cameras from FindFace Server.
     - Boolean: 1 = the list of cameras is obtained from FindFace Server (default), 0 = fkvideo_detector processes a video stream defined in the ``‑‑source`` and ``‑‑camid`` parameters. The ``‑‑source`` and ``‑‑camid`` parameters have priority: if a video stream is specified, the ``‑‑remote-config`` option is automatically set to 0. ‑‑remote-config and ‑‑remote-config 1 are equal.
     - ‑‑remote-config
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

    | api-url=127.0.0.1:8000
    | api-token=lMDkdLnO6FF-PLfwmMuypTsM
    | license-ntls-server=192.168.10.1:3133
    | source-params=rtsp_transport=tcp,rtsp_flags=prefer,timeout=-1
    | body=galleries=testgal1\,testgal2,gender=true,age=true,emotions=true,meta=video.mp4
    | start-ts = 2013-01-22 12:34:56


.. note::
   You can specify several values for an additional body field (``body``), separated by a comma. In the configuration file, a comma between values of the same field must be preceded by a backslash (``\,``) to avoid a parsing error. 

