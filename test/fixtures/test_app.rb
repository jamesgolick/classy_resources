require 'rubygems'
require 'sinatra'

define_resource :posts, :collection => [:get, :post],
                        :member     => [:get, :put, :delete]
