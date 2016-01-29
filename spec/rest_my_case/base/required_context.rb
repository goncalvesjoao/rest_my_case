require 'spec_helper'

describe RestMyCase::Base do

  describe ".required_context" do

    context "When the method is not used" do

      context "and NO params are passed down to .perform" do
        before { @context = RequiredContext::Base.perform }

        it "context should be ok" do
          expect(@context.ok?).to be true
        end
      end

      context "and params are passed down to .perform" do
        before { @context = RequiredContext::Base.perform({ post_attributes: { body: 'body' } }) }

        it "context should be ok" do
          expect(@context.ok?).to be true
        end
      end

    end

    context "When no context attributes are required" do

      before { @context = RequiredContext::Base.perform }

      it "context should be ok" do
        expect(@context.ok?).to be true
      end

    end

    context "When dependencies also have a required_context" do
    end

  end

end
