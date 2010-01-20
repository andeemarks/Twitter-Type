require File.dirname(__FILE__) + "/tweeterprofile"

class TweetAnalyser
  
  def initialize(profile)
    raise ArgumentError if profile.class != TweeterProfile
    
    @profile = profile
  end
  
  def analyse(tweets)
    raise ArgumentError.new("No tweets to analyse") if tweets.nil?
    raise ArgumentError.new("Tweets are not enumerable") if !tweets.is_a?(Enumerable)

    tweets.each do |tweet|
      update_profile(tweet)
    end
    
    return @profile
  end
  
  def update_profile(tweet) 
      @profile.update_from(tweet)
  end
  
end
