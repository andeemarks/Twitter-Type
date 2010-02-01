require 'spec'
require 'twittertypeinferrer'
require 'twitterclient'

include TwitterType

describe TypeInferrer do

  it "should pass a basic smoke test" do
    TypeInferrer.new("andee_marks")
  end

  it "should fail gracefully if the Twitter API usage limit is exceeded" do
    cut = TypeInferrer.new("andee_marks")
    mock_client = mock()
    #mock_client.should_receive(:gather_tweets_for).with("andee_marks").and_raise(TwitterError)
    cut.client = mock_client
    #cut.classify
    end

  it "should infer a type for a Twitter User" do
    cut = TypeInferrer.new("andee_marks")

    mock_client = mock()
    tweets = Array.new(1) {|i| Tweet.new("test", "to user")}
    mock_client.should_receive(:gather_tweets_for).with("andee_marks").and_return(tweets)

    cut.client = mock_client

    cut.inferred_type.should == Types::UNDETERMINED
    cut.classify
    cut.inferred_type.should_not == Types::UNDETERMINED
  end
end