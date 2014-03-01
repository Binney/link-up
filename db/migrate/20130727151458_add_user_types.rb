class AddUserTypes < ActiveRecord::Migration
  def change
    add_column :users, :mentor, :boolean, default: 0
    add_column :users, :organiser, :boolean, default: 0
  end
end
