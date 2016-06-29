require 'fileutils'

namespace :jetty do
  desc 'Set blacklight-jetty to use configuration files in solr_config'
  task :configure do
    config_path = File.expand_path('solr_conf/conf', Rails.root)
    target_path = File.expand_path('jetty/solr/blacklight-core/conf', Rails.root)
    if Dir.exist?(target_path)
      if Dir.exist?(config_path)
        puts 'INFO: Removing packaged config files in jetty'
        FileUtils.rmdir(target_path)
        puts 'INFO: Installing local config file'
        FileUtils.cp_r(config_path, target_path)
        puts 'SUCCESS: Local Solr config files installed'
      else
        puts "FAIL: #{config_path} does not exist. No files to copy."
      end
    else
      puts 'FAIL: jetty directory not found. Run `bundle exec rake jetty:clean` first.'
    end
  end
end
