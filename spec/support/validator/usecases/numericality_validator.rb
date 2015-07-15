class NumericalityValidator < RestMyCase::Validator

  target :user

  validates_numericality_of :phone

  validates_numericality_of :phone, less_than: ->(user) { user.fax }, message: 'should be less than fax'

  validates_numericality_of :fax, greater_than: :phone, message: 'should be greater than phone', if: ->(user) { user.validate_fax }

  validates_numericality_of :fax, odd: true, message: 'should be odd'

end
