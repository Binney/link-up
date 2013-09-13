class CreateMentorships < ActiveRecord::Migration
  def change
    create_table :mentorships do |t|
      t.integer :mentor_id
      t.integer :mentee_id
      t.integer :confirmation_stage, default: 0
      # Confirmation stages:
      #
      # 0: Created by mentor
      # 1: Confirmed by mentee but not admin
      # 2: Confirmed by admin but not mentee
      # 3: Confirmed by both and thus valid

      t.timestamps
    end
  end
end
