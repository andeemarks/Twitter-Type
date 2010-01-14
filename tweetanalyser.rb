require 'TweeterProfile'
require 'Hashie'

class TweetAnalyser
  
  def initialize(profile)
    raise ArgumentError if profile.class != TweeterProfile
    
    @profile = profile
  end
  
  def analyse(tweets)
    raise ArgumentError.new("No tweets to analyse") if tweets.nil?
    raise ArgumentError.new("Tweets are not in array") if tweets.class != Array
#    raise ArgumentError.new("Array does not contain tweets") if tweets.count > 0 and "Hashie::Mash".eql(tweets.first.inspect)

    tweets.each do |tweet|
      analyse_tweet(tweet)
    end
    
    return @profile
  end
  
  def analyse_tweet(tweet) 
    begin
      @profile.tweet_count = @profile.tweet_count + 1
      @profile.reply_count = @profile.reply_count + 1 if tweet.to_user != nil 
      @profile.retweet_count = @profile.retweet_count + 1 if tweet.text.start_with?('RT')
      @profile.link_count = @profile.link_count + 1 if tweet.text.index('http://') != nil
      @profile.last_tweet_id = tweet.id if tweet.id > @profile.last_tweet_id
    rescue NoMethodError => root
      raise ArgumentError.new("Missing method responses in tweet structure:" + root.to_s)
    end
  end
  
end