class RubyUser

  attr_accessor :first_name, :last_name, :fax, :phone, :user_name, :zip_code, :smurf_leader, :validate_fax

  def initialize(attributes = {})
    (attributes || {}).each { |name, value| send("#{name}=", value) }
  end

end
