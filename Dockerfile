FROM postgres:14.1

# ENV POSTGRES_PASSWORD password

COPY ./loadDb.sh /docker-entrypoint-initdb.d/loadDb.sh
COPY ./scripts/ /scripts/
COPY ./omoponfhir/ /omoponfhir/
RUN chmod -v a+rwx /omoponfhir/healthcheck.sh

RUN chmod -v a+rwx /docker-entrypoint-initdb.d/loadDb.sh