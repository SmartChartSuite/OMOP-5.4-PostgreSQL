#!/bin/bash

function healthcheck {
  STATUS=`psql -U postgres -p 5432 -d omop54 -c "SELECT * FROM f_person;"`
  if [[ $STATUS == *"person_id"* ]]; then
    echo "Ready"
    return 0
  else
    echo "Waiting on OMOPonFHIR Tables"
    return 1
  fi
}

healthcheck