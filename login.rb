require 'sinatra'
require 'digest/sha1'

helpers do
  def session_clear
    session.delete('uid')
  end

  def is_login
    !(session['uid'].nil? || session['uid'] == "" || User.find(session['uid']).nil?)
  end

  def login_block
    if is_login
      yield
    else
      redirect '/'
    end
  end

  def get_uid
    session['uid']
  end

  def get_name
    u = User.find(get_uid)
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

  u = User.where(email: email).first
  if u != nil
    if Digest::SHA1.hexdigest(password) == u.password
      session['uid'] = u.id
      session['dummy'] = Digest::SHA1.hexdigest(Time.new.to_s)
      redirect '/challenge'
    end
  end

  redirect '/'
end

get '/logout' do
  session_clear
  redirect '/'
end

