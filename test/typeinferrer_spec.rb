require "spec"
require "src/typeinferrer"
require "src/twittertype"

describe TypeInferrer do
  before(:each) do
    @mock_profile = mock()
  end

  it "should infer a type of retweeter from a profile with predominantly retweets" do
    @mock_profile.stub!(:retweet_count).and_return(1)
    @mock_profile.stub!(:link_count).and_return(0)
    @mock_profile.stub!(:reply_count).and_return(0)
    @mock_profile.stub!(:tweet_count).and_return(1)
    TypeInferrer.new.infer(@mock_profile).should == TwitterType::RETWEETER
  end

  it "should infer a type of linker from a profile with predominantly links" do
    @mock_profile.stub!(:link_count).and_return(1)
    @mock_profile.stub!(:retweet_count).and_return(0)
    @mock_profile.stub!(:reply_count).and_return(0)
    @mock_profile.stub!(:tweet_count).and_return(1)
    TypeInferrer.new.infer(@mock_profile).should == TwitterType::LINKER
  end

  it "should infer a type of chatter from a profile with predominantly replies" do
    @mock_profile.stub!(:link_count).and_return(0)
    @mock_profile.stub!(:retweet_count).and_return(0)
    @mock_profile.stub!(:reply_count).and_return(1)
    @mock_profile.stub!(:tweet_count).and_return(1)
    TypeInferrer.new.infer(@mock_profile).should == TwitterType::CHATTER
  end

  it "should infer a type of originator from a profile with predominantly original tweets" do
    @mock_profile.stub!(:link_count).and_return(1)
    @mock_profile.stub!(:retweet_count).and_return(1)
    @mock_profile.stub!(:reply_count).and_return(1)
    @mock_profile.stub!(:tweet_count).and_return(10)
    TypeInferrer.new.infer(@mock_profile).should == TwitterType::ORIGINATOR
  end

end