require File.join(File.dirname(__FILE__), "/spec_helper.rb")

describe QueryBuilder do
  it "should query single branch path" do
    params = { splat: ['search'] }
    query = QueryBuilder.build_from(params)
    query.should == 'search'
  end
  it "should include query after path" do
    params = { splat: ['search'], 'q' => 'wine' }
    query = QueryBuilder.build_from(params)
    query.should == 'search?q=wine'
  end
end
