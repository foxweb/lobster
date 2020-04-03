require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require 'hanami/middleware/body_parser'
require_relative './db_schema'
require_relative '../apps/api/application'

Hanami.configure do # rubocop:disable Metrics/BlockLength
  mount Api::Application, at: '/'

  middleware.use Hanami::Middleware::BodyParser, :json

  model do
    adapter :sql, ENV.fetch('DATABASE_URL')

    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/lobster/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :staging do
    logger level: :warn, formatter: :json, filter: []

    mailer do
      delivery :smtp,
               address:   ENV.fetch('SMTP_HOST'),
               port:      ENV.fetch('SMTP_PORT'),
               domain:    ENV.fetch('SMTP_DOMAIN'),
               user_name: ENV.fetch('SMTP_USER'),
               password:  ENV.fetch('SMTP_PASSWORD')
    end
  end

  environment :production do
    logger level: :warn, formatter: :json, filter: []

    mailer do
      delivery :smtp,
               address:   ENV.fetch('SMTP_HOST'),
               port:      ENV.fetch('SMTP_PORT'),
               domain:    ENV.fetch('SMTP_DOMAIN'),
               user_name: ENV.fetch('SMTP_USER'),
               password:  ENV.fetch('SMTP_PASSWORD')
    end
  end
end
