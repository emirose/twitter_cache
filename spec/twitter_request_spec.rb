require File.join(File.dirname(__FILE__), "/../lib/twitter_request.rb")
require "ostruct"

describe TwitterRequest do

  it "should authenticate" do
    request = TwitterRequest.new(Cache.new, "/search")
    request.access_token.should_not be_nil
  end
  
  it "should make a request to Twitter" do
    request = TwitterRequest.new(Cache.new, "search/tweets.json?q=wine") 
    request.access_token.should_receive(:request).with(:get, "https://api.twitter.com/1.1" +"/search/tweets.json?q=wine").and_return(OpenStruct.new(:code => 200))
    request.response.code.should be_equal(200)
  end
  
end
