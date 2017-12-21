.. _ffupload-ip:

Uploads in FindFace Web UI
------------------------------------------------

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
	      "facen" : BinData(0,"CKftuU5t6j2ZfBo9tvR6vU+vnj1vTMi959KiOyVRrjt2Sn09n7wFPfBAGrwexTc9NbRnPYT2CTzld1487L69vAtBkzzljiy8hHdbvVDSbLxCG6W8Qsp+PNfyKr0Drq09+KecvPKT8ztD+tW8pVxgPV15IjpVzYS8wTcNvRrAb71K3g88XpSovVnnjz2a2047Wec+PZcst72MA6e9FEG+vW8CGb4eosY96xhdveBMn7zMKlw88xg1PUZXTjyZV4s8JI0PvK3NoD0M3ws8N75gPfeDPzyN9Wy9bnpfO6UsUT12ARY9v6WXu0dthbvxnh6958uNPVi97bzqZmc9jqCzvGKMBzxJStI8hxf1u6Ega7255D89lZxKPHJYIr0lWD29URJdPTLUOT0F0oC8Rr+4PfYVhL1+Kdg9doYfO6uGiT2CAEk89E+5O1Nmkz3viIG8/QtxvOxbzbzJruq86Nm2vXnKnj1iy8O9l8p8PPwHXD3f4x29nGuIvWQxzD3y6SG9HqUGPma0ojz/C3g9jRLVPFf++r3W5au8yKC5PU0Imz3irrS7jWjNPYVVET25bDg99GUQvaDABT0hjcm8xY4tvSi4v71abv296QPAO9JWorzJ/Ba9iQAsPZJfybnRO5g94M6SvUEtVDyRxfQ9CkmQvQkq4LzDtNw83sl4PQE23jsz7iE9NlZTPYq5VL2fpUY9NlXzvFcgFj3InIe9frfSvWASAL6qHUO9ah0xvQlWLz2rq2Y95/WDPf6ijT39wJy8muG5vLljorw1jwK8zHAUvBVUwbsU9709rIaQPbu5bTtFwZO9Qc7CvU6ni71aEHW9rXsVva+ScD0SbX67WgoWvXarAzzKExi9jwaavEioGT2qem08GY2ovJH1lbyAEZk8bujWPCczbDxyedW8DG57PdMoh71RHt07NXchvVxisLug3bw9Ruf8vUyosLticR49v81uvHlIvTxpOoi8KppAPLUhR73qRdY78PIaPBwWpL3oyQ29EvP2PeCfrjyyq+q8eFG+PAexkL0IDIM9l4hGvc1G7bvHJLM9Cr/NPNh4DDxslzU9VL3PPOvoNL0hoPe9aWMNPdTFbLtOpZq7QcOjvf6CjrwkJ6A7MkNIO67ADj2sJde8cFHWPeTQVrsIN2g9KzG6vZr1qTypecO9gA6APSwcbb2bEvk9mLOuvUxOrr176689QgRSvS+hQD0ccDS9Ra+ovaI7xD3maaS9snHDPXXKsruxibg8BIzbPMQBjDu81GQ7/g6XPWiVNT2zxEg9YcoGvmOHI72HzAi+1BHXvTNueL3j6aS8fd0RPkREkz0HHZg91h/OPKCpRzy2+E89MqEIPRFBFrw3VTO8o68OvVy/LD2WKt68LdCdPMju6bw1Ok89bXIsvCMRgTnse9W9hOUJvfX0F71MF8s7Fq+Lu9XAOTx58rc95+AePV246Tqw2q09586zvIu497yevly9uiYxvTF4SD3Sp5q9yl1uPQp9yL1W+s67e3krvSL2Yb0Uthm9LzCIOgqWhj15QBs91f13PQPzoDuzqDg9VyRgPE1+TTpLaRs8bzcmvYPsj72sC668h5IPvXTCq7zPe+28Z8GpvQiQ3Lxovua9aqmmPVOZJr1+P548m+pEvMwZC7yec5C9dKENvO0lA73o6zG7+A/MPRjn1r1952O93ORNPHtdKD0E1M29YVVkvd3hSr0="),
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



