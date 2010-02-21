require 'twittertypeinferrer'

module TwitterType

  inferrer = TwitterType::TypeInferrer.new()

  ARGV.each do |screen_name|
    inferrer.infer(screen_name)
    print inferrer.profile
  end
end
