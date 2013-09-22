class IndexUsersOnSchool < ActiveRecord::Migration
  def change
    add_index :users, :school
  end
end
