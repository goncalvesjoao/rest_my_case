require 'spec_helper'

describe RestMyCase::Base do

  describe "#invoke!" do

    context "when the invokees don't abort" do

      class Perform::ScreammingInvoker < Perform::UseCaseWrapper
        def perform
          super
          invoke! Perform::BuildPost, Perform::Validations, Perform::SavePost
        end
      end

      it "should invoke other use cases with the invoker's context and actually alter it" do
        @context = Perform::ScreammingInvoker.perform

        expect(@context.setup).to eq [
          "Perform::Logger",
          "Perform::ScreammingInvoker",
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger",
          "Perform::ValidateName",
          "Perform::Logger",
          "Perform::ValidateBody",
          "Perform::Logger",
          "Perform::Validations",
          "Perform::Logger",
          "Perform::SavePost"
        ]
        expect(@context.perform).to eq [
          "Perform::Logger",
          "Perform::ScreammingInvoker",
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger",
          "Perform::ValidateName",
          "Perform::Logger",
          "Perform::ValidateBody",
          "Perform::Logger",
          "Perform::Validations",
          "Perform::Logger",
          "Perform::SavePost"
        ]
        expect(@context.rollback).to eq []
        expect(@context.final).to eq [
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger",
          "Perform::ValidateName",
          "Perform::Logger",
          "Perform::ValidateBody",
          "Perform::Logger",
          "Perform::Validations",
          "Perform::Logger",
          "Perform::SavePost",
          "Perform::Logger",
          "Perform::ScreammingInvoker"
        ]
      end

    end

    context "when the invokees abort" do

      class Perform::Validations2 < Perform::UseCaseWrapper
        def perform
          super

          invoke! Perform::ValidateName, Perform::ValidateBody

          context.should_not_be_true = true
        end
      end

      class Perform::CreatePost2 < Perform::UseCaseWrapper
        depends Perform::BuildPost, Perform::Validations2, Perform::SavePost
      end

      before do
        @context = Perform::CreatePost2.perform \
          error: ['Perform::ValidateName_perform', 'Perform::ValidateBody_perform']
      end

      it "invoker should abort the process it his invokees have also aborted" do
        expect(@context.setup).to eq [
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger",
          "Perform::Validations2",
          "Perform::Logger",
          "Perform::SavePost",
          "Perform::Logger",
          "Perform::CreatePost2",
          "Perform::Logger",
          "Perform::ValidateName",
          "Perform::Logger",
          "Perform::ValidateBody"
        ]
        expect(@context.perform).to eq [
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger",
          "Perform::Validations2",
          "Perform::Logger",
          "Perform::ValidateName"
        ]
        expect(@context.rollback).to eq [
          "Perform::ValidateName",
          "Perform::Logger",
          "Perform::Validations2",
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger"
        ]
        expect(@context.final).to eq [
          "Perform::Logger",
          "Perform::ValidateName",
          "Perform::Logger",
          "Perform::ValidateBody",
          "Perform::Logger",
          "Perform::BuildPost",
          "Perform::Logger",
          "Perform::Validations2",
          "Perform::Logger",
          "Perform::SavePost",
          "Perform::Logger",
          "Perform::CreatePost2"
        ]

        expect(@context.should_not_be_true).to be_falsey
      end

    end

  end

end
