guard :bundler do
  watch('Gemfile')
end

group :red_green_refactor, halt_on_fail: true do
  # don't run rubocop when tests fail
  guard :rspec, cmd: 'bundle exec rspec', all_on_start: true do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    rspec = dsl.rspec
    watch(rspec.spec_helper)  { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    dsl.watch_spec_files_for(%r{apps/(.*)\.rb})
    dsl.watch_spec_files_for(%r{lib/(.*)\.rb})

    watch(%r{apps/api/serializers/(.*)\.rb}) do |m|
      "#{rspec.spec_dir}/api/controllers/#{m[1]}_spec.rb"
    end

    action_specs = "#{rspec.spec_dir}/api/controllers"

    watch('apps/api/application.rb')           { action_specs }
    watch('apps/api/controllers/rendering.rb') { action_specs }

    watch('db/schema.rb') { rspec.spec_dir }

    watch(%r{spec/factories/.*\.rb}) { rspec.spec_dir }
  end

  guard :rubocop, notification: true do
    watch(/.+\.rb$/)
    watch('Gemfile')
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
