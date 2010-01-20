require 'twitterclient'
require 'tweeterprofile'
require 'tweetanalyser'

class TwitterType
  def initialize
    begin
      classify('andee_marks')
    rescue Twitter::TwitterError => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    end
  end
  
  def classify(user)
    tweets = TwitterClient.new.gather_tweets_for(user)
    profile = TweetAnalyser.new(user).analyse(tweets)
    puts profile.to_s

  end

end

TwitterType.new