require 'airbrake'

Airbrake.configure do |c|
  c.project_id = ENV['AIRBRAKE_PROJECT_ID']
  c.project_key = ENV['AIRBRAKE_PROJECT_KEY']

  c.root_directory = Hanami.root
  c.logger = Hanami.logger
  c.logger.level = Hanami::Logger::WARN
  c.environment = ENV['HANAMI_ENV']
  c.ignore_environments = %w[development test]
  c.blacklist_keys = [:password]
  c.performance_stats = true
end

Airbrake.merge_context(app_name: ENV['APP_NAME'])
