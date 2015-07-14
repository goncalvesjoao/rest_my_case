require 'spec_helper'

describe RestMyCase::AccusationAttorneys::Base do

  describe '#validate' do
    context "given that the child class hasn't implemented the validate method" do
      TestCase4 = Class.new(described_class)

      before { @instance = TestCase4.new({ attributes: { id: '1' } }) }

      it 'should raise an error' do
        expect { @instance.validate(nil) }.to raise_error
      end
    end
  end

end
