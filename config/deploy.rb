# config valid only for Capistrano 3.1
lock '3.6.0'
set :default_environment, {
  'PATH' => "/opt/ruby/current/bin:$PATH"
}
set :bundle_roles, [:app, :work]
set :bundle_flags, "--deployment --path=vendor/bundle"
set :bundle_cmd, "/opt/ruby/current/bin/bundle"
set :application, 'medieval_micro'
set :scm, :git
set :repo_url, "https://github.com/ndlib/medieval_micro.git"
set :branch, ENV["BRANCH_NAME"] || 'master'

set :keep_releases, 5
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
SSHKit.config.command_map[:bundle] = '/opt/ruby/current/bin/bundle'
SSHKit.config.command_map[:rake] = "#{fetch(:bundle)} exec rake"
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :db_create do
    on roles(:app) do
      execute :rake, 'db:create'
    end
  end

  task :db_migrate do
    on roles(:app) do
      within release_path do
        execute "export PATH=/opt/ruby/current/bin:$PATH && cd #{release_path} && bundle exec rake RAILS_ENV=#{fetch(:rails_env)} db:migrate"
      end
    end
  end

  task :precompile_assets do
    on roles(:app) do
      within release_path do
        execute "export PATH=/opt/ruby/current/bin:$PATH && cd #{release_path} && /opt/ruby/current/bin/bundle exec rake RAILS_ENV=#{fetch(:rails_env)} assets:precompile"
      end
    end
  end

  task :debug do
    on roles(:app) do
      execute "export PATH=/opt/ruby/current/bin:$PATH && which bundle && bundle --version"
    end
  end

  namespace :assets do
    task :precompile do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute "export PATH=/opt/ruby/current/bin:$PATH && cd #{release_path} && /opt/ruby/current/bin/bundle exec rake RAILS_ENV=#{fetch(:rails_env)} assets:precompile"
          end
        end
      end
    end
  end
end
