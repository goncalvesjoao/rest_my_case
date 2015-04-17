class RubyPost

  attr_accessor :title, :body, :phone_number

  def initialize(attributes = {})
    (attributes || {}).each { |name, value| send("#{name}=", value) }
  end

end
