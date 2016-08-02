class HrProfilesCost < ActiveRecord::Base
	
	belongs_to :profile, class_name: "HrProfile", foreign_key: "hr_profile_id"
  has_many :time_entries, ->(hpc) { where("tyear = ?", hpc.year) }, :through => :profile

	validates :hourly_cost, :numericality => { :greater_than_or_equal_to => 0 }, :presence => true

	after_save :save_profile_cost
	after_destroy :destroy_profile_cost

	DEFAULT_HOURLY_COST = 0.0

	def self.years
		select(:year).distinct.map(&:year)
	end

	def get_errors
		errors.present? ? errors.full_messages.map{|m| profile.name+": "+m} : []
	end

	def save_profile_cost
	  if self.hourly_cost_changed?
		  self.time_entries.each do |te|
		  	te.set_profile_and_cost(te.hr_profile_id, self.hourly_cost)
		  end
		end
	end

	def destroy_profile_cost
	  self.time_entries.each do |te|
	  	te.set_profile_and_cost(te.hr_profile_id, DEFAULT_HOURLY_COST)
	  end
	end
end
