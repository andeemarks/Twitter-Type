require 'SQLite3'
include SQLite3

class ProfilePersister
  def persist(profile)
    @db = Database.open("twitter_type_profiles.db")
    @db.execute("select * from profle") rescue create_table
    
    @db.close
  end
  
  def create_table
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