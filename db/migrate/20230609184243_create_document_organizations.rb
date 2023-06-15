# frozen_string_literal: true

class CreateDocumentOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :document_organizations do |t|
      t.string :role
      t.belongs_to :document, foreign_key: true
      t.belongs_to :organization, foreign_key: true
      t.timestamps
    end
  end
end

