require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
enable :sessions

set :database, "sqlite3:groupblog.sqlite3"


# This route is used for the sign-in and sign-up
get '/' do 
	redirect '/signin'
end

get '/signin' do 
	erb :index
end


# This will be used for the sign-in and sign-up
# post '/' do	
# end