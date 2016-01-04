class CreateTableTweets < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.string :post
  		t.integer :user_id
  		t.string :title
  	end
  end
end
