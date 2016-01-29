require 'spec_helper'

describe RestMyCase::AccusationAttorneys::Format do

  describe "with options, 'with'" do
    FormatValidator1 = Class.new(RestMyCase::Validator) do
      target :post

      validates_format_of :body, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end

    context "given a resource with a valid body" do
      before do
        @post = RubyPost.new(body: 'email@gmail.com')
        @context = FormatValidator1.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with an invalid body" do
      before do
        @post = RubyPost.new(body: 'emailmail.com')
        @context = FormatValidator1.perform(post: @post)
      end

      it '@post should have an error' do
        expect(@post.errors.include?(:body)).to be true
      end
    end
  end

  describe "with options, 'without'" do
    FormatValidator2 = Class.new(RestMyCase::Validator) do
      target :post

      validates_format_of :body, without: /@/i
    end

    context "given a resource with a valid body" do
      before do
        @post = RubyPost.new(body: 'emailmailcom')
        @context = FormatValidator2.perform(post: @post)
      end

      it '@post should have no errors' do
        expect(@post.errors.empty?).to be true
      end
    end

    context "given a resource with an invalid body" do
      before do
        @post = RubyPost.new(body: 'email@gmailcom')
        @context = FormatValidator2.perform(post: @post)
      end

      it '@post should have an error' do
        expect(@post.errors.include?(:body)).to be true
      end
    end
  end

  describe "without options" do
    it 'should raise an error' do
      expect { Class.new(RestMyCase::Validator) { validates_format_of :body } }.to raise_error ArgumentError
    end
  end

end
