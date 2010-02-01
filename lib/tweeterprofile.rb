class TweeterProfile
  attr_accessor :screen_name, 
    :tweet_count, 
    :reply_count, 
    :retweet_count, 
    :link_count

  def initialize(screen_name)
    @tweet_count = 0
    @reply_count = 0
    @retweet_count = 0
    @link_count = 0
    @screen_name = screen_name
  end

  def update_from(tweet)
    begin
      p tweet
      
      @tweet_count = @tweet_count + 1

      if tweet.to_user != nil
        @reply_count = @reply_count + 1
        return
      end

      @retweet_count = @retweet_count + 1 if tweet.text.start_with?('RT')
      @link_count = @link_count + 1 if tweet.text.index('http://') != nil
    rescue NoMethodError => root
      raise ArgumentError.new("Missing method responses in tweet structure:" + root.to_s)
    end
  end

  def to_s
    s = @screen_name + ": "
    s = s + "#tweets " + @tweet_count.to_s + ", "
    s = s + "#replies " + @reply_count.to_s + ", "
    s = s + "#retweets " + @retweet_count.to_s + ", "
    s = s + "#links " + @link_count.to_s
    s = s + "\n"
  end

  def ==(other)
    result = @screen_name == other.screen_name
    result = result && @tweet_count == other.tweet_count
    result = result && @reply_count == other.reply_count
    result = result && @retweet_count == other.retweet_count
    result = result && @link_count == other.link_count

    return result
  end
end