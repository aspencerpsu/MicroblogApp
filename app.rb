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


# This /signup get and post route allows a new user to
# signup and become a user of this microblog app
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
#######################################################

# This post and get route gives an existing user the 
# ability to sign in and also logout in the 
# logout route
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
    	redirect '/post/:id'
	else
		redirect '/'
	end
end

get '/logout' do
	session.clear
	redirect '/'
end

####################################################

# This allows any user to the see the entire 
# posts from every user
get '/feed' do 
	@feeds = Post.all
	@latest_feed = @feeds.reverse
	erb :feed
end
#####################################################

# This is the main user page, a user will be able
# to edit their profile, create posts, look at the
# posts they have created, and see other users that
# have signed up.
get '/post/:id' do 
	@user = current_user
	if @user
		@posts = Post.where(user_id: @user.id)
		@totalposts = Post.where(user_id: @user.id).all
		erb :post
	else
		redirect '/'
	end
	erb :post
end

post '/post/:id' do 
	@user = current_user
	if @user
		@posts = Post.new(user_id: @current_user.id, post: params[:userbody], title: params[:title])
		puts "the body for the param is classified as: " + params[:userbody].length.inspect
		if params[:userbody].length <= 140
			@posts.save
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

#####################################################
# This is for a post deletion for a single post after
# a user signs in

get '/post/:id/delete_post' do 
	@single_post = params[:id]
	@find_single_post = Post.find(@single_post)
	@find_single_post.destroy
	redirect '/post/:id'
end

#####################################################

# This is the user profile page that a user
# can see after signing in. A user should be 
# able to edit profile information from this
# get and post route in /post/:id/profile
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
		add this
	else
		redirect '/post/profile'
	end
	puts @update
	redirect '/post/:user_id'
end
########################################################

# This route will delete a user from the database and
# all of the users posts that is associated with him.
get '/post/:id/profile/delete' do 
	@user_delete = User.find(params[:id])
	@user_post_delete = Post.find_by(user_id: params[:id])
	@user_delete.destroy
	@user_post_delete.destroy
	redirect '/'
end
########################################################

# This user route will show all users that exist in
# the microblog app, a user that has signed in should
# be able to click on a user and see his posts and 
# profile information

get '/users' do
	@user = current_user
	if @user 
		@all_users = User.all
		erb :users
	end
end

get '/users/profile/:id' do 
	@user_person = params[:id]
	puts "my param is " + @user_person
	@user_find = User.find(@user_person)
	erb :users_profile
end




