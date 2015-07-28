class RubyPostWithComments

  class RubyComment

    attr_accessor :title

    def initialize(attributes = {})
      (attributes || {}).each { |name, value| send("#{name}=", value) }
    end

  end

  attr_reader :comments

  def initialize(comments = [])
    @comments = comments.map { |comment| RubyComment.new(comment) }
  end

end
