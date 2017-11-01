.. _extraction-api:

Extraction API
================================

With the ``Extraction API`` component, you can flexibly configure the format of API responses to extract various face data, including the
bounding box coordinates, normalized face, gender, age, and emotions, as well as the face feature vector (facen). Implementing this feature to
your system can remarkably broaden the scope of analytic tasks it is capable of fulfilling. 

.. note::
   Being a ``findface-facenapi`` counterpart when it comes to data extraction via API, ``Extraction API`` is more resource-demanding. The component cannot fully substitute ``findface-facenapi`` as it doesn't allow adding faces and working with the database.

.. note::
   You can also :ref:`use <extract-facens>` ``Extraction API`` as a facen extractor, i. e. as a substitute for ``findface-nnapi``.

.. tip::
   Encoded in base64 normalized images received from the Extraction API component are qualified for posting to findface-facenapi.

.. contents:: In this section:

Install Extraction API
-----------------------------

To install and configure the ``Extraction API`` component, do the following:

.. note::
   ``Extraction API`` requires the package with models :program:`<findface-data>.deb`. Make sure it's installed.

#. Install the component.

   .. code::

       $ sudo apt-get install findface-extraction-api

#. Open the ``findface-extraction-api.ini`` configuration file.

   .. code::

       $ sudo vi /etc/findface-extraction-api.ini

#. If :ref:`NTLS <licensing>` is remote, specify its IP address. 

   .. code::

       license_ntls_server: 192.168.113.2:3133

#. Configure other parameters if needed. For example, enable or disable fetching Internet images.

   .. code::

       fetch:
         enabled: true
         size_limit: 10485760
   
#. The ``min_face_size`` and ``max_face_size`` parameters do not work as filters. They rather indicate the guaranteed detection interval. Pick up their values carefully as these parameters affect performance.

   .. code::
    
      nnd:
        min_face_size: 30
        max_face_size: .inf

#. The ``model_instances`` parameter indicates how many instances of each enabled face detector (``nnd``, ``legacy`` or ``prenormalized``) and each enabled model (``facen``, ``gender``, ``age``, ``emotions``) run concurrently. The default value (0) means that this number is equal to the number of CPU cores. If it severely affects RAM consumption (for example, extraction-api fails), adjust the parameter value. 

   .. code::

       model_instances: 2

#. To estimate the face quality, enable the ``quality_estimator``. In this case, ``extraction-api`` will return the quality score in the :ref:`detection_score <detection_score>` parameter.

   .. tip::
      Interpret the quality score further in analytics. Upright faces in frontal position are considered the best quality. They result in values around ``0``, mostly negative (such as ``-0.00067401276``, for example). Inverted faces and large face angles are estimated with negative values some ``-5`` and less.

   .. code::

       quality_estimator: true

#. Enable the ``Extraction API`` service autostart and lauch the service.

   .. code::

       $ sudo systemctl enable findface-extraction-api && sudo systemctl start findface-extraction-api

API Requests
--------------------------

The Extraction API component accepts POST requests
to \ http://127.0.0.1:18666/.

There are 2 ways to format the request body:

* ``application/json``: the request body contains only JSON.
* ``multipart/form-data``: the request body contains a JSON part with the request itself, other body parts are used for image transfer.

The JSON part of the request body contains a set of requests:

.. code::

    { 
        "requests": [request1, request2, .., requestN]
    }

Each request in the set applies to a specific image or region in the
image and accepts the following parameters:

