# frozen_string_literal: true

class ProjectsController < ApplicationController
  include ProjectAuthorization

  before_action :set_project, except: %i[index new create]
  before_action :authorize_project_member!, except: %i[index new create]

  def index
    @projects = if current_user.admin?
                  Project.all
                else
                  current_user.projects
                end
  end

  def show
    @comment_form = CommentForm.new
    @status_change_form = StatusChangeForm.new if current_user.project_manager?(@project)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @project.add_member(current_user, role: "manager")
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(%i[name status])
  end
end
