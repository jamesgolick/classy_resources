# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{classy_resources}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Golick"]
  s.date = %q{2009-01-29}
  s.description = %q{TODO}
  s.email = %q{james@giraffesoft.ca}
  s.files = ["README.rdoc", "VERSION.yml", "lib/classy_resources", "lib/classy_resources/active_record.rb", "lib/classy_resources/mime_type.rb", "lib/classy_resources/post_body_param_parsing.rb", "lib/classy_resources/post_body_params.rb", "lib/classy_resources/sequel.rb", "lib/classy_resources.rb", "test/active_record_test.rb", "test/fixtures", "test/fixtures/active_record_test_app.rb", "test/fixtures/sequel_test_app.rb", "test/sequel_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/giraffesoft/classy_resources}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
