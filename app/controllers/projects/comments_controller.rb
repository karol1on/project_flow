# frozen_string_literal: true

module Projects
  class CommentsController < ApplicationController
    include ProjectAuthorization

    before_action :set_project
    before_action :authorize_project_member!

    def create
      result = Conversation::CreateComment.call(
        user: current_user,
        project: @project,
        params: comment_params
      )

      if result.success?
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update(
              "comment_form",
              partial: "projects/comment_form",
              locals: { project: @project, comment_form: CommentForm.new }
            )
          end
        end
      else
        render json: { errors: result.errors }, status: :unprocessable_entity
      end
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def comment_params
      params.require(:comment_form).permit(:content, attachments: [])
    end
  end
end
