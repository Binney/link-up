class AddSchools < ActiveRecord::Migration
  def change
    add_column :users, :school, :string
    add_column :venues, :is_school, :boolean, default: 0
  end
end
