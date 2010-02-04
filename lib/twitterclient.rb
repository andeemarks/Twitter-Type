require 'rubygems'
require 'twitter'

module TwitterType

  class TwitterClient
    def gather_tweets_for(screen_name)
      raise ArgumentError if screen_name.nil? or screen_name.strip.size == 0
      
      begin
        Twitter::Search.new.from(screen_name)
      rescue Twitter::TwitterError => error
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
end