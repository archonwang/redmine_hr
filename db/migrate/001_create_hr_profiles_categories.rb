class CreateHrProfilesCategories < ActiveRecord::Migration
  def self.up
    create_table :hr_profiles_categories, :force => true do |t|
      t.column :name, :string, :limit => 20, :null => false
    end
  end

  def self.down
    drop_table :hr_profiles_categories
  end
end
