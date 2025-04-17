# frozen_string_literal: true

class Comment < ConversationItem
  has_rich_text :content
  has_many_attached :attachments

  validates :content, presence: true
end
