# -*- encoding: utf-8 -*-

$:.unshift("lib") unless $:.include?("lib")
require "isbn"

Gem::Specification.new do |s|
  s.name              = "isbn"
  s.version           = ISBN::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = %Q{a simple library of functions on ISBN\'s}
  s.homepage          = "http://github.com/entangledstate/isbn"
  s.email             = "entangledstate@gmail.com"
  s.authors           = ["Tim Kersey"]
  s.has_rdoc          = false

  s.files             = `git ls-files`.split("\n")

  s.executables       = `git ls-files bin`.split("\n").map {|f| f[/bin\/(.*)/,1]}
        
  s.description       = <<desc
  library to transform ISBN\'s from new to used, between 10 and 13, etc...
desc
end