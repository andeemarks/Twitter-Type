require "spec"
require "profiletotypeconverter"

describe TwitterType::ProfileToTypeConverter do
  before(:all) do
    @mock_profile = mock()
    @cut = ProfileToTypeConverter.new
  end

  it "should fail to infer a profile which has less tweets than possible given other attributes" do
    setup_profile({:retweet_count => 1, :link_count => 0, :reply_count => 0, :tweet_count => 0})
    lambda{@cut.convert(@mock_profile)}.should raise_error(ArgumentError)

    setup_profile({:retweet_count => 0, :link_count => 1, :reply_count => 0, :tweet_count => 0})
    lambda{@cut.convert(@mock_profile)}.should raise_error(ArgumentError)

    setup_profile({:retweet_count => 0, :link_count => 0, :reply_count => 1, :tweet_count => 0})
    lambda{@cut.convert(@mock_profile)}.should raise_error(ArgumentError)
  end                                                                      
  
  it "should infer a type of retweeter from a profile with predominantly retweets" do
    setup_profile({:retweet_count => 1, :link_count => 0, :reply_count => 0, :tweet_count => 1})
    @cut.convert(@mock_profile).should == Types::RETWEETER
  end

  it "should infer a type of linker from a profile with predominantly links" do
    setup_profile({:retweet_count => 0, :link_count => 1, :reply_count => 0, :tweet_count => 1})
    @cut.convert(@mock_profile).should == Types::LINKER
  end

  it "should infer a type of chatter from a profile with predominantly replies" do
    setup_profile({:retweet_count => 0, :link_count => 0, :reply_count => 1, :tweet_count => 1})
    @cut.convert(@mock_profile).should == Types::CHATTER
  end

  it "should infer a type of originator from a profile with predominantly original tweets" do
    setup_profile({:retweet_count => 1, :link_count => 1, :reply_count => 1, :tweet_count => 10})
    @cut.convert(@mock_profile).should == Types::ORIGINATOR
  end

  it "should infer no clear type from a profile with no clear trends" do
    setup_profile({:retweet_count => 1, :link_count => 1, :reply_count => 1, :tweet_count => 3})
    @cut.convert(@mock_profile).should == Types::UNDETERMINED
  end

  it "should infer no clear type from an empty profile" do
    setup_profile({:retweet_count => 0, :link_count => 0, :reply_count => 0, :tweet_count => 0})
    @cut.convert(@mock_profile).should == Types::UNDETERMINED
  end

  def setup_profile(return_values)
    @mock_profile.stub!(:retweet_count).and_return(return_values[:retweet_count])
    @mock_profile.stub!(:link_count).and_return(return_values[:link_count])
    @mock_profile.stub!(:reply_count).and_return(return_values[:reply_count])
    @mock_profile.stub!(:tweet_count).and_return(return_values[:tweet_count])
  end
end