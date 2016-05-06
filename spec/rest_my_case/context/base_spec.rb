require 'spec_helper'

describe RestMyCase::Context::Base do

  describe '#values_at' do
    let(:context) { described_class.new(one: 1, two: 2, three: 3) }

    context "no params are used" do
      it 'empty array should be returned' do
        expect(context.values_at).to eq []
      end
    end

    context "when all of the params are known" do
      it 'all of the values should be returned' do
        expect(context.values_at(:one, :two, :three)).to eq [1, 2, 3]
      end
    end

    context "when trying to extract less values then all of the known attributes" do
      it 'nil will be returned in the place of the unknown' do
        expect(context.values_at(:one, :two, :four)).to eq [1, 2, nil]
      end
    end

    context "when one of the params is not known" do
      it 'just the known values should be returned' do
        expect(context.values_at(:one, :two)).to eq [1, 2]
      end
    end
  end

end
