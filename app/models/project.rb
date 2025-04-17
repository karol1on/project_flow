# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_memberships, dependent: :destroy
  has_many :members, through: :project_memberships, source: :user
  has_many :conversation_items, dependent: :destroy
  has_many :status_changes, dependent: :destroy

  enum :status, {
    not_started: 0,
    in_progress: 1,
    on_hold: 2,
    completed: 3,
    cancelled: 4
  }, validate: true

  validates :name, :status, presence: true

  def add_member(user, role: "member")
    project_memberships.create(user: user, role: role)
  end
end
