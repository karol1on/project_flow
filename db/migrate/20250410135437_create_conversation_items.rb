# frozen_string_literal: true

class CreateConversationItems < ActiveRecord::Migration[8.0]
  def change
    create_table :conversation_items do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false

      t.string :from_status
      t.string :to_status

      t.timestamps

      t.index :type
    end
  end
end
