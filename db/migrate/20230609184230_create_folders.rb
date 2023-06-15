# frozen_string_literal: true

class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.belongs_to :user, foreign_key: true
      t.belongs_to :organization, foreign_key: true
      t.references :parent, foreign_key: { to_table: :folders }
      t.timestamps
    end
  end
end

