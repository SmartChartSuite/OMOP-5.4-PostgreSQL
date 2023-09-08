FROM postgres:14.1

# ENV POSTGRES_PASSWORD password

# none of these are actually executed if an intialised database is found
# (docker-entrypoint-initdb.d ignored!)
COPY ./loadDb.sh /docker-entrypoint-initdb.d/loadDb.sh
COPY ./local_temp.sh /docker-entrypoint-initdb.d/local_temp.sh

COPY ./scripts/ /scripts/
COPY ./omoponfhir/ /omoponfhir/
RUN chmod -v a+rwx /omoponfhir/healthcheck.sh
COPY ./postgresql.conf /scripts/

RUN chmod -v a+rwx /docker-entrypoint-initdb.d/loadDb.sh
RUN chmod -v a+rwx /docker-entrypoint-initdb.d/local_temp.sh