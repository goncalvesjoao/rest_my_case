require 'spec_helper'

describe RestMyCase::Base do

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

end
