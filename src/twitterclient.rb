require 'rubygems'
require 'twitter'

class TwitterClient
  def gather_tweets_for(screen_name)
    last_profile = ProfileRepository.new.get_last_profile(screen_name)
    puts "Searching for tweets for " + screen_name + " since id of " + last_profile.last_tweet_id.to_s + "\n"
    Twitter::Search.new.from(screen_name).since(last_profile.last_tweet_id)
  end

end