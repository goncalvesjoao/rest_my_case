require 'spec_helper'

describe RestMyCase::Judges::Base do

  describe "#build_use_cases_for_the_defendant" do

    # context "When a use case depends on other use cases" do
    #   before { @result = defense_attorney.build_use_cases_for_the_defendant }
    #   let(:attributes) { { id: 1, comment: 'my comment', session: -1 } }
    #   let(:defense_attorney) do
    #     RestMyCase::DefenseAttorney.new(Comments::Create::Base, attributes)
    #   end

    #   it "Should instanciate 3 objects" do
    #     expect(@result.length).to be 3
    #   end

    #   it "dass" do
    #     expect(@result[0]).to be_a Comments::Create::BuildComment
    #     expect(@result[1]).to be_a Comments::SaveComment
    #     expect(@result[2]).to be_a Comments::Create::SendEmail
    #   end

    # end

  end

end
