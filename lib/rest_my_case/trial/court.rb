module RestMyCase
  module Trial

    Court = Struct.new(:judge_class, :defense_attorney_class, :last_ancestor) do

      def execute(use_case_classes, attributes = {})
        trial_case = Case.new(last_ancestor, use_case_classes, attributes)

        defense_attorney_class.new(trial_case).build_case_for_the_defendant

        judge_class.new(trial_case).determine_the_sentence

        trial_case
      end

    end

  end
end
