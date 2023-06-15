# frozen_string_literal: true
require 'active_record'

module Examples
  module Googledrive
    class Folder < ActiveRecord::Base
      belongs_to :organization
      belongs_to :user
      belongs_to :parent, class_name: "Folder", optional: true
      has_many :documents

      has_many :editor_folder_users, -> { where role: :editor }, class_name: "FolderUser", foreign_key: "folder_id"
      has_many :editors, class_name: "User", through: :editor_folder_users, source: :user, disable_joins: true

      has_many :commenter_folder_users, -> { where role: :commenter }, class_name: "FolderUser", foreign_key: "folder_id"
      has_many :commenters, class_name: "User", through: :commenter_folder_users, source: :user, disable_joins: true

      has_many :viewer_folder_users, -> { where role: :viewer }, class_name: "FolderUser", foreign_key: "folder_id"
      has_many :viewers, class_name: "User", through: :viewer_folder_users, source: :user, disable_joins: true

      def relations(relation)
        {
          editor: -> { User.union_all(User.where(id: user.id), editors, parent ? parent.relations(:editor) : User.none ) },
          commenter: -> { User.union_all(commenters, relations(:editor), parent ? parent.relations(:commenter) : User.none ) },
          viewer: -> { User.union_all(viewers, relations(:commenter), parent ? parent.relations(:viewer) : User.none ) }
        }[relation].call
      end
    end
  end
end
