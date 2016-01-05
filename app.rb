require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
require 'sinatra/flash'
enable :sessions

set :database, "sqlite3:groupblog.sqlite3"

def current_user
  if session[:user_id].has_value?
    @current_user = User.find(session[:user_id])
  else
  	@current_user = nil
end

# This route is used for the sign-in and sign-up
get '/' do 
	erb :index
end

get '/signup' do
	erb :signup
end

post '/signup' do 
	params.inspect
	@user = User.create(username: params[username], password: params[password], first: params[first], last: params[last],  email: params[email])
	session[:user_id] = @user.id
	redirect '/'
end

post '/signin' do
	# Select the first user in the Users table (i.e. row 1)
	@user = User.where(username: params[:username]).first
	# Check to see if the password is the same as the parameter of the user and the session cookie is empty
	if @user.password == params[:password]
		current_user
    	# flash[:notice] = "You've been signed in successfully."
    	# current_user
    	puts 'params are for current_user ' + current_user.inspect
    	erb :post_sign
	else
		redirect '/'
	end
end

#Client will be redirected towards a new post page
get '/post/:user_id.username/new' do

end

post '/post' do
	current_user
	@post = Post.create(: params[username], password: params[password])


