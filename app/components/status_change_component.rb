# frozen_string_literal: true

class StatusChangeComponent < ViewComponent::Base
  include StatusHelper

  attr_reader :status_change

  def initialize(status_change:)
    @status_change = status_change
    super
  end
end
