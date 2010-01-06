require 'twitterclient'
require 'tweeterprofile'
require 'profilepersister'

class TwitterType
  def initialize
    #auth = Twitter::OAuth.new('yo0ta9akCx3LW4g3rKs6Q', 'TKbVV8r3hMkkrUz1rLst29PpeEcd00KSMpXJ0gQ')
    #auth.authorize_from_access('access token', 'access secret')

    @persister = ProfilePersister.new
    classify('andee_marks')
  end
  
  def classify(user)
    tweets = TwitterClient.gather_friend_tweets_for(user)
    
    tweets.each do |friend, tweets| 
      profile = TweeterProfile.new(friend, tweets)
      puts profile.to_s
      #@persister.persist(profile)
    end
  end

end

TwitterType.new