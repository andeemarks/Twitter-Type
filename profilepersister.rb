require 'SQLite3'
include SQLite3

class ProfilePersister
  PROFILE_INSERT_SQL =<<-SQL
  insert into profile 
    (tweeter_name, 
    number_of_tweets, 
    number_of_retweets, 
    number_of_links, 
    number_of_chats) 
    values ( ?, ?, ?, ?, ?);
    SQL
    
  def self.persist(profile)
    @profile = profile
    @db = Database.open("twitter_type_profiles.db")
    
    @db.execute("select count(*) from profile") rescue create_table
    
    insert_profile
    
    @db.close
  end

  def self.insert_profile
      @db.execute(PROFILE_INSERT_SQL, 
        @profile.tweeter.screen_name, 
        @profile.tweet_count, 
        @profile.retweet_count, 
        @profile.link_count, 
        @profile.reply_count)
  end
    
  def self.create_table
    @db.execute_batch <<-SQL
        create table profile (
          id integer primary key,
          tweeter_name varchar(200) not null,
          number_of_tweets integer,
          number_of_retweets integer,
          number_of_links integer,
          number_of_chats integer
        )
      SQL
  end
end