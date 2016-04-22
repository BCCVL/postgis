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

Env Vars:
---------

  - LOCALE="en_US"
  - ENCODING="UTF-8"
  - POSTGRES_USER="postgres"
  - POSTGRES_PASSWD="postgres"
  - PG_DATA=/var/lib/pgsql/9.5/data
  - POSTGRES_SSL_CERT= path to cert file .... may have intermediate and root certs appended
  - POSTGRES_SSL_KEY=... private key file



Memory tuning:
--------------
  - systems with more than 1GB of ram should use ~25% for shared_buffers
  - default logging goes to stderr
