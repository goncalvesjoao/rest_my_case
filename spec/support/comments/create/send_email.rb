require_relative '../find_one'

module Comments
  module Create

    class SendEmail < ::SendEmail::Base

      depends FindOne

    end

  end
end
