# frozen_string_literal: true

class CreateProjectMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :project_memberships do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, default: "member", null: false

      t.timestamps

      t.index %i[project_id user_id]
    end
  end
end
