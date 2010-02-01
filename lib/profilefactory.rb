require 'tweeterprofile'

module TwitterType

class ProfileFactory

  def initialize(user)
    raise ArgumentError.new("No user name supplied") if user.nil? or !user.is_a?(String)
    @user = user
  end

  def build(tweets)
    raise ArgumentError.new("No tweets to analyse") if tweets.nil?
    raise ArgumentError.new("Tweets are not enumerable") if !tweets.is_a?(Enumerable)

    profile = TweeterProfile.new(@user)
    tweets.each do |tweet|
      profile.update_from(tweet)
    end

    return profile
  end
end

end