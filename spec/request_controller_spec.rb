require File.join(File.dirname(__FILE__), "/spec_helper.rb")

describe RequestController do
  before do
    @query = 'search?q=wine'
    @cache = Cache.new
  end
  it "should make request at start" do
    request = mock
    controller = RequestController.new(@cache)
    TwitterRequest.should_receive(:new).with(@query).and_return(request)
    expected_response = OpenStruct.new(body: :request, header: {'X-Rate-Limit-Remaining'=> '10', 'X-Rate-Limit-Reset' => '500'})
    request.stub(:response).and_return(expected_response)
    response = controller.handle(@query)
    response.body.should == :request
    response.header['X-Rate-Limit-Remaining'].should == 10
    response.header['X-Rate-Limit-Reset'].should == 500
  end

  it "should use cached value if already cached" do
    cached_response = OpenStruct.new(body: :cached, header: {'X-Rate-Limit-Remaining'=> '10'})
    @cache.put(@query, cached_response)
    controller = RequestController.new(@cache, 1, 1)
    response = controller.handle(@query)
    response.body.should == :cached
    response.header['X-Rate-Limit-Remaining'].should == 1
    response.header['X-Rate-Limit-Reset'].should == 1
  end
  
  context "exceeding api limits" do
    it "should return an error if trying to request before reset time" do
      controller = RequestController.new(@cache, 0)
      response = controller.handle(@query)
      response.body.should == %Q{{"errors": [{"code": 88, "message": "Rate limit exceeded"}]}}
      response.header['X-Rate-Limit-Remaining'].should == 0
    end

    it "should make request after reset time" do
      controller = RequestController.new(@cache, 0, (Time.now + 14*60).utc.to_i)
      Time.is(Time.now + 15*60) do
        request = mock
        TwitterRequest.should_receive(:new).with(@query).and_return(request)
        expected_response = OpenStruct.new(body: :request, header: {'X-Rate-Limit-Remaining'=> 10, 'X-Rate-Limit-Reset' => 500})
        request.stub(:response).and_return(expected_response)
        response = controller.handle(@query)
        response.body.should == :request
        response.header['X-Rate-Limit-Remaining'].should == 10
        response.header['X-Rate-Limit-Reset'].should == 500
      end
    end

    it "should use cached value if already cached even before reset" do
      cached_response = OpenStruct.new(body: :cached, header: {'X-Rate-Limit-Remaining'=> '10', 'X-Rate-Limit-Reset' => '400' })
      @cache.put(@query, cached_response)
      expected_reset_time = (Time.now + 10 *60).utc.to_i
      controller = RequestController.new(@cache, 0, expected_reset_time)
      response = controller.handle(@query)
      response.body.should == :cached
      response.header['X-Rate-Limit-Remaining'].should == 0
      response.header['X-Rate-Limit-Reset'].should == expected_reset_time
    end
  end
end
