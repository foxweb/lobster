require 'db_schema'

DbSchema.configure(url: ENV['DATABASE_URL'])

load Hanami.root.join('db', 'schema.rb')
