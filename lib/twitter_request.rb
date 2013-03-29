require "oauth"
require "json"

class TwitterRequest
  
  def initialize(path)
    @path = path
  end

  def access_token
    consumer = OAuth::Consumer.new(ENV['API_KEY'], ENV['API_SECRET'], {})
    token_hash = { :oauth_token => ENV['OAUTH_TOKEN'], :oauth_token_secret => ENV['OAUTH_TOKEN_SECRET']}
    @access_token ||= OAuth::AccessToken.from_hash(consumer, token_hash )
  end

  def response 
    access_token.request(:get, "https://api.twitter.com/1.1/" + @path)
  end

end




