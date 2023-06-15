# frozen_string_literal: true
require "active_record"

module Examples
  module Googledrive
    class Organization < ActiveRecord::Base
      has_many :users
      has_many :folders
    end
  end
end
