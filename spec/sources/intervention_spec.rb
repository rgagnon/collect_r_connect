require File.join(File.dirname(__FILE__),'..','spec_helper')

describe "Intervention" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Intervention,'testuser'
    end

    it "should process Intervention query" do
      pending
    end

    it "should process Intervention create" do
      pending
    end

    it "should process Intervention update" do
      pending
    end

    it "should process Intervention delete" do
      pending
    end
  end  
end