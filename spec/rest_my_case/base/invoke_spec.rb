require 'spec_helper'

describe RestMyCase::Base do

  describe "#invoke" do

    class Perform::Invoker < Perform::UseCaseWrapper
      def perform
        super
        invoke Perform::BuildPost, Perform::Validations, Perform::SavePost

        context.should_be_true = true
      end
    end

    it "should invoke other use cases with the invoker's cloned context and they can't alter the invoker's context" do
      context = Perform::Invoker.perform

      expect(context.setup.length).to be 2
      expect(context.perform.length).to be 2
      expect(context.rollback.length).to be 0
      expect(context.final.length).to be 2

      expect(context.should_be_true).to be true
    end

  end

end
