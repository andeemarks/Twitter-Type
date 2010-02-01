require "twitterclient"
require "profilefactory"
require "typeinferrer"

class TwitterType
  RETWEETER = 1
  LINKER = 2
  CHATTER = 3
  ORIGINATOR = 4
  UNDETERMINED = 5
  
  def initialize(user)
    begin
      classify(user)
    rescue Twitter::TwitterError => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    end
  end
  
  def classify(user)
    tweets = TwitterClient.new.gather_tweets_for(user)
    profile = ProfileFactory.new(user).build(tweets)
    profile = TypeInferrer.new.infer(profile)
    #puts profile.to_s

  end

end

TwitterType.new("andee_marks")