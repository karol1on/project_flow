# frozen_string_literal: true

class User < ApplicationRecord
  ROLES = %w[admin member].freeze

  devise :database_authenticatable, :registerable, :rememberable, :validatable

  has_many :project_memberships, dependent: :destroy
  has_many :projects, through: :project_memberships
  has_many :conversation_items, dependent: :destroy

  def admin? = role == "admin"

  def project_role(project)
    project_memberships.find_by(project:)&.role
  end

  def project_manager?(project)
    admin? || project_role(project) == "manager"
  end

  def project_member?(project)
    admin? || project_memberships.exists?(project:)
  end
end
