class NumericalityValidator < RestMyCase::Validator

  target :user

  validates_numericality_of :phone

  # validates_numericality_of :phone, less_than: ->(user) { user.fax }

  # validates_numericality_of :width, greater_than: :minimum_weight

end
