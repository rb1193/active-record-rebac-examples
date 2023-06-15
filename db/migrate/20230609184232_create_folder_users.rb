# frozen_string_literal: true

class CreateFolderUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_users do |t|
      t.string :role
      t.belongs_to :folder, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end

