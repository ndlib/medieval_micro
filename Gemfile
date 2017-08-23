source 'https://rubygems.org'

gem 'blacklight', '~> 4.5.0'
gem 'cancan', '~> 1.6.10'
gem 'devise', '~> 3.0.3'
gem 'devise_cas_authenticatable', '~> 1.3.2'
gem 'fastercsv'
gem 'formtastic', '3.0'
gem 'jbuilder', '~> 2.0'
gem 'kaminari', github: 'harai/kaminari', branch: 'route_prefix_prototype'
gem 'mysql2'
gem 'net-ldap', '~> 0.1.1', require: 'net/ldap'
gem 'protected_attributes'
gem 'rails', '4.0.11'
gem 'rb-readline'
gem 'unicode', platforms: [:mri_18, :mri_19]

# Assets
gem 'bootstrap-sass'
gem 'coffee-rails', '~> 4.0.0'
gem 'hesburgh_assets', git: 'git@git.library.nd.edu:assets', branch: 'assets-work-around-post-renovation'
gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'jettywrapper'
end

group :development, :test do
  gem 'database_cleaner', '< 1.1.0'
  gem 'rspec-rails', '~> 3.0.0'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :deploy do
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails'
end
