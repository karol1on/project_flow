# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  before { sign_in(user, scope: :user) }

  describe "GET /projects" do
    subject { get projects_path }

    it "returns a successful response" do
      subject
      expect(response).to be_successful
    end

    context "when user is an admin" do
      before do
        user.update(role: "admin")
      end

      let!(:projects) { create_list(:project, 3) }

      it "shows all projects" do
        subject
        projects.each do |project|
          expect(response.body).to include(project.name)
        end
      end
    end

    context "when user is a regular member" do
      before do
        create(:project_membership, user:, project:)
        create(:project) # Create another project that user is not a member of
      end

      it "shows only user's projects" do
        subject
        expect(response.body).to include(project.name)
        expect(response.body).not_to include("Project 2")
      end
    end
  end

  describe "GET /projects/:id" do
    subject { get project_path(project) }

    context "when user is a project member" do
      before { create(:project_membership, user:, project:) }

      it "returns a successful response" do
        subject
        expect(response).to be_successful
      end

      it "shows the project details" do
        subject
        expect(response.body).to include(project.name)
      end

      context "when user is a regular member" do
        it "does not show the status change form" do
          subject
          expect(response.body).not_to include("status_change_form")
        end
      end
    end

    context "when user is a project manager" do
      before { create(:project_membership, user:, project:, role: "manager") }

      it "shows the status change form" do
        subject
        expect(response.body).to include("status_change_form")
      end
    end

    context "when user is not a project member" do
      it "redirects to projects path" do
        subject
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe "GET /projects/new" do
    subject { get new_project_path }

    it "returns a successful response" do
      subject
      expect(response).to be_successful
    end

    it "shows the new project form" do
      subject
      expect(response.body).to include("New Project")
    end
  end

  describe "POST /projects" do
    subject { post projects_path, params: }

    context "with valid parameters" do
      let(:params) { { project: { name: "New Project", status: "not_started" } } }

      it "creates a new project" do
        expect { subject }.to change(Project, :count).by(1)
      end

      it "adds the current user as a manager" do
        expect { subject }.to change(ProjectMembership, :count).by(1)
        expect(ProjectMembership.last.role).to eq("manager")
      end

      it "redirects to the created project" do
        subject
        expect(response).to redirect_to(Project.last)
      end
    end

    context "with invalid parameters" do
      let(:params) { { project: { name: "" } } }

      it "does not create a new project" do
        expect { subject }.not_to change(Project, :count)
      end

      it "renders the new template" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("New Project")
      end
    end
  end
end
