require_relative 'use_case'
require_relative 'to_admins'
require_relative 'to_user'

module SendEmail

  class Base < UseCase

    depends ToAdmins,
            ToUser

  end

end
