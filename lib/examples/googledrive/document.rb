# frozen_string_literal: true
require "active_record"

module Examples
  module Googledrive
    class Document < ActiveRecord::Base
      belongs_to :folder
      belongs_to :owner, class_name: "User", foreign_key: "user_id"

      has_many :viewer_document_users, -> { where role: :viewer }, class_name: "DocumentUser", foreign_key: "document_id"
      has_many :viewers, class_name: "User", through: :viewer_document_users, source: :user

      has_many :editor_document_users, -> { where role: :editor }, class_name: "DocumentUser", foreign_key: "document_id"
      has_many :editors, class_name: "User", through: :editor_document_users, source: :user, disable_joins: true

      has_many :commenter_document_users, -> { where role: :commenter }, class_name: "DocumentUser", foreign_key: "document_id"
      has_many :commenters, class_name: "User", through: :commenter_document_users, source: :user

      has_many :editor_document_organization, -> { where role: :editor }, class_name: "DocumentOrganization", foreign_key: "document_id"
      has_many :editor_organizations, class_name: "Organization", through: :editor_document_organization, source: :organization
      has_many :editor_organization_users, class_name: "User", through: :editor_organizations, source: :users, disable_joins: true

      has_many :commenter_document_organization, -> { where role: :commenter }, class_name: "DocumentOrganization", foreign_key: "document_id"
      has_many :commenter_organizations, class_name: "Organization", through: :commenter_document_organization, source: :organization
      has_many :commenter_organization_users, class_name: "User", through: :commenter_organizations, source: :users, disable_joins: true

      has_many :viewer_document_organization, -> { where role: :viewer }, class_name: "DocumentOrganization", foreign_key: "document_id"
      has_many :viewer_organizations, class_name: "Organization", through: :viewer_document_organization, source: :organization
      has_many :viewer_organization_users, class_name: "User", through: :viewer_organizations, source: :users, disable_joins: true

      def relations(relation)
        {
          editor: -> { User.union_all(User.where(id: owner.id), editors, editor_organization_users, folder.relations(:editor)) },
          commenter: -> { User.union_all(commenters, commenter_organization_users, folder.relations(:commenter), relations(:editor)) },
          viewer: -> { User.union_all(viewers, viewer_organization_users, folder.relations(:viewer), relations(:commenter)) }
        }[relation].call
      end
    end
  end
end
