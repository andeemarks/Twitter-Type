require 'twitterclient'
require 'tweeterprofile'
require 'profilepersister'

class TwitterType
  def initialize
    #auth = Twitter::OAuth.new('yo0ta9akCx3LW4g3rKs6Q', 'TKbVV8r3hMkkrUz1rLst29PpeEcd00KSMpXJ0gQ')
    #auth.authorize_from_access('access token', 'access secret')

    @persister = ProfilePersister.new
    @client = TwitterClient.new('andee_marks', 'aciijckx')
    @client.friends.each { |friend| classify(friend) }
  end
  
  def classify(user)
    tweets = @client.gather_tweets_for(user)
    
    return if tweets.count <= 0
    
    profile = TweeterProfile.new(user, tweets)
    puts profile.to_s
    #@persister.persist(profile)
  end

end

TwitterType.new