# frozen_string_literal: true
require "active_record"

module Examples
  module Googledrive
    class User < ActiveRecord::Base
      belongs_to :organization
    end
  end
end
