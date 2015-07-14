module RestMyCase
  module Context
    module Status

      class Matcher

        STATUS_SETTER_REGEX   = /\A[a-zA-Z](.*)!\z/
        STATUS_QUESTION_REGEX = /\A[a-zA-Z](.*)\?\z/

        def initialize(text)
          @text = text
        end

        def match_as_setter?
          !!(@text =~ STATUS_SETTER_REGEX)
        end

        def match_as_question?
          !!(@text =~ STATUS_QUESTION_REGEX)
        end

        def status
          @text[0...-1]
        end

      end

    end
  end
end
