require 'spec_helper'

describe RestMyCase::DefenseAttorney do

  module DefenseAttorney
    class LogEvents < RestMyCase::Base; end
    class AnalyseEvents < RestMyCase::Base; end
    class BuildPost < RestMyCase::Base; end
    class SavePost < RestMyCase::Base; end
    class BuildComments < RestMyCase::Base; end
    class SaveComments < RestMyCase::Base; end

    class UseCaseWrapper < RestMyCase::Base
      depends LogEvents, AnalyseEvents
    end
    class CreatePost < UseCaseWrapper
      depends BuildPost, SavePost
    end
    class CreatePostWithComments < CreatePost
      depends BuildComments, SaveComments
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
    let(:defendant) {  }
    let(:use_cases) do
      described_class.build_use_cases_for_the(DefenseAttorney::UseCaseWrapper, id: 1)
    end

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents
    ]
  end

  context "When a use case depends on other use cases" do
    let(:use_cases) do
      described_class.build_use_cases_for_the(DefenseAttorney::CreatePostWithComments, id: 1)
    end

    it_behaves_like "a porper shepherd", [
      DefenseAttorney::BuildComments,
      DefenseAttorney::SaveComments,
      DefenseAttorney::BuildPost,
      DefenseAttorney::SavePost,
      DefenseAttorney::LogEvents,
      DefenseAttorney::AnalyseEvents
    ]
  end

end
