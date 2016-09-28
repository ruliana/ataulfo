group :tdd, halt_on_fail: true do
  guard :rspec,
        cmd: 'bundle exec rspec -f documentation --color',
        run_all: {cmd: 'bundle exec rspec -f documentation --color'},
        keep: true,
        all_on_start: true,
        all_after_pass: true do

    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('lib/mcgee.rb') { 'spec' }
  end
  guard :rubocop, cmd: 'bundle exec rubocop', cli: '-fs -c./.rubocop.yml' do
    watch(%r{.+\.rb$})
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
