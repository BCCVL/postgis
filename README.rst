PostGIS
=======

Postgres database with PostGIS extension enabled.


Data storage
------------

Data is stored in /var/lib/pgsql/9.5/data .


Build
-----

.. code-block:: Shell

  docker build -t hub.bccvl.org.au/postgres/postgis:9.5.0 .

Publish
-------

.. code-block:: Shell

  docker push hub.bccvl.org.au/postgres/postgis:9.5.0
