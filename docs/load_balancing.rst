.. _load-balancing:

Load Balancing with NginX
===============================

To enhance throughput and reduce latency in highload installations with severe requirements to resource optimization, we recommend you to set up
`nginx load balancing <https://www.nginx.com/resources/admin-guide/load-balancer/>`__.

With load balancing, traffic, instead of being directed to a single instance of a component, is proxied via nginx and distributed across
multiple instances of the component in a round-robin fashion. As a result, you remarkably reduce latency and improve overall performance,
scalability and reliability of your system.

Load balancing can be set up for the following components:

+---------------------+--------------------------------------------------------------------------------------------------------+
| Component           | Recommended number of instances per host                                                               |
+=====================+========================================================================================================+
| findface-facenapi   | 1 is usually enough. When it comes to findface-facenapi, load balancing is usually set up only in a    |
|                     | cluster environment with several findface-facenapi hosts, 1 findface-facenapi instance running on each |
|                     | host. In this case, traffic is distributed across these hosts.                                         |
+---------------------+--------------------------------------------------------------------------------------------------------+
| findface-nnapi      | Number of CPU cores minus 1. Gives a significant performance gain.                                     |
+---------------------+--------------------------------------------------------------------------------------------------------+
| extraction-api      | 1, automatically load-balanced. Set up load balancing only across extraction-api                       |
|                     | instances located on different physical hosts.                                                         |
+---------------------+--------------------------------------------------------------------------------------------------------+

The following step-by-step instructions demonstrate how to set up nginx load balancing for 2 findface-nnapi instances on a host. The other
components can be load-balanced by analogy. 

Do the following:

#. If necessary, install nginx on the findface-nnapi host (nginx is installed automatically along with the findface-upload component).

   .. code::

       $ sudo apt-get install nginx

#. Copy the content of the ``/lib/systemd/system/findface-nnapi.service`` file into a new file ``/etc/systemd/system/findface-nnapi@.service``.

   .. code::

       $ sudo cp /lib/systemd/system/findface-nnapi.service /etc/systemd/system/findface-nnapi@.service

#. Stop all the findface-nnapi services and disable their autostart. Edit the new file ``findface-nnapi@.service`` by appending ``--listen 127.0.0.1:%i`` to the ``ExecStart`` line.

   .. code::

       ## Stop the findface-nnapi services and disable their autostart
       $ sudo service findface-nnapi stop && sudo systemctl disable findface-nnapi

       ## Open the file
       $ sudo vi /etc/systemd/system/findface-nnapi@.service

       ## Edit the ExecStart line by appending --listen 127.0.0.1:%i
       ExecStart=/usr/bin/findface-nnapi -c /etc/findface-nnapi.ini --listen 127.0.0.1:%i

#. Create a new nginx configuration file. 

   .. code::

       $ sudo vi /etc/nginx/sites-available/nnapi

#. Insert the following `text <https://raw.githubusercontent.com/NTech-Lab/FFSER-file-examples/master/nnapi>`__ into the configuration file. In the text, substitute provided ports for findface-nnapi instances ('upstream nnapibackends') and the findface-nnapi listening port ('listen') with their actual values. Port numbers should be unique for each component on the host.

   .. code::

       upstream nnapibackends {
               server 127.0.0.1:18090;
               server 127.0.0.1:18091;
       }
       server {
               listen 18088;
               server_name nnapi;
               client_max_body_size 64m;
               location / {
                       proxy_pass http://nnapibackends;
                       proxy_next_upstream error;
               }
               access_log /var/log/nginx/nnapi.access_log;
               error_log /var/log/nginx/nnapi.error_log;
       }


#. Enable the load balancer in nginx.

   .. code::

       $ sudo ln -s /etc/nginx/sites-available/nnapi /etc/nginx/sites-enabled/

#. Restart nginx.

   .. code::

       $ sudo service nginx restart

#. For each findface-nnapi instance, enable autostart.

   .. code::

       $ sudo systemctl enable findface-nnapi@18090
       $ sudo systemctl enable findface-nnapi@18091

#. Start the findface-nnapi instances.

   .. code::

       $ sudo systemctl start findface-nnapi@18090
       $ sudo systemctl start findface-nnapi@18091

#. From now on, requests sent to findface-nnapi will be distributed over 2 findface-nnapi instances in the round-robin mode. You can view the
   process of requests distribution in the findface-nnapi log file /var/log/syslog (look for different process_id values).

   .. code::

       $ sudo tail -f /var/log/syslog | grep nnapi
       Jul  7 03:53:05 ubuntu findface-nnapi[49606]: (2017-07-07 10:53:05) [INFO    ] Request: 127.0.0.1:34494 0x7fb100000960 HTTP/1.0 POST /facen
       Jul  7 03:53:06 ubuntu findface-nnapi[49606]: (2017-07-07 10:53:06) [INFO    ] Response: 0x7fb100000960 /facen?x2=0&y1=0&x1=0&y2=0 200 0
       Jul  7 03:53:06 ubuntu findface-nnapi[49624]: (2017-07-07 10:53:06) [INFO    ] Request: 127.0.0.1:52960 0x7f9cf8000960 HTTP/1.0 POST /facen
       Jul  7 03:53:06 ubuntu findface-nnapi[49624]: (2017-07-07 10:53:06) [INFO    ] Response: 0x7f9cf8000960 /facen?x2=0&y1=0&x1=0&y2=0 200 0
       Jul  7 03:53:32 ubuntu findface-nnapi[49606]: (2017-07-07 10:53:32) [INFO    ] Request: 127.0.0.1:34502 0x7fb100001ec0 HTTP/1.0 POST /facen
       Jul  7 03:53:32 ubuntu findface-nnapi[49606]: (2017-07-07 10:53:32) [INFO    ] Response: 0x7fb100001ec0 /facen?x2=0&y1=0&x1=0&y2=0 200 0
       Jul  7 03:53:32 ubuntu findface-nnapi[49624]: (2017-07-07 10:53:32) [INFO    ] Request: 127.0.0.1:52968 0x7f9cf8001ec0 HTTP/1.0 POST /facen
       Jul  7 03:53:33 ubuntu findface-nnapi[49624]: (2017-07-07 10:53:33) [INFO    ] Response: 0x7f9cf8001ec0 /facen?x2=0&y1=0&x1=0&y2=0 200 0

#. You can use this method to set up load balancing across instances on several physical hosts.

