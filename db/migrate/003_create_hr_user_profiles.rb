class CreateHrUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :hr_user_profiles, :force => true do |t|
      t.column :user_id, :integer, :null => false
      t.column :hr_profile_id, :integer, :null => true
      t.column :start_date, :datetime, :null => false
      t.column :end_date, :datetime, :null => true
    end
  end

  def self.down
    drop_table :hr_user_profiles
  end
end
