module RestMyCase

  module Status

    def self.included(parent_class)
      return unless parent_class.respond_to? :trial_court

      parent_class.trial_court.context_class = Context::Status
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
