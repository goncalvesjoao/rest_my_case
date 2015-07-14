require 'spec_helper'

describe RestMyCase::DefenseAttorney::Base do

  let(:use_cases) do
    trial_case = RestMyCase::Trial::Case.new(RestMyCase::Base, RestMyCase::Context::Base, use_case_classes, id: 1)

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

    let(:use_case_classes) { [DefenseAttorney::UseCaseWrapper] }

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::BuilEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::UseCaseWrapper
    ]

  end

  context "When a use case inherits from another that also has dependencies" do

    let(:use_case_classes) { [DefenseAttorney::CreatePostWithComments] }

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::BuildComments,
      DefenseAttorney::SaveComments,
      DefenseAttorney::CreateComments,
      DefenseAttorney::AssignAttributes,
      DefenseAttorney::BuildSomething,
      DefenseAttorney::BuildPost,
      DefenseAttorney::SavePost,
      DefenseAttorney::BuilEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::CreatePostWithComments
    ]

  end

  context "When general config has parent_dependencies_first = true" do

    before do
      RestMyCase.configure do |config|
        config.parent_dependencies_first = true
      end
    end
    after { RestMyCase.reset_config }

    context "When a use case inherits from another that also has dependencies" do

      let(:use_case_classes) { [DefenseAttorney::CreatePostWithComments] }

      it_behaves_like "a porper shepherd", [
        DefenseAttorney::BuilEvent,
        DefenseAttorney::SaveEvent,
        DefenseAttorney::CreateEvent,
        DefenseAttorney::LogEvents,
        DefenseAttorney::AnalyseEvents,
        DefenseAttorney::BuildSomething,
        DefenseAttorney::AssignAttributes,
        DefenseAttorney::BuildPost,
        DefenseAttorney::SavePost,
        DefenseAttorney::BuildComments,
        DefenseAttorney::SaveComments,
        DefenseAttorney::CreateComments,
        DefenseAttorney::CreatePostWithComments
      ]

    end

  end

  context "When dependent use_case has parent_dependencies_first = true" do

    before { DefenseAttorney::BuildPost.parent_dependencies_first = true }
    after  { DefenseAttorney::BuildPost.parent_dependencies_first = nil }

    context "When a use case inherits from another that also has dependencies" do

      let(:use_case_classes) { [DefenseAttorney::CreatePostWithComments] }

      it_behaves_like "a porper shepherd", [
        DefenseAttorney::BuildComments,
        DefenseAttorney::SaveComments,
        DefenseAttorney::CreateComments,
        DefenseAttorney::BuildSomething,
        DefenseAttorney::AssignAttributes,
        DefenseAttorney::BuildPost,
        DefenseAttorney::SavePost,
        DefenseAttorney::BuilEvent,
        DefenseAttorney::SaveEvent,
        DefenseAttorney::CreateEvent,
        DefenseAttorney::LogEvents,
        DefenseAttorney::AnalyseEvents,
        DefenseAttorney::CreatePostWithComments
      ]

    end

  end

end
