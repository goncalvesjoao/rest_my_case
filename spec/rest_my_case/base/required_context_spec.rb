require 'spec_helper'

describe RestMyCase::Base do

  describe ".required_context" do

    context "When #setup odly populates the required field" do
      before { @context = RequiredContext::Users::GetCurrentUser.perform }

      it "context should be ok" do
        expect(@context.ok?).to be true
      end

      it "use_case instance should have a delegating method to that required_context" do
        use_case = RequiredContext::Users::GetCurrentUser.new({})
        expect(use_case).to respond_to(:current_user)
      end
    end

    context "When the required_context of a class fails, its dependencies shouldn't run" do
      before { @context = RequiredContext::Users::Create.perform }

      it "context dependencies should not have ran" do
        expect(@context.current_user).to be nil
      end
    end

    context "When dependencies also have a required_context" do
      before { @context = RequiredContext::Posts::Update.perform }

      it "context should NOT be ok" do
        expect(@context.ok?).to be false
      end

      it "context errors should only include the first context_errors" do
        expect(@context.errors.length).to be 1
        expect(@context.errors[0][:context_errors][:id]).to be_truthy
      end
    end

    context "When the required_context of a class fails and one of the dependencies aborts first" do
      before { @context = RequiredContext::Comments::Update.perform }

      it "required_context should not have ran" do
        expect(@context.errors.length).to be 1
      end
    end

  end

end
