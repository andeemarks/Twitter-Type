require 'SQLite3'
include SQLite3

class ProfilePersister
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
    select max(last_tweet_id)
    from profile
    where tweeter_name = ?;    
  SQL
  
  def get_last_profile_id(screen_name)
    @db = Database.open("twitter_type_profiles.db")
    
    @db.execute("select count(*) from profile") rescue create_table
    
    last_profile_id = select_last_profile_id(screen_name)
    
    @db.close
    
    return last_profile_id
    
  end
  
  def select_last_profile_id(screen_name)
    @db.get_first_value(LAST_PROFILE_QUERY_SQL, screen_name)
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
        @profile.tweeter.screen_name, 
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