.. _bulk-face:

Bulk Face Enrollment
=========================

The Bulk Face Enrollment feature allows for enrolling faces to findface-facenapi from images in bulk.

.. contents:: In this section:

General Information
----------------------------

You can bulk-enroll faces in one of the following ways:

* from images in a current directory,
* from images in a given subdirectory,
* from images from all subdirectories. 

To install the Bulk Face Enrollment component, execute: 

.. code::

    $ sudo apt-get install findface-mass-enroll

To display the component help message, execute:

.. code::

    $ findface-mass-enroll --help

.. code::

    ## $ findface-mass-enroll --help
    Usage: findface-mass-enroll [OPTIONS] COMMAND [ARGS]...

    Options:
      --job PATH  Job file (default: ffmassenroll.job)
      --help      Show this message and exit.

    Commands:
      prepare  Prepare upload job
      print    Print contents of job file as JSON
      run      Run upload job

    $ findface-mass-enroll prepare --help
    Usage: findface-mass-enroll prepare [OPTIONS] [IMAGES]...

      This subcommand is used to prepare one or more job files for subsequent
      runs.

      Examples:

      Enrolling all *.jpg files in current directory with meta 'Phillip J. Fry':

      $ ls
      photo1.jpg photo2.jpg photo3.jpg
      $ findface-mass-enroll prepare --meta-const='Phillip J. Fry' '*.jpg'

      Enrolling all JPEGs and PNGs from a subdirectory with meta from accompanying TXT files:

      $ ls subdir
      photo1.jpg photo1.txt photo2.png photo2.txt photo3.jpeg photo3.txt
      $ findface-mass-enroll prepare --meta-companion='txt' 'subdir/*.jpg' 'subdir/*.png' 'subdir/*.jpeg'

      Enrolling JPEGs from all subdirectories with meta from CSV file:

      $ cat meta.csv
      "Phillip J. Fry","dir1/photo1.jpg"
      "Phillip J. Fry","dir1/photo2.jpg"
      "Phillip J. Fry","dir1/photo3.jpg"
      "Turanga Leela","dir2/photo1.jpg"
      "Turanga Leela","dir2/photo2.jpg"
      "Turanga Leela","dir2/photo3.jpg"
      $ ls -R
      .:
      meta.csv

      ./dir1:
      photo1.jpg photo2.jpg photo3.jpg

      ./dir2:
      photo1.jpg photo2.jpg photo3.jpg
      $ findface-mass-enroll prepare --meta-csv=meta.csv '**/*.jpg' '**/*.jpeg'

    Options:
      --meta-const TEXT      Shared metadata string
      --meta-companion TEXT  Extension of metadata files accompanying the images
                             (e.g. txt)
      --meta-csv PATH        Name of the CSV file containing metadata
      --meta-filename        Use file name (without extension) as metadata string
      --split INTEGER        Split job file into N parts (default: don't split)
      --help                 Show this message and exit.

    ## $ findface-mass-enroll print --help
    Usage: findface-mass-enroll print [OPTIONS]

      Print contents of job file as JSON

    Options:
      --failed  Show only failed images
      --help    Show this message and exit.

    ## $ findface-mass-enroll run --help
    Usage: findface-mass-enroll run [OPTIONS]

      Run upload job

    Options:
      --parallel INTEGER              Number of enroll threads (default: 10)
      --api TEXT                      API url (default: http://127.0.0.1:8000/)
                                      [required]
      --token TEXT                    API token  [required]
      --gallery TEXT                  Enroll faces into specified gallery
                                      (default: default)
      --failed                        Include failed images
      --mf-selector [all|biggest|reject]
                                      mf_selector (biggest,all,reject)
      --gender                        Extract gender
      --age                           Extract age
      --emotions                      Extract emotions
      --stats-interval INTEGER        Output stats after every STATS_INTERVAL
                                      seconds (default: 1)
      --help                          Show this message and exit.

To harness the feature, do the following:

#. Prepare a job file containing the list of images with metadata (``prepare``). If all images share the same metastring, you can specify it right in the command line when preparing the job file (``--meta-const``). If each image has a unique metastring, map metastrings to images in a CSV file (``--meta-csv``).

   .. note::
        The CSV file used as a metadata source should have the followin format: ``metastring | image``. If some images are not listed in the CSV file, their metastrings will be empty.

   .. tip::
        To write the list of images to a CSV file, you can use the command below. Each image in the list will be associated with a metastring coinciding with the image full path (in the format ``metastring | image``).

        .. code::

           $ find /home/user/sample | grep -E 'jpg|png' |awk '{print $0","$0}' > list.csv 

#. If necessary, display the job file content (``print``).

#. Enroll faces to findface-facenapi for further processing (``run``).

   .. note::
        Should an error occur during the job file processing, correct the mistake and try again with the option --failed (see examples below).

Example
-----------------

Enroll faces from all .jpg files in a /home/user/images/ directory with a shared metastring 'Phillip J. Fry':

.. code::

    ## To display the list of images in a directory, execute:
    $ ls /home/user/images/
      photo1.jpg photo2.jpg photo3.jpg ...

    ## Prepare a job file:
    $ findface-mass-enroll prepare --meta-const='Phillip J. Fry' '/home/user/images/*'

    Looking for images matching '*.jpg'
    2055 files prepared for upload
    2055 files in job file samplejob

    ## Run the job file:
    $ findface-mass-enroll run --token 'RczGgVEMizR1njHHQegNH_g9mwGl6-A1' --api http://127.0.0.1:8000/ --gender --age --emotions --mf-selector=all
    [33/2055] faces processed (4 succeeded, 9 failed, 10 skipped). 2.14 rps. [00:00:17/00:16:04]
     
    ---------------------------------------- Summary -------------------------------------------
     
    Found 2055 images in job file
    Skipped 0 already processed images
    Successfully processed 2000 images
    Failed to process 55 images


    ## Should an error occur during the job file processing, correct the mistake and try again with the option --failed:
    $ findface-mass-enroll run --token 'RczGgVEMizR1njHHQegNH_g9mwGl6-A1' --api http://127.0.0.1:8000/ --gender --age --emotions --mf-selector=all --failed

