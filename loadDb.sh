#!/bin/bash
ERROR='\033[0;31m'
WARN='\033[1;33m'
INFO='\033[1;32m'
DEFAULT='\033[0m' # No Color

# Step 1 - Create the initial tables at all times.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE omop54;
    \c omop54
    \i /scripts/OMOPCDM_postgresql_5.4_ddl.sql
EOSQL


# Step 2 - Prior to setting constraints if enabled, load vocabulary if present.
PATH_TO_VOCAB=/VOCAB
if [[ -d $PATH_TO_VOCAB ]]; then
if [[ "$(ls -A $PATH_TO_VOCAB)" ]]; then
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    \c omop54
    \i /scripts/load_vocabulary.sql
EOSQL
else
echo -e "${ERROR}ERROR -- ${DEFAULT}Vocabulary Folder is Empty. Skipping load."
fi
else
echo -e "${INFO}INFO  -- ${DEFAULT}Vocabulary Folder Not Found. If this is not expected, ensure that you have your local folder mounted properly and re-run the image."
fi

# Step 3 - If constraints are enabled, set constraints.
if [[ $CONSTRAINTS = "true" ]]; then
echo -e "${INFO}INFO  -- ${DEFAULT}CONSTRAINTS equal true, building tables with constraints."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    \c omop54
    \i /scripts/OMOPCDM_postgresql_5.4_primary_keys.sql
    \i /scripts/OMOPCDM_postgresql_5.4_indices.sql
    \i /scripts/OMOPCDM_postgresql_5.4_constraints.sql
EOSQL
else
echo -e "${INFO}INFO  -- ${DEFAULT}CONSTRAINTS does not equal 'true', skipping setting constraints."
fi

