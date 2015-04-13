module RestMyCase

  class Configuration

    attr_accessor :parent_dependencies_first

    def initialize
      @parent_dependencies_first = false
    end

  end

end
