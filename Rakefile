$:.unshift("lib") unless $:.include?("lib")
require "isbn"

desc "Build, Install and Cleanup gem"
task :install do
  `gem build isbn.gemspec`
  `gem install isbn-#{ISBN::VERSION}.gem`
  `rm isbn-#{ISBN::VERSION}.gem`
end

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.pattern = FileList['test/**/*_test.rb', 'test/**/*_spec.rb']
  test.verbose = true
end

desc "publish to rubygems.org"
task :publish => :build do
  `gem push isbn-#{ISBN::VERSION}.gem`
  `rm isbn-#{ISBN::VERSION}.gem`
end
