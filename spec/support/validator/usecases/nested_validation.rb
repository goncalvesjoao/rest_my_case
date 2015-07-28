class NestedValidation < RestMyCase::Validator

  target :comments, in: :post

  validates_presence_of :title

end
