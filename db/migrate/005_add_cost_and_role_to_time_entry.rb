class AddCostAndRoleToTimeEntry < ActiveRecord::Migration
  def self.up
    add_column :time_entries, :cost, :float, :default => 0.0, :null => false
    add_column :time_entries, :hr_profile_id, :integer, :default => :null, :null => true
  end

  def self.down
    remove_column :time_entries, :cost
    remove_column :time_entries, :hr_profile_id
  end
end
