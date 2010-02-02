require "twitterclient"
require "profilefactory"
require "profiletotypeconverter"

module TwitterType

  class TypeInferrer
    attr_writer :client
    attr_reader :inferred_type

    def initialize(user)
      @user = user
      @client = TwitterClient.new
      @inferred_type = Types::UNDETERMINED
    end

    def classify
      tweets = @client.gather_tweets_for(@user)
      profile = ProfileFactory.new(@user).build(tweets)
      @inferred_type = ProfileToTypeConverter.new.convert(profile)
      #p @inferred_type
    end

  end

end

TypeInferrer.new("andee_marks").classify