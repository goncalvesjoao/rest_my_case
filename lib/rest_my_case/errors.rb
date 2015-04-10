module RestMyCase
  module Errors

    class Base < StandardError; end

    class Skip < Base; end

    class Abort < Base; end

  end
end
