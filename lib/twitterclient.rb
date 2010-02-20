require 'rubygems'
require 'twitter'

module TwitterType

  class TwitterClient
    def gather_recent_tweets_for (screen_name)
      raise ArgumentError if screen_name.nil? or screen_name.strip.size == 0
      
      begin
        Twitter::Client.new.timeline_for(:user, :id => screen_name)
      rescue Twitter::RESTError => error
        raise ProtectedUserAccessError.new(error.to_s) if !(error.code.index(ProtectedUserAccessError::CODE).nil?)
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
  end
end