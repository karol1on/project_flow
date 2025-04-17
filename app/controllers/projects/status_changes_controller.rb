# frozen_string_literal: true

module Projects
  class StatusChangesController < ApplicationController
    include ProjectAuthorization

    before_action :set_project
    before_action :authorize_project_manager!

    def create
      result = Conversation::ChangeStatus.call(
        user: current_user,
        project: @project,
        params: status_change_params
      )

      if result.success?
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update(
              "status_change_form",
              partial: "projects/status_change_form",
              locals: { project: @project, status_change_form: StatusChangeForm.new }
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

    def status_change_params
      params.expect(status_change_form: [:to_status])
    end
  end

  # class User < ApplicationRecord
  #   has_many :conversation_items
  #   has_many :comments
  #   has_many :status_changes

  #   validates :email, presence: true, uniqueness: true
  #   validates :name, presence: true
  # end
end
