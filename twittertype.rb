require 'twitterclient'
require 'tweeterprofile'
require 'profilepersister'

class TwitterType
  def initialize
    #auth = Twitter::OAuth.new('yo0ta9akCx3LW4g3rKs6Q', 'TKbVV8r3hMkkrUz1rLst29PpeEcd00KSMpXJ0gQ')
    #auth.authorize_from_access('access token', 'access secret')

    classify('andee_marks', 'aciijckx')
  end
  
  def classify(user, password)
    tweets = TwitterClient.gather_friend_tweets_for(user, password)
    
    tweets.each do |friend, tweets| 
      profile = TweeterProfile.new(friend, tweets)
      puts profile.to_s
      ProfilePersister.new.persist(profile)
    end
  end

end

TwitterType.new