require 'rubygems'
require 'sinatra'
require 'digest/sha1'

# signup
get '/signup2' do
  redirect "./signup"
end

post '/signup2' do
  session_clear

  name     = params['name']
  email    = params['email']
  password = params['password']

  if name.nil? || email.nil? || password.nil? || name == "" || email == "" || password == ""
    redirect "/signup"
  else
    if User.find_by_name(name).nil? && User.find_by_email(email).nil?
      u = User.new
      u.name     = params['name']
      u.email    = params['email']
      u.password = Digest::SHA1.hexdigest(params['password'])
      u.save
    end
    erb :signup2, :layout => false
  end
end

get '/signup' do
 session_clear

 erb :signup
end

