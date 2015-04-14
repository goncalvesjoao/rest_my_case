require 'spec_helper'

describe RestMyCase::Base do

  describe ".dependencies" do
    it " should only list the class's dependencies" do
      expect(RestMyCaseBase::CreatePostWithComments.dependencies).to \
        eq [RestMyCaseBase::BuildComments, RestMyCaseBase::CreateComments]
    end
  end

  describe ".context_accessor" do
    let(:context)   { RestMyCase::TrialCase::Context.new(id: 1, comment: 'my comment', session: -1) }
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
    let(:use_case) { RestMyCaseBase::CreatePostWithComments.new(RestMyCase::TrialCase::Context.new) }

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
    let(:context)   { RestMyCase::TrialCase::Context.new(id: 1, comment: 'my comment', session: -1) }
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

    context "When something that doesn't responde to #to_hash is used" do
      it "should raise an exception" do
        expect { RestMyCaseBase::CreatePost.perform(Object.new) }.to \
          raise_error(ArgumentError)
      end
    end

    context "When a use case #abort during the setup process" do
      before { @context = Perform::CreatePost.perform }

      it "context should reflect an invalid state" do
        expect(@context.valid?).to be false
      end

      it "context should contain only one error" do
        expect(@context.errors.keys.length).to be 1
      end

      it "context must not be populated by the #perform methods" do
        # binding.pry
        expect(@context.setup.length).to be 2
        expect(@context.perform.length).to be 0
        expect(@context.rollback.length).to be 2
        expect(@context.final.length).to be 6
      end
    end

  end

end
