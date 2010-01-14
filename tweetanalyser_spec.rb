require 'tweetanalyser'

describe TweetAnalyser do
  it "requires a profile on construction" do
    lambda {TweetAnalyser.new}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new(nil)}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new(1)}.should raise_error(ArgumentError)
    lambda {TweetAnalyser.new("abc")}.should raise_error(ArgumentError)
    
    TweetAnalyser.new(TweeterProfile.new(nil))
  end
  
  it "requires an array of tweets to analyse" do
    analyser = TweetAnalyser.new(TweeterProfile.new(nil))
    lambda {analyser.analyse()}.should raise_error(ArgumentError)
    lambda {analyser.analyse(nil)}.should raise_error(ArgumentError)
    lambda {analyser.analyse("tweets")}.should raise_error(ArgumentError)
    lambda {analyser.analyse([1, 2, 3])}.should raise_error(ArgumentError)
    
    analyser.analyse(Array.new(1, Hashie::Mash))
  end
  
  it "will return the original profile if no tweets are supplied" do
    original_profile = TweeterProfile.new(nil)
    analyser = TweetAnalyser.new(original_profile)
    analyser.analyse(Array.new()).should eql(original_profile)
  end
end

