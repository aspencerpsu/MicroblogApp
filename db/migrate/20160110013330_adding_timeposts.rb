class AddingTimeposts < ActiveRecord::Migration
  def change_table
      add_column(:posts, :created_at, :datetime)
      add_column(:posts, :updated_at, :datetime)
  end
end
