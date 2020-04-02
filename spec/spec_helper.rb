ENV['HANAMI_ENV'] ||= 'test'

require_relative '../config/environment'
Hanami.boot
Hanami::Utils.require!("#{__dir__}/support")

ROLE_PERMISSIONS = YAML.load_file('db/seeds/roles.yml').freeze

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

  config.before(:suite) do
    Factory.create(:role, RoleRepository.new)
    Factory.create(:support_role, RoleRepository.new)
  end

  config.after(:suite) do
    RoleRepository.new.clear
  end
end

RSpec::Matchers.define :eq_timestamp do |expected|
  match do |actual|
    (actual - expected).abs <= 2
  end
end

Factory = ROM::Factory.configure do |c|
  c.rom = Hanami::Model.container
end

def Factory.create(factory_name, repository = nil, **args)
  repo = repository || Hanami::Utils::Class.load!(
    Hanami::Utils::String.classify(factory_name) + 'Repository'
  ).new
  struct = self[factory_name, **args]

  repo.find(struct.id)
end

Hanami::Utils.require!("#{__dir__}/factories")
