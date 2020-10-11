docker-compose build

# migrate tables to database
# need to make sure that migration should happen from inside the container and not triggered from outside rake
# Something like this inside Dockerfile should do --> RUN bundle exec rake db:migrate
docker-compose run feederapp bundle exec rake db:migrate

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