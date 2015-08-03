module NestedValidation

  class Base < RestMyCase::Validator

    target :comments, in: :post

    validates_presence_of :title

  end

  class ValidatorSameMethod < RestMyCase::Validator

    target :comments, in: :post

    validates_presence_of :title

    def setup
      context._comments = comments
    end

    def comments
      @comments ||= [
        RubyPostWithComments::RubyComment.new({ title: 'first comment' }),
        RubyPostWithComments::RubyComment.new({ title: 'second comment' })
      ]
    end

  end

end
