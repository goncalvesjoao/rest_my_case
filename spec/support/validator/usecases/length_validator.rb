class LengthValidator < RestMyCase::Validator

  target :user

  validates_length_of :first_name, maximum: 5

  validates_length_of :last_name, maximum: 5, message: "less than 5 if you don't mind"

  validates_length_of :fax, in: 7..8, allow_nil: true

  validates_length_of :phone, in: 7..8, allow_blank: true

  validates_length_of :user_name, within: 6..7, too_long: 'pick a shorter name', too_short: 'pick a longer name'

  validates_length_of :zip_code, minimum: 5, too_short: 'please enter at least 5 characters'

  validates_length_of :smurf_leader, is: 4, message: "papa is spelled with 4 characters... don't play me."

end
