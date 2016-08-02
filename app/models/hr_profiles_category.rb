class HrProfilesCategory < ActiveRecord::Base
	has_many :profiles, class_name: "HrProfile", foreign_key: "hr_profiles_category_id", dependent: :nullify

	validates_presence_of :name
  	validates_length_of :name, :maximum => 20
end
