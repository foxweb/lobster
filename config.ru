require './config/environment'
require 'newrelic_rpm'
require 'newrelic-hanami'

NewRelic::Agent.manual_start

run Hanami.app
