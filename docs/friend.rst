.. _friend:

'Friend or Foe' Identification
====================================

As you configure :ref:`persons`, you can also enable 'friend or foe' identification in order to further enhance your video analytics.

.. contents:: In this section:

About Friends and Foes
--------------------------------

The 'friend or foe' identification system of FindFace Enterprise Server
SDK can positively identify only friends, not foes. A friend is a person
whose face has been captured a certain number of days by the same camera
during a certain period of time. In all other cases, a person is just
considered to be 'not a friend'.

Enable 'Friend or Foe' Identification
-------------------------------------------

To enable 'friend or foe' identification, do the following:

#. Configure and tryout :ref:`dynamic person
   creation <persons>`.

#. Open the **findface-facenapi.ini** configuration file for
   editing.

   .. code::

       $ sudo vi /etc/findface-facenapi.ini

#. Edit the settings.

   .. warning::
        The **findface-facenapi.ini** content must be correct Python code.

   .. code::

       ## A friend is a person that has been seen a certain number of days
       ## by the same camera during an interval [now() - $interval ; now()]
       ## Uncomment and edit the number of days a person has to be seen to become a friend. 
            → friend_count = 5
       ## Interval in seconds during which a person has to be seen a certain number of days (1 week by default)
            → friend_interval = (3600*24*7)

#. Restart the service.

   .. code::

       sudo service findface-facenapi restart

'Friend or Foe' Identification in REST API
-------------------------------------------------

The example below demonstrates a ``POST /face`` request and the
corresponding response containing the 'friend' parameter (``"friend": true``
or ``"friend": false``).

.. rubric:: Request

.. code::

    POST /v0/face/ HTTP/1.1
    Host: 127.0.0.1
    Authorization: Token e93437ccdae66d57a45a5c6d9aa7602e
    Content-Type: application/json
    Content-Length: [length]

    {
        "photo": "http://static.findface.pro/sample.jpg"
    }

.. rubric:: Response

.. code::

    HTTP/1.1 200 OK
    Date: Mon, 13 Jun 2016 12:23:56 GMT
    Content-Type: application/json
    Content-Length: [length]

    {
      "results": {
        "[595, 127, 812, 344]": [
          {
            "confidence": 1,
            "face": {
              "friend": true,
              "galleries": [
                "default"
              ],
              "id": 2,
              "meta": "Jack Smith",
              "normalized": "http://192.168.113.76:3333/uploads/20170418/1492509569217098.jpeg",
              "person_id": 2,
              "photo": "http://192.168.113.76:3333/uploads/20170418/14925095692111893.jpeg",
              "photo_hash": "53477c4a72f52c6efc951d9c7ece42bc",
              "thumbnail": "http://192.168.113.76:3333/uploads/20170418/14925095692159095.jpeg",
              "timestamp": "2017-04-18T09:59:29.211000",
              "x1": 595,
              "x2": 812,
              "y1": 127,
              "y2": 344
            }
          }
        ]
      }
    }


