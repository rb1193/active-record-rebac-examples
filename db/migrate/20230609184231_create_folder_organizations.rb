# frozen_string_literal: true

class CreateFolderOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_organizations do |t|
      t.string :role
      t.belongs_to :folder, foreign_key: true
      t.belongs_to :organization, foreign_key: true
      t.timestamps
    end
  end
end

