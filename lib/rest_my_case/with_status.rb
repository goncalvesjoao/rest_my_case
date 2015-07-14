module RestMyCase

  class WithStatus < Base

    def self.trial_court
      @trial_court ||= Trial::Court.new \
        Judge::Base, DefenseAttorney::Base, Base, Context::Status::Base
    end

    def failure!(status, message = nil)
      context.status.send("#{status}!")

      error!(message || status)
    end

  end

end
