module RestMyCase

  class Status < Base

    def self.trial_court
      @trial_court ||= Trial::Court.new \
        Judge::Base, DefenseAttorney::Base, Base, Context::Status::Base
    end

    context_reader :status

    def failure(status, message = nil)
      context.status.send("#{status}!")

      error(Helpers.blank?(message) ? "#{status}" : "#{status} - #{message}")
    end

    def failure!(status, message = nil)
      failure(status, message) && fail(Errors::Abort)
    end

  end

end
