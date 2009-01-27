require File.dirname(__FILE__) + '/test_helper'
require 'sinatra'
require 'sinatra/test/unit'
require File.dirname(__FILE__) + '/fixtures/test_app'

class ClassyResourcesTest < Test::Unit::TestCase
  context "on GET to /posts" do
    setup do
      2.times { create_post }
      get '/posts.xml'
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal Post.all.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }
  end
end
