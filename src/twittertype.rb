require File.dirname(__FILE__) + "/twitterclient"
require File.dirname(__FILE__) + "/tweeterprofile"
require File.dirname(__FILE__) + "/profilefactory"
require File.dirname(__FILE__) + "/typeinferrer"
require "twitter"

class TwitterType
  RETWEETER = 1
  LINKER = 2
  CHATTER = 3
  ORIGINATOR = 4

  def initialize
    begin
      classify('andee_marks')
    rescue Twitter::TwitterError => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    end
  end
  
  def classify(user)
    tweets = TwitterClient.new.gather_tweets_for(user)
    profile = ProfileFactory.new(user).build(tweets)
    profile = TypeInferrer.new().infer(profile)
    puts profile.to_s

  end

end

TwitterType.new