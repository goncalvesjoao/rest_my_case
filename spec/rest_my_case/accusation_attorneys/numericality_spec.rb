require 'spec_helper'

describe RestMyCase::AccusationAttorneys::Numericality do

  describe "without options" do
    NumericalityValidator1 = Class.new(RestMyCase::Validator) do
      target :post

      validates_numericality_of :phone_number
    end

    context "given a resource with an integer phone_number" do
      before do
        @post = RubyPost.new(phone_number: 2)
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with a float phone_number" do
      before do
        @post = RubyPost.new(phone_number: 2.5)
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with a string phone_number but integer nonetheless" do
      before do
        @post = RubyPost.new(phone_number: "2")
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with a string phone_number but float nonetheless" do
      before do
        @post = RubyPost.new(phone_number: "2.5")
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with a string phone_number but not numeric" do
      before do
        @post = RubyPost.new(phone_number: "2.s")
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have an error' do
        expect(@post.errors.include?(:phone_number)).to be true
      end
    end
  end

  describe "only_integer" do
    NumericalityValidator2 = Class.new(RestMyCase::Validator) do
      target :post

      validates_numericality_of :phone_number, only_integer: true
    end

    context "given a resource with an integer phone_number" do
      before do
        @post = RubyPost.new(phone_number: 2)
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with a float phone_number" do
      before do
        @post = RubyPost.new(phone_number: 2.5)
        @context = NumericalityValidator2.perform(post: @post)
      end

      it '@post should have an error' do
        expect(@post.errors.include?(:phone_number)).to be true
      end
    end

    context "given a resource with a string phone_number but float nonetheless" do
      before do
        @post = RubyPost.new(phone_number: "2.5")
        @context = NumericalityValidator2.perform(post: @post)
      end

      it '@post should have an error' do
        expect(@post.errors.include?(:phone_number)).to be true
      end
    end

    context "given a resource with a string phone_number but not numeric" do
      before do
        @post = RubyPost.new(phone_number: "2.s")
        @context = NumericalityValidator1.perform(post: @post)
      end

      it '@post should have an error' do
        expect(@post.errors.include?(:phone_number)).to be true
      end
    end
  end

end