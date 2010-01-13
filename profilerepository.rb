require 'SQLite3'
include SQLite3

class ProfileRepository
  PROFILE_INSERT_SQL =<<-SQL
  insert into profile 
    (tweeter_name, 
    number_of_tweets, 
    number_of_retweets, 
    number_of_links, 
    number_of_chats,
    last_tweet_id) 
    values ( ?, ?, ?, ?, ?, ? );
    SQL
    
  LAST_PROFILE_QUERY_SQL =<<-SQL
    select * 
    from profile 
    where last_tweet_id = 
    (select max(last_tweet_id) 
    from profile 
    where tweeter_name = ?);
  SQL
  
  def get_last_profile(screen_name)
    @db = Database.open("twitter_type_profiles.db")
    
    @db.execute("select count(*) from profile") rescue create_table
    
    last_profile = select_last_profile(screen_name)
    
    @db.close
    
    return last_profile
    
  end
  
  def select_last_profile(screen_name)
    #last_profile = TweeterProfile.new
    
    @db.query(LAST_PROFILE_QUERY_SQL, screen_name) do |result|
      if (result.eof?)
        return TweeterProfile.new("no previous profile")
      end

      result.each do |row| 
        last_profile = TweeterProfile.new(row.tweeter_name)
        last_profile.tweet_count = row.number_of_tweets
        last_profile.retweet_count = row.number_of_retweets
        last_profile.reply_count = row.number_of_chats
        last_profile.link_count = row.number_of_links
        last_profile.last_tweet_id = row.last_tweet_id
      end
    end
    
    return last_profile
  end
  
  def persist(profile)
    @profile = profile
    @db = Database.open("twitter_type_profiles.db")
    
    @db.execute("select count(*) from profile") rescue create_table
    
    insert_profile
    
    @db.close
  end

  def insert_profile
      @db.execute(PROFILE_INSERT_SQL, 
        @profile.screen_name, 
        @profile.tweet_count, 
        @profile.retweet_count, 
        @profile.link_count, 
        @profile.reply_count,
        @profile.last_tweet_id)
  end
    
  def create_table
    @db.execute_batch <<-SQL
        create table profile (
          id integer primary key,
          tweeter_name varchar(200) not null,
          number_of_tweets integer,
          number_of_retweets integer,
          number_of_links integer,
          number_of_chats integer,
          last_tweet_id varchar(50)
        )
      SQL
  end
end