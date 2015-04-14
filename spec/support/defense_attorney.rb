module DefenseAttorney

  class BuilEvent < RestMyCase::Base; end

  class SaveEvent < RestMyCase::Base; end

  class CreateEvent < RestMyCase::Base
    depends SaveEvent
  end

  class LogEvents < RestMyCase::Base
    depends BuilEvent, CreateEvent
  end

  class AnalyseEvents < RestMyCase::Base; end

  class BuildPost < RestMyCase::Base; end

  class SavePost < RestMyCase::Base; end

  class BuildComments < RestMyCase::Base; end

  class SaveComments < RestMyCase::Base; end

  class CreateComments < RestMyCase::Base
    depends SaveComments
  end

  class UseCaseWrapper < RestMyCase::Base
    depends LogEvents, AnalyseEvents
  end

  class CreatePost < UseCaseWrapper
    depends BuildPost, SavePost
  end

  class CreatePostWithComments < CreatePost
    depends BuildComments, CreateComments
  end

end
