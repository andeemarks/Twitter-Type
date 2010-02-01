require 'spec'
require 'tweeterprofile'

describe TweeterProfile do

  before(:each) do
    @profile = TweeterProfile.new("andy")

    @mock_tweet = mock()
    @mock_tweet.stub!(:to_user).and_return(nil)
    @mock_tweet.stub!(:text).and_return("text")
  end

  it "should provide a valid string representation for a newly created profile" do
    TweeterProfile.new("andy").to_s.should eql("andy: #tweets 0, #replies 0, #retweets 0, #links 0\n")

  end

  it "should provide a valid string representation for an updated profile" do
    @profile.tweet_count = 1
    @profile.reply_count = 2
    @profile.retweet_count = 3
    @profile.link_count = 4

    @profile.to_s.should eql("andy: #tweets 1, #replies 2, #retweets 3, #links 4\n")

  end

  it "should fail when asked to update itself from a nil tweet" do
    lambda {@profile.update_from(nil)}.should raise_error(ArgumentError)
  end

  it "should increase the tweet count for each tweet found" do
    @profile.update_from(@mock_tweet)
    @profile.tweet_count.should == 1

    @profile.update_from(@mock_tweet)
    @profile.tweet_count.should == 2

  end

  it "should increase the reply count for each tweet sent to a user" do
    @mock_tweet.stub!(:to_user).and_return("user")

    @profile.update_from(@mock_tweet)
    @profile.reply_count.should == 1

    @profile.update_from(@mock_tweet)
    @profile.reply_count.should == 2

    @mock_tweet.stub!(:to_user).and_return(nil)
    @profile.update_from(@mock_tweet)
    @profile.reply_count.should == 2
  end

  it "should let a reply take precedence over a retweet" do
    @mock_tweet.stub!(:to_user).and_return("user")

    @profile.update_from(@mock_tweet)
    @profile.reply_count.should == 1
    @profile.retweet_count.should == 0
  end

  it "should increase the retweet count for each tweet forwarded from a user" do
    @mock_tweet.stub!(:text).and_return("RT user")

    @profile.update_from(@mock_tweet)
    @profile.retweet_count.should == 1

    @profile.update_from(@mock_tweet)
    @profile.retweet_count.should == 2

    @mock_tweet.stub!(:text).and_return("text")
    @profile.update_from(@mock_tweet)
    @profile.retweet_count.should == 2
  end

  it "should increase the link count for each tweet mentioning an URL" do
    @mock_tweet.stub!(:text).and_return("text http://www.twitter.com")

    @profile.update_from(@mock_tweet)
    @profile.link_count.should == 1

    @profile.update_from(@mock_tweet)
    @profile.link_count.should == 2

    @mock_tweet.stub!(:text).and_return("text")
    @profile.update_from(@mock_tweet)
    @profile.link_count.should == 2
  end

  it "should be equal to another profile with the same values" do
    first = TweeterProfile.new("user")
    first.link_count = 1
    first.retweet_count = 2
    first.reply_count = 3
    first.tweet_count = 4

    second = TweeterProfile.new(first.screen_name)
    second.link_count = first.link_count
    second.retweet_count = first.retweet_count
    second.reply_count = first.reply_count
    second.tweet_count = first.tweet_count

    first.equal?(second).should == false
    (first == second).should == true
  end
end
