require "twitterclient"
require "profilefactory"
require "typeinferrer"

class TwitterType
  attr_writer :client
  attr_reader :inferred_type
  
  RETWEETER = 1
  LINKER = 2
  CHATTER = 3
  ORIGINATOR = 4
  UNDETERMINED = 5
  
  def initialize(user)
    @user = user
    @client = TwitterClient::Client.new
    @inferred_type = nil
  end

  def classify
    begin
      tweets = @client.gather_tweets_for(@user)
      profile = ProfileFactory.new(@user).build(tweets)
      @inferred_type = TypeInferrer.new.infer(profile)
    rescue TwitterClient::Error => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    end
    #puts profile.to_s
  end

end

#TwitterType.new("andee_marks")