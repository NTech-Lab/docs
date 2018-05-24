.. _galleries:

Galleries
-------------------------

There is always a gallery titled default. Faces are always added to the default gallery and cannot be removed from it. The default gallery cannot be stopped. 

In addition to the default gallery, you can create custom galleries and add faces into them. Custom galleries allows you to have several datasets in one environment. This might be useful if you need to search through different face lists, for example if you have several products
or several customers with different face datasets.

To create a custom gallery, use the method :ref:`POST /galleries/gallery_name <gallery-post>`.

By default, all API methods apply to the default gallery. However, you can narrow down usage of most methods to a specific gallery (see the
table below). To do so, provide the gallery name in your API request URI. For example, to search a person in a gallery 'ppl', use ``POST /faces/gallery/ppl/identify/`` instead of ``POST /identify/``.

+-----------------------------+-----------------------------------------------+
| Default gallery method      | Custom gallery method                         |
+=============================+===============================================+
| ``POST /identify/``         | ``POST /faces/gallery/<Gallery>/identify/``   |
+-----------------------------+-----------------------------------------------+
| ``GET /faces/``             | ``GET /faces/gallery/<Gallery>/``             |
+-----------------------------+-----------------------------------------------+
| ``GET /face/meta/<Meta>``   | ``GET /face/gallery/<Gallery>/meta/<Meta>``   |
+-----------------------------+-----------------------------------------------+
| ``GET /meta/``              | ``GET /meta/gallery/<Gallery>/``              |
+-----------------------------+-----------------------------------------------+


