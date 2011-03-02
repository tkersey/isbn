$:.unshift("lib") unless $:.include?("lib")
require "isbn"

require 'rake/gempackagetask'
spec = eval(File.read("isbn.gemspec"))
Rake::GemPackageTask.new(spec).define

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.pattern = "test/**/*_test.rb"
end

desc "publish to rubygems.org"
task :publish => :build do
  `gem push isbn-#{ISBN::VERSION}.gem`
  `rm isbn-#{ISBN::VERSION}.gem`
end

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = FileList['test/**/*_test.rb', 'test/**/*_spec.rb']
  test.verbose = true
end