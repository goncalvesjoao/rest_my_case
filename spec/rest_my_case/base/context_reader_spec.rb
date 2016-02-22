require 'spec_helper'

describe RestMyCase::Base do

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

end
