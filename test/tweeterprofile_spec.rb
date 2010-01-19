require 'src/tweeterprofile'

describe TweeterProfile do
  
  it "should provide a valid string representation for a newly created profile" do
    TweeterProfile.new("andy").to_s.should eql("andy: #tweets 0, #replies 0, #retweets 0, #links 0, #last_id -1\n")

  end

  it "should provide a valid string representation for an updated profile" do
    profile = TweeterProfile.new("andy")
    profile.tweet_count = 1
    profile.reply_count = 2
    profile.retweet_count = 3
    profile.link_count = 4
    profile.last_tweet_id = 5

    profile.to_s.should eql("andy: #tweets 1, #replies 2, #retweets 3, #links 4, #last_id 5\n")

  end
end
