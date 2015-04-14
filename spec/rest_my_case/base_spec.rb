require 'spec_helper'

describe RestMyCase::Base do

  describe ".dependencies" do
    it " should only list the class's dependencies" do
      expect(RestMyCaseBase::CreatePostWithComments.dependencies).to \
        eq [RestMyCaseBase::BuildComments, RestMyCaseBase::CreateComments]
    end
  end

  describe ".context_accessor" do
    let(:context)   { RestMyCase::Context.new(id: 1, comment: 'my comment', session: -1) }
    let(:use_case)  { RestMyCaseBase::CreatePostWithComments.new(context) }

    it "Should create getters targeting to context" do
      expect(use_case.respond_to?(:comment)).to be true
    end

    it "Should create setters targeting to context" do
      expect(use_case.respond_to?(:comment=)).to be true
    end

    it "Getter should delegate to context" do
      expect(use_case.comment).to eq context.comment
    end

    it "Setter should delegate to context" do
      use_case.comment = 'your comment'
      expect(use_case.context.comment).to eq 'your comment'
    end
  end

  describe ".context_writer" do
    let(:use_case) { RestMyCaseBase::CreatePostWithComments.new(RestMyCase::Context.new) }

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
    let(:context)   { RestMyCase::Context.new(id: 1, comment: 'my comment', session: -1) }
    let(:use_case)  { RestMyCaseBase::CreatePostWithComments.new(context) }

    it "Should create getters targeting to context" do
      expect(use_case.respond_to?(:session)).to be true
      expect(use_case.respond_to?(:session=)).to be false
    end

    it "Getter should delegate to context" do
      expect(use_case.session).to eq context.session
    end
  end

  describe ".perform" do

    context "When a use case aborts during the setup process" do
      module SetupAbort
        class ValidateName < RestMyCase::Base
          def perform; fail('no name present!'); end
        end
        class ValidateBody < RestMyCase::Base
          def perform; fail('no body present!'); end
        end
        class Validations < RestMyCase::Base
          depends ValidateName, ValidateBody
        end
        class BuildPost < RestMyCase::Base; end
        class SavePost < RestMyCase::Base; end
        class CreatePost < RestMyCase::Base
          depends BuildPost, Validations, SavePost
        end
      end

      it "context should reflect an invalid state" do
        context = SetupAbort::CreatePost.perform

        expect(context.valid?).to be false
      end
    end

  end

end
