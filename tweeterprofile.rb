class TweeterProfile
  attr_reader :tweeter, :tweet_count, :reply_count, :retweet_count, :link_count, :last_tweet_id
  
  def initialize(screen_name)
    @tweet_count = 0
    @reply_count = 0
    @retweet_count = 0
    @link_count = 0
    @last_tweet_id = -1
    @screen_name = screen_name    
  end
  
  def analyse(tweets)
    tweets.each do |tweet|
      analyse_tweet(tweet)
    end
  end
  
  def analyse_tweet(tweet) 
    @tweet_count = @tweet_count + 1
    @reply_count = @reply_count + 1 if tweet.to_user != nil 
    @retweet_count = @retweet_count + 1 if tweet.text.start_with?('RT')
    @link_count = @link_count + 1 if tweet.text.index('http://') != nil
    @last_tweet_id = tweet.id if tweet.id > @last_tweet_id
  end
  
  def to_s
    s = @tweeter.screen_name + ": "
    s = s + "#tweets " + @tweet_count.to_s + ", "
    s = s + "#replies " + @reply_count.to_s + ", "
    s = s + "#retweets " + @retweet_count.to_s + ", "
    s = s + "#links " + @link_count.to_s + ", "
    s = s + "#last_id " + @last_tweet_id.to_s
    s = s + "\n"
  end
end