require File.dirname(__FILE__) + '/../lib/classy_resources'
require 'rubygems'
require 'test/unit'
require 'context'
require 'zebra'
require 'mocha'

class Test::Unit::TestCase
  protected
    def create_post(opts = {})
      Post.create!({}.merge(opts))
    end
end
