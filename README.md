# Medieval Microfilms and Facsimiles Database
This application serves as a supplementary finding aid for microfilms and facsimiles in the Medieval Institute collection.

Production URL: https://medieval-microfilms-and-facsimiles.library.nd.edu/

Product Owner: Julia Schneider (jschneid)

## Setting up your development environment

Install and run mysql5.1:
Download 5.1 from https://downloads.mysql.com/archives/community/
```
export PATH=/usr/local/mysql/bin:/usr/local/mysql/support-files:$PATH
sudo -u mysql mysql.server start
```

Install ruby & project dependencies:
```
rbenv install `cat .ruby-version`
gem install bundler
bundle
```

Create the database and load data from production:
```
bundle exec rake db:create db:schema:load db:sync[production]
```

Set up Solr:
```
bundle exec rake jetty:clean jetty:configure
```

Start Solr:
```
bundle exec rake jetty:start
```

Populate the Solr index with data from the database:
```
bundle exec rake solr:index:all
```
