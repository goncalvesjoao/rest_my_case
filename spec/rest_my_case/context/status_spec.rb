require 'spec_helper'

describe RestMyCase::Context::Status do

  describe '#status=' do
    let(:context) { described_class.new }

    it 'raises error' do
      expect do
        context.status = 'not_found'
      end.to raise_error('status is a reserved keyword which cannot be set')
    end
  end

  describe '#status' do
    before { @status = described_class.new.status }

    describe '#method_missing' do
      context "given that no method was previously called" do
        it 'calling an unknown_method should raise an error' do
          expect { @status.unknown_method }.to raise_error NoMethodError
        end

        it '#ok? should be true' do
          expect(@status.ok?).to be true
        end
      end
    end

    describe '#to_s' do
      context "given that .not_found! was called" do
        before { @status.not_found! }

        it "should return 'not_found'" do
          expect(@status.to_s).to eq "not_found"
        end
      end
    end

    describe '#==' do
      context "given that .unauthorized! was called" do
        before { @status.unauthorized! }

        it "comparing to 'unauthorized' should return true" do
          expect(@status == 'unauthorized').to be true
        end
      end
    end

  end

end
