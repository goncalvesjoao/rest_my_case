module RestMyCase

  class HttpStatus < Status

    def self.trial_court
      @trial_court ||= Trial::Court.new \
        Judge::Base, DefenseAttorney::Base, Base, Context::HttpStatus
    end

  end

end
