class RelationshipUsers < ActiveRecord::Migration
  def change
  	create_table :relationships do |t|
  		t.integer :user_id
  		t.integer :post_id
  	end
  end
end
