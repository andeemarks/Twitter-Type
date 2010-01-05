class TweeterProfile
  def initialize(tweeter, tweets)
    @tweet_count = 0
    @reply_count = 0
    @retweet_count = 0
    @link_count = 0
    @tweeter = tweeter
    
    return if tweets.count <= 0
    
    tweets.each do |tweet|
      analyse_tweet(tweet)
    end
    
  end
  
  def analyse_tweet(tweet) 
    @tweet_count = @tweet_count + 1
    @reply_count = @reply_count + 1 if tweet.to_user != nil 
    @retweet_count = @retweet_count + 1 if tweet.text.start_with?('RT')
    @link_count = @link_count + 1 if tweet.text.index('http://') != nil
  end
  
  def to_s
    s = @tweeter.name + ": "
    s = s + "#tweets " + @tweet_count.to_s + ", "
    s = s + "#replies " + @reply_count.to_s + ", "
    s = s + "#retweets " + @retweet_count.to_s + ", "
    s = s + "#links " + @link_count.to_s
    s = s + "\n"
  end
end