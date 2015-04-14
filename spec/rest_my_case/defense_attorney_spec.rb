require 'spec_helper'

describe RestMyCase::DefenseAttorney do

  module DefenseAttorney
    class BuilEvent < RestMyCase::Base; end
    class SaveEvent < RestMyCase::Base; end
    class CreateEvent < RestMyCase::Base
      depends SaveEvent
    end
    class LogEvents < RestMyCase::Base
      depends BuilEvent, CreateEvent
    end
    class AnalyseEvents < RestMyCase::Base; end
    class BuildPost < RestMyCase::Base; end
    class SavePost < RestMyCase::Base; end
    class BuildComments < RestMyCase::Base; end
    class SaveComments < RestMyCase::Base; end
    class CreateComments < RestMyCase::Base
      depends SaveComments
    end

    class UseCaseWrapper < RestMyCase::Base
      depends LogEvents, AnalyseEvents
    end
    class CreatePost < UseCaseWrapper
      depends BuildPost, SavePost
    end
    class CreatePostWithComments < CreatePost
      depends BuildComments, CreateComments
    end
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
    let(:use_cases) do
      described_class.build_trial_cases(DefenseAttorney::UseCaseWrapper, id: 1)
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
      described_class.build_trial_cases(DefenseAttorney::CreatePostWithComments, id: 1)
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
      described_class.build_trial_cases(DefenseAttorney::CreatePostWithComments, id: 1)
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
      described_class.build_trial_cases(DefenseAttorney::CreatePostWithComments, id: 1)
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
      described_class.build_trial_cases(DefenseAttorney::CreatePostWithComments, id: 1)
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

end
