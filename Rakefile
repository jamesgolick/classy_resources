require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "classy_resources"
    s.summary = "Instant ActiveResource compatible resources. Think resource_controller, for sinatra."
    s.email = "james@giraffesoft.ca"
    s.homepage = "http://github.com/giraffesoft/classy_resources"
    s.description = "TODO"
    s.authors = ["James Golick"]
    s.add_dependency "activesupport", "2.2.2"
    s.add_dependency "sinatra-sinatra", "~>0.9.0.4"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new(:active_record) do |t|
  t.libs << 'lib'
  t.pattern = 'test/active_record_test.rb'
  t.verbose = false
end

Rake::TestTask.new(:sequel) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/sequel*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'classy_resources'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => [:active_record, :sequel]
