module TwitterType

  class TweeterProfile
    attr_accessor :screen_name,
                  :tweet_count,
                  :reply_count,
                  :retweet_count,
                  :link_count,
                  :inferred_type

    def initialize(screen_name)
      @tweet_count = 0
      @reply_count = 0
      @retweet_count = 0
      @link_count = 0
      @screen_name = screen_name
    end

    def update_from(tweet)
      begin
        @tweet_count = @tweet_count + 1

        if tweet.to_user != nil
          @reply_count = @reply_count + 1
          return
        end

        @retweet_count = @retweet_count + 1 if tweet.text.slice(0, 2) == 'RT'
        @link_count = @link_count + 1 if tweet.text.index('http://') != nil
      rescue NoMethodError => root
        raise ArgumentError.new("Missing method responses in tweet structure:" + root.to_s)
      end
    end

    def equal_highest?(highest_count, first, second)
      highest_count == first and highest_count == second
    end

    def infer_type

      attributes = [@retweet_count, @link_count, @reply_count]
      highest_count = attributes.max

      raise ArgumentError if @tweet_count < highest_count

      @inferred_type = set_type(highest_count)

      return @inferred_type
    end

    def set_type(highest_count)
      return :originator if @tweet_count > (@retweet_count + @link_count + @reply_count)

      return :undetermined if equal_highest?(highest_count, @retweet_count, @link_count)
      return :undetermined if equal_highest?(highest_count, @retweet_count, @reply_count)
      return :undetermined if equal_highest?(highest_count, @link_count, @reply_count)

      return :retweeter if highest_count == @retweet_count
      return :linker if highest_count == @link_count
      return :chatter if highest_count == @reply_count
    end

    def to_s
      @screen_name + ": #tweets " + @tweet_count.to_s + ", #replies " + @reply_count.to_s + ", #retweets " + @retweet_count.to_s + ", #links " + @link_count.to_s + "\n"
    end

    def ==(other)
      result = @screen_name == other.screen_name
      result = result && @tweet_count == other.tweet_count
      result = result && @reply_count == other.reply_count
      result = result && @retweet_count == other.retweet_count
      result = result && @link_count == other.link_count

      return result
    end

  end
end