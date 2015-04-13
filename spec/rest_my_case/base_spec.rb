require 'spec_helper'

describe RestMyCase::Base do

  context "When a use case depends on other use cases" do

    it ".dependencies should list the class's dependencies" do
      expect(Posts::Create::Base.dependencies).to \
        eq [Posts::Create::BuildPost, Posts::SavePost]
    end

  end

  context "When a use case inherits from another that also has its own dependencies" do

    it ".dependencies should only list the class's dependencies" do
      expect(Comments::Create::SendEmail.dependencies).to eq [Comments::FindOne]
    end

  end

  describe ".context_accessor" do

    let(:context)   { RestMyCase::Context.new(id: 1, comment: 'my comment', session: -1) }
    let(:use_case)  { Comments::FindOne.new(context) }

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

    let(:use_case) { Comments::FindOne.new(RestMyCase::Context.new) }

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
    let(:use_case)  { Comments::FindOne.new(context) }

    it "Should create getters targeting to context" do
      expect(use_case.respond_to?(:session)).to be true
      expect(use_case.respond_to?(:session=)).to be false
    end

    it "Getter should delegate to context" do
      expect(use_case.session).to eq context.session
    end

  end

end
