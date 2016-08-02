class CreateHrProfiles < ActiveRecord::Migration
  def self.up
    create_table :hr_profiles, :force => true do |t|
      t.column :name, :string, :limit => 20, :null => false
      t.column :hr_profiles_category_id, :integer, :null => true
    end
  end

  def self.down
    drop_table :hr_profiles
  end
end