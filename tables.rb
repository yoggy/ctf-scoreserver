#!/usr/bin/ruby
require 'rubygems'
require 'active_record'

$db = 'db.sqlite3'

# DB
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      
      t.text     :name
      t.text     :email
      t.string   :password

      t.timestamps
    end
    
    add_index :users, :id
    add_index :users, :name
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end

end

class CreateChallenges < ActiveRecord::Migration
  def self.up
    create_table :challenges do |t|
      
      t.string   :status
      t.text     :abstract
      t.text     :detail
      t.integer  :point
      t.text     :answer

      t.timestamps
    end

    add_index :challenges, :id
  end

  def self.down
    drop_table :challenges
  end
end

class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      
      t.integer  :user_id
      t.integer  :challenge_id
      t.text     :answer

      t.timestamps
    end

    add_index :answers, :user_id
    add_index :answers, :challenge_id
  end

  def self.down
    drop_table :answers
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => $db,
  :timeout => 10000
)

class User < ActiveRecord::Base
  has_many :answers

  def total_score
    return 0 if self.answers.nil?

    total = 0
    self.answers.each{|a|
      total += a.challenge.point
    }
    total
  end

  def last_answer_time
    return Time.utc("1970-1-1") if self.answers.nil? 
    self.answers.sort{|a, b| a.created_at <=> b.created_at}.reverse[0].created_at
  end
end

class Challenge < ActiveRecord::Base
  has_many :answers
end

class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
end

unless File.exist? $db
  CreateUsers.up
  CreateChallenges.up
  CreateAnswers.up
end

