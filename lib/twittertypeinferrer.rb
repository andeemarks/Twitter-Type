require "twitterclient"
require "profilefactory"
require "profiletotypeconverter"

module TwitterType

class TypeInferrer
  attr_writer :client
  attr_reader :inferred_type
  
  RETWEETER = 1
  LINKER = 2
  CHATTER = 3
  ORIGINATOR = 4
  UNDETERMINED = 5
  
  def initialize(user)
    @user = user
    @client = TwitterType::TwitterClient.new
    @inferred_type = UNDETERMINED
  end

  def classify
    begin
      tweets = @client.gather_tweets_for(@user)
      profile = ProfileFactory.new(@user).build(tweets)
      @inferred_type = TwitterType::ProfileToTypeConverter.new.convert(profile)
      p @inferred_type
    rescue TwitterType::TwitterError => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    end
    #puts profile.to_s
  end

end

end

TwitterType::TypeInferrer.new("andee_marks").classify