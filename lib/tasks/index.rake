namespace :solr do
  namespace :index do

    desc "Index all microfilm records WITHOUT commiting changes to the index."
    task :microfilms => :environment do
      Microfilm.all.each do |microfilm|
        puts "Indexing Microfilm ID:#{microfilm.id}"
        Blacklight.solr.add microfilm.as_solr
      end
    end

    desc "Index all facsimile records WITHOUT commiting changes to the index."
    task :facsimiles => :environment do
      Facsimile.all.each do |facsimile|
        puts "Indexing Facsimile ID:#{facsimile.id}"
        Blacklight.solr.add facsimile.as_solr
      end
    end

    desc "Index all microfilm and facsimile records AND commit changes to the index"
    task :all => :environment do
      Rake::Task['solr:index:microfilms'].execute
      Rake::Task['solr:index:facsimiles'].execute
      Rake::Task['solr:index:commit'].execute
      Rake::Task['solr:index:optimize'].execute
    end

    desc "Commit changes to solr index"
    task :commit => :environment do
      puts "Commiting Solr index."
      start = Time.now
      Blacklight.solr.commit
      puts "Commiting took #{Time.now - start}s"
    end

    desc "Optimize solr index"
    task :optimize => :environment do
      puts "Optimizing Solr index."
      start = Time.now
      Blacklight.solr.optimize
      puts "Optimization took #{Time.now - start}s"
    end

  end
end
