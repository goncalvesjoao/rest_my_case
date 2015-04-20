module Perform

  class Test < RestMyCase::Base
    def flow_control(method)
      id = "#{self.class.name}_#{method}"

      context.error       ||= []
      context.error_bang  ||= []
      context.skip        ||= []
      context.skip_bang   ||= []
      context.abort       ||= []
      context.abort_bang  ||= []
      context.setup       ||= []
      context.perform     ||= []
      context.rollback    ||= []
      context.final       ||= []

      error   if context.error.include? id
      error!  if context.error_bang.include? id
      skip    if context.skip.include? id
      skip!   if context.skip_bang.include? id
      abort   if context.abort.include? id
      abort!  if context.abort_bang.include? id

      context.send(method) << self.class.name
    end

    def setup
      flow_control :setup
    end

    def perform
      flow_control :perform
    end

    def rollback
      flow_control :rollback
    end

    def final
      flow_control :final
    end
  end

  class Logger < Test; end

  class UseCaseWrapper < Test
    depends Logger
  end

  class ValidateName < UseCaseWrapper; end

  class ValidateBody < UseCaseWrapper; end

  class Validations < UseCaseWrapper
    depends ValidateName, ValidateBody
  end

  class BuildPost < UseCaseWrapper; end

  class SavePost < UseCaseWrapper; end

  class CreatePost < UseCaseWrapper
    depends BuildPost, Validations, SavePost
  end

end
