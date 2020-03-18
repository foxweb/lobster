ENV['HANAMI_ENV'] ||= 'test'

require_relative '../config/environment'
Hanami.boot
Hanami::Utils.require!("#{__dir__}/support")

RSpec.configure do |config|
  config.include RequestHelpers, type: :action

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end

# Factory = ROM::Factory.configure do |c|
#   c.rom = Hanami::Model.container
# end

# def Factory.create(factory_name, repository = nil, **args)
#   repo = repository || Hanami::Utils::Class.load!(
#     Hanami::Utils::String.classify(factory_name) + 'Repository'
#   ).new
#   struct = self[factory_name, **args]
#
#   repo.find(struct.id)
# end
#
# Hanami::Utils.require!("#{__dir__}/factories")
