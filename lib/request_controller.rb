require File.join(File.dirname(__FILE__), "/twitter_request.rb")

class RequestController
  def initialize cache, rate_limit_remaining=1, reset_time=Time.now.utc.to_i
    @cache = cache
    @rate_limit_remaining = rate_limit_remaining
    @reset_time = reset_time
  end

  def handle query
    if !@cache.get(query)
      return RateLimitExceededError.new if !can_request?
      response = TwitterRequest.new(query).response
      @cache.put(query, response)
      @rate_limit_remaining = response.header['X-Rate-Limit-Remaining'].to_i
      @reset_time = response.header['X-Rate-Limit-Reset'].to_i
    end
    response = @cache.get(query)
    response.header['X-Rate-Limit-Remaining'] = @rate_limit_remaining
    response.header['X-Rate-Limit-Reset'] = @reset_time
    response
  end

  def can_request?
    @rate_limit_remaining > 0 || Time.now.utc.to_i > @reset_time
  end

end

class RateLimitExceededError
  def body
    %Q{{"errors": [{"code": 88, "message": "Rate limit exceeded"}]}}
  end

  def header
    {
      'X-Rate-Limit-Remaining' => 0
    }
  end
end
