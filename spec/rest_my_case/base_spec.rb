require 'spec_helper'

describe RestMyCase::Base do

  module RestMyCaseBase
    class LogEvents < RestMyCase::Base; end
    class AnalyseEvents < RestMyCase::Base; end
    class BuildPost < RestMyCase::Base; end
    class SavePost < RestMyCase::Base; end
    class BuildComments < RestMyCase::Base; end
    class SaveComments < RestMyCase::Base; end

    class UseCaseWrapper < RestMyCase::Base
      context_writer    :id
      context_reader    :session
      context_accessor  :comment
      depends LogEvents, AnalyseEvents
    end
    class CreatePost < UseCaseWrapper
      depends BuildPost, SavePost
    end
    class CreatePostWithComments < CreatePost
      depends BuildComments, SaveComments
    end
  end

  describe ".dependencies" do
    it " should only list the class's dependencies" do
      expect(RestMyCaseBase::CreatePostWithComments.dependencies).to \
        eq [RestMyCaseBase::BuildComments, RestMyCaseBase::SaveComments]
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

end
