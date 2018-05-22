.. _plugin-methods:


Methods
--------------------------

.. rubric:: In this section:

.. contents::
   :local:



Class ``Faces.Model``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents a face object. Allows for retrieving such face data as coordinates of the face region (a.k.a. bbox), the result of face normalization, and a face feature vector (facen).


Property ``bbox``
"""""""""""""""""""""""""""""""""""""

Represents a bounding box (rectangle) around a face in the original image. Coordinates of a bbox are stored in a ``Rectangle`` object as ``namedtuple([x1,y1,x2,y2])``, where:

* ``x1``: x coordinate of the top-left corner of the bounding box, *float*.
* ``y1``: y coordinate of the top-left corner of the bounding box, *float*.
* ``x2``: x coordinate of the bottom-right corner of the bounding box, *float*. 
* ``y2``: y coordinate of the bottom-right corner of the bounding box, *float*.


.. note::
   A bbox's coordinates can lie outside image boundaries and be negative.

.. rubric:: Getter 

``bbox(self)``

.. rubric:: Returns:

Coordinates of a bbox.

.. rubric:: Return type:

``Rectangle(self['x1'], self['y1'], self['x2'], self['y2'])``

.. rubric:: Setter

``bbox(self, bbox)``

Updates the bbox coordinates.


Property ``facen``
""""""""""""""""""""""""""

Represents a face feature vector.

.. rubric:: Getter

``facen(self)``

.. rubric:: Returns:

Face feature vector. 

.. rubric:: Return type:

``base64``


Method ``get_normalized``
""""""""""""""""""""""""""""""""

Returns a normalized face image.

``get_normalized(self)``

.. rubric:: Returns:

Result of face normalization.

.. rubric:: Return type:

Bytes of the ``.png`` file.


Method ``from_extraction_face``
""""""""""""""""""""""""""""""""""""""""

Creates a face object as an instance of the ``Faces.Model`` class.

``from_extraction_face(cls, eface)``

.. rubric:: Parameters:

* ``eface``: set of face data received from ``ctx.extractor.extract()``. This set always includes a bbox (``Rectangle(self['x1'], self['y1'], self['x2'], self['y2'])``) and normalized face image (bytes of the ``.png`` file). ``Facen``, ``gender``, ``age`` and ``emotions`` properties can be ``None``.

.. rubric:: Returns:

Face object.

.. rubric:: Return type:

Face object is wrapped into the ``Faces.Model`` class as a dictionary ``face`` with the following *key: value* pairs:

* ``'bbox'``: coordinates of the face region in the original image (bbox), ``Rectangle(self['x1'], self['y1'], self['x2'], self['y2'])``  
* ``'facen'``: (optional) face feature vector, *base64*
* ``'gender'``: (optional) 'male' or 'female', *string*
* ``'age'``: (optional) estimated age, *float*
* ``'emotions'``: (optional) 2 most prevalent emotions, *list*
* ``'normalized'``: bytes of the ``.png`` file
* ``'score'``: face image quality, *float*  

  .. note::
     You can interpret the face image quality as follows. Upright faces in frontal position are considered the best quality. They result in values around 0, mostly negative (such as -0.00067401276, for example). Inverted faces and large face angles are estimated with negative values some -5 and less.



Class ``Faces``
^^^^^^^^^^^^^^^^^^^^^^^^

Represents a collection of faces. Each face in the collection has the following properties:

* ``_id`` - primary key, *uint64*
* ``owner`` - owner id, *ObjectId*
* ``facen`` - feature vector, *base64*
* ``bbox`` - coordinates of the face region in the original image (bbox), ``Rectangle(self['x1'], self['y1'], self['x2'], self['y2'])``
* ``photo_hash`` - md5 of the original image
* ``gallery`` - galleries that feature the face, *list*
* ``meta`` - metadata string, can be empty



Method ``add``
"""""""""""""""""""""""

Enrols a face object to MongoDB, adding such parameters as ``_id``and ``owner``, and returns the updated face object. If the face has no id, this method generates a new id and inserts it into the face object. If the added face already has an id, this method fails at the attempt to insert a new id. In the case of a conflict, this method retries with another id up to 3 times. 

.. important::
   As this method updates only MongoDB and not the facen storage (``tntapi``), you will have to call ``add_to_galleries`` after this method in order to add a face to a gallery.  

``add(self, user, face)``

.. rubric:: Parameters:

* ``user``: ``owner`` property passed as a user id, *ObjectId*, or user object. Required for authentication
* ``face``: face object

.. rubric:: Returns:

Updated face object.

.. rubric:: Return type:

Instance of the ``Face.Model`` class.

.. rubric:: Usage:

