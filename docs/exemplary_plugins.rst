.. _exemplary-plugins:


Exemplary Plugins
------------------------------------

The following case studies will help you write your first ``findface-facenapi`` plugin:

* The :download:`html-demo-report.py <_scripts/html-report-demo.py>` plugin identifies faces detected in video by the ``fkvideo_detector`` component and saves the identification results to a static HTML file.

  .. note::
     By default, faces detected in video are added to a database without identification. In order to identify them, :ref:`assign <fkvideo-config>` ``v1/identify`` to the ``request-url`` parameter of ``fkvideo_detector``.

* The :download:`websocket-demo-plugin <_scripts/websocket-demo-plugin.py>` plugin identifies faces and sends the identification results to a websocket.

  

