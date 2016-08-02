module Hr
  module ApplicationHelperPatch
    def self.included(base)
      base.class_eval do
				def currency(n)
				  number_to_currency n, :locale => Setting.default_language
				end
      end
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  ApplicationHelper.send(:include, Hr::ApplicationHelperPatch)
end

