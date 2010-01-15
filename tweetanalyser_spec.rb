require 'tweetanalyser'

describe TweetAnalyser do
  before(:each) do
    @empty_profile = TweeterProfile.new(nil)
    @basic_analyser = TweetAnalyser.new(@empty_profile)

    @tweet_with_valid_fields = mock()
    @tweet_with_valid_fields.stub!(:to_user).and_return("user")
    @tweet_with_valid_fields.stub!(:text).and_return("RT textm http://www.cool.com")
    @tweet_with_valid_fields.stub!(:id).and_return(12345678)

  end
  
  it "should fail construction without a profile" do
    lambda {TweetAnalyser.new}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new(nil)}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new(1)}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new("abc")}.should raise_error(ArgumentError)
    
    TweetAnalyser.new(TweeterProfile.new(nil))
  end
  
  it "should fail analysis without an array of tweets" do
    lambda {@basic_analyser.analyse()}.should raise_error(ArgumentError)
    lambda {@basic_analyser.analyse(nil)}.should raise_error(ArgumentError)
    lambda {@basic_analyser.analyse("tweets")}.should raise_error(ArgumentError)
    lambda {@basic_analyser.analyse([1, 2, 3])}.should raise_error(ArgumentError)
    
    @basic_analyser.analyse(Array.new())
  end
  
  it "should return the original profile if no tweets are supplied" do
    @basic_analyser.analyse(Array.new()).should eql(@empty_profile)
  end
  
  it "needs a valid set of fields in the tweet" do
    lambda {@basic_analyser.analyse(Array.new(1, "tweet"))}.should raise_error(ArgumentError)

    @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
  end
  
  it "needs the tweet text to be a string" do
    tweet_with_non_string_text = mock()
    tweet_with_non_string_text.stub!(:to_user).and_return("user")
    tweet_with_non_string_text.stub!(:text).and_return(1)
    
    lambda {@basic_analyser.analyse(Array.new(1, tweet_with_non_string_text))}.should raise_error(ArgumentError)
  end
  
  it "should increase the profile tweet count for each tweet found" do    
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.tweet_count.should == 1

    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.tweet_count.should == 2

    profile = @basic_analyser.analyse(Array.new(2, @tweet_with_valid_fields))
    profile.tweet_count.should == 4
    
    profile = @basic_analyser.analyse(Array.new())
    profile.tweet_count.should == 4
  end
  
  it "should increase the profile reply count for each tweet sent to a user" do
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.reply_count.should == 1

    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.reply_count.should == 2

    profile = @basic_analyser.analyse(Array.new(2, @tweet_with_valid_fields))
    profile.reply_count.should == 4
    
    profile = @basic_analyser.analyse(Array.new())
    profile.reply_count.should == 4 

    @tweet_with_valid_fields.stub!(:to_user).and_return(nil)
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.reply_count.should == 4
    
    
  end
  
  it "should increase the profile retweet count for each tweet forwarded from a user" do
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.retweet_count.should == 1

    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.retweet_count.should == 2

    profile = @basic_analyser.analyse(Array.new(2, @tweet_with_valid_fields))
    profile.retweet_count.should == 4
    
    profile = @basic_analyser.analyse(Array.new())
    profile.retweet_count.should == 4 

    @tweet_with_valid_fields.stub!(:text).and_return("text")
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.retweet_count.should == 4
  end
  
  it "should increase the profile link count for each tweet mentioning an URL" do
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.link_count.should == 1

    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.link_count.should == 2

    profile = @basic_analyser.analyse(Array.new(2, @tweet_with_valid_fields))
    profile.link_count.should == 4
    
    profile = @basic_analyser.analyse(Array.new())
    profile.link_count.should == 4 

    @tweet_with_valid_fields.stub!(:text).and_return("text")
    profile = @basic_analyser.analyse(Array.new(1, @tweet_with_valid_fields))
    profile.link_count.should == 4
  end
end
