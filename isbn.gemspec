# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{isbn}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Kersey"]
  s.date = %q{2009-01-13}
  s.description = %q{library to transform ISBN's from new to used, between 10 and 13, etc...}
  s.email = %q{entangledstate@gmail.com}
  s.files = ["VERSION.yml", "lib/isbn.rb", "test/isbn_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/entangledstate/isbn}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{a simple library of functions on ISBN's}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
