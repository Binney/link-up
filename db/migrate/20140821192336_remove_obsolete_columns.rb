class RemoveObsoleteColumns < ActiveRecord::Migration
  def change
  	remove_column :venues, :is_school
  	remove_column :users, :school
  	remove_column :schools, :student_quantity
  end
end
