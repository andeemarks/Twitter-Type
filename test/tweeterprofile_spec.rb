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
    TweeterProfile.new("andy").to_s.should eql("andy: #tweets 0, #replies 0, #retweets 0, #links 0, #last_id -1\n")

  end

  it "should provide a valid string representation for an updated @profile" do
    @profile.tweet_count = 1
    @profile.reply_count = 2
    @profile.retweet_count = 3
    @profile.link_count = 4
    @profile.last_tweet_id = 5

    @profile.to_s.should eql("andy: #tweets 1, #replies 2, #retweets 3, #links 4, #last_id 5\n")

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

  it "should update the last tweet id when it finds a newer one" do
    (@empty_profile.last_tweet_id < @tweet_with_valid_fields.id).should be_true

    @profile.update_from(@tweet_with_valid_fields)
    @profile.last_tweet_id.should == @tweet_with_valid_fields.id
  end

  it "should preserve original last tweet id when cannot find a newer one" do
    @tweet_with_valid_fields.stub!(:id).and_return(-2)

    (@empty_profile.last_tweet_id < @tweet_with_valid_fields.id).should be_false

    @profile.update_from(@tweet_with_valid_fields)
    @profile.last_tweet_id.should == @empty_profile.last_tweet_id
  end
end
