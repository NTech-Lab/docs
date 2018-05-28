.. _token:

Create Authentication Token
==================================

Once the FindFace Server сomponents installed, create a token in the long or short format, depending on your preference. Either format, this token will be valid to authenticate your FindFace Enterprise Server SDK instance in API requests.

To create a long token, execute:
::

 findface-facenapi.token

 ##0123456789_abcdefghijklmnopqrstuvw

To create a short token, execute:
::

 findface-facenapi.token --short
 ##A0B1-C2D3
 
If MongoDB is installed on a remote host, you have to indicate the path to the ``findface-facenapi.ini`` configuration file in the token generation command.
::

 sudo findface-facenapi.token --config=/etc/findface-facenapi.ini

.. note::
   Use the authentication token to access the FindFace Web User Interface at ``http://<facenapi_ip>:8000/#/``. See :ref:`ffui` for details.

