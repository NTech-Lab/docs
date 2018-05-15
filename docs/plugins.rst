.. _plugins:

Extend Functionality with Plugins
========================================================

By default, the ``findface-facenapi`` component follows a predefined set of behaviour traits. That implies certain limitations on its functionality. Using plugins can significantly extend the scope of tasks that ``findface-facenapi`` is capable of fulfilling. 

Here are just few examples of how you can implement the plugins to your system: 

.. note::
   To write a plugin, you require good command of the Python programming language.

* By default, the ``fkvideo_detector`` component does not process the ``findface-facenapi`` responses to its face identification and camera operation API requests. You can use a plugin as a proxy script that will manage communication between ``fkvideo_detector`` and ``findface-facenapi`` and redirect API responses to an application that can process and render them.
* Use plugins to send the facial recognition results to a websocket or save them to a file.

.. rubric:: In this section:

.. contents::
   :local:


Functions and Methods
----------------------------------------------

The ``facenapi`` code includes so called the ``core`` and ``server`` parts (``facenapi.core.models`` and ``facenapi.server.models``), with the ``server`` being an extension of the ``core``. This section will introduce you to all the ``core`` and ``server`` functions, classes and class methods you can refer to when writing a plugin. 

.. important::
   You are likely to build the plugin code around the ``Server.Faces`` and ``Person`` classes. 


Looking into ``findface.core.models``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To implement the ``facenapi.core.models`` functionality to your plugin, refer to the following modules content:

* ``face``
* ``gallery``
* ``mongo_store``
* ``users``
* ``counters`` 

Module ``face``: imports
"""""""""""""""""""""""""""""""""""""""""""""""""

The ``face`` module uses the following imports: 

.. code::
  
   import logging
   from collections import OrderedDict, namedtuple, UserList

   import motor
   import pymongo.errors
   from pymongo.collection import ReturnDocument

   from ..id_generator import AbstractIdGenerator
   from ..rectangle import Rectangle
   from .mongo_store import UserStore
   from ..facen_storage import AbstractFacenStorage, NotFoundError
   from ..utils import mongo_retry
   from ..bbox import rect_to_bbox_dict

   logger = logging.getLogger(__name__)


.. _faces.model:

