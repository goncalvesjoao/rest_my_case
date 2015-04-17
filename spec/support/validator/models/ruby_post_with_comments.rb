class RubyPostWithComments

  class RubyComment

    attr_accessor :title, :email, :post_id

    def initialize(attributes = {})
      (attributes || {}).each { |name, value| send("#{name}=", value) }
    end

  end


  attr_reader :comments

  def initialize(comments = {})
    @comments = comments.map { |comment| RubyComment.new(comment) }
    @comments = [] if @comments.nil?
  end

  def first_two_comments
    [
      comments[0],
      comments[1]
    ]
  end

end