* ``"image"``: an uploaded image (use ``multipart:part`` to refer to a relevant request body ``part``), or a publicly accessible image URL   (``http:``, ``https:``).
* ``"roi"``: a region of interest in the image. If the region is not specified, the entire image is processed.
* ``"detector"``: a face detector to apply to the image (``legacy``, ``nnd`` or ``prenormalized``). The ``prenormalized`` mode accepts normalized face images and omits detecting faces. Use ``nnd`` if you need to estimate the face quality (``"quality_estimator": true``). 
* ``"need_facen"``: if true, the request returns a facen in the response.
* ``"need_gender"``: returns gender.
* ``"need_emotions"``: returns emotions.
* ``"need_age"``: returns age.
* ``"need_normalized"``: returns a normalized face image encoded in base64. The normalized image can then be posted again to the ``Extraction API`` component as "prenormalized". 
* ``"auto_rotate"``: if true, auto-rotates an original image to 4 different orientations and returns faces detected in each orientation. Works only if ``"detector": "nnd"`` and ``"quality_estimator": true``.

.. code::

    {
        "image": "http://static.findface.pro/sample.jpg",
        "roi": {"left": 0, "right": 1000, "top": 0, "bottom": 1000},
        "detector": "nnd", 
        "need_facen": true,
        "need_gender": true,
        "need_emotions": true,
        "need_age": true,  
        "need_normalized": true,
        "auto_rotate": true
    }

API Response Format
-----------------------------

A typical response from the Extraction API component contains a set of
responses to the requests wrapped into the main API request:

.. code::

    {
        "response": [response1, response2, .., responseN]
    }

Each response in the set contains the following JSON data:

* ``"faces"``: a set of faces detected in the provided image or region of interest.
* ``"error"``: an error occurred during processing (if any). The error body includes the error code which can be interpreted automatically (``"code"``) and a human-readable description (``"desc"``).

.. code::

    {
        "faces": [face1, face2, .., faceN],
        "error": {
            "code": "IMAGE_DECODING_FAILED",
            "desc": "Failed to decode: reason"
        }
    }

Each face in the set is provided with the following data:

.. _detection_score:

* ``"bbox"``: coordinates of a bounding box with the face.
* ``"detection_score"``: either the face detection accuracy, or the face quality score (depending on whether ``quality_estimator`` is ``false`` or ``true`` at ``/etc/findface-extraction-api.ini``). Upright faces in frontal position are considered the best quality. They result in values around ``0``, mostly negative (such as ``-0.00067401276``, for example). Inverted faces and large face angles are estimated with negative values some ``-5`` and less.
* ``"facen"``: the face feature vector.
* ``"gender"``: gender information (MALE or FEMALE) with recognition accuracy if requested.
* ``"age"``: age estimate if requested.
* ``"emotions"``: all available emotions in descending order of probability if requested. 
* ``"normalized"``: a normalized face image encoded in base64 if requested.

.. code::

    {
        "bbox": { "left": 1, "right": 2, "top": 3, "bottom": 4},
        "detection_score": -0.0004299,
        "facen": "...",
        "gender": {
            "gender": "MALE",
            "score": "1.123"
        },
        "age": 23.59,
        "emotions": [
            { "emotion": "neutral", "score": 0.95 },
            { "emotion": "angry", "score": 0.55 },
            ...
        ],
        "normalized": "...",
    }

Examples
-------------------

.. rubric:: Request #1

.. code::

    $ curl -X POST -F sample=@sample.jpg -F 'request={"requests":[{"image":"multipart:sample","detector":"nnd", "need_gender":true, "need_normalized": true, "need_facen": true}]}' http://127.0.0.1:18666/| jq

.. rubric:: Response

.. code::

    {
      "responses": [
        {
          "faces": [
            {
              "bbox": {
                "left": 595,
                "top": 127,
                "right": 812,
                "bottom": 344
              },
              "detection_score": -0.0012599,
              "facen": "qErDPTE...vd4oMr0=",
              "gender": {
                "gender": "FEMALE",
                "score": -2.6415858
              },
              "normalized": "iVBORw0KGgoAAAANSUhE...79CIbv"
            }
          ]
        }
      ]
    }


.. rubric:: Request #2

