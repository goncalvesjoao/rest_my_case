require 'spec_helper'

describe RestMyCase::DefenseAttorney::Base do

  let(:use_cases) do
    described_class.new(trial_case).build_case_for_the_defendant

    trial_case.use_cases
  end

  shared_examples "a porper shepherd" do |dependencies|
    it "use_cases should be in the proper order" do
      dependencies.each_with_index do |dependency, index|
        expect(use_cases[index]).to be_a dependency
      end
    end

    it "use_cases should share the same context" do
      use_cases.each do |use_case1|
        use_cases.each do |use_case2|
          expect(use_case1.context).to be use_case2.context
        end
      end
    end
  end

  context "When a use case depends on other use cases" do
    let(:trial_case) { RestMyCase::TrialCase::Base.new(DefenseAttorney::UseCaseWrapper, id: 1) }

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::BuilEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::UseCaseWrapper
    ]
  end

  context "When a use case inherits from another that also has its own dependencies" do
    let(:trial_case) { RestMyCase::TrialCase::Base.new DefenseAttorney::CreatePostWithComments, id: 1 }

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::BuilEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::UseCaseWrapper,
      DefenseAttorney::BuildPost,
      DefenseAttorney::SavePost,
      DefenseAttorney::CreatePost,
      DefenseAttorney::BuildComments,
      DefenseAttorney::SaveComments,
      DefenseAttorney::CreateComments,
      DefenseAttorney::CreatePostWithComments
    ]
  end

end
