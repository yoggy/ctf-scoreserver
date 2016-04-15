require 'rubygems'
require 'sinatra'
require 'time'

#
# announcement
#
get '/announcements' do
  limit = 7
  page = params["page"].to_i
  @announcements = Announcement.where(show: true).order("time DESC").limit(limit).offset(page * limit)
  erb :announcements
end

