require 'rubygems'
require 'twitter'

module TwitterClient

  class Client
    def gather_tweets_for(screen_name)
      Twitter::Search.new.from(screen_name)
    end
  end

  class Error < RuntimeError
    attr :message
  
    def initialize(message)
      @message = message
    end
  end
end