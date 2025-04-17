# frozen_string_literal: true

module Conversation
  class CreateComment
    include ServiceBase

    attr_reader :user, :project, :params

    def initialize(user:, project:, params:)
      @user = user
      @project = project
      @params = params
    end

    def call
      form = CommentForm.new(
        content: params[:content],
        project_id: project.id,
        user_id: user.id,
        attachments: params[:attachments]
      )

      if form.save
        broadcast_comment(form.comment)
        Success.new(form.comment)
      else
        Failure.new(form.comment, form.errors)
      end
    end

    private

    def broadcast_comment(comment)
      Turbo::StreamsChannel.broadcast_prepend_to(
        "project_#{project.id}_conversation",
        target: "conversation_items",
        partial: "conversation_items/item",
        locals: { item: comment }
      )
    end
  end
end