.. code::

   face = self.ctx.faces.Model.from_extraction_face(eface)
   face['meta'] = meta
   face = await self.ctx.faces.add(self.user, face)


Method ``regenerate_id``
"""""""""""""""""""""""""""""""

Replaces a face's id with a newly generated one.

``regenerate_id(self, face)``                     

.. rubric:: Parameters:

``face``: face object

.. rubric:: Returns:

Does not return any value.


Method ``add_to_galleries``
"""""""""""""""""""""""""""""""""""

Adds a face to specified galleries in MongoDB and the facen storage (``tntapi``). This method first attempts to add a face to galleries in the facen storage. In the case of success, it updates the face ``gallery`` field in MongoDB. If the face already exists in the facen storage gallery, the method generates an error.           

``add_to_galleries(self, face, galleries)``

.. rubric:: Parameters:

* ``face``: face object
* ``galleries``: gallery names, list of strings

.. rubric:: Returns:

Does not return any value.


Method ``del_from_galleries``
"""""""""""""""""""""""""""""""""""

Removes a face from specified galleries in MongoDB and the facen storage (``tntapi``). This method first attempts to remove a face from galleries in the facen storage. In the case of success, it updates the face ``gallery`` field in MongoDB. If the face doesn't exist in the facen storage gallery, it is considered to be successfully removed. 

``del_from_galleries(self, face, galleries)``

.. rubric:: Parameters:

* ``face``: face object
* ``galleries``: gallery names, list of strings

.. rubric:: Returns:

Does not return any value.
   


Method ``identify``
"""""""""""""""""""""""""""

Search galleries for faces that resemble a given ``face`` with matching confidence larger or equal to the ``threshold``. 

``identify(self, user, gallery, face, limit, threshold, filters=None, ignore_errors=False)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication 
* ``gallery``: galleries to search in, list of strings
* ``face``: either face object, or ``eface`` received from ``ctx.extractor.extract()`` 
* ``limit``: maximum number of returned faces, *integer*
* ``threshold``: minimum matching confidence between the given and returned faces, from 0 (lowest) to 1 (highest), *float*
* ``filters=``: additional filters from the MongoDB query dictionary
* ``ignore_errors``: if ``false`` and one or several ``tntapi`` shards are out of service, an error is returned. If ``true``, no error is generated and available ``tntapi`` shards are used to obtain face identification results, indicating the number of live servers vs the total number of servers in the results. 

.. rubric:: Returns:

Results that feature properties of each found face in order of decreasing confidence.

.. rubric:: Return type:

``results``: list-like object with the following properties: 

* ``results.live_server``: the number of ``tntapi`` shards used to obtain face identification results (only if ``ignore_errors=True``)
* ``results.total_servers``: the total number of ``tntapi`` shards in the system (only if ``ignore_errors=True``)
* ``results[x]``: namedtuple ``IdentifyResult`` featuring ``face`` and ``confidence``
* ``results[x].face``: face object
* ``results[x].confidence``: matching confidence, *float*


Class ``Galleries``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents a collection of galleries. Each gallery in the collection has the following properties:

* ``owner`` - owner id, *ObjectId*
* ``name`` - gallery name, *string*



Method ``add``
""""""""""""""""""""""""

Creates a gallery in MongoDB and returns it as an instance of the ``Galleries.Model`` class.

``add(self, user, gallery)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``gallery``: gallery name, *string*

.. rubric:: Returns:

* Gallery object if the gallery name is unique
* Error if the gallery name is not specified or already exists in the database.

.. rubric:: Return type:

Instance of the ``Galleries.Model`` class, or ``ValueError``


Class ``MongoStore``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents a wrapper around the MongoDB collection of objects. ``MongoStore`` is used to wrap an object into an instance of the ``Model`` class, so that you can work with this object by using methods described below. 

.. note::
   Objects can be of any type: face, gallery, camera, user, etc. ``MongoStore`` wraps them respectively into ``Faces.Model``, ``Galleries.Model``, ``Cameras.Model``, ``Users.Model``, etc.

Method ``find``
""""""""""""""""""""

Search for MongoDB objects that meet given requirements.

``find(self, filters, sort=None, skip=None, limit=None)``

.. rubric:: Parameters:

* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``skip``: elements of the MongoDB query dictionary to skip
* ``limit``: maximum number of returned objects

.. rubric:: Returns:

MongoDB objects

.. rubric:: Return type:

List of instances of the ``Model`` class.

Method ``find_one``
""""""""""""""""""""""""

Returns the first MongoDB object that meets given requirements.

``find_one(self, filters, sort=None, skip=None)``

.. rubric:: Parameters:

* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``skip``: elements of the MongoDB query dictionary to skip

.. rubric:: Returns:

MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.


Method ``count``
"""""""""""""""""""""""" 

Returns the total number of MongoDB objects of a certain type.

``count(self, filters, sort=None, skip=None, limit=None)``

.. rubric:: Parameters:

* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``skip``: elements of the MongoDB query dictionary to skip
* ``limit``: maximum number of returned objects

.. rubric:: Returns:

The number of MongoDB objects.

.. rubric:: Return type:

Number.


Method ``remove_one``
"""""""""""""""""""""""""""

