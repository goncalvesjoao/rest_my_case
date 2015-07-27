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
      expect(@context.errors).to a_hash_including({ message: "no target to validate!", class_name: "RestMyCase::Validator" })
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
        expect(@context.errors).to a_hash_including({ message: "unprocessable_entity" , class_name: "CustomValidator" })
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

    context "given a post with an invalid phone_number and a context preventing the validation from running" do
      before do
        @post = RubyPost.new(phone_number: 'asd')
        @context = CustomValidator.perform(post: @post, should_not_validate_country_code: true)
      end

      it "@context.ok? should be true" do
        expect(@context.ok?).to be true
      end
    end
  end

  context "Given a class that inherits from a class that has its own dependencies" do
    context "given an empty post" do
      before do
        @post = RubyPost.new
        @context = HierarchyValidation::Son.perform(post: @post)
      end

      it "HierarchyValidation::Son should be able to inherit Father's validations and alter them" do
        expect(@context.ok?).to be false
        expect(@post.errors.added?(:title, :blank)).to be true
        expect(@post.errors.added?(:body, :blank)).to be true
        expect(@post.errors.size).to be 2
      end
    end

    context "given an empty post and a context preventing the title validation" do
      before do
        @post = RubyPost.new(ignore_title: true)
        @context = HierarchyValidation::Son.perform(post: @post)
      end

      it "HierarchyValidation::Son should only show the body error" do
        expect(@context.ok?).to be false
        expect(@post.errors.added?(:title, :blank)).to be false
        expect(@post.errors.added?(:body, :blank)).to be true
        expect(@post.errors.size).to be 1
      end
    end
  end

  context "When passing an array with 2 resources" do

    context "and both of them are valid" do
      before do
        @post1 = RubyPost.new(title: 'title', body: 'body')
        @post2 = RubyPost.new(title: 'title', body: 'body')
        @context = HierarchyValidation::GrandSon.perform(posts: [@post1, @post2])
      end

      it "@context.ok? should be true" do
        expect(@context.ok?).to be true
      end

      it "@post1 should not cotain errors" do
        expect(@post1.errors.count).to be 0
      end

      it "@post2 should not cotain errors" do
        expect(@post2.errors.count).to be 0
      end
    end

    context "and one of them is invalid" do
      before do
        @post1 = RubyPost.new(title: 'title', body: 'body')
        @post2 = RubyPost.new(title: 'title')
        @context = HierarchyValidation::GrandSon.perform(posts: [@post1, @post2])
      end

      it "@context.ok? should be false" do
        expect(@context.ok?).to be false
      end

      it "@post1 should not cotain errors" do
        expect(@post1.errors.count).to be 0
      end

      it "@post2 should not cotain errors" do
        expect(@post2.errors.count).to be 1
        expect(@post2.errors.added?(:body, :blank)).to be true
      end
    end

    context "and both of them are invalid" do
      before do
        @post1 = RubyPost.new(body: 'body')
        @post2 = RubyPost.new(title: 'title')
        @context = HierarchyValidation::GrandSon.perform(posts: [@post1, @post2])
      end

      it "@context.ok? should be false" do
        expect(@context.ok?).to be false
      end

      it "@post1 should not cotain errors" do
        expect(@post1.errors.count).to be 1
        expect(@post1.errors.added?(:title, :blank)).to be true
      end

      it "@post2 should not cotain errors" do
        expect(@post2.errors.count).to be 1
        expect(@post2.errors.keys).to eq [:body]
      end
    end

    context "and both of them are invalid and one is marked_for_destruction" do
      before do
        @post1 = RubyPost.new(body: 'body', _destroy: true)
        @post2 = RubyPost.new(title: 'title')
        @context = HierarchyValidation::GrandSon.perform(posts: [@post1, @post2])
      end

      it "@context.ok? should be false" do
        expect(@context.ok?).to be false
      end

      it "@post1 should not cotain errors" do
        expect(@post1.errors.count).to be 0
      end

      it "@post2 should not cotain errors" do
        expect(@post2.errors.count).to be 1
        expect(@post2.errors.include?(:body)).to be true
      end
    end

    context "one is valid, the other isn't but is also marked_for_destruction" do
      before do
        @post1 = RubyPost.new(_destroy: true)
        @post2 = RubyPost.new(title: 'title', body: 'body')
        @context = HierarchyValidation::GrandSon.perform(posts: [@post1, @post2])
      end

      it "@context.ok? should be true" do
        expect(@context.ok?).to be true
      end

      it "@post1 should not cotain errors" do
        expect(@post1.errors.count).to be 0
      end

      it "@post2 should not cotain errors" do
        expect(@post2.errors.count).to be 0
      end
    end

    context "one is valid, the other isn't and both are marked_for_destruction" do
      before do
        @post1 = RubyPost.new(_destroy: true)
        @post2 = RubyPost.new(title: 'title', body: 'body', _destroy: true)
        @context = HierarchyValidation::GrandSon.perform(posts: [@post1, @post2])
      end

      it "@context.ok? should be true" do
        expect(@context.ok?).to be true
      end

      it "@post1 should not cotain errors" do
        expect(@post1.errors.count).to be 0
      end

      it "@post2 should not cotain errors" do
        expect(@post2.errors.count).to be 0
      end
    end

  end
end

