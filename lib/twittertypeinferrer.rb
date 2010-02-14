require "twitterclient"
require "profilefactory"

module TwitterType

  class TypeInferrer
    attr_writer :client
    attr_reader :profile

    def initialize()
      @client = TwitterClient.new
    end

    def infer(user)
      tweets = @client.gather_recent_tweets_for(user)
      @profile = ProfileFactory.new(user).build(tweets)
      @profile.infer_type

      self
    end

  end

end