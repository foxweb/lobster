source 'https://rubygems.org'

gem 'hanami',        '~> 1.3'
gem 'hanami-model',  '~> 1.3'
gem 'hanami-mailer', '~> 1.3'
gem 'rake'

gem 'pg'
gem 'db_schema', '~> 0.5.0'
gem 'db_schema-reader-postgres', '~> 0.2.1'
gem 'rom-factory'

gem 'bcrypt'
gem 'jwt'

gem 'awesome_pry'
gem 'oj'

gem 'rack-cors'

gem 'puma'

gem 'newrelic-hanami'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'

  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'terminal-notifier'
  gem 'terminal-notifier-guard'

  gem 'rubocop', require: false
  gem 'rubocop-performance'
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'rspec'
  gem 'rspec_junit_formatter'
end

group :production do
  # gem 'puma'
end
