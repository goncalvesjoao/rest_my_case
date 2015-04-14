require 'spec_helper'

describe RestMyCase::TrialCase::Base do

  context "When something that doesn't responds to #to_hash is passed down" do
    it "should raise an exception" do
      expect { described_class.new(Object, Object.new) }.to \
        raise_error(ArgumentError)
    end
  end

  context "When nil is passed down" do
    it "should NOT raise an exception" do
      expect { described_class.new(Object, nil) }.not_to raise_error
    end
  end

  context "When nothing is passed down" do
    it "should NOT raise an exception" do
      expect { described_class.new(Object) }.not_to raise_error
    end
  end

  context "When something that responds to #to_hash is passed down" do
    let(:context) { described_class.new(Object, id: 1, name: '2').context }

    it "should create a context with it" do
      expect(context).to be_a RestMyCase::TrialCase::Context
    end

    it "context should contain the attributes passed down" do
      expect(context.id).to be 1
      expect(context.name).to eq '2'
    end
  end

end
