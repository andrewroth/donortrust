require File.dirname(__FILE__) + '/../../spec_helper'

describe Dt::HomeController do

  IPS = { :CA => '198.103.238.30', :US => '74.125.113.99' }

  context "should have a country code in the session and helper method" do
    it "of CA when requested from Canadian IP" do
      @request.env['REMOTE_ADDR'] = IPS[:CA]
      get :index
      session[:country_code].should == 'CA'
      @controller.send(:country_code).should == "CA"
    end
    it "of US when requested from U.S. IP" do
      @request.env['REMOTE_ADDR'] = IPS[:US]
      get :index
      session[:country_code].should == 'US'
      @controller.send(:country_code).should == "US"
    end
    it "of CA (default) when requested from local IP" do
      @request.env['REMOTE_ADDR'] = '127.0.0.1'
      get :index
      session[:country_code].should == 'CA'
      @controller.send(:country_code).should == "CA"
    end
  end

end
