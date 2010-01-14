require 'tweetanalyser'

describe TweetAnalyser do
  before(:each) do
    @empty_profile = TweeterProfile.new(nil)
    @basic_analyser = TweetAnalyser.new(@empty_profile)
  end
  
  it "will fail construction without a profile" do
    lambda {TweetAnalyser.new}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new(nil)}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new(1)}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new("abc")}.should raise_error(ArgumentError)
    
    TweetAnalyser.new(TweeterProfile.new(nil))
  end
  
  it "will fail analysis without an array of tweets" do
    lambda {@basic_analyser.analyse()}.should raise_error(ArgumentError)
    lambda {@basic_analyser.analyse(nil)}.should raise_error(ArgumentError)
    lambda {@basic_analyser.analyse("tweets")}.should raise_error(ArgumentError)
    lambda {@basic_analyser.analyse([1, 2, 3])}.should raise_error(ArgumentError)
    
    @basic_analyser.analyse(Array.new())
  end
  
  it "will return the original profile if no tweets are supplied" do
    @basic_analyser.analyse(Array.new()).should eql(@empty_profile)
  end
  
  it "will need a validly set of fields in the tweet" do
    lambda {@basic_analyser.analyse(Array.new(1, "tweet"))}.should raise_error(ArgumentError)

    tweet_with_valid_fields = mock()
    tweet_with_valid_fields.stub!(:to_user).and_return("user")
    tweet_with_valid_fields.stub!(:text).and_return("text")
    tweet_with_valid_fields.stub!(:id).and_return(12345678)
    
    @basic_analyser.analyse(Array.new(1, tweet_with_valid_fields))
  end
  
  it "will need the tweet text to be a string" do
    tweet_with_non_string_text = mock()
    tweet_with_non_string_text.stub!(:to_user).and_return("user")
    tweet_with_non_string_text.stub!(:text).and_return(1)
    
    lambda {@basic_analyser.analyse(Array.new(1, tweet_with_non_string_text))}.should raise_error(ArgumentError)
  end
end
