.. _plugin-methods:


Classes and Methods
--------------------------

This section provides a full reference to the ``findface-facenapi`` context you can use in your plugin.

.. tip::
   Use ``ctx`` from the  ``activate`` parameters to access classes and methods directly from a plugin, e.g. use ``ctx.faces.Model.from_extraction_face(eface)`` to invoke :py:meth:`Faces.Model.from_extraction_face`. To refer to classes and methods in a class that inherits from a HTTP API handler, use ``self.ctx``: ``self.ctx.faces.Model.from_extraction_face(eface)``.

.. rubric:: In this section:

.. contents::
   :local:


Basic Classes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. py:class:: MongoStore

   Information about faces, galleries, cameras, persons, as well as authentication data are stored in the MongoDB database. The ``MongoStore`` class provides a base for interaction between ``findface-facenapi`` and MongoDB objects, being a wrapper around the MongoDB object collection. ``MongoStore`` wraps each object returned in a MongoDB query into an instance of the ``Model`` class (``[Objects].Model``), so that the object can have its own methods and properties and can be further processed through the ``findface-facenapi`` context. 

   .. note::
      Objects can be of any type: face, gallery, camera, user, etc. ``MongoStore`` wraps them respectively into ``Faces.Model``, ``Galleries.Model``, ``Cameras.Model``, ``Users.Model``, etc.

   .. py:method:: find(self, filters, sort=None, skip=None, limit=None)

      Searches for MongoDB objects that meet given requirements.

      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :param skip: (optional) criteria for skipping some of MongoDB objects
      :type skip: elements of the MongoDB query dictionary or None
      :param limit: (optional) maximum number of returned objects
      :type limit: int or None
      :return: Objects of a certain type
      :rtype: List of instances of the ``[Objects].Model`` class

   .. py:method:: find_one(self, filters, sort=None, skip=None)

      Returns the first MongoDB object that meets given requirements.

      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :param skip: (optional) criteria for skipping some of MongoDB objects
      :type skip: elements of the MongoDB query dictionary or None
      :return: Object of a certain type
      :rtype: ``[Objects].Model`` instance

   .. py:method:: count(self, filters, sort=None, skip=None, limit=None)

      Returns the total number of MongoDB objects of a certain type.

      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :param skip: (optional) criteria for skipping some of MongoDB objects
      :type skip: elements of the MongoDB query dictionary or None
      :param limit: (optional) maximum number of counted objects
      :type limit: int or None
      :return: Number of objects of a certain type
      :rtype: int


   .. py:method:: remove_one(self, filters, sort=None)

      Removes the first MongoDB object that meets given requirements.

      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :return: Removed object
      :rtype: ``[Objects].Model`` instance


   .. py:method:: update_one(self, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs)

      Updates a specified MongoDB object.

      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param update: object property to update
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :return: Updated object
      :rtype: ``[Objects].Model`` instance

   .. py:method:: wrap_in_model(self, obj)

      Wraps a MongoDB object into the ``Model`` class.

      :param obj: MongoDB object
      :type obj: dict or OrderedDict
      :return: Object of a certain type
      :rtype: ``[Objects].Model`` instance


