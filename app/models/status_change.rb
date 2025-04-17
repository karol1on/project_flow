# frozen_string_literal: true

class StatusChange < ConversationItem
  validates :from_status, :to_status, presence: true
end
