#!/bin/bash

# Setup DDBB
rm -rf /opt/wordpress-database
mkdir /opt/wordpress-database
chown vagrant.vagrant /opt/wordpress-database

# Variables
IMAGE_NAME="mariadb:10.11"
CONTAINER_NAME="tmp-mariadb"

# Start MariaDB server
echo "> Start database server"
docker run --detach --rm \
    --name $CONTAINER_NAME \
    --user $(id -u vagrant):$(id -g vagrant) \
    --env MARIADB_ROOT_PASSWORD=$DATABASE_ROOT \
    --env MARIADB_DATABASE=$DATABASE_DDBB \
    --env MARIADB_USER=$DATABASE_USER \
    --env MARIADB_PASSWORD=$DATABASE_PASS \
    --volume /opt/wordpress-database:/var/lib/mysql:Z \
    $IMAGE_NAME

printf "> Wait for database to be ready "
COUNTER=0
while [ "${COUNTER}" -lt "60" ]; do
    sleep 1
    DB_READY="$(docker exec --interactive $CONTAINER_NAME mysql --user=$DATABASE_USER --password=$DATABASE_PASS --database=$DATABASE_DDBB --execute='\q' &> /dev/null; echo $?)"
    printf '.'
    if [ "${DB_READY}" -eq "0" ]; then
        break
    fi
    COUNTER=$(( $COUNTER + 1 ))
done
printf '\n'
if [ "${COUNTER}" -ge "60" ]; then
    echo "> Can't connect to database"
    exit 1
fi

# Load DDBB dump
echo "> Import database dump"
docker exec --interactive $CONTAINER_NAME \
    sh -c "exec mysql --user=$DATABASE_USER --password=$DATABASE_PASS --database=$DATABASE_DDBB" \
    < /home/vagrant/sql/dump.sql

# Update domain for local environment
echo "> Update domain name"
docker exec --interactive \
    $CONTAINER_NAME \
    mysql \
        --user=$DATABASE_USER \
        --password=$DATABASE_PASS \
        --database=$DATABASE_DDBB \
        --execute="UPDATE ${PREFIX}options SET option_value = replace(option_value, '${DOMAIN_OLD}', '${DOMAIN_NEW}') WHERE option_name = 'home' OR option_name = 'siteurl'"

# Stop MariaDB server
echo "> Stop database server"
docker stop $CONTAINER_NAME
