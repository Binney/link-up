class AlterFavouritesIndices < ActiveRecord::Migration
  def change
    remove_index :favourites, [:user_id, :event_id]
    add_index :favourites, [:user_id, :event_id, :day]
  end
end