Module ``face``: class ``Faces``
"""""""""""""""""""""""""""""""""""

The global class ``Faces`` represents a collection of instances of the private class ``_Face`` and calls the latter by using the ``Model`` class (``Faces.Model = _Face``). 

.. rubric:: Class ``Faces.Model``

The ``Faces.Model`` (``_Face``) class stores such properties of a detected face as coordinates of the face region (a.k.a. bbox), the result of face normalization, a face feature vector (facen), gender, age and emotions information, and allows for extracting these data from a given image.

.. code::

   class _Face(OrderedDict):
       def __init__(self, *args, **kwargs):
           super().__init__(*args, **kwargs)
           self.normalized = None

       @property
       def bbox(self):
           """Return face coordinates using the Rectangle method (imported from the rectangle module)."""
           return Rectangle(self['x1'], self['y1'], self['x2'], self['y2'])

       @bbox.setter
       def bbox(self, bbox):
           """Update face coordinates using the Rectangle method."""
           self['x1'], self['y1'], self['x2'], self['y2'] = bbox
 
       async def get_normalized(self):
           if self.normalized:
               return self.normalized
           raise NotImplementedError
  
       @property
       def facen(self):
           return self['facen']

       @classmethod
       def from_extraction_face(cls, eface):
           """Create Faces.Model instance from ExtractionFace instance."""
           face = cls(rect_to_bbox_dict(eface.bbox))
           face['facen'] = eface.facen
           if eface.gender:
               face['gender'] = eface.gender.name
           if eface.age:
               face['age'] = eface.age
           if eface.emotions:
               face['emotions'] = [e.name for e in eface.emotions[:2]]
           score = getattr(eface,'score', None)
           face.normalized = eface.normalized
           if score:
               face['detectorParams'] = {'score': eface.score}
           return face

.. rubric:: Class ``Faces``

As mentioned above, the ``Faces`` class represents a collection of detected faces. Each face in the collection must be assigned the following attributes:

* ``_id`` - primary key, uint64
* ``owner`` - owner id, ObjectId
* ``facen`` - feature vector
* ``bbox`` - coordinates of the face region in the original photo
* ``photo_hash`` - md5 of the original photo
* ``gallery`` - list of galleries that feature the face
* ``meta`` - metadata string, may be empty


.. _faces-methods:

You can invoke the following methods for the ``Faces`` class:

+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| Method                                        | Description                                                                                                                      |
+===============================================+==================================================================================================================================+
| add(self, user, face)                         | Add a face to MongoDB and return it being wrapped in ``Faces.Model``.                                                            |
|                                               | If the added face already has an id, this method fails at the attempt to insert a newly generated id.                            |
|                                               | If the face has no id, this method generates a new id and inserts it. In the case of a conflict, this method retries             |
|                                               | with another id up to 3 times. As this method updates only MongoDB and not the facen storage (``tntapi``), it can only be used   |
|                                               | to add a face to a default gallery. In order to add a face to a specific gallery, you will have to call                          |
|                                               | ``add_to_galleries(face, galleries)`` after this method.                                                                         |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| regenerate_id(self, face)                     | Replace a face's id with a newly generated one.                                                                                  |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| add_to_galleries(self, face, galleries)       | Add a face to specified galleries in MongoDB and the facen storage (``tntapi``). This method first attempts to add a face        |
|                                               | to galleries in the facen storage. If it is a success, it updates the face ``gallery`` field in MongoDB. If the face already     |
|                                               | exists in the facen storage gallery, the method generates an error.                                                              |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| del_from_galleries(self, face, galleries)     | Remove a face from specified galleries in MongoDB and the facen storage (``tntapi``). This method first attempts to remove a     |
|                                               | face from galleries in the facen storage. If it is a success, it updates the face ``gallery`` field in MongoDB.                  |
|                                               | If the face doesn't exist in the facen storage gallery, it is considered to be successfully removed.                             |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| identify(self, user, gallery, face, limit,    | Return faces that resemble a given ``face`` with similarity larger or equal to the ``threshold``. The maximum number of          | 
| threshold, filters=None, ignore_errors=False) | returned faces is defined by the ``limit``. Results can be filtered by optional ``filters`` (see the MongoDB query dictionary).  |
|                                               | By default, if one or several ``tntapi`` shards are out of service during face identification, ``findface-facenapi`` returns an  |
|                                               | error. If necessary, set ``ignore_errors=True``. In this case ``findface-facenapi`` will use available ``tntapi`` shards to      |
|                                               | obtain face identification results, indicating the number of live servers vs the total number of servers in the response         | 
|                                               | through the ``IdentifyResults`` class (see :ref:`IdentifyResults`).                                                              |
|                                               | This method returns a list-like object of faces in order of decreasing similarity. If ``ignore_errors=True``, the                |
|                                               | list-like object features two additional properties: ``live_servers`` and ``total_servers``.                                     |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+




.. code::

   class Faces(UserStore):

       Model = _Face

       def __init__(self, collection: motor.MotorCollection, id_generator: AbstractIdGenerator, facen_storage: AbstractFacenStorage, max_identify_limit=0):
           super().__init__(collection)
           self.id_generator = id_generator
           self.facen_storage = facen_storage
           self.max_identify_limit = max_identify_limit

       async def add(self, user, face):
           """Add a face to MongoDB and return it being wrapped in Faces.Model."""
           assert face['facen']
           face['owner'] = user['_id'] if isinstance(user, dict) else user
           if '_id' in face:
               await self.collection.insert_one(face)
           else:
               tries = 3
               for t in range(tries):
                   await self.regenerate_id(face)
                   try:
                       mongo_reply = await self.collection.insert_one(face)
                       face['_id'] = mongo_reply.inserted_id
                   except pymongo.errors.DuplicateKeyError:
                       logger.warning("Could not add face with id %r, will try to regenerate", face['_id'])
                   else:
                       break
               else:
                   logger.error("Could not add face %r to default gallery. Ran out of attempts.", face['_id'])
                   del face['_id']
                   raise pymongo.errors.DuplicateKeyError
           return self.wrap_in_model(face)

       async def regenerate_id(self, face):
           """Replace a face's id with a newly generated one."""
           face['_id'] = await self.id_generator()

       async def add_to_galleries(self, face, galleries):
           """Add a face to specified galleries in MongoDB and the facen storage."""
           galleries = frozenset(galleries)
           futures = [self.facen_storage.add(face['owner'], gallery, face['_id'], face['facen']) for gallery in galleries]
           exc = None
           galleries_succeeded = []
           for gallery, future in zip(galleries, futures):
               try:
                   await future
               except Exception as e:
                   exc = e
               else:
                   galleries_succeeded.append(gallery)
           face['gallery'] = (await self.update_one(face['owner'], {'_id': face['_id']},
                                 {'$addToSet': {'gallery': { '$each': galleries_succeeded} }},
                                 return_document=ReturnDocument.AFTER))['gallery']
           if exc is not None:
               raise exc

       async def del_from_galleries(self, face, galleries):
           """Remove a face from specified galleries in MongoDB and the facen storage."""
           galleries = frozenset(galleries)
           futures = [self.facen_storage.delete(face['owner'], gallery, face['_id']) for gallery in galleries]
           exc = None
           galleries_succeeded = []
           for gallery, future in zip(galleries, futures):
               try:
                   await future
               except NotFoundError:
                   galleries_succeeded.append(gallery)
               except Exception as e:
                   exc = e
               else:
                   galleries_succeeded.append(gallery)
           face['gallery'] = (await self.update_one(face['owner'], {'_id': face['_id']},
                                 {'$pull': {'gallery': { '$in': galleries_succeeded}} },
                                 return_document=ReturnDocument.AFTER))['gallery']
           if exc is not None:
               raise exc

       async def identify(self, user, gallery, face, limit, threshold, filters=None, ignore_errors=False):
           """Return N faces (N <=limit) that resemble a given face with similarity larger or equal to threshold."""
           if (limit==0 or limit > self.max_identify_limit) and self.max_identify_limit != 0:
               limit = self.max_identify_limit
           search_results, _, live_servers, total_servers = await self.facen_storage.search(
               user['_id'] if isinstance(user, dict) else user, gallery,
               face.facen, limit, threshold, ignore_errors=ignore_errors
           )
           results = IdentifyResults()
           results.live_servers, results.total_servers = live_servers, total_servers
           for chunk in chunks(search_results, 3000):
               mongo_filters = {'_id':{'$in': [x.id for x in chunk]}}
               if filters:
                   mongo_filters.update(filters)
               faces = await self.find(user, filters=mongo_filters)
               faces = dict((face['_id'], face) for face in faces)
               for result in chunk:
                   face = faces.get(result.id)
                   if face:
                       results.append(IdentifyResult(face, result.confidence))

           return results

       def prepare_indexes(self):
           return [{
               'key': [('owner', 1), ('gallery', 1), ('_id', -1)],
           },
           {
               'key': [('owner', 1), ('meta', 1), ('gallery', 1), ('_id', -1)],
           }]





