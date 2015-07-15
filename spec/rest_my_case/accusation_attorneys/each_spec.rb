require 'spec_helper'

describe RestMyCase::AccusationAttorneys::Each do

  describe '#validate_each' do
    context "given that the child class hasn't implemented the validate_each method" do
      AccusationAttorneysTestCase2 = Class.new(described_class)

      before { @instance = AccusationAttorneysTestCase2.new({ attributes: { id: '1' } }) }

      it 'should raise an error' do
        expect { @instance.validate_each(nil, nil, nil) }.to raise_error
      end
    end
  end

end
