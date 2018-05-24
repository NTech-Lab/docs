.. _fkvideo-render:

Render Detection Results
======================================================

The fkvideo_detector component does not process FindFace Server responses to face identification and camera operation API requests. You should write your own proxy script that will manage communication between fkvideo_detector and FindFace Server and redirect API responses to an application that can process and render them. A typical rendering topology is shown on the diagram below:

|render_en|

.. |render_en| image:: https://gcc-elb-public-prod.gliffy.net/embed/image/e1e6f14528d931131fd3d25fea862232.png

.. |render_ru| image:: https://gcc-elb-public-prod.gliffy.net/embed/image/334f93a3e0c8de9f648b346019b710ed.png

When writing the proxy script, hold to the following logic:

#. A request from fkvideo_detector transparently goes to FindFace Server in the following format:

   .. code::

      curl -X POST -H 'Authorization: Token ntech' -F "gender=true" -F "emotions=true" -F "age=true" -F "cam_id=1b19a189-26b9-42e5-8cd8-6cabde79dc7e" -F "timestamp=2017-08-25T13:09:54" -F "bbox=[[620,380,1383,1143]]" -F "photo=@15036665986531599.jpeg" -F "face0=@15036665986766284_norm.png" -F 'detectorParams={"score": -0.000911839, "direction_score": -0.568228}' http://192.168.104.184:8000/v1/face

#. As FindFace Server replies to fkvideo_detector, your proxy script should redirect the response to your application for further processing.
   
   .. note::
       FindFace Server responses to requests sent directly or by fkvideo_detector are same. They may contain a link to a face thumbnail and other data which can be parsed in your application.

