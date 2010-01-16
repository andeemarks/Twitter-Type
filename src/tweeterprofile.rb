class TweeterProfile
  attr_accessor :screen_name, 
    :tweet_count, 
    :reply_count, 
    :retweet_count, 
    :link_count, 
    :last_tweet_id
  
  def initialize(screen_name)
    @tweet_count = 0
    @reply_count = 0
    @retweet_count = 0
    @link_count = 0
    @last_tweet_id = -1
    @screen_name = screen_name    
  end

  def to_s
    s = @screen_name + ": "
    s = s + "#tweets " + @tweet_count.to_s + ", "
    s = s + "#replies " + @reply_count.to_s + ", "
    s = s + "#retweets " + @retweet_count.to_s + ", "
    s = s + "#links " + @link_count.to_s + ", "
    s = s + "#last_id " + @last_tweet_id.to_s
    s = s + "\n"
  end
end