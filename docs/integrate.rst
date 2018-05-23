.. _integrate:

***********************************************
Integration
***********************************************

Being integrated into specific solutions or Android applications, FindFace Enterprise Server SDK can be used in such areas as biometric identification and access control, customer analytics, customer offer tailoring, offline retargeting, managing white and black lists, sorting and optimizing media libraries, borrower scoring, fraud prevention, employee productivity control, and many more.

You can integrate with FindFace Enterprise Server SDK in one of the following ways, depending on your purpose and resources:

* Via embedded :ref:`api`. This variant provides cross-platform multidimensional integration with your own application. Allows for maximum flexibility, though it is more time- and knowledge-intensive, as you have to get the application ready.
* By writing ``findface-facenapi`` :ref:`plugins <plugins>` in Python. This variant provides easier approach to the FindFace Enterprise Server SDK functionality than REST API as it involves less coding. To write a plugin, you require good command of the Python programming language.
* Through custom HTTP API handlers implemented to the FindFace API Environment in addition to the embedded :ref:`api`. 
   
  .. note::
     The FindFace API Environment is powered by ``tornado.web.Application``. To implement a custom HTTP API handler, use the ``add_handlers`` method (see the ``tornado.web`` `official documentation <http://www.tornadoweb.org/en/stable/web.html>`__ for details). 

  .. tip::
     You can inherit from some ready-to-use HTTP API Handlers in your plugin (see :ref:`plugins`).

.. toctree::
   :maxdepth: 1
   :caption: In this chapter:

   rest_api
   plugins






