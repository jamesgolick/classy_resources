require File.dirname(__FILE__) + '/test_helper'
require 'sinatra'
require 'sinatra/test/unit'
require File.dirname(__FILE__) + '/fixtures/active_record_test_app'

class ActiveRecordTest < Test::Unit::TestCase
  context "on GET to /posts with xml" do
    setup do
      2.times { create_post }
      get '/posts.xml'
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal Post.all.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }
  end

  context "on GET to /posts with json" do
    setup do
      2.times { create_post }
      get '/posts.json'
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal Post.all.to_json, @response.body }
    expect { assert_equal "application/json", @response.content_type }
  end

  context "on POST to /posts" do
    setup do
      Post.destroy_all
      post '/posts.xml', :post => {:title => "whatever"}
    end

    expect { assert_equal 302, @response.status }
    expect { assert_equal "/posts/#{Post.first.id}.xml", @response.location }
    expect { assert_equal "whatever", Post.first.title }
    expect { assert_equal "application/xml", @response.content_type }
  end

  context "on GET to /posts/id" do
    setup do
      @post = create_post
      get "/posts/#{@post.id}.xml"
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal @post.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }
  end

  context "on PUT to /posts/id" do
    setup do
      @post = create_post
      put "/posts/#{@post.id}.xml", :post => {:title => "Changed!"}
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal @post.reload.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }

    should "update the post" do
      assert_equal "Changed!", @post.reload.title
    end
  end

  context "on DELETE to /posts/id" do
    setup do
      @post = create_post
      delete "/posts/#{@post.id}.xml"
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal "application/xml", @response.content_type }

    should "destroy the post" do
      assert_nil Post.find_by_id(@post)
    end
  end
end
