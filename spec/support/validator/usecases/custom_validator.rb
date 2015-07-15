class CustomValidator < RestMyCase::Validator

  target :post

  validate :phone_number_country_code, if: :should_validate_country_code

  def phone_number_country_code(post)
    if post.phone_number.split(' ')[0] != '123'
      post.errors.add(:phone_number, 'invalid country code')

      return false
    end

    true
  end

  def should_validate_country_code(post)
    !context.should_not_validate_country_code
  end

end
