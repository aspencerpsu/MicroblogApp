class User <ActiveRecord::Base
	has_many :posts
	has_many :follows, foreign_key: :follower_id
	has_many :follows, through: :relationships, class_name: Relationship
	has_many :followings, through: :relationships, class_name: Relationship
	has_many :followings, foreign_key: :followee_id, class_name: Follow
end

class Post <ActiveRecord::Base
	belongs_to :user
end

class Relationship <ActiveRecord::Base
	belongs_to :follower, foreign_key: :follower_id, class_name: User
	belongs_to :followee, foreign_key: :followee_id, class_name: User
end
# 2 Convention over Configuration in Active Record

#3 Database Table - Plural with underscores separating words (e.g., book_clubs).
#4 Model Class - Singular with the first letter of each word capitalized (e.g., BookClub).
