require 'rubygems'
require 'twitter'

class TwitterClient
  def initialize(username, password)
    auth = Twitter::HTTPAuth.new('andee_marks', 'aciijckx')
    
    @client = Twitter::Base.new(auth)
  end
  
  def friends
    @client.friends
  end
  
  def gather_tweets_for(user)
    Twitter::Search.new.from(user.screen_name)
  end

end