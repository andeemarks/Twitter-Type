require 'rubygems'
require 'twitter'

class TwitterClient
  def self.gather_friend_tweets_for(user)
    begin
      friend_ids = Twitter.friend_ids(user)
      puts friend_ids.to_s + "\n"

      friend_tweets = Hash.new
      friend_ids.each { |friend_id| 
        puts "Finding user for " + friend_id.to_s + "\n"
        friend = Twitter::user(friend_id)
        friend_tweets[friend] = Twitter::Search.new.from(friend.screen_name) 
      }

      return friend_tweets

    rescue Twitter::TwitterError => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    rescue Crack::ParseError => error
      puts "Error: Cannot parse Twitter response: " + error + "\n"
    end
  end

end