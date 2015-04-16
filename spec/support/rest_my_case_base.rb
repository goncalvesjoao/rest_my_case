module RestMyCaseBase

  class BuildPost < RestMyCase::Base; end

  class ValidateName < RestMyCase::Base
    def perform; error('no name present!'); end
  end

  class ValidateBody < RestMyCase::Base
    def perform; error('no body present!'); end
  end

  class Validations < RestMyCase::Base
    depends ValidateName, ValidateBody

    self.silence_dependencies_abort = true
  end

  class SavePost < RestMyCase::Base; end

  class BuildComments < RestMyCase::Base; end

  class SaveComments < RestMyCase::Base; end

  class CreateComments < RestMyCase::Base
    depends SaveComments
  end

  class UseCaseWrapper < RestMyCase::Base
    context_writer    :id
    context_reader    :session
    context_accessor  :comment
  end

  class CreatePost < UseCaseWrapper
    depends BuildPost, SavePost
  end

  class CreatePostWithValidations < CreatePost
    depends Validations
  end

  class CreatePostWithComments < CreatePost
    depends BuildComments, CreateComments
  end

end
