require 'rubygems'
require 'twitter'

module TwitterType

  class TwitterClient
    def gather_recent_tweets_for (screen_name)
      raise ArgumentError if screen_name.nil? or screen_name.strip.size == 0
      
      Twitter::Client.new.timeline_for(:user, :id => screen_name)
    end
  end
end