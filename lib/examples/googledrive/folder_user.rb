# frozen_string_literal: true
require "active_record"

module Examples
  module Googledrive
    class FolderUser < ActiveRecord::Base
      belongs_to :user
      belongs_to :folder
    end
  end
end
