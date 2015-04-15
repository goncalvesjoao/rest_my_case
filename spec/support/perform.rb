module Perform

  class UseCaseWrapper < RestMyCase::Base
    def flow_control(method)
      id = "#{self.class.name}_#{method}"

      context.fail        ||= []
      context.fail_bang   ||= []
      context.skip        ||= []
      context.skip_bang   ||= []
      context.abort       ||= []
      context.abort_bang  ||= []
      context.setup       ||= []
      context.perform     ||= []
      context.rollback    ||= []
      context.final       ||= []

      fail    if context.fail.include? id
      fail!   if context.fail_bang.include? id
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
