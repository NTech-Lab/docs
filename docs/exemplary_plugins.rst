.. _exemplary-plugins:


Build Plugin around HTTP Handler
------------------------------------

Plugins are great as proxy scripts that manage communication between ``fkvideo_detector`` and ``findface-facenapi`` and redirect ``findface-facenapi`` responses to an application that can process and render them. Another practical use case is sending the facial recognition results to a websocket or saving them to a file.

When writing a plugin for these use cases, you can inherit from the following ready-to-use HTTP handlers:

   * ``facenapi.core.http.base_handler.BaseHandler`` implements the FindFace Web Interface (without Video Processing)
   * ``facenapi.server.base_video_handler.BaseVideoHandler`` implements Video Processing. 

      .. note::
         ``BaseVideoHandler`` parses the ``fkvideo_detector`` requests and passes the parsed data to the ``process_frame`` method. 


.. note::
   To refer to the ``findface-facenapi`` context in a class that inherits from a HTTP API handler, use ``self.ctx``, e.g. ``self.ctx.faces.Model.from_extraction_face(eface)``.

The following examples will help you use these handlers in your plugin:

  .. important::
     By default, ``fkvideo_detector`` sends API requests directly to ``findface-facenapi``. To use a plugin as a proxy script between the components, assign the plugin path to the ``request-url`` parameter of ``fkvideo_detector``. The plugin path is specified inside ``app.add_handlers()`` in the plugin. It is ``/static-demo/frame`` for ``html-demo-report.py``, and ``/demo/frame`` for ``websocket-demo-plugin``.

* The :download:`html-demo-report.py <_scripts/html-report-demo.py>` plugin identifies faces detected in video by the ``fkvideo_detector`` component and saves the identification results to a static HTML file.

* The :download:`websocket-demo-plugin <_scripts/websocket-demo-plugin.py>` plugin identifies faces detected in video by the ``fkvideo_detector`` component and sends the identification results to a websocket.

