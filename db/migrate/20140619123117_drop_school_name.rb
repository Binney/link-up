class DropSchoolName < ActiveRecord::Migration
  def change
  	remove_column :schools, :name
  end
end
