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

post '/post' do
	@user = current_user
	@posts = Post.create(post: params[:body], user_id: @user.id, title: params[:title])
	redirect '/post'
end

get '/feed' do 
	@feeds = Post.all
	erb :feed
end

get '/post/:user_id' do 
	@user = current_user
	if @user
		@posts = Post.where(user_id: @user.id)
		@totalposts = Post.where(user_id: @user.id).all
		# puts 'my params for the post are' + "#{@totalposts[0].user_id}"
		erb :post
	else
		redirect '/'
	end
	erb :post
end

get '/post/users' do 
	@user = current_user
	if @user 
		@all_users = User.all
		@user_profile = @all_users.find(params[:id])
		erb :users
	else
		redirect '/signin'
	end
end

post '/post/:user_id' do 
	@user = current_user
	if @user
		@posts = Post.new(user_id: @current_user.id, post: params[:userbody], title: params[:title])
		puts "the body for the param is classified as: " + params[:userbody].length.inspect
		puts "the official timestamp for the post is" + "#{@posts.created_at}"
		if params[:userbody].length <= 140
			@posts.save
			puts "the official timestamp for the post is " + "#{@posts.created_at}"
			redirect '/post/:user_id'
		elsif params[:userbody].length > 140
			@characteroverload = "Characters cannot exceed 140"

			@totalposts = Post.where(user_id: @user.id).all

			erb :post
		end
	else
		@cantsign = "Can't post your food for thought, try again buddy"
	end
end

get '/logout' do
	session.clear
	redirect '/'
end

     
get '/post/:id/profile' do 
	@user = current_user
	erb :profile
end

post '/post/:id/profile' do 
	@user = current_user
	puts "my params are now " + params.inspect
	@update = User.find_by(id: @user.id)
	if params[:first] && params[:last] && params[:email] != ""
		@update.update(first: params[:first], last: params[:last], email: params[:email])
		@update.save
	else
		redirect '/post/profile'
	end
	puts @update
	redirect '/post'
end