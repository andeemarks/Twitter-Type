require 'spec'
require 'twittertype'
require 'twitterclient'

describe TwitterType do

  it "should pass a basic smoke test" do
    TwitterType.new("andee_marks")
  end

#  it "should fail gracefully if the Twitter API usage limit is exceeded" do
#    cut = TwitterType.new("andee_marks")
#    mock_client = mock()
#    mock_client.should_receive(:gather_tweets_for).with("andee_marks").and_raise(TwitterClient::Error)
#    cut.client = mock_client
#    cut.classify
#  end

  it "should infer a type for a Twitter User" do
    cut = TwitterType.new("andee_marks")

    mock_client = mock()
    tweets = Array.new(1) {|i| Tweet.new("test", "to user")}
    mock_client.should_receive(:gather_tweets_for).with("andee_marks").and_return(tweets)

    cut.client = mock_client

    cut.inferred_type.should == TwitterType::UNDETERMINED
    cut.classify
    cut.inferred_type.should_not == TwitterType::UNDETERMINED
  end
end