require 'spec_helper'

describe RestMyCase::DefenseAttorney do

  describe ".dependencies" do

    context "When a use case depends on other use cases" do

      let(:use_cases) do
        RestMyCase::DefenseAttorney.dependencies Posts::Create::Base
      end

      it "use_cases should be in the proper order" do
        expect(use_cases).to eq [Posts::Create::BuildPost, Posts::SavePost]
      end

    end

    context "When a use case depends on other use cases" do

      let(:use_cases) do
        RestMyCase::DefenseAttorney.dependencies Comments::Create::SendEmail
      end

      it "use_cases should be in the proper order" do
        expect(use_cases).to \
          eq [Comments::FindOne, SendEmail::ToAdmins, SendEmail::ToUser, SendEmail::OneMoreDependency]
      end

    end

  end

end