Removes the first MongoDB object that meets given requirements.

``remove_one(self, filters, sort=None)``

.. rubric:: Parameters:

* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by

.. rubric:: Returns:

Removed MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.


Method ``update_one``
""""""""""""""""""""""""

Updates a specified MongoDB object.

``update_one(self, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs)``

.. rubric:: Parameters:

* ``filters``: filters from the MongoDB query dictionary
* ``update``: object property to update
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``**kwargs``: optional arguments that the method takes

.. rubric:: Returns:

Updated MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.


Method ``wrap_in_model``
""""""""""""""""""""""""""""""""

Wraps a MongoDB object into the ``Model`` class.

``wrap_in_model(self, obj)``

.. rubric:: Parameters:

* ``obj``: MongoDB object, *dict* or *OrderedDict*

.. rubric:: Returns:

MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.



Class ``UserStore``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Inherits from the ``MongoStore`` class. Provides authentication for all user owned objects by ensuring that passing an unauthenticated request will cause an error instead of security vulnerabilities.


Method ``find``
""""""""""""""""""""

Search for MongoDB objects that meet given requirements.

``find(self, user, filters, sort=None, skip=None, limit=None)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``skip``: elements of the MongoDB query dictionary to skip
* ``limit``: maximum number of returned objects

.. rubric:: Returns:

MongoDB objects

.. rubric:: Return type:

List of instances of the ``Model`` class.



Method ``find_one``
""""""""""""""""""""""""

Returns the first MongoDB object that meets given requirements.

``find_one(self, user, filters, sort=None, skip=None)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``skip``: elements of the MongoDB query dictionary to skip

.. rubric:: Returns:

MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.

Method ``count``
"""""""""""""""""""""""" 

Returns the total number of MongoDB objects of a certain type.

``count(self, user, filters, sort=None, skip=None, limit=None)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``skip``: elements of the MongoDB query dictionary to skip
* ``limit``: maximum number of returned objects

.. rubric:: Returns:

The number of MongoDB objects.

.. rubric:: Return type:

Number.


Method ``remove_one``
"""""""""""""""""""""""""""

Removes the first MongoDB object that meets given requirements.

``remove_one(self, user, filters, sort=None)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``filters``: filters from the MongoDB query dictionary
* ``sort``: elements of the MongoDB query dictionary to sort by

.. rubric:: Returns:

Removed MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.


Method ``update_one``
""""""""""""""""""""""""

Updates a specified MongoDB object.

``update_one(self, user, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``filters``: filters from the MongoDB query dictionary
* ``update``: MongoDB object property to update
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``**kwargs``: optional arguments that the method takes

.. rubric:: Returns:

Updated MongoDB object.

.. rubric:: Return type:

Instance of the ``Model`` class.


Method ``update_many``
""""""""""""""""""""""""""

Update specified MongoDB objects.

``update_many(self, user, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``filters``: filters from the MongoDB query dictionary
* ``update``: MongoDB object property to update
* ``sort``: elements of the MongoDB query dictionary to sort by
* ``**kwargs``: optional arguments that the method takes

.. rubric:: Returns:

Updated MongoDB objects.

.. rubric:: Return type:

Instances of the ``Model`` class.


Class ``Users``
^^^^^^^^^^^^^^^^^^^^^^^^

Represents a collection of user objects. Each user object in the collection has the following properties:

* ``_id`` - primary key, *ObjectId*
* ``token`` - authentication token, must be unique, *string*
* ``active`` - allows user to perform requests, *bool*

Each face and gallery in the system must belong to a certain user. User objects are also used for authentication. 

Method ``add``
""""""""""""""""""""

Enrols a new user to the database and returns it as an instance of the ``Users.Model`` class.

``add(self, user)``

.. rubric:: Parameters:

* ``user``: user data, *dictionary*

.. rubric:: Returns:

User object.

.. rubric:: Return type:

Instance of the ``Users.Model`` class.


Class ``Counters``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Used to generate a new id for a face or a person.

Method ``next(self, counter)``
""""""""""""""""""""""""""""""""""

Increments the counter and returns its new value.

``next(self, counter)``

.. rubric:: Parameters:

