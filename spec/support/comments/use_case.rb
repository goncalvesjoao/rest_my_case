module Comments

  class UseCase < RestMyCase::Base

    context_writer    :id
    context_reader    :session
    context_accessor  :comment

  end

end
