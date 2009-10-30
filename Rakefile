begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "isbn"
    s.summary = "a simple library of functions on ISBN\'s"
    s.email = "entangledstate@gmail.com"
    s.homepage = "http://github.com/entangledstate/isbn"
    s.description = "library to transform ISBN\'s from new to used, between 10 and 13, etc..."
    s.authors = ["Tim Kersey"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.pattern = FileList['test/**/*_test.rb', 'test/**/*_spec.rb']
  test.verbose = true
end