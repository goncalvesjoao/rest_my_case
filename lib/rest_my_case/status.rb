require 'rest_my_case/context/status'

module RestMyCase

  module Status

    def self.included(parent_class)
      return unless parent_class.respond_to? :trial_court

      parent_class.trial_court.context_class = Context::Status
    end

    def status
      context.status
    end

    def failure(status, error_message = nil)
      if error_message.is_a?(Hash)
        error_data = error_message
      else
        error_data = { message: error_message }
      end

      error_data[:status] = status

      error(error_data)
    end

    def failure!(status, error = nil)
      failure(status, error) && fail(Errors::Abort)
    end

  end

end
