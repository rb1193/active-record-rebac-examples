# frozen_string_literal: true

class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.belongs_to :user, foreign_key: true
      t.belongs_to :folder, foreign_key: true
      t.timestamps
    end
  end
end

