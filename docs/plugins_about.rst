.. _plugins-about:

Basics
=============================

This section will give you a general idea of the ``findface-facenapi`` context.

.. rubric:: In this section:

.. contents::
   :local:


.. _wrap:

Wrapping MongoDB Objects into the ``Model`` Class
-------------------------------------------------------

Information about faces, galleries, cameras, persons, as well as authentication data are stored in the MongoDB database. The :py:class:`MongoStore` class provides a base for interaction between the ``findface-facenapi`` component and MongoDB objects, being a wrapper around the MongoDB object collection. ``MongoStore`` wraps each object, returned in a MongoDB query, into an instance of the ``Model`` class (``[Objects].Model``, e.g. ``Faces.Model``, ``Galleries.Model``, etc.), so that the object can have its own methods and properties, and can be further processed through the ``findface-facenapi`` context. 

Implementing Authentication
---------------------------------

While the :py:class:`MongoStore` class creates a base for interaction between ``findface-facenapi`` and MongoDB objects (see :ref:`wrap`), it doesn't call for authentication. To provide it, the following ``MongoStore`` subclasses are used:

* The :py:class:`UserStore` class provides user-based authentication. It ensures that passing an unauthenticated request will cause an error, instead of security vulnerabilities. Each class that represents a collection of objects (faces, galleries, persons, etc.) inherits from ``UserStore``. 
* The :py:class:`Users` class stores the authentication credentials as user objects. Both a user id and user object are qualified for authentication and can be passed to methods that require it.


Common Object Types
-------------------------

Rectangle
^^^^^^^^^^^^^^^^^^^^^^^^^^

Stores coordinates of a face bounding box in the original image as ``Rectangle('x1', 'y1', 'x2', 'y2')``, where:

* ``left``: x coordinate of the top-left corner of the bounding box, *float*.
* ``top``: y coordinate of the top-left corner of the bounding box, *float*.
* ``right``: x coordinate of the bottom-right corner of the bounding box, *float*. 
* ``bottom``: y coordinate of the bottom-right corner of the bounding box, *float*.

.. note::
   A bbox's coordinates can lie outside image boundaries and be negative.
 

``facenapi.core.extractors.ExtractionFace``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``facenapi.core.extractors.ExtractionFace`` object represents a dictionary of face data returned from ``ctx.extractor.extract()``. It can be converted into a ``Faces.Model`` instance by using :py:meth:`Faces.Model.from_extraction_face`.

The ``facenapi.core.extractors.ExtractionFace`` dictionary have the following keys:

* ``bbox``: coordinates of the face region in the original image (bbox)
* ``normalized``: normalized face image, bytes of the ``.png`` file
* ``facen``: (optional) face feature vector, *base64* 
* ``gender``: (optional) 'male' or 'female', *str* 
* ``age``: (optional) estimated age, *float*
* ``emotions``: (optional) emotions with relevant probability, *namedtuple*
* ``'score'``: face image quality, *float*
*  ``'photo_hash'``: hash of the original photo, *str*

.. _face:

Face object
^^^^^^^^^^^^^^^^^^^^^

Being wrapped into the ``Faces.Model`` class, a face object represents a dictionary ``face`` with the following keys:

* ``"id" (number)``: unique identifier of the face
* ``'bbox'``: coordinates of the face region in the original image (bbox)  
* ``'facen'``: (optional) face feature vector, *base64*
* ``'gender'``: (optional) 'male' or 'female', *str*
* ``'age'``: (optional) estimated age, *float*
* ``'emotions'``: (optional) 2 most prevalent emotions, *tuple*
* ``'normalized'``: normalized face image, bytes of the ``.png`` file
* ``'score'``: face image quality, *float*

  .. note::
     You can interpret the face image quality as follows. Upright faces in frontal position are considered the best quality. They result in values around 0, mostly negative (such as -0.00067401276, for example). Inverted faces and large face angles are estimated with negative values some -5 and less.

* ``'timestamp'``: (optional) time of the face object creation as ISO8601 string
* ``'photo'``: (optional) URL of the original image used to create the face object
*  ``'photo_hash'``: hash of the original photo, *str*
*  ``'thumbnail'``: (optional) URL of the face thumbnail
*  ``'meta'``: (optional) metadata string that you can use to store any information associated with the face
*  ``'galleries'``: (optional) list of galleries that feature the face.

A collection of face objects is stored in the ``Faces`` class.

Implementing Collections of MongoDB Objects
-----------------------------------------------

Each collection of MongoDB objects is implemented as the ``[Objects]`` class and consists of instances of the relevant ``[Objects].Model`` class. For example, to work with a face and person collections, you have to refer respectively to the ``Faces`` and ``Persons`` classes; with a face and person objects - to ``Faces.Model`` and ``Persons.Model``, etc.

Each collection class inherits from :py:class:`UserStore`. 
 



