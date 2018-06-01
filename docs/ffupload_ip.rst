.. _ffupload-ip:

Uploads in FindFace Web UI
--------------------------------

.. rubric:: Issue: Original images, face thumbnails, and face normalized images are not displayed in the FindFace web interface after the ``findface-upload`` host IP address has been changed.

Each face object in the :ref:`MongoDB <start>` database is provided with the following links to the ``Uploads`` folder:

* Link to the relevant original image
* Links to the relevant FindFace Server artifacts: the face thumbnail and normalized image


If the ``findface-upload`` host IP address happens to change, the links to the ``Uploads`` folder get broken, and the original images and artifacts can no longer be displayed in the :ref:`web interface <ffui>`.

To fix the problem, bulk-edit the links in the ``photo``, ``thumbnail`` and ``normalized`` fields of the face objects in MongoDB as follows:

#. On the console, navigate into MongoDB and then into the ``facenapi`` database.

   .. code::
      
      mongo
      use facenapi

#. Invoke a random face object to make sure that the old IP address is still in use in its ``photo``, ``normalized``, and ``thumbnail`` fields  (``127.0.0.1`` in the case study). 

   .. code::
      
      db.faces.findOne()

      {
	      "_id" : NumberLong("3871027550645276"),
	      "y2" : 383,
	      "x2" : 397,
	      "x1" : 84,
	      "y1" : 71,
	      "facen" : BinData(0,"CKftuU5t6j+...+tdKD0E1M29="),
	      "gender" : "female",
	      "age" : 38.75063705444336,
	      "emotions" : [
		      "neutral",
		      "sad"
	      ],
	      "meta" : "",
	      "photo_hash" : "6209c1a017972f8b18fada3f9e4d2768",
	      "timestamp" : ISODate("2017-12-01T09:22:16.950Z"),
	      "gallery" : [
		      "default"
	      ],
	      "person_id" : 13,
	      "friend" : false,
	      "owner" : ObjectId("5a0e96928acdc01dab404bdd"),
	      "photo" : "http://127.0.0.1:3333/uploads/5a0e96928acdc01dab404bdd/20171201/3871027550645276_92fc8aa39973_photo.jpeg",
	      "normalized" : "http://127.0.0.1:3333/uploads/5a0e96928acdc01dab404bdd/20171201/3871027550645276_41ec18ba44cd_norm.png",
	      "thumbnail" : "http://127.0.0.1:3333/uploads/5a0e96928acdc01dab404bdd/20171201/3871027550645276_3bc9e34b60aa_thumb.jpeg"
      }


#. Apply the IP address replacement script to the ``photo``, ``normalized``, and ``thumbnail`` fields of the face objects. In the case study, the IP address ``127.0.0.1`` is being replaced with ``192.168.2.158``.

   .. code::

      db.faces.find().forEach(function(e,i) {     e.photo=e.photo.replace("//127.0.0.1","//192.168.2.158"); e.normalized=e.normalized.replace("//127.0.0.1","//192.168.2.158"); e.thumbnail=e.thumbnail.replace("//127.0.0.1","//192.168.2.158");     db.faces.save(e); });

#. Invoke a random face object once more to make sure that the IP address has been successfully changed.

   .. code::

      db.faces.findOne()

      ...
      "photo" : "http://192.168.2.158:3333/uploads/5a0e96928acdc01dab404bdd/20171201/3871027550645276_92fc8aa39973_photo.jpeg",
      "normalized" : "http://192.168.2.158:3333/uploads/5a0e96928acdc01dab404bdd/20171201/3871027550645276_41ec18ba44cd_norm.png",
      "thumbnail" : "http://192.168.2.158:3333/uploads/5a0e96928acdc01dab404bdd/20171201/3871027550645276_3bc9e34b60aa_thumb.jpeg"
      ...



