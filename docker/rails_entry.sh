# All the things that will execute when starting the rails service
# Copy the generated lock file back into the project root. This is to sync this change back to the
# application after the container has mounted the sync volume
cp /bundle/Gemfile.lock ./
chmod a+x ./docker/wait-for-it.sh
bash docker/wait-for-it.sh mysql:3306
# bundle exec rake db:create db:schema:load
# If we find people are ok with just starting a shell in the container and running the db create/load before running specs, then we can remove this
# RAILS_ENV=development bundle exec rake db:create db:schema:load
# Precompile Assets
bundle exec rake RAILS_ENV=development assets:precompile
#bundle exec rake RAILS_ENV=development db:migrate
#bundle exec rake RAILS_ENV=development jetty:clean jetty:configure
bundle exec rake RAILS_ENV=development solr:index:all

exec bundle exec rails s -e development -b 0.0.0.0 # -p 3000 # --ssl --ssl-key-file dev_server_keys/server.key --ssl-cert-file dev_server_keys/server.crt