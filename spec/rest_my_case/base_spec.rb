require 'spec_helper'

describe RestMyCase::Base do

  context "When a use case depends on other use cases" do

    module Posts
      module Create
        class AssignAttributes < RestMyCase::Base; end
        class SavePost < RestMyCase::Base; end

        class Base < RestMyCase::Base
          depends AssignAttributes, SavePost
        end
      end
    end

    it ".dependencies and .local_dependencies should list those use cases" do
      dependencies = [Posts::Create::AssignAttributes, Posts::Create::SavePost]

      expect(Posts::Create::Base.dependencies).to eq dependencies
      expect(Posts::Create::Base.local_dependencies).to eq dependencies
    end

  end

  context "When a use case inherits from another that also has its own dependencies" do

    module SendEmail
      class ToAdmins < RestMyCase::Base; end
      class ToUser < RestMyCase::Base; end

      class Base < RestMyCase::Base
        depends ToAdmins, ToUser
      end
    end

    module Comments
      class FindComment < RestMyCase::Base; end

      class SendEmail < ::SendEmail::Base
        depends FindComment
      end
    end

    it ".local_dependencies should list only one use cases" do
      expect(Comments::SendEmail.local_dependencies).to eq [Comments::FindComment]
    end

    it ".dependencies should list 3 use cases" do
      expect(Comments::SendEmail.dependencies).to \
        eq [Comments::FindComment, SendEmail::ToAdmins, SendEmail::ToUser]
    end

  end

end
