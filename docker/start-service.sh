# migrate tables to database
docker-compose run feederapp rake db:migrate

# start feederapp server and postgres db
docker-compose up -d
feederapp_container_id=$(docker ps --filter "name=feederapp-container" -q)
# start webpack server
docker exec -d $feederapp_container_id /bin/sh -c "./bin/webpack-dev-server"

# connect to postgresql to check if db is populated properly
feederdb_container_id=$(docker ps --filter "name=feederdb-container" -q)
docker exec -it $feederdb_container_id psql -U user myapp_development

# stop feederapp server and postgres db
docker-compose down