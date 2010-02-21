require "spec"
require "twitterclientwrapper"

describe TwitterType::TwitterClientWrapper do

  it "should subclass TwitterClient" do
    TwitterClientWrapper.superclass.should == TwitterClient
  end

  it "should allow injection of a TwitterClient" do
    TwitterClientWrapper.new(TwitterClient.new)
  end

  it "should default the client to a TwitterClient instance" do
    TwitterClientWrapper.new.client.class.should == TwitterClient
  end

  it "should turn raise a custom exception when an attempt to access a protected user's tweets is made" do
    protected_user_access_error = Twitter::RESTError.new
    protected_user_access_error.code = "401"

    client = mock    
    client.stub!(:gather_recent_tweets_for).with("protected_user").and_raise(protected_user_access_error)

    lambda{TwitterClientWrapper.new(client).gather_recent_tweets_for("protected_user")}.should raise_error(ProtectedUserAccessError)
  end

  it "should turn any other exceptiona raised by client into a generci exception" do
    access_error = Twitter::RESTError.new
    access_error.code = "404"

    client = mock
    client.stub!(:gather_recent_tweets_for).with("dodgy_user").and_raise(access_error)

    lambda{TwitterClientWrapper.new(client).gather_recent_tweets_for("dodgy_user")}.should raise_error(TwitterClientError)
  end
end