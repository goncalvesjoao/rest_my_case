require 'spec_helper'

describe RestMyCase::Context::Status::Base do

  describe '#status=' do

    let(:context) { described_class.new }

    it 'raises error' do
      expect do
        context.status = 'not_found'
      end.to raise_error
    end

  end
end
