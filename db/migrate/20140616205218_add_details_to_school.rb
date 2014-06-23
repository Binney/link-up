class AddDetailsToSchool < ActiveRecord::Migration
  def change
  	add_column :schools, :teacher_code, :string
  	add_column :schools, :student_code, :string
  	add_column :schools, :student_quantity, :integer, default: 0
  	add_column :users, :school_id, :integer, default: 1
  end
end