.. py:class:: UserStore(MongoStore)

   Inherits from the :py:class:`MongoStore` class. While ``MongoStore`` creates a base for interaction between ``findface-facenapi`` and MongoDB objects, the ``UserStore`` class provides user-based authentication for such interaction. It ensures that passing an unauthenticated request will cause an error instead of security vulnerabilities.


   .. py:method:: find(self, user, filters, sort=None, skip=None, limit=None)

      Searches for MongoDB objects that meet given requirements.
      
      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :param skip: (optional) criteria for skipping some of MongoDB objects
      :type skip: elements of the MongoDB query dictionary or None
      :param limit: (optional) maximum number of returned objects
      :type limit: int or None
      :return: Objects of a certain type
      :rtype: List of instances of the ``[Objects].Model`` class

   .. py:method:: find_one(self, user, filters, sort=None, skip=None)

      Returns the first MongoDB object that meets given requirements.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :param skip: (optional) criteria for skipping some of MongoDB objects
      :type skip: elements of the MongoDB query dictionary or None
      :return: Object of a certain type
      :rtype: ``[Objects].Model`` instance

   .. py:method:: count(self, user, filters, sort=None, skip=None, limit=None)

      Returns the total number of MongoDB objects of a certain type.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :param skip: (optional) criteria for skipping some of MongoDB objects
      :type skip: elements of the MongoDB query dictionary or None
      :param limit: (optional) maximum number of counted objects
      :type limit: int or None
      :return: Number of objects of a certain type
      :rtype: int


   .. py:method:: remove_one(self, user, filters, sort=None)

      Removes the first MongoDB object that meets given requirements.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :return: Removed object
      :rtype: ``[Objects].Model`` instance


   .. py:method:: update_one(self, user, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs)

      Updates a specified MongoDB object.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param update: object property to update
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :return: Updated object
      :rtype: ``[Objects].Model`` instance

   .. py:method:: update_many(self, user, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs)

      Updates specified MongoDB objects.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param filters: filters
      :type filters: elements of the MongoDB query dictionary or None
      :param update: object property to update
      :param sort: (optional) criteria for sorting MongoDB objects
      :type sort: elements of the MongoDB query dictionary or None
      :return: Updated objects
      :rtype: List of instances of the ``[Objects].Model`` class



User Enrollment
^^^^^^^^^^^^^^^^^^^^^^^^

.. py:class:: Users(MongoStore)

   Represents a collection of user objects. Each user object in the collection has the following properties:

   * ``_id`` - primary key, *ObjectId*
   * ``token`` - authentication token, must be unique, *string*
   * ``active`` - allows user to perform requests, *bool*

   Each face and gallery in the system must belong to a certain user. User objects are also used for authentication. 

   .. py:method:: ``add(self, user)``

      Enrolls a new user to the MongoDB database and returns it as an instance of the ``Users.Model`` class.

      :param dictionary user: user data
      :return: User object
      :rtype: ``Users.Model`` instance


Working with Faces and Galleries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. py:class:: Faces.Model(OrderedDict)

   Represents a face object.

   .. py:classmethod:: from_extraction_face(cls, eface)

      Creates a face object as an instance of the ``Faces.Model`` class.

      :param eface: set of face data received from ``ctx.extractor.extract()``
      :type eface: dictionary
      :return: Face object
      :rtype: ``Faces.Model`` instance


