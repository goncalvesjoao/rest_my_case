module RestMyCase

  module HttpStatus

    include Status

    def self.included(parent_class)
      return unless parent_class.respond_to? :trial_court

      parent_class.trial_court.context_class = Context::HttpStatus
    end

  end

end
