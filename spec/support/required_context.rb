module RequiredContext

  module Users
    class GetCurrentUser < RestMyCase::Base
      required_context [
        :current_user
      ]
      def setup
        context.current_user = Object.new
      end
    end
  end

  module Posts
    class FindOne < RestMyCase::Base
      required_context [
        :id
      ]

      def perform
        context.post = OpenStruct.new id: context.id
      end
    end

    class AssignAttributes < RestMyCase::Base
      required_context \
        :post,
        :post_attributes

      def perform
        context.post.assign_attributes context.post_attributes
      end
    end

    class Save < RestMyCase::Base
      required_context \
        :post

      def perform
        context.post.save
      end
    end

    class Update < RestMyCase::Base
      depends FindOne, AssignAttributes, Save
    end
  end

end
