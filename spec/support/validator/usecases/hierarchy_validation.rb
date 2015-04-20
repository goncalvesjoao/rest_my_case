module HierarchyValidation

  class Father < RestMyCase::Validator

    target :post

    validates_presence_of :title

  end

  class Son < Father

    validates_presence_of :email

  end

end