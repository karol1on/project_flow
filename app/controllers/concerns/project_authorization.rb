# frozen_string_literal: true

module ProjectAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authorize_project_member!
    return if current_user.project_member?(@project)

    respond_to do |format|
      format.turbo_stream { head :unauthorized }
      format.html do
        flash[:alert] = "You don't have access to this project"
        redirect_to projects_path
      end
    end
  end

  def authorize_project_manager!
    return if current_user.project_manager?(@project)

    respond_to do |format|
      format.turbo_stream { head :unauthorized }
      format.html do
        flash[:alert] = "You must be a project manager to perform this action"
        redirect_to project_path(@project)
      end
    end
  end
end
