.. _architecture:

*************************************
Choose Deployment Architecture
*************************************

FindFace Enterprise Server SDK is delivered in the following distributable packages:

 * A package with components :program:`<findface-repo>.deb`.
 * Several packages with neural network models :program:`<findface-data>.deb`. Each model is delivered in a separate package.
      
     
Depending on your system characteristics and performance requirements, there are 2 FindFace Enterprise Server SDK deployments:

+----------------+-----------------------------------------------------------------------------------------------------+
| Deployment     | Recommendation                                                                                      |
+================+=====================================================================================================+
| Standalone     | You can deploy FindFace Enterprise Server SDK on a :ref:`single host (standalone) <standalone>`     |
|                | if the number of faces in the database does not exceed some 1,000,000.                              |
+----------------+-----------------------------------------------------------------------------------------------------+
| Cluster        | If the number of faces in the database does exceed 1 million, deploy FindFace Enterprise Server SDK |
|                | in a :ref:`cluster environment <cluster>` and configure fast index search. This is a medium and     |
|                | large deployment which can be scaled almost infinitely. It will also suit professional high load    |
|                | projects with severe requirements to performance.                                                   |   
+----------------+-----------------------------------------------------------------------------------------------------+

.. toctree::
   :maxdepth: 2
   :caption: In this chapter:

   standalone_architecture
   cluster_architecture
   extra_functionality


