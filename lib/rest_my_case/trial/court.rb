module RestMyCase
  module Trial

    class Court < Struct.new(:judge_class, :defense_attorney_class)

      def execute(use_case_classes, attributes = {})
        trial_case = Case.new(use_case_classes, attributes)

        defense_attorney_class.new(trial_case).build_case_for_the_defendant

        judge_class.new(trial_case).determine_the_sentence

        trial_case.context
      end

    end

  end
end
