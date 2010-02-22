require 'rubygems'
require 'twitterclient'

module TwitterType

  class TwitterClientWrapper < TwitterClient

    attr_reader :client
    
    def initialize(client = TwitterClient.new)
      @client = client
    end
    
    def gather_recent_tweets_for (screen_name)
      begin
        @client.gather_recent_tweets_for(screen_name)
      rescue Twitter::RESTError => error
        raise ProtectedUserAccessError.new(error.to_s) if ProtectedUserAccessError.fits(error)
        raise TwitterClientError.new(error.to_s)
      end
    end
  end

  class TwitterClientError < StandardError
    attr :message

    def initialize(message)
      @message = message
    end
  end

  class ProtectedUserAccessError < TwitterClientError
    CODE = "401"

    def self.fits(error)
      return !error.code.index(CODE).nil?
    end
  end
end