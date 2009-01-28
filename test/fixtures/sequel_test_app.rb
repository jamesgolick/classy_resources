require 'rubygems'
require 'sinatra'
require 'classy_resources/sequel'
require 'sequel'

Sequel::Model.db = Sequel.sqlite

Sequel::Model.db.instance_eval do
  create_table! :users do
    primary_key :id
    varchar :name
  end

  create_table! :subscriptions do
    primary_key :id
    int :user_id
    varchar :name
  end
end

class User < Sequel::Model(:users)
  one_to_many :subscriptions
end

class Subscription < Sequel::Model(:subscriptions)
  many_to_one :users
  validates_presence_of :user_id
end

define_resource :users, :collection => [:get, :post],
                        :member     => [:put, :delete, :get]

define_resource :subscriptions, :collection => [:get, :post],
                                :parent     => :users
