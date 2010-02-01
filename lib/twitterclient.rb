require 'rubygems'
require 'twitter'

module TwitterType

  class TwitterClient
    def gather_tweets_for(screen_name)
      Twitter::Search.new.from(screen_name)
    end
  end

  class TwitterError < RuntimeError
    attr :message
  
    def initialize(message)
      @message = message
    end
  end
end