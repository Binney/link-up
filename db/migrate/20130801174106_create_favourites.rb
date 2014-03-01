class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
    add_index :favourites, :user_id
    add_index :favourites, :event_id
    add_index :favourites, [:user_id, :event_id], unique: true
  end
end
