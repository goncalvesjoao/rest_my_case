require 'spec_helper'

describe RestMyCase::Base do

  describe ".required_context" do

    context "When #setup odly populates the required field" do
      before { @context = RequiredContext::Users::GetCurrentUser.perform }

      it "context should be ok" do
        expect(@context.ok?).to be true
      end
    end

    context "When dependencies also have a required_context" do
      before { @context = RequiredContext::Posts::Update.perform }

      it "context should NOT be ok" do
        expect(@context.ok?).to be false
      end

      it "context errors should include 3 context_errors" do
        expect(@context.errors.length).to be 3
        expect(@context.errors[0][:context_errors][:id]).to be_truthy
        expect(@context.errors[1][:context_errors][:post]).to be_truthy
        expect(@context.errors[1][:context_errors][:post_attributes]).to be_truthy
        expect(@context.errors[2][:context_errors][:post]).to be_truthy
      end
    end

  end

end
