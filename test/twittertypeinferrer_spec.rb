require 'spec'
require 'twittertypeinferrer'
require 'twitterclient'

include TwitterType

describe TypeInferrer do

  before(:each) do
    @cut = TypeInferrer.new("andee_marks")
    @mock_client = mock()
  end

  it "should pass a basic smoke test" do
    #TypeInferrer.new("andee_marks").classify
  end

  it "should fail clearly if the Twitter API usage limit is exceeded" do
    @mock_client.stub!(:gather_tweets_for).with("andee_marks").and_raise(TwitterClientError.new(nil)) 
    @cut.client = @mock_client

    @cut.inferred_type.should == Types::UNDETERMINED
    lambda {@cut.classify}.should raise_error(TwitterClientError)
    @cut.inferred_type.should == Types::UNDETERMINED
  end

  it "should infer a type for a Twitter User" do
    tweets = Array.new(1) {|i| Tweet.new("test", "to user")}
    @mock_client.stub!(:gather_tweets_for).with("andee_marks").and_return(tweets)

    @cut.client = @mock_client

    @cut.inferred_type.should == Types::UNDETERMINED
    @cut.classify
    @cut.inferred_type.should_not == Types::UNDETERMINED
  end
end