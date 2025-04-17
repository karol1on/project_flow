# frozen_string_literal: true

class ConversationItem < ApplicationRecord
  belongs_to :project
  belongs_to :user

  scope :chronological, -> { order(created_at: :desc) }
end
