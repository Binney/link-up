class AddAgeInfoToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :max_age, :integer
  	add_column :events, :min_age, :integer
  	add_column :schools, :mentor_code, :string
  end
end