.. py:class:: Faces(UserStore)

   Represents a collection of faces. Each face in the collection has the following properties:

   * ``_id`` - primary key, *uint64*
   * ``owner`` - owner id, *ObjectId*
   * ``facen`` - feature vector, *base64*
   * ``bbox`` - coordinates of the face region in the original image (bbox), ``Rectangle(self['x1'], self['y1'], self['x2'], self['y2'])``
   * ``photo_hash`` - md5 of the original image
   * ``gallery`` - galleries that feature the face, *list*
   * ``meta`` - metadata, string or None

   .. py:method:: add(self, user, face)

      Enrolls a face object to MongoDB, adding such parameters as ``_id`` and ``owner``, and returns the updated face object. If the face has no id, this method generates a new id and inserts it into the face object. If the added face already has an id, this method fails at the attempt to insert a new id. In the case of a conflict, this method retries with another id up to 3 times. 

      .. important::
         As this method updates only MongoDB and not the facen storage (``tntapi``), you will have to call :py:meth:`Faces.add_to_galleries` after this method in order to add a face to a gallery. 

      :param user: face ``owner`` passed as a user id or user object
      :type user: ObjectId or ``Users.Model``
      :param face: face object
      :type face: ``Faces.Model`` instance
      :return: Updated face object
      :rtype: ``Faces.Model`` instance


      .. rubric:: Usage:

      .. code::

         face = ctx.faces.Model.from_extraction_face(eface)
         face['meta'] = meta
         face = await ctx.faces.add(self.user, face)

   .. py:method:: regenerate_id(self, face)

      Replaces a face's id with a newly generated one.

      :param face: face object
      :type face: ``Faces.Model`` instance
      :rtype: Void
              
   .. py:method:: add_to_galleries(self, face, galleries)

      Adds a face to specified galleries in MongoDB and the facen storage (``tntapi``). This method first attempts to add a face to galleries in the facen storage. In the case of success, it updates the face ``gallery`` field in MongoDB. If the face already exists in the facen storage gallery, the method generates an error.           

      :param face: face object
      :type face: ``Faces.Model`` instance
      :param galleries: gallery names
      :type galleries: list[str]
      :rtype: Void


   .. py:method:: del_from_galleries(self, face, galleries)

      Removes a face from specified galleries in MongoDB and the facen storage (``tntapi``). This method first attempts to remove a face from galleries in the facen storage. In the case of success, it updates the face ``gallery`` field in MongoDB. If the face doesn't exist in the facen storage gallery, it is considered to be successfully removed. 

      :param face: face object
      :type face: ``Faces.Model`` instance
      :param galleries: gallery names
      :type galleries: list[str]
      :rtype: Void

   
   .. py:method:: identify(self, user, gallery, face, limit, threshold, filters=None, ignore_errors=False)

      Searches galleries for faces that resemble a given ``face`` with matching confidence larger or equal to the ``threshold``. 

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param gallery: galleries to search in
      :type galleries: list[str]
      :param face: either a face object, or ``eface`` received from the ``ctx.extractor.extract()`` method
      :type face: ``Faces.Model`` or dictionary
      :param int limit: maximum number of returned faces
      :param float threshold: minimum matching confidence between the given and returned faces, from 0 (lowest) to 1 (highest)
      :param filters: (optional) filters
      :type filters: elements of the MongoDB query dictionary or None
      :param bool ignore_errors: (optional) If ``false`` and one or several ``tntapi`` shards are out of service, an error is returned. If ``true``, no error is generated and available ``tntapi`` shards are used to obtain face identification results, indicating the number of live servers vs the total number of servers in the results. 
      :return: Results that feature properties of each found face in order of decreasing confidence.
      :rtype: List-like object ``results``

      The ``results`` object features the following properties: 

      * ``results.live_server``: number of ``tntapi`` shards used to obtain face identification results (only if ``ignore_errors=True``)
      * ``results.total_servers``: total number of ``tntapi`` shards in the system (only if ``ignore_errors=True``)
      * ``results[x]``: namedtuple ``IdentifyResult`` featuring ``face`` and ``confidence``. 
      * ``results[x].face``: face object
      * ``results[x].confidence``: matching confidence, *float*

.. py:class:: ServerFaces(CoreFaces)

   Extends functionality of the ``Faces`` class. Supports upload of original images, normalized images and thumbnails to the ``Uploads`` folder.

   .. py:method:: gen_ffupload_key(cls, face, suffix='.jpeg')

      Populates the ``photo``, ``thumbnail`` and ``normalized`` fields of a face object or a dictionary with relevant links to the original image, thumbnail and normalized image in the ``Uploads`` folder. These links will be used when invoking :py:meth:`ServerFaces.upload`. 

      :param face: face object or face data
      :type face: ``Faces.Model`` instance or dictionary
      :param str suffix: (optional) suffix to the name of the image file
      :return: Links
      :rtype: '%s/%s/%d_%s%s'  % (face['owner'], now.strftime('%Y%m%d'), face['_id'], token_hex(6), suffix)


   .. py:method:: upload_thumbnail(self, face, img: Image, url=None)

      Uploads a face thumbnail to the ``Uploads`` folder or specified URL.

      :param face: either a face object, or ``eface`` received from the ``ctx.extractor.extract()`` method
      :type face: ``Faces.Model`` or dictionary
      :param img: original image ``facenapi.core.image.Image``
      :param url: upload URL
      :rtype: Void

   .. py:method:: regenerate_id(self, face)

      Regenerates a face id and URLs of the relevant original image, normalized face image, and the thumbnail (as they contain the face id).

      :param face: face object
      :type face: ``Faces.Model`` instance
      :rtype: Void

   .. py:method:: upload(self, face, img)

      Uploads an original image, normalized face image and a thumbnail to the ``Uploads`` folder.

      :param face: either a face object, assigned the ``normalized`` property, or ``eface`` received from the ``ctx.extractor.extract()`` method
      :type face: ``Faces.Model`` or dictionary
      :param img: original image ``facenapi.core.image.Image``
      :rtype: Void

