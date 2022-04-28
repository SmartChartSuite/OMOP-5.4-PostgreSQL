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

PATH_TO_VOCAB=/VOCAB
if [[ -d $PATH_TO_VOCAB ]]; then
if [[ "$(ls -A $DIR)" ]]; then
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    \c omop54
    \i /scripts/load_vocabulary.sql
EOSQL
else
echo "Vocabulary Folder is Empty."
fi
else
echo "Vocabulary Folder Not Found. If this is not expected, ensure that you have your local folder mounted properly and re-run the image."
fi