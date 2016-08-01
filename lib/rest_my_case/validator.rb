require 'object_attorney'

module RestMyCase
  class Validator < Base
    include ObjectAttorney

    def self.target(name, options = {})
      defend(name, options)

      if defendant_options[:in].present?
        context_reader defendant_options[:in]
      else
        context_reader name
      end
    end

    trial_court.last_ancestor = Validator

    self.silence_dependencies_abort = true

    def perform
      return if defendant_options.empty?

      error('unprocessable_entity') if invalid?
    end
  end
end
