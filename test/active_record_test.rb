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

    expect { assert_equal 201, @response.status }
    expect { assert_equal "/posts/#{Post.first.id}.xml", @response.location }
    expect { assert_equal "whatever", Post.first.title }
    expect { assert_equal "application/xml", @response.content_type }
    expect { assert_equal Post.first.to_xml, @response.body }
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

  context "on GET to /posts/id/comments" do
    setup do
      @post = create_post
      2.times { @post.comments.create!(hash_for_comment) }
      2.times { create_comment }
      get "/posts/#{@post.id}/comments.xml"
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal "application/xml", @response.content_type }
    expect { assert_equal @post.comments.to_xml, @response.body }
  end

  context "on POST to /posts/id/comments" do
    setup do
      Comment.destroy_all
      @post = create_post
      post "/posts/#{@post.id}/comments.xml", :comment => hash_for_comment
    end

    expect { assert_equal 201, @response.status }
    expect { assert_equal "application/xml", @response.content_type }
    expect { assert_equal "/comments/#{@post.comments.reload.first.id}.xml", @response.location }
    expect { assert_equal 1, @post.comments.reload.count }
    expect { assert_equal Comment.first.to_xml, @response.body }
  end

  context "on POST to /posts/id/comments with a JSON post body" do
    setup do
      @post = create_post
      post "/posts/#{@post.id}/comments.xml", {:comment => hash_for_comment(:author => 'james')}.to_json,
                                              :content_type => 'application/json'
    end

    expect { assert_equal 201, @response.status }
    expect { assert_equal "application/xml", @response.content_type }
    expect { assert_equal "/comments/#{@post.comments.reload.first.id}.xml", @response.location }
    expect { assert_equal 1, @post.comments.reload.count }
    expect { assert_equal 'james', @post.comments.first.author }
  end

  context "on POST to /posts/id/comments with a XML post body" do
    setup do
      @post = create_post
      post "/posts/#{@post.id}/comments.xml", Comment.new(:author => 'james').to_xml,
                                              :content_type => 'application/xml'
    end

    expect { assert_equal 201, @response.status }
    expect { assert_equal "application/xml", @response.content_type }
    expect { assert_equal "/comments/#{@post.comments.reload.first.id}.xml", @response.location }
    expect { assert_equal 1, @post.comments.reload.count }
    expect { assert_equal 'james', @post.comments.first.author }
  end
end
