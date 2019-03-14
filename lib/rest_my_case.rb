# frozen_string_literal: true

require 'ostruct'

require 'rest_my_case/version'
require 'rest_my_case/helpers'
require 'rest_my_case/errors/base'
require 'rest_my_case/config/base'
require 'rest_my_case/config/general'
require 'rest_my_case/defense_attorney/base'
require 'rest_my_case/context/base'
require 'rest_my_case/judge/base'
require 'rest_my_case/trial/case'
require 'rest_my_case/trial/court'

require 'rest_my_case/base'
require 'rest_my_case/status'
require 'rest_my_case/http_status'
require 'rest_my_case/validator'

module RestMyCase
  def self.configure
    yield config
  end

  def self.config
    @config ||= Config::General.new
  end

  def self.reset_config
    @config = Config::General.new
  end

  def self.get_config(attribute, use_case)
    config.get(attribute, use_case)
  end
end
