class ChangeColumnPost < ActiveRecord::Migration
  def change
  	change_column(:posts, :post, :text, limit: 140)
  end
end
