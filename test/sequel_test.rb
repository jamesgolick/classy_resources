require File.dirname(__FILE__) + '/test_helper'
require 'sinatra'
require 'sinatra/test/unit'
require File.dirname(__FILE__) + '/fixtures/sequel_test_app'
require 'activesupport'

class Sequel::Model
  def to_xml(opts={})
    values.to_xml(opts)
  end
end

class SequelTest < Test::Unit::TestCase
  context "on GET to /users with xml" do
    setup do
      2.times { create_user }
      get '/users.xml'
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal User.all.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }
  end

  context "on POST to /users" do
    setup do
      User.destroy_all
      post '/users.xml', :user => {:name => "whatever"}
    end

    expect { assert_equal 302, @response.status }
    expect { assert_equal "/users/#{User.first.id}.xml", @response.location }
    expect { assert_equal "whatever", User.first.name }
    expect { assert_equal "application/xml", @response.content_type }
  end

  context "on GET to /users/id" do
    setup do
      @user = create_user
      get "/users/#{@user.id}.xml"
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal @user.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }
  end

  context "on PUT to /users/id" do
    setup do
      @user = create_user
      put "/users/#{@user.id}.xml", :user => {:name => "Changed!"}
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal @user.reload.to_xml, @response.body }
    expect { assert_equal "application/xml", @response.content_type }

    should "update the user" do
      assert_equal "Changed!", @user.reload.name
    end
  end

  context "on DELETE to /users/id" do
    setup do
      @user = create_user
      delete "/users/#{@user.id}.xml"
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal "application/xml", @response.content_type }

    should "destroy the user" do
      assert_nil User.find(:id => @user.id)
    end
  end

  context "on GET to /users/id/comments" do
    setup do
      @user = create_user
      2.times { @user.add_subscription(create_subscription) }
      2.times { create_subscription }
      get "/users/#{@user.id}/subscriptions.xml"
    end

    expect { assert_equal 200, @response.status }
    expect { assert_equal "application/xml", @response.content_type }
    expect { assert_equal @user.subscriptions.to_xml, @response.body }
  end

  #context "on POST to /posts/id/comments" do
  #  setup do
  #    @post = create_post
  #    post "/posts/#{@post.id}/comments.xml", :comment => hash_for_comment
  #  end

  #  expect { assert_equal 302, @response.status }
  #  expect { assert_equal "application/xml", @response.content_type }
  #  expect { assert_equal "/comments/#{@post.comments.reload.first.id}.xml", @response.location }
  #  expect { assert_equal 1, @post.comments.reload.count }
  #end
end