.. _IdentifyResults:


Module ``face``: other objects
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 

Besides the ``Faces`` and ``Faces.Model`` classes, the ``face`` module also features the following objects:

* A helper function which splits a list of items into evenly sized chunks.

  .. code::

     def chunks(items, chunk_size):
         for i in range(0, len(items), chunk_size):
             yield items[i:i + chunk_size]

* A named tuple which stores recognition confidence for each detected face. 

   .. code::
      
      IdentifyResult = namedtuple('IdentifyResult', ('face', 'confidence'))

* A global class that returns the number of live servers vs the total number of servers during face identification (used in the :ref:`identify <faces-methods>` method for the ``Faces`` class).

  .. code::

     class IdentifyResults(UserList):
         live_servers = 0
         total_servers = 0



Module ``gallery``: class ``Galleries``
""""""""""""""""""""""""""""""""""""""""""

The ``gallery`` module features only one global class: ``Galleries``. By analogy with the ``Faces`` class, the ``Galleries`` class represents a collection of instances of the private class ``_Gallery`` (this time it doesn't feature any properties) and calls the latter by using the ``Model`` class (``Galleries.Model = _Gallery``). 

Each gallery in the collection must be assigned the following attributes:

* ``owner`` - owner id, ObjectId
* ``name`` - gallery name


To create a gallery in MongoDB, use the ``add(self, user, gallery)`` method. To return the existing galleries indexes, use ``prepare_indexes``.
 

.. code::

   import re
   from collections import OrderedDict

   from .mongo_store import UserStore

   GALLERY_RE = re.compile(r'^[a-zA-Z0-9_-]+$')
 
   class _Gallery(OrderedDict):
       pass

   class Galleries(UserStore):
       Model = _Gallery

       async def add(self, user, gallery):
           """Create a gallery in MongoDB and validate its name."""
           gallery['owner'] = user['_id'] if isinstance(user, dict) else user
           if not gallery.get('name'):
               raise ValueError('Empty gallery name')
           if not isinstance(gallery['name'], str) or len(gallery['name']) > 48 or not GALLERY_RE.match(gallery['name']):
               raise ValueError('Bad gallery name: ' + gallery['name'])

           insert_result = await self.collection.insert_one(gallery)
           gallery['_id'] = insert_result.inserted_id
           return self.wrap_in_model(gallery)

       def prepare_indexes(self):
           return [
               {
                   'key': [('owner', 1), ('name', 1)],
                   'unique': True,
               }
           ]


Module ``mongo_store``: classes ``MongoStore`` and ``UserStore``
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The ``mongo_store`` module features the following classes:

* ``MongoStore`` is a wrapper around the MongoDB collection of objects. Objects can be of any type: face, gallery, camera, user, etc. ``MongoStore`` wraps every returned object in an instance of the ``Model`` class, so that this object can have its own methods and properties, and you can refer to it.
* ``UserStore`` provides a base for all objects owned by a user. It ensures that passing an unauthenticated request will cause an error instead of security vulnerabilities.

.. code::

   import motor
   from pymongo.collection import ReturnDocument
  
   from ..utils import mongo_retry

   class MongoStore:
       """This is a wrapper around the MongoDB collection of objects, that wraps every returned object
       in an instance of the Model class, so that this object can have its own methods and properties"""
       def __init__(self, collection: motor.MotorCollection):
           self.collection = collection

       async def find(self, filters, sort=None, skip=None, limit=None):
           objects = await mongo_retry(lambda: self.collection.find(filters,sort=sort, skip=skip or 0, limit=limit or 0).to_list(None))
           return [self.Model(object) for object in objects]

       async def find_one(self, filters, sort=None, skip=None):
           objects = await mongo_retry(lambda: self.collection.find(filters,sort=sort, skip=skip or 0, limit=1).to_list(None))
           if len(objects) < 1:
               return None
           return self.Model(objects[0])


       async def count(self, filters, sort=None, skip=None, limit=None):
           return await mongo_retry(lambda: self.collection.find(filters,sort=sort, skip=skip or 0, limit=limit or 0).count())

       async def remove_one(self, filters, sort=None):
           object = await mongo_retry(lambda: self.collection.find_one_and_delete(filters, sort=sort))
           if object is None:
               return None
           return self.Model(object)

       async def update_one(self, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs):
           object = await self.collection.find_one_and_update(filters, update, sort=sort, return_document=return_document, **kwargs)
           if object is None:
               return None
           return self.Model(object)

       def prepare_indexes(self):
           """This method returns a list of indexes that exist in the database.

           Every item of the returned list must be a dictionary, where 'key' is the
           index key and all other items are parameters for ensure_index() """
           return []

       async def ensure_indexes(self):
           """Create indexes for this store"""
           for idx in self.prepare_indexes():
               idx = idx.copy()
               key = idx.pop('key')
               await self.collection.ensure_index(key, **idx)

       def wrap_in_model(self, obj):
           if isinstance(obj, self.Model):
               return obj
           return self.Model(obj)


   class UserStore(MongoStore):
       """This class provides a base for all objects owned by a user, to
       ensure that an unauthenticated request will cause an error instead of security
       vulnerabilities"""

       def _user_query(self, user):
           query = {}
           if user is not self.ALL_USERS:
               if isinstance(user, dict):
                   user = user['_id']
               query['owner'] = user
           return query

       class ALL_USERS:
           pass
       async def find(self, user, filters, sort=None, skip=None, limit=None):
           query = self._user_query(user)
           query.update(filters)
           return await super().find(query, sort=sort, skip=skip or 0, limit=limit)

       async def find_one(self, user, filters, sort=None, skip=None):
           query = self._user_query(user)
           query.update(filters)
           return await super().find_one(query, sort=sort, skip=skip)

       async def count(self, user, filters, sort=None, skip=None, limit=None):
           query = self._user_query(user)
           query.update(filters)
           return await super().count(query, sort=sort, skip=skip, limit=limit)

       async def remove_one(self, user, filters, sort=None):
           query = self._user_query(user)
           query.update(filters)
           return await super().remove_one(query, sort=sort)

       async def update_one(self, user, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs):
           query = self._user_query(user)
           query.update(filters)
           return await super().update_one(query, update, sort=sort, return_document=return_document, **kwargs)

       async def update_many(self, user, filters, update, sort=None, return_document=ReturnDocument.AFTER, **kwargs):
           query = self._user_query(user)
           query.update(filters)
           return await super().update_one(query, update, sort=sort, return_document=return_document, **kwargs)


Module ``users``: class ``Users``
""""""""""""""""""""""""""""""""""""""

The ``users`` module features only one global class: ``Users``. By analogy with the ``Faces`` and ``Galleries`` classes, the ``Users`` class represents a collection of instances of the private class ``_User`` and calls the latter by using the ``Model`` class (``Users.Model = _User``).

Each user in the collection must be assigned the following attributes:

* ``_id`` - primary key, ObjectId
* ``token`` - authentication token, must be unique and belong to the ``string`` data type
* ``active`` - allows user to perform requests, belongs to the ``boolean`` data type

Each face and gallery must belong to a certain user. Objects of the ``Users`` class are also used for authentication. 

To create a user in MongoDB, use the ``add(self, user)`` method. To return the user database index, use ``prepare_indexes``.


.. code::

   from collections import OrderedDict

   from .mongo_store import MongoStore

   class _User(OrderedDict):
       def __init__(self, *args, **kwargs):
           super().__init__(*args, **kwargs)

   class Users(MongoStore):
       Model = _User
       def prepare_indexes(self):
           return [
               { 'key': [('token', 1), ], 'unique': True, }
           ]

       async def add(self, user):
           assert user['_id']
           assert user['token']
           await self.collection.insert_one(user)
           return self.wrap_in_model(user)




Module ``counters``: class ``Counters``
"""""""""""""""""""""""""""""""""""""""""""

The ``counters`` module features only one class: ``Counters``. This class is invoked whenever it is necessary to generate a new id for a face or a person.

.. code::

   import pymongo.errors
   import motor
   from collections import OrderedDict

   from .mongo_store import MongoStore
   from ..utils import mongo_retry
   

   class Counters(MongoStore):
       Model = OrderedDict

       def __init__(self, collection: motor.MotorCollection, counters=()):
           super().__init__(collection)
           self.counters = counters

       async def ensure_indexes(self):
           for c in self.counters:
               try:
                   await self.collection.insert({"_id": c, "seq": 1})
               except pymongo.errors.DuplicateKeyError:
                   pass
               except:
                   raise

        async def next(self, counter):
           """Increment the counter and return its new value."""
           if counter not in self.counters:
               raise ValueError("Unknown counter: "+counter)
           res = await mongo_retry(lambda: self.collection.find_and_modify(
               query={"_id": counter},
               update={"$inc": {"seq": 1}},
               fields={"_id": False},
               upsert=True, new=True
           ))
           seq = res['seq']
           if not isinstance(seq, int):
               raise TypeError("Counter sequence is not an integer. %s counter is corrupted in database" % (counter, ))
           return seq





Looking into ``findface.server.models``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To implement the ``facenapi.server.models`` functionality to your plugin, refer to the following modules content:

* ``camera``
* ``face``
* ``person``
 


Module ``camera``: class ``Cameras``
"""""""""""""""""""""""""""""""""""""""""""""

The ``camera`` module features only one global class: ``Cameras``. The ``Cameras`` class represents a collection of instances of the private class ``_Camera`` and calls the latter by using the ``Model`` class (``Cameras.Model = _Camera``).

To add a camera to your system, use the ``add(self, user, camera)`` method.

.. code::

   import re
   from collections import OrderedDict

   from facenapi.core.models.mongo_store import UserStore

   class _Camera(OrderedDict):
       pass

   class Cameras(UserStore):
       Model = _Camera

       async def add(self, user, camera):
           camera['owner'] = user['_id'] if isinstance(user, dict) else user
           insert_result = await self.collection.insert_one(camera)
           camera['_id'] = insert_result.inserted_id
           return self.wrap_in_model(camera)



Module ``face``: class ``ServerFaces``
"""""""""""""""""""""""""""""""""""""""""""

The global class ``ServerFaces`` represents a collection of instances of the private class ``_Face`` and calls the latter by using the ``Model`` class (``ServerFaces.Model = _Face``). 

The difference between the ``Faces.Model`` (see :ref:`faces.model`) and ``ServerFaces.Model`` classes is that the latter supports saving original images and thumbnails.

To regenerate a face id and URLs of the original image, normalized face image, and the thumbnail (as they contain the face id), use the ``regenerate_id(self, face)`` method. To upload an original image, normalized face image and a thumbnail to ``findface-upload``, use the ``upload(self, face, img)`` method.


.. code::

   import io
   from datetime import datetime

   from facenapi.core.models.face import Faces as CoreFaces
   from facenapi.core.utils import fetch_then_raise
   from facenapi.core.image import Image

   try:
       from secrets import token_hex
   except ImportError:
       import binascii
       urandom = open('/dev/urandom', 'rb')
       def token_hex(nbytes=None):
           if nbytes is None:
               nbytes = 16
           return binascii.hexlify(urandom.read(nbytes)).decode('ascii')

   class _Face(CoreFaces.Model):
       pass

   class ServerFaces(CoreFaces):
       Model = _Face

       def __init__(self, *args, uploader, **kwargs):
           super().__init__(*args, **kwargs)
           self.uploader = uploader

       @classmethod
       def gen_ffupload_key(cls, face, suffix='.jpeg'):
           now = datetime.now()
           return '%s/%s/%d_%s%s'  % (face['owner'], now.strftime('%Y%m%d'), face['_id'], token_hex(6), suffix)

       async def upload_thumbnail(self, face, img: Image, url=None):
           if url is None:
               url = face['thumbnail']
           thumb_rect = img.shape.intersect(face.bbox)
           thumb_img = img.img.crop((thumb_rect.left, thumb_rect.top, thumb_rect.right, thumb_rect.bottom))
           thumb_contents = io.BytesIO()
           thumb_img.save(thumb_contents, format='JPEG', quality=90)
           thumb_contents.seek(0)
           await self.uploader.upload_by_url(url, thumb_contents.getvalue())

        async def regenerate_id(self, face):
           await super().regenerate_id(face)
           if self.uploader:
               face['photo'] = self.uploader.url_for_key(self.gen_ffupload_key(face, '_photo.jpeg'))
               face['normalized'] = self.uploader.url_for_key(self.gen_ffupload_key(face, '_norm.png'))
               face['thumbnail'] = self.uploader.url_for_key(self.gen_ffupload_key(face, '_thumb.jpeg'))
           else:
               face['photo'] = face['normalized'] = face['thumbnail'] = ''

       async def upload(self, face, img):
           await fetch_then_raise([
               self.uploader.upload_by_url(face['normalized'], await face.get_normalized()),
               self.uploader.upload_by_url(face['photo'], await img.encode()),
               self.upload_thumbnail(face, img),
           ])



Module ``person``: class ``Persons``
""""""""""""""""""""""""""""""""""""""

The ``person`` module features only one global class: ``Persons``. The ``Persons`` class represents a collection of instances of the private class ``_Person`` and calls the latter by using the ``Model`` class (``Persons.Model = _Person``). This class is used to implement the advanced functions of :ref:`Dynamic Person Creation <persons>` and :ref:`'Friend and Foe' Identification <friend>`. 

Each person in the collection must be assigned the following attributes:

* ``_id`` - person_id, uint64
* ``owner`` - owner id, ObjectId

You can invoke the following methods for the ``Persons`` class:

+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| Method                                        | Description                                                                                                                      |
+===============================================+==================================================================================================================================+
| add(self, user, person)                       | Create a person and return it being wrapped in ``Persons.Model``.                                                                |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| identify(self, user, face, gallery,           | Return a person whose face resembles a given ``face`` with similarity larger or equal to the ``threshold``.                      | 
| threshold, create=False, filters=None)        | Results can be filtered by optional ``filters`` (see the MongoDB query dictionary).                                              |
|                                               | If ``create=True`` and no similar faces were found, the method creates a new person and returns ``person_id``.                   | 
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+
| is_friend(self, user, person_id, cam_id)      | Check for the camera ``cam_id`` if a given ``person_id`` belongs to a friend.                                                    |
+-----------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------+


.. code::

   import logging
   from collections import OrderedDict
   from datetime import datetime
   from dateutil.relativedelta import relativedelta

   from facenapi.core.models.mongo_store import UserStore
   from facenapi.core.errors import ConfigurationError
   from facenapi.core.utils import mongo_retry

   logger = logging.getLogger(__name__)

   class _Person(OrderedDict):
       pass

   class Persons(UserStore):
       Model = _Person

       def __init__(self, collection, faces, counters, friend_interval, friend_count):
           self.collection = collection
           self.faces = faces
           self.counters = counters
           self.friend_interval, self.friend_count = friend_interval, friend_count

       async def add(self, user, person):
           if '_id' not in person:
               person['_id'] = await self.counters.next('persons')
           person['owner'] = user['_id'] if isinstance(user, dict) else user
           await self.collection.insert_one(person)
           return self.wrap_in_model(person)

       async def identify(self, user, face, gallery, threshold, create=False, filters=None):
           search_results = await self.faces.identify(user, gallery, face, limit=100, threshold=threshold, filters=filters)
           selected_person_id = None
           personless_face = 1j # use imaginary one as an indicator of "nothing read from mongodb", just in case someone
           # writes 'null' into _id by mistake
           for result in search_results:
               person_id = result.face.get('person_id', None)
               if person_id is not None:
                   selected_person_id = person_id
                   break
               else:
                   personless_face = result.face.get('_id')
           if personless_face==1j:
               logger.warning("person_id is None for id:%d, looks like db<>index inconsistency "\
                   "or person_identify/threshold options were changed without rebuilding db" % personless_face)
               raise ConfigurationError(reason="Person identification is enabled but there are"
                        " faces without person_id in database. You should never change person_identify on existing"
                        " database")
           if selected_person_id is None and create:
               selected_person_id = (await self.add(user, {"meta":"autogenerated"}))['_id']
           return selected_person_id

       async def is_friend(self, user, person_id, cam_id):
           if (person_id is not None) and (cam_id is not None):
               dt = datetime.now() - relativedelta(seconds=self.friend_interval)
               query = [
                   {
                       "$match": {
                           "timestamp": {
                               "$gte": dt
                           },
                           "person_id": person_id,
                           "cam_id": cam_id,
                           "owner": user['_id'] if isinstance(user, dict) else user,
                       }
                   },
                   {
                       "$group": {
                           "_id": {
                               "year": {
                                   "$year": "$timestamp"
                               },
                               "day": {
                                   "$dayOfYear": "$timestamp"
                               }
                           },
                           "timestamp": {
                               "$first": "$timestamp"
                           }
                       }
                   },
               ]
               days = await mongo_retry(lambda: self.faces.collection.aggregate(query).to_list(None))
               return len(days) >= self.friend_count
           else:
               return False



.. _write-plugin:


Case Studies
-----------------------------

The following case studies will help you write your first ``findface-facenapi`` plugin:

* The :download:`html-demo-report.py <_scripts/html-report-demo.py>` plugin identifies faces detected in video by the ``fkvideo_detector`` component and saves the identification results to a static HTML file.

  .. note::
     By default, faces detected in video are added to a database without identification. In order to identify them, :ref:`assign <fkvideo-config>` ``v1/identify`` to the ``request-url`` parameter of ``fkvideo_detector``.

* The :download:`websocket-demo-plugin <_scripts/websocket-demo-plugin.py>` plugin identifies faces and sends the identification results to a websocket.

  

Implement Plugin to ``findface-facenapi``
------------------------------------------

To implement a plugin to ``findface-facenapi``, do the following:

#. Put a plugin into a directory of your choice. You can use several directories to store plugins.
#. Open the ``findface-facenapi`` configuration file.

   .. code::

      sudo vi /etc/findface-facenapi.ini

   .. warning::
      The ``findface-facenapi.ini`` content must be correct Python code.


#. Uncomment the ``plugins_dirs`` parameter and specify the comma-separated list of plugin directories. 

   .. code::

      plugins_dirs                   = '/etc/findface/plugins/video, /etc/findface/plugins/html'

#. Uncomment the ``plugins_enabled`` parameter and specify the comma-separated list of plugins to load, or an asterisk (*) to load all plugins. 
      
   .. code::

      plugins_enabled                = '*'


