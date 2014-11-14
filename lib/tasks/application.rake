namespace :app do
  desc "Raise an error unless the Rails Environment is development"
  task :development_environment_only do
    raise "This task is limited to the development environment" unless Rails.env == 'development'
  end

  desc "Raise an error if the Rails Environment is production"
  task :restrict_from_production do
    raise "This task is restricted from the production environment" if Rails.env == 'production'
  end
end

def setup_db_sync(target_environment)
  @target_db  = Rails.configuration.database_configuration[target_environment]
  @current_db = Rails.configuration.database_configuration[Rails.env]
  @sql_dump   = File.join(Rails.root,'tmp',"#{target_environment}_data.sql")
end

def dump_target_database
  puts "Dumping data from #{@target_db['database']} to #{@sql_dump}"
  `mysqldump -u #{@target_db['username']} --password=#{@target_db['password']} -h #{@target_db['host']} #{@target_db['database']} > #{@sql_dump}`
end

def load_data_from_dump
  puts "Loading data to #{@current_db['database']} from #{@sql_dump}"
  `mysql -u #{@current_db['username']} --password=#{@current_db['password']} -h #{@current_db['host']} #{@current_db['database']} < #{@sql_dump}`
end

namespace :db do
  desc "Load data from the database of the specified environment into the current environment"
  task :sync, [:target_environment] => [:environment] do |t, args|
    Rake::Task['app:restrict_from_production'].execute
    args.with_defaults(:target_environment => 'production')
    setup_db_sync(args[:target_environment])
    dump_target_database
    load_data_from_dump
  end

  desc "Dump data from the database of the specified environment into a local file"
  task :dump, [:target_environment] => [:environment] do |t, args|
    args.with_defaults(:target_environment => 'production')
    setup_db_sync(args[:target_environment])
    dump_target_database
  end

  desc "Load a data dump from the specified environment into the current environment"
  task :load_from_dump, [:target_environment] => [:environment] do |t, args|
    Rake::Task['app:restrict_from_production'].execute
    args.with_defaults(:target_environment => 'production')
    setup_db_sync(args[:target_environment])
    load_data_from_dump
  end
end
