require 'rest_my_case/context/status'

module RestMyCase

  module Status

    module ClassMethods
      def trial_court
        @trial_court ||= Trial::Court.new \
          Judge::Base, DefenseAttorney::Base, Base, Context::Status
      end
    end

    def self.included(parent_class)
      parent_class.extend ClassMethods
    end

    def status
      context.status
    end

    def failure(status, error_message = nil)
      error_data = \
        error_message.is_a?(Hash) ? error_message : { message: error_message }

      error_data[:status] = status

      error(error_data)
    end

    def failure!(status, error = nil)
      failure(status, error) && raise(Errors::Abort)
    end

  end

end
