require './lib/twitter_request.rb'
require './lib/cache.rb'
require 'sinatra'

CACHE = Cache.new(15 * 60)

get '/*' do
 query = "#{params[:splat].first}?q=#{params["q"]}"
 request= TwitterRequest.new(CACHE, query) 
 request.response.body
end

