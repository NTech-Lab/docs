.. _prerequisites:

Prerequisite Software
------------------------------

In order to run successfully, FindFace Server needs the following software:

+---------------+--------------------------------------------------------------------------------+----------------------------------+
| Prerequisite  | Usage                                                                          | Installation                     |
| software      |                                                                                |                                  |
+===============+================================================================================+==================================+
| MongoDB       | Internal database that provides proper functioning of FindFace Server.         | Manually, before installing      |
|               | Stores faces metadata, galleries details, settings and other internal data.    | the FindFace Server components   |
+---------------+--------------------------------------------------------------------------------+----------------------------------+
| Tarantool     | Stores faces vector data.                                                      | Automatically along with         |
|               |                                                                                | the tntapi component.            |
+---------------+--------------------------------------------------------------------------------+----------------------------------+

.. rubric:: In this section:

.. contents::
   :local:

   
.. include:: mongodb.rst
   
.. include:: tarantool.rst
