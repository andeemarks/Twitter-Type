require 'spec'
require 'twittertypeinferrer'
require 'twitterclient'

include TwitterType

describe TypeInferrer do

  it "should pass a basic smoke test" do
    TypeInferrer.new("andee_marks").classify
  end
end