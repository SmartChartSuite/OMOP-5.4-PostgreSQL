echo starting script...
# create temporary directory for postgres in docker
mkdir /tmp/stat_temporary 

# copy your postgresql.conf to postgresql config location in docker
cat /scripts/postgresql.conf >> /var/lib/postgresql/data/postgresql.conf

echo finished
# REF: https://stackoverflow.com/questions/66325175/docker-container-with-postgres-warning-could-not-open-statistics-file-pg-stat
