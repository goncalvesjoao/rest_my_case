require_relative '../use_case'
require_relative 'build_post'
require_relative '../save_post'

module Posts
  module Create

    class Base < UseCase

      depends BuildPost,
              SavePost

    end

  end
end
