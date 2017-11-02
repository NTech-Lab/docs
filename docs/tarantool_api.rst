Direct API Requests to Tarantool
======================================

You can use HTTP API to extract data directly from the Tarantool Database. 

.. contents:: In this section:

General Information
----------------------------

API requests to Tarantool should be sent to ``http://<tarantool_host_ip:port>``.

.. tip:: 
    The port for API requests can be found in the Tarantool configuration file:

    .. code::

       ## Tarantool configuration file:
       /etc/tarantool/instances.enabled/FindFace.lua

       ## You can find the port in this section (8001 in the example):
       FindFace.start("127.0.0.1", 8001)

.. note::
    In the case of standalone deployment, you can access Tarantool by default only locally (127.0.0.1). If you want to access Tarantool remotely, :ref:`change <tntapi-standalone>` the Tarantool configuration file.


Each API request to Tarantool contains the following parameters:


* ``:ver``: the API version (v1 at the moment).
* ``:name``: the gallery name.
* ``:id``: the face id.

Add Face
----------------------

.. rubric:: Request

.. code::

    POST /:ver/:name/add/:id

``Body``: a raw feature vector (facen)

.. rubric:: Returns:

*  HTTP 200 and empty body if success.
*  HTTP 409 if a face with the same id already exists in the gallery.
*  HTTP with a status other than 200 and error description in the body if failure.

.. rubric:: Example

.. code::

    $ curl -s -D - 'http://localhost:8001/v1/my_gal/add/1234' --data-binary @3827305024709134.facen

    HTTP/1.1 200 Ok
    Content-length: 0
    Server: Tarantool http (tarantool v1.7.3-673-g23cc4dc)
    Connection: keep-alive

Get Facen
---------------------

.. rubric:: Request

.. code::

    GET /:ver/:name/get/:id

.. rubric:: Returns:

*  A JSON representation of the face with its id and base64 encoded facen if success.
*  HTTP 404 if a face with the given id is not found in the gallery. 
*  HTTP with a status other than 200 and error description in the body if failure.

.. tip:: 
    To convert a facen from base64 to a binary file, execute:

    .. code::

       echo 'facen in base64' |base64 -d> facen

.. rubric:: Example

.. code::

    $ curl -s -D - 'http://localhost:8001/v1/my_gal/get/1234' HTTP/1.1 200 Ok Content-length: 1754 Server: Tarantool http (tarantool v1.7.3-673-g23cc4dc) Connection: keep-alive {"facen":"BFa9PWNlS7215fI98ETQvJkxML2hUFY9cF\/Tu9ZjnLx\/uVc9EzWSPQTsR7zoysI8+4PSPIsjnr2GV1M8eFMKvfn9mjsPPjA8ZXoNvTEsSr0rJkM9MR0IPINXSj3Em0s9awm5Oos5SD380a693GroPBz6nzxQMDQ9HdOjPd7QhDxUIzC+g90sPUWUDLwjk7U9cpWkPZ83 rTyEDNm8Ti\/0ve4Trr1rnQA+Yc\/KvJzqnbzOPSG998CKPBFpAr77kFO9BonDvK9B0buvjAq9Q7A\/u6awnTw0lvy80QZcvRFQAz0BdH498hF6vQKRcDy77c08mGRkvQ305DomnBM9XSqwvN54GT0ClFO9a+kWvhp7iT3uqqU9v1+\/vYhzm7uREt091douuyDKRr2PcIG9Uc8xPVJnvzt5T309NicxPD9SAr3f6sO8UmlhvRMI67wlTte880wYvUF8o7xg4\/g8aqNQu\/AAWD2z59C9CQCrPepF7Dy8qUa9iCczPfKv+Dy+bRo9KhyYPZfY0b1xtbY7nKXLuvYFbr0g8rM86o0QPRCKOj1a7rU9bd+3Pbqs7LslJcO9bBh+vVYeUr3S95Y9Wtg5PUZnRr0D0G08lkRkveImPDx4iQ084Qy1vKRBjj3uf4W85qx+vREFX7uccQ++5mMMvetNAL25b409P0GQvDIGLz3mHqg9ca\/Guv2beTy56wg7p\/hTPdxQgr0jxQQ9Ud0CPZcx\/LtRLiU9bECQvUnvszpMVcM8b3OovURPET3JdHs9LyQUPsc9JzvW1ZQ7y2ySPdN4Xb0xi9c8X7UevRqjVL0MLpE9PoQpvFxxjD2NCDO81jH\/PF1KFTzc3pc7qpaFPXxuPb2tjsY9iA5lPR1NoT1+Uuu7G6gpu727wTwo6ii8iaH+PI1WY72D9QG+8lhAPUegx71VsFs8ajQLvOdekrzGqAg+zhPLvbjyNDxaI1E9Wkj\/O1307D1ZMSk9IxqGvYCvFb1bE429hZF4vewikzwDbfG8wwYNPiQn4L2NV6Q9VKrvPTjwTr3dlG05jck+vZ\/KID1+n8Y8qpvnvOJjBj2P4+w8IJGgvROAfz1S4ve8QEouvQ5CkDu0OTI8\/v\/pvFrK5b3bkIO82LVBPcf2Yr0aGaU9RArUvEecJz1r8zk87U4vvC65ljz6kRS956U2PH6JMT5nfAg7KX7qPBz7Ejy60vk9\/iEPPYw8pT3Mfvk8UQYyPUCG+TyD5CO90c6nvSVLvDwRJSW9C3udvDORMz3zqtU8yd+0PXrubj3u9pQ9cGZIPVjlqTz6eIs8Z4wsPIjEIT3gnqI9kjhTPRJ8b73crA492KKIvSvpEz3ROrs9M+ZrO3RDOrwPpgG9+buePbiwi726dSs9k\/iVvZjEhT3W0B69IRojvQGUVj2J6vQ9FiDhPNRUO70bcum9fOOvPKA\/y7yB9wq9ntsBPYL6XL0wgkw7nLu6O\/\/USz1EoUg9JKE9PLDzNL0Pns49fPVyPJfZaj2g6pi8MuZePV0xQLxkR4W9pEe7vYTv7jytv567nakpPcCHZbsfjx89jPENPW0x87vr3Wi84L9mvSGeFL2hsBo9HBI2vXiEJr2uIQW7L0FsPU2w8jz2chi9FB5nvFcj9rknTha9qxCoPb0Qu72sIik9Hn4FvE\/8JL02Vh0879v\/O6weQjxpD7k85Kj2PGb0ej0V6xS8\/4EvPXmv3z0=","id":1234}

