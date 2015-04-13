require "rest_my_case/configuration"
require "rest_my_case/version"
require "rest_my_case/errors"
require "rest_my_case/base"

module RestMyCase

  def self.configure(&block)
    yield(Config)
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

end
