#!/bin/bash
if [[ $CONSTRAINTS = "true" ]]; then
echo "CONSTRAINTS equal true, building tables with constraints."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE omop54;
    \c omop54
    \i /scripts/OMOPCDM_postgresql_5.4_ddl.sql
    \i /scripts/OMOPCDM_postgresql_5.4_primary_keys.sql
    \i /scripts/OMOPCDM_postgresql_5.4_indices.sql
    \i /scripts/OMOPCDM_postgresql_5.4_constraints.sql
EOSQL
else
echo "CONSTRAINTS does not equal 'true', building tables without constraints."
echo "WARNING: If you intended to build the database with constraints, ensure your environment variable is set properly to the string 'true'."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE omop54;
    \c omop54
    \i /scripts/OMOPCDM_postgresql_5.4_ddl.sql
EOSQL
fi
    #  \i /scripts/OMOPCDM_postgresql_5.4_primary_keys.sql
    #  \i /scripts/OMOPCDM_postgresql_5.4_constraints.sql  NOTE: Causes error.
    #  \i /scripts/OMOPCDM_postgresql_5.4_indices.sql