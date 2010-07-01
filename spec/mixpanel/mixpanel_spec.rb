require 'spec_helper'

describe Mixpanel do
  before do
    @mixpanel = Mixpanel.new(MIX_PANEL_TOKEN)
  end

  context "Initializing object" do
    it "should have an instance variable for token and events" do
      @mixpanel.instance_variables.should include("@token", "@events")
    end
  end

  context "Accessing Mixpanel through direct request" do
    before do
      @mixpanel = Mixpanel.new(MIX_PANEL_TOKEN)
    end

    context "Tracking events" do
      it "should track simple events" do
        @mixpanel.track_event("Sign up").should == true
      end

      it "should call request method with token and time value" do
        params = {:event => "Sign up", :properties => {:token => MIX_PANEL_TOKEN, :time => Time.now.utc.to_i}}

        @mixpanel.should_receive(:request).with(params).and_return("1")
        @mixpanel.track_event("Sign up").should == true
      end
    end
  end

  context "Accessing Mixpanel through javascript API" do
    context "Appending events" do
      it "should append simple events" do
        @mixpanel.append_event("Sign up")
        mixpanel_events_should_include(@mixpanel, "Sign up", {})
      end

      it "should append events with properties" do
        @mixpanel.append_event("Sign up", {:referer => 'http://example.com'})
        mixpanel_events_should_include(@mixpanel, "Sign up", {:referer => 'http://example.com'})
      end

      it "should give direct access to events" do
        @mixpanel.append_event("Sign up", {:referer => 'http://example.com'})
        @mixpanel.events.size.should == 1
      end
    end
  end
end