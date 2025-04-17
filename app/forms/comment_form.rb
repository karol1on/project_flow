# frozen_string_literal: true

class CommentForm
  include ActiveModel::Model

  attr_accessor :content, :project_id, :user_id, :attachments, :comment

  validates :content, :project_id, :user_id, presence: true

  def save
    return false unless valid?

    comment = Comment.new(
      content:,
      project_id:,
      user_id:,
      attachments:
    )

    if comment.save
      self.comment = comment
      true
    else
      false
    end
  end
end
