module Hr
  module UserPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        has_many :profiles, class_name: "HrUserProfile", foreign_key: "user_id", :dependent => :destroy
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def current_profile(date = Date.today)
        (user_profile = profiles.where("(? BETWEEN start_date AND end_date) OR (start_date <= ? AND end_date IS NULL)", date, date).first).present? ?
          user_profile.profile :
          nil
      end

      def current_cost(date = Date.today)
        (profile = current_profile(date)).present? ? 
          profile.costs.where(year: date.year).first : 
          nil
      end
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  # use require_dependency if you plan to utilize development mode
  require_dependency 'principal'
  require_dependency 'user'
  User.send(:include, Hr::UserPatch)
end
