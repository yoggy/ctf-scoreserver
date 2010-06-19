require 'rubygems'
require 'sinatra'
require 'digest/sha1'

helpers do
  def session_clear
    session.delete('uid')
  end

  def login_block
    if session['uid'].nil? || session['uid'] == "" || User.find_by_id(session['uid']).nil?
      redirect '/'
    else
      yield
    end
  end

  def get_uid
    session['uid']
  end

  def get_name
    u = User.find_by_id(get_uid)
    return "" until u

    u.name
  end
end

#
# login / logout
#
get '/login' do
  redirect '/'
end

post '/login' do
  session_clear

  email    = params['email']
  password = params['password']

  if email.nil? || password.nil? || email == "" || password == ""
    redirect '/'
  end

  u = User.find_by_email(email, :first)
  if u != nil
    if Digest::SHA1.hexdigest(password) == u.password
      session['uid'] = u.id
      session['dummy'] = Digest::SHA1.hexdigest(Time.new.to_s)
      redirect './challenge'
    end
  end

  redirect './'
end

get '/logout' do
  session_clear
  redirect '/'
end

