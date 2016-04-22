#!/bin/bash

LOCALE=${LOCALE:-en_US}
ENCODING=${ENCODING:-UTF-8}

POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWD=${POSTGRES_PASSWD:-postgres}

PATH=/usr/pgsql-9.5/bin:$PATH

export PGUSER=${POSTGRES_USER}
PG_DATA=${PG_DATA:-/var/lib/pgsql/9.5/data}

chown postgres:postgres ${PG_DATA}
chmod 700 ${PG_DATA}


# update SSL CERTS if in use
if [ -n "${POSTGRES_SSL_CERT}" ] ; then
    chown postgres:postgres "${POSTGRES_SSL_CERT}"
fi
if [ -n "${POSTGRES_SSL_KEY}" ] ; then
    chown postgres:postgres "${POSTGRES_SSL_KEY}"
    chmod 600 "${POSTGRES_SSL_KEY}"
fi

# Check if data folder is empty. If it is, start the dataserver
if [ ! "$(ls -A ${PG_DATA})" ] ; then

    su postgres -c "initdb --encoding=${ENCODING} --locale=${LOCALE}.${ENCODING} --lc-collate=${LOCALE}.${ENCODING} --lc-monetary=${LOCALE}.${ENCODING} --lc-numeric=${LOCALE}.${ENCODING} --lc-time=${LOCALE}.${ENCODING} -D ${PG_DATA}"

    # Modify basic configutarion
    su postgres -c "echo \"host all all 0.0.0.0/0 md5\" >> $PG_DATA/pg_hba.conf"
    su postgres -c "echo \"listen_addresses='*'\" >> $PG_DATA/postgresql.conf"

    if [ -n "${POSTGRES_SSL_CERT}" -a -n "${POSTGRES_SSL_KEY}" ] ; then
        su postgres -c "echo \"ssl=on\" >> \"${PG_DATA}/postgresql.conf\""
        su postgres -c "echo \"ssl_cert_file='${POSTGRES_SSL_CERT}'\" >> \"$PG_DATA/postgresql.conf\""
        su postgres -c "echo \"ssl_key_file='${POSTGRES_SSL_KEY}'\" >> \"$PG_DATA/postgresql.conf\""
    fi

    # Establish postgres user password and run the database
    su postgres -c "pg_ctl -w -D ${PG_DATA} start" && su postgres -c "psql -h localhost -U postgres -p 5432 -c \"alter role postgres password '${POSTGRES_PASSWD}';\"" && su postgres -c "pg_ctl -w -D ${PG_DATA} stop"
fi

# start db for setup:
su postgres -c "pg_ctl -w -D ${PG_DATA} start"

# Create the 'template_postgis' template db
psql <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Load postgis extension into template
psql --dbname="template_postgis" <<-'EOSQL'
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
EOSQL

# stop db for setup:
su postgres -c "pg_ctl -w -D ${PG_DATA} stop"

# Start the database
su postgres -c "postgres -D $PG_DATA"
