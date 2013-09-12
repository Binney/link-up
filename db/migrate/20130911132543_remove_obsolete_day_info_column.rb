class RemoveObsoleteDayInfoColumn < ActiveRecord::Migration
  def change
    remove_column :events, :day_info
  end
end
