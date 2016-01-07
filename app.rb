require 'sinatra'
require 'sinatra/activerecord'
# require 'sinatra/flash'
require './models.rb'

use Rack::Session::Pool
enable :sessions
set :protection, :session => true

set :database, "sqlite3:groupblog.sqlite3"

def current_user
  if session[:user_id]
    @current_user = User.find(session[:user_id])
  end
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
	@user = User.create(username: params[:username], password: params[:password], first: params[:first], last: params[:last],  email: params[:email])
	session[:user_id] = @user.id
	if @user.save
		redirect '/'
	else
		'/signup'
	end
end

get '/signin' do
	erb :signin
end

get '/post/:user_id' do 
	@user = current_user
	if @user
		@posts = Post.where(user_id: @user.id).first
		erb :post
	else
		redirect '/'
	end
end

post '/post/:user_id/new' do 
	@user = current_user
	if @user
		@post = Post.create(user_id: @current_user.id, post: params[:userbody], params[:title])
	else
		@cantsign = "Can't post your food for thought, try again buddy"
	end
	erb :post
end

post '/signin' do
	# Select the first user in the Users table (i.e. row 1)
	@user = User.where(username: params[:username]).first
	# Check to see if the password is the same as the parameter of the user and the session cookie is empty
	if @user.password == params[:password]
		session[:user_id] = @user.id
    	# flash[:notice] = "You've been signed in successfully."
    	# current_user
    	puts 'params are for current_user ' + @user.id.inspect 
    	redirect '/post/:user_id'
	else
		redirect '/'
	end
end

get '/logout' do
	session.clear
	redirect '/'
end

get '/post/#{@user.id}/profile' do 
	erb :profile
end

post '/post/profile' do 
	@user = current_user

end


# #Client will be redirected towards a new post page
# get '/post/:user_id.username/new' do

# end

# post '/post' do
# 	current_user
# 	@post = Post.create(: params[username], password: params[password])


