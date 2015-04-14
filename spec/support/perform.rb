module Perform

  class ValidateName < RestMyCase::Base
    context_reader :name

    def setup
      fail('no name present!') if name.nil?

      context.setup << self.class.name
    end

    def perform
      context.perform << self.class.name
    end

    def rollback
      context.rollback << self.class.name
    end

    def final
      context.final << self.class.name
    end
  end

  class ValidateBody < RestMyCase::Base
    context_reader :body

    def setup
      fail('no body present!') if body.nil?

      context.setup << self.class.name
    end

    def perform
      context.perform << self.class.name
    end

    def rollback
      context.rollback << self.class.name
    end

    def final
      context.final << self.class.name
    end
  end

  class Validations < RestMyCase::Base
    depends ValidateName, ValidateBody

    def setup
      context.setup << self.class.name
    end

    def perform
      context.perform << self.class.name
    end

    def rollback
      context.rollback << self.class.name
    end

    def final
      context.final << self.class.name
    end
  end

  class BuildPost < RestMyCase::Base
    def setup
      context.setup = []
      context.perform = []
      context.rollback = []
      context.final = []

      context.setup << self.class.name
    end

    def perform
      context.perform << self.class.name
    end

    def rollback
      context.rollback << self.class.name
    end

    def final
      context.final << self.class.name
    end
  end

  class SavePost < RestMyCase::Base
    def setup
      context.setup << self.class.name
    end

    def perform
      context.perform << self.class.name
    end

    def rollback
      context.rollback << self.class.name
    end

    def final
      context.final << self.class.name
    end
  end

  class CreatePost < RestMyCase::Base
    depends BuildPost, Validations, SavePost

    def setup
      context.setup << self.class.name
    end

    def perform
      context.perform << self.class.name
    end

    def rollback
      context.rollback << self.class.name
    end

    def final
      context.final << self.class.name
    end
  end

end