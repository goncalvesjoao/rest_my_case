require 'spec_helper'

describe RestMyCase::Base do

  describe ".perform" do

    context "When something that doesn't responds to #to_hash is passed down" do

      it "should raise an exception" do
        expect { Perform::CreatePost.perform(Object.new) }.to \
          raise_error(ArgumentError)
      end

    end

    context "When nil is passed down" do

      it "should NOT raise an exception" do
        expect { Perform::CreatePost.perform(nil) }.not_to raise_error
      end

    end

    context "When nothing is passed down" do

      it "should NOT raise an exception" do
        expect { Perform::CreatePost.perform }.not_to raise_error
      end

    end

    context "When a use case calls #error during the setup process" do
      before do
        @context = Perform::CreatePost.perform \
          error: ['Perform::ValidateName_setup', 'Perform::ValidateBody_setup']
      end

      it "context should reflect an invalid state" do
        expect(@context.valid?).to be false
      end

      it "context should contain only one error" do
        expect(@context.errors).to match a_hash_including({ message: '', class_name: "Perform::ValidateName" })
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 4
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 12
      end
    end

    context "When a use case calls #error! during the setup process" do
      before do
        @context = Perform::CreatePost.perform \
          error_bang: ['Perform::ValidateName_setup']
      end

      it "context should reflect an invalid state" do
        expect(@context.valid?).to be false
      end

      it "context should contain only one error" do
        expect(@context.errors).to match a_hash_including({ message: '', class_name: "Perform::ValidateName" })
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 3
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 12
      end
    end

    context "When a use case calls #abort! during the setup process" do
      before do
        @context = Perform::CreatePost.perform \
          abort_bang: ['Perform::ValidateName_setup']
      end

      it "context should reflect an valid state" do
        expect(@context.valid?).to be true
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 3
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 12
      end
    end

    context "When a use case calls #abort! during the perform process" do
      before do
        @context = Perform::CreatePost.perform \
          abort_bang: ['Perform::ValidateName_perform']
      end

      it "context should reflect an valid state" do
        expect(@context.valid?).to be true
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 12
        expect(@context.perform.length).to be 3
        expect(@context.rollback.length).to be 4
        expect(@context.final.length).to be 12
      end
    end

    context "When a use case calls #skip during the setup process" do
      before do
        @context = Perform::CreatePost.perform \
          skip: ['Perform::ValidateBody_setup']
      end

      it "context should reflect an valid state" do
        expect(@context.valid?).to be true
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 12
        expect(@context.perform.length).to be 11
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 12
      end
    end

    context "When a use case calls #skip! during the setup process" do

      before do
        @context = Perform::CreatePost.perform \
          skip_bang: ['Perform::ValidateBody_setup']
      end

      it "context should reflect an valid state" do
        expect(@context.valid?).to be true
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 11
        expect(@context.perform.length).to be 11
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 12
      end

    end

    context "When dependent use_case has silence_dependencies_abort = true" do

      before  { Perform::Validations.silence_dependencies_abort = true }
      after   { Perform::Validations.silence_dependencies_abort = nil }

      context "When a use case calls #error during the setup process" do
        before do
          @context = Perform::CreatePost.perform \
            error: ['Perform::ValidateName_setup', 'Perform::ValidateBody_setup']
        end

        it "context should reflect an invalid state" do
          expect(@context.valid?).to be false
        end

        it "context should contain only 2 errors" do
          expect(@context.errors).to match a_hash_including({ message: '', class_name: "Perform::ValidateName"}, { message: '', class_name: "Perform::ValidateBody" })
        end

        it "context prove that only the correct method have ran" do
          expect(@context.setup.length).to be 8
          expect(@context.perform.length).to be 0
          expect(@context.rollback.length).to be 0
          expect(@context.final.length).to be 12
        end

      end

      context "When a use case calls #error during the perform process" do

        before do
          @context = Perform::CreatePost.perform \
            error: ['Perform::ValidateName_perform', 'Perform::ValidateBody_perform']
        end

        it "context should reflect an invalid state" do
          expect(@context.valid?).to be false
        end

        it "context should contain only 2 errors" do
          expect(@context.errors).to match a_hash_including({ message: '', class_name: "Perform::ValidateName" }, { message: '', class_name: "Perform::ValidateBody" })
        end

        it "context prove that only the correct method have ran" do
          expect(@context.setup.length).to be 12
          expect(@context.perform.length).to be 8
          expect(@context.rollback.length).to be 8
          expect(@context.final.length).to be 12
        end

      end

    end

    context "When general config has silence_dependencies_abort = true" do

      before do
        RestMyCase.configure do |config|
          config.silence_dependencies_abort = true
        end
      end
      after { RestMyCase.reset_config }

      context "When a use case calls #error during the perform process" do

        before do
          @context = Perform::CreatePost.perform \
            error: ['Perform::ValidateName_perform', 'Perform::ValidateBody_perform', 'Perform::BuildPost_perform', 'Perform::SavePost_perform']
        end

        it "context should reflect an invalid state" do
          expect(@context.valid?).to be false
        end

        it "context should contain only 4 errors" do
          expect(@context.errors).to match a_hash_including({ message: '', class_name: "Perform::BuildPost" }, { message: '', class_name: "Perform::ValidateName" }, { message: '', class_name: "Perform::ValidateBody" }, { message: '', class_name: "Perform::SavePost" })
        end

        it "context prove that only the correct method have ran" do
          expect(@context.setup.length).to be 12
          expect(@context.perform.length).to be 12
          expect(@context.rollback.length).to be 0
          expect(@context.final.length).to be 12
        end

      end

    end

  end

end
