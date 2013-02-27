require './lib/twitter_request.rb'
require './lib/cache.rb'
require 'sinatra'

CACHE = Cache.new(15 * 60)

get '/*' do
  @limit_remaining ||= 1
  @limit_reset ||= 1

  query = "#{params[:splat].first}?q=#{params["q"]}"
  if can_make_request?
    request = TwitterRequest.new(CACHE, query) 
    response = request.response
    if response.code == 200
      @limit_remaining = response.header['X-Rate-Limit-Remaining']
      @limit_reset = response.header['X-Rate-Limit-Reset']
    end
    response.body
  else
    %Q{{"errors": [{"code": 88, "message": "Rate limit exceeded"}]}}
  end
end

def can_make_request?
  @limit_remaining > 0 || Time.now.utc.to_i > @limit_reset
end
