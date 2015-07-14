require 'spec_helper'

describe RestMyCase::Context::Status::Status do

  describe '#method_missing' do
    context "given that no method was previously called" do
      before { @status = described_class.new }

      it 'calling an unknown_method should raise an error' do
        expect { @status.unknown_method }.to raise_error
      end

      it '#ok? should be true' do
        expect(@status.ok?).to be true
      end
    end
  end

  describe '#to_s' do
    context "given that .not_found! was called" do
      before do
        @status = described_class.new
        @status.not_found!
      end

      it "should return 'not_found'" do
        expect(@status.to_s).to eq "not_found"
      end
    end
  end

  describe '#==' do
    context "given that .unauthorized! was called" do
      before do
        @status = described_class.new
        @status.unauthorized!
      end

      it "comparing to 'unauthorized' should return true" do
        expect(@status == 'unauthorized').to be true
      end
    end
  end

end
