# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rubocop/rake_task'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.verbose = true
  t.warning = false
  t.pattern = 'test/**/*_test.rb'
end

RuboCop::RakeTask.new(:lint) do |t|
  t.options = ['--display-cop-names']
end

RuboCop::RakeTask.new(:fix) do |t|
  t.options = ['--autocorrect-all']
end

YARD::Rake::YardocTask.new(:yard) do |t|
  t.files = ['lib/**/*.rb']
  t.options = ['--markup', 'markdown']
end

task :default do
  Rake::Task['test'].execute
  Rake::Task['lint'].execute
end
