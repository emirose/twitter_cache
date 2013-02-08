require './lib/twitter_request.rb'
require 'sinatra'

get '/*' do
 query = params[:splat].first + "?q=" + params["q"]
 request= TwitterRequest.new(query) 
 request.response.body
end

