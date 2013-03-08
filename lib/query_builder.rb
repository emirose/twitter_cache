class QueryBuilder
  def self.build_from(params)
    query = params[:splat].first
    if params['q']
      query += "?q=#{params['q']}"
    end
    query
  end
end
