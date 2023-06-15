# frozen_string_literal: true
require 'active_record'

module Examples
  module Googledrive
    class DocumentUser < ActiveRecord::Base
      belongs_to :user
      belongs_to :document
    end
  end
end
