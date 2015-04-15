require 'spec_helper'

describe RestMyCase::Base do

  describe ".dependencies" do

    it "should only list the class's dependencies" do
      expect(RestMyCaseBase::CreatePostWithComments.dependencies).to \
        eq [RestMyCaseBase::BuildComments, RestMyCaseBase::CreateComments]
    end

  end

  describe ".context_accessor" do

    let(:context)  { RestMyCase::Context::Base.new(id: 1, comment: 'my comment', session: -1) }
    let(:use_case) { RestMyCaseBase::CreatePostWithComments.new(context) }

    it "Should create getters targeting to context" do
      expect(use_case.respond_to?(:comment)).to be true
    end

    it "Should create setters targeting to context" do
      expect(use_case.respond_to?(:comment=)).to be true
    end

    it "Getter should delegate to context" do
      expect(use_case.comment).to eq 'my comment'
    end

    it "Setter should delegate to context" do
      use_case.comment = 'your comment'
      expect(use_case.context.comment).to eq 'your comment'
    end

  end

  describe ".context_writer" do

    let(:context)  { RestMyCase::Context::Base.new }
    let(:use_case) { RestMyCaseBase::CreatePostWithComments.new(context) }

    it "Should create setters targeting to context" do
      expect(use_case.respond_to?(:id)).to be false
      expect(use_case.respond_to?(:id=)).to be true
    end

    it "Setter should delegate to context" do
      use_case.id = 2

      expect(use_case.context.id).to eq 2
    end

  end

  describe ".context_reader" do

    let(:context)  { RestMyCase::Context::Base.new(id: 1, comment: 'my comment', session: -1) }
    let(:use_case) { RestMyCaseBase::CreatePostWithComments.new(context) }

    it "Should create getters targeting to context" do
      expect(use_case.respond_to?(:session)).to be true
      expect(use_case.respond_to?(:session=)).to be false
    end

    it "Getter should delegate to context" do
      expect(use_case.session).to eq -1
    end

  end

  describe ".perform" do

    context "When a use case calls #fail during the setup process" do
      before do
        @context = Perform::CreatePost.perform \
          fail: ['Perform::ValidateName_setup']
      end

      it "context should reflect an invalid state" do
        expect(@context.valid?).to be false
      end

      it "context should contain only one error" do
        expect(@context.errors.keys.length).to be 1
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 3
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 7
      end
    end

    context "When a use case calls #fail! during the setup process" do
      before do
        @context = Perform::CreatePost.perform \
          fail_bang: ['Perform::ValidateName_setup']
      end

      it "context should reflect an invalid state" do
        expect(@context.valid?).to be false
      end

      it "context should contain only one error" do
        expect(@context.errors.keys.length).to be 1
      end

      it "context prove that only the correct method have ran" do
        expect(@context.setup.length).to be 2
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 7
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
        expect(@context.setup.length).to be 2
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 7
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
        expect(@context.setup.length).to be 7
        expect(@context.perform.length).to be 2
        expect(@context.rollback.length).to be 3
        expect(@context.final.length).to be 7
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
        expect(@context.setup.length).to be 7
        expect(@context.perform.length).to be 6
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 7
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
        expect(@context.setup.length).to be 6
        expect(@context.perform.length).to be 6
        expect(@context.rollback.length).to be 0
        expect(@context.final.length).to be 7
      end

    end

    context "When dependent use_case has silence_dependencies_abort = true" do

      before  { Perform::Validations.silence_dependencies_abort = true }
      after   { Perform::Validations.silence_dependencies_abort = nil }

      context "When a use case calls #fail during the setup process" do
        before do
          @context = Perform::CreatePost.perform \
            fail: ['Perform::ValidateName_setup', 'Perform::ValidateBody_setup']
        end

        it "context should reflect an invalid state" do
          expect(@context.valid?).to be false
        end

        it "context should contain only 2 errors" do
          expect(@context.errors.keys.length).to be 2
        end

        it "context prove that only the correct method have ran" do
          expect(@context.setup.length).to be 5
          expect(@context.perform.length).to be 0
          expect(@context.rollback.length).to be 0
          expect(@context.final.length).to be 7
        end

      end

      context "When a use case calls #fail during the perform process" do

        before do
          @context = Perform::CreatePost.perform \
            fail: ['Perform::ValidateName_perform', 'Perform::ValidateBody_perform']
        end

        it "context should reflect an invalid state" do
          expect(@context.valid?).to be false
        end

        it "context should contain only 2 errors" do
          expect(@context.errors.keys.length).to be 2
        end

        it "context prove that only the correct method have ran" do
          expect(@context.setup.length).to be 7
          expect(@context.perform.length).to be 5
          expect(@context.rollback.length).to be 5
          expect(@context.final.length).to be 7
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

      context "When a use case calls #fail during the perform process" do

        before do
          @context = Perform::CreatePost.perform \
            fail: ['Perform::ValidateName_perform', 'Perform::ValidateBody_perform', 'Perform::BuildPost_perform', 'Perform::SavePost_perform']
        end

        it "context should reflect an invalid state" do
          expect(@context.valid?).to be false
        end

        it "context should contain only 4 errors" do
          expect(@context.errors.keys.length).to be 4
        end

        it "context prove that only the correct method have ran" do
          expect(@context.setup.length).to be 7
          expect(@context.perform.length).to be 7
          expect(@context.rollback.length).to be 7
          expect(@context.final.length).to be 7
        end

      end

    end

  end

end
