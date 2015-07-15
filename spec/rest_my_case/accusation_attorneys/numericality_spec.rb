require 'spec_helper'

describe RestMyCase::AccusationAttorneys::Numericality do

  describe "without options" do
    context "given a resource with an integer phone" do
      before do
        @user = RubyUser.new(phone: 2, fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have no errors' do
        expect(@user.errors.empty?).to be true
      end
    end

    context "given a fax smaller than a phone" do
      before do
        @user = RubyUser.new(phone: 10, fax: 2, validate_fax: true)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have a fax error' do
        expect(@user.errors.count).to be 3
        expect(@user.errors.messages).to match a_hash_including({:phone=>["should be less than fax"], :fax=>["should be greater than phone", "should be odd"]})
      end
    end

    context "given a resource with a float phone" do
      before do
        @user = RubyUser.new(phone: 2.5, fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have no errors' do
        expect(@user.errors.empty?).to be true
      end
    end

    context "given a resource with a string phone but integer nonetheless" do
      before do
        @user = RubyUser.new(phone: "2", fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have no errors' do
        expect(@user.errors.empty?).to be true
      end
    end

    context "given a resource with a string phone but float nonetheless" do
      before do
        @user = RubyUser.new(phone: "2.5", fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have no errors' do
        expect(@user.errors.empty?).to be true
      end
    end

    context "given a resource with a string phone but not numeric" do
      before do
        @user = RubyUser.new(phone: "2.s", fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have an error' do
        expect(@user.errors.include?(:phone)).to be true
      end
    end
  end

  describe "only_integer" do
    NumericalityValidator2 = Class.new(RestMyCase::Validator) do
      target :user

      validates_numericality_of :phone, only_integer: true
    end

    context "given a resource with an integer phone" do
      before do
        @user = RubyUser.new(phone: 2, fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have no errors' do
        expect(@user.errors.empty?).to be true
      end
    end

    context "given a resource with a float phone" do
      before do
        @user = RubyUser.new(phone: 2.5, fax: 11)
        @context = NumericalityValidator2.perform(user: @user)
      end

      it '@user should have an error' do
        expect(@user.errors.include?(:phone)).to be true
      end
    end

    context "given a resource with a string phone but float nonetheless" do
      before do
        @user = RubyUser.new(phone: "2.5", fax: 11)
        @context = NumericalityValidator2.perform(user: @user)
      end

      it '@user should have an error' do
        expect(@user.errors.include?(:phone)).to be true
      end
    end

    context "given a resource with a string phone but not numeric" do
      before do
        @user = RubyUser.new(phone: "2.s", fax: 11)
        @context = NumericalityValidator.perform(user: @user)
      end

      it '@user should have an error' do
        expect(@user.errors.include?(:phone)).to be true
      end
    end
  end

end
