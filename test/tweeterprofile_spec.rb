require 'src/tweeterprofile'

describe TweeterProfile do

  before(:each) do
    @profile = TweeterProfile.new("andy")

    @tweet_with_valid_fields = mock()
    @tweet_with_valid_fields.stub!(:to_user).and_return("user")
    @tweet_with_valid_fields.stub!(:text).and_return("RT textm http://www.cool.com")
    @tweet_with_valid_fields.stub!(:id).and_return(12345678)

    @empty_profile = TweeterProfile.new(nil)
    
  end

  it "should provide a valid string representation for a newly created @profile" do
    TweeterProfile.new("andy").to_s.should eql("andy: #tweets 0, #replies 0, #retweets 0, #links 0\n")

  end

  it "should provide a valid string representation for an updated @profile" do
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
    @profile.update_from(@tweet_with_valid_fields)
    @profile.tweet_count.should == 1

    @profile.update_from(@tweet_with_valid_fields)
    @profile.tweet_count.should == 2

  end

  it "should increase the reply count for each tweet sent to a user" do
    @profile.update_from(@tweet_with_valid_fields)
    @profile.reply_count.should == 1

    @profile.update_from(@tweet_with_valid_fields)
    @profile.reply_count.should == 2

    @tweet_with_valid_fields.stub!(:to_user).and_return(nil)
    @profile.update_from(@tweet_with_valid_fields)
    @profile.reply_count.should == 2


  end

  it "should increase the retweet count for each tweet forwarded from a user" do
    @profile.update_from(@tweet_with_valid_fields)
    @profile.retweet_count.should == 1

    @profile.update_from(@tweet_with_valid_fields)
    @profile.retweet_count.should == 2

    @tweet_with_valid_fields.stub!(:text).and_return("text")
    @profile.update_from(@tweet_with_valid_fields)
    @profile.retweet_count.should == 2
  end

  it "should increase the link count for each tweet mentioning an URL" do
    @profile.update_from(@tweet_with_valid_fields)
    @profile.link_count.should == 1

    @profile.update_from(@tweet_with_valid_fields)
    @profile.link_count.should == 2

    @tweet_with_valid_fields.stub!(:text).and_return("text")
    @profile.update_from(@tweet_with_valid_fields)
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
