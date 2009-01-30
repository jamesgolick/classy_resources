require File.dirname(__FILE__) + '/test_helper'
require 'sinatra'
require 'sinatra/test/unit'
require File.dirname(__FILE__) + '/fixtures/sequel_test_app'
require 'activesupport'

class SequelErrorsToXmlTest < Test::Unit::TestCase
  context "serializing a sequel errors object" do
    before do
      @subscription = Subscription.new
      @subscription.valid?
    end

    should "serialize in a format that is active resource compatible" do
      str =<<-__END__
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error>user_id is not present</error>
</errors>
__END__
      assert_equal str, @subscription.errors.to_xml
    end
  end
end

