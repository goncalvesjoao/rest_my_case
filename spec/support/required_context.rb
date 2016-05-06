module RequiredContext

  module Users
    class GetCurrentUser < RestMyCase::Base
      required_context [
        :current_user
      ]
      def setup
        context.current_user = OpenStruct.new
      end
    end

    class BuildUser < RestMyCase::Base
      def perform
        context.current_user = OpenStruct.new context.current_user_attributes
      end
    end

    class Save < RestMyCase::Base
      def perform
        context.current_user.save
      end
    end

    class Create < RestMyCase::Base
      depends BuildUser, Save

      required_context \
        :current_user
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

  module Comments
    class FindOne < RestMyCase::Base
      def perform
        error!(:not_found)
      end
    end

    class AssignAttributes < RestMyCase::Base
      required_context :comment
    end

    class Save < RestMyCase::Base
      required_context :comment
    end

    class Update < RestMyCase::Base
      depends FindOne, AssignAttributes, Save
    end
  end

end
