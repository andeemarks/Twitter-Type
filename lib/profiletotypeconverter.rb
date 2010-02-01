require "tweeterprofile"
require "types"

module TwitterType

class ProfileToTypeConverter

  def convert(profile)

    attributes = [profile.retweet_count, profile.link_count, profile.reply_count]
    highest_count = attributes.max

    raise ArgumentError if profile.tweet_count < highest_count
    
    return Types::ORIGINATOR if profile.tweet_count > (profile.retweet_count + profile.link_count + profile.reply_count)

    return TypeInferrer::UNDETERMINED if highest_count == profile.retweet_count and highest_count == profile.link_count
    return TypeInferrer::UNDETERMINED if highest_count == profile.retweet_count and highest_count == profile.reply_count
    return TypeInferrer::UNDETERMINED if highest_count == profile.link_count and highest_count == profile.reply_count

    return TypeInferrer::RETWEETER if highest_count == profile.retweet_count
    return TypeInferrer::LINKER if highest_count == profile.link_count
    return TypeInferrer::CHATTER if highest_count == profile.reply_count
  end
end

end