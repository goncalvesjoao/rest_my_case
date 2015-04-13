require_relative 'one_more_dependency'

module SendEmail

  class UseCase < RestMyCase::Base

    depends OneMoreDependency

  end

end
