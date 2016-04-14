#!/usr/bin/ruby
require 'active_record'

$db = 'db.sqlite3'

# DB
class CreateUsers < ActiveRecord::Migration
  def change
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
end

class CreateChallenges < ActiveRecord::Migration
  def change
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
end

class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer  :user_id
      t.integer  :challenge_id
      t.text     :answer

      t.timestamps
    end

    add_index :answers, :user_id
    add_index :answers, :challenge_id
  end
end

class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.datetime :time
      t.text     :subject
      t.text     :html
      t.boolean  :show

      t.timestamps
    end
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

class Announcement < ActiveRecord::Base
end

if !File.exist?($db) || File.size($db) == 0
  CreateUsers.new.change
  CreateChallenges.new.change
  CreateAnswers.new.change
  CreateAnnouncements.new.change
end
