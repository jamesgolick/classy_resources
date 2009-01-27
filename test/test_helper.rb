require File.dirname(__FILE__) + '/../lib/classy_resources'
require 'rubygems'
require 'test/unit'
require 'context'
require 'zebra'
require 'mocha'
require 'activerecord'

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter  => 'sqlite3', 
                                                   :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

ActiveRecord::Schema.define(:version => 0) do
  create_table :posts do |t|
    t.string :title
  end
end

class Post < ActiveRecord::Base
end

class Test::Unit::TestCase
  protected
    def create_post(opts = {})
      Post.create!({}.merge(opts))
    end
end
