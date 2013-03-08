require "oauth"
require "json"

class TwitterRequest
CONFIG = JSON.parse(File.new(File.join(File.dirname(__FILE__), "/../config.json")).read)
  
  def initialize(path)
    @path = path
  end

  def access_token
    consumer = OAuth::Consumer.new(CONFIG['api_key'], CONFIG['api_secret'], {})
    token_hash = { :oauth_token => CONFIG['oauth_token'], :oauth_token_secret =>CONFIG['oauth_token_secret']}
    @access_token ||= OAuth::AccessToken.from_hash(consumer, token_hash )
  end

  def response 
    access_token.request(:get, "https://api.twitter.com/1.1/" + @path)
  end

end




