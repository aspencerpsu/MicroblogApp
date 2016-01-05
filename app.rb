require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
enable :sessions

set :database, "sqlite3:groupblog.sqlite3"


# This route is used for the sign-in and sign-up
get '/' do 

	erb :index
end

get '/signup' do
	erb :signup
end

post '/signup' do 
	@user = User.create(username: params[username], password: params[password], first: params[first], last: params[last],  email: params[email])
	session[:user_id] = @user.id
	redirect '/'
end


# This will be used for the sign-in and sign-up
# post '/' do	
# end