class AddSchoolIdToLogbooks < ActiveRecord::Migration
  def change
  	add_column :logbook_templates, :school_id, :integer
  end
end
