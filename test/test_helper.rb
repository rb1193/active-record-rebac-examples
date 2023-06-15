# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "examples"
require "minitest/autorun"
require "yaml"
require "active_record"
require "active_record_extended"

ActiveRecord::Base.logger = Logger.new(STDOUT)