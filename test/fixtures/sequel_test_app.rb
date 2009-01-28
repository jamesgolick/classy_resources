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
end

class User < Sequel::Model(:users)
end

define_resource :users, :collection => [:get, :post],
                        :member     => :put
