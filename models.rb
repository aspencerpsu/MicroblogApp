class User <ActiveRecord::Base
	has_many :posts
	has_many :relationships, foreign_key: :follower_id
	has_many :relationships, through: :relationships
	has_many :followings, through: :relationships
	has_many :followings, foreign_key: :followee_id
end

class Post <ActiveRecord::Base
	belongs_to :user
end

class Relationship <ActiveRecord::Base
	belongs_to :follower, foreign_key: :follower_id
	belongs_to :followee, foreign_key: :followee_id
end
# 2 Convention over Configuration in Active Record

#3 Database Table - Plural with underscores separating words (e.g., book_clubs).
#4 Model Class - Singular with the first letter of each word capitalized (e.g., BookClub).
