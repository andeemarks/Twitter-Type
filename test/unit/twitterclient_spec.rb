require "spec"
require "twitterclient"

describe TwitterType::TwitterClient do

  it "should fail with an empty or nil user name" do
    lambda{TwitterClient.new.gather_recent_tweets_for(nil)}.should raise_error(ArgumentError)
    lambda{TwitterClient.new.gather_recent_tweets_for("")}.should raise_error(ArgumentError)
    lambda{TwitterClient.new.gather_recent_tweets_for("   ")}.should raise_error(ArgumentError)
    lambda{TwitterClient.new.gather_recent_tweets_for(' ')}.should raise_error(ArgumentError)
  end
end