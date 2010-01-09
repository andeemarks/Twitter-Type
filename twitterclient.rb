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
        friend_tweets[friend] = Twitter::Search.new.from(friend.screen_name) 

      return friend_tweets

    rescue Twitter::TwitterError => error
      puts "Error: Rate limit exceeded: " + error + "\n"
    rescue Crack::ParseError => error
      puts "Error: Cannot parse Twitter response: " + error + "\n"
    end
  end

end