module Hr
  module UsersHelperPatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :user_settings_tabs, :profile_history
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def user_settings_tabs_with_profile_history
        tabs = user_settings_tabs_without_profile_history
        tabs << {:name => 'profile_history', :partial => 'users/profile', :label => :'hr.label_profile_history'}
      end
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  UsersHelper.send(:include, Hr::UsersHelperPatch)
end
