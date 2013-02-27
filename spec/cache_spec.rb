require File.join(File.dirname(__FILE__), "/../lib/cache.rb")

class Time 
  def self.is value 
    Time.stub(:now).and_return(value)
    yield   
    Time.unstub(:now)
  end
end
  
describe Cache do

  it "should return nil if the request has not been cached" do
    cache = Cache.new
    cache.get('query').should be_nil
  end
  
  
  it "should return cached value if the request has been cached less than 15 minutes" do
    cache = Cache.new(15 * 60)
    cache.put('query', 'tweets')
    cache.get('query').should == 'tweets'
  end

  it "should return nil if the request has been cached less more 15 minutes" do
    cache = Cache.new(15 * 60)
    cache.put('query', 'tweets')
    Time.is(Time.now + 20 * 60) do
      cache.get('query').should be_nil
    end
  end
end
