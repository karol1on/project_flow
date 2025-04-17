# frozen_string_literal: true

module Conversation
  class ChangeStatus
    include ServiceBase

    attr_reader :user, :project, :params

    def initialize(user:, project:, params:)
      @user = user
      @project = project
      @params = params
    end

    def call
      form = StatusChangeForm.new(
        project_id: project.id,
        user_id: user.id,
        to_status: params[:to_status]
      )

      ActiveRecord::Base.transaction do
        form.save
        project.update!(status: params[:to_status])
        broadcast_status_change(form.status_change)
        Success.new(form.status_change)
      end
    rescue ActiveRecord::RecordInvalid => e
      Failure.new(form.status_change, e.record.errors)
    end

    private

    def broadcast_status_change(status_change)
      Turbo::StreamsChannel.broadcast_update_to(
        "project_#{project.id}",
        target: "project_status_badge",
        partial: "projects/status_badge",
        locals: { project: }
      )

      Turbo::StreamsChannel.broadcast_prepend_to(
        "project_#{project.id}_conversation",
        target: "conversation_items",
        partial: "conversation_items/item",
        locals: { item: status_change }
      )
    end
  end
end
