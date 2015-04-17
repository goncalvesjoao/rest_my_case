module HierarchyValidation

  class Father < RestMyCase::Validator::Base

    target :post

    validates_presence_of :title

  end

  class Son < Father

    validates_presence_of :email

  end

end