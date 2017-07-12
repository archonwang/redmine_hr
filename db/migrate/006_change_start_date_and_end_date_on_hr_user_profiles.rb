class ChangeStartDateAndEndDateOnHrUserProfiles < ActiveRecord::Migration
  def self.up
    change_column :hr_user_profiles, :start_date, :date
    change_column :hr_user_profiles, :end_date, :date
  end

  def self.down
    change_column :hr_user_profiles, :start_date, :datetime
    change_column :hr_user_profiles, :end_date, :datetime
  end
end
