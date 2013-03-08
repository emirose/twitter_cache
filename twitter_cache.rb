require './lib/request_controller.rb'
require './lib/query_builder.rb'
require './lib/cache.rb'
require 'sinatra'

cache = Cache.new(15 * 60)
REQUEST_CONTROLLER = RequestController.new(cache)

get '/*' do
  query = QueryBuilder.build_from(params)
  REQUEST_CONTROLLER.handle(query).body
end

