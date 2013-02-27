class Cache

  def initialize expiration_time=nil
    @cache = {}
    @cache_duration = expiration_time 
  end

  def get query
    if cached_data = @cache[query]
      is_expired?(cached_data) ? nil : cached_data[:results]
    end
  end

  def put query, results
    @cache[query] = {:results => results, :storing_time => Time.now}
  end

  private
  def is_expired? cache_data
    @cache_duration && Time.now > (cache_data[:storing_time] + @cache_duration)
  end
end
