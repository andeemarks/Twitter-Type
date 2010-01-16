require 'rubygems'
require 'twitter'

class TwitterClient
  def self.gather_friend_tweets_for(user, password)
    begin
      client = Twitter::HTTPAuth.new(user, password)
      base = Twitter::Base.new(client)
      friends = base.friends

      friend_tweets = Hash.new
      #friends.each { |friend| 
      friend = friends.first 
      last_profile = ProfileRepository.new.get_last_profile(friend.screen_name)
      puts "Searching for tweets for " + friend.screen_name + " since id of " + last_profile.last_tweet_id.to_s + "\n"
        friend_tweets[friend] = Twitter::Search.new.from(friend.screen_name).since(last_profile.last_tweet_id)

      return friend_tweets

    rescue Crack::ParseError => error
      puts "Error: Cannot parse Twitter response: " + error + "\n"
    end
  end

end