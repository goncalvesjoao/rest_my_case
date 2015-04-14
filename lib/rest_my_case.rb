require "rest_my_case/configuration/base"
require "rest_my_case/version"
require "rest_my_case/errors"
require "rest_my_case/base"

module RestMyCase

  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration::Base.new
  end

  def self.reset_config
    @config = Configuration::Base.new
  end

  def self.get_config(attribute, use_case)
    config.get(attribute, use_case)
  end

end
