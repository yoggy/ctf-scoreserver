#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'digest/sha1'

require 'config.rb'

require 'json'

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
    redirect 'main'
  end
end

# 
post '/admin/delete' do 
  admin_block do
    content_type :json
  
    begin
      c = Challenge.find(params['id'])
      c.delete
    rescue Exception => e
      pp e
    end
    redirect 'main'
  end
end

