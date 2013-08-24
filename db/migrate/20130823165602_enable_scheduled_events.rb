class EnableScheduledEvents < ActiveRecord::Migration
  def change
    rename_column :events, :cost, :cost_details
    add_column :events, :cost, :integer
    add_column :favourites, :schedule, :string
    add_column :events, :schedule, :string
  end
end
