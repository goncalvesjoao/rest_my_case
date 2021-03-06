require 'spec_helper'

describe RestMyCase::Trial::Court do

  context "When using Judge::Base and DefenseAttorney::Base" do
    before do
      @use_case_class = Class.new(RestMyCase::Base)
      @trial_court = described_class.new \
        RestMyCase::Judge::Base, RestMyCase::DefenseAttorney::Base, RestMyCase::Base, RestMyCase::Context::Base
    end

    context "When something that responds to #to_hash is passed down" do

      let(:context) { @trial_court.execute([@use_case_class], id: 1, name: '2').context }

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
