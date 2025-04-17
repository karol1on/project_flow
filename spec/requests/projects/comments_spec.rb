# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Projects::Comments", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  before do
    sign_in(user, scope: :user)
    create(:project_membership, user:, project:)
  end

  describe "POST /projects/:project_id/comments" do
    subject { post project_comments_path(project), params:, headers: }

    context "with valid parameters" do
      let(:params) do
        {
          comment_form: {
            content: "Test comment",
            attachments: []
          }
        }
      end

      it "creates a new comment" do
        expect { subject }.to change(Comment, :count).by(1)
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
          comment_form: { content: "" }
        }
      end

      it "does not create a new comment" do
        expect { subject }.not_to change(Comment, :count)
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

    context "when user is not a project member" do
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
