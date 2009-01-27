require 'rubygems'
require 'sinatra'
require 'classy_resources/active_record'
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


define_resource :posts, :collection => [:get, :post],
                        :member     => [:get, :put, :delete],
                        :formats    => [:xml, :json]