Remove Face
--------------------

.. warning::
   Removing a face from Tarantool will not remove it from MongoDB.

.. rubric:: Request

.. code::

    DELETE /:ver/:name/del/:id

.. rubric:: Returns:

* HTTP 200 and empty body if success.
* HTTP 404 if a face with the given id is not found in the gallery. 
* HTTP with a status other than 200 and error description in the body if failure.

.. rubric:: Example

.. code::

    $ curl -s -D - -X DELETE 'http://localhost:8001/v1/my_gal/del/1234'

    HTTP/1.1 200 Ok
    Content-length: 0
    Server: Tarantool http (tarantool v1.7.3-673-g23cc4dc)
    Connection: keep-alive

Face Search
-------------------

.. rubric:: Request

.. code::

    POST /:ver/:name/search/:limit/:threshold?linear_search 

``:limit``: the maximum number of faces in the response
``:threshold``: the minimum similarity for faces in the response (from 0 to 1).
``linear_search`` (boolean, optional): set linear_search=1 (true) to use only the linear space to search for faces. This setting has priority over the only_index setting (/etc/tarantool/instances.enabled/FindFace.lua).
``body``: a raw facen.

.. rubric:: Returns:

* A JSON array with faces with the ``conf`` and ``id`` fields in the body if success. The value in the ``X-search-stat`` header indicates whether the fast index was used for the search: ``with_index`` or ``without_index``.
* HTTP with a status other than 200 and error description in the body if failure.

.. rubric:: Example

.. code::

    $ curl -s -D - 'http://localhost:8001/v1/my_gal/search/1/0.65?linear_search=1' --data-binary @3827305024709134.facen

    HTTP/1.1 200 Ok
    Content-length: 22
    X-search-stat: without_index
    Server: Tarantool http (tarantool v1.7.3-673-g23cc4dc)
    Connection: keep-alive

    [{"conf":1,"id":1234}]

List Faces
------------------

.. rubric:: Request

.. code::

    GET /:ver/:name/list/:start_id/:count

``:start_id``: the minimum ``face_id`` in the response

``:count``: the maximum number of faces in the response

.. rubric:: Returns:

* A JSON array with faces, and the next page URL if success. Each face is provided with its id, base64 encoded facen and the name of a Tarantool space where the face is located (linear, preindex, or indexed). The next page URL should be passed as ``:start_id`` in another API request to get the next page of results. 
* HTTP with a status other than 200 and error description in the body if failure.

