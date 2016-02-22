require 'spec_helper'

describe RestMyCase::Base do

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

end
