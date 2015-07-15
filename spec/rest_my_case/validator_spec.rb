require 'spec_helper'

describe RestMyCase::Validator do

  context "Given a validator with no target" do
    before do
      @context = RestMyCase::Validator.perform
    end

    it "@context.ok? should be false" do
      expect(@context.ok?).to be false
    end

    it "@context.errors should reflect the fact that no target is defined" do
      expect(@context.errors).to a_hash_including({"RestMyCase::Validator"=>["no target to validate!"]})
    end
  end

  context "Given a validator with a custom validation" do
    context "given a post with an invalid phone_number" do
      before do
        @post = RubyPost.new(phone_number: 'asd')
        @context = CustomValidator.perform(post: @post)
      end

      it "@context.ok? should be false" do
        expect(@context.ok?).to be false
      end

      it "@context.errors should include the unprocessable_entity error" do
        expect(@context.errors).to a_hash_including({"CustomValidator"=>["unprocessable_entity"]})
      end

      it "@post.errors should mention the bad phone_number error" do
        expect(@post.errors.added?(:phone_number, 'invalid country code')).to be true
      end
    end

    context "given a post with a valid phone_number" do
      before do
        @post = RubyPost.new(phone_number: '123 123')
        @context = CustomValidator.perform(post: @post)
      end

      it "@context.ok? should be true" do
        expect(@context.ok?).to be true
      end
    end
  end

  context "Given a class that inherits from a class that has its own dependencies" do
    before do
      @post = RubyPost.new
      @context = HierarchyValidation::Son.perform(post: @post)
    end

    it "HierarchyValidation::Son should be able to inherit Father's validations and alter them" do
      expect(@context.ok?).to be false
      expect(@post.errors.added?(:title, :blank)).to be true
      expect(@post.errors.added?(:email, :blank)).to be true
      expect(@post.errors.size).to be 2
    end
  end

end

