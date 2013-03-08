require File.join(File.dirname(__FILE__), "/../lib/query_builder.rb")
require File.join(File.dirname(__FILE__), "/../lib/request_controller.rb")
require File.join(File.dirname(__FILE__), "/../lib/cache.rb")
require File.join(File.dirname(__FILE__), "/../lib/twitter_request.rb")
require 'ostruct'

class Time 
  def self.is value 
    Time.stub(:now).and_return(value)
    yield   
    Time.unstub(:now)
  end
end

