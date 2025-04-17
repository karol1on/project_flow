# frozen_string_literal: true

class StatusChangeForm
  include ActiveModel::Model

  attr_accessor :project_id, :user_id, :to_status, :status_change

  validates :project_id, :user_id, :to_status, presence: true

  def save
    return false unless valid?

    project = Project.find(project_id)
    status_change = StatusChange.new(
      project_id:,
      user_id:,
      from_status: project.status,
      to_status:
    )

    if status_change.save
      self.status_change = status_change
      true
    else
      false
    end
  end
end
