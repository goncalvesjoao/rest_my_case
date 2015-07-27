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

    def failure(status, error = nil)
      error = { message: error } unless error.is_a?(Hash)

      error[:status] = status

      error(error)
    end

    def failure!(status, error = nil)
      failure(status, error) && fail(Errors::Abort)
    end

  end

end
