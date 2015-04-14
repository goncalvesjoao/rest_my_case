require 'spec_helper'

describe RestMyCase::DefenseAttorney do

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
    let(:use_cases) do
      described_class.new(DefenseAttorney::UseCaseWrapper, id: 1).build_trial_case_for_the_defendant.use_cases
    end

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
    let(:use_cases) do
      described_class.new(DefenseAttorney::CreatePostWithComments, id: 1).build_trial_case_for_the_defendant.use_cases
    end

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

  context "When general configuration has parent_dependencies_first = false" do
    before do
      RestMyCase.configure do |config|
        config.parent_dependencies_first = false
      end
    end

    after { RestMyCase.reset_config }

    let(:use_cases) do
      described_class.new(DefenseAttorney::CreatePostWithComments, id: 1).build_trial_case_for_the_defendant.use_cases
    end

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::BuildComments,
      DefenseAttorney::SaveComments,
      DefenseAttorney::CreateComments,
      DefenseAttorney::CreatePostWithComments,

      DefenseAttorney::BuildPost,
      DefenseAttorney::SavePost,
      DefenseAttorney::CreatePost,

      DefenseAttorney::BuilEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::UseCaseWrapper
    ]
  end

  context "When general configuration has dependencies_first = false" do
    before do
      RestMyCase.configure do |config|
        config.dependencies_first = false
      end
    end

    after { RestMyCase.reset_config }

    let(:use_cases) do
      described_class.new(DefenseAttorney::CreatePostWithComments, id: 1).build_trial_case_for_the_defendant.use_cases
    end

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::UseCaseWrapper,
      DefenseAttorney::LogEvents,
      DefenseAttorney::BuilEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::CreatePost,
      DefenseAttorney::BuildPost,
      DefenseAttorney::SavePost,
      DefenseAttorney::CreatePostWithComments,
      DefenseAttorney::BuildComments,
      DefenseAttorney::CreateComments,
      DefenseAttorney::SaveComments
    ]
  end

  context "When an use case class configuration has dependencies_first = false" do
    before do
      DefenseAttorney::UseCaseWrapper.dependencies_first = false
    end

    after { DefenseAttorney::UseCaseWrapper.dependencies_first = nil }

    let(:use_cases) do
      described_class.new(DefenseAttorney::CreatePostWithComments, id: 1).build_trial_case_for_the_defendant.use_cases
    end

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::UseCaseWrapper,
      DefenseAttorney::BuilEvent,
      DefenseAttorney::SaveEvent,
      DefenseAttorney::CreateEvent,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents,
      DefenseAttorney::BuildPost,
      DefenseAttorney::SavePost,
      DefenseAttorney::CreatePost,
      DefenseAttorney::BuildComments,
      DefenseAttorney::SaveComments,
      DefenseAttorney::CreateComments,
      DefenseAttorney::CreatePostWithComments
    ]
  end

  context "When nil is used has attributes" do
    let(:defendant) { DefenseAttorney::CreatePostWithComments }

    it "should raise an exception" do
      expect { described_class.new(defendant, nil) }.to \
        raise_error(ArgumentError)
    end
  end

  context "When something that doesn't responde to #to_hash is used" do
    let(:defendant) { DefenseAttorney::CreatePostWithComments }

    it "should raise an exception" do
      expect { described_class.new(defendant, Object.new) }.to \
        raise_error(ArgumentError)
    end
  end

end
