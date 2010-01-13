class TweetAnalyser
  
  def initialize(profile)
    @profile = profile
  end
  
  def analyse(tweets)
    tweets.each do |tweet|
      analyse_tweet(tweet)
    end
    
    return @profile
  end
  
  def analyse_tweet(tweet) 
    @profile.tweet_count = @profile.tweet_count + 1
    @profile.reply_count = @profile.reply_count + 1 if tweet.to_user != nil 
    @profile.retweet_count = @profile.retweet_count + 1 if tweet.text.start_with?('RT')
    @profile.link_count = @profile.link_count + 1 if tweet.text.index('http://') != nil
    @profile.last_tweet_id = tweet.id if tweet.id > @profile.last_tweet_id
  end
  
end