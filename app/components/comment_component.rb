# frozen_string_literal: true

class CommentComponent < ViewComponent::Base
  include StatusHelper

  attr_reader :comment

  def initialize(comment:)
    @comment = comment
    super
  end
end
