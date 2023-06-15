# frozen_string_literal: true
require 'active_record'

module Examples
  module Googledrive
    class DocumentOrganization < ActiveRecord::Base
      belongs_to :organization
      belongs_to :document
    end
  end
end
