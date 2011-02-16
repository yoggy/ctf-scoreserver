#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'digest/sha1'

require 'config.rb'

require 'json'
require 'time'

require 'pp'

helpers do
  def admin_session_clear
    session.delete('admin')
  end

  def admin_block
    if !session.key?('admin') || session['admin'] != true
      redirect '/admin'
    else
      yield
    end
  end
end

get '/admin' do 
  admin_session_clear
  erb :admin_login
end

post '/admin/login' do
  p = params['password']
  if !p.nil? && Digest::SHA1.hexdigest(p) == ADMIN_PASS_SHA1
    session['admin'] = true
    redirect '/admin/main'
  else
    redirect '/admin'
  end
end

get '/admin/logout' do
  admin_session_clear
  redirect '/admin'
end

get '/admin/main' do 
  admin_block do
    @challenges = Challenge.find(:all)
    erb :admin_main
  end
end

# for ajax
post '/admin/load' do
  admin_block do
    content_type :json
    begin
      c = Challenge.find_by_id(params['id'], :first)
    rescue Exception => e
      pp e
    end

    if c != nil
      j = {
        :id       => c.id,
        :point    => c.point,
        :status   => c.status,
        :abstract => c.abstract,
        :detail   => c.detail,
        :answer   => c.answer,
        :result   => true
      }
      JSON.unparse(j)
    else
      JSON.unparse({:result => false, :err_msg => "challenge id=#{id} is not found.."})
    end
  end
end

# 
post '/admin/save' do
  c = Challenge.find_by_id(params['id'])
  c ||= Challenge.new

  admin_block do
    c.id       = params['id']
    c.point    = params['point']
    c.status   = params['status']
    c.abstract = params['abstract']
    c.detail   = params['detail']
    c.answer   = params['answer']
    c.save
    redirect '/admin/main'
  end
end

post '/admin/delete' do 
  admin_block do
    begin
      c = Challenge.find(params['id'])
      c.delete
    rescue Exception => e
      pp e
    end
    redirect '/admin/main'
  end
end

get '/admin/announcements' do
  admin_block do
    @announcements = Announcement.find(:all, :order => "time DESC")
    erb :admin_announcements
  end
end

post '/admin/load_announcement' do
  admin_block do
    content_type :json
    begin
      a = Announcement.find_by_id(params['id'], :first)
    rescue Exception => e
      pp e
    end

    if a != nil
      j = {
        :id      => a.id,
        :time    => a.time.strftime("%Y-%m-%d %H:%M"),
        :show    => a.show.to_s,
        :subject => a.subject,
        :html    => a.html,
        :result  => true
      }
      JSON.unparse(j)
    else
      JSON.unparse({:result => false, :err_msg => "announce id=#{id} is not found.."})
    end
  end
end

post '/admin/save_announcement' do 
  a = Announcement.find_by_id(params['id'])
  a ||= Announcement.new

  admin_block do
    a.id      = params['id']
    a.time    = Time.parse(params['time'])
    a.show    = params['show']
    a.subject = params['subject']
    a.html    = params['html']
    a.save
    redirect '/admin/announcements'
  end
end

post '/admin/delete_announcement' do
  admin_block do
    begin
      a = Announcement.find(params['id'])
      a.delete
    rescue Exception => e
      pp e
    end
    redirect '/admin/announcements'
  end
end

