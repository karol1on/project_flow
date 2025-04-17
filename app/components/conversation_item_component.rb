# frozen_string_literal: true

class ConversationItemComponent < ViewComponent::Base
  include StatusHelper

  with_collection_parameter :item

  def initialize(item:)
    @item = item
    super
  end

  private

  def component_class
    @item.is_a?(Comment) ? CommentComponent : StatusChangeComponent
  end
end
