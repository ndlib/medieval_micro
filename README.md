# Medieval Microfilms and Facsimiles Database
This application serves as a supplementary finding aid for microfilms and facsimiles in the Medieval Institute collection.

Production URL: https://medieval-microfilms-and-facsimiles.library.nd.edu/

Product Owner: Julia Schneider (jschneid)

## Setting up your development environment

Install ruby & project dependencies:
```
rbenv install `cat .ruby-version`
gem install bundler
bundle
```

Create the database and load data from production:
```
mysql.server start
bundle exec rake db:create db:migrate db:sync[production]
```

Set up Solr:
```
bundle exec rake jetty:clean jetty:configure
```

Populate the Solr index with data from the database:
```
bundle exec rake solr:index:all
```
