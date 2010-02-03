require 'spec'
require 'twittertypeinferrer'
require 'twitterclient'

include TwitterType

describe TypeInferrer do

  before(:each) do
    @cut = TypeInferrer.new("andee_marks")
    @mock_client = mock()
  end

  it "should fail clearly if the Twitter API usage limit is exceeded" do
    @mock_client.stub!(:gather_tweets_for).with("andee_marks").and_raise(TwitterClientError.new(nil)) 
    @cut.client = @mock_client

    @cut.profile.should == nil
    lambda {@cut.classify}.should raise_error(TwitterClientError)
    @cut.profile.should == nil
  end

  it "should infer a type for a Twitter User" do
    tweets = Array.new(1) {|i| Tweet.new("test", "to user")}
    @mock_client.stub!(:gather_tweets_for).with("andee_marks").and_return(tweets)

    @cut.client = @mock_client

    @cut.profile.should == nil
    @cut.classify
    @cut.profile.inferred_type.should_not == :undetermined
  end
end