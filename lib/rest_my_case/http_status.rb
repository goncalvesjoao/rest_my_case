# frozen_string_literal: true

require 'rest_my_case/context/http_status'

module RestMyCase
  module HttpStatus
    include Status

    module ClassMethods
      def trial_court
        @trial_court ||= Trial::Court.new \
          Judge::Base, DefenseAttorney::Base, Base, Context::HttpStatus
      end
    end

    def self.included(parent_class)
      parent_class.extend ClassMethods
    end
  end
end
