module RequiredContext

  class Base < RestMyCase::Base
  end

  class CreateUser < RestMyCase::Base

    # required_context \
    #   user_attributes: Compel.any

  end

  class CreatePost < RestMyCase::Base

    # required_context \
    #   current_user: Compel.any.required,
    #   post_attributes: Compel.any

  end

end
