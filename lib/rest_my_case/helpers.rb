module RestMyCase

  module Helpers

    extend self

    def stringify_keys(attributes)
      attributes.to_hash
    end

  end

end
