module HierarchyValidation

  class Father < RestMyCase::Validator

    target :post

    validates_presence_of :title, if: ->(post) { !post.ignore_title }

  end

  class Son < Father

    validates_presence_of :body

  end

  class GrandSon < Son

    target :posts

  end

end
