require "spec"
require 'src/profilefactory'
require 'src/tweeterprofile'

describe ProfileFactory do
  before(:each) do
    @empty_profile = TweeterProfile.new("user")
    @factory = ProfileFactory.new(@empty_profile.screen_name)

    @mock_valid_tweet = mock()
    @mock_valid_tweet.stub!(:to_user).and_return("user")
    @mock_valid_tweet.stub!(:text).and_return("RT textm http://www.cool.com")
    @mock_valid_tweet.stub!(:id).and_return(12345678)

  end
  
  it "should fail construction without a user" do
    lambda {ProfileFactory.new}.should raise_error(ArgumentError)
    lambda {ProfileFactory.new(nil)}.should raise_error(ArgumentError)
    lambda {ProfileFactory.new(1)}.should raise_error(ArgumentError)
    
    ProfileFactory.new("user")
  end
  
  it "should fail analysis if it cannot enumerate tweets" do
    lambda {@factory.build()}.should raise_error(ArgumentError)
    lambda {@factory.build(nil)}.should raise_error(ArgumentError)
    lambda {@factory.build("tweets")}.should raise_error(ArgumentError)
    lambda {@factory.build([1, 2, 3])}.should raise_error(ArgumentError)
    
    @factory.build(Array.new())
  end
  
  it "should return the empty profile if no tweets are supplied" do
    @factory.build(Array.new()).should == @empty_profile
  end
  
  it "needs a valid set of fields in the tweet" do
    lambda {@factory.build(Array.new(1, "tweet"))}.should raise_error(ArgumentError)

    @factory.build(Array.new(1, @mock_valid_tweet))
  end
  
  it "needs the tweet text to be a string" do
    tweet_with_non_string_text = mock()
    tweet_with_non_string_text.stub!(:to_user).and_return(nil)
    tweet_with_non_string_text.stub!(:text).and_return(1)
    
    lambda {@factory.build(Array.new(1, tweet_with_non_string_text))}.should raise_error(ArgumentError)
  end
end
