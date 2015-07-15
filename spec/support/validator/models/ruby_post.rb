class RubyPost

  attr_accessor :title, :body, :phone_number, :ignore_title, :_destroy

  def initialize(attributes = {})
    (attributes || {}).each { |name, value| send("#{name}=", value) }
  end

  def marked_for_destruction?
    _destroy
  end

end
