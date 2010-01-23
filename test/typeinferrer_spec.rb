require "spec"
require "src/typeinferrer"
require "src/twittertype"

describe TypeInferrer do
  before(:all) do
    @mock_profile = mock()
    @cut = TypeInferrer.new
  end

  it "should infer a type of retweeter from a profile with predominantly retweets" do
    setup_profile({:retweet_count => 1, :link_count => 0, :reply_count => 0, :tweet_count => 1})
    @cut.infer(@mock_profile).should == TwitterType::RETWEETER
  end

  it "should infer a type of linker from a profile with predominantly links" do
    setup_profile({:retweet_count => 0, :link_count => 1, :reply_count => 0, :tweet_count => 1})
    @cut.infer(@mock_profile).should == TwitterType::LINKER
  end

  it "should infer a type of chatter from a profile with predominantly replies" do
    setup_profile({:retweet_count => 0, :link_count => 0, :reply_count => 1, :tweet_count => 1})
    @cut.infer(@mock_profile).should == TwitterType::CHATTER
  end

  it "should infer a type of originator from a profile with predominantly original tweets" do
    setup_profile({:retweet_count => 1, :link_count => 1, :reply_count => 1, :tweet_count => 10})
    @cut.infer(@mock_profile).should == TwitterType::ORIGINATOR
  end


  it "should infer no clear type from a profile with no clear trends" do
    setup_profile({:retweet_count => 1, :link_count => 1, :reply_count => 1, :tweet_count => 3})
    @cut.infer(@mock_profile).should == TwitterType::UNDETERMINED
  end


  def setup_profile(return_values)
    @mock_profile.stub!(:retweet_count).and_return(return_values[:retweet_count])
    @mock_profile.stub!(:link_count).and_return(return_values[:link_count])
    @mock_profile.stub!(:reply_count).and_return(return_values[:reply_count])
    @mock_profile.stub!(:tweet_count).and_return(return_values[:tweet_count])
  end
end