.. py:class:: Galleries(UserStore)

   Represents a collection of galleries. Each gallery in the collection has the following properties:

   * ``owner`` - owner id, *ObjectId*
   * ``name`` - gallery name, *string*

   .. py:method:: add(self, user, gallery)

      Creates a gallery in MongoDB and returns it as an instance of the ``Galleries.Model`` class.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param gallery: gallery name
      :type gallery: str
      :return: Gallery object
      :rtype: ``Galleries.Model`` instance
      :raise ValueError: if the gallery name is not specified or already exists in MongoDB



Adding Camera
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. py:class:: Cameras(UserStore)
   
   Represents a collection of cameras for video face detection.

   .. py:method:: ``add(self, user, camera)``

      Adds a camera to your system and returns it as an instance of the ``Cameras.Model`` class.

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param camera: camera data
      :type camera: dictionary
      :return: Camera object
      :rtype: ``Cameras.Model`` instance


Working with Persons
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. py:class:: Persons(UserStore)
   
   Represents a collection of persons. Used to implement the advanced functions of :ref:`Dynamic Person Creation <persons>` and :ref:`'Friend and Foe' Identification <friend>`. 

   Each person object in the collection has the following properties:

   * ``_id``: person_id, *uint64*
   * ``owner``: owner id, *ObjectId*


   .. py:method:: add(self, user, person)

      Creates a person and returns it as a ``Persons.Model`` instance. 

      :param user: user id or user object (for authentication and to populate the ``owner`` property)
      :type user: ObjectId or ``Users.Model``
      :param dictionary person: person data
      :return: Person object
      :rtype: ``Persons.Model`` instance
     

   .. py:method:: identify(self, user, face, gallery, threshold, create=False, filters=None)

      Searches galleries for persons whose faces resemble a given ``face`` with matching confidence larger or equal to the ``threshold``.                    

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param face: either a face object, or ``eface`` received from the ``ctx.extractor.extract()`` method
      :type face: ``Faces.Model`` or dictionary
      :param gallery: galleries to search in
      :type galleries: list[str]
      :param float threshold: minimum matching confidence between the given and returned faces, from 0 (lowest) to 1 (highest)
      :param bool create: (optional) if ``True`` and no similar faces were found, the method creates a new person and returns ``person_id`` 
      :param filters: (optional) filters
      :type filters: elements of the MongoDB query dictionary or None
      :return: ``person_id`` of found persons, or ``person_id`` of a newly created person if no similar faces were found.
      :rtype: uint64 or list[uint64]


   .. py:method:: is_friend(self, user, person_id, cam_id)

      Checks if a person is a friend, for a given camera. 

      :param user: user id or user object (for authentication)
      :type user: ObjectId or ``Users.Model``
      :param uint64 person_id: person_id of the person
      :param str cam_id: camera id
      :return: ``True`` if the person is a friend, and ``False`` otherwise.
      :rtype: bool


Auxiliary Classes
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. py:class:: Counters(MongoStore)
  
   Used to generate a new id for an object.

   .. py:method:: next(self, counter)

      Increments the counter and returns its new value.

      :param int counter: current value of the counter
      :return: New value of the counter ``seq``
      :rtype: int
      :raise TypeError: if the current value is not found
      :raise ValueError: if the current value is invalid


