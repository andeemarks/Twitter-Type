require 'rubygems'
require 'twitter'

class TwitterClient
  def gather_tweets_for(screen_name)
    Twitter::Search.new.from(screen_name)
  end

end