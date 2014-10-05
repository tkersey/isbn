$:.unshift("lib") unless $:.include?("lib")
version = open("VERSION").read.strip

desc "Build, Install and Cleanup gem"
task :install do
  `gem build isbn.gemspec`
  `gem install isbn-#{version}.gem`
  `rm isbn-#{version}.gem`
end

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.pattern = FileList['test/**/*_test.rb', 'test/**/*_spec.rb']
  test.verbose = true
end

desc "publish to rubygems.org"
task :publish  do
  `gem build isbn.gemspec`
  `gem push isbn-#{version}.gem`
  `rm isbn-#{version}.gem`
end
