class AddDayinfoStringToEvents < ActiveRecord::Migration
  def change
    add_column :events, :day_info, :string
  end
end
