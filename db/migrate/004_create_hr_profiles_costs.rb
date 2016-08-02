class CreateHrProfilesCosts < ActiveRecord::Migration
  def self.up
    create_table :hr_profiles_costs, :force => true do |t|
      t.column :hr_profile_id, :integer, :null => true
      t.column :year, :integer, :null => false
      t.column :hourly_cost, :float, :default => 0.0, :null => false
    end
  end

  def self.down
    drop_table :hr_profiles_costs
  end
end
