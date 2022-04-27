FROM postgres:14.1

# ENV POSTGRES_PASSWORD password

COPY ./loadDb.sh /docker-entrypoint-initdb.d/loadDb.sh
COPY ./scripts/ /scripts/

RUN chmod -v a+rwx /docker-entrypoint-initdb.d/loadDb.sh