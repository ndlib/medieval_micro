# Medieval Microfilms and Facsimiles Database
This application serves as a supplementary finding aid for microfilms and facsimiles in the Medieval Institute collection.

Preproduction URL: https://medieval-microfilms-and-facsimiles-prep.library.nd.edu/
Production URL: https://medieval-microfilms-and-facsimiles.library.nd.edu/

Product Owner: Julia Schneider (jschneid)

Github Repository: https://github.com/ndlib/medieval_micro

Visit the Service Runbook: [Medieval Microfilms and Facsimiles](https://github.com/ndlib/TechnologistsPlaybook/tree/master/run-books/medieval-micro.md)

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
bundle --path vendor/bundle
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

Clear all docs from the Solr development core:
```
curl http://localhost:8983/solr/update?commit=true --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
```
