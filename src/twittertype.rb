require 'twitterclient'
require 'tweeterprofile'
require 'profilerepository'
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
    profile = TweeterProfile.new(user)
    profile = TweetAnalyser.new(profile).analyse(tweets)
    puts profile.to_s
    ProfileRepository.new.persist(profile)

  end

end

TwitterType.new