require 'sinatra'
require 'time'

#
# ranking
#
get '/ranking' do
  login_block do
    us = User.all
    us = us.inject([]) {|r, u| u.total_score > 0 ? r + [u] : r}

    us.sort! {|a, b| 
      at = a.total_score
      bt = b.total_score
      at == bt ? b.last_answer_time <=> a.last_answer_time : at <=> bt
    }
    us.reverse!

    @scores = []
    us.each{|u|
      @scores << {
        'name' => u.name,
        'score' => u.total_score,
        'last_answer_time' => u.last_answer_time.iso8601
      }
    }
    
    erb :ranking
  end
end

