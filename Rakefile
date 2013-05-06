require "bundler/gem_tasks"
require "rake/testtask"

desc "run tests"
Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.pattern = 'spec/*spec.rb'
  t.verbose = true
end
