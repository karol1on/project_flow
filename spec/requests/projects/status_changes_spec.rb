# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects::StatusChanges", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  before do
    sign_in(user, scope: :user)
    create(:project_membership, user:, project:, role: "manager")
  end

  describe "POST /projects/:project_id/status_changes" do
    subject { post project_status_changes_path(project), params:, headers: }

    context "with valid parameters" do
      let(:params) do
        {
          status_change_form: {
            to_status: "in_progress"
          }
        }
      end

      it "creates a new status change" do
        expect { subject }.to change(StatusChange, :count).by(1)
      end

      it "updates the project status" do
        expect { subject }.to change { project.reload.status }.from("not_started").to("in_progress")
      end

      it "returns success status" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
        expect(response.body).to include("turbo-stream")
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          status_change_form: { to_status: "invalid_status" }
        }
      end

      it "does not create a new status change" do
        expect { subject }.not_to change(StatusChange, :count)
      end

      it "does not update the project status" do
        expect { subject }.not_to change { project.reload.status }.from("not_started")
      end

      it "returns unprocessable entity status" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages" do
        subject
        expect(response.parsed_body).to have_key("errors")
      end
    end

    context "when user is not a project manager" do
      before do
        ProjectMembership.where(user:, project:).destroy_all
      end

      let(:params) { {} }

      it "returns unauthorized status" do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
