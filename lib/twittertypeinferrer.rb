require "twitterclient"
require "profilefactory"

module TwitterType

  class TypeInferrer
    attr_writer :client
    attr_reader :profile

    def initialize(user)
      @user = user
      @client = TwitterClient.new
    end

    def classify
      tweets = @client.gather_tweets_for(@user)
      @profile = ProfileFactory.new(@user).build(tweets)
      @profile.infer_type
      #p @inferred_type
    end

  end

end