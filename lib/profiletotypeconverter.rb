require "tweeterprofile"
require "types"

include TwitterType

module TwitterType

class ProfileToTypeConverter

  def convert(profile)

    attributes = [profile.retweet_count, profile.link_count, profile.reply_count]
    highest_count = attributes.max

    raise ArgumentError if profile.tweet_count < highest_count
    
    return Types::ORIGINATOR if profile.tweet_count > (profile.retweet_count + profile.link_count + profile.reply_count)

    return Types::UNDETERMINED if highest_count == profile.retweet_count and highest_count == profile.link_count
    return Types::UNDETERMINED if highest_count == profile.retweet_count and highest_count == profile.reply_count
    return Types::UNDETERMINED if highest_count == profile.link_count and highest_count == profile.reply_count

    return Types::RETWEETER if highest_count == profile.retweet_count
    return Types::LINKER if highest_count == profile.link_count
    return Types::CHATTER if highest_count == profile.reply_count
  end
end

end