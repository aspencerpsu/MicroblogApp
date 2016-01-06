class CreateMoreForeignKeys < ActiveRecord::Migration
  def change
  	rename_column :relationships, :followers, :follower_id
	rename_column :relationships, :followees, :followee_id
  end
end
