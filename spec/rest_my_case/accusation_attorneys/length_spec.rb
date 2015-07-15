require 'spec_helper'

describe RestMyCase::AccusationAttorneys::Length do

  describe "with options, 'with'" do
    context "given a blank user" do
      before do
        @user = RubyUser.new
        @context = LengthValidator.perform(user: @user)
      end

      it '@user should contain errors' do
        expect(@user.errors.messages).to match a_hash_including({:user_name=>["pick a longer name"], :zip_code=>["please enter at least 5 characters"], :smurf_leader=>["papa is spelled with 4 characters... don't play me."]})
      end
    end

    context "given a user with first_name and last_name > then 5 chars, fax = '', user_name > 7 chars, zip_code = 12345, smurf_leader = 'papas'" do
      before do
        @user = RubyUser.new(first_name: '123456', last_name: '123456', fax: '', phone: '', user_name: '12345678', zip_code: '12345', smurf_leader: 'papas')
        @context = LengthValidator.perform(user: @user)
      end

      it '@user should contain errors' do
        expect(@user.errors.messages).to match a_hash_including({:first_name=>[:too_long], :last_name=>["less than 5 if you don't mind"], :fax=>[:too_short], :user_name=>["pick a shorter name"], :smurf_leader=>["papa is spelled with 4 characters... don't play me."]})
      end

      context "change the user's attributes for valid ones, except the phone" do
        before do
          @user.errors.clear
          @user.first_name = @user.last_name = '12345'
          @user.fax = '12345678'
          @user.phone = '123456789'
          @user.user_name = '1234567'
          @user.smurf_leader = 'papa'
          @context = LengthValidator.perform(user: @user)
        end

        it '@user should contain errors' do
          expect(@user.errors.messages).to match a_hash_including({:phone=>[:too_long]})
        end
      end

    end
  end

end