.. code::

    $ curl -X POST  -F 'request={"requests": [{"need_age": true, "need_gender": true, "detector": "nnd", "roi": {"left": -2975, "top": -635, "right": 4060, "bottom": 1720}, "image": "https://static.findface.pro/sample.jpg", "need_emotions": true}]}' http://127.0.0.1:18666/ |jq

.. rubric:: Response

.. code::

    {
      "responses": [
        {
          "faces": [
            {
              "bbox": {
                "left": 595,
                "top": 127,
                "right": 812,
                "bottom": 344
              },
              "detection_score": 0.9999999,
              "gender": {
                "gender": "FEMALE",
                "score": -2.6415858
              },
              "age": 26.048346,
              "emotions": [
                {
                  "emotion": "neutral",
                  "score": 0.90854686
                },
                {
                  "emotion": "sad",
                  "score": 0.051211596
                },
                {
                  "emotion": "happy",
                  "score": 0.045291856
                },
                {
                  "emotion": "surprise",
                  "score": -0.024765536
                },
                {
                  "emotion": "fear",
                  "score": -0.11788454
                },
                {
                  "emotion": "angry",
                  "score": -0.1723868
                },
                {
                  "emotion": "disgust",
                  "score": -0.35445923
                }
              ]
            }
          ]
        }
      ]
    }


.. rubric:: Request #3. Auto-rotation

.. code::
  
   $ curl -s -F 'sample=@/path/to/your/photo.png' -F 'request={"requests":[{"image":"multipart:sample","detector":"nnd", "auto_rotate": true, "need_normalized": true }]}' http://192.168.113.79:18666/

.. rubric:: Response

.. code::

   {
    "responses": [
      {
        "faces": [
          {
            "bbox": {
              "left": 96,
              "top": 99,
              "right": 196,
              "bottom": 198
            },
            "detection_score": -0.00019264,
            "normalized": "iVBORw0KGgoAAAANSUhE....quWKAAC"
           },
          {
            "bbox": {
              "left": 205,
              "top": 91,
              "right": 336,
              "bottom": 223
            },
            "detection_score": -0.00041600747,
            "normalized": "iVBORw0KGgoAAAANSUhEUgAA....AByquWKAACAAElEQVR4nKy96XYbybIdnF"
          }
        ]
      }
    ]
   }


.. _extract-facens:

Extract Facens
---------------------------------------------------

By default, ``findface-facenapi`` detects faces in images and sends them to ``findface-nnapi`` for a facen extraction. Then ``findface-facenapi`` saves the obtained facen to MongoDB and Tarantool databases. You can use ``Extraction API`` as a substitute of ``findface-nnapi`` in this pipeline. 

The main advantage of ``Extraction API`` in contrast with ``findface-nnapi`` is its built-in ability to clone into multiple instances and automatically balance the traffic across them, while for ``findface-nnapi``, load balancing has to be manually :ref:`set up <load-balancing>` via NginX. 

To extract facens via ``Extraction API``, do the following:

#. Open the ``findface-facenapi.ini`` configuration file:: 

      $ sudo vi /etc/findface-facenapi.ini
   
#. Uncomment and edit the ``extractor`` parameter in the following way::

     extractor = 'extraction-api'

   .. warning::
       The ``findface-facenapi.ini`` content must be correct Python code.

#. Uncomment and/or edit ``extraction_api_url`` to align with your network specification::
  
     extraction_api_url = 'http://localhost:18666'     
    

#. Start ``Extraction API`` and enable its autostart.

   .. code::

      $ sudo service findface-extraction-api start && sudo systemctl enable findface-extraction-api

#. Restart ``findface-facenapi``.

   .. code::

      $ sudo service findface-facenapi restart

#. Stop ``findface-nnapi`` and disable its autostart. 

   .. code::

      $ sudo service findface-nnapi stop && sudo systemctl disable findface-nnapi

#. Check the services status. The command will return the services description, status (should be Active), path and running time.

   .. code:: 

      $ sudo service 'findface*' status


