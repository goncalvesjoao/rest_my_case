module RestMyCase

  module HttpStatus

    def self.included(parent_class)
      parent_class.include Status

      parent_class.trial_court.context_class = Context::HttpStatus
    end

  end

end
