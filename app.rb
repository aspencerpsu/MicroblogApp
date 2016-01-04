require 'sinatra'
require 'sinatra/activerecord'
require './models.rb'
enable :sessions

set :database, "sqlite3:groupblog.sqlite3"

