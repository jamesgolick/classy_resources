require 'rubygems'
gem 'activerecord', '2.2.2'
require 'activerecord'
require 'sinatra'
require 'classy_resources/active_record'

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter  => 'sqlite3', 
                                                   :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

ActiveRecord::Schema.define(:version => 0) do
  create_table :posts do |t|
    t.string :title
  end

  create_table :comments do |t|
    t.integer :post_id
    t.string :author
  end
end

class Post < ActiveRecord::Base
  has_many :comments
  validates_presence_of :title
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

set :raise_errors, false

define_resource :posts, :collection => [:get, :post],
                        :member     => [:get, :put, :delete],
                        :formats    => [:xml, :json]

define_resource :comments, :collection => [:get, :post]

use ClassyResources::PostBodyParams

