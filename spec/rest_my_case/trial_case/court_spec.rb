require 'spec_helper'

describe RestMyCase::Trial::Court do

  context "When using Judge::Base and DefenseAttorney::Base" do
    before { @trial_court = described_class.new RestMyCase::Judge::Base, RestMyCase::DefenseAttorney::Base }

    context "When something that doesn't responds to #to_hash is passed down" do

      it "should raise an exception" do
        expect { @trial_court.execute([Object], Object.new) }.to \
          raise_error(ArgumentError)
      end

    end

    context "When nil is passed down" do

      it "should NOT raise an exception" do
        expect { @trial_court.execute([Object], nil) }.not_to raise_error
      end

    end

    context "When nothing is passed down" do

      it "should NOT raise an exception" do
        expect { @trial_court.execute([Object]) }.not_to raise_error
      end

    end

    context "When something that responds to #to_hash is passed down" do

      let(:context) { @trial_court.execute([Object], id: 1, name: '2') }

      it "should create a context with it" do
        expect(context).to be_a RestMyCase::Context::Base
      end

      it "context should contain the attributes passed down" do
        expect(context.id).to be 1
        expect(context.name).to eq '2'
      end

    end

  end
end
