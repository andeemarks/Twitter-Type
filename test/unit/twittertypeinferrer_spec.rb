require 'spec'
require 'twittertypeinferrer'
require 'twitterclient'

include TwitterType

describe TypeInferrer do

  VALID_TWITTER_USER = "andee_marks"

  Tweet = Struct.new(:text, :to_user)

  before(:each) do
    @cut = TypeInferrer.new
    @mock_client = mock()
  end

  it "should fail gracefully if the Twitter client fails in some way" do
    @mock_client.stub!(:gather_recent_tweets_for).with(VALID_TWITTER_USER).and_raise(TwitterClientError.new(nil))
    @cut.client = @mock_client

    @cut.profile.should == nil
    lambda {@cut.infer(VALID_TWITTER_USER)}.should raise_error(TwitterClientError)
    @cut.profile.should == nil
  end

  it "should use an unknown_unauthorised type for any protected screen name" do
    @mock_client.stub!(:gather_recent_tweets_for).with(VALID_TWITTER_USER).and_raise(ProtectedUserAccessError.new(nil))
    @cut.client = @mock_client

    @cut.profile.should == nil
    @cut.infer(VALID_TWITTER_USER)
    @cut.profile.inferred_type.should == :unknown_protected_user

  end

  it "should use an unknown_user type for any invalid screen name" do
    @mock_client.stub!(:gather_recent_tweets_for).with(VALID_TWITTER_USER).and_raise(InvalidUserAccessError.new(nil))
    @cut.client = @mock_client

    @cut.profile.should == nil
    @cut.infer(VALID_TWITTER_USER)
    @cut.profile.inferred_type.should == :unknown_user

  end

  it "should infer a type for a Twitter User" do
    tweets = Array.new(1) {|i| Tweet.new("test", "to user")}
    @mock_client.stub!(:gather_recent_tweets_for).with(VALID_TWITTER_USER).and_return(tweets)

    @cut.client = @mock_client

    @cut.profile.should == nil
    @cut.infer(VALID_TWITTER_USER)
    @cut.profile.inferred_type.should_not == :undetermined
  end
end