.. rubric:: Example

.. code::

    $ curl -s -D - 'http://localhost:8001/v1/my_gal/list/0/1' HTTP/1.1 200 Ok Content-length: 1795 Server: Tarantool http (tarantool v1.7.3-673-g23cc4dc) Connection: keep-alive {"faces":[{"id":1234,"space":"linear","facen":"BFa9PWNlS7215fI98ETQvJkxML2hUFY9cF\/Tu9ZjnLx\/uVc9EzWSPQTsR7zoysI8+4PSPIsjnr2GV1M8eFMKvfn9mjsPPjA8ZXoNvTEsSr0rJkM9MR0IPINXSj3Em0s9awm5Oos5SD380a693GroPBz6nzxQMDQ9HdO jPd7QhDxUIzC+g90sPUWUDLwjk7U9cpWkPZ83rTyEDNm8Ti\/0ve4Trr1rnQA+Yc\/KvJzqnbzOPSG998CKPBFpAr77kFO9BonDvK9B0buvjAq9Q7A\/u6awnTw0lvy80QZcvRFQAz0BdH498hF6vQKRcDy77c08mGRkvQ305DomnBM9XSqwvN54GT0ClFO9a+kWvhp7iT3uqqU9v1+\/vYhzm7uREt091douuyDKRr2PcIG9Uc8xPVJnvzt5T309NicxPD9SAr3f6sO8UmlhvRMI67wlTte880wYvUF8o7xg4\/g8aqNQu\/AAWD2z59C9CQCrPepF7Dy8qUa9iCczPfKv+Dy+bRo9KhyYPZfY0b1xtbY7nKXLuvYFbr0g8rM86o0QPRCKOj1a7rU9bd+3Pbqs7LslJcO9bBh+vVYeUr3S95Y9Wtg5PUZnRr0D0G08lkRkveImPDx4iQ084Qy1vKRBjj3uf4W85qx+vREFX7uccQ++5mMMvetNAL25b409P0GQvDIGLz3mHqg9ca\/Guv2beTy56wg7p\/hTPdxQgr0jxQQ9Ud0CPZcx\/LtRLiU9bECQvUnvszpMVcM8b3OovURPET3JdHs9LyQUPsc9JzvW1ZQ7y2ySPdN4Xb0xi9c8X7UevRqjVL0MLpE9PoQpvFxxjD2NCDO81jH\/PF1KFTzc3pc7qpaFPXxuPb2tjsY9iA5lPR1NoT1+Uuu7G6gpu727wTwo6ii8iaH+PI1WY72D9QG+8lhAPUegx71VsFs8ajQLvOdekrzGqAg+zhPLvbjyNDxaI1E9Wkj\/O1307D1ZMSk9IxqGvYCvFb1bE429hZF4vewikzwDbfG8wwYNPiQn4L2NV6Q9VKrvPTjwTr3dlG05jck+vZ\/KID1+n8Y8qpvnvOJjBj2P4+w8IJGgvROAfz1S4ve8QEouvQ5CkDu0OTI8\/v\/pvFrK5b3bkIO82LVBPcf2Yr0aGaU9RArUvEecJz1r8zk87U4vvC65ljz6kRS956U2PH6JMT5nfAg7KX7qPBz7Ejy60vk9\/iEPPYw8pT3Mfvk8UQYyPUCG+TyD5CO90c6nvSVLvDwRJSW9C3udvDORMz3zqtU8yd+0PXrubj3u9pQ9cGZIPVjlqTz6eIs8Z4wsPIjEIT3gnqI9kjhTPRJ8b73crA492KKIvSvpEz3ROrs9M+ZrO3RDOrwPpgG9+buePbiwi726dSs9k\/iVvZjEhT3W0B69IRojvQGUVj2J6vQ9FiDhPNRUO70bcum9fOOvPKA\/y7yB9wq9ntsBPYL6XL0wgkw7nLu6O\/\/USz1EoUg9JKE9PLDzNL0Pns49fPVyPJfZaj2g6pi8MuZePV0xQLxkR4W9pEe7vYTv7jytv567nakpPcCHZbsfjx89jPENPW0x87vr3Wi84L9mvSGeFL2hsBo9HBI2vXiEJr2uIQW7L0FsPU2w8jz2chi9FB5nvFcj9rknTha9qxCoPb0Qu72sIik9Hn4FvE\/8JL02Vh0879v\/O6weQjxpD7k85Kj2PGb0ej0V6xS8\/4EvPXmv3z0="}],"next":5678}