* ``counter``: current value of the counter, integer

.. rubric:: Returns:

New value of the counter.

.. rubric:: Return type: 

``seq``: new value, *integer*, or TypeError/ValueError if the current value is invalid


Class ``Cameras``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents a collection of cameras for video face detection.

Method ``add``
"""""""""""""""""""""

Adds a camera to your system and returns it as an instance of the ``Cameras.Model`` class.

``add(self, user, camera)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``camera``: camera data, *dictionary*

.. rubric:: Returns:

Camera object.

.. rubric:: Return type:

Instance of the the ``Cameras.Model`` class.


Class ``ServerFaces``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Extends functionality of the ``Faces`` class. Supports upload of original images, normalized images and thumbnails to the ``Uploads`` folder.

Method ``gen_ffupload_key``
"""""""""""""""""""""""""""""""""""""""""""

Populates the ``photo``, ``thumbnail`` and ``normalized`` fields of a face object with relevant links to the original image, thumbnail and normalized image in the ``Uploads`` folder. These links will be used when invoking the ``upload`` method. 

``gen_ffupload_key(cls, face, suffix='.jpeg')``

.. rubric:: Parameters:

* ``face``: face object, or face data, dictionary
* ``suffix``: image file extension

.. rubric:: Returns:

Links 

.. rubric:: Return type:

``'%s/%s/%d_%s%s'  % (face['owner'], now.strftime('%Y%m%d'), face['_id'], token_hex(6), suffix)``


Method ``upload_thumbnail``
"""""""""""""""""""""""""""""""""

Uploads a face thumbnail to the ``Uploads`` folder.

``upload_thumbnail(self, face, img: Image, url=None)``

.. rubric:: Parameters:

* ``face``: face object, or ``eface`` received from ``ctx.extractor.extract()``
* ``img``: original image, ``facenapi.core.image.Image``
* ``url``: upload URL

.. rubric:: Returns:

Does not return any value.

Method ``regenerate_id``
""""""""""""""""""""""""""""""

Regenerates a face id and URLs of the relevant original image, normalized face image, and the thumbnail (as they contain the face id).

``regenerate_id(self, face)``

.. rubric:: Parameters:

* ``face``: face object

.. rubric:: Returns:

Does not return any value.


Method ``upload``
"""""""""""""""""""""""

Uploads an original image, normalized face image and a thumbnail to the ``Uploads`` folder.

``upload(self, face, img)``

.. rubric:: Parameters:

* ``face``: face object, assigned the ``normalized`` property, or ``eface`` received from ``ctx.extractor.extract()``
* ``img``: original image, ``facenapi.core.image.Image``

.. rubric:: Returns:

Does not return any value.


Class ``Persons``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents a collection of persons. Used to implement the advanced functions of :ref:`Dynamic Person Creation <persons>` and :ref:`'Friend and Foe' Identification <friend>`. 

Each person object in the collection has the following properties:

* ``_id``: person_id, *uint64*
* ``owner``: owner id, *ObjectId*


Method ``add``
""""""""""""""""""""""

Creates a person and returns it as a ``Persons.Model`` instance. 

``add(self, user, person)``


.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication. Used to populate the ``owner`` property.
* ``person``: person data, dictionary

.. rubric:: Returns:

Person object.

.. rubric:: Return type:

Instance of the ``Persons.Model`` class.


Method ``identify``
"""""""""""""""""""""""""

Search galleries for persons whose faces resemble a given ``face`` with matching confidence larger or equal to the ``threshold``.                    

``identify(self, user, face, gallery, threshold, create=False, filters=None)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``face``: face object, or ``eface`` received from ``ctx.extractor.extract()``
* ``gallery``: galleries to search in, list of strings
* ``threshold``: minimum matching confidence between the given and returned faces, from 0 (lowest) to 1 (highest), *float*
* ``create=False``: if ``create=True`` and no similar faces were found, the method creates a new person and returns ``person_id``
* ``filters=None``: filters from the MongoDB query dictionary

.. rubric:: Returns:

``person_id`` of found persons, or ``person_id`` of a newly created person if no similar faces were found. 

.. rubric:: Return type:

``_id``: *uint64*



Method ``is_friend``
"""""""""""""""""""""""""""

Checks if a given ``person_id`` belongs to a friend for a certain camera. 

``is_friend(self, user, person_id, cam_id)``

.. rubric:: Parameters:

* ``user``: user id, *ObjectId*, or user object. Required for authentication
* ``person_id``: person_id, *uint64*
* ``cam_id``: camera id, *string*

.. rubric:: Returns:

``True`` if a given ``person_id`` belongs to a friend, and ``False`` otherwise.

.. rubric:: Return type:

Boolean




