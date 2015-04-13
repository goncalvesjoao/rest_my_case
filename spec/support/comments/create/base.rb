require_relative '../use_case'
require_relative 'build_comment'
require_relative 'send_email'
require_relative '../save_comment'

module Comments
  module Create

    class Base < UseCase

      depends BuildComment,
              SaveComment,
              SendEmail

    end

  end
end
