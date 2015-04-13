require_relative 'fetch_admins'

module SendEmail

  class ToAdmins < RestMyCase::Base

    depends FetchAdmins

  end

end
