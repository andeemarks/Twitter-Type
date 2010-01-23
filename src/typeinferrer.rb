require "src/tweeterprofile"
require "src/twittertype"

class TypeInferrer

  def infer(profile)

    attributes = [profile.retweet_count, profile.link_count, profile.reply_count]
    highest_count = attributes.max

    return TwitterType::ORIGINATOR if profile.tweet_count > (profile.retweet_count + profile.link_count + profile.reply_count)

    return TwitterType::UNDETERMINED if highest_count == profile.retweet_count and highest_count == profile.link_count
    return TwitterType::UNDETERMINED if highest_count == profile.retweet_count and highest_count == profile.reply_count
    return TwitterType::UNDETERMINED if highest_count == profile.link_count and highest_count == profile.reply_count

    return TwitterType::RETWEETER if highest_count == profile.retweet_count
    return TwitterType::LINKER if highest_count == profile.link_count
    return TwitterType::CHATTER if highest_count == profile.reply_count
  end
end
