require "twitterclientwrapper"
require "profilefactory"

module TwitterType

  class TypeInferrer
    attr_writer :client
    attr_reader :profile

    def initialize()
      @client = TwitterClientWrapper.new
    end

    def infer(user)
      begin
        tweets = @client.gather_recent_tweets_for(user)
        @profile = ProfileFactory.new(user).build(tweets)
        @profile.infer_type
      rescue TwitterType::ProtectedUserAccessError => error
        @profile = ProfileFactory.new(user).build([])
        @profile.inferred_type = :unknown_protected_user
      rescue TwitterType::InvalidUserAccessError => error
        @profile = ProfileFactory.new(user).build([])
        @profile.inferred_type = :unknown_user
      end

      self
    end

  end